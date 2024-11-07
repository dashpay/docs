```{eval-rst}
.. _examples-testing-applications:
.. meta::
  :title: Testing Applications
  :description: Dash Core provides several network options designed to let developers test their applications with reduced risks and limitations.
```

# Testing Applications

Dash Core provides several network options designed to let developers test their applications with reduced risks and limitations.

## Testnet

When run with no arguments, all Dash Core programs default to Dash's main network ([mainnet](../resources/glossary.md#mainnet)). However, for development, it's safer and cheaper to use Dash's test network ([testnet](../resources/glossary.md#testnet)) where the [duffs](../resources/glossary.md#duffs) spent have no real-world value. Testnet also relaxes some restrictions (such as standard transaction checks) so you can test functions which might currently be disabled by default on [mainnet](../resources/glossary.md#mainnet).

To use testnet, use the argument `-testnet` with `dash-cli`, `dashd` or `dash-qt` or add `testnet=1` to your `dash.conf` file as [described earlier](../examples/configuration-file.md).  To get free duffs for testing, check the faucets listed below. Some are community supported and due to potentially frequent Testnet changes, one or more of them may be unavailable at a given time:

* [Testnet Faucet - Dash Core Group](https://testnet-faucet.dash.org/)
* [Testnet Faucet - Crowdnode.io](http://faucet.test.dash.crowdnode.io/)

Testnet is a public resource provided for free by Dash Core Group and members of the community, so please don't abuse it.

## Regtest mode

For situations where interaction with random [peers](../resources/glossary.md#peer) and [blocks](../resources/glossary.md#block) is unnecessary or unwanted, Dash Core's [regression test mode](../resources/glossary.md#regression-test-mode) (regtest mode) lets you instantly create a brand-new private [block chain](../resources/glossary.md#block-chain) with the same basic rules as testnet---but one major difference: you choose when to create new blocks, so you have complete control over the environment.

Many developers consider regtest mode the preferred way to develop new applications. The following example will let you create a regtest environment after you first [configure dashd](../examples/configuration-file.md).

``` bash
> dashd -regtest -daemon
Dash Core server starting
```

Start `dashd` in regtest mode to create a private block chain.

``` text
## Dash Core
dash-cli -regtest generate 101
```

Generate 101 blocks using a special RPC which is only available in regtest mode. This takes less than a second on a generic PC. Because this is a new block chain using Dash's default rules, the first blocks pay a [block reward](../resources/glossary.md#block-reward) of 500 dash.  Unlike [mainnet](../resources/glossary.md#mainnet), in regtest mode only the first 150 blocks pay a reward of 500 dash. However, a block must have 100 [confirmations](../resources/glossary.md#confirmations) before that reward can be spent, so we generate 101 blocks to get access to the [coinbase transaction](../resources/glossary.md#coinbase-transaction) from block #1.

``` bash
dash-cli -regtest getbalance
500.00000000
```

Verify that we now have 500 dash available to spend.

You can now use Dash Core RPCs prefixed with `dash-cli -regtest`.

Regtest wallets and block chain state (chainstate) are saved in the `regtest` subdirectory of the Dash Core configuration directory. You can safely delete the `regtest` subdirectory and restart Dash Core to start a new regtest. (See the [Developer Examples Introduction](../examples/introduction.md) for default configuration directory locations on various operating systems. **Always back up mainnet wallets before performing dangerous operations such as deleting**.)

The complete set of regtest-specific arguments can be found on the [`dashd` Arguments and  Commands page](../dashcore/wallet-arguments-and-commands-dashd.md#regtest-options).

## Devnet mode

### Overview

Developer networks (devnets) have some aspects of testnet and some aspects of regtest. Unlike testnet, multiple independent devnets can be created and coexist without interference. Devnets can consist of nodes running on the same computer, on a small private network, or distributed across the internet.

Each devnet is identified by a name which is hardened into a "devnet genesis" block that is automatically positioned at height 1. Validation rules ensure that a [node](../resources/glossary.md#node) from `devnet=test1` will not accept blocks from `devnet=test2`. This is done by checking the expected devnet [genesis block](../resources/glossary.md#genesis-block). Also, the devnet name is put into the sub-version field of the [`version` message](../reference/p2p-network-control-messages.md#version). If a node connects to the wrong [network](../resources/glossary.md#network), it will immediately be disconnected.

The genesis block of the devnet is the same as the one from regtest. This starts the devnet with a very low [difficulty](../resources/glossary.md#difficulty), allowing quick generation of a sufficient balance to create a [masternode](../resources/glossary.md#masternode).

### Configuration

To use devnet, use the argument `-devnet=<name>` with `dash-cli`, `dashd`or `dash-qt` or add `devnet=<name>` to your `dash.conf` file as [described earlier](../examples/configuration-file.md).

Devnets must be assigned both `-port` and `-rpcport` unless they are not listening (`-listen=0`). It is possible to run a devnet on a private (RFC1918) network by using the `-allowprivatenet=1` argument.

Example devnet start command:

``` bash
> dashd -devnet=mydevnet -rpcport=18998 -port=18999 -daemon
Dash Core server starting
```

#### Devnet-specific options

Devnets can use 3 devnet-specific options to enable quickly mining large amounts of Dash. This enables quick establishment of test masternodes, etc. The following `dash.conf` excerpt shows these configuration options in use:

```
# First 1000 blocks mined with the lowest difficulty (like regtest)
# and first 500 blocks mined with a block subsidity multiplied by 10
# This allows immediate MN registration (DIP3 activates on block 2)
minimumdifficultyblocks=1000
highsubsidyblocks=500
highsubsidyfactor=10
```

The complete set of devnet-specific arguments can be found on the [`dashd` Arguments and  Commands page](../dashcore/wallet-arguments-and-commands-dashd.md#devnet-options).

### Management

Devnet wallets and block chain state (chainstate) are saved in the `devnet-<name>` subdirectory of the Dash Core configuration directory. You can safely delete the `devnet-<name>` subdirectory and restart Dash Core to start a new devnet. (See the [Developer Examples Introduction](../examples/introduction.md) for default configuration directory locations on various operating systems. **Always back up mainnet wallets before performing dangerous operations such as deleting.**)

An old devnet can be easily dropped and a new one started just by destroying all nodes and recreating them with a new devnet name. This works best in combination with an automated deployment using something like Ansible and Terraform. The [Dash Network Deploy](https://github.com/dashevo/dash-network-deploy) tool provides a way to do this.

## Network type comparison

Each network type has some unique characteristics to support development and testing. The tables below summarize some of the significant differences between the 4 network types.

### Network characteristics

|  | Mainnet | [Testnet](#testnet) | [Regtest](#regtest-mode) | [Devnet](#devnet-mode) |
|-|-|-|-|-|
| Public network | Yes | Yes | No | Optional |
| Private network | No | No | Yes | Optional |
| Number of networks | 1 | 1 | Unlimited | Unlimited / Unique (named) |

:::{note}
To enable or disable sporks on a regtest or devnet, set `sporkaddr` and `sporkkey` in the `dash.conf` config file. Any valid Dash address / private key can be used. You can get an address using the [`getnewaddress` RPC](../api/remote-procedure-calls-wallet.md#getnewaddress) and retrieve its private key using the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
:::

### Mining characteristics

| Network Type | Difficulty adjustment algorithm |
|-|-|
| [Testnet](#testnet) | Mainnet algorithm, but [allows minimum difficulty blocks](https://github.com/dashpay/dash/blob/v0.17.0.3/src/pow.cpp#L142-L146) if no blocks are created for 5 minutes |
| [Regtest](#regtest-mode) | Mines blocks at the [minimum difficulty level](https://github.com/dashpay/dash/blob/v0.17.0.3/src/chainparams.cpp#L925) |
| [Devnet](#devnet-mode) | Mainnet algorithm after [4001 blocks](https://github.com/dashpay/dash/blob/v0.17.0.3/src/chainparams.cpp#L749) unless overridden by [devnet-specific options](#devnet-specific-options) |

:::{note}
See [chainparams.cpp](https://github.com/dashpay/dash/blob/master/src/chainparams.cpp) for details on other differences
:::
