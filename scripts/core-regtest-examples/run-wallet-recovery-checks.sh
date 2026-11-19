#!/usr/bin/env bash
#
# run-wallet-recovery-checks.sh
#
# Start a fresh, isolated Dash Core regtest node and check that the wallet
# backup, restore, and recovery commands in the user docs still work:
#
#   docs/user/wallets/dashcore/advanced.rst  Upgrade to HD, View HD wallet
#                                            information, Restore HD wallet,
#                                            Migrate wallet
#   docs/user/wallets/dashcore/backup.rst    Backup, automatic backups, Restore
#   docs/user/wallets/recovery.rst           Private Keys
#   docs/user/wallets/paper.rst              Importing the private key
#   docs/user/wallets/dashcore/interface.rst dash-wallet salvage
#
# The pages show commands to type but no output, so this script does not
# capture examples. It runs each documented command, checks the result, and
# exits non-zero if any check fails. A failure usually means a Dash Core
# release changed a command the docs rely on.
#
# Output in OUT_DIR:
#   NN-<step>.txt  Each command (first line, "$ ..."), its output, and an
#                  "exit=<status>" line
#   checks.txt     One PASS or FAIL line per check, plus NOTE lines
#   version.txt    dashd -version first line
#   datadir/       The node's data directory, with all test wallets
#
# The script never deletes anything. Each run creates a new, private
# directory, which is kept so the wallets can be inspected after a failed
# check. Delete it when you no longer need it.
#
# Usage:
#   DASH_BIN=/path/to/dash/src ./run-wallet-recovery-checks.sh
#
# Overrides (environment variables):
#   DASH_BIN   Directory containing dashd, dash-cli and dash-wallet (required)
#   OUT_DIR    Where to write command output; must not exist
#              (default: new temp dir)
#   DATADIR    Node data directory; must not exist
#              (default: OUT_DIR/datadir)
#   P2P_PORT   P2P port (default: 26701; the node runs with -listen=0)
#   RPC_PORT   RPC port (default: 26702)
#
# Dependencies: bash, python3. The legacy wallet checks need Dash Core built
# with Berkeley DB support (release binaries are).
#
set -Eeuo pipefail
# Everything the script creates is readable by the current user only
umask 077

# ---- Config ------------------------------------------------------------------
: "${DASH_BIN:?set DASH_BIN to the directory containing dashd, dash-cli and dash-wallet}"
DASHD="$DASH_BIN/dashd"
CLI_BIN="$DASH_BIN/dash-cli"
WALLET_BIN="$DASH_BIN/dash-wallet"
P2P_PORT="${P2P_PORT:-26701}"
RPC_PORT="${RPC_PORT:-26702}"

# The BIP39 test mnemonic, also used by scripts/dash-qt-screenshots.
# Public, regtest-only keys: NEVER use these on mainnet or testnet.
MNEMONIC="abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
# First receiving address (m/44'/1'/0'/0/0) without and with a mnemonic
# passphrase. "TREZOR" is the passphrase of the BIP39 test vectors.
EXPECTED_ADDRESS="yRd4FhXfVGHXpsuZXPNkMrfD9GVj46pnjt"
MNEMONIC_PASSPHRASE="TREZOR"
EXPECTED_ADDRESS_MP="ya4hijmdfG9gtJHZoDWhedMYT8da2e3zu5"
WALLET_PASSPHRASE="docs-wallet-passphrase"

# A fixed regtest-only private key, sha256("dash-docs regtest paper wallet"),
# in uncompressed WIF (like the paper wallet example on recovery.rst) and
# compressed WIF. The two forms have different addresses.
KEY_WIF_UNCOMPRESSED="92wzq3ABc6YUtsqzwMeeygADLT9XvRZcBaVjXou3sC5k5ipGnmz"
KEY_WIF_COMPRESSED="cTbkF2XXouTx7yRGiv9Cd9qfSrQfUoQvHgqpiyzjeXuw9ePAJKDF"
KEY_AMOUNT_UNCOMPRESSED=1.5
KEY_AMOUNT_COMPRESSED=2.5
KEY_BALANCE="4.00000000" # sum of the two amounts
# ------------------------------------------------------------------------------

