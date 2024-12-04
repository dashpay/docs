```{eval-rst}
.. meta::
  :title: Misbehaving Nodes
  :description: Dash Core discourages peer nodes from sending false information by not immediately disconnecting but by prioritizing them for eviction, with no time-out or removal options.
```

# Misbehaving Nodes

:::{note}
Dash Core 18.1.0 introduced changes to how misbehaving peers are treated.
:::

Take note that for both types of broadcasting, mechanisms are in place to punish misbehaving [peers](../resources/glossary.md#peer) who take up bandwidth and computing resources by sending false information. Since Dash Core 18.1.0, peers that misbehave (e.g. send us invalid blocks) are referred to as discouraged nodes in log output. They are not strictly banned: incoming connections are still allowed from them, but they're preferred for eviction.

Furthermore, a few additional changes are introduced to how discouraged addresses are treated:

* Discouraging an address does not time out automatically after 24 hours (or the `-bantime` setting). Depending on traffic from other peers, discouragement may time out at an indeterminate time.

* Discouragement is not persisted over restarts.

* There is no method to list discouraged addresses. They are not returned by the [`listbanned` RPC](../api/remote-procedure-calls-network.md#listbanned).

* Discouragement cannot be removed with the [`setban remove` RPC](../api/remote-procedure-calls-network.md#setban) command. If you need to remove a discouragement, you can remove all discouragements by stopping and restarting your node.

 If a peer gets a banscore above the `-banscore=<n>` threshold (100 by default), they will be disconnected and discouraged.

| Type | Misbehavior | Ban Score | Description |
| ---- | ----------- | --------- | ----------- |
| Net | GetBlockTxn Index Error | **100** | Peer relayed a [`getblocktxn` message](../reference/p2p-network-data-messages.md#getblocktxn) with out-of-bound indices
| Net | Bloom Filter Service | **100** | Bloom filter message received from peer that has bloom filter commands disabled by default (protocol version > 70201) (`filterload` message, [`filteradd` message](../reference/p2p-network-control-messages.md#filteradd), or [`filterclear` message](../reference/p2p-network-control-messages.md#filterclear))
| Net | Block Rejected | 1 | Peer rejected the block it requested from us
| Net | Duplicate Version | 1 | Duplicate [`version` message](../reference/p2p-network-control-messages.md#version) received
| Net | Wrong Devnet | **100** | Peer responded with the wrong devnet version (`version` message)
| Net | Wrong Devnet | 1 | Peer connected using the wrong devnet version (`version` message)
| Net | No Version | 1 | Received a message prior to receiving a [`version` message](../reference/p2p-network-control-messages.md#version)
| Net | No Verack | 1 | After sending [`version` message](../reference/p2p-network-control-messages.md#version), received a message other than a [`verack` message](../reference/p2p-network-control-messages.md#verack) back first
| Net | Address List Size | 20 | More than 1000 addresses received (`addr` message)
| Net | Inventory List | 20 | More than `MAX_INV_SZ` (50000) inventories received (`inv` message)
| Net | Get Data Size | 20 | More than `MAX_INV_SZ` (50000) inventories requested (`getdata` message)
| Net | Orphan Transaction | **Varies** | Peer relayed an invalid orphan transaction. Ban score varies from 0-100 based on the specific reason (values set by `AcceptToMemoryPoolWorker()`)
| Net | Bad Transaction | **Varies** | Transaction rejected from the mempool
| Net | Invalid Header | **Varies** | Invalid block header received from peer (`cmpctblock` message)
| Net | Invalid CompactBlock | **100** | Invalid compact block /non-matching block transactions received from peer (`cmpctblock` message)
| Net | Header List Size | 20 | More than `MAX_HEADERS_RESULTS` (2000) headers received (`headers` message)
| Net | Header List Sequence | 20 | Non-continous headers sequence received (`headers` message)
| Net | Invalid Block | **Varies** | Invalid block header received from peer
| Net | Bloom Filter Size | **100** | Maximum script element size (520) exceeded (`filterload` message or [`filteradd` message](../reference/p2p-network-control-messages.md#filteradd))
| Net | MN List Diff | 1 | Failed to get masternode list diff (`getmnlistd` message)
| Net | Unrequested MN List Diff | **100** | Peer provided an unrequested masternode list diff (`mnlistdiff` message)
| InstantSend | Invalid Lock Message | **100** | Invalid TXID or inputs in lock message (`isdlock` message)
| InstantSend | Verify Error | 20 | Peer relayed a message that failed to verify
| LLMQ ChainLock | Invalid | 10 | Invalid ChainLock message (`clsig` message)
| LLMQ Commitment | Null QcTx | **100** | Peer relayed a block with a null commitment
| LLMQ Commitment | Invalid LLMQ Type | **100** | Peer relayed a block containing an invalid LLMQ Type
| LLMQ Commitment | Invalid Height | **100** | Peer relayed a block that is not the first block in the DKG interval
| LLMQ Commitment | Invalid Commitment | **100** | Peer relayed a block with an invalid quorum commitment
| LLMQ DKG | Empty Message | **100** | Peer relayed a message with no payload
| LLMQ DKG | Invalid LLMQ Type | **100** | Peer relayed a message for an incorrect LLMQ Type
| LLMQ DKG | Invalid Message | **100** | Peer relayed a message that could not be deserialized
| LLMQ DKG | Preverify Failed | **100** | Peer relayed a message that could not be pre-verified
| LLMQ DKG | Signature  | **100** | Peer relayed a message with an invalid signature
| LLMQ DKG | Full Verify Failed | **100** | Peer relayed a message that failed full verification
| LLMQ Signing | Too Many Messages | **100** | Maximum message count exceed in [`qsigsesann` message](../reference/p2p-network-quorum-messages.md#qsigsesann), [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv), [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs), or [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs)
| LLMQ Signing | Signature  | **100** | Peer relayed a message with an invalid recovered signature or signature share
| Masternode Authentication | Duplicate Message | **100** | Only 1 message allowed (`mnauth` message)
| Masternode Authentication | Invalid Services | **100** | Peer not advertising `NODE_NETWORK` or `NODE_BLOOM` services (`mnauth` message)
| Masternode Authentication | Empty Hash | **100** | Peer relayed a message with a null ProRegTx hash (`mnauth` message)
| Masternode Authentication | Signature | **100** | Peer relayed a message with an invalid signature (`mnauth` message)
| Masternode Authentication | Invalid MN | 10 | Peer not in the valid masternode list (`mnauth` message)
| Masternode Authentication | Invalid Signature | 10 | Signature verification failed (`mnauth` message)
| Governance | Sync | 20 | Requesting a governance sync too frequently (`govsync` message with empty hash)
| Governance | Invalid Object | 20 | Peer relayed an invalid governance object (`govobj` message)
| Governance | Invalid Vote | 20 | Peer relayed an invalid/invalid old vote(`govobjvote` message)
| Governance | Unsupported Vote Signal | 20 | Vote signal outside the accepted range (see [`govobjvote` message](../reference/p2p-network-governance-messages.md#govobjvote))
| CoinJoin | Signature  | 10 | Peer relayed a message with an invalid signature (`dsq` message)
| Spork | Invalid Time | **100** | Peer relayed a spork with a timestamp too far in the future (`spork` message)
| Spork | Signature  | **100** | Peer relayed a spork with an invalid signature (`spork` message)
