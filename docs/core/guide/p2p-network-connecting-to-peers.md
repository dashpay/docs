```{eval-rst}
.. meta::
  :title: Connecting to Peers
  :description: Connecting to a peer is done by sending a version message, which contains your version number, block, and current time to the remote node.
```

# Connecting to Peers

Connecting to a [peer](../resources/glossary.md#peer) is done by sending a [`version` message](../reference/p2p-network-control-messages.md#version), which contains your version number, block, and current time to the remote node. The remote node responds with its own [`version` message](../reference/p2p-network-control-messages.md#version). Then both nodes send a [`verack` message](../reference/p2p-network-control-messages.md#verack) to the other node to indicate the connection has been established.

Once connected, the client can send to the remote node `getaddr` and [`addr` messages](../reference/p2p-network-control-messages.md#addr) to gather additional peers.

In order to maintain a connection with a peer, nodes by default will send a [`ping` message](../reference/p2p-network-control-messages.md#ping) to peers every 2 minutes. If 20 minutes pass without a message being sent to or received from a peer, or without a response to a `ping` message, the client will assume that connection has closed. A peer is also disconnected if its send buffer stays full (sending paused) for 20 minutes.
