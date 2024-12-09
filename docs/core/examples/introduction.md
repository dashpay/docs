```{eval-rst}
.. _examples-index:
.. meta::
  :title: Dash Core Examples Introduction
  :description: The following guide aims to provide examples to help you start building Dash-based applications. 
```

# Introduction

The following guide aims to provide examples to help you start building Dash-based applications. To make the best use of this document, you may want to install the current version of Dash Core, either from [source](https://github.com/dashpay/dash/) or from a [pre-compiled executable](https://www.dash.org/wallets/#wallets).

Once installed, you'll have access to three programs: `dashd`, `dash-qt`, and `dash-cli`.

* `dash-qt` provides a combination full Dash [peer](../resources/glossary.md#peer) and [wallet](../resources/glossary.md#wallet) frontend. From the Help menu, you can access a console where you can enter the RPC commands used throughout this document.

* `dashd` is more useful for programming: it provides a full peer which you can interact with through RPCs to port 9998 (or 19998 for [testnet](../resources/glossary.md#testnet) / 19898 for regtest).

* `dash-cli` allows you to send RPC commands to `dashd` from the command line.  For example, `dash-cli help`
