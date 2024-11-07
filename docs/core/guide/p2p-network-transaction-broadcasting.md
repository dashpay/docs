```{eval-rst}
.. meta::
  :title: Transaction Broadcasting
  :description: Transaction broadcasting is the process where a transaction is sent to peer nodes in the Dash network for validation and further propagation.
```

# Transaction Broadcasting

In order to send a [transaction](../resources/glossary.md#transaction) to a [peer](../resources/glossary.md#peer), an [`inv` message](../reference/p2p-network-data-messages.md#inv) is sent. If a [`getdata` message](../reference/p2p-network-data-messages.md#getdata) is received in reply, the transaction is sent using a [`tx` message](../reference/p2p-network-data-messages.md#tx). If it is a valid transaction, the peer receiving the transaction also forwards the transaction to its peers.

:::{note}
Dash Core 18.1.0 backported changes from Bitcoin to support block-only relay connections (specific connections that do not relay transaction information). This change was made to improve network topology and reduce information leaked by transaction relay. See the [Bitcoin pull request](https://github.com/bitcoin/bitcoin/pull/15759) for additional details.
:::

## Memory Pool

Full peers may keep track of unconfirmed transactions which are eligible to be included in the next [block](../resources/glossary.md#block). This is essential for miners who will actually mine some or all of those transactions, but it's also useful for any peer who wants to keep track of unconfirmed transactions, such as peers serving unconfirmed transaction information to SPV clients.

Because unconfirmed transactions have no permanent status in Dash, Dash Core stores them in non-persistent memory, calling them a memory pool or mempool. When a peer shuts down, its memory pool is lost except for any transactions stored by its wallet. This means that never-mined unconfirmed transactions tend to slowly disappear from the network as peers restart or as they purge some transactions to make room in memory for others.

Transactions which are mined into blocks that later become [stale blocks](../resources/glossary.md#stale-block) may be added back into the memory pool. These re-added transactions may be re-removed from the pool almost immediately if the replacement blocks include them. This is the case in Dash Core, which removes stale blocks from the chain one by one, starting with the tip (highest block). As each block is removed, its transactions are added back to the memory pool. After all of the stale blocks are removed, the replacement blocks are added to the chain one by one, ending with the new tip. As each block is added, any transactions it confirms are removed from the memory pool.

SPV clients don't have a memory pool for the same reason they don't relay transactions. They can't independently verify that a transaction hasn't yet been included in a block and that it only spends UTXOs, so they can't know which transactions are eligible to be included in the next block.