for bin in "$DASHD" "$CLI_BIN" "$WALLET_BIN"; do
  if [[ ! -x "$bin" ]]; then
    echo "error: not found or not executable: $bin" >&2
    exit 1
  fi
done
command -v python3 >/dev/null || { echo "error: python3 is required" >&2; exit 1; }

# The script deletes nothing, so it only writes to directories it creates:
# it never mixes with earlier output or touches existing wallets. Each
# directory is created with a plain mkdir, which fails if anything (a
# directory, file, or symlink) is already at that path.
# refuse_existing <variable name> <path>
refuse_existing() {
  if [[ -e "$2" || -L "$2" ]]; then
    echo "error: $1 must not exist: $2" >&2
    exit 1
  fi
}
# make_new_dir <variable name> <path> - create the directory, not its parents
make_new_dir() {
  mkdir -p -- "$(dirname -- "$2")"
  mkdir -- "$2" 2>/dev/null || { echo "error: $1 must not exist: $2" >&2; exit 1; }
}
# Check both before creating anything, so a refused run leaves nothing behind
[[ -z "${OUT_DIR:-}" ]] || refuse_existing OUT_DIR "$OUT_DIR"
[[ -z "${DATADIR:-}" ]] || refuse_existing DATADIR "$DATADIR"
if [[ -z "${OUT_DIR:-}" ]]; then
  OUT_DIR="$(mktemp -d -t dash-wallet-recovery-checks.XXXXXX)"
else
  make_new_dir OUT_DIR "$OUT_DIR"
fi
DATADIR="${DATADIR:-$OUT_DIR/datadir}"
make_new_dir DATADIR "$DATADIR"
# Dash Core reports absolute paths (migratewallet backup_path)
DATADIR="$(cd "$DATADIR" && pwd)"
WALLETS_DIR="$DATADIR/regtest/wallets"
BACKUPS_DIR="$DATADIR/regtest/backups"

cli() {
  "$CLI_BIN" -regtest -datadir="$DATADIR" -rpcport="$RPC_PORT" "$@"
}
wallet_tool() {
  "$WALLET_BIN" -regtest -datadir="$DATADIR" "$@"
}

NODE_STARTED=0
stop_node() {
  cli stop >/dev/null 2>&1 || true
  for _ in $(seq 1 60); do
    [[ -f "$DATADIR/regtest/dashd.pid" ]] || return 0
    sleep 0.5
  done
  return 1
}
# On exit, stop the node but keep all files
cleanup() {
  if [[ "$NODE_STARTED" == 1 ]] && ! stop_node; then
    echo "warning: dashd did not stop; stop it before deleting $DATADIR" >&2
  fi
  echo "kept: output in $OUT_DIR, datadir in $DATADIR (delete them when done)"
}
trap cleanup EXIT
# Setup commands (not logged steps) abort the run if they fail. Report the
# failure once, from the main shell, not from each command substitution.
trap '(( BASH_SUBSHELL )) || echo "error: setup command failed at line $LINENO: $BASH_COMMAND" >&2' ERR

# start_node [args...] - start dashd and wait for RPC
start_node() {
  "$DASHD" -regtest -datadir="$DATADIR" -daemonwait \
    -port="$P2P_PORT" -rpcport="$RPC_PORT" -listen=0 -connect=0 "$@" >/dev/null
  NODE_STARTED=1
  cli -rpcwait -rpcwaittimeout=60 getblockcount >/dev/null
}

# ---- Logging and checks ------------------------------------------------------
STEP=0
declare -A FILE

# log <slug> <cli|wallet_tool> [args...] - run a command and save the command,
# its output, and its exit status to the next numbered file
log() {
  local slug="$1" status=0 label arg
  shift
  STEP=$((STEP + 1))
  FILE[$slug]="$OUT_DIR/$(printf '%02d' "$STEP")-$slug.txt"
  case "$1" in
    cli) label=dash-cli ;;
    wallet_tool) label=dash-wallet ;;
    *) label="$1" ;;
  esac
  {
    printf '$ %s' "$label"
    for arg in "${@:2}"; do
      if [[ -n "$arg" && "$arg" != *[!A-Za-z0-9_=./:@,+-]* ]]; then
        printf ' %s' "$arg"
      else
        printf " '%s'" "${arg//\'/\'\\\'\'}"
      fi
    done
    printf '\n'
  } > "${FILE[$slug]}"
  "$@" >> "${FILE[$slug]}" 2>&1 || status=$?
  echo "exit=$status" >> "${FILE[$slug]}"
}

