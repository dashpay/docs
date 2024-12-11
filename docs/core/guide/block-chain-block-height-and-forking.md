```{eval-rst}
.. meta::
  :title: Block Height and Forking
  :description: In Dash, forks occur when multiple blocks of the same height are produced simultaneously, causing nodes to follow the longest chain. 
```

# Block Height and Forking

Any Dash [miner](../resources/glossary.md#miner) who successfully hashes a [block header](../resources/glossary.md#block-header) to a value below the [target threshold](../resources/glossary.md#target) can add the entire [block](../resources/glossary.md#block) to the [block chain](../resources/glossary.md#block-chain) (assuming the block is otherwise valid). These blocks are commonly addressed by their [block height](../resources/glossary.md#block-height)---the number of blocks between them and the first Dash block (block 0, most commonly known as the [genesis block](../resources/glossary.md#genesis-block)).

![Common And Uncommon Block Chain Forks](../../img/dev/en-blockchain-fork.svg)

Multiple blocks can all have the same block height, as is common when two or more miners each produce a block at roughly the same time. This creates an apparent [fork](../resources/glossary.md#fork) in the block chain, as shown in the illustration above.

When miners produce simultaneous blocks at the end of the block chain, each [node](../resources/glossary.md#node) individually chooses which block to accept. In the absence of other considerations, discussed below, nodes usually use the first block they see.

Eventually a miner produces another block which attaches to only one of the competing simultaneously-mined blocks. This makes that side of the fork stronger than the other side. Assuming a fork only contains valid blocks, normal [peers](../resources/glossary.md#peer) always follow the most difficult chain to recreate and throw away any [stale block](../resources/glossary.md#stale-block) belonging to shorter forks. (Stale blocks are also sometimes called orphans or orphan blocks, but those terms are also used for true orphan blocks without a known parent block.)

Long-term forks are possible if different miners work at cross-purposes, such as some miners diligently working to extend the block chain at the same time other miners are attempting a [51 percent attack](../resources/glossary.md#51-percent-attack) to revise transaction history.

Since multiple blocks can have the same height during a block chain fork, block height should not be used as a globally unique identifier. Instead, blocks are usually referenced by the hash of their header (often with the byte order reversed, and in hexadecimal).
