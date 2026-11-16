#!/usr/bin/env bash
#
# run-transaction-tutorials.sh
#
# Start a fresh, isolated Dash Core regtest node and run the transaction
# tutorials in docs/core/examples/ end to end, in order, using the same
# commands the pages show:
#
#   transaction-tutorial.md (setup), transaction-tutorial-simple-spending.md,
#   transaction-tutorial-simple-raw-transaction.md,
#   transaction-tutorial-complex-raw-transaction.md,
#   transaction-tutorial-offline-signing.md,
#   transaction-tutorial-p2sh-multisig.md
#
# Each command's output is written to a numbered file in OUT_DIR, followed by
# an "exit=<status>" line. Only 46-os-send-5a.txt (offline signing step 5a) is
# expected to fail.
#
# Unlike capture-rest-examples.sh, the output is not deterministic: the wallet
# generates new keys on every run, so addresses, keys, and TXIDs differ.
#
# Usage:
#   DASH_BIN=/path/to/dash/src ./run-transaction-tutorials.sh
#
# Overrides (environment variables):
#   DASH_BIN   Directory containing dashd and dash-cli (required)
#   OUT_DIR    Where to write command output (default: new temp dir)
#   DATADIR    Node data directory; must be empty or not exist
#              (default: new temp dir, removed on exit)
#   P2P_PORT   P2P port (default: 26671; the node runs with -listen=0)
#   RPC_PORT   RPC port (default: 26672)
#   KEEP_DATADIR=1  Keep DATADIR after the run (default: remove a temp DATADIR)
#
# Dependencies: bash, python3. The tutorials need a legacy wallet, so dashd
# must be built with Berkeley DB support (release binaries are).
#
set -euo pipefail

# ---- Config ------------------------------------------------------------------
: "${DASH_BIN:?set DASH_BIN to the directory containing dashd and dash-cli}"
DASHD="$DASH_BIN/dashd"
CLI_BIN="$DASH_BIN/dash-cli"
OUT_DIR="${OUT_DIR:-$(mktemp -d -t dash-tutorial-examples.XXXXXX)}"
P2P_PORT="${P2P_PORT:-26671}"
RPC_PORT="${RPC_PORT:-26672}"
# ------------------------------------------------------------------------------

for bin in "$DASHD" "$CLI_BIN"; do
  if [[ ! -x "$bin" ]]; then
    echo "error: not found or not executable: $bin" >&2
    exit 1
  fi
done
command -v python3 >/dev/null || { echo "error: python3 is required" >&2; exit 1; }

TEMP_DATADIR=0
if [[ -z "${DATADIR:-}" ]]; then
  DATADIR="$(mktemp -d -t dash-tutorial-datadir.XXXXXX)"
  TEMP_DATADIR=1
elif [[ -e "$DATADIR" && -n "$(ls -A "$DATADIR")" ]]; then
  echo "error: DATADIR must be empty or not exist: $DATADIR" >&2
  exit 1
fi
mkdir -p "$DATADIR" "$OUT_DIR"

# The pages run `dash-cli -regtest ...`; this adds the isolated datadir and port
dash_cli() {
  "$CLI_BIN" -datadir="$DATADIR" -rpcport="$RPC_PORT" "$@"
}

NODE_STARTED=0
cleanup() {
  if [[ "$NODE_STARTED" == 1 ]]; then
    dash_cli -regtest stop >/dev/null 2>&1 || true
    for _ in $(seq 1 60); do
      [[ -f "$DATADIR/regtest/dashd.pid" ]] || break
      sleep 0.5
    done
    if [[ -f "$DATADIR/regtest/dashd.pid" ]]; then
      echo "warning: dashd did not stop; leaving datadir $DATADIR in place" >&2
      return
    fi
  fi
  if [[ "$TEMP_DATADIR" == 1 && "${KEEP_DATADIR:-0}" != 1 ]]; then
    rm -rf "$DATADIR"
  fi
}
trap cleanup EXIT

# log <file> <command...> - run a command, save its output and exit status
log() {
  local file="$1" status=0
  shift
  "$@" > "$OUT_DIR/$file" 2>&1 || status=$?
  echo "exit=$status" >> "$OUT_DIR/$file"
}

# result <file> - print a saved output without its exit line
result() { sed '$d' "$OUT_DIR/$1"; }