# out <slug> - print a step's output without the command and exit lines
out() { sed '1d;$d' "${FILE[$1]}"; }

# jq_py <python-expression> - evaluate an expression over JSON `d` on stdin;
# prints nothing if the input is not JSON or the expression fails
jq_py() {
  python3 -c 'import json, sys; d = json.load(sys.stdin); print(eval(sys.argv[1]))' "$1" 2>/dev/null || true
}

# Predicates for check
ok() { grep -qx 'exit=0' "${FILE[$1]}"; }
fails() { ! ok "$1" && grep -qF -- "$2" "${FILE[$1]}"; }
same() { [[ -n "$1" && "$1" == "$2" ]]; }
true_in() { [[ "$(out "$1" | jq_py "$2")" == True ]]; }

NPASS=0
NFAIL=0
# check <description> <predicate> [args...] - record PASS or FAIL
check() {
  local desc="$1" line
  shift
  if "$@"; then
    line="PASS  $desc"
    NPASS=$((NPASS + 1))
  else
    line="FAIL  $desc"
    NFAIL=$((NFAIL + 1))
  fi
  echo "$line" | tee -a "$OUT_DIR/checks.txt"
}
note() { echo "NOTE  $*" | tee -a "$OUT_DIR/checks.txt"; }
section() { echo "## $*" | tee -a "$OUT_DIR/checks.txt"; }

# Helpers that are setup, not checks
balance() { cli -rpcwallet="$1" getbalance 2>/dev/null || true; }
# addresses <wallet> - sorted addresses in the wallet's address book
addresses() {
  cli -rpcwallet="$1" listreceivedbyaddress 0 true 2>/dev/null |
    jq_py '" ".join(sorted(a["address"] for a in d))'
}
ismine() { [[ "$(cli -rpcwallet="$1" getaddressinfo "$2" | jq_py 'd["ismine"]')" == True ]]; }
mine() { cli generatetoaddress "$1" "$MINER_ADDR" >/dev/null; }

"$DASHD" -version | head -n 1 > "$OUT_DIR/version.txt"
echo "dashd: $(cat "$OUT_DIR/version.txt")"
echo "datadir: $DATADIR"
echo "output: $OUT_DIR"

start_node
cli createwallet miner >/dev/null
MINER_ADDR=$(cli -rpcwallet=miner getnewaddress)
mine 101 # the block 1 coinbase matures at height 101

# ---- Restore HD wallet (advanced.rst) ----------------------------------------
section "Restore HD wallet (advanced.rst)"
# createwallet "enter wallet name" false true "optional wallet password"
# upgradetohd "enter mnemonic" "optional mnemonic passphrase" "optional wallet passphrase"
log restore-plain-createwallet cli createwallet restore-plain false true ""
log restore-plain-upgradetohd cli -rpcwallet=restore-plain upgradetohd "$MNEMONIC" "" ""
log restore-plain-getnewaddress cli -rpcwallet=restore-plain getnewaddress
check "createwallet blank, no wallet password" ok restore-plain-createwallet
check "upgradetohd with mnemonic, no passphrases" ok restore-plain-upgradetohd
check "restored wallet's first address is $EXPECTED_ADDRESS" same "$(out restore-plain-getnewaddress)" "$EXPECTED_ADDRESS"

