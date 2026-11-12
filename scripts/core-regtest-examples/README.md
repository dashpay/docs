# Dash Core Regtest Example Capture

This directory contains a tool to regenerate the examples on the [HTTP REST requests](../../docs/core/api/http-rest-requests.md) page from a real Dash Core node.

## Overview

`capture-rest-examples.sh`:

1. Starts a fresh, isolated regtest node (`-rest -txindex -server -listen=0 -disablewallet`)
2. Builds a small, deterministic chain and mempool (see [Chain Contents](#chain-contents))
3. Requests every REST endpoint shown on the page, in every format the page shows, plus the documented error cases
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
| 606 | Coinbase plus one confirmed transaction: spends the block 1 coinbase, pays 10 DASH to the recipient address and the change to the miner address. Used for the Block, Block/NoTxDetails, BlockHashByHeight, Headers, DeploymentInfo, Tx, and GetUtxos examples |
| 607-610 | Coinbase-only blocks (tip is 610, so block 606 has 5 confirmations) |
| Mempool | Parent: spends the block 2 coinbase, pays 5 DASH to the recipient address. Child: spends the parent's change output, pays 1 DASH to the recipient address. The child depends on the parent, so `depends` and `spentby` are populated |

Each example transaction pays a fee of 0.00001 DASH. The GetUtxos example queries the confirmed transaction's output 0 and the mempool parent's output 0 with `checkmempool`, so it shows both a confirmed UTXO and an unconfirmed one (height `2147483647`).

No masternodes or quorums exist, so `chainlock` and `instantlock` are always `false` and the CbTx merkle roots are all zeros.

## Output Files

| File | Endpoint |
|------|----------|
| `block.hex`, `block.json` | `/rest/block/<hash>` |
| `block-notxdetails.hex`, `block-notxdetails.json` | `/rest/block/notxdetails/<hash>` |
| `blockhashbyheight.hex`, `blockhashbyheight.json` | `/rest/blockhashbyheight/<height>` |
| `chaininfo.json` | `/rest/chaininfo` |
| `deploymentinfo.json`, `deploymentinfo-block.json` | `/rest/deploymentinfo` (tip and block 606) |
| `getutxos.hex`, `getutxos.json` | `/rest/getutxos/checkmempool/...` |
| `headers.hex`, `headers.json` | `/rest/headers/2/<hash>` (deprecated path form, still served) |
| `mempool-contents.json`, `mempool-contents-txids.json`, `mempool-contents-txids-sequence.json` | `/rest/mempool/contents` (default, `verbose=false`, and `verbose=false&mempool_sequence=true`) |
| `mempool-info.json` | `/rest/mempool/info` |
| `tx.hex`, `tx.json` | `/rest/tx/<txid>` |
| `error-*.txt` | Error responses documented on the page |

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
