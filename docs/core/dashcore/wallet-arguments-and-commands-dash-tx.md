```{eval-rst}
.. _dashcore-arguments-and-commands-dash-tx:
.. meta::
  :title: dash-tx Wallet Arguments and Commands
  :description: Command-line options for creating, parsing, or modifying transactions via dash-tx.
```

# dash-tx

The `dash-tx` application provides a command-line option for creating, parsing, or modifying transactions.

## Usage

```bash
Usage:
  dash-tx [options] <hex-tx> [commands]  Update hex-encoded dash transaction
  dash-tx [options] -create [commands]   Create hex-encoded dash transaction
```

### Options

```text
  -?
       Print this help message and exit

  -create
       Create new, empty TX.

  -json
       Select JSON output

  -txid
       Output only the hex-encoded transaction id of the resultant transaction.

  -version
       Print version and exit
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
  delin=N
       Delete input N from TX

  delout=N
       Delete output N from TX

  in=TXID:VOUT(:SEQUENCE_NUMBER)
       Add input to TX

  locktime=N
       Set TX lock time to N

  nversion=N
       Set TX version to N

  outaddr=VALUE:ADDRESS
       Add address-based output to TX

  outdata=[VALUE:]DATA
       Add data-based output to TX

  outmultisig=VALUE:REQUIRED:PUBKEYS:PUBKEY1:PUBKEY2:....[:FLAGS]
       Add Pay To n-of-m Multi-sig output to TX. n = REQUIRED, m = PUBKEYS.
       Optionally add the "S" flag to wrap the output in a
       pay-to-script-hash.

  outpubkey=VALUE:PUBKEY[:FLAGS]
       Add pay-to-pubkey output to TX. Optionally add the "S" flag to wrap the
       output in a pay-to-script-hash.

  outscript=VALUE:SCRIPT[:FLAGS]
       Add raw script output to TX. Optionally add the "S" flag to wrap the
       output in a pay-to-script-hash.

  sign=SIGHASH-FLAGS
       Add zero or more signatures to transaction. This command requires JSON
       registers:prevtxs=JSON object, privatekeys=JSON object. See
       signrawtransactionwithkey docs for format of sighash flags, JSON
       objects.
```

### Register Commands

```text
  load=NAME:FILENAME
       Load JSON file FILENAME into register NAME

  set=NAME:JSON-STRING
       Set register NAME to given JSON-STRING
```
