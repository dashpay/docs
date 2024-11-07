```{eval-rst}
.. _guide-features-instantsend:
.. meta::
  :title: InstantSend
  :description: Dash Core’s InstantSend feature provides a way to lock transaction inputs and enable secure, instantaneous transactions. 
```

# InstantSend

## Overview

Dash Core's [InstantSend](../resources/glossary.md#instantsend) feature provides a way to lock transaction [inputs](../resources/glossary.md#input) and enable secure, instantaneous [transactions](../resources/glossary.md#transaction). The [network](../resources/glossary.md#network) automatically attempts to upgrade any qualifying transaction to InstantSend without a need for the sending [wallet](../resources/glossary.md#wallet) to explicitly request it.

* To qualify for InstantSend, each transaction input must meet at least one of the following criteria:
  * Be locked by InstantSend
  * Be in a block that has a [ChainLock](../resources/glossary.md#chainlock)
  * Have at least the number [confirmations](../resources/glossary.md#confirmations) (block depth) indicated by the table below

| **Network** | **Confirmations Required** |
| --- | --- |
| Mainnet | 6 Blocks (normal transactions)<br>**100 Blocks (mining/masternode rewards)** |
| Testnet / Regtest / Devnet | 2 Blocks |

The introduction of the [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum) feature in Dash Core 0.14 provided a foundation to scale InstantSend. The transaction input locking process (and resulting network traffic) now occurs only within the quorum. This minimized network congestion since only the [`isdlock` message](../reference/p2p-network-instantsend-messages.md#isdlock) produced by the locking process is relayed to the entire Dash network. The lock message contains all the information necessary to verify a successful transaction lock.

## Deterministic InstantSend

Protocol version 70220 implemented deterministic InstantSend (see [DIP22](https://github.com/dashpay/dips/blob/master/dip-0022.md)) which added the `isdlock` message as a replacement for the `islock` message. The `islock` message was deprecated and fully removed in protocol version 70231.

## Management via Spork

:::{note}
Dash Core 21.0.0 [hardened all spork values on mainnet](https://github.com/dashpay/dash/blob/v21.0.0/doc/release-notes.md#mainnet-spork-hardening). The following information only relates to test networks where spork values can still be updated dynamically.
:::

Spork 2 (`SPORK_2_INSTANTSEND_ENABLED`) is used to manage InstantSend on test networks. [Spork](../resources/glossary.md#spork) 2 enables or disables the entire InstantSend feature. As of Dash Core 0.17.0, it also can be used to limit locking to transactions found in blocks.

In the event of a sustained overload of InstantSend, the spork can be set to a value of `1`. This mode enables a clean transition to fully disabling InstantSend without interfering with ChainLocks. In this mode masternodes will stop creating locks for new transactions when they enter the mempool and will only lock them once mined into a block. Once all existing locked transactions are mined into blocks, InstantSend can then be disabled by setting the spork value to `0` without disrupting ChainLocks.

## Mining Considerations

Note: A transaction will **not** be included in the block template (from the [`getblocktemplate` RPC](../api/remote-procedure-calls-mining.md#getblocktemplate)) unless it:

 1. Has been locked, or
 2. Has been in the mempool for >=10 minutes (`WAIT_FOR_ISLOCK_TIMEOUT`)

A [miner](../resources/glossary.md#miner) may still include any transaction, but [blocks](../resources/glossary.md#block) containing only locked transactions (or ones older than the timeout) should achieve a ChainLock faster. This is desirable to miners since it prevents any blockchain reorganizations that might orphan their block.

## InstantSend Data Flow

| **InstantSend Client** | **Direction**  | **Peers**   | **Description** |
| --- | :---: | --- | --- |
| [`tx` message](../reference/p2p-network-data-messages.md#tx)                | → |                         | Client sends InstantSend transaction
| **LLMQ Signing Sessions**   |   |                         | Quorums internally process locking |
|                             |   |                         | Quorum(s) responsible for the transaction's inputs lock the inputs via LLMQ signing sessions
|                             |   |                         | Once all inputs are locked, the quorum responsible for the overall transaction creates the transaction lock (`isdlock`) via an LLMQ signing session
| **LLMQ Results**             |   |                         | Quorum results broadcast to the network |
|                             | ← | [`inv` message](../reference/p2p-network-data-messages.md#inv) (isdlock)  | Quorum responds with lock inventory
| [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (isdlock)  | → |                         | Client requests lock message
|                             | ← | [`isdlock` message](../reference/p2p-network-instantsend-messages.md#isdlock)        | Quorum responds with lock message

Once a transaction lock is approved, the `instantlock` field of various RPCs is set to `true` (e.g. the [`getmempoolentry` RPC](../api/remote-procedure-calls-blockchain.md#getmempoolentry)).