# json_get <python-expression> - evaluate an expression over JSON `d` on stdin
json_get() {
  python3 -c 'import json, sys; d = json.load(sys.stdin); print(eval(sys.argv[1]))' "$1"
}

"$DASHD" -version | head -n 1 > "$OUT_DIR/version.txt"
echo "dashd: $(cat "$OUT_DIR/version.txt")"
echo "datadir: $DATADIR"
echo "output: $OUT_DIR"

"$DASHD" -regtest -datadir="$DATADIR" -daemonwait \
  -port="$P2P_PORT" -rpcport="$RPC_PORT" -listen=0 >/dev/null
NODE_STARTED=1
dash_cli -regtest -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null

# ---- Setup (transaction-tutorial.md, testing-applications.md) ---------------
log 01-createwallet.txt dash_cli -regtest -named createwallet wallet_name=tutorial descriptors=false load_on_startup=true
log 02-generate101.txt dash_cli -regtest -generate 101
log 03-getbalance.txt dash_cli -regtest getbalance

# ---- Simple spending ---------------------------------------------------------
NEW_ADDRESS=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS" > "$OUT_DIR/10-ss-newaddress.txt"
log 11-ss-sendtoaddress.txt dash_cli -regtest sendtoaddress "$NEW_ADDRESS" 10.00
log 12-ss-listunspent.txt dash_cli -regtest listunspent
log 13-ss-listunspent0.txt dash_cli -regtest listunspent 0
log 14-ss-generate1.txt dash_cli -regtest -generate 1
unset NEW_ADDRESS

# ---- Simple raw transaction --------------------------------------------------
log 20-sr-listunspent.txt dash_cli -regtest listunspent
# The coinbase UTXO from block 2
UTXO_TXID=$(dash_cli -regtest getblock "$(dash_cli -regtest getblockhash 2)" | json_get 'd["tx"][0]')
UTXO_VOUT=0
NEW_ADDRESS=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS" > "$OUT_DIR/21-sr-newaddress.txt"
RAW_TX=$(dash_cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS'": 499.9999
    }''')
echo "$RAW_TX" > "$OUT_DIR/22-sr-rawtx.txt"
log 23-sr-decode.txt dash_cli -regtest decoderawtransaction "$RAW_TX"
log 24-sr-sign.txt dash_cli -regtest signrawtransactionwithwallet "$RAW_TX"
SIGNED_RAW_TX=$(result 24-sr-sign.txt | json_get 'd["hex"]')
log 25-sr-send.txt dash_cli -regtest sendrawtransaction "$SIGNED_RAW_TX"
log 26-sr-generate1.txt dash_cli -regtest -generate 1
unset UTXO_TXID UTXO_VOUT NEW_ADDRESS RAW_TX SIGNED_RAW_TX

# ---- Complex raw transaction -------------------------------------------------
log 30-cr-listunspent.txt dash_cli -regtest listunspent
# UTXO 1: the coinbase from block 3. UTXO 2: the 10 DASH simple spending output
UTXO1_TXID=$(dash_cli -regtest getblock "$(dash_cli -regtest getblockhash 3)" | json_get 'd["tx"][0]')
UTXO1_VOUT=0
UTXO1_ADDRESS=$(result 30-cr-listunspent.txt | json_get '[u["address"] for u in d if u["txid"] == "'"$UTXO1_TXID"'"][0]')
read -r UTXO2_TXID UTXO2_VOUT UTXO2_ADDRESS < <(result 30-cr-listunspent.txt | json_get '" ".join([(u["txid"], str(u["vout"]), u["address"]) for u in d if u["amount"] == 10][0])')
echo "$UTXO1_TXID $UTXO1_VOUT $UTXO1_ADDRESS $UTXO2_TXID $UTXO2_VOUT $UTXO2_ADDRESS" > "$OUT_DIR/31-cr-utxos.txt"
log 32-cr-dumpprivkey1.txt dash_cli -regtest dumpprivkey "$UTXO1_ADDRESS"
log 33-cr-dumpprivkey2.txt dash_cli -regtest dumpprivkey "$UTXO2_ADDRESS"
UTXO1_PRIVATE_KEY=$(result 32-cr-dumpprivkey1.txt)
UTXO2_PRIVATE_KEY=$(result 33-cr-dumpprivkey2.txt)
NEW_ADDRESS1=$(dash_cli -regtest getnewaddress)
NEW_ADDRESS2=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS1 $NEW_ADDRESS2" > "$OUT_DIR/34-cr-newaddresses.txt"
RAW_TX=$(dash_cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO1_TXID'",
        "vout": '$UTXO1_VOUT'
      },
      {
        "txid": "'$UTXO2_TXID'",
        "vout": '$UTXO2_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS1'": 499.9999,
      "'$NEW_ADDRESS2'": 10
    }''')
