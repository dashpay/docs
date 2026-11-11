# Shared settings and helpers for setup-demo.sh and capture.sh. Source it.
# shellcheck shell=bash

# --- Configuration (override with environment variables) ---------------------
# DASH_BIN: directory with dashd and dash-cli, plus dash-qt either next to them
# (release tarball bin/) or in qt/ (source build src/).
DASH_BIN=${DASH_BIN:-$(dirname "$(command -v dashd 2>/dev/null || echo /nonexistent/dashd)")}
WORK=$(realpath -m "${WORK:-/tmp/dash-qt-screenshots}")
shopt -s inherit_errexit
export DISPLAY=${DISPLAY_NUM:-:99}

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
die() { echo "error: $*" >&2; exit 1; }

write_conf() { # dir rpcport port extra...
  local dir=$1 rpc=$2 port=$3; shift 3
  mkdir -p "$dir"
  { printf 'regtest=1\nserver=1\n[regtest]\nrpcuser=u\nrpcpassword=p\n'
    printf 'rpcport=%s\nport=%s\nbind=127.0.0.1\nfallbackfee=0.00001\n' "$rpc" "$port"
    printf '%s\n' "$@"; } > "$dir/dash.conf"
}

write_profile() { # GUI font settings; only while dash-qt/dashd on DEMO is stopped
  mkdir -p "$DEMO/regtest"
  python3 - "$DEMO/regtest/settings.json" <<'EOF'
import json, os, sys
p = sys.argv[1]
s = json.load(open(p)) if os.path.exists(p) else {}
s.update({"font-scale": -30, "font-weight-normal": 3, "font-weight-bold": 6})
json.dump(s, open(p, "w"), indent=4)
EOF
  # dash-qt runs with XDG_CONFIG_HOME=$WORK/xdg, so the host's Qt settings and
  # fontconfig don't apply. Skip the first-run Appearance Setup dialog, show the
  # Masternodes and Governance tabs, and make Ubuntu Sans the default UI font.
  mkdir -p "$WORK/xdg/Dash" "$WORK/xdg/fontconfig"
  python3 - "$WORK/xdg/Dash/Dash-Qt-regtest.conf" <<'EOF'
import configparser, sys
p = sys.argv[1]
c = configparser.RawConfigParser(); c.optionxform = str; c.read(p)
if not c.has_section("General"): c.add_section("General")
for k in ("fAppearanceSetupDone", "fShowMasternodesTab", "fShowGovernanceTab"):
    c.set("General", k, "true")
with open(p, "w") as f: c.write(f, space_around_delimiters=False)
EOF
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

start_x() {
  if ! xdpyinfo >/dev/null 2>&1 && ! xdotool getdisplaygeometry >/dev/null 2>&1; then
    nohup Xvfb "$DISPLAY" -screen 0 1920x1080x24 -nolisten tcp > "$WORK/xvfb.log" 2>&1 &
    for _ in $(seq 10); do xdotool getdisplaygeometry >/dev/null 2>&1 && return; pause 0.5; done
    die "Xvfb did not start on $DISPLAY; see $WORK/xvfb.log"
  fi
}

now() { cat "$WORK/mocktime" 2>/dev/null || echo "$MOCKTIME"; }
tick() { # advance both nodes' clocks by $1 seconds (default 600)
  local t=$(( $(now) + ${1:-600} ))
  echo "$t" > "$WORK/mocktime"; pcli setmocktime "$t"; cli setmocktime "$t" 2>/dev/null || true
}

start_peer() {
  pcli getblockcount >/dev/null 2>&1 && return
  "$DASHD" -datadir="$PEER" -mocktime="$(now)" -daemon >/dev/null
  pcli -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null
}

start_demo_daemon() {
  "$DASHD" -datadir="$DEMO" -mocktime="$(now)" -daemon >/dev/null
  cli -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null
}

start_demo_qt() {
  write_profile
  env "${QT_ENV[@]}" nohup "$DASH_QT" -datadir="$DEMO" -choosedatadir=0 \
    -mocktime="$(now)" > "$WORK/dash-qt.log" 2>&1 &
  cli -rpcwait -rpcwaittimeout=90 getblockcount >/dev/null
}

running() { pgrep -u "$(id -u)" -f -- "-datadir=$1( |$)" >/dev/null; }
stop_node() { # cli-function datadir
  running "$2" || return 0
  "$1" stop >/dev/null 2>&1 || true
  for _ in $(seq 30); do running "$2" || return 0; pause 1; done
  # An open modal dialog can block dash-qt's shutdown; then signal it.
  pkill -u "$(id -u)" -TERM -f -- "-datadir=$2( |$)" || true
  for _ in $(seq 15); do running "$2" || return 0; pause 1; done
  pkill -u "$(id -u)" -KILL -f -- "-datadir=$2( |$)" || true; pause 1
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
