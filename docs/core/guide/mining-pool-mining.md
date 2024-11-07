```{eval-rst}
.. meta::
  :title: Dash Pool Mining
  :description: A mining pool is a collective effort by miners to combine processing power, distribute rewards evenly based on work contributed, and increase chances of finding a block. 
```

# Pool Mining

Pool miners follow a similar workflow, illustrated below, which allows mining pool operators to pay miners based on their share of the work done. The mining pool gets new [transactions](../resources/glossary.md#transaction) from the network using `dashd`. Using one of the methods discussed later, each miner's mining software connects to the pool and requests the information it needs to construct block headers.

![Pooled Bitcoin Mining](../../img/dev/en-pooled-mining-overview.svg)

In pooled mining, the mining pool sets the [target threshold](../resources/glossary.md#target) a few orders of magnitude higher (less difficult) than the network difficulty. This causes the mining hardware to return many block headers which don't hash to a value eligible for inclusion on the [block chain](../resources/glossary.md#block-chain) but which do hash below the pool's target, proving (on average) that the miner checked a percentage of the possible hash values.

The [miner](../resources/glossary.md#miner) then sends to the pool a copy of the information the pool needs to validate that the header will hash below the target and that the block of transactions referred to by the header [merkle root](../resources/glossary.md#merkle-root) field is valid for the pool's purposes. (This usually means that the [coinbase transaction](../resources/glossary.md#coinbase-transaction) must pay the pool.)

The information the miner sends to the pool is called a share because it proves the miner did a share of the work. By chance, some shares the pool receives will also be below the network target---the mining pool sends these to the network to be added to the block chain.

The miner portion of the [block reward](../resources/glossary.md#block-reward) and [transaction  fees](../resources/glossary.md#transaction-fee) that come from mining that block are paid to the mining pool. The mining pool pays out a portion of these proceeds to individual miners based on how many shares they generated. For example, if the mining pool's target threshold is 100 times lower than the network target threshold, 100 shares will need to be generated on average to create a successful block, so the mining pool can pay 1/100th of its payout for each share received.  Different mining pools use different reward distribution systems based on this basic share system.