echo "$RAW_TX" > "$OUT_DIR/35-cr-rawtx.txt"
log 36-cr-sign1.txt dash_cli -regtest signrawtransactionwithkey "$RAW_TX" '''
    [
      "'$UTXO1_PRIVATE_KEY'"
    ]'''
PARTLY_SIGNED_RAW_TX=$(result 36-cr-sign1.txt | json_get 'd["hex"]')
log 37-cr-sign2.txt dash_cli -regtest signrawtransactionwithkey "$PARTLY_SIGNED_RAW_TX" '''
    [
      "'$UTXO2_PRIVATE_KEY'"
    ]'''
# Not sent: the offline signing tutorial spends it
OLD_SIGNED_RAW_TX=$(result 37-cr-sign2.txt | json_get 'd["hex"]')
unset PARTLY_SIGNED_RAW_TX RAW_TX NEW_ADDRESS1 NEW_ADDRESS2 UTXO1_TXID UTXO1_VOUT UTXO1_ADDRESS \
  UTXO2_TXID UTXO2_VOUT UTXO2_ADDRESS UTXO1_PRIVATE_KEY UTXO2_PRIVATE_KEY

# ---- Offline signing ---------------------------------------------------------
echo "$OLD_SIGNED_RAW_TX" > "$OUT_DIR/40-os-old-signed-rawtx.txt"
log 41-os-decode.txt dash_cli -regtest decoderawtransaction "$OLD_SIGNED_RAW_TX"
UTXO_TXID=$(result 41-os-decode.txt | json_get 'd["txid"]')
UTXO_VOUT=1
UTXO_OUTPUT_SCRIPT=$(result 41-os-decode.txt | json_get 'd["vout"][1]["scriptPubKey"]["hex"]')
NEW_ADDRESS=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS" > "$OUT_DIR/42-os-newaddress.txt"
RAW_TX=$(dash_cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS'": 9.9999
    }''')
echo "$RAW_TX" > "$OUT_DIR/43-os-rawtx.txt"
log 44-os-sign-4a.txt dash_cli -regtest signrawtransactionwithwallet "$RAW_TX"
log 45-os-sign-4b.txt dash_cli -regtest signrawtransactionwithwallet "$RAW_TX" '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'"
      }
    ]'''
SIGNED_RAW_TX=$(result 45-os-sign-4b.txt | json_get 'd["hex"]')
log 46-os-send-5a.txt dash_cli -regtest sendrawtransaction "$SIGNED_RAW_TX"
log 47-os-send-5b-first.txt dash_cli -regtest sendrawtransaction "$OLD_SIGNED_RAW_TX"
log 48-os-send-5b-second.txt dash_cli -regtest sendrawtransaction "$SIGNED_RAW_TX"
log 49-os-getrawmempool.txt dash_cli -regtest getrawmempool
unset OLD_SIGNED_RAW_TX SIGNED_RAW_TX RAW_TX UTXO_TXID UTXO_VOUT UTXO_OUTPUT_SCRIPT NEW_ADDRESS

# ---- P2SH multisig -----------------------------------------------------------
NEW_ADDRESS1=$(dash_cli -regtest getnewaddress)
NEW_ADDRESS2=$(dash_cli -regtest getnewaddress)
NEW_ADDRESS3=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS1 $NEW_ADDRESS2 $NEW_ADDRESS3" > "$OUT_DIR/50-ms-newaddresses.txt"
log 51-ms-getaddressinfo3.txt dash_cli -regtest getaddressinfo "$NEW_ADDRESS3"
NEW_ADDRESS1_PUBLIC_KEY=$(dash_cli -regtest getaddressinfo "$NEW_ADDRESS1" | json_get 'd["pubkey"]')
NEW_ADDRESS2_PUBLIC_KEY=$(dash_cli -regtest getaddressinfo "$NEW_ADDRESS2" | json_get 'd["pubkey"]')
NEW_ADDRESS3_PUBLIC_KEY=$(result 51-ms-getaddressinfo3.txt | json_get 'd["pubkey"]')
log 52-ms-createmultisig.txt dash_cli -regtest createmultisig 2 '''
    [
      "'$NEW_ADDRESS1_PUBLIC_KEY'",
      "'$NEW_ADDRESS2_PUBLIC_KEY'",
      "'$NEW_ADDRESS3_PUBLIC_KEY'"
    ]'''
