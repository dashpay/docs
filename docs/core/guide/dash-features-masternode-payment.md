```{eval-rst}
.. meta::
  :title: Masternode Payment
  :description: Masternode reward payments in Dash are determined by on-chain masternode lists in each block. 
```

# Masternode Payment

Since [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md) (introduced in Dash Core 0.13.0), [masternode](../resources/glossary.md#masternode) reward payments are based on the deterministic masternode list information found on-chain in each [block](../resources/glossary.md#block). This results in a transparent, deterministic process that operates using the [algorithm described in DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md#masternode-rewards).

On-chain masternode lists reduce the complexity of reward payments, make payments much more predictable, and also allow masternode payments to be enforced for all blocks (enforcement for superblocks was not possible in the previous system).

## Evolution Masternodes

Since Evolution masternodes (evonodes) have four times more collateral than regular masternodes, evonodes are paid in four consecutive blocks each time they are selected for payment. This is to maintain the same incentive structure that regular masternodes have.

Once Dash Platform is released, 37.5% of the masternode block subsidy will be moved into the Platform credit pool and used to pay evonodes. Both regular masternodes and evonodes will then receive a single reward payment on the Core chain per payment cycle. Evonodes will receive the remainder of their block rewards from Platform. Additionally, evonodes will receive 100% of the fees generated from Dash Platform since they are the only nodes that host it.
