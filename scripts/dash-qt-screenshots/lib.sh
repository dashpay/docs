# Shared settings and helpers for setup-demo.sh and capture.sh. Source it.
# shellcheck shell=bash

# --- Configuration (override with environment variables) ---------------------
# DASH_BIN: directory with dashd and dash-cli, plus dash-qt either next to them
# (release tarball bin/) or in qt/ (source build src/).
DASH_BIN=${DASH_BIN:-$(dirname "$(command -v dashd 2>/dev/null || echo /nonexistent/dashd)")}
shopt -s inherit_errexit
die() { echo "error: $*" >&2; exit 1; }
umask 077   # everything the scripts create under $WORK is private to you
# WORK: data, logs and output. The Tools window shots show this path, so keep
# the default for those (see check_work for the safety checks).
WORK_DEFAULT=/tmp/dash-qt-screenshots
WORK=${WORK:-$WORK_DEFAULT}
# Resolve only the parent, so a symlinked WORK itself stays visible to check_work.
WORK=$(realpath -m -- "$(dirname "$WORK")")/$(basename "$WORK")
# Every folder above WORK must exist, belong to you or root, and not be writable
# by others unless sticky like /tmp, so nobody else can swap WORK. Checked before
# anything is created.
d=$(dirname "$WORK")
[ -d "$d" ] || die "$d does not exist; create it or choose another WORK"
while :; do
  [ -O "$d" ] || [ "$(stat -c %u "$d")" = 0 ] || die "$d belongs to another user; choose another WORK"
  [ -z "$(find "$d" -maxdepth 0 -perm /022 ! -perm -1000)" ] ||
    die "$d is writable by other users; choose another WORK"
  [ "$d" != / ] || break; d=$(dirname "$d")
done
unset d
unset DISPLAY   # GUI commands only ever use the private Xvfb from start_x

DASHD=$DASH_BIN/dashd
CLI_BIN=$DASH_BIN/dash-cli
if [ -x "$DASH_BIN/qt/dash-qt" ]; then DASH_QT=$DASH_BIN/qt/dash-qt; else DASH_QT=$DASH_BIN/dash-qt; fi

DEMO=$WORK/demo   # data directory shown in the screenshots (dash-qt)
PEER=$WORK/peer   # helper node: mines, holds the "ext" wallet, gives dash-qt a peer

# Fixed inputs that make addresses, keys, heights and dates repeatable.
MOCKTIME=1794312000                   # 2026-11-10 12:00:00 UTC
WALLET_PASS=docs-demo-pass
MNEMONIC_WALLET="abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
MNEMONIC_EXT="legal winner thank year wave sausage worth useful legal winner thank yellow"

# Profile from README.md. Unsetting desktop Qt variables, TZ and XDG_CONFIG_HOME
# keep host settings out.
QT_ENV=(-u QT_QPA_PLATFORM -u QT_QPA_PLATFORMTHEME -u QT_STYLE_OVERRIDE -u WAYLAND_DISPLAY
        -u QT_SCREEN_SCALE_FACTORS -u QT_AUTO_SCREEN_SCALE_FACTOR -u QT_ENABLE_HIGHDPI_SCALING
        LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 TZ=UTC QT_FONT_DPI=96 QT_SCALE_FACTOR=1
        XDG_CONFIG_HOME="$WORK/xdg")

need_bins() {
  local b; for b in "$DASHD" "$CLI_BIN" "$DASH_QT"; do
    [ -x "$b" ] || { echo "error: $b not found; set DASH_BIN (see README.md)" >&2; exit 1; }; done
}

cli()  { "$CLI_BIN" -datadir="$DEMO" "$@"; }
pcli() { "$CLI_BIN" -datadir="$PEER" "$@"; }
pause() { timeout "${1:-1}" tail -f /dev/null || true; }

# $WORK must be a folder you own that others can't write to. Run it after
# creating $WORK: mkdir -p succeeds on a folder someone else already made.
check_work() {
  [ -d "$WORK" ] && [ ! -L "$WORK" ] && [ -O "$WORK" ] || die "$WORK is not a folder you own"
  [ -z "$(find "$WORK" -maxdepth 0 -perm /022)" ] || die "$WORK is writable by other users"
}

write_conf() { # dir rpcport port extra...
  local dir=$1 rpc=$2 port=$3; shift 3
  mkdir -p "$dir"
  # No rpcuser/rpcpassword: dash-cli -datadir uses the node's private .cookie.
  { printf 'regtest=1\nserver=1\n[regtest]\n'
    printf 'rpcport=%s\nport=%s\nfallbackfee=0.00001\n' "$rpc" "$port"
    printf '%s\n' "$@"; } > "$dir/dash.conf"
}

