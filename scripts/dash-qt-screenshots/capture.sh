#!/bin/bash
# Capture Dash Core screenshots from the regtest demo data (run setup-demo.sh first).
#
# Usage: capture.sh [--keep] [shot...]
#   shot     one or more of the names below (default: all)
#   --keep   leave dash-qt and the peer running afterwards (Xvfb always stays up)
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

SHOTS=(masternodes governance options wizard wizard-evonode)
OUT=$WORK/out
U=$OUT/docs/user
WIZ=$WORK/wizard-raw

# --- Shots -------------------------------------------------------------------
# Main window: 1124 x 784 matches the existing main-window images.
main_tab() { # x of the tab in the 1124-wide tab bar
  M=$(main_win); place "$M" 1124 784; click "$M" "$1" 45 1.5
}

shot_masternodes() {
  main_tab 772
  grab "$M" "$U/wallets/dashcore/img/masternodes.png"
  convert "$U/wallets/dashcore/img/masternodes.png" -crop 1124x300+0+0 +repage -strip \
    "$U/masternodes/img/dashcore-mn-register-button.png"
}

shot_governance() {
  main_tab 912
  click "$M" 120 224   # select the first proposal
  grab "$M" "$U/wallets/dashcore/img/governance.png"
  cp "$U/wallets/dashcore/img/governance.png" "$U/governance/img/core-qt/governance-tab.png"
}

shot_options() {
  M=$(main_win); key "$M" alt+s; key "$M" o
  local O; O=$(win Options)
  place "$O" 692 493; click "$O" 175 27   # Wallet tab
  grab "$O" "$U/wallets/dashcore/img/options-wallet.png"
  place "$O" 692 465; click "$O" 512 27   # Display tab
  grab "$O" "$U/wallets/dashcore/img/options-display.png"
  key "$O" Escape
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
if ! pgrep -f -- "-datadir=$DEMO( |$)" >/dev/null; then   # fresh start from the pristine copy
  stop_node pcli "$PEER"
  rm -rf "$DEMO" "$PEER"; cp -a "$WORK/demo.base" "$DEMO"; cp -a "$WORK/peer.base" "$PEER"
  start_peer; start_demo_qt
fi
sync_nodes; finish_mnsync
M=$(main_win); place "$M" 1124 784
click "$M" 980 627   # "Hide" on the sync overlay (shown because the GUI compares
                     # the mocktime tip with the real clock); harmless otherwise
mkdir -p "$U/wallets/dashcore/img" "$U/masternodes/img" "$U/governance/img/core-qt"
for s in "${REQ[@]}"; do echo "capturing $s"; "shot_$s"; done

if [ $KEEP = 0 ]; then stop_node cli "$DEMO"; stop_node pcli "$PEER"; fi
echo "Images in $OUT"