log restore-encrypted-createwallet cli createwallet restore-encrypted false true "$WALLET_PASSPHRASE"
log restore-encrypted-upgradetohd-nopass cli -rpcwallet=restore-encrypted upgradetohd "$MNEMONIC" "" ""
log restore-encrypted-upgradetohd cli -rpcwallet=restore-encrypted upgradetohd "$MNEMONIC" "" "$WALLET_PASSPHRASE"
log restore-encrypted-getnewaddress cli -rpcwallet=restore-encrypted getnewaddress
log restore-encrypted-getwalletinfo cli -rpcwallet=restore-encrypted getwalletinfo
check "createwallet blank, with wallet password" ok restore-encrypted-createwallet
check "upgradetohd on an encrypted wallet needs the wallet passphrase" fails restore-encrypted-upgradetohd-nopass "Wallet encrypted"
check "upgradetohd with mnemonic and wallet passphrase" ok restore-encrypted-upgradetohd
check "encrypted restored wallet's first address is $EXPECTED_ADDRESS" same "$(out restore-encrypted-getnewaddress)" "$EXPECTED_ADDRESS"
check "restored wallet is an encrypted descriptor wallet" true_in restore-encrypted-getwalletinfo '"unlocked_until" in d and d["descriptors"]'

log restore-mp-createwallet cli createwallet restore-mp false true "$WALLET_PASSPHRASE"
log restore-mp-upgradetohd cli -rpcwallet=restore-mp upgradetohd "$MNEMONIC" "$MNEMONIC_PASSPHRASE" "$WALLET_PASSPHRASE"
log restore-mp-getnewaddress cli -rpcwallet=restore-mp getnewaddress
check "upgradetohd with mnemonic, mnemonic passphrase and wallet passphrase" ok restore-mp-upgradetohd
check "mnemonic passphrase restore's first address is $EXPECTED_ADDRESS_MP" same "$(out restore-mp-getnewaddress)" "$EXPECTED_ADDRESS_MP"

# Mnemonic passphrase limit (the -allow-deprecated-long-mnemonics part runs at
# the end, because it restarts the node)
P248=$(printf 'a%.0s' $(seq 1 248))
P249=$(printf 'a%.0s' $(seq 1 249))
log mp248-createwallet cli createwallet mp248 false true ""
log mp248-upgradetohd cli -rpcwallet=mp248 upgradetohd "$MNEMONIC" "$P248" ""
log mp249-createwallet cli createwallet mp249 false true ""
log mp249-upgradetohd cli -rpcwallet=mp249 upgradetohd "$MNEMONIC" "$P249" ""
check "248-byte mnemonic passphrase is accepted" ok mp248-upgradetohd
check "249-byte mnemonic passphrase is rejected" fails mp249-upgradetohd "at most 248 bytes"

# The same restore into a legacy wallet. It is used for dumphdinfo, backup,
# automatic backup, and migratewallet below.
log legacy-createwallet cli -named createwallet wallet_name=legacy blank=true descriptors=false load_on_startup=false
log legacy-upgradetohd cli -rpcwallet=legacy upgradetohd "$MNEMONIC" "" "$WALLET_PASSPHRASE"
log legacy-getnewaddress cli -rpcwallet=legacy getnewaddress
check "legacy wallet: createwallet blank and upgradetohd" ok legacy-upgradetohd
check "legacy restored wallet's first address is $EXPECTED_ADDRESS" same "$(out legacy-getnewaddress)" "$EXPECTED_ADDRESS"
# The funding and migration steps use the address the restore returned, so
# they still run if the address check fails
RESTORED_ADDR=$(out legacy-getnewaddress)

# ---- View HD wallet information (advanced.rst) -------------------------------
section "View HD wallet information (advanced.rst)"
mnemonic_in() {
  true_in "$1" 'all(x["mnemonic"] == "'"$MNEMONIC"'" and x["mnemonicpassphrase"] == "'"$2"'" for x in d["descriptors"]) and len(d["descriptors"]) > 0'
}
log view-plain-listdescriptors cli -rpcwallet=restore-plain listdescriptors true
check "listdescriptors true shows mnemonic and empty mnemonicpassphrase" mnemonic_in view-plain-listdescriptors ""
log view-mp-listdescriptors-locked cli -rpcwallet=restore-mp listdescriptors true
check "listdescriptors true on a locked wallet fails" fails view-mp-listdescriptors-locked "walletpassphrase"
log view-mp-walletpassphrase cli -rpcwallet=restore-mp walletpassphrase "$WALLET_PASSPHRASE" 600
log view-mp-listdescriptors cli -rpcwallet=restore-mp listdescriptors true
check "after walletpassphrase, listdescriptors true shows mnemonic and mnemonicpassphrase" mnemonic_in view-mp-listdescriptors "$MNEMONIC_PASSPHRASE"
log view-dumphdinfo-descriptor cli -rpcwallet=restore-plain dumphdinfo
check "dumphdinfo fails on a descriptor wallet" fails view-dumphdinfo-descriptor "Only legacy wallets"
log view-legacy-walletpassphrase cli -rpcwallet=legacy walletpassphrase "$WALLET_PASSPHRASE" 600
log view-dumphdinfo-legacy cli -rpcwallet=legacy dumphdinfo
check "dumphdinfo on a legacy wallet shows the mnemonic" true_in view-dumphdinfo-legacy 'd["mnemonic"] == "'"$MNEMONIC"'" and d["mnemonicpassphrase"] == "" and len(d["hdseed"]) == 128'

