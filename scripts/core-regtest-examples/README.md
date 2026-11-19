# Dash Core Regtest Example Capture

This directory contains tools that run Dash Core examples from the docs on a real regtest node:

* `capture-rest-examples.sh` regenerates the examples on the [HTTP REST requests](../../docs/core/api/http-rest-requests.md) page.
* `run-transaction-tutorials.sh` runs the [transaction tutorials](../../docs/core/examples/transaction-tutorial.md) end to end (see [Transaction Tutorials](#transaction-tutorials)).
* `run-wallet-recovery-checks.sh` checks that the wallet backup, restore, and recovery commands in the user docs still work (see [Wallet Recovery Checks](#wallet-recovery-checks)).

## Overview

`capture-rest-examples.sh`:

1. Starts a fresh, isolated regtest node (`-rest -txindex -blockfilterindex=basic -server -listen=0 -disablewallet`)
2. Builds a small, deterministic chain and mempool (see [Chain Contents](#chain-contents))
3. Requests every REST endpoint shown on the page, in every format the page shows, plus several error cases
4. Writes each response to a named file in the output directory
5. Stops the node

Running the script twice with the same Dash Core build produces identical output, so a regenerated example only changes where Dash Core itself changed.

**Rule:** Examples on the REST page come from this script. Do not hand-edit hashes, amounts, or other output in those examples; change the script and regenerate instead. Trimming output (for example, truncating a long list) is fine if the page says so.

## Prerequisites

* **dashd** and **dash-cli** from the Dash Core version being documented
* **curl**
* **Python 3**: For JSON pretty-printing (no extra packages)
* **Bash**

## Usage

```bash
cd scripts/core-regtest-examples

# Required: directory containing dashd and dash-cli
DASH_BIN="$HOME/code/dash/src" ./capture-rest-examples.sh

# Choose the output directory
DASH_BIN="$HOME/dashcore-24.0.0/bin" OUT_DIR=/tmp/rest-24.0.0 ./capture-rest-examples.sh
```

**Configuration via Environment Variables**:

| Variable | Default | Description |
|----------|---------|-------------|
| `DASH_BIN` | (required) | Directory containing `dashd` and `dash-cli` |
| `OUT_DIR` | New temp dir | Where responses are written |
| `DATADIR` | New temp dir | Node data directory. Must be empty or not exist. A temp datadir is removed on exit |
| `KEEP_DATADIR` | `0` | Set to `1` to keep a temp datadir after the run |
| `P2P_PORT` | `26661` | P2P port (the node does not listen, but the port is set explicitly) |
| `RPC_PORT` | `26662` | RPC and REST port |

The default ports differ from the standard regtest ports (19899 P2P, 19898 RPC), so the script can run next to a normal regtest node. The docs show the standard regtest port (`curl http://localhost:19898/rest/...`); `manifest.tsv` lists each request in that form.

## Chain Contents

All coins are mined to and spent from a fixed, hard-coded **regtest-only** key. The keys are SHA-256 hashes of fixed labels and are public; never use them on mainnet or testnet.

| Height | Contents |
|--------|----------|
| 1-605 | Coinbase-only blocks paying the miner address. DIP0003, v20, and MN_RR activate at 432 and withdrawals at 600 (regtest `CRegTestParams` in `src/chainparams.cpp`), so later blocks carry a version 3 CbTx (`cbTx` in the JSON) |
| 606 | Coinbase plus one confirmed transaction: spends the block 1 coinbase, pays 10 DASH to the recipient address and the change to the miner address. Used for the Block, Block/NoTxDetails, BlockFilter, BlockFilterHeaders, BlockHashByHeight, Headers, DeploymentInfo, Tx, and GetUtxos examples |
| 607-610 | Coinbase-only blocks (tip is 610, so block 606 has 5 confirmations) |
| Mempool | Parent: spends the block 2 coinbase, pays 5 DASH to the recipient address. Child: spends the parent's change output, pays 1 DASH to the recipient address. The child depends on the parent, so `depends` and `spentby` are populated |

Each example transaction pays a fee of 0.00001 DASH. The GetUtxos example queries the confirmed transaction's output 0 and the mempool parent's output 0 with `checkmempool`, so it shows both a confirmed UTXO and an unconfirmed one (height `2147483647`).

No masternodes or quorums exist, so `chainlock` and `instantlock` are always `false` and the CbTx merkle roots are all zeros.

## Output Files

| File | Endpoint |
|------|----------|
| `block.hex`, `block.json` | `/rest/block/<hash>` |
| `block-notxdetails.hex`, `block-notxdetails.json` | `/rest/block/notxdetails/<hash>` |
| `blockfilter.hex`, `blockfilter.json` | `/rest/blockfilter/basic/<hash>` |
| `blockfilterheaders.hex`, `blockfilterheaders.json` | `/rest/blockfilterheaders/basic/<hash>?count=2` |
| `blockhashbyheight.hex`, `blockhashbyheight.json` | `/rest/blockhashbyheight/<height>` |
| `chaininfo.json` | `/rest/chaininfo` |
| `deploymentinfo.json`, `deploymentinfo-block.json` | `/rest/deploymentinfo` (tip and block 606) |
| `getutxos.hex`, `getutxos.json` | `/rest/getutxos/checkmempool/...` |
| `headers.hex`, `headers.json` | `/rest/headers/<hash>?count=2` |
| `headers-deprecated.hex`, `headers-deprecated.json` | `/rest/headers/2/<hash>` (deprecated path form, still served) |
| `mempool-contents.json`, `mempool-contents-txids.json`, `mempool-contents-txids-sequence.json` | `/rest/mempool/contents` (default, `verbose=false`, and `verbose=false&mempool_sequence=true`) |
| `mempool-info.json` | `/rest/mempool/info` |
| `tx.hex`, `tx.json` | `/rest/tx/<txid>` |
| `error-*.txt` | Error responses for several endpoints (not all are documented on the page) |

Each `.json` response also has a `.pretty.json` copy (2-space indentation, numbers kept exactly as the node wrote them), and each `.hex` response has a `.wrapped.txt` copy (64 characters per line with trailing `\`), matching how the docs show them.

Other files:

* `version.txt` - `dashd -version` first line
* `context.txt` - addresses, block hashes, and TXIDs used in the run
* `manifest.tsv` - each file with its HTTP status and the docs-form URL

## Determinism Notes

* The node starts with `-mocktime`, and each block is mined after `setmocktime` advances the clock by 150 seconds (block 1 is at `1767225600`, 2026-01-01 UTC). Block times, mempool entry times, and hashes are therefore fixed.
* Transactions are built with `createrawtransaction` and signed with `signrawtransactionwithkey`, which uses deterministic (RFC 6979) signatures. No wallet is loaded.
* Two consecutive runs on the same machine produced byte-identical output, including `size_on_disk` (ChainInfo) and `usage` (MemPool/Info).
* `size_on_disk` and `usage` depend on on-disk and in-memory layout, so they may differ between platforms or Dash Core builds even when everything else matches.
* Any change to the chain layout constants at the top of the script (start time, spacing, heights, fee, keys) changes every hash in the output. Change them only on purpose, and then regenerate every example on the page.

## Transaction Tutorials

`run-transaction-tutorials.sh` starts a fresh, isolated regtest node, creates the legacy wallet from the tutorial setup, and runs the equivalent of the commands on each transaction tutorial page in order: simple spending, simple raw transaction, complex raw transaction, offline signing, and P2SH multisig. Each step's output goes to a numbered file in the output directory, followed by an `exit=<status>` line. The script fails if any step other than offline signing step 5a (which is meant to fail) returns an error.

```bash
DASH_BIN="$HOME/code/dash/src" OUT_DIR=/tmp/tutorials ./run-transaction-tutorials.sh
```

It takes the same `DASH_BIN`, `OUT_DIR`, `DATADIR`, `KEEP_DATADIR`, `P2P_PORT` (default `26671`), and `RPC_PORT` (default `26672`) variables as `capture-rest-examples.sh`. Legacy wallets need Dash Core built with Berkeley DB support, which the release binaries include.

The output is not deterministic: the wallet creates new keys on every run, so addresses, keys, and TXIDs change. When you refresh a tutorial page, paste the output from a single run so that values the text refers to later (TXIDs, addresses, and amounts) stay consistent.

## Wallet Recovery Checks

`run-wallet-recovery-checks.sh` checks that the wallet backup, restore, and recovery commands in the user docs still work with a Dash Core build. Those pages show commands to type but no output, so the script captures no examples. It runs each command as the pages give it on a fresh, isolated regtest node, checks the result, and exits non-zero if any check fails. Run it when a new Dash Core release comes out. A failure usually means the release changed a command the docs rely on.

```bash
# Each run writes to a new temp directory
DASH_BIN="$HOME/code/dash/src" ./run-wallet-recovery-checks.sh

# Choose the output directory; it must be empty or not exist
DASH_BIN="$HOME/dashcore-24.0.0/bin" OUT_DIR=/tmp/wallet-recovery-24.0.0 ./run-wallet-recovery-checks.sh
```

`DASH_BIN` must also contain `dash-wallet`. The legacy wallet checks need Dash Core built with Berkeley DB support, which the release binaries include. A run takes about 15 seconds.

**Configuration via Environment Variables**:

| Variable | Default | Description |
|----------|---------|-------------|
| `DASH_BIN` | (required) | Directory containing `dashd`, `dash-cli`, and `dash-wallet` |
| `OUT_DIR` | New temp dir | Where output is written. Must be empty or not exist |
| `DATADIR` | `OUT_DIR/datadir` | Node data directory. Must be empty or not exist |
| `P2P_PORT` | `26701` | P2P port (the node does not listen, but the port is set explicitly) |
| `RPC_PORT` | `26702` | RPC port |

Unlike the other scripts in this directory, this one never deletes anything. It refuses to run in a non-empty `OUT_DIR` or `DATADIR`, so it cannot overwrite earlier output or touch an existing wallet. On exit it stops the node and keeps every file, so you can inspect the wallets after a failed check. Delete the run's directory when you no longer need it. A run uses about 30 MB, most of it the datadir.

What it checks:

| Page | Checks |
|------|--------|
| [advanced.rst](../../docs/user/wallets/dashcore/advanced.rst), Restore HD wallet | `createwallet "name" false true "password"` and `upgradetohd "mnemonic" "mnemonic passphrase" "wallet passphrase"`, with and without a wallet password and with a mnemonic passphrase. The first `getnewaddress` must be `yRd4FhXfVGHXpsuZXPNkMrfD9GVj46pnjt` for the BIP39 test mnemonic (`abandon ... about`), or `ya4hijmdfG9gtJHZoDWhedMYT8da2e3zu5` with the mnemonic passphrase `TREZOR`. The same restore into a legacy wallet. Mnemonic passphrases are limited to 248 bytes, or 256 bytes with `-allow-deprecated-long-mnemonics` (the node restarts for this check) |
| advanced.rst, View HD wallet information | `listdescriptors true` shows `mnemonic` and `mnemonicpassphrase`, and needs `walletpassphrase` on an encrypted wallet. `dumphdinfo` works on a legacy wallet and fails on a descriptor wallet |
| advanced.rst, Upgrade to HD | `upgradetohd "" "" <walletpassphrase>` gives a legacy non-HD wallet a new mnemonic and encrypts it, and fails on a descriptor wallet |
| advanced.rst, Migrate wallet | `migratewallet` on an encrypted legacy wallet needs the passphrase, keeps the wallet name, balance, addresses, and mnemonic, moves watch-only addresses to `<name>_watchonly`, and leaves a `.legacy.bak` backup in the wallet's directory |
| [recovery.rst](../../docs/user/wallets/recovery.rst), [paper.rst](../../docs/user/wallets/paper.rst) | On a descriptor wallet, `getdescriptorinfo "pkh(<WIF>)"` then `importdescriptors '[{"desc": "pkh(<WIF>)#<checksum>", "timestamp": 0}]'` imports a funded key and its balance appears; `importprivkey` fails. On a legacy wallet, `importprivkey <WIF>` does the same; `importdescriptors` fails. Both an uncompressed key (like the example on recovery.rst) and a compressed key are imported |
| [backup.rst](../../docs/user/wallets/dashcore/backup.rst) | `backupwallet` then `restorewallet`, for a descriptor and a legacy wallet, and copying `wallet.dat` of an unloaded wallet into a new wallet directory, give a wallet with the same balance and addresses. Loading a legacy wallet creates an automatic backup in `backups/`; loading a descriptor wallet does not |
| [interface.rst](../../docs/user/wallets/dashcore/interface.rst), salvage note | `dash-wallet -wallet=<name> salvage` and `-wallet=<name>/wallet.dat salvage` on a legacy wallet write `wallet.dat.<timestamp>.bak`, and the salvaged wallet loads with its imported keys' funds and its mnemonic. Salvage fails on a descriptor wallet |

All keys are public and regtest-only: the BIP39 test mnemonic, and a private key that is the SHA-256 hash of `dash-docs regtest paper wallet`. Never use them on mainnet or testnet.

Output in `OUT_DIR`:

* `NN-<step>.txt` - each command (first line, starting with `$`), its output, and an `exit=<status>` line. Commands that only set up the test (mining, funding) are not saved
* `checks.txt` - one `PASS` or `FAIL` line per check, grouped by page, plus `NOTE` lines
* `version.txt` - `dashd -version` first line
* `datadir/` - the node's data directory with all the test wallets (unless `DATADIR` is set)

The run is not deterministic: the node runs on the real clock and the miner wallet gets new keys each run, so TXIDs and the miner's addresses change. The checked addresses and balances are the same on every run.

`dash-wallet salvage` keeps only private key, encryption key, and HD chain records. On an HD legacy wallet it keeps the mnemonic and imported keys but drops the HD-derived addresses, so their funds do not show up until the mnemonic is restored. The script records this in a `NOTE` line instead of a check.
