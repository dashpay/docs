```{eval-rst}
.. meta::
  :title: Proof of Work
  :description: Dash's proof of work relies on the unpredictability of cryptographic hashes, which generate a seemingly random number from any data, and any alteration in the data yields a new unpredictable number.
```

# Proof of Work

The [block chain](../resources/glossary.md#block-chain) is collaboratively maintained by anonymous [peers](../resources/glossary.md#peer) on the [network](../resources/glossary.md#network), so Dash requires that each [block](../resources/glossary.md#block) prove a significant amount of work was invested in its creation to ensure that untrustworthy peers who want to modify past blocks have to work harder than honest peers who only want to add new blocks to the block chain.

Chaining blocks together makes it impossible to modify [transactions](../resources/glossary.md#transaction) included in any block without modifying all following blocks. As a result, the cost to modify a particular block increases with every new block added to the block chain, magnifying the effect of the proof of work.

The [proof of work](../resources/glossary.md#proof-of-work) used in Dash takes advantage of the apparently random nature of cryptographic hashes. A good cryptographic hash algorithm converts arbitrary data into a seemingly-random number. If the data is modified in any way and the hash re-run, a new seemingly-random number is produced, so there is no way to modify the data to make the hash number predictable.

To prove you did some extra work to create a block, you must create a hash of the [block header](../resources/glossary.md#block-header) which does not exceed a certain value. For example, if the maximum possible hash value is <span class="math">2<sup>256</sup> − 1</span>, you can prove that you tried up to two combinations by producing a hash value less than <span class="math">2<sup>255</sup></span>.

In the example given above, you will produce a successful hash on average every other try. You can even estimate the probability that a given hash attempt will generate a number below the [target threshold](../resources/glossary.md#target). Dash assumes a linear probability that the lower it makes the target threshold, the more hash attempts (on average) will need to be tried.

New blocks will only be added to the block chain if their hash is at least as challenging as a [difficulty](../resources/glossary.md#difficulty) value expected by the [consensus](../resources/glossary.md#consensus) protocol. Every block, the network uses the difficulty of the last 24 blocks and number of seconds elapsed between generation of the first and last of those last 24 blocks. The ideal value is 3600 (one hour).

* If it took less than one hour to generate the 24 blocks, the expected difficulty value is increased so that the next 24 blocks should take exactly one hour to generate if hashes are checked at the same rate.

* If it took more than one hour to generate the blocks, the expected difficulty value is decreased for the same reason.

This method of calculating difficulty (Dark Gravity Wave) was authored by Dash creator Evan Duffield to fix exploits possible with the previously used Kimoto Gravity Well difficulty readjustment algorithm. For additional detail, reference this [Official Documentation Dark Gravity Wave page](https://docs.dash.org/en/stable/introduction/features.html#dark-gravity-wave).

Because each block header must hash to a value below the target threshold, and because each block is linked to the block that preceded it, it requires (on average) as much hashing power to propagate a modified block as the entire Dash network expended between the time the original block was created and the present time. Only if you acquired a majority of the network's hashing power could you reliably execute such a [51 percent attack](../resources/glossary.md#51-percent-attack) against transaction history (although, it should be noted, that even less than 50% of the hashing power still has a good chance of performing such attacks).

The block header provides several easy-to-modify fields, such as a dedicated nonce field, so obtaining new hashes doesn't require waiting for new transactions. Also, only the 80-byte block header is hashed for proof-of-work, so including a large volume of transaction data in a block does not slow down hashing with extra I/O, and adding additional transaction data only requires the recalculation of the ancestor hashes in the [merkle tree](../resources/glossary.md#merkle-tree).