# ---- Upgrade to HD (advanced.rst) --------------------------------------------
section "Upgrade to HD (advanced.rst)"
# upgradetohd "" "" <walletpassphrase>: a new random mnemonic, and the
# wallet passphrase encrypts an unencrypted wallet
log upgrade-createwallet cli -named createwallet wallet_name=upgrade blank=true descriptors=false load_on_startup=false
log upgrade-upgradetohd cli -rpcwallet=upgrade upgradetohd "" "" "$WALLET_PASSPHRASE"
log upgrade-getwalletinfo cli -rpcwallet=upgrade getwalletinfo
log upgrade-walletpassphrase cli -rpcwallet=upgrade walletpassphrase "$WALLET_PASSPHRASE" 600
log upgrade-dumphdinfo cli -rpcwallet=upgrade dumphdinfo
check "upgradetohd \"\" \"\" <walletpassphrase> on a legacy non-HD wallet" ok upgrade-upgradetohd
check "upgraded wallet is HD and encrypted" true_in upgrade-getwalletinfo '"hdchainid" in d and "unlocked_until" in d'
check "upgraded wallet has a new 12-word mnemonic" true_in upgrade-dumphdinfo 'len(d["mnemonic"].split()) == 12 and d["mnemonic"] != "'"$MNEMONIC"'"'
log upgrade-descriptor cli -rpcwallet=restore-plain upgradetohd "" "" ""
check "upgradetohd fails on a descriptor wallet (already HD)" fails upgrade-descriptor "already upgraded to HD"

# ---- Funding (setup) ---------------------------------------------------------
desc_address() {
  cli deriveaddresses "$(cli getdescriptorinfo "pkh($1)" | jq_py 'd["descriptor"]')" | jq_py 'd[0]'
}
KEY_ADDR_U=$(desc_address "$KEY_WIF_UNCOMPRESSED")
KEY_ADDR_C=$(desc_address "$KEY_WIF_COMPRESSED")
cli createwallet backup-source >/dev/null
BACKUP_ADDR=$(cli -rpcwallet=backup-source getnewaddress)
cli -rpcwallet=backup-source getnewaddress >/dev/null # an unused address
WATCH_ADDR=$(cli -rpcwallet=miner getnewaddress)
cli -rpcwallet=legacy importaddress "$WATCH_ADDR" "" false
cli -rpcwallet=miner sendtoaddress "$KEY_ADDR_U" "$KEY_AMOUNT_UNCOMPRESSED" >/dev/null
cli -rpcwallet=miner sendtoaddress "$KEY_ADDR_C" "$KEY_AMOUNT_COMPRESSED" >/dev/null
cli -rpcwallet=miner sendtoaddress "$BACKUP_ADDR" 3 >/dev/null
cli -rpcwallet=miner sendtoaddress "$RESTORED_ADDR" 2 >/dev/null
cli -rpcwallet=miner sendtoaddress "$WATCH_ADDR" 1 >/dev/null
mine 1
section "Restored wallets see new funds"
check "restored descriptor wallet shows the funds sent to its first address" same "$(balance restore-plain)" "2.00000000"
check "restored legacy wallet shows the funds sent to its first address" same "$(balance legacy)" "2.00000000"

