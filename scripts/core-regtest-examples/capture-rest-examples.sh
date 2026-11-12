#!/usr/bin/env bash
#
# capture-rest-examples.sh
#
# Start a fresh, isolated Dash Core regtest node, build a small deterministic
# chain and mempool, and capture the response of every REST endpoint shown on
# docs/core/api/http-rest-requests.md into OUT_DIR.
#
# Usage:
#   DASH_BIN=/path/to/dash/src ./capture-rest-examples.sh
#
# Overrides (environment variables):
#   DASH_BIN   Directory containing dashd and dash-cli (required)
#   OUT_DIR    Where to write captured responses (default: new temp dir)
#   DATADIR    Node data directory; must be empty or not exist
#              (default: new temp dir, removed on exit)
#   P2P_PORT   P2P port (default: 26661; the node runs with -listen=0)
#   RPC_PORT   RPC/REST port (default: 26662)
#   KEEP_DATADIR=1  Keep DATADIR after the run (default: remove a temp DATADIR)
#
# The default ports differ from the standard regtest ports (19899/19898) so the
# script can run next to a normal regtest node. Docs show the standard regtest
# RPC port (19898); see manifest.tsv in OUT_DIR for the docs-form URLs.
#
# Dependencies: bash, curl, python3 (for JSON pretty-printing).
#
set -euo pipefail

# ---- Config ------------------------------------------------------------------
: "${DASH_BIN:?set DASH_BIN to the directory containing dashd and dash-cli}"
DASHD="$DASH_BIN/dashd"
CLI_BIN="$DASH_BIN/dash-cli"
OUT_DIR="${OUT_DIR:-$(mktemp -d -t dash-rest-examples.XXXXXX)}"
P2P_PORT="${P2P_PORT:-26661}"
RPC_PORT="${RPC_PORT:-26662}"
DOCS_PORT=19898 # default regtest RPC port, used in URLs shown in the docs

# Chain layout. Changing any of these changes every hash in the output.
MOCKTIME_START=1767225600 # 2026-01-01T00:00:00Z, time of block 1
BLOCK_SPACING=150         # seconds between blocks (regtest target spacing)
PRE_TX_HEIGHT=605         # mine this many blocks before the confirmed tx
TX_BLOCK_HEIGHT=606       # block containing the confirmed tx
TIP_HEIGHT=610            # final chain height
FEE=0.00001000            # fee paid by each example transaction

# Fixed regtest-only keys (sha256 of a label). NEVER use these on mainnet or
# testnet; anyone can spend from them.
#   miner:     sha256("dash-docs regtest miner")
#   recipient: sha256("dash-docs regtest recipient")
MINER_WIF="cMvdAragzPXRBtuZ1bLqYP3gSMmYddKyXPA24hxjRSChpd7hk9JV"
RECIPIENT_WIF="cV9kJvtL6meiN894K6Db7QaQp2q6KUr3UBZkriRVEkXVkautjgfR"
# ------------------------------------------------------------------------------

for bin in "$DASHD" "$CLI_BIN"; do
  if [[ ! -x "$bin" ]]; then
    echo "error: not found or not executable: $bin" >&2
    exit 1
  fi
done
for tool in curl python3; do
  command -v "$tool" >/dev/null || { echo "error: $tool is required" >&2; exit 1; }
done

TEMP_DATADIR=0
if [[ -z "${DATADIR:-}" ]]; then
  DATADIR="$(mktemp -d -t dash-rest-datadir.XXXXXX)"
  TEMP_DATADIR=1
elif [[ -e "$DATADIR" && -n "$(ls -A "$DATADIR")" ]]; then
  echo "error: DATADIR must be empty or not exist: $DATADIR" >&2
  exit 1
fi
mkdir -p "$DATADIR" "$OUT_DIR"

cli() {
  "$CLI_BIN" -regtest -datadir="$DATADIR" -rpcport="$RPC_PORT" "$@"
}

