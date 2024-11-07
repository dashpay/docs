```{eval-rst}
.. meta::
  :title: Dash Simplified Payment Verification (SPV)
  :description: Simplified Payment Verification (SPV) is a method used by lightweight clients to verify transactions without downloading the entire blockchain.
```

# Simplified Payment Verification (SPV)

An alternative approach detailed in the [original Bitcoin paper](https://bitcoin.org/en/bitcoin-paper) is a client that only downloads the [headers](../resources/glossary.md#header) of [blocks](../resources/glossary.md#block) during the initial syncing process and then requests [transactions](../resources/glossary.md#transaction) from full [nodes](../resources/glossary.md#node) as needed. This scales linearly with the height of the [block chain](../resources/glossary.md#block-chain) at only 80 bytes per block header, or up to 16.8MB per year, regardless of total block size.

As described in the white paper, the [merkle root](../resources/glossary.md#merkle-root) in the block header along with a merkle branch can prove to the SPV client that the transaction in question is embedded in a block in the block chain. This does not guarantee validity of the transactions that are embedded. Instead it demonstrates the amount of work required to perform a double-spend attack.

The block's depth in the block chain corresponds to the cumulative [difficulty](../resources/glossary.md#difficulty) that has been performed to build on top of that particular block. The SPV client knows the merkle root and associated transaction information, and requests the respective merkle branch from a full node. Once the merkle branch has been retrieved, proving the existence of the transaction in the block, the SPV client can then look to block *depth* as a proxy for transaction validity and security. The cost of an attack on a user by a malicious node who inserts an invalid transaction grows with the cumulative difficulty built on top of that block, since the malicious node alone will be mining this forged chain.

## Potential SPV Weaknesses

If implemented naively, an SPV client has a few important weaknesses.

First, while the SPV client can not be easily fooled into thinking a transaction is in a block when it is not, the reverse is not true. A full node can simply lie by omission, leading an SPV client to believe a transaction has not occurred. This can be considered a form of Denial of Service. One mitigation strategy is to connect to a number of full [nodes](../resources/glossary.md#node), and send the requests to each node. However this can be defeated by network partitioning or Sybil attacks, since identities are essentially free, and can be bandwidth intensive. Care must be taken to ensure the client is not cut off from honest nodes.

Second, the SPV client only requests transactions from full nodes corresponding to keys it owns. If the SPV client downloads all blocks and then discards unneeded ones, this can be extremely bandwidth intensive. If they simply ask full nodes for blocks with specific transactions, this allows full nodes a complete view of the public [addresses](../resources/glossary.md#address) that correspond to the user. This is a large privacy leak, and allows for tactics such as denial of service for clients, users, or addresses that are disfavored by those running full nodes, as well as trivial linking of funds. A client could simply spam many fake transaction requests, but this creates a large strain on the SPV client, and can end up defeating the purpose of thin clients altogether.

To mitigate the latter issue, Bloom filters have been implemented as a method of obfuscation and compression of block data requests.

## Bloom Filters

A [bloom filter](../resources/glossary.md#bloom-filter) is a space-efficient probabilistic data structure that is used to test membership of an element. The data structure achieves great data compression at the expense of a prescribed false positive rate.

A Bloom filter starts out as an array of n bits all set to 0. A set of k random hash functions are chosen, each of which output a single integer between the range of 1 and n.

When adding an element to the Bloom filter, the element is hashed k times separately, and for each of the k outputs, the corresponding Bloom filter bit at that index is set to 1.

Querying of the Bloom filter is done by using the same hash functions as before. If all k bits accessed in the bloom filter are set to 1, this demonstrates with high probability that the element lies in the set. Clearly, the k indices could have been set to 1 by the addition of a combination of other elements in the domain, but the parameters allow the user to choose the acceptable false positive rate.

Removal of elements can only be done by scrapping the bloom filter and re-creating it from scratch.

## Application Of Bloom Filters

Rather than viewing the false positive rates as a liability, it is used to create a tunable parameter that represents the desired privacy level and bandwidth trade-off. A SPV client creates their Bloom filter and sends it to a full node using the [`filterload` message](../reference/p2p-network-control-messages.md#filterload), which sets the filter for which transactions are desired. The [`filteradd` message](../reference/p2p-network-control-messages.md#filteradd) allows addition of desired data to the filter without needing to send a totally new Bloom filter, and the [`filterclear` message](../reference/p2p-network-control-messages.md#filterclear) allows the connection to revert to standard block discovery mechanisms. If the filter has been loaded, then full nodes will send a modified form of blocks, called a [merkle block](../resources/glossary.md#merkle-block). The merkle block is simply the block header with the merkle branch associated with the set Bloom filter.

An SPV client can not only add transactions as elements to the filter, but also [public keys](../resources/glossary.md#public-key), data from signature scripts and pubkey scripts, and more. This enables [P2SH](../resources/glossary.md#pay-to-script-hash) transaction finding.

If a user is more privacy-conscious, he can set the Bloom filter to include more false positives, at the expense of extra bandwidth used for transaction discovery. If a user is on a tight bandwidth budget, he can set the false-positive rate to low, knowing that this will allow full nodes a clear view of what transactions are associated with his client.

**Resources:** [DashJ](https://github.com/HashEngineering/dashj), a Java implementation of Dash based on BitcoinJ that uses the SPV security model and Bloom filters. Used in many Android wallets.

Bloom filters were standardized for use via [BIP37](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki). Review the BIP for implementation details.
