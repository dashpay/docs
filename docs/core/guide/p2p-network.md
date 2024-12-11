```{eval-rst}
.. meta::
  :title: P2P Network
  :description: The Dash P2P network is a system where full nodes collaboratively maintain a network for block and transaction exchange, with some nodes storing the entire blockchain (archival nodes) and others only storing parts of it (pruned nodes).
```

# P2P Network

The Dash network protocol allows full [nodes](../resources/glossary.md#node) (peers) to collaboratively maintain a peer-to-peer [network](../resources/glossary.md#network) for [block](../resources/glossary.md#block) and [transaction](../resources/glossary.md#transaction) exchange. Full nodes download and verify every block and transaction prior to relaying them to other nodes. Archival nodes are full nodes which store the entire [block chain](../resources/glossary.md#block-chain) and can serve historical blocks to other nodes. Pruned nodes are full nodes which do not store the entire block chain. Many SPV clients also use the Dash network protocol to connect to full nodes.

Consensus rules do _not_ cover networking, so Dash programs may use alternative networks and protocols, such as the [high-speed block relay network](https://www.mail-archive.com/bitcoin-development@lists.sourceforge.net/msg03189.html) used by some miners and the [dedicated transaction information servers](https://github.com/spesmilo/electrum-server) used by some wallets that provide SPV-level security.

To provide practical examples of the Dash peer-to-peer network, this section uses Dash Core as a representative full node and [DashJ](https://github.com/HashEngineering/dashj) as a representative SPV client. Both programs are flexible, so only default behavior is described. Also, for privacy, actual IP addresses in the example output below have been replaced with [RFC5737](http://tools.ietf.org/html/rfc5737) reserved IP addresses.

```{toctree}
:maxdepth: 3
:titlesonly:

p2p-network-peer-discovery
p2p-network-connecting-to-peers
p2p-network-initial-block-download
p2p-network-block-broadcasting
p2p-network-transaction-broadcasting
p2p-network-misbehaving-nodes
```
