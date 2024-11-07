```{eval-rst}
.. meta::
  :title: Transaction Tutorial
  :description: This section explains using Dash Core's RPC interface to create transactions with different attributes, a common task for Dash applications. 
```

# Transaction Tutorial

Creating transactions is something most Dash applications do. This section describes how to use Dash Core's RPC interface to create transactions with various attributes.

Your applications may use something besides Dash Core to create transactions, but in any system, you will need to provide the same kinds of data to create transactions with the same attributes as those described below.

In order to use this tutorial, you will need to setup [Dash Core](https://www.dash.org/wallets/#wallets) and create a [regression test mode](../resources/glossary.md#regression-test-mode) environment with 500 DASH in your test wallet.

```{toctree}
:maxdepth: 3
:titlesonly:
  
transaction-tutorial-simple-spending
transaction-tutorial-simple-raw-transaction
transaction-tutorial-complex-raw-transaction
transaction-tutorial-offline-signing
transaction-tutorial-p2sh-multisig
```