# ---- Import a private key (recovery.rst, paper.rst) --------------------------
section "Import a private key (recovery.rst, paper.rst)"
# Descriptor wallet: getdescriptorinfo "pkh(<WIF>)", then
# importdescriptors '[{"desc": "pkh(<WIF>)#<checksum>", "timestamp": 0}]'
log import-createwallet cli createwallet import-descriptor false false "$WALLET_PASSPHRASE"
log import-walletpassphrase cli -rpcwallet=import-descriptor walletpassphrase "$WALLET_PASSPHRASE" 600
n=0
for wif in "$KEY_WIF_UNCOMPRESSED" "$KEY_WIF_COMPRESSED"; do
  n=$((n + 1))
  log import-getdescriptorinfo-$n cli getdescriptorinfo "pkh($wif)"
  checksum=$(out import-getdescriptorinfo-$n | jq_py 'd["checksum"]')
  log import-importdescriptors-$n cli -rpcwallet=import-descriptor importdescriptors "[{\"desc\": \"pkh($wif)#$checksum\", \"timestamp\": 0}]"
  check "getdescriptorinfo \"pkh(<WIF>)\" returns a checksum (key $n)" same "${#checksum}" 8
  check "importdescriptors with the checksum and timestamp 0 succeeds (key $n)" true_in import-importdescriptors-$n 'd[0]["success"]'
done
check "imported keys' funds show after the rescan (descriptor wallet)" same "$(balance import-descriptor)" "$KEY_BALANCE"
log import-importprivkey-descriptor cli -rpcwallet=import-descriptor importprivkey "$KEY_WIF_UNCOMPRESSED"
check "importprivkey fails on a descriptor wallet" fails import-importprivkey-descriptor "Only legacy wallets"

# Legacy wallet: importprivkey <WIF>
log import-legacy-createwallet cli -named createwallet wallet_name=import-legacy descriptors=false load_on_startup=false passphrase="$WALLET_PASSPHRASE"
log import-legacy-walletpassphrase cli -rpcwallet=import-legacy walletpassphrase "$WALLET_PASSPHRASE" 600
log import-legacy-importprivkey-1 cli -rpcwallet=import-legacy importprivkey "$KEY_WIF_UNCOMPRESSED"
log import-legacy-importprivkey-2 cli -rpcwallet=import-legacy importprivkey "$KEY_WIF_COMPRESSED"
check "importprivkey on a legacy wallet (key 1)" ok import-legacy-importprivkey-1
check "importprivkey on a legacy wallet (key 2)" ok import-legacy-importprivkey-2
check "imported keys' funds show after the rescan (legacy wallet)" same "$(balance import-legacy)" "$KEY_BALANCE"
log import-legacy-importdescriptors cli -rpcwallet=import-legacy importdescriptors "[{\"desc\": \"pkh($KEY_WIF_COMPRESSED)#$checksum\", \"timestamp\": 0}]"
check "importdescriptors fails on a legacy wallet" fails import-legacy-importdescriptors "not available for non-descriptor wallets"

# ---- Backup and restore (backup.rst) -----------------------------------------
section "Backup and restore (backup.rst)"
mkdir -p "$DATADIR/manual-backups"
# same_funds <a> <b> - same balance and address book (a failed lookup fails)
same_funds() {
  same "$(balance "$1")" "$(balance "$2")" &&
    same "$(addresses "$1")" "$(addresses "$2")"
}
# same_wallet <a> <b> - same_funds, and the same next address
same_wallet() {
  same_funds "$1" "$2" &&
    same "$(cli -rpcwallet="$1" getnewaddress)" "$(cli -rpcwallet="$2" getnewaddress)"
}
log backup-backupwallet cli -rpcwallet=backup-source backupwallet "$DATADIR/manual-backups/backup-source.dat"
log backup-restorewallet cli restorewallet backup-restored "$DATADIR/manual-backups/backup-source.dat"
check "backupwallet (descriptor wallet)" ok backup-backupwallet
check "restorewallet from the backup (descriptor wallet)" ok backup-restorewallet
check "restored backup has the same balance and addresses (descriptor wallet)" same_wallet backup-source backup-restored

