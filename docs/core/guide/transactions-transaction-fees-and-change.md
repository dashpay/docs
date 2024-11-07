```{eval-rst}
.. meta::
  :title: Transaction Fees and Change
  :description: Transaction fees in Dash depend on transaction size and surplus from UTXOs is returned to the spender as a change output.
```

# Transaction Fees and Change

Transactions pay fees based on the total byte size of the signed transaction. Fees per byte are calculated based on current demand for space in mined blocks with fees rising as demand increases.  The [transaction fee](../resources/glossary.md#transaction-fee) is split between the miner (25%) and masternode (75%), as explained in the [block reward allocation section](https://docs.dash.org/en/stable/docs/user/introduction/features.html#block-reward-allocation). It is ultimately up to each [miner](../resources/glossary.md#miner) to choose the minimum transaction fee they will accept.

All transactions are prioritized based on their fee per byte, with higher-paying transactions being added in sequence until all of the available space is filled.

As of Dash Core 0.12.2.x, a [minimum relay fee](../resources/glossary.md#minimum-relay-fee) (1,000 [duffs](../resources/glossary.md#duffs) following [DIP1](https://github.com/dashpay/dips/blob/master/dip-0001.md) activation) is required to broadcast a transaction across the [network](../resources/glossary.md#network). Any transaction paying only the minimum fee should be prepared to wait a long time before there's enough spare space in a block to include it.

Since each transaction spends Unspent Transaction Outputs (UTXOs) and because a UTXO can only be spent once, the full value of the included UTXOs must be spent or given to a miner as a [transaction fee](../resources/glossary.md#transaction-fee).  Few people will have UTXOs that exactly match the amount they want to pay, so most transactions include a change output.

A [change output](../resources/glossary.md#change-output) is a regular output which spends the surplus duffs from the UTXOs back to the spender. Change outputs can reuse the same P2PKH pubkey hash or P2SH script hash as was used in the UTXO, but for the reasons described in the [next subsection](../guide/transactions-avoiding-key-reuse.md), it is highly recommended that change outputs be sent to a new [P2PKH](../resources/glossary.md#pay-to-pubkey-hash) or [P2SH](../resources/glossary.md#pay-to-script-hash) [address](../resources/glossary.md#address).
