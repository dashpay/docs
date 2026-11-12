```{eval-rst}
.. _guide-features-chainlocks:
.. meta::
  :title: ChainLocks
  :description: Dash's ChainLock feature uses long-living masternode quorums to expedite transaction security and prevent 51% mining attacks. 
```

# ChainLocks

Dash's [ChainLock](../resources/glossary.md#chainlock) feature leverages [LLMQ](../resources/glossary.md#long-living-masternode-quorum) Signing Requests/Sessions to reduce uncertainty when receiving funds and remove the possibility of 51% mining attacks.

For each block, an LLMQ of a few hundred [masternodes](../resources/glossary.md#masternode) (300-400) is selected and each participating member signs the first [block](../resources/glossary.md#block) that it sees extending the active chain at the current [block height](../resources/glossary.md#block-height). If enough members (at least 240) see the same block as the first block, they will be able to create a [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) and propagate it to all [nodes](../resources/glossary.md#node) in the [network](../resources/glossary.md#network).

If a valid [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) is received by a node, it must reject all blocks (and any descendants) at the same height that do not match the block specified in the [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig). This makes the decision on the active chain quick, easy and unambiguous. It also makes reorganizations below this block impossible.

A node that missed a [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) can recover the ChainLock from the ChainLock signature that miners include in the coinbase transaction ([CbTx](../reference/transactions-special-transactions.md#cbtx)) of later blocks.

With LLMQ-based [InstantSend](../resources/glossary.md#instantsend), a ChainLock is only attempted once each [transaction](../resources/glossary.md#transaction) in the block (and in any recent blocks that are not yet ChainLocked) is either locked via InstantSend or was first seen by the masternode at least 10 minutes earlier. If a block contains unlocked transactions, masternodes attempt to establish retroactive InstantSend locks for them prior to a ChainLock. Provider transactions (e.g., ProRegTx and ProUpServTx) are never locked via InstantSend, so a block containing one may wait up to about 10 minutes for its ChainLock unless the provider transaction was first seen at least 10 minutes earlier.

ChainLocks have been active on the Dash network since block <a href="https://insight.dash.org/insight/block/00000000000000112e41e4b3afda8b233b8cc07c532d2eac5de097b68358c43e" target="_blank">1088640</a> in June of 2019. Please read [DIP8 ChainLocks](https://github.com/dashpay/dips/blob/master/dip-0008.md) for additional details.