write_profile() { # GUI font settings; only while dash-qt/dashd on DEMO is stopped
  mkdir -p "$DEMO/regtest"
  python3 -I - "$DEMO/regtest/settings.json" <<'EOF'
import json, os, sys
p = sys.argv[1]
s = json.load(open(p)) if os.path.exists(p) else {}
s.update({"font-scale": -30, "font-weight-normal": 3, "font-weight-bold": 6})
json.dump(s, open(p, "w"), indent=4)
EOF
  # dash-qt runs with XDG_CONFIG_HOME=$WORK/xdg, so the host's Qt settings and
  # fontconfig don't apply. Skip the first-run Appearance Setup dialog, show the
  # Masternodes and Governance tabs, and make Ubuntu Sans the default UI font.
  # The Qt settings file is rewritten on every start, so window geometry,
  # discreet mode and other state saved by an earlier run don't carry over.
  mkdir -p "$WORK/xdg/Dash" "$WORK/xdg/fontconfig"
  printf '%s\n' '[General]' fAppearanceSetupDone=true fShowMasternodesTab=true \
    fShowGovernanceTab=true mask_values=false > "$WORK/xdg/Dash/Dash-Qt-regtest.conf"
  cat > "$WORK/xdg/fontconfig/fonts.conf" <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
  <alias binding="strong"><family>sans-serif</family><prefer><family>Ubuntu Sans</family></prefer></alias>
  <alias binding="strong"><family>Sans Serif</family><prefer><family>Ubuntu Sans</family></prefer></alias>
</fontconfig>
EOF
}

# A private Xvfb for this run, on the first free display, that only clients
# with the cookie in $WORK/xauthority can use. stop_x shuts it down.
XVFB_PID=
start_x() {
  [ -z "$XVFB_PID" ] || return 0
  local old; old=$(cat "$WORK/xvfb.pid" 2>/dev/null || true)   # left by --keep
  if [[ $old =~ ^[0-9]+$ ]] && [ -O "/proc/$old" ] && [ "$(cat "/proc/$old/comm")" = Xvfb ]; then
    kill "$old" || true
  fi
  export XAUTHORITY=$WORK/xauthority
  : > "$XAUTHORITY"
  # Wildcard entry (any host, any display): the display number isn't known yet.
  echo "ffff 0000  0000  0012 4d49542d4d414749432d434f4f4b49452d31 0010 $(mcookie)" |
    xauth -q -f "$XAUTHORITY" nmerge -
  : > "$WORK/xvfb.display"
  nohup Xvfb -displayfd 3 -auth "$XAUTHORITY" -screen 0 1920x1080x24 -nolisten tcp \
    3> "$WORK/xvfb.display" > "$WORK/xvfb.log" 2>&1 &
  XVFB_PID=$!; echo "$XVFB_PID" > "$WORK/xvfb.pid"
  for _ in $(seq 20); do
    if grep -q . "$WORK/xvfb.display"; then export DISPLAY=":$(head -1 "$WORK/xvfb.display")"; return; fi
    pause 0.5
  done
  die "Xvfb did not start; see $WORK/xvfb.log"
}
stop_x() { [ -z "$XVFB_PID" ] || kill "$XVFB_PID" 2>/dev/null || true; XVFB_PID=; }

now() {
  local t; t=$(cat "$WORK/mocktime" 2>/dev/null || echo "$MOCKTIME")
  [[ $t =~ ^[0-9]+$ ]] || die "$WORK/mocktime does not hold a number"
  echo "$t"
}
tick() { # advance both nodes' clocks by $1 seconds (default 600)
  local t; t=$(now); t=$(( t + ${1:-600} ))
  echo "$t" > "$WORK/mocktime"; pcli setmocktime "$t"; cli setmocktime "$t" 2>/dev/null || true
}

# Make sure the node answering on a data directory's RPC port is that data
# directory's node, not one left running from another $WORK.
owns() { "$1" getrpcinfo 2>/dev/null | grep -qF "\"logpath\": \"$2/"; }  # cli-function datadir
own() { owns "$@" || die "another Dash Core node answers on the RPC port in $2/dash.conf; stop it first"; }

# -daemonwait returns only once the node is up, and fails if its ports are
# taken, so dash-cli can't end up talking to someone else's server.
start_peer() {
  if running "$PEER"; then own pcli "$PEER"; return; fi
  local t; t=$(now)
  "$DASHD" -datadir="$PEER" -mocktime="$t" -daemonwait >/dev/null
  own pcli "$PEER"
}

start_demo_daemon() {
  local t; t=$(now)
  "$DASHD" -datadir="$DEMO" -mocktime="$t" -daemonwait >/dev/null
  own cli "$DEMO"
}