# Backup by copying wallet.dat while the wallet is not loaded, then restore
# by putting the copy in place and loading it
log copy-unloadwallet cli unloadwallet backup-source
check "unloadwallet before copying wallet.dat" ok copy-unloadwallet
# Never copy a loaded wallet; the checks below then fail
if ok copy-unloadwallet; then
  mkdir "$WALLETS_DIR/backup-copied"
  cp "$WALLETS_DIR/backup-source/wallet.dat" "$WALLETS_DIR/backup-copied/wallet.dat"
fi
log copy-loadwallet-source cli loadwallet backup-source
log copy-loadwallet-copy cli loadwallet backup-copied
check "original wallet loads again after the copy" ok copy-loadwallet-source
check "copied wallet.dat loads" ok copy-loadwallet-copy
check "copied wallet.dat has the same balance and addresses" same_wallet backup-source backup-copied

log backup-legacy-backupwallet cli -rpcwallet=legacy backupwallet "$DATADIR/manual-backups/legacy.dat"
log backup-legacy-restorewallet cli restorewallet legacy-restored "$DATADIR/manual-backups/legacy.dat"
check "backupwallet and restorewallet (legacy wallet)" ok backup-legacy-restorewallet
check "restored backup has the same balance and addresses (legacy wallet)" same_funds legacy legacy-restored

# Automatic backups: only legacy wallets, made when the wallet loads
section "Automatic backups (backup.rst)"
cli unloadwallet legacy >/dev/null
cli loadwallet legacy >/dev/null
cli unloadwallet backup-source >/dev/null
cli loadwallet backup-source >/dev/null
has_auto_backup() { compgen -G "$BACKUPS_DIR/$1.*" >/dev/null; }
check "loading a legacy wallet creates backups/legacy.<date>" has_auto_backup legacy
check "loading a descriptor wallet creates no automatic backup" eval '! has_auto_backup backup-source'

# ---- dash-wallet salvage (interface.rst) -------------------------------------
section "dash-wallet salvage (interface.rst)"
# The import-legacy wallet has imported keys with funds and an HD seed
cli -rpcwallet=import-legacy walletpassphrase "$WALLET_PASSPHRASE" 600
HD_BEFORE=$(cli -rpcwallet=import-legacy dumphdinfo | jq_py 'd["mnemonic"]')
HD_ADDR_BEFORE=$(cli -rpcwallet=import-legacy getnewaddress)
cli unloadwallet import-legacy >/dev/null
# Also check the "-wallet=<name>/wallet.dat" form on a copy
mkdir "$WALLETS_DIR/salvage-path"
cp "$WALLETS_DIR/import-legacy/wallet.dat" "$WALLETS_DIR/salvage-path/wallet.dat"
log salvage wallet_tool -wallet=import-legacy salvage
log salvage-path-form wallet_tool -wallet=salvage-path/wallet.dat salvage
has_salvage_bak() { compgen -G "$WALLETS_DIR/$1/wallet.dat.[0-9]*.bak" >/dev/null; }
check "dash-wallet -wallet=<name> salvage" ok salvage
check "salvage writes wallet.dat.<timestamp>.bak" has_salvage_bak import-legacy
check "dash-wallet -wallet=<name>/wallet.dat salvage" ok salvage-path-form
check "salvage writes wallet.dat.<timestamp>.bak (<name>/wallet.dat form)" has_salvage_bak salvage-path
log salvage-loadwallet cli loadwallet import-legacy
log salvage-rescan cli -rpcwallet=import-legacy rescanblockchain
check "salvaged wallet loads" ok salvage-loadwallet
check "salvaged wallet keeps the imported keys' funds after a rescan" same "$(balance import-legacy)" "$KEY_BALANCE"
cli -rpcwallet=import-legacy walletpassphrase "$WALLET_PASSPHRASE" 600
check "salvaged wallet keeps the HD mnemonic" same "$(cli -rpcwallet=import-legacy dumphdinfo | jq_py 'd["mnemonic"]')" "$HD_BEFORE"
# Salvage keeps only key, ckey, mkey, and hdchain records (src/wallet/salvage.cpp),
# not hdpubkey, so an HD legacy wallet loses its derived addresses. Not a
# docs claim, so it is a note, not a check.
if ! ismine import-legacy "$HD_ADDR_BEFORE"; then
  note "salvage drops HD-derived addresses (hdpubkey records); $HD_ADDR_BEFORE is no longer in the salvaged wallet. Restore the mnemonic to recover their funds."
