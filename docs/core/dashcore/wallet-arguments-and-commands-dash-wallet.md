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

  -highsubsidyblocks=<n>
       The number of blocks with a higher than normal subsidy to mine at the
       start of a chain. Block after that height will have fixed subsidy
       base. (default: 0, devnet-only)

  -highsubsidyfactor=<n>
       The factor to multiply the normal block subsidy by while in the
       highsubsidyblocks window of a chain (default: 1, devnet-only)

  -llmqchainlocks=<quorum name>
       Override the default LLMQ type used for ChainLocks. Allows using
       ChainLocks with smaller LLMQs. (default: llmq_devnet,
       devnet-only)

  -llmqdevnetparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_DEVNET quorum (devnet-only)

  -llmqinstantsenddip0024=<quorum name>
       Override the default LLMQ type used for InstantSendDIP0024. (default:
       llmq_devnet_dip0024, devnet-only)

  -llmqmnhf=<quorum name>
       Override the default LLMQ type used for EHF. (default: llmq_devnet,
       devnet-only)

  -llmqplatform=<quorum name>
       Override the default LLMQ type used for Platform. (default:
       llmq_devnet_platform, devnet-only)

  -minimumdifficultyblocks=<n>
       The number of blocks that can be mined with the minimum difficulty at
       the start of a chain (default: 0, devnet-only)

  -powtargetspacing=<n>
       Override the default PowTargetSpacing value in seconds (default: 2.5
       minutes, devnet-only)

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