# dash-qt has no -daemonwait. It writes a new .cookie only after it holds the
# RPC port, so wait for that file while dash-qt is still running.
start_demo_qt() {
  local t pid; t=$(now)
  write_profile
  rm -f "$DEMO/regtest/.cookie"
  env "${QT_ENV[@]}" nohup "$DASH_QT" -datadir="$DEMO" -choosedatadir=0 \
    -mocktime="$t" > "$WORK/dash-qt.log" 2>&1 &
  pid=$!
  for _ in $(seq 90); do
    [ -f "$DEMO/regtest/.cookie" ] && break
    kill -0 "$pid" 2>/dev/null || die "dash-qt exited; see $WORK/dash-qt.log"
    pause 1
  done
  cli -rpcwait -rpcwaittimeout=90 getblockcount >/dev/null; own cli "$DEMO"
}

# pgrep/pkill take a regex, so escape the path's special characters.
re_path() { printf '%s' "$1" | sed 's/[][\.*^$+?(){}|]/\\&/g'; }
running() { pgrep -u "$(id -u)" -f -- "-datadir=$(re_path "$1")( |$)" >/dev/null; }
stop_node() { # cli-function datadir
  running "$2" || return 0
  # RPC stop only if the RPC port is this node's; otherwise go straight to signals.
  if owns "$1" "$2"; then "$1" stop >/dev/null 2>&1 || true; fi
  for _ in $(seq 30); do running "$2" || return 0; pause 1; done
  # An open modal dialog can block dash-qt's shutdown; then signal it.
  pkill -u "$(id -u)" -TERM -f -- "-datadir=$(re_path "$2")( |$)" || true
  for _ in $(seq 15); do running "$2" || return 0; pause 1; done
  pkill -u "$(id -u)" -KILL -f -- "-datadir=$(re_path "$2")( |$)" || true; pause 1
}

sync_nodes() { # wait until the demo node has the peer's tip
  local want; want=$(pcli getblockcount)
  for _ in $(seq 60); do [ "$(cli getblockcount)" = "$want" ] && break; pause 1; done
  [ "$(cli getblockcount)" = "$want" ] || die "demo node did not sync to height $want"
}
finish_mnsync() { local c; for c in cli pcli; do for _ in $(seq 8); do $c mnsync next >/dev/null; done; done; }

# --- GUI helpers -------------------------------------------------------------
PARK_X=1910 PARK_Y=1070   # where the mouse waits so nothing shows a hover state

win() { # exact window name, waits up to 10 s; prints the id
  local w
  for _ in $(seq 20); do
    for w in $(xdotool search --onlyvisible --name '' 2>/dev/null); do
      [ "$(xdotool getwindowname "$w" 2>/dev/null)" = "$1" ] && { echo "$w"; return; }
    done
    pause 0.5
  done
  die "window '$1' not found"
}
main_win() { win "Dash Core - Wallet"; }
place() { xdotool windowmove "$1" 0 0 windowsize "$1" "$2" "$3"; pause 1; }  # id w h
click() { xdotool windowfocus "$1"; xdotool mousemove "$2" "$3" click 1; xdotool mousemove $PARK_X $PARK_Y; pause "${4:-1}"; }
key() { xdotool windowfocus "$1"; shift; xdotool key "$@"; pause 1; }
type_text() { xdotool windowfocus "$1"; xdotool type --delay 15 "$2"; xdotool mousemove $PARK_X $PARK_Y; pause 0.5; }
grab() { mkdir -p "$(dirname "$2")"; import -window "$1" +repage -strip "$2"; }  # id out

# Main window: 1124 x 784 matches the existing main-window images.
# Tab x positions in the 1124-wide tab bar: Overview 72, Send 212, Receive 352,
# Transactions 492, CoinJoin 632, Masternodes 772, Governance 912.
main_tab() { # x of the tab
  M=$(main_win); place "$M" 1124 784; click "$M" "$1" 45 1.5
}

# Start dash-qt on the demo data (the peer must be running) and get the main
# window ready: synced, placed, and the sync overlay hidden.
open_gui() {
  start_x; start_demo_qt; sync_nodes; finish_mnsync
  M=$(main_win); place "$M" 1124 784
  click "$M" 980 627   # "Hide" on the sync overlay (shown because the GUI compares
                       # the mocktime tip with the real clock); harmless otherwise
}

# Cut the empty space between a dialog's content and its bottom button row.
# Keeps the content, a 24 px margin and the last 64 px (buttons).
compact() { # in out
  local in=$1 out=$2 w h bb y bh keep
  w=$(identify -format %w "$in"); h=$(identify -format %h "$in")
  bb=$(convert "$in" -crop "${w}x$((h-80))+0+0" +repage -fuzz 2% -trim -format '%h %Y' info: | tr -d '+')
  bh=${bb% *}; y=${bb#* }; keep=$((y+bh+24)); [ $keep -le $((h-64)) ] || keep=$((h-64))
  convert \( "$in" -crop "${w}x${keep}+0+0" +repage \) \
          \( "$in" -crop "${w}x64+0+$((h-64))" +repage \) -append -strip "$out"
}
