#!/usr/bin/env bash
#
# capture-multisig-example.sh
#
# Start a fresh, isolated Dash Core regtest node and run the 2-of-3 multisig
# example from the Multisignature section of
# docs/user/wallets/dashcore/advanced.rst, using the same commands the page
# shows. The seller, buyer, and arbiter are three descriptor wallets on the
# same node, and a fourth wallet mines the blocks.
#
# Output in OUT_DIR:
#   NN-<party>-<rpc>.txt  Each command and its output
#   multisig-example.rst  The page's literal blocks, in page order, formatted
#                         and trimmed the way the page shows them
#   version.txt           dashd -version first line
#
# Running the script twice with the same Dash Core build produces identical
# output. The wallets come from a fixed mnemonic, the node runs on mocktime,
# and the setup avoids the two random choices the wallet makes when it sends
# (see "Setup" below).
#
# Usage:
#   DASH_BIN=/path/to/dash/src ./capture-multisig-example.sh
#
# Overrides (environment variables):
#   DASH_BIN   Directory containing dashd and dash-cli (required)
#   OUT_DIR    Where to write command output (default: new temp dir)
#   DATADIR    Node data directory; must be empty or not exist
#              (default: new temp dir, removed on exit)
#   P2P_PORT   P2P port (default: 26681; the node runs with -listen=0)
#   RPC_PORT   RPC port (default: 26682)
#   KEEP_DATADIR=1  Keep DATADIR after the run (default: remove a temp DATADIR)
#
# Dependencies: bash, python3.
#
set -euo pipefail

# ---- Config ------------------------------------------------------------------
: "${DASH_BIN:?set DASH_BIN to the directory containing dashd and dash-cli}"
DASHD="$DASH_BIN/dashd"
CLI_BIN="$DASH_BIN/dash-cli"
OUT_DIR="${OUT_DIR:-$(mktemp -d -t dash-multisig-example.XXXXXX)}"
P2P_PORT="${P2P_PORT:-26681}"
RPC_PORT="${RPC_PORT:-26682}"

# Example layout. Changing any of these changes every hash in the output.
MOCKTIME_START=1767225600 # 2026-01-01T00:00:00Z, time of block 1
BLOCK_SPACING=150         # seconds between blocks (regtest target spacing)
# The BIP39 test mnemonic, also used by scripts/dash-qt-screenshots. Each
# wallet uses its name as the mnemonic passphrase, so each gets its own keys.
# Public, regtest-only keys: NEVER use these on mainnet or testnet.
MNEMONIC="abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
BUYER_UTXO=0.25000500 # the buyer's only coin: the payment plus a small fee
FUND_AMOUNT=0.25      # buyer pays this to the multisig address
SPEND_AMOUNT=0.249    # seller receives this; the difference is the fee
# ------------------------------------------------------------------------------

for bin in "$DASHD" "$CLI_BIN"; do
  if [[ ! -x "$bin" ]]; then
    echo "error: not found or not executable: $bin" >&2
    exit 1
  fi
done
command -v python3 >/dev/null || { echo "error: python3 is required" >&2; exit 1; }

if [[ -d "$OUT_DIR" && -n "$(find "$OUT_DIR" -maxdepth 1 -name '[0-9][0-9]-*.txt')" ]]; then
  echo "error: OUT_DIR already has output from an earlier run: $OUT_DIR" >&2
  exit 1
fi

TEMP_DATADIR=0
if [[ -z "${DATADIR:-}" ]]; then
  DATADIR="$(mktemp -d -t dash-multisig-datadir.XXXXXX)"
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

# json_get <python-expression> - evaluate an expression over JSON `d` on stdin
json_get() {
  python3 -c 'import json, sys; d = json.load(sys.stdin); print(eval(sys.argv[1]))' "$1"
}

# run <party> <rpc> [args...] - run an RPC in the party's wallet, save the
# command and its output to the next numbered file, and print the output.
# The first line of each file is the command as the page shows it, without
# the "<party>@dash:~$ ./dash-cli" prompt. Steps are numbered from the files
# already written, because run is often called in a subshell.
run() {
  local party="$1" step file
  shift
  step=$(find "$OUT_DIR" -maxdepth 1 -name '[0-9][0-9]-*.txt' | wc -l)
  file="$OUT_DIR/$(printf '%02d' $((step + 1)))-$party-$1.txt"
  python3 - "$@" > "$file" <<'EOF'
import sys
def quote(a):
    if a == "*":
        return '"*"'
    if a[:1] in "[{":
        return "'" + a + "'"
    return a
print(" ".join(quote(a) for a in sys.argv[1:]))
EOF
  cli -rpcwallet="$party" "$@" | tee -a "$file"
}

