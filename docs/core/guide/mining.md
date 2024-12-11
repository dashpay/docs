```{eval-rst}
.. meta::
  :title: Dash Mining
  :description: Mining adds new blocks to the block chain, making transaction history hard to modify. Mining takes on two forms – Solo Mining and Pool Mining. 
```

# Mining

Mining adds new [blocks](../resources/glossary.md#block) to the [block chain](../resources/glossary.md#block-chain), making transaction history hard to modify.  Mining today takes on two forms:

* Solo mining, where the [miner](../resources/glossary.md#miner) attempts to generate new blocks on his own, with the proceeds from the mining portion of the [block reward](../resources/glossary.md#block-reward) and [transaction fees](../resources/glossary.md#transaction-fee) going entirely to himself, allowing him to receive large payments with a higher variance (longer time between payments)

* Pooled mining, where the miner pools resources with other miners to find blocks more often, with the proceeds being shared among the pool miners in rough correlation to the amount of hashing power they each contributed, allowing the miner to receive small payments with a lower variance (shorter time between payments).

```{toctree}
:maxdepth: 3

mining-solo-mining
mining-pool-mining
mining-block-prototypes
```
