#!/bin/bash
# Build the regtest demo data used by capture.sh.
#
# Creates $WORK/demo (the wallet shown in screenshots) and $WORK/peer (a helper
# node that mines and owns the "ext" wallet). Fixed mnemonics, BLS secrets and
# mocktime make addresses, keys, block heights and dates the same on every run.
# Transaction ids and object hashes still vary (wallet coin selection and change
# position are random).
#
# Usage: setup-demo.sh            (refuses to overwrite an existing $WORK)
#        setup-demo.sh --force    (deletes $WORK first)
set -euo pipefail
. "$(dirname "$0")/lib.sh"

need_bins
if [ -e "$WORK" ]; then
  [ "${1:-}" = --force ] || die "$WORK exists; use --force to rebuild it"
  stop_node cli "$DEMO"; stop_node pcli "$PEER"; rm -rf "$WORK"
fi
mkdir -p "$WORK"; echo "$MOCKTIME" > "$WORK/mocktime"

write_conf "$PEER" 29898 29899
write_conf "$DEMO" 19898 19899 connect=127.0.0.1:29899
write_profile
start_peer; start_demo_daemon

X() { pcli -rpcwallet=ext "$@"; }
W() { cli -rpcwallet=Wallet "$@"; }
push() { # copy mempool transactions both ways now; P2P relay under mocktime is slow and unordered
  local t
  for t in $(cli getrawmempool | tr -d '[]", '); do pcli sendrawtransaction "$(cli getrawtransaction "$t")" >/dev/null 2>&1 || true; done
  for t in $(pcli getrawmempool | tr -d '[]", '); do cli sendrawtransaction "$(pcli getrawtransaction "$t")" >/dev/null 2>&1 || true; done
}
mine() {
  push; tick 150
  pcli generatetoaddress "$1" "$MINE" >/dev/null; sync_nodes
}

# Wallets from fixed mnemonics (blank wallet + upgradetohd)
pcli createwallet ext false true "" false true true >/dev/null
X upgradetohd "$MNEMONIC_EXT" >/dev/null
cli createwallet Wallet false true "" false true true >/dev/null
W upgradetohd "$MNEMONIC_WALLET" >/dev/null
MINE=$(X getnewaddress)

echo "Mining past DIP3 activation..."
mine 650

echo "Funding the demo wallet..."
send() { # amount label
  local a; a=$(W getnewaddress "$2"); tick 60; X sendtoaddress "$a" "$1" >/dev/null; push; echo "$a"
}
COLL=( "$(send 1001.5 '')" "$(send 1001.5 '')" "$(send 1001.5 '')" )
send 25 '' >/dev/null; send 3.5 'Invoice #123' >/dev/null; send 0.75 'Coffee shop' >/dev/null
send 12.25 '' >/dev/null; send 1500 '' >/dev/null   # 1500: fee source for the wizard
mine 1

echo "Registering masternodes..."
# One registration per block so payment order doesn't depend on proTxHash.
# BLS secrets 0x01..0x08 (any valid scalar works; these are just fixed).
bls_pub() { cli bls fromsecret "$(printf '%064x' "$1")" | python3 -c 'import json,sys;print(json.load(sys.stdin)["public"])'; }
n=1
for i in 0 1 2; do   # owned by the demo wallet (Owned filter, My votes)
  W protx register_fund "$(W getnewaddress)" "[\"203.0.113.$((11+i)):19899\"]" \
    "$(W getnewaddress)" "$(bls_pub $n)" "$(W getnewaddress)" 0 "$(W getnewaddress)" "${COLL[$i]}" >/dev/null
  n=$((n+1)); mine 1
done
for i in 0 1 2 3 4; do   # other operators
  F=$(X getnewaddress); X sendtoaddress "$F" 1001 >/dev/null; mine 1
  X protx register_fund "$(X getnewaddress)" "[\"203.0.113.$((21+i)):19899\"]" \
    "$(X getnewaddress)" "$(bls_pub $n)" "$(X getnewaddress)" 0 "$(X getnewaddress)" "$F" >/dev/null
  n=$((n+1)); mine 1
done
mine 2
finish_mnsync

echo "Creating proposals..."
declare -A H
props=( "dash-docs-v24-update 25" "core-dev-team-q1 120" "community-meetups 8.5" "marketing-campaign-2027 60" )
declare -a PREP=()
for p in "${props[@]}"; do
  set -- $p; t=$(now)
  pa=$(X getnewaddress)
  json=$(printf '{"type":1,"name":"%s","start_epoch":%d,"end_epoch":%d,"payment_amount":%s,"payment_address":"%s","url":"https://www.dashcentral.org/p/%s"}' \
         "$1" $((t-60)) $((t+86400*60)) "$2" "$pa" "$1")
  hex=$(printf '%s' "$json" | python3 -c 'import sys;print(sys.stdin.buffer.read().hex())')
  PREP+=( "$1 $t $hex $(X gobject prepare 0 1 "$t" "$hex")" )
  tick 60
done
mine 7
for e in "${PREP[@]}"; do
  set -- $e; H[$1]=$(X gobject submit 0 1 "$2" "$3" "$4")
done
mine 1

echo "Voting..."
XM=($(X protx list wallet | python3 -c 'import json,sys;print(" ".join(json.load(sys.stdin)))'))
WM=($(W protx list wallet | python3 -c 'import json,sys;print(" ".join(json.load(sys.stdin)))'))
va() { tick 5; "$1" gobject vote-alias "$2" funding "$3" "$4" >/dev/null; }
for i in 0 1 2 3 4; do va X "${H[dash-docs-v24-update]}" yes "${XM[$i]}"; done
for i in 0 1 2; do va X "${H[core-dev-team-q1]}" yes "${XM[$i]}"; done; va X "${H[core-dev-team-q1]}" no "${XM[3]}"
va X "${H[community-meetups]}" yes "${XM[0]}"; va X "${H[community-meetups]}" abstain "${XM[1]}"
for i in 0 1 2; do va X "${H[marketing-campaign-2027]}" no "${XM[$i]}"; done; va X "${H[marketing-campaign-2027]}" yes "${XM[3]}"
wait_votes() { # node-cli count: governance objects and votes are relayed with a delay
  for _ in $(seq 60); do
    [ "$("$1" gobject count json | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d["proposals"],d["votes"])')" = "4 $2" ] && return
    pause 1
  done; die "governance data did not reach $1"
}
wait_votes cli 15
for i in 0 1 2; do va W "${H[dash-docs-v24-update]}" yes "${WM[$i]}"; done
va W "${H[core-dev-team-q1]}" yes "${WM[0]}"; va W "${H[core-dev-team-q1]}" no "${WM[1]}"
wait_votes pcli 20
mine 1

W encryptwallet "$WALLET_PASS" >/dev/null
echo "Height $(cli getblockcount), $(cli protx list | grep -c '"') masternodes, $(cli gobject count | tr -d '\n')"
stop_node cli "$DEMO"; stop_node pcli "$PEER"
# capture.sh restores these copies before each run, so wallet state such as the
# next unused address is the same every time.
cp -a "$DEMO" "$WORK/demo.base"; cp -a "$PEER" "$WORK/peer.base"
echo "Demo data ready in $WORK"
