```{eval-rst}
.. _reference-index:
.. meta::
  :title: Dash Core Introduction
  :description: The Developer Reference provides technical details for building Dash-based applications. 
```

# Introduction

The Developer Reference aims to provide technical details and API information to help you start building Dash-based applications, but it is not a specification. To make the best use of this documentation, you may want to install the current version of Dash Core, either from [source](https://www.github.com/dashpay/dash) or from a [pre-compiled executable](https://github.com/dashpay/dash/releases/latest).

Questions about Dash development are best asked in one of the [Dash development communities](https://www.dash.org/community/). Errors or suggestions related to documentation can be submitted as via the "Edit this page" button on the top, right of each page.

In the following documentation, some strings have been shortened or wrapped:
"`[...]`" indicates extra data was removed, and lines ending in a single backslash "\\" are continued below.

## Not A Specification

This Developer Documentation describes how Dash works to help educate new Dash developers, but it is not a specification---and it never will be.

Dash security depends on [consensus](../resources/glossary.md#consensus). Should your program diverge from consensus, its security is weakened or destroyed. The cause of the divergence doesn't matter: it could be a bug in your program, it could be an error in this documentation which you implemented as described, or it could be you do everything right but other software on the [network](../resources/glossary.md#network) [behaves unexpectedly](https://bitcoin.org/en/alert/2013-03-11-chain-fork) as in the case of Bitcoin's v0.8 chain fork. The specific cause will not matter to the users of your software whose wealth is lost.

The only correct specification of consensus behavior is the actual behavior of programs on the network which maintain consensus. As that behavior is subject to arbitrary inputs in a large variety of unique environments, it cannot ever be fully documented here or anywhere else.

In addition, we also warn you that this documentation has not been extensively reviewed by Dash experts and so likely contains numerous errors.
