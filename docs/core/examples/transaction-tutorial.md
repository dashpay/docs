```{eval-rst}
.. meta::
  :title: Transaction Tutorial
  :description: This section explains using Dash Core's RPC interface to create transactions with different attributes, a common task for Dash applications. 
```

# Transaction Tutorial

Creating transactions is something most Dash applications do. This section describes how to use Dash Core's RPC interface to create transactions with various attributes.

Your applications may use something besides Dash Core to create transactions, but in any system, you will need to provide the same kinds of data to create transactions with the same attributes as those described below.

## Setup

In order to use this tutorial, you will need to setup [Dash Core](https://www.dash.org/wallets/#wallets) and create a [regression test mode](../resources/glossary.md#regression-test-mode) environment with 500 DASH in your test wallet.

Some steps use RPCs that only work with legacy (non-descriptor) wallets, such as the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey). Create a legacy wallet for the tutorial before funding it:

``` bash
dash-cli -regtest -named createwallet wallet_name=tutorial descriptors=false load_on_startup=true
```

Legacy wallets require Dash Core built with Berkeley DB (BDB) support, which the release binaries include. If more than one wallet is loaded, add `-rpcwallet=tutorial` to the wallet commands in this tutorial.

:::{versionchanged} 24.0.0
New wallets are descriptor wallets by default, and `createwallet` requires `load_on_startup` whenever `descriptors` is specified.
:::

```{toctree}
:maxdepth: 3
:titlesonly:
  
transaction-tutorial-simple-spending
transaction-tutorial-simple-raw-transaction
transaction-tutorial-complex-raw-transaction
transaction-tutorial-offline-signing
transaction-tutorial-p2sh-multisig
```
