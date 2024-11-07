```{eval-rst}
.. meta::
  :title: Masternode Quorums
  :description: Dash’s masternode quorums enable masternode-provided features to work in a decentralized, deterministic way. 
```

# Masternode Quorums

Dash's [masternode](../resources/glossary.md#masternode) quorums are used to facilitate the operation of masternode provided features in a decentralized, deterministic way. The original quorums (used largely for [InstantSend](../resources/glossary.md#instantsend) and masternode payments) were ephemeral and used for a single purpose (e.g. voting on one specific InstantSend transaction).

Dash Core 0.14 (protocol version 70214) introduced the [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum)  (LLMQ) system described in detail by [DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md). These LLMQs are deterministic subsets of the global deterministic masternode list that are formed via a distributed key generation (DKG) protocol and remain active for a long periods of time (e.g. hours to days).

The main task of LLMQs is to perform threshold signing of consensus-related messages (e.g. [ChainLocks](../resources/glossary.md#chainlock)).

## LLMQ Creation (DKG)

The following table details the data flow of P2P messages exchanged during the distributed key generation (DKG) protocol used to establish an LLMQ.

:::{note}
With the exception of the final step (`qfcommit` message broadcast), the message exchanges happen only between masternodes participating in the DKG process via the [Intra-Quorum communication process](https://github.com/dashpay/dips/blob/master/dip-0006.md#intra-quorum-communication) described in the DIP.
:::

*Quorum DKG Data Flow*

:::{attention}
Minimum Masternode Protocol Version Since Dash Core 0.16.0, masternodes perform a [version
check](https://github.com/dashpay/dash/pull/3390) on their quorum peers during DKG. Masternodes that
do not meet the `MIN_MASTERNODE_PROTO_VERSION` will begin receiving increases in
[PoSe](../guide/dash-features-proof-of-service.md) score once ~70% of the masternodes on the network
have upgraded to that version.
:::

| **Masternode** | **Direction**  | **Peers**   | **Description** |
| --- | :---: | --- | --- |
| **[Initialization Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#1-initialization-phase)**| | | **Deterministically evaluate if quorum participation necessary** |
| | | | Each quorum participant establishes connections to a set of quorum participants [as described in DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#building-the-set-of-deterministic-connections) |
| **[Contribution Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#2-contribution-phase)** | | | **Send quorum contributions (intra-quorum communication)** |
|`inv` message (qcontrib)                        | → |                              | Masternode sends inventory for its quorum contribution *to other masternodes in the quorum*
|                                                | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (qcontrib) | Peer(s) respond with request for quorum contribution
| [`qcontrib` message](../reference/p2p-network-quorum-messages.md#qcontrib)                             | → |                              | Masternode sends the requested quorum contribution
| **[Complaining Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#3-complaining-phase)** | | | **Send complaints for any peers with invalid or missing contributions (intra-quorum communication)** |
|`inv` message (qcomplaint)                      | → |                              | Masternode sends inventory for any complaints *to other masternodes in the quorum*
|                                                | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (qcomplaint) | Peer(s) respond with request for quorum complaints
| [`qcomplaint` message](../reference/p2p-network-quorum-messages.md#qcomplaint)                           | → |                              | Masternode sends the requested complaints
| **[Justification Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#4-justification-phase)** | | | **Send justification responses for any complaints against own contributions (intra-quorum communication)** |
|`inv` message (qjustify)                        | → |                              | Masternode sends inventory for any justifications *to other masternodes in the quorum*
|                                                | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (qjustify) | Peer(s) respond with request for quorum justifications
| [`qjustify` message](../reference/p2p-network-quorum-messages.md#qjustify)                             | → |                              | Masternode sends the requested justifications
| **[Commitment Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#5-commitment-phase)** | | | **Send premature commitment containing the quorum public key (intra-quorum communication)** |
|`inv` message (qpcommit)                        | → |                              | Masternode sends inventory for its premature commitment *to other masternodes in the quorum*
|                                                | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (qpcommit) | Peer(s) respond with request for quorum premature commitment
| [`qpcommit` message](../reference/p2p-network-quorum-messages.md#qpcommit)                             | → |                              | Masternode sends the requested premature commitment
| **[Finalization Phase](https://github.com/dashpay/dips/blob/master/dip-0006.md#6-finalization-phase)** | | | **Send final commitment containing the quorum public key** |
|`inv` message (qfcommit)                        | → |                              | Masternode sends inventory for its premature commitment **to all peers**
|                                                | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (qfcommit) | Peer(s) respond with request for quorum final commitment
| [`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit)                             | → |                              | Masternode sends the requested final commitment

## LLMQ Signing Session

The following table details the data flow of P2P messages exchanged during an LLMQ signing session. These sessions take advantage of BLS threshold signatures to enable quorums to sign arbitrary messages. For example, Dash Core 0.14 uses this capability to create the quorum signature found in the [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) that enables [ChainLocks](../resources/glossary.md#chainlock).

Please read [DIP7 LLMQ Signing Requests / Sessions](https://github.com/dashpay/dips/blob/master/dip-0007.md) for additional details.

*LLMQ Signing Session Data Flow*

| **Masternode** | **Direction**  | **Peers**   | **Description** |
| --- | :---: | --- | --- |
| **[Siging Request Phase](https://github.com/dashpay/dips/blob/master/dip-0007.md#signing-request)** | | | Request quorum signing of a message (e.g. InstantSend transaction input) (intra-quorum communication) |
| [`qsigsesann` message](../reference/p2p-network-quorum-messages.md#qsigsesann)                             | → |                              | Masternode sends a signing session announcement *to other masternodes in the quorum*
| **[Share Propagation Phase](https://github.com/dashpay/dips/blob/master/dip-0007.md#propagating-signature-shares)** | | | Members exchange signature shares within the quorum (intra-quorum communication) |
| [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv)                             | → |                              | Masternode sends one or more quorum signature share inventories *to other masternodes in the quorum*<br>*May occur multiple times in this phase*
|                                                | ← | [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs) (qcontrib) | Peer(s) respond with request for signature shares<br>*May occur multiple times in this phase*
| [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs)                             | → |                              | Masternode sends the requested batched signature share(s)<br>*May occur multiple times in this phase*
| **[Threshold Signature Recovery Phase](https://github.com/dashpay/dips/blob/master/dip-0007.md#recovered-threshold-signatures)** | | | A recovered signature is created by a quorum member once valid signature shares from at least the threshold number of members have been received |
| [`qsigrec` message](../reference/p2p-network-quorum-messages.md#qsigrec)                             | → |                              | Masternode sends the quorum recovered signature **to all peers** (except those that have asked to be excluded via a [`qsendrecsigs` message](../reference/p2p-network-quorum-messages.md#qsendrecsigs))

Note the following timeouts defined by Dash Core related to signing sessions:

| Parameter | Timeout, sec | Description |
| --- | --- | --- |
| `SESSION_NEW_SHARES_TIMEOUT` | 60 | Time to wait for new shares |
| `SIG_SHARE_REQUEST_TIMEOUT` | 5 | Time to wait for a requested share before requesting from a different node |
| `SESSION_TOTAL_TIMEOUT` | 300 | Time to wait for session to complete |

## Quorum Configuration

Mainnet and Testnet only use quorums of pre-defined sizes that are hard coded into Dash Core. RegTest and Devnet environments each have a quorum that supports custom size and threshold parameters that are controlled via command line or configuration file parameters (`llmqtestparams`/`llmqdevnetparams`).

A list of all the quorums and their default sizes can be found in the [Current LLMQ Types table](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md) found in DIP-6.

The specific quorum type used for a feature can vary based on the network. The following table shows which quorums are used for each feature on the various networks:

| | Mainnet | Testnet | Devnet * | RegTest * |
|-|-|-|-|-|
| ChainLocks ([DIP-8](https://github.com/dashpay/dips/blob/master/dip-0008.md)) | LLMQ_400_60 | LLMQ_50_60 | LLMQ_50_60 | LLMQ_TEST |
| Deterministic InstantSend | LLMQ_60_75 | LLMQ_60_75 | LLMQ_60_75 | LLMQ_TEST_DIP0024 |
| InstantSend (pre DIP-24) | LLMQ_50_60 | LLMQ_50_60 | LLMQ_50_60 | LLMQ_TEST_INSTANTSEND |
| Platform | LLMQ_100_67 | LLMQ_25_67 | LLMQ_100_67 | LLMQ_TEST_PLATFORM |
| Enhanced Hard Fork ([DIP-23](https://github.com/dashpay/dips/blob/master/dip-0023.md))| LLMQ_400_85 | LLMQ_50_60 | LLMQ_50_60 | LLMQ_TEST |

\* Note that the quorum types used on RegTest and Devnets have customizable parameters as described above

### Quorum formation

The quorum formation process operates regardless of quorum usage. So the [DKG process](#llmq-creation-dkg) will be attempted for *all quorum types enabled on a network* regardless of whether or not that quorum type is going to be used.

The following table showing which quorums are enabled for each network type is derived from information taken from Dash Core's [chainparams.cpp](https://github.com/dashpay/dash/blob/master/src/chainparams.cpp) file:

| Quorum type | Mainnet | Testnet | Devnet | RegTest |
|-|:-:|:-:|:-:|:-:|
| LLMQ_50_60 | x | x | x | - |
| LLMQ_60_75 | x | x | x | - |
| LLMQ_400_60 | x | x | x | - |
| LLMQ_400_85 | x | x | x | - |
| LLMQ_100_67 | x | x | x | - |
| LLMQ_25_67 | - | x | - | - |
| LLMQ_DEVNET | - | - | x | - |
| LLMQ_DEVNET_DIP0024 | - | - | x | - |
| LLMQ_DEVNET_PLATFORM | - | - | x | - |
| LLMQ_TEST | - | - | - | x |
| LLMQ_TEST_INSTANTSEND | - | - | - | x |
| LLMQ_TEST_V17 | - | - | - | x |
| LLMQ_TEST_DIP0024 | - | - | - | x |
| LLMQ_TEST_PLATFORM | - | - | - | x |