"$DASHD" -version | head -n 1 > "$OUT_DIR/version.txt"
echo "dashd: $(cat "$OUT_DIR/version.txt")"
echo "datadir: $DATADIR"
echo "output: $OUT_DIR"

MOCKTIME=$MOCKTIME_START
"$DASHD" -regtest -datadir="$DATADIR" -daemonwait -mocktime="$MOCKTIME" \
  -port="$P2P_PORT" -rpcport="$RPC_PORT" -listen=0 -connect=0 >/dev/null
NODE_STARTED=1
cli -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null

# ---- Setup (not shown on the page) -------------------------------------------
# The wallet makes two random choices when it sends: where the change output
# goes, and (on 1 in 10 sends) a locktime below the tip height. The buyer's
# sendtoaddress in step 3 avoids both: the buyer owns a single coin only
# slightly larger than the payment, so there is no change output, and the tip
# is more than 8 hours old when the buyer sends, so the wallet sets the
# locktime to 0 (DiscourageFeeSniping in src/wallet/spend.cpp).

# mine <count> - mine blocks to the miner wallet, BLOCK_SPACING seconds apart
mine() {
  for _ in $(seq 1 "$1"); do
    MOCKTIME=$((MOCKTIME + BLOCK_SPACING))
    cli setmocktime "$MOCKTIME"
    cli generatetoaddress 1 "$MINER_ADDR" >/dev/null
  done
}

for party in miner seller buyer arbiter; do
  cli -named createwallet wallet_name="$party" blank=true >/dev/null
  cli -rpcwallet="$party" upgradetohd "$MNEMONIC" "$party" >/dev/null
done
MINER_ADDR=$(cli -rpcwallet=miner getnewaddress)
mine 101 # the block 1 coinbase matures at height 101

# Pay the buyer's single coin from the block 1 coinbase. A raw transaction
# with fixed inputs, outputs, and locktime has no random parts.
COINBASE_TXID=$(cli getblock "$(cli getblockhash 1)" | json_get 'd["tx"][0]')
COINBASE_VALUE=$(cli getrawtransaction "$COINBASE_TXID" 1 | json_get 'd["vout"][0]["valueSat"]')
MINER_CHANGE=$(python3 -c 'import sys; from decimal import Decimal as D; print(D(sys.argv[1]) / 100000000 - D(sys.argv[2]) - D("0.00001"))' "$COINBASE_VALUE" "$BUYER_UTXO")
SETUP_TX=$(cli createrawtransaction "[{\"txid\":\"$COINBASE_TXID\",\"vout\":0}]" \
  "{\"$(cli -rpcwallet=buyer getrawchangeaddress)\":$BUYER_UTXO,\"$(cli -rpcwallet=miner getrawchangeaddress)\":$MINER_CHANGE}")
SETUP_TX=$(cli -rpcwallet=miner signrawtransactionwithwallet "$SETUP_TX" | json_get 'd["hex"]')
cli sendrawtransaction "$SETUP_TX" >/dev/null
mine 1

# Let the tip age past 8 hours (see above). Steps 1-3 run at this time.
MOCKTIME=$((MOCKTIME + 9 * 60 * 60))
cli setmocktime "$MOCKTIME"

# ---- Step 1: Create three addresses ------------------------------------------
declare -A ADDR PUBKEY
for party in seller buyer arbiter; do
  ADDR[$party]=$(run "$party" getnewaddress "$party")
  PUBKEY[$party]=$(run "$party" getaddressinfo "${ADDR[$party]}" | json_get 'd["pubkey"]')
done

# ---- Step 2: Create multisig address -----------------------------------------
KEYS="[\"${PUBKEY[seller]}\",\"${PUBKEY[buyer]}\",\"${PUBKEY[arbiter]}\"]"
for party in seller buyer arbiter; do
  MULTISIG=$(run "$party" createmultisig 2 "$KEYS")