NODE_STARTED=0
cleanup() {
  if [[ "$NODE_STARTED" == 1 ]]; then
    cli stop >/dev/null 2>&1 || true
    # Wait for dashd to exit so the datadir can be removed safely
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

# Pretty-print JSON with 2-space indentation, keeping numbers exactly as the
# node wrote them (e.g. 0.00001000 stays 0.00001000).
pretty_json() {
  python3 -c '
import json, sys

class Num(str):
    pass

def dump(o, ind=0):
    pad, pad2 = "  " * ind, "  " * (ind + 1)
    if isinstance(o, dict):
        if not o:
            return "{}"
        items = [pad2 + json.dumps(k) + ": " + dump(v, ind + 1) for k, v in o.items()]
        return "{\n" + ",\n".join(items) + "\n" + pad + "}"
    if isinstance(o, list):
        if not o:
            return "[]"
        return "[\n" + ",\n".join(pad2 + dump(v, ind + 1) for v in o) + "\n" + pad + "]"
    if isinstance(o, Num):
        return str(o)
    return json.dumps(o)

data = json.loads(sys.stdin.read(), parse_float=Num, parse_int=Num)
print(dump(data))
'
}

# Wrap hex at 64 characters with a trailing backslash, as the docs show it.
wrap_hex() {
  tr -d '\n' | fold -w 64 | sed '$!s/$/\\/'
  echo
}

printf 'file\thttp_status\tdocs_url\n' > "$OUT_DIR/manifest.tsv"

# rest <name> <path> - GET /rest/<path> and save the body to OUT_DIR/<name>
rest() {
  local name="$1" path="$2" status
  status="$(curl -sS -o "$OUT_DIR/$name" -w '%{http_code}' \
    "http://127.0.0.1:${RPC_PORT}/rest/${path}")"
  printf '%s\t%s\t%s\n' "$name" "$status" \
    "http://localhost:${DOCS_PORT}/rest/${path}" >> "$OUT_DIR/manifest.tsv"
  case "$name" in
    *.json) [[ "$status" == 200 ]] && pretty_json < "$OUT_DIR/$name" > "$OUT_DIR/${name%.json}.pretty.json" ;;
    *.hex)  [[ "$status" == 200 ]] && wrap_hex < "$OUT_DIR/$name" > "$OUT_DIR/${name%.hex}.wrapped.txt" ;;
  esac
  return 0
}

# ---- Start node --------------------------------------------------------------
"$DASHD" -version | head -n 1 > "$OUT_DIR/version.txt"
echo "dashd: $(cat "$OUT_DIR/version.txt")"
echo "datadir: $DATADIR"
echo "output: $OUT_DIR"

"$DASHD" -regtest -datadir="$DATADIR" -daemonwait \
  -port="$P2P_PORT" -rpcport="$RPC_PORT" -listen=0 -server -rest -txindex \
  -disablewallet -mocktime="$MOCKTIME_START" -debug=0 >/dev/null
NODE_STARTED=1
cli -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null

# ---- Keys and addresses (no wallet needed) -----------------------------------
desc_info() { cli getdescriptorinfo "pkh($1)"; }
# json_get <key-or-index>... - read JSON on stdin and print the selected value
json_get() {
  python3 -c '
import json, sys
d = json.load(sys.stdin)
for k in sys.argv[1:]:
    d = d[int(k)] if isinstance(d, list) else d[k]
print(d)
' "$@"
}
MINER_DESC="$(desc_info "$MINER_WIF" | json_get descriptor)"
RECIPIENT_DESC="$(desc_info "$RECIPIENT_WIF" | json_get descriptor)"
MINER_ADDR="$(cli deriveaddresses "$MINER_DESC" | json_get 0)"
RECIPIENT_ADDR="$(cli deriveaddresses "$RECIPIENT_DESC" | json_get 0)"

# mine <count> - mine blocks one at a time, advancing mocktime by BLOCK_SPACING
mine() {
  local i height
  for ((i = 0; i < $1; i++)); do
    height="$(cli getblockcount)"
    cli setmocktime $((MOCKTIME_START + height * BLOCK_SPACING))
    cli generatetoaddress 1 "$MINER_ADDR" >/dev/null
  done
}

