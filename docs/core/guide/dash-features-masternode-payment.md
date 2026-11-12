```{eval-rst}
.. meta::
  :title: Masternode Payment
  :description: Masternode reward payments in Dash are determined by on-chain masternode lists in each block. 
```

# Masternode Payment

Since [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md) (introduced in Dash Core 0.13.0), [masternode](../resources/glossary.md#masternode) reward payments are based on the deterministic masternode list information found on-chain in each [block](../resources/glossary.md#block). This results in a transparent, deterministic process that operates using the [algorithm described in DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md#masternode-rewards).

On-chain masternode lists reduce the complexity of reward payments, make payments much more predictable, and also allow masternode payments to be enforced for all blocks (enforcement for superblocks was not possible in the previous system).

After the v24 hard fork activates, each expected masternode payment and superblock payment must be matched by its own output in the coinbase transaction. A single coinbase output can no longer satisfy two identical expected payments.

## Multi-Party Payouts

After the v24 hard fork activates, a masternode owner can split the owner reward (the masternode reward minus any operator reward) across 1 to 8 payout addresses. Each payout address is assigned a portion of the owner reward in basis points, with the last payout address receiving any remainder from rounding. Each payout is a separate coinbase output. The operator reward is not affected. Payout addresses are set by a version 3 [ProRegTx](../reference/transactions-special-transactions.md#proregtx) or [ProUpRegTx](../reference/transactions-special-transactions.md#proupregtx). See the [Payout Share Structure](../reference/transactions-special-transactions.md#payout-share-structure) for details.

## Shared Masternodes

After the v24 hard fork activates, the collateral of a masternode can be funded jointly by 2 to 8 participants (a [shared masternode](../reference/transactions-special-transactions.md#shared-masternode-registration)). The owner reward of a shared masternode is split among the participants in proportion to each participant's collateral contribution, with the last participant receiving any remainder from rounding. Each portion is paid to the participant's reward address, or to their refund address if no reward address is set. The operator reward is not affected.

## Evolution Masternodes

Since Evolution masternodes (evonodes) have four times more collateral than regular masternodes, evonodes are paid in four consecutive blocks each time they are selected for payment. This is to maintain the same incentive structure that regular masternodes have.

Once Dash Platform is released, 37.5% of the masternode block subsidy will be moved into the Platform credit pool and used to pay evonodes. Both regular masternodes and evonodes will then receive a single reward payment on the Core chain per payment cycle. Evonodes will receive the remainder of their block rewards from Platform. Additionally, evonodes will receive 100% of the fees generated from Dash Platform since they are the only nodes that host it.

Evonodes cannot use [multi-party payouts](#multi-party-payouts) or [shared collateral](#shared-masternodes) until the separate `evo_shares` deployment activates.