done
MS_ADDR=$(json_get 'd["address"]' <<< "$MULTISIG")
MS_DESC=$(json_get 'd["descriptor"]' <<< "$MULTISIG")

# ---- Step 3: Buyer funds the multisig address --------------------------------
FUND_TXID=$(run buyer sendtoaddress "$MS_ADDR" "$FUND_AMOUNT")
if [[ "$(cli getrawtransaction "$FUND_TXID" 1 | json_get '(len(d["vout"]), d["locktime"])')" != "(1, 0)" ]]; then
  echo "error: the funding transaction has a change output or a nonzero locktime" >&2
  exit 1
fi
mine 1
VOUT=$(run seller getrawtransaction "$FUND_TXID" 1 |
  json_get "[o['n'] for o in d['vout'] if o['scriptPubKey'].get('address') == '$MS_ADDR'][0]")

# ---- Step 4: Spending the multisig -------------------------------------------
PSBT=$(run seller createpsbt "[{\"txid\":\"$FUND_TXID\",\"vout\":$VOUT}]" "{\"${ADDR[seller]}\":$SPEND_AMOUNT}")
PSBT=$(run seller utxoupdatepsbt "$PSBT" "[\"$MS_DESC\"]")
PSBT=$(run seller walletprocesspsbt "$PSBT" | json_get 'd["psbt"]')
SIGNED=$(run buyer walletprocesspsbt "$PSBT")
if [[ "$(json_get 'd["complete"]' <<< "$SIGNED")" != True ]]; then
  echo "error: PSBT is not complete after the second signature" >&2
  exit 1
fi
run buyer sendrawtransaction "$(json_get 'd["hex"]' <<< "$SIGNED")" >/dev/null
mine 1
run seller listtransactions "*" 1 >/dev/null

# ---- Format the page's literal blocks ----------------------------------------
python3 - "$OUT_DIR" > "$OUT_DIR/multisig-example.rst" <<'EOF'
import glob, json, os, sys

out_dir = sys.argv[1]
steps = []
for path in sorted(glob.glob(os.path.join(out_dir, "[0-9][0-9]-*.txt"))):
    party = os.path.basename(path).split("-")[1]
    command, _, output = open(path).read().partition("\n")
    steps.append((party, command, output.rstrip("\n")))

def trim_rawtx(output):
    """Replace vin and the raw hex with [...], as the page does."""
    lines, skip = [], False
    for line in output.split("\n"):
        if line.startswith('  "vin": ['):
            lines.append("  [...]")
            skip = True
        elif skip:
            skip = not line.startswith("  ],")
        elif line.startswith('  "hex": '):
            lines.append("  [...]")
        else:
            lines.append(line)
    return "\n".join(lines)

def block(title, indexes, trim=None):
    lines = [f".. {title}", "", f"{steps[indexes[0]][0].capitalize()}::", ""]
    for n, i in enumerate(indexes):
        party, command, output = steps[i]
        if n:
            lines.append("  ")
        lines.append(f"  {party}@dash:~$ ./dash-cli {command}")
        if trim:
            output = trim(output)
        lines += [("  " + line).rstrip() for line in output.split("\n")]
    return "\n".join(lines) + "\n"

pubkeys = {steps[i][0]: json.loads(steps[i][2])["pubkey"] for i in (1, 3, 5)}
keys = "\n".join(f"  {p + ':':<10} {pubkeys[p]}" for p in ("seller", "buyer", "arbiter"))

blocks = [
    block("Step 1: Create three addresses", [0, 1]),
    block("Step 1", [2, 3]),
    block("Step 1", [4, 5]),
    ".. Step 1\n\nThis results in three public keys::\n\n" + keys + "\n",
    block("Step 2: Create multisig address", [6]),
    block("Step 2", [7]),
    block("Step 2", [8]),
    block("Step 3: Buyer funds the multisig address", [9]),
    block("Step 3", [10], trim_rawtx),
    block("Step 4: Spending the multisig", [11]),
    block("Step 4", [12]),
    block("Step 4", [13]),
    block("Step 4", [14]),
    block("Step 4", [15]),
    block("Step 4", [16]),
]
print("\n".join(blocks), end="")
EOF

echo "done: page blocks in $OUT_DIR/multisig-example.rst"
