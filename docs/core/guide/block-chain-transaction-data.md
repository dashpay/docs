```{eval-rst}
.. meta::
  :title: Transaction Data
  :description: Every block must include one or more transactions. The first one of these transactions must be a coinbase transaction which should collect and spend the block reward.
```

# Transaction Data

Every [block](../resources/glossary.md#block) must include one or more [transactions](../resources/glossary.md#transaction). The first one of these transactions must be a [coinbase transaction](../resources/glossary.md#coinbase-transaction), also called a generation transaction, which should collect and spend the [block reward](../resources/glossary.md#block-reward) (comprised of a block subsidy and any transaction fees paid by transactions included in this block).

The UTXO of a coinbase transaction has the special condition that it cannot be spent (used as an input) for at least 100 blocks. This temporarily prevents [miners](../resources/glossary.md#miner) and masternodes from spending the transaction fees and block reward from a block that may later be determined to be stale (and therefore the coinbase transaction destroyed) after a block chain [fork](../resources/glossary.md#fork).

Blocks are not required to include any non-coinbase transactions, but miners almost always do include additional transactions in order to collect their transaction fees.

All transactions, including the coinbase transaction, are encoded into blocks in binary [raw transaction](../resources/glossary.md#raw-transaction) format.

The rawtransaction format is hashed to create the transaction identifier ([TXID](../resources/glossary.md#transaction-identifiers)). From these txids, the [merkle tree](../resources/glossary.md#merkle-tree) is constructed by pairing each txid with one other txid and then hashing them together. If there are an odd number of txids, the txid without a partner is hashed with a copy of itself.

The resulting hashes themselves are each paired with one other hash and hashed together. Any hash without a partner is hashed with itself. The process repeats until only one hash remains, the [merkle root](../resources/glossary.md#merkle-root).

For example, if transactions were merely joined (not hashed), a five-transaction merkle tree would look like the following text diagram:

```
       ABCDEEEE .......Merkle root
      /        \
   ABCD        EEEE
  /    \      /
 AB    CD    EE .......E is paired with itself
/  \  /  \  /
A  B  C  D  E .........Transactions
```

As discussed in the [Simplified Payment Verification](../resources/glossary.md#simplified-payment-verification) (SPV) subsection, the merkle tree allows clients to verify for themselves that a transaction was included in a block by obtaining the merkle root from a [block header](../resources/glossary.md#block-header) and a list of the intermediate hashes from a full [peer](../resources/glossary.md#peer). The full peer does not need to be trusted: it is expensive to fake block headers and the intermediate hashes cannot be faked or the verification will fail.

For example, to verify transaction D was added to the block, an SPV client only needs a copy of the C, AB, and EEEE hashes in addition to the merkle root; the client doesn't need to know anything about any of the other transactions. If the five transactions in this block were all at the maximum size, downloading the entire block would require over 500,000 bytes---but downloading three hashes plus the block header requires only 140 bytes.

Note: If identical txids are found within the same block, there is a possibility that the merkle tree may collide with a block with some or all duplicates removed due to how unbalanced merkle trees are implemented (duplicating the lone hash). Since it is impractical to have separate transactions with identical txids, this does not impose a burden on honest software, but must be checked if the invalid status of a block is to be cached; otherwise, a valid block with the duplicates eliminated could have the same merkle root and block hash, but be rejected by the cached invalid outcome, resulting in security bugs such as [CVE-2012-2459](https://en.bitcoin.it/wiki/CVEs#CVE-2012-2459).
