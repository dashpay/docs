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
| Net | Bad Transaction | **Varies** | Transaction rejected from the mempool. Consensus failures score 100, including transactions that fail the DERSIG, NULLDUMMY, CHECKLOCKTIMEVERIFY, or CHECKSEQUENCEVERIFY script checks
| Net | Invalid Header | **Varies** | Invalid block header received from peer (`cmpctblock` message)
| Net | Invalid CompactBlock | **100** | Invalid compact block /non-matching block transactions received from peer (`cmpctblock` message)
| Net | Repeated Block Transactions | **100** | Peer sent block transactions for a compact block whose previous reconstruction attempt failed ([`blocktxn` message](../reference/p2p-network-data-messages.md#blocktxn))
| Net | Mutated Block | **100** | Peer relayed a mutated block (merkle root mismatch or 64-byte transaction malleation) ([`block` message](../reference/p2p-network-data-messages.md#block))
| Net | Header List Size | 20 | More than `MAX_HEADERS_RESULTS` (2000) headers received (`headers` message)
| Net | Header List Sequence | 20 | Non-continous headers sequence received (`headers` message)
| Net | Invalid Block | **Varies** | Invalid block header received from peer
| Net | Bloom Filter Size | **100** | Malformed or oversized bloom filter: more than 36,000 bytes or 50 hash functions ([`filterload` message](../reference/p2p-network-control-messages.md#filterload)), or a data element exceeding the maximum script element size (520) ([`filteradd` message](../reference/p2p-network-control-messages.md#filteradd))
| Net | Not Found List Size | 20 | More than `MAX_INV_SZ` (50000) entries received ([`notfound` message](../reference/p2p-network-data-messages.md#notfound))
| Net | MN List Diff | 1 | Failed to get masternode list diff (`getmnlistd` message). Not applied when the failure is caused by block data this node does not have (pruned or below an unvalidated snapshot base)
| Net | Unrequested MN List Diff | **100** | Peer provided an unrequested masternode list diff (`mnlistdiff` message)
| Net | Quorum Rotation Info | 1 | Failed to get quorum rotation info ([`getqrinfo` message](../reference/p2p-network-data-messages.md#getqrinfo)). Not applied when the failure is caused by block data this node does not have (pruned or below an unvalidated snapshot base)
| Net | Malformed Quorum Rotation Info Request | **100** | Peer relayed a malformed request, including one with more than 4096 base block hashes (`getqrinfo` message)
| Net | Unrequested Quorum Rotation Info | **100** | Peer provided unrequested quorum rotation info ([`qrinfo` message](../reference/p2p-network-data-messages.md#qrinfo))
| InstantSend | Invalid Lock Message | **100** | Invalid TXID or inputs in lock message (`isdlock` message)
| InstantSend | Verify Error | 20 | Peer relayed a message that failed to verify
| LLMQ ChainLock | Invalid | 10 | Invalid ChainLock message (`clsig` message)
| LLMQ ChainLock | Unrequested | 10 | Peer sent a ChainLock that was not requested from it ([`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig))
| LLMQ Commitment | Unrequested | 10 | Peer sent a final commitment that was not requested from it ([`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit))
| LLMQ Commitment | Stale Commitment | **100** | Peer with protocol version 70239 or higher relayed a commitment for a quorum more than one DKG interval old (`qfcommit` message)
| LLMQ Commitment | Null QcTx | **100** | Peer relayed a block with a null commitment
| LLMQ Commitment | Invalid LLMQ Type | **100** | Peer relayed a block containing an invalid LLMQ Type
| LLMQ Commitment | Invalid Height | **100** | Peer relayed a block that is not the first block in the DKG interval
| LLMQ Commitment | Invalid Commitment | **100** | Peer relayed a block with an invalid quorum commitment
| LLMQ DKG | Unrequested | 10 | Peer sent a DKG message that was not requested from it (e.g. [`qcontrib` message](../reference/p2p-network-quorum-messages.md#qcontrib))
| LLMQ DKG | Unverified Peer | 10 | Peer that is not a verified masternode relayed a DKG message
| LLMQ DKG | Empty Message | **100** | Peer relayed a message too short to contain the LLMQ type and quorum hash
| LLMQ DKG | Invalid LLMQ Type | **100** | Peer relayed a message for an incorrect LLMQ Type
| LLMQ DKG | Invalid Quorum Hash | **100** | Peer relayed a message whose quorum hash is a block with no parent block or is not a valid quorum base block
| LLMQ DKG | Invalid Message | **100** | Peer relayed a message that was oversized, malformed, or could not be deserialized
| LLMQ DKG | Preverify Failed | **100** | Peer relayed a message that could not be pre-verified
| LLMQ DKG | Signature  | **100** | Peer relayed a message with an invalid signature
| LLMQ DKG | Full Verify Failed | **100** | Peer relayed a message that failed full verification
| LLMQ Signing | Too Many Messages | **100** | Maximum message count exceed in [`qsigsesann` message](../reference/p2p-network-quorum-messages.md#qsigsesann), [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv), [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs), or [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs)
| LLMQ Signing | Signature  | **100** | Peer relayed a message with an invalid recovered signature or signature share
| LLMQ Quorum Data | Unauthorized Request | 10 | Request received by a node that is not a masternode, or from a peer that is neither a verified masternode nor a `qwatch` connection ([`qgetdata` message](../reference/p2p-network-quorum-messages.md#qgetdata))
| LLMQ Quorum Data | Oversized Request | **100** | Request payload larger than a valid request (`qgetdata` message)
| LLMQ Quorum Data | Invalid LLMQ Type | **100** | Request for an unknown LLMQ type (`qgetdata` message)
| LLMQ Quorum Data | Too Many Requests | 25 | More than 64 pending requests from one masternode, or a repeated request before the previous one expired (`qgetdata` message)
| LLMQ Quorum Data | Unauthorized Response | 10 | Response from a peer that is not a verified masternode, or received by a node that is neither a masternode nor watching quorums ([`qdata` message](../reference/p2p-network-quorum-messages.md#qdata))
| LLMQ Quorum Data | Unrequested Response | 10 | Response that was not requested, was already received, or does not match the request (`qdata` message)
| LLMQ Quorum Data | Invalid Data Size | **100** | Verification vector or encrypted contributions with the wrong number of entries (`qdata` message)
| LLMQ Quorum Data | Invalid Data | 10 | Invalid verification vector, contribution share, or resulting secret key share (`qdata` message)
| Masternode Authentication | Duplicate Message | **100** | Only 1 message allowed (`mnauth` message)
| Masternode Authentication | Invalid Services | **100** | Peer not advertising `NODE_NETWORK` or `NODE_BLOOM` services (`mnauth` message)
| Masternode Authentication | Empty Hash | **100** | Peer relayed a message with a null ProRegTx hash (`mnauth` message)
| Masternode Authentication | Signature | **100** | Peer relayed a message with an invalid signature (`mnauth` message)
| Masternode Authentication | Invalid MN | 10 | Peer not in the valid masternode list (`mnauth` message)
| Masternode Authentication | Invalid Signature | 10 | Signature verification failed (`mnauth` message)
| Governance | Sync | 20 | Requesting a governance sync too frequently (`govsync` message with empty hash), or repeatedly requesting votes for the same governance object that this node can sync (`govsync` message with an object hash and non-empty bloom filter)
| Governance | Invalid Sync Filter | **100** | Malformed or oversized bloom filter ([`govsync` message](../reference/p2p-network-governance-messages.md#govsync))
| Governance | Malformed Vote | **100** | Malformed vote, including a signature that is not 65 or 96 bytes ([`govobjvote` message](../reference/p2p-network-governance-messages.md#govobjvote))
| Governance | Invalid Object | 20 | Peer relayed an invalid governance object (`govobj` message)
| Governance | Invalid Vote | 20 | Peer relayed an invalid/invalid old vote(`govobjvote` message)
| Governance | Unsupported Vote Signal | 20 | Vote signal outside the accepted range (see [`govobjvote` message](../reference/p2p-network-governance-messages.md#govobjvote))
| CoinJoin | Signature  | 10 | Peer relayed a message with an invalid signature (`dsq` message)
| CoinJoin | Invalid DSTX | 10 | Peer relayed a CoinJoin broadcast transaction with an invalid structure or signature ([`dstx` message](../reference/p2p-network-privatesend-messages.md#dstx))
| CoinJoin | Unverifiable DSTX | 1 | Peer relayed a CoinJoin broadcast transaction from an unknown masternode, or one that is only valid under rules activating at the next block (`dstx` message)
| Spork | Invalid Time | **100** | Peer relayed a spork with a timestamp too far in the future (`spork` message)
| Spork | Signature  | **100** | Peer relayed a spork with an invalid signature (`spork` message)
| Spork | Malformed | **100** | Peer relayed a spork that could not be deserialized ([`spork` message](../reference/p2p-network-control-messages.md#spork))
| Platform | Unknown Masternode | 1 | Ban message references a ProTx hash not in the masternode list ([`platformban` message](../reference/p2p-network-masternode-messages.md#platformban))
| Platform | Invalid Node Type | **100** | Ban message references a masternode that is not an evonode (`platformban` message)
| Platform | Invalid Height | 1 | Requested height is up to 5 blocks outside the accepted range (576 blocks below the chain tip through the tip) (`platformban` message)
| Platform | Invalid Height | 10 | Requested height is more than 5 blocks outside the accepted range (`platformban` message)
| Platform | Unknown Quorum | **100** | Ban message references an unknown Platform quorum (`platformban` message)
| Platform | Signature | **100** | Ban message has an invalid quorum signature (`platformban` message)