fi
cli unloadwallet restore-plain >/dev/null
log salvage-descriptor wallet_tool -wallet=restore-plain salvage
check "salvage fails on a descriptor wallet" fails salvage-descriptor "Data is not in required format"

# ---- Migrate wallet (advanced.rst) -------------------------------------------
section "Migrate wallet (advanced.rst)"
LEGACY_BALANCE=$(balance legacy)
LEGACY_ADDRESSES=$(addresses legacy)
log migrate-nopass cli -named migratewallet wallet_name=legacy
check "migratewallet on an encrypted wallet needs the passphrase" fails migrate-nopass "passphrase"
log migrate cli -named migratewallet wallet_name=legacy passphrase="$WALLET_PASSPHRASE"
check "migratewallet with the passphrase" ok migrate
check "migrated wallet keeps its name and moves watch-only scripts to legacy_watchonly" true_in migrate 'd["wallet_name"] == "legacy" and d.get("watchonly_name") == "legacy_watchonly"'
BACKUP_PATH=$(out migrate | jq_py 'd["backup_path"]')
check "migration backup ending in .legacy.bak is in the wallet's directory" eval '[[ "$BACKUP_PATH" == "$WALLETS_DIR/legacy/"*.legacy.bak && -f "$BACKUP_PATH" ]]'
log migrate-getwalletinfo cli -rpcwallet=legacy getwalletinfo
check "migrated wallet is a descriptor wallet" true_in migrate-getwalletinfo 'd["descriptors"] and d["format"] == "sqlite"'
check "migrated wallet keeps its balance" same "$(balance legacy)" "$LEGACY_BALANCE"
check "migrated wallet keeps its addresses" same "$(addresses legacy)" "$LEGACY_ADDRESSES"
check "migrated wallet owns its first address" ismine legacy "$RESTORED_ADDR"
check "watch-only address is in legacy_watchonly" ismine legacy_watchonly "$WATCH_ADDR"
cli -rpcwallet=legacy walletpassphrase "$WALLET_PASSPHRASE" 600
log migrate-listdescriptors cli -rpcwallet=legacy listdescriptors true
check "migrated wallet keeps the HD mnemonic" mnemonic_in migrate-listdescriptors ""

# ---- Long mnemonic passphrases (advanced.rst) --------------------------------
section "-allow-deprecated-long-mnemonics (advanced.rst)"
stop_node || { echo "error: dashd did not stop" >&2; exit 1; }
start_node -allow-deprecated-long-mnemonics
P256=$(printf 'a%.0s' $(seq 1 256))
P257=$(printf 'a%.0s' $(seq 1 257))
log long-createwallet-249 cli createwallet long249 false true ""
log long-upgradetohd-249 cli -rpcwallet=long249 upgradetohd "$MNEMONIC" "$P249" ""
log long-createwallet-256 cli createwallet long256 false true ""
log long-upgradetohd-256 cli -rpcwallet=long256 upgradetohd "$MNEMONIC" "$P256" ""
log long-createwallet-257 cli createwallet long257 false true ""
log long-upgradetohd-257 cli -rpcwallet=long257 upgradetohd "$MNEMONIC" "$P257" ""
check "with the option, a 249-byte mnemonic passphrase is accepted" ok long-upgradetohd-249
check "with the option, a 256-byte mnemonic passphrase is accepted" ok long-upgradetohd-256
check "with the option, a 257-byte mnemonic passphrase is rejected" fails long-upgradetohd-257 "at most 256 bytes"

# ---- Result ------------------------------------------------------------------
echo "passed: $NPASS, failed: $NFAIL (details in $OUT_DIR/checks.txt)"
if (( NFAIL )); then
  echo "error: $NFAIL check(s) failed" >&2
  exit 1
fi
echo "done: all wallet recovery checks passed; output in $OUT_DIR"
