```{eval-rst}
.. meta::
  :title: Blockchain
  :description: Dash's blockchain acts as a timestamped public ledger, safeguarding against double spending and transaction record alteration.
```

# Blockchain

The blockchain provides Dash's public ledger, an ordered and timestamped record of transactions. This system is used to protect against double spending and modification of previous transaction records.

Each full node in the Dash network independently stores a blockchain containing only blocks validated by that node. When several nodes all have the same blocks in their blockchain, they are considered to be in [consensus](../resources/glossary.md#consensus). The validation rules these nodes follow to maintain consensus are called [consensus rules](../resources/glossary.md#consensus-rules). This section describes many of the consensus rules used by Dash Core.

```{toctree}
:maxdepth: 3

block-chain-block-chain-overview
block-chain-proof-of-work
block-chain-block-height-and-forking
block-chain-transaction-data
block-chain-consensus-rule-changes
```
