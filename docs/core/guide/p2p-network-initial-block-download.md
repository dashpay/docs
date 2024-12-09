```{eval-rst}
.. meta::
  :title: Initial Block Download
  :description: Initial block download (IBD) is the process where a full node downloads and validates all Dash blocks from the genesis block to the latest one to confirm transactions and recent blocks.
```

# Initial Block Download

Before a full [node](../resources/glossary.md#node) can validate unconfirmed transactions and recently-mined [blocks](../resources/glossary.md#block), it must download and validate all blocks from block 1 (the block after the hardcoded [genesis block](../resources/glossary.md#genesis-block)) to the current tip of the best [block chain](../resources/glossary.md#block-chain). This is the [initial block download](../resources/glossary.md#initial-block-download) (IBD) or initial sync.

Although the word "initial" implies this method is only used once, it can also be used any time a large number of blocks need to be downloaded, such as when a previously-caught-up node has been offline for a long time. In this case, a node can use the IBD method to download all the blocks which were produced since the last time it was online.

Dash Core uses the IBD method any time the last block on its local best block chain has a [block header](../resources/glossary.md#block-header) time more than 24 hours in the past. Dash Core will also perform IBD if its local best block chain is more than 144 blocks lower than its local best [header chain](../resources/glossary.md#header-chain) (that is, the local block chain is more than about 6 hours in the past).

## Blocks-First

Dash Core (up until version 0.12.0.x) uses a simple initial block download (IBD) method we'll call *blocks-first*. The goal is to download the blocks from the best block chain in sequence.

![Overview Of Blocks-First Method](../../img/dev/en-blocks-first-flowchart.svg)

The first time a node is started, it only has a single block in its local best block chain---the hardcoded genesis block (block 0).  This node chooses a remote [peer](../resources/glossary.md#peer), called the sync node, and sends it the [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks) illustrated below.

![First GetBlocks Message Sent During IBD](../../img/dev/en-ibd-getblocks.svg)

In the header hashes field of the [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks), this new node sends the header hash of the only block it has, the genesis block (`b67a...0000` in [internal byte order](../resources/glossary.md#internal-byte-order)).  It also sets the stop hash field to all zeroes to request a maximum-size response.

Upon receipt of the [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks), the sync node takes the first (and only) header hash and searches its local best block chain for a block with that header hash. It finds that block 0 matches, so it replies with 500 block [inventories](../resources/glossary.md#inventory) (the maximum response to a [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks)) starting from block 1. It sends these inventories in the [`inv` message](../reference/p2p-network-data-messages.md#inv) illustrated below.

![First Inv Message Sent During IBD](../../img/dev/en-ibd-inv.svg)

Inventories are unique identifiers for information on the [network](../resources/glossary.md#network). Each inventory contains a type field and the unique identifier for an instance of the object. For blocks, the unique identifier is a hash of the block's header.

The block inventories appear in the [`inv` message](../reference/p2p-network-data-messages.md#inv) in the same order they appear in the block chain, so this first [`inv` message](../reference/p2p-network-data-messages.md#inv) contains inventories for blocks 1 through 501. (For example, the hash of block 1 is `4343...0000` as seen in the illustration above.)

The IBD node uses the received inventories to request 128 blocks from the sync node in the [`getdata` message](../reference/p2p-network-data-messages.md#getdata) illustrated below.

![First GetData Message Sent During IBD](../../img/dev/en-ibd-getdata.svg)

It's important to [blocks-first](../resources/glossary.md#blocks-first-sync) nodes that the blocks be requested and sent in order because each block header references the header hash of the preceding block. That means the IBD node can't fully validate a block until its parent block has been received. Blocks that can't be validated because their parents haven't been received are called [orphan blocks](../resources/glossary.md#orphan-block); a subsection below describes them in more detail.

Upon receipt of the [`getdata` message](../reference/p2p-network-data-messages.md#getdata), the sync node replies with each of the blocks requested. Each block is put into [serialized block](../resources/glossary.md#serialized-block) format and sent in a separate [`block` message](../reference/p2p-network-data-messages.md#block). The first [`block` message](../reference/p2p-network-data-messages.md#block) sent (for block 1) is illustrated below.

![First Block Message Sent During IBD](../../img/dev/en-ibd-block.svg)

The IBD node downloads each block, validates it, and then requests the next block it hasn't requested yet, maintaining a queue of up to 128 blocks to download. When it has requested every block for which it has an inventory, it sends another [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks) to the sync node requesting the inventories of up to 500 more blocks.  This second [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks) contains multiple header hashes as illustrated below:

![Second GetBlocks Message Sent During IBD](../../img/dev/en-ibd-getblocks2.svg)

Upon receipt of the second [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks), the sync node searches its local best block chain for a block that matches one of the header hashes in the message, trying each hash in the order they were received. If it finds a matching hash, it replies with 500 block inventories starting with the next block from that point. But if there is no matching hash (besides the stopping hash), it assumes the only block the two nodes have in common is block 0 and so it sends an `inv` starting with block 1 (the same [`inv` message](../reference/p2p-network-data-messages.md#inv) seen several illustrations above).

This repeated search allows the sync node to send useful inventories even if the IBD node's local block chain forked from the sync node's local block chain. This [fork](../resources/glossary.md#fork) detection becomes increasingly useful the closer the IBD node gets to the tip of the block chain.

When the IBD node receives the second [`inv` message](../reference/p2p-network-data-messages.md#inv), it will request those blocks using [`getdata` messages](../reference/p2p-network-data-messages.md#getdata).  The sync node will respond with [`block` messages](../reference/p2p-network-data-messages.md#block).  Then the IBD node will request more inventories with another [`getblocks` message](../reference/p2p-network-data-messages.md#getblocks)---and the cycle will repeat until the IBD node is synced to the tip of the block chain.  At that point, the node will accept blocks sent through the regular block broadcasting described in a later subsection.

### Blocks-First Advantages & Disadvantages

The primary advantage of [blocks-first](../resources/glossary.md#blocks-first-sync) [IBD](../resources/glossary.md#initial-block-download) is its simplicity. The primary disadvantage is that the IBD node relies on a single sync node for all of its downloading. This has several implications:

* **Speed Limits:** All requests are made to the sync node, so if the sync node has limited upload bandwidth, the IBD node will have slow download speeds.  Note: if the sync node goes offline, Dash Core will continue downloading from another node---but it will still only download from a single sync node at a time.

* **Download Restarts:** The sync node can send a non-best (but otherwise valid) block chain to the IBD node. The IBD node won't be able to identify it as non-best until the initial block download nears completion, forcing the IBD node to restart its block chain download over again from a different node. Dash Core ships with several block chain checkpoints at various block heights selected by developers to help an IBD node detect that it is being fed an alternative block chain history---allowing the IBD node to restart its download earlier in the process.

* **Disk Fill Attacks:** Closely related to the download restarts, if the sync node sends a non-best (but otherwise valid) block chain, the chain will be stored on disk, wasting space and possibly filling up the disk drive with useless data.

* **High Memory Use:** Whether maliciously or by accident, the sync node can send blocks out of order, creating orphan blocks which can't be validated until their parents have been received and validated. Orphan blocks are stored in memory while they await validation, which may lead to high memory use.

All of these problems are addressed in part or in full by the headers-first IBD method used since Dash Core 0.12.0.x.

**Resources:** The table below summarizes the messages mentioned throughout this subsection. The links in the message field will take you to the reference page for that message.

| **Message** | [getblocks message](../reference/p2p-network-data-messages.md#getblocks) | [inv message](../reference/p2p-network-data-messages.md#inv)                             | [getdata message](../reference/p2p-network-data-messages.md#getdata)  | [block message](../reference/p2p-network-data-messages.md#block)
| --- | --- | --- | --- | --- |
| **From→To** | IBD→Sync                         | Sync→IBD                                         | IBD→Sync                      | Sync→IBD
| **Payload** | One or more header hashes        | Up to 500 block inventories (unique identifiers) | One or more block inventories | One serialized block

## Headers-First

Dash Core 0.12.0+ uses an [initial block download](../resources/glossary.md#initial-block-download) (IBD) method called *[headers-first](../resources/glossary.md#headers-first-sync)*. The goal is to download the [headers](../resources/glossary.md#header) for the best [header chain](../resources/glossary.md#header-chain), partially validate them as best as possible, and then download the corresponding [blocks](../resources/glossary.md#block) in parallel.  This solves several problems with the older [blocks-first](../resources/glossary.md#blocks-first-sync) IBD method.

![Overview Of Headers-First Method](../../img/dev/en-headers-first-flowchart.svg)

The first time a node is started, it only has a single block in its local best [block chain](../resources/glossary.md#block-chain)---the hardcoded [genesis block](../resources/glossary.md#genesis-block) (block 0).  The node chooses a remote [peer](../resources/glossary.md#peer), which we'll call the sync node, and sends it the [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders) illustrated below.

![First getheaders message](../../img/dev/en-ibd-getheaders.svg)

In the header hashes field of the [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders), the new node sends the header hash of the only block it has, the genesis block (`b67a...0000` in internal byte order).  It also sets the stop hash field to all zeroes to request a maximum-size response.

Upon receipt of the [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders), the sync node takes the first (and only) header hash and searches its local best block chain for a block with that header hash. It finds that block 0 matches, so it replies with 2,000 header (the maximum response) starting from block 1. It sends these header hashes in the [`headers` message](../reference/p2p-network-data-messages.md#headers) illustrated below.

![First headers message](../../img/dev/en-ibd-headers.svg)

The [IBD](../resources/glossary.md#initial-block-download) [node](../resources/glossary.md#node) can partially validate these block headers by ensuring that all fields follow [consensus rules](../resources/glossary.md#consensus-rules) and that the hash of the header is below the [target threshold](../resources/glossary.md#target) according to the nBits field.  (Full validation still requires all transactions from the corresponding block.)

After the IBD node has partially validated the block headers, it can do two things in parallel:

1. **Download More Headers:** the IBD node can send another [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders) to the sync node to request the next 2,000 headers on the best header chain. Those headers can be immediately validated and another batch requested repeatedly until a [`headers` message](../reference/p2p-network-data-messages.md#headers) is received from the sync node with fewer than 2,000 headers, indicating that it has no more headers to offer. A [headers](../resources/glossary.md#header) sync for 1 million blocks can be completed in 500 round trips, or about 80 MB of downloaded data.

    Once the IBD node receives a [`headers` message](../reference/p2p-network-data-messages.md#headers) with fewer than 2,000 headers from the sync node, it sends a [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders) to each of its outbound peers to get their view of best header chain. By comparing the responses, it can easily determine if the headers it has downloaded belong to the best header chain reported by any of its outbound peers. This means a dishonest sync node will quickly be discovered even if checkpoints aren't used (as long as the IBD node connects to at least one honest peer; Dash Core will continue to provide checkpoints in case honest peers can't be found).

2. **Download Blocks:** While the IBD node continues downloading headers, and after the headers finish downloading, the IBD node will request and download each [block](../resources/glossary.md#block). The IBD node can use the block header hashes it computed from the header chain to create [`getdata` messages](../reference/p2p-network-data-messages.md#getdata) that request the blocks it needs by their [inventory](../resources/glossary.md#inventory). It doesn't need to request these from the sync node---it can request them from any of its full node [peers](../resources/glossary.md#peer). (Although not all full nodes may store all blocks.) This allows it to fetch blocks in parallel and avoid having its download speed constrained to the upload speed of a single sync node.

    To spread the load between multiple peers, Dash Core will only request up to 16 blocks at a time from a single peer. Combined with its maximum of 8 outbound connections, this means Dash Core using headers-first will request a maximum of 128 blocks simultaneously during IBD (the same maximum number that blocks-first Dash Core requested from its sync node).

![Simulated Headers-First Download Window](../../img/dev/en-headers-first-moving-window.svg)

Dash Core's headers-first mode uses a 1,024-block moving download window to maximize download speed. The lowest-height block in the window is the next block to be validated; if the block hasn't arrived by the time Dash Core is ready to validate it, Dash Core will wait a minimum of two more seconds for the stalling node to send the block. If the block still hasn't arrived, Dash Core will disconnect from the stalling node and attempt to connect to another node. For example, in the illustration above, Node A will be disconnected if it doesn't send block 3 within at least two seconds.

Once the IBD node is synced to the tip of the block chain, it will accept blocks sent through the regular block broadcasting described in a later subsection.

**Resources:** The table below summarizes the messages mentioned throughout this subsection. The links in the message field will take you to the reference page for that message.

| **Message** | [getheaders message](../reference/p2p-network-data-messages.md#getheaders) | [headers message](../reference/p2p-network-data-messages.md#headers) | [getdata message](../reference/p2p-network-data-messages.md#getdata)                             | [block message](../reference/p2p-network-data-messages.md#block)
| --- | --- | --- | --- | --- |
| **From→To** | IBD→Sync                           | Sync→IBD                     | IBD→*Many*                                               | *Many*→IBD
| **Payload** | One or more header hashes          | Up to 2,000 block headers    | One or more block inventories derived from header hashes | One serialized block
