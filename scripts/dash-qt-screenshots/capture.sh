#!/bin/bash
# Capture Dash Core screenshots from the regtest demo data (run setup-demo.sh first).
#
# Usage: capture.sh [--keep] [shot...]
#   shot     one or more of the names below (default: all)
#   --keep   leave dash-qt and the peer running afterwards, e.g. to inspect a
#            failed shot (Xvfb always stays up). The next run restarts them
#            from the pristine demo data anyway.
#
# Images are written to $WORK/out/<repo path>, e.g.
# $WORK/out/docs/user/wallets/dashcore/img/masternodes.png. Compare them with
# the committed images using compare.sh, and copy them into the repo with
# compare.sh --install.
#
# Navigation uses fixed window sizes and click coordinates. If a Dash Core
# release moves a button, update the coordinates below.
set -euo pipefail
. "$(dirname "$0")/lib.sh"

SHOTS=(tabs masternodes governance options tools wizard wizard-evonode)
OUT=$WORK/out
U=$OUT/docs/user
I=$U/wallets/dashcore/img
WIZ=$WORK/wizard-raw

# --- Shots -------------------------------------------------------------------
# main_tab (lib.sh) switches tabs in the 1124 x 784 main window.

shot_tabs() {
  main_tab 72;  grab "$M" "$I/overview.png"
  key "$M" ctrl+shift+d; place "$M" 1124 798   # Settings > Discreet mode
  grab "$M" "$I/overview-discreet.png"; key "$M" ctrl+shift+d
  main_tab 212; grab "$M" "$I/send.png"
  # Filled-in form. The address is the peer wallet's next one, the same every run;
  # send-receive.rst names its first characters (yU2y).
  local a; a=$(pcli -rpcwallet=ext getnewaddress)
  click "$M" 485 129 0.3; type_text "$M" "$a"
  click "$M" 485 172 0.3; type_text "$M" "Invoice #124"
  click "$M" 147 215 0.3; key "$M" ctrl+a; type_text "$M" 2.5; key "$M" Tab
  grab "$M" "$I/sendready.png"
  main_tab 352; grab "$M" "$I/receive.png"
  main_tab 492; grab "$M" "$I/transactions.png"
  main_tab 632; grab "$M" "$I/coinjoin.png"
}

shot_masternodes() {
  main_tab 772
  grab "$M" "$I/masternodes.png"
  convert "$I/masternodes.png" -crop 1124x300+0+0 +repage -strip \
    "$U/masternodes/img/dashcore-mn-register-button.png"
}

shot_governance() {
  main_tab 912
  click "$M" 120 224   # select the first proposal
  grab "$M" "$I/governance.png"
  cp "$I/governance.png" "$U/governance/img/core-qt/governance-tab.png"
}

shot_options() {
  M=$(main_win); key "$M" alt+s; key "$M" o
  local O t x h; O=$(win Options)
  # tab:x of the tab:window height (each matches the existing image)
  for t in main:60:493 wallet:175:493 coinjoin:290:496 network:405:493 \
           display:512:465 appearance:635:465; do
    IFS=: read -r t x h <<<"$t"
    place "$O" 692 "$h"; click "$O" "$x" 27; grab "$O" "$I/options-$t.png"
  done
  key "$O" Escape
}

# Tools window, opened and switched with its Window menu shortcuts.
shot_tools() {
  local T t k w h
  M=$(main_win)
  for t in information:i:834:618 console:c:833:591 wallet-repair:r:787:618; do
    IFS=: read -r t k w h <<<"$t"
    key "$M" "ctrl+shift+$k"; T=$(win "Tools window"); place "$T" "$w" "$h"
    # Console: focus the message area, so the input line has no blinking cursor.
    [ "$t" != console ] || click "$T" 400 300
    grab "$T" "$I/tools-$t.png"
    if [ "$t" = information ]; then   # the Information tab's other views
      click "$T" 118 73; grab "$T" "$I/tools-information-network.png"
      click "$T" 194 73; grab "$T" "$I/tools-information-governance.png"
    fi
  done
  key "$T" Escape
}

# Register Masternode wizard: 640 px wide, buttons at the bottom of a 900 px window.
open_wizard() {
  main_tab 772
  xdotool windowfocus "$M"; xdotool mousemove 896 106 mousedown 1; pause 0.2; xdotool mouseup 1
  xdotool mousemove $PARK_X $PARK_Y
  D=$(win "Register Masternode"); place "$D" 640 900
}
next() { click "$D" 588 871 1.5; }
wiz() { grab "$D" "$WIZ/$1.png"; compact "$WIZ/$1.png" "$U/masternodes/img/dashcore-mn-wizard-$1.png"; }
service() { click "$D" 320 127 0.3; type_text "$D" "203.0.113.14:19899"; key "$D" Tab; }  # Tab: no blinking cursor
close_wizard() { key "$D" Escape; }

shot_wizard() {
  mkdir -p "$WIZ"; open_wizard
  wiz type;       next
  wiz collateral; next
  service; wiz service; next
  wiz keys;       next
  wiz payout;     next
  wiz fee;        next
  place "$D" 640 1080; wiz review; place "$D" 640 900   # tall page: no scroll bar
  click "$D" 582 871 1.5                                 # Continue
  wiz operator-key
  close_wizard
}

shot_wizard-evonode() {
  mkdir -p "$WIZ"; open_wizard
  click "$D" 44 174 0.5   # EvoNode
  next; next
  service; next
  next; next
  click "$D" 320 136 0.3; type_text "$D" "8e4c3b1d2a9f7e6c5b4a39281706f5e4d3c2b1a0"; key "$D" shift+Tab  # leave the field without selecting a port box
  wiz platform
  close_wizard
}

# --- Run ---------------------------------------------------------------------
KEEP=0; REQ=()
for a in "$@"; do
  case $a in
    --keep) KEEP=1 ;;
    -h|--help) sed -n '2,/^set /{/^#/s/^# \{0,1\}//p}' "$0"; echo "Shots: ${SHOTS[*]}"; exit 0 ;;
    *) [[ " ${SHOTS[*]} " == *" $a "* ]] || die "unknown shot '$a' (shots: ${SHOTS[*]})"; REQ+=("$a") ;;
  esac
done
[ ${#REQ[@]} -gt 0 ] || REQ=("${SHOTS[@]}")
need_bins
[ -d "$WORK/demo.base" ] || die "no demo data in $WORK; run setup-demo.sh first"

start_x
# Always start from the pristine copy, so a failed or --keep run can't leak state.
stop_node cli "$DEMO"; stop_node pcli "$PEER"
rm -rf "$DEMO" "$PEER"; cp -a "$WORK/demo.base" "$DEMO"; cp -a "$WORK/peer.base" "$PEER"
[ $KEEP = 1 ] || trap 'stop_node cli "$DEMO"; stop_node pcli "$PEER"' EXIT
start_peer; open_gui
mkdir -p "$I" "$U/masternodes/img" "$U/governance/img/core-qt"
touch "$OUT/.run-start"   # compare.sh only looks at images from this run
for s in "${REQ[@]}"; do echo "capturing $s"; "shot_$s"; done

echo "Images in $OUT"
