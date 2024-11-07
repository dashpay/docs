```{eval-rst}
.. meta::
  :title: Dash Mining Block Prototypes
  :description: Both solo and pool mining require mining software to gather information to build block headers, which is transmitted and utilized in a sequential manner. 
```

# Block Prototypes

In both solo and pool mining, the mining software needs to get the information necessary to construct block headers. This subsection describes, in a linear way, how that information is transmitted and used. However, in actual implementations, parallel threads and queuing are used to keep ASIC hashers working at maximum capacity,

## getwork RPC

The simplest and earliest method was the now-deprecated Dash Core `getwork` RPC, which constructed a [header](../resources/glossary.md#header) for the miner directly. Since a header only contains a single 4-byte nonce good for about 4 gigahashes, many modern miners need to make dozens or hundreds of `getwork` requests a second.

## getblocktemplate RPC

An improved method is the Dash Core [`getblocktemplate` RPC](../api/remote-procedure-calls-mining.md#getblocktemplate). This provides the mining software with much more information:

1. The information necessary to construct a [coinbase transaction](../resources/glossary.md#coinbase-transaction) paying the pool or the solo miner's `dashd` wallet.

2. A complete dump of the [transactions](../resources/glossary.md#transaction) `dashd` or the mining pool suggests including in the block, allowing the mining software to inspect the transactions, optionally add additional transactions, and optionally remove non-required transactions.

3. Other information necessary to construct a [block header](../resources/glossary.md#block-header) for the next [block](../resources/glossary.md#block): the block version, previous block hash, and bits (target).

4. The mining pool's current [target threshold](../resources/glossary.md#target) for accepting shares. (For solo miners, this is the network target.)

Using the transactions received, the mining software adds a nonce to the coinbase extra nonce field and then converts all the transactions into a [merkle tree](../resources/glossary.md#merkle-tree) to derive a [merkle root](../resources/glossary.md#merkle-root) it can use in a block header. Whenever the extra nonce field needs to be changed, the mining software rebuilds the necessary parts of the merkle tree and updates the time and merkle root fields in the block header.

Like all `dashd` RPCs, `getblocktemplate` is sent over HTTP. To ensure they get the most recent work, most miners use [HTTP longpoll](https://en.wikipedia.org/wiki/Push_technology#Long_polling) to leave a `getblocktemplate` request open at all times. This allows the mining pool to push a new `getblocktemplate` to the miner as soon as any [miner](../resources/glossary.md#miner) on the peer-to-peer [network](../resources/glossary.md#network) publishes a new block or the pool wants to send more transactions to the mining software.

## Stratum

A widely used alternative to `getblocktemplate` is the [Stratum mining protocol](http://mining.bitcoin.cz/stratum-mining). Stratum focuses on giving miners the minimal information they need to construct block headers on their own:

1. The information necessary to construct a coinbase transaction paying the pool.

2. The parts of the merkle tree which need to be re-hashed to create a new merkle root when the coinbase transaction is updated with a new extra nonce. The other parts of the merkle tree, if any, are not sent, effectively limiting the amount of data which needs to be sent to (at most) about a kilobyte at current transaction volume.

3. All of the other non-merkle root information necessary to construct a block header for the next block.

4. The mining pool's current target threshold for accepting shares.

Using the coinbase transaction received, the mining software adds a nonce to the coinbase extra nonce field, hashes the coinbase transaction, and adds the hash to the received parts of the merkle tree. The tree is hashed as necessary to create a merkle root, which is added to the block header information received. Whenever the extra nonce field needs to be changed, the mining software updates and re-hashes the coinbase transaction, rebuilds the merkle root, and updates the header merkle root field.

Unlike `getblocktemplate`, miners using Stratum cannot inspect or add transactions to the block they're currently mining. Also unlike `getblocktemplate`, the Stratum protocol uses a two-way TCP socket directly, so miners don't need to use HTTP longpoll to ensure they receive immediate updates from mining pools when a new block is broadcast to the peer-to-peer network.

**Resources:** The GPLv3 [BFGMiner](https://github.com/luke-jr/bfgminer) mining software and AGPLv3 [Eloipool](https://github.com/luke-jr/eloipool) mining pool software are widely-used among Bitcoin miners and pools. The [libblkmaker](https://github.com/bitcoin/libblkmaker) C library and [python-blkmaker](https://gitorious.org/bitcoin/python-blkmaker) library, both MIT licensed, can interpret GetBlockTemplate for your programs.