# spend <txid> <vout> <recipient_amount> - pay recipient, change to miner;
# prints the TXID. Runs inside $(...), where set -e does not apply, so each
# step checks for failure explicitly.
spend() {
  local txid="$1" vout="$2" amount="$3" value change raw signed
  value="$(cli gettxout "$txid" "$vout" true | json_get value)" || return 1
  change="$(python3 -c 'from decimal import Decimal as D; import sys; print(D(sys.argv[1]) - D(sys.argv[2]) - D(sys.argv[3]))' "$value" "$amount" "$FEE")" || return 1
  raw="$(cli createrawtransaction "[{\"txid\":\"$txid\",\"vout\":$vout}]" \
    "{\"$RECIPIENT_ADDR\":$amount,\"$MINER_ADDR\":$change}")" || return 1
  signed="$(cli signrawtransactionwithkey "$raw" "[\"$MINER_WIF\"]" | json_get hex)" || return 1
  cli sendrawtransaction "$signed"
}

coinbase_txid() { cli getblock "$(cli getblockhash "$1")" 1 | json_get tx 0; }

# ---- Build chain -------------------------------------------------------------
echo "mining $PRE_TX_HEIGHT blocks..."
mine "$PRE_TX_HEIGHT"

# Confirmed transaction: spend the block 1 coinbase, mined in TX_BLOCK_HEIGHT
CONFIRMED_TXID="$(spend "$(coinbase_txid 1)" 0 10.00000000)"
mine $((TX_BLOCK_HEIGHT - PRE_TX_HEIGHT))
mine $((TIP_HEIGHT - TX_BLOCK_HEIGHT))

# Mempool: a parent spending the block 2 coinbase, and a child spending the
# parent's change output (so depends/spentby are populated)
cli setmocktime $((MOCKTIME_START + TIP_HEIGHT * BLOCK_SPACING))
MEMPOOL_PARENT_TXID="$(spend "$(coinbase_txid 2)" 0 5.00000000)"
MEMPOOL_CHILD_TXID="$(spend "$MEMPOOL_PARENT_TXID" 1 1.00000000)"

TX_BLOCK_HASH="$(cli getblockhash "$TX_BLOCK_HEIGHT")"
if [[ "$(cli getblock "$TX_BLOCK_HASH" 1 | json_get tx 1)" != "$CONFIRMED_TXID" ]]; then
  echo "error: confirmed transaction is not in block $TX_BLOCK_HEIGHT" >&2
  exit 1
fi

cat > "$OUT_DIR/context.txt" <<EOF
miner_address=$MINER_ADDR
recipient_address=$RECIPIENT_ADDR
tip_height=$(cli getblockcount)
tip_hash=$(cli getbestblockhash)
tx_block_height=$TX_BLOCK_HEIGHT
tx_block_hash=$TX_BLOCK_HASH
confirmed_txid=$CONFIRMED_TXID
mempool_parent_txid=$MEMPOOL_PARENT_TXID
mempool_child_txid=$MEMPOOL_CHILD_TXID
EOF

# ---- Capture REST responses --------------------------------------------------
echo "capturing REST responses..."

# GET Block
rest block.hex  "block/${TX_BLOCK_HASH}.hex"
rest block.json "block/${TX_BLOCK_HASH}.json"

# GET Block/NoTxDetails
rest block-notxdetails.hex  "block/notxdetails/${TX_BLOCK_HASH}.hex"
rest block-notxdetails.json "block/notxdetails/${TX_BLOCK_HASH}.json"

# GET BlockHashByHeight
rest blockhashbyheight.hex  "blockhashbyheight/${TX_BLOCK_HEIGHT}.hex"
rest blockhashbyheight.json "blockhashbyheight/${TX_BLOCK_HEIGHT}.json"

# GET ChainInfo
rest chaininfo.json "chaininfo.json"

# GET DeploymentInfo
rest deploymentinfo.json       "deploymentinfo.json"
rest deploymentinfo-block.json "deploymentinfo/${TX_BLOCK_HASH}.json"

# GET GetUtxos: a confirmed output and an unconfirmed (mempool) output
UTXO_PATH="checkmempool/${CONFIRMED_TXID}-0/${MEMPOOL_PARENT_TXID}-0"
rest getutxos.hex  "getutxos/${UTXO_PATH}.hex"
rest getutxos.json "getutxos/${UTXO_PATH}.json"

# GET Headers (deprecated /headers/<count>/<hash> form, still served by v24)
rest headers.hex  "headers/2/${TX_BLOCK_HASH}.hex"
rest headers.json "headers/2/${TX_BLOCK_HASH}.json"

# GET MemPool/Contents
rest mempool-contents.json                "mempool/contents.json"
rest mempool-contents-txids.json          "mempool/contents.json?verbose=false"
rest mempool-contents-txids-sequence.json "mempool/contents.json?verbose=false&mempool_sequence=true"

# GET MemPool/Info
rest mempool-info.json "mempool/info.json"

# GET Tx
rest tx.hex  "tx/${CONFIRMED_TXID}.hex"
rest tx.json "tx/${CONFIRMED_TXID}.json"

# Error cases (some are documented on the page)
rest error-block-invalid-hash.txt      "block/nothex.json"
rest error-deploymentinfo-notfound.txt "deploymentinfo/$(printf '0%.0s' {1..64}).json"
rest error-headers-count.txt           "headers/0/${TX_BLOCK_HASH}.json"
rest error-mempool-verbose.txt         "mempool/contents.json?verbose=maybe"
rest error-mempool-sequence.txt        "mempool/contents.json?mempool_sequence=true"
rest error-chaininfo-format.txt        "chaininfo.hex"

echo "done: $(($(wc -l < "$OUT_DIR/manifest.tsv") - 1)) responses written to $OUT_DIR"
