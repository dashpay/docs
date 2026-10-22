```{eval-rst}
.. meta::
  :title: Transaction Tutorial
  :description: This section explains using Dash Core's RPC interface to create transactions with different attributes, a common task for Dash applications. 
```

# Transaction Tutorial

Creating transactions is something most Dash applications do. This section describes how to use Dash Core's RPC interface to create transactions with various attributes.

Your applications may use something besides Dash Core to create transactions, but in any system, you will need to provide the same kinds of data to create transactions with the same attributes as those described below.

In order to use this tutorial, install and [configure Dash Core](../examples/configuration-file.md), then start a fresh [regression test mode](../resources/glossary.md#regression-test-mode) environment. Create a legacy wallet (the private-key examples below do not support descriptor wallets) and mine 101 blocks to obtain 500 DASH in spendable coinbase funds:

```shell
dashd -regtest -daemon
dash-cli -regtest -named createwallet wallet_name=tutorial descriptors=false
dash-cli -regtest -generate 101
dash-cli -regtest getbalance
```

The balance should be `500.00000000`. Use only this wallet while following the tutorials in order. All funds and private keys in these examples are for regtest only; never use them on mainnet.

Example output is illustrative and may differ between sections and Dash Core versions. Use the addresses, TXIDs, output indexes, amounts, keys, and transaction hex returned by your own node throughout. Values ending in `[...]` are abbreviated; use the full value, not the abbreviation.

```{toctree}
:maxdepth: 3
:titlesonly:
  
transaction-tutorial-simple-spending
transaction-tutorial-simple-raw-transaction
transaction-tutorial-complex-raw-transaction
transaction-tutorial-offline-signing
transaction-tutorial-p2sh-multisig
```
