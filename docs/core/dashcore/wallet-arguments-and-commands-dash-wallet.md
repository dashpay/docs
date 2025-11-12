```{eval-rst}
.. _dashcore-arguments-and-commands-dash-wallet:
.. meta::
  :title: dash-wallet Arguments and Commands
  :description: The dash-wallet application is an offline tool for creating and interacting with Dash Core wallet files.
```

# dash-wallet

The `dash-wallet` application is an offline tool for creating and interacting with Dash Core wallet files. By default dash-wallet will act on wallets in the default mainnet wallet directory in the datadir. To change the target wallet, use the `-datadir`, `-wallet` and `-testnet`/`-regtest` arguments.

## Usage

```bash
Usage:
  dash-wallet [options] <command>
```

### Options

```text

  -?
       Print this help message and exit

  -datadir=<dir>
       Specify data directory

  -descriptors
       Create descriptors wallet. Only for 'create'

  -dumpfile=<file name>
       When used with 'dump', writes out the records to this file. When used
       with 'createfromdump', loads the records into a new wallet.

  -format=<format>
       The format of the wallet file to create. Either "bdb" or "sqlite". Only
       used with 'createfromdump'

  -usehd
       Create HD (hierarchical deterministic) wallet (default: 1)

  -version
       Print version and exit

  -wallet=<wallet-name>
       Specify wallet name

```

### Debugging/Testing options

```text

  -debug=<category>
       Output debugging information (default: 0).

  -printtoconsole
       Send trace/debug info to console (default: 1 when no -debug is true, 0
       otherwise).

```

### Chain selection options

```text

  -chain=<chain>
       Use the chain <chain> (default: main). Allowed values: main, test,
       regtest

  -devnet=<name>
       Use devnet chain with provided name

  -testnet
       Use the test chain. Equivalent to -chain=test

```

### Commands

```text

  create
       Create new wallet file

  createfromdump
       Create new wallet file from dumped records

  dump
       Print out all of the wallet key-value records

  info
       Get wallet info

  salvage
       Attempt to recover private keys from a corrupt wallet. Warning:
       'salvage' is experimental.

  wipetxes
       Wipe all transactions from a wallet
```