P2SH_ADDRESS=$(result 52-ms-createmultisig.txt | json_get 'd["address"]')
P2SH_REDEEM_SCRIPT=$(result 52-ms-createmultisig.txt | json_get 'd["redeemScript"]')
log 53-ms-sendtoaddress.txt dash_cli -regtest sendtoaddress "$P2SH_ADDRESS" 10.00
UTXO_TXID=$(result 53-ms-sendtoaddress.txt)
log 54-ms-getrawtransaction.txt dash_cli -regtest getrawtransaction "$UTXO_TXID" 1
# The output that pays the multisig address
read -r UTXO_VOUT UTXO_OUTPUT_SCRIPT < <(result 54-ms-getrawtransaction.txt | json_get '" ".join([(str(v["n"]), v["scriptPubKey"]["hex"]) for v in d["vout"] if v["scriptPubKey"].get("address") == "'"$P2SH_ADDRESS"'"][0])')
echo "$UTXO_VOUT $UTXO_OUTPUT_SCRIPT" > "$OUT_DIR/55-ms-utxo.txt"
NEW_ADDRESS4=$(dash_cli -regtest getnewaddress)
echo "$NEW_ADDRESS4" > "$OUT_DIR/56-ms-newaddress4.txt"
RAW_TX=$(dash_cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT'
      }
   ]
   ''' '''
   {
     "'$NEW_ADDRESS4'": 9.998
   }''')
echo "$RAW_TX" > "$OUT_DIR/57-ms-rawtx.txt"
log 58-ms-dumpprivkey1.txt dash_cli -regtest dumpprivkey "$NEW_ADDRESS1"
log 59-ms-dumpprivkey3.txt dash_cli -regtest dumpprivkey "$NEW_ADDRESS3"
NEW_ADDRESS1_PRIVATE_KEY=$(result 58-ms-dumpprivkey1.txt)
NEW_ADDRESS3_PRIVATE_KEY=$(result 59-ms-dumpprivkey3.txt)
log 60-ms-sign1.txt dash_cli -regtest signrawtransactionwithkey "$RAW_TX" '''
    [
      "'$NEW_ADDRESS1_PRIVATE_KEY'"
    ]''' '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'",
        "redeemScript": "'$P2SH_REDEEM_SCRIPT'"
      }
    ]
    '''
PARTLY_SIGNED_RAW_TX=$(result 60-ms-sign1.txt | json_get 'd["hex"]')
log 61-ms-sign3.txt dash_cli -regtest signrawtransactionwithkey "$PARTLY_SIGNED_RAW_TX" '''
    [
      "'$NEW_ADDRESS3_PRIVATE_KEY'"
    ]''' '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'",
        "redeemScript": "'$P2SH_REDEEM_SCRIPT'"
      }
    ]
    '''
SIGNED_RAW_TX=$(result 61-ms-sign3.txt | json_get 'd["hex"]')
log 62-ms-send.txt dash_cli -regtest sendrawtransaction "$SIGNED_RAW_TX"

# ---- Check results -----------------------------------------------------------
failed=()
for f in "$OUT_DIR"/[0-9]*.txt; do
  name="$(basename "$f")"
  [[ "$name" == 46-os-send-5a.txt ]] && continue
  if grep -q '^exit=[1-9]' "$f"; then failed+=("$name"); fi
done
if ! grep -q '^exit=[1-9]' "$OUT_DIR/46-os-send-5a.txt"; then
  failed+=("46-os-send-5a.txt (expected to fail)")
fi
if (( ${#failed[@]} )); then
  echo "error: unexpected results in: ${failed[*]}" >&2
  exit 1
fi
echo "done: all tutorial steps behaved as expected; output in $OUT_DIR"
