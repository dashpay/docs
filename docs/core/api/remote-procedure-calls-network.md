```{eval-rst}
.. meta::
  :title: Network RPCs
  :description: A list of all network connection related remote procedure calls in Dash Core.
```

# Network RPCs

## AddNode

The [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) attempts to add or remove a node from the addnode list, or to try a connection to a node once.

*Parameter #1---hostname/IP address and port of node to add or remove*

| Name   | Type   | Presence                | Description |
| ------ | ------ | ----------------------- | ----------- |
| `node` | string | Required<br>(exactly 1) | The node to add as a string in the form of `<IP address>:<port>`. |

*Parameter #2---whether to add or remove the node, or to try only once to connect*

| Name      | Type   | Presence                | Description |
| --------- | ------ | ----------------------- | ----------- |
| `command` | string | Required<br>(exactly 1) | What to do with the IP address above.  Options are:<br>• `add` to add a node to the addnode list.  Up to 8 nodes can be added additional to the default 8 nodes. Not limited by `-maxconnections`<br>• `remove` to remove a node from the list.  If currently connected, this will disconnect immediately<br>• `onetry` to immediately attempt connection to the node even if the outgoing connection slots are full; this will only attempt the connection once |

*Parameter #3---v2 transport*

| Name   | Type   | Presence                | Description |
| ------ | ------ | ----------------------- | ----------- |
| `v2transport` | bool | Optional<br>(0 or1) | Attempt to connect using BIP324 v2 transport protocol (ignored for `remove` command). Default=set by `-v2transport` option. |

_Result---`null` plus error on failed remove_

| Name     | Type | Presence                | Description |
| -------- | ---- | ----------------------- | ----------- |
| `result` | null | Required<br>(exactly 1) | Always JSON `null` whether the node was added, removed, tried-and-connected, or tried-and-not-connected.  The JSON-RPC error field will be set only if you try adding a node that was already added or removing a node that is not on the addnodes list |

*Example from Dash Core 0.12.2*

Try connecting to the following node.

```bash
dash-cli -testnet addnode 192.0.2.113:19999 onetry
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [GetAddedNodeInfo](../api/remote-procedure-calls-network.md#getaddednodeinfo): returns information about the given added node, or all added nodes (except onetry nodes). Only nodes which have been manually added using the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) will have their information displayed.

## AddPeerAddress

:::{attention}
This RPC is for testing only.
:::

The [`addpeeraddress` RPC](../api/remote-procedure-calls-network.md#addpeeraddress) adds the address
of a potential peer to the address manager.

*Parameter #1---IP address of node to add*

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `address` | string | Required<br>(exactly 1) | The IP address of the peer |

*Parameter #2---port of the node to add*

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `port` | number | Required<br>(exactly 1) | The port of the peer |

*Parameter #3---add to tried address table*

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `tried` | bool | Optional<br>(0 or 1) | If true, attempt to add the peer to the tried addresses table |

*Result---a list of added nodes*

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `result`          | object | Required<br>(exactly 1) | An object describing if the address was successfully added |
| →<br>`success`    | bool   | Required<br>(exactly 1) | Whether the peer address was successfully added to the address manager |

*Example from Dash Core 20.0.0*

Try connecting to the following node.

```bash
dash-cli addpeeraddress "1.2.3.4" 9999
```

Result:

```json
{
  "success": true
}
```

*See also: none*

## ClearBanned

*Added in Bitcoin Core 0.12.0*

The [`clearbanned` RPC](../api/remote-procedure-calls-network.md#clearbanned) clears list of banned nodes.

*Parameters: none*

_Result---`null` on success_

| Name     | Type | Presence                | Description                           |
| -------- | ---- | ----------------------- | ------------------------------------- |
| `result` | null | Required<br>(exactly 1) | JSON `null` when the list was cleared |

*Example from Dash Core 0.12.2*

Clears the ban list.

```bash
dash-cli clearbanned
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [ListBanned](../api/remote-procedure-calls-network.md#listbanned): lists all manually banned IPs/Subnets.
* [SetBan](../api/remote-procedure-calls-network.md#setban): attempts add or remove a IP/Subnet from the banned list.
* [ClearDiscouraged](../api/remote-procedure-calls-network.md#cleardiscouraged): clears list of discouraged nodes.

## ClearDiscouraged

*Added in Dash Core 19.0.0*

The [`cleardiscouraged` RPC](../api/remote-procedure-calls-network.md#cleardiscouraged) clears all discouraged nodes.

*Parameters: none*

_Result---`null` on success_

| Name     | Type | Presence                | Description                           |
| -------- | ---- | ----------------------- | ------------------------------------- |
| `result` | null | Required<br>(exactly 1) | JSON `null` when the list was cleared |

*Example from Dash Core 19.0.0*

Clears the ban list.

```bash
dash-cli cleardiscouraged
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [ListBanned](../api/remote-procedure-calls-network.md#listbanned): lists all manually banned IPs/Subnets.
* [ClearBanned](../api/remote-procedure-calls-network.md#clearbanned): clears list of banned nodes.
* [SetBan](../api/remote-procedure-calls-network.md#setban): attempts add or remove a IP/Subnet from the banned list.

## DisconnectNode

*Added in Bitcoin Core 0.12.0*

The [`disconnectnode` RPC](../api/remote-procedure-calls-network.md#disconnectnode) immediately disconnects from a specified node.

*Parameter #1---hostname/IP address and port of node to disconnect*

| Name      | Type   | Presence                | Description                                                                                                                    |
| --------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `address` | string | Required<br>(exactly 1) | The node you want to disconnect from as a string in the form of `<IP address>:<port>`.<br><br>*Updated in Bitcoin Core 0.14.1* |

*Parameter #2---nodeid*

| Name   | Type   | Presence | Description                                  |
| ------ | ------ | -------- | -------------------------------------------- |
| nodeid | number | Optional | The node ID (see `getpeerinfo` for node IDs) |

_Result---`null` on success or error on failed disconnect_

| Name     | Type | Presence                | Description                                |
| -------- | ---- | ----------------------- | ------------------------------------------ |
| `result` | null | Required<br>(exactly 1) | JSON `null` when the node was disconnected |

*Example from Dash Core 0.15.0*

Disconnects following node by address.

```bash
dash-cli -testnet disconnectnode 192.0.2.113:19999
```

Result (no output from `dash-cli` because result is set to `null`).

Disconnects following node by id.

```bash
dash-cli -testnet disconnectnode "" 3
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [AddNode](../api/remote-procedure-calls-network.md#addnode): attempts to add or remove a node from the addnode list, or to try a connection to a node once.
* [GetAddedNodeInfo](../api/remote-procedure-calls-network.md#getaddednodeinfo): returns information about the given added node, or all added nodes (except onetry nodes). Only nodes which have been manually added using the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) will have their information displayed.

## GetAddedNodeInfo

The [`getaddednodeinfo` RPC](../api/remote-procedure-calls-network.md#getaddednodeinfo) returns information about the given added node, or all added nodes (except onetry nodes). Only nodes which have been manually added using the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) will have their information displayed.

*Parameter #1---what node to display information about*

| Name   | Type   | Presence             | Description                        |
| ------ | ------ | -------------------- | ---------------------------------- |
| `node` | string | Optional<br>(0 or 1) | The node to get information about in the same `<IP address>:<port>` format as the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode).  If provided, return information about this specific node, otherwise all nodes are returned. |

*Result---a list of added nodes*

| Name                   | Type   | Presence                | Description                         |
| ---------------------- | ------ | ----------------------- | ----------------------------------- |
| `result`               | array  | Required<br>(exactly 1) | An array containing objects describing each added node.  If no added nodes are present, the array will be empty.  Nodes added with `onetry` will not be returned |
| →<br>Added Node        | object | Optional<br>(0 or more) | An object containing details about a single added node |
| → →<br>`addednode`     | string | Required<br>(exactly 1) | An added node in the same `<IP address>:<port>` format as used in the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode). |
| → →<br>`connected`     | bool   | Optional<br>(0 or 1)    | This will be set to `true` if the node is currently connected and `false` if it is not |
| → →<br>`addresses`     | array  | Optional<br>(0 or 1) | This will be an array of addresses belonging to the added node. Only present when `connected` is `true` |
| → → →<br>Address       | object | Optional<br>(0 or more) | An object describing one of this node's addresses |
| → → → →<br>`address`   | string | Required<br>(exactly 1) | An IP address and port number of the node.  If the node was added using a DNS address, this will be the resolved IP address |
| → → → →<br>`connected` | string | Required<br>(exactly 1) | Whether or not the local node is connected to this addnode using this IP address.  Valid values are:<br>• `false` for not connected<br>• `inbound` if the addnode connected to us<br>• `outbound` if we connected to the addnode |

*Example from Dash Core 21.0.0*

```bash
dash-cli getaddednodeinfo
```

Result (real hostname and IP address replaced with [RFC5737](http://tools.ietf.org/html/rfc5737) reserved address):

```json
[
  {
    "addednode": "192.0.2.113:19999",
    "connected": true,
    "addresses": [
      {
        "address": "192.0.2.113:19999",
        "connected": "outbound"
      }
    ]
  }
]
```

*See also*

* [AddNode](../api/remote-procedure-calls-network.md#addnode): attempts to add or remove a node from the addnode list, or to try a connection to a node once.
* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node.

## GetConnectionCount

The [`getconnectioncount` RPC](../api/remote-procedure-calls-network.md#getconnectioncount) returns the number of connections to other nodes.

*Parameters: none*

*Result---the number of connections to other nodes*

| Name     | Type         | Presence                | Description                                                                |
| -------- | ------------ | ----------------------- | -------------------------------------------------------------------------- |
| `result` | number (int) | Required<br>(exactly 1) | The total number of connections to other nodes (both inbound and outbound) |

*Example from Dash Core 0.12.2*

```bash
dash-cli -testnet getconnectioncount
```

Result:

```text
14
```

*See also*

* [GetNetTotals](../api/remote-procedure-calls-network.md#getnettotals): returns information about network traffic, including bytes in, bytes out, and the current time.
* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node.
* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.

## GetNodeAddresses

The [`getnodeaddresses` RPC](../api/remote-procedure-calls-network.md#getnodeaddresses) returns the known addresses which can potentially be used to find new nodes in the network.

*Parameter #1---count*

| Name    | Type         | Presence             | Description                                                                                                    |
| ------- | ------------ | -------------------- | -------------------------------------------------------------------------------------------------------------- |
| `count` | number (int) | Optional<br>(0 or 1) | The number of addresses to return. Limited to the smaller of 2500 or 23% of all known addresses (default = 1). |

*Parameter #2---network*

| Name       | Type   | Presence             | Description                                                   |
| ---------- | ------ | -------------------- | ------------------------------------------------------------- |
| `network`  | string | Optional<br>(0 or 1) | The network (ipv4, ipv6, onion, i2p) the node connected through. |

*Result---the current bytes in, bytes out, and current time*

| Name            | Type         | Presence                | Description                                                |
| --------------- | ------------ | ----------------------- | ---------------------------------------------------------- |
| `result`        | array        | Required<br>(exactly 1) | An array containing information about the known addresses. |
| →<br>`time`     | number (int) | Required<br>(exactly 1) | The epoch time of when the node was last seen (in Unix)    |
| →<br>`services` | number (int) | Required<br>(exactly 1) | The services offered                                       |
| →<br>`address`  | string       | Required<br>(exactly 1) | The address of the node                                    |
| →<br>`port`     | number (int) | Required<br>(exactly 1) | The port of the node                                       |
| →<br>`network`  | string       | Required<br>(exactly 1) | The network (ipv4, ipv6, onion, i2p) the node connected through |

*Example from Dash Core 21.0.0*

```bash
dash-cli -testnet getnodeaddresses
```

Result:

```json
[
  {
    "time": 1713783495,
    "services": 3077,
    "address": "34.214.102.160",
    "port": 19999,
    "network": "ipv4"
  }
]
```

## GetNetTotals

The [`getnettotals` RPC](../api/remote-procedure-calls-network.md#getnettotals) returns information about network traffic, including bytes in, bytes out, and the current time.

*Parameters: none*

*Result---the current bytes in, bytes out, and current time*

| Name                             | Type                | Presence                | Description                                                                                                                  |
| -------------------------------- | ------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `result`                         | object              | Required<br>(exactly 1) | An object containing information about the node's network totals                                                             |
| →<br>`totalbytesrecv`            | number (int)        | Required<br>(exactly 1) | The total number of bytes received since the node was last restarted                                                         |
| →<br>`totalbytessent`            | number (int)        | Required<br>(exactly 1) | The total number of bytes sent since the node was last restarted                                                             |
| →<br>`timemillis`                | number (int)        | Required<br>(exactly 1) | Unix epoch time in milliseconds according to the operating system's clock (not the node adjusted time)                       |
| →<br>`uploadtarget`              | string : <br>object | Required<br>(exactly 1) | The upload target information                                                                                                |
| → →<br>`timeframe`               | number (int)        | Required<br>(exactly 1) | Length of the measuring timeframe in seconds (currently set to `24` hours)                                                   |
| → →<br>`target`                  | number (int)        | Required<br>(exactly 1) | The maximum allowed outbound traffic in bytes (default is `0`).  Can be changed with `-maxuploadtarget`                      |
| → →<br>`target_reached`          | bool                | Required<br>(exactly 1) | Indicates if the target is reached.  If the target is reached the node won't serve SPV and historical block requests anymore |
| → →<br>`serve_historical_blocks` | bool                | Required<br>(exactly 1) | Indicates if historical blocks are served                                                                                    |
| → →<br>`bytes_left_in_cycle`     | number (int)        | Required<br>(exactly 1) | Amount of bytes left in current time cycle.  `0` is displayed if no upload target is set                                     |
| → →<br>`time_left_in_cycle`      | number (int)        | Required<br>(exactly 1) | Seconds left in current time cycle.  `0` is displayed if no upload target is set                                             |

*Example from Dash Core 0.12.2*

```bash
dash-cli getnettotals
```

Result:

```json
{
  "totalbytesrecv": 4661588,
  "totalbytessent": 2899423,
  "timemillis": 1507815162756,
  "uploadtarget": {
    "timeframe": 86400,
    "target": 0,
    "target_reached": false,
    "serve_historical_blocks": true,
    "bytes_left_in_cycle": 0,
    "time_left_in_cycle": 0
  }
}
```

*See also*

* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.
* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node.

## GetNetworkInfo

The [`getnetworkinfo` RPC](../api/remote-procedure-calls-network.md#getnetworkinfo) returns information about the node's connection to the network.

*Parameters: none*

*Result---information about the node's connection to the network*

| Name                                   | Type          | Presence                | Description                                                                                                                                                                                                                                       |
| -------------------------------------- | ------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                               | object        | Required<br>(exactly 1) | Information about this node's connection to the network                                                                                                                                                                                           |
| →<br>`version`                         | number        | Required<br>(exactly 1) | This node's version of Dash Core in its internal integer format.  For example, Dash Core 0.12.2 has the integer version number 120200                                                                                                             |
| →<br>`buildversion`                    | string        | Required<br>(exactly 1) | The node's build version including RC info or commit as relevant                                                                                                                                                                                  |
| →<br>`subversion`                      | string        | Required<br>(exactly 1) | The user agent this node sends in its [`version` message](../reference/p2p-network-control-messages.md#version)                                                                                                                                          |
| →<br>`protocolversion`                 | number (int)  | Required<br>(exactly 1) | The protocol version number used by this node.  See the [protocol versions section](../reference/p2p-network-protocol-versions.md) for more information                                                                                                  |
| →<br>`localservices`                   | string (hex)  | Required<br>(exactly 1) | The services supported by this node as advertised in its [`version` message](../reference/p2p-network-control-messages.md#version)                                                                                                                       |
| →<br>`localservicesnames`              | array         | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br>An array of strings describing the services offered, in human-readable form.                                                                                                                                     |
| → →<br>SERVICE_NAME                    | string        | Required<br>(exactly 1) | The service name.                                                                                                                                                                                                                                 |
| →<br>`localrelay`                      | bool          | Required<br>(exactly 1) | *Added in Bitcoin Core 0.13.0*<br><br>The services supported by this node as advertised in its [`version` message](../reference/p2p-network-control-messages.md#version)                                                                                 |
| →<br>`timeoffset`                      | number (int)  | Required<br>(exactly 1) | The offset of the node's clock from the computer's clock (both in UTC) in seconds.  The offset may be up to 4200 seconds (70 minutes)                                                                                                             |
| →<br>`networkactive`                   | bool          | Required<br>(exactly 1) | Set to `true` if P2P networking is enabled.  Set to `false` if P2P networking is disabled. Enabling/disabling done via [SetNetworkActive](../api/remote-procedure-calls-network.md#setnetworkactive)                                     |
| →<br>`connections`                     | number (int)  | Required<br>(exactly 1) | The total number of open connections (both outgoing and incoming) between this node and other nodes                                                                                                                                               |
| →<br>`connections_in`                  | number (int)  | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>The number of inbound connections                                                                                                                                                                            |
| →<br>`connections_out`             | number (int)  | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>The number of outbound connections                                                                                                                                                                           |
| →<br>`connections_mn`                   | number (int)  | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>The number of verified masternode connections                                                                                                                                                                |
| →<br>`connections_mn_in`            | number (int)  | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>The number of inbound verified masternode connections                                                                                                                                                        |
| →<br>`connections_mn_out`           | number (int)  | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>The number of outbound verified masternode connections                                                                                                                                                       |
| →<br>`socketevents`                    | string        | Required<br>(exactly 1) | The socket events mode, either `epoll`, `poll`, or `select`                                                                                                                                                  |
| →<br>`networks`                        | array         | Required<br>(exactly 1) | An array with three objects: one describing the IPv4 connection, one describing the IPv6 connection, and one describing the Tor hidden service (onion) connection                                                                                 |
| → →<br>Network                         | object        | Optional<br>(0 to 3)    | An object describing a network.  If the network is unroutable, it will not be returned                                                                                                                                                            |
| → → →<br>`name`                        | string        | Required<br>(exactly 1) | The name of the network.  Either `ipv4`, `ipv6`, or `onion`                                                                                                                                                                                       |
| → → →<br>`limited`                     | bool          | Required<br>(exactly 1) | Set to `true` if only connections to this network are allowed according to the `-onlynet` Dash Core command-line/configuration-file parameter.  Otherwise set to `false`                                                                          |
| → → →<br>`reachable`                   | bool          | Required<br>(exactly 1) | Set to `true` if connections can be made to or from this network.  Otherwise set to `false`                                                                                                                                                       |
| → → →<br>`proxy`                       | string        | Required<br>(exactly 1) | The hostname and port of any proxy being used for this network.  If a proxy is not in use, an empty string                                                                                                                                        |
| → → →<br>`proxy_randomize_credentials` | bool          | Required<br>(exactly 1) | *Added in Bitcoin Core 0.11.0*<br><br>Set to `true` if randomized credentials are set for this proxy. Otherwise set to `false`                                                                                                                    |
| →<br>`relayfee`                        | number (DASH) | Required<br>(exactly 1) | The minimum relay fee per kilobyte for transactions in order for this node to accept it into its memory pool                                                                                                                                      |
| →<br>`incrementalfee`                  | number (DASH) | Required<br>(exactly 1) | *Added in Dash Core 0.12.3*<br><br>The minimum fee increment for mempool limiting or BIP 125 replacement in DASH/kB                                                                                                                               |
| →<br>`localaddresses`                  | array         | Required<br>(exactly 1) | An array of objects each describing the local addresses this node believes it listens on                                                                                                                                                          |
| → →<br>Address                         | object        | Optional<br>(0 or more) | An object describing a particular address this node believes it listens on                                                                                                                                                                        |
| → → →<br>`address`                     | string        | Required<br>(exactly 1) | An IP address or .onion address this node believes it listens on.  This may be manually configured, auto detected, or based on [`version` messages](../reference/p2p-network-control-messages.md#version) this node received from its peers              |
| → → →<br>`port`                        | number (int)  | Required<br>(exactly 1) | The port number this node believes it listens on for the associated `address`.  This may be manually configured, auto detected, or based on [`version` messages](../reference/p2p-network-control-messages.md#version) this node received from its peers |
| → → →<br>`score`                       | number (int)  | Required<br>(exactly 1) | The number of incoming connections during the uptime of this node that have used this `address` in their [`version` message](../reference/p2p-network-control-messages.md#version)                                                                       |
| →<br>`warnings`                        | string        | Required<br>(exactly 1) | *Added in Bitcoin Core 0.11.0*<br><br>A plain-text description of any network warnings. If there are no warnings, an empty string will be returned.                                                                                               |

*Example from Dash Core 21.0.0*

```bash
dash-cli getnetworkinfo
```

Result (actual addresses have been replaced with [RFC5737](http://tools.ietf.org/html/rfc5737) reserved addresses):

```json
{
  "version": 210100,
  "buildversion": "v21.1.0",
  "subversion": "/Dash Core:21.1.0/",
  "protocolversion": 70233,
  "localservices": "0000000000000c05",
  "localservicesnames": [
    "NETWORK",
    "BLOOM",
    "NETWORK_LIMITED",
    "HEADERS_COMPRESSED"
  ],
  "localrelay": true,
  "timeoffset": 0,
  "networkactive": true,
  "connections": 10,
  "connections_in": 0,
  "connections_out": 10,
  "connections_mn": 6,
  "connections_mn_in": 0,
  "connections_mn_out": 6,
  "socketevents": "epoll",
  "networks": [
    {
      "name": "ipv4",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "ipv6",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "onion",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "i2p",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "cjdns",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    }
  ],
  "relayfee": 0.00001000,
  "incrementalfee": 0.00001000,
  "localaddresses": [
  ],
  "warnings": "Make sure to encrypt your wallet and delete all non-encrypted backups after you have verified that the wallet works!"
}
```

*See also*

* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node.
* [GetNetTotals](../api/remote-procedure-calls-network.md#getnettotals): returns information about network traffic, including bytes in, bytes out, and the current time.
* [SetNetworkActive](../api/remote-procedure-calls-network.md#setnetworkactive): disables/enables all P2P network activity.

## GetPeerInfo

The [`getpeerinfo` RPC](../api/remote-procedure-calls-network.md#getpeerinfo) returns data about each connected network node.

*Parameters: none*

*Result---information about each currently-connected network node*

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `result`                        | array               | Required<br>(exactly 1) | An array of objects each describing one connected node.  If there are no connections, the array will be empty |
| →<br>Node                       | object              | Optional<br>(0 or more) | An object describing a particular connected node |
| → →<br>`id`                     | number (int)        | Required<br>(exactly 1) | The node's index number in the local node address database |
| → →<br>`addr`                   | string              | Required<br>(exactly 1) | The IP address and port number used for the connection to the remote node |
| → →<br>`addrlocal`              | string              | Optional<br>(0 or 1)    | Our IP address and port number according to the remote node.  May be incorrect due to error or lying.  Most SPV nodes set this to `127.0.0.1:9999` |
| → →<br>`network`                | string              | Optional<br>(0 or 1)    | **Added in Dash Core 20.0.0**<br>The network being used (ipv4, ipv6, onion, i2p, not_publicly_routable)                                                                                                                    |
| → →<br>`mapped_as`              | string              | Optional<br>(0 or 1)    | _Added in Dash Core 18.0.0_<br>The AS in the BGP route to the peer used for diversifying peer selection |
| → →<br>`addrbind`               | string              | Optional<br>(0 or 1)    | Bind address of the connection to the peer |
| → →<br>`services`               | string (hex)        | Required<br>(exactly 1) | The services advertised by the remote node in its [`version` message](../reference/p2p-network-control-messages.md#version) |
| → →<br>`servicesnames`          | array               | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br>An array of strings describing the services offered, in human-readable form. |
| → → →<br>SERVICE_NAME           | string              | Required<br>(exactly 1) | The service name if it is recognised. |
| → →<br>`verified_proregtx_hash` | string (hex)        | Optional<br>(0 or 1)    | The ProRegTx of the masternode |
| → →<br>`verified_pubkey_hash`   | string (hex)        | Optional<br>(0 or 1)    | The hashed operator public key of the masternode |
| `relaytxes`          | bool         | Required<br>(exactly 1) | Whether peer has asked us to relay transactions to it. |
| → →<br>`lastsend`               | number (int)        | Required<br>(exactly 1) | The Unix epoch time when we last successfully sent data to the TCP socket for this node |
| → →<br>`lastrecv`               | number (int)        | Required<br>(exactly 1) | The Unix epoch time when we last received data from this node |
| `last_transaction`   | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br>The UNIX epoch time of the last valid transaction received from this peer. |
| `last_block`         | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br>The UNIX epoch time of the last block received from this peer. |
| → →<br>`bytessent`              | number (int)        | Required<br>(exactly 1) | The total number of bytes we've sent to this node |
| → →<br>`bytesrecv`              | number (int)        | Required<br>(exactly 1) | The total number of bytes we've received from this node |
| → →<br>`conntime`               | number (int)        | Required<br>(exactly 1) | The Unix epoch time when we connected to this node |
| → →<br>`timeoffset`             | number (int)        | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The time offset in seconds |
| → →<br>`pingtime`               | number (real)       | Required<br>(exactly 1) | The number of seconds this node took to respond to our last P2P [`ping` message](../reference/p2p-network-control-messages.md#ping) |
| → →<br>`minping`                | number (real)       | Optional<br>(0 or 1)    | *Updated in Bitcoin Core 0.13.0*<br><br>The minimum observed ping time (if any at all) |
| → →<br>`pingwait`               | number (real)       | Optional<br>(0 or 1)    | The number of seconds we've been waiting for this node to respond to a P2P [`ping` message](../reference/p2p-network-control-messages.md#ping).  Only shown if there's an outstanding [`ping` message](../reference/p2p-network-control-messages.md#ping) |
| → →<br>`version`                | number (int)        | Required<br>(exactly 1) | The protocol version number used by this node.  See the [protocol versions section](../reference/p2p-network-protocol-versions.md) for more information |
| → →<br>`subver`                 | string              | Required<br>(exactly 1) | The user agent this node sends in its [`version` message](../reference/p2p-network-control-messages.md#version).  This string will have been sanitized to prevent corrupting the JSON results.  May be an empty string |
| → →<br>`inbound`                | bool                | Required<br>(exactly 1) | Set to `true` if this node connected to us (inbound); set to `false` if we connected to this node (outbound) |
| → →<br>`bip152_hb_to`          | bool                | Required<br>(exactly 1) | Whether we selected peer as (compact blocks) high-bandwidth peer |
| → →<br>`bip152_hb_from`        | bool                | Required<br>(exactly 1) | Whether peer selected us as (compact blocks) high-bandwidth peer |
| → →<br>`addnode`                | bool                | Required<br>(exactly 1) | **DEPRECATED, returned only if the config option -deprecatedrpc=getpeerinfo_addnode is passed**<br>Set to `true` if this node was added via the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode). |
| → →<br>`masternode`             | bool                | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Whether connection was due to masternode connection attempt |
| → →<br>`banscore`               | number (int)        | Required<br>(exactly 1) | *DEPRECATED, returned only if config option -deprecatedrpc=banscore is passed*<br>The ban score we've assigned the node based on any misbehavior it's made.  By default, Dash Core disconnects when the ban score reaches `100` |
| → →<br>`startingheight`         | number (int)        | Required<br>(exactly 1) | The height of the remote node's block chain when it connected to us as reported in its [`version` message](../reference/p2p-network-control-messages.md#version) |
| → →<br>`synced_headers` | number (int) | Required<br>(exactly 1) | The highest-height header we have in common with this node based the last P2P [`headers` message](../reference/p2p-network-data-messages.md#headers) it sent us. If a [`headers` message](../reference/p2p-network-data-messages.md#headers) has not been received, this will be set to `-1` |
| → →<br>`synced_blocks` | number (int) | Required<br>(exactly 1) | The highest-height block we have in common with this node based on P2P [`inv` messages](../reference/p2p-network-data-messages.md#inv) this node sent us. If no block [`inv` messages](../reference/p2p-network-data-messages.md#inv) have been received from this node, this will be set to `-1` |
| → →<br>`inflight` | array | Required<br>(exactly 1) | An array of blocks which have been requested from this peer. May be empty |
| → → →<br>Blocks | number (int) | Optional<br>(0 or more) | The height of a block being requested from the remote peer |
| → →<br>`addr_relay_enabled`            | bool                | Required<br>(exactly 1) | Whether we participate in address relay with this peer. |
| → →<br>`addr_processed`                | number (int)        | Required<br>(exactly 1) | The total number of addresses processed, excluding those dropped due to rate limiting. |
| → →<br>`addr_rate_limited`             | number (int)        | Required<br>(exactly 1) | The total number of addresses dropped due to rate limiting. |
| → →<br>`whitelisted` | bool | Required<br>(exactly 1) | **DEPRECATED, returned only if config option -deprecatedrpc=whitelisted is passed**<br>Set to `true` if the remote peer has been whitelisted; otherwise, set to `false`. Whitelisted peers will not be banned if their ban score exceeds the maximum (100 by default). By default, peers connecting from localhost are whitelisted |
| → →<br>`permissions` | array | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br>Any special permissions that have been granted to this peer |
| → →<br>`bytessent_per_msg` | string : <br>object | Required<br>(exactly 1) | *Added in Bitcoin Core 0.13.0*<br><br>Information about total sent bytes aggregated by message type |
| → → →<br>Message Type | number (int) | Required<br>(1 or more) | Total sent bytes aggregated by message type. One field for every used message type |
| → →<br>`bytesrecv_per_msg` | string : <br>object | Required<br>(exactly 1) | *Added in Bitcoin Core 0.13.0*<br><br>Information about total received bytes aggregated by message type |
| → → →<br>Message Type | number (int) | Required<br>(1 or more) | Total received bytes aggregated by message type. One field for every used message type |
| `connection_type` | string | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br>Type of connection:<br>outbound-full-relay, block-relay-only, inbound, manual, addr-fetch, feeler.<br>Describes how the connection was established. Set to `true` if this node was added via the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode).<br>**Note: This output is subject to change in future releases as connection behaviors are refined.** |
| `transport_protocol_type`| string | Optional<br>(0 or 1) | **Added in Dash Core 22.0.0**<br>The transport protocol type:<br>`detecting` - peer could be v1 or v2<br>`v1` - plaintext transport protocol<br>`v2` - BIP324 encrypted transport protocol |
| `session_id` | string | Optional<br>(0 or 1) | **Added in Dash Core 22.0.0**<br>The session ID for this connection, or "" if there is none ("v2" transport protocol only). |

*Example from Dash Core 22.0.0*

```bash
dash-cli -testnet getpeerinfo
```

Result (edited to show only a single entry, with IP addresses changed to  
[RFC5737](http://tools.ietf.org/html/rfc5737) reserved IP addresses):

```json
[
  {
    "id": 0,
    "addr": "198.51.100.1:19999",
    "addrbind": "192.0.2.1:34896",
    "addrlocal": "203.0.113.1:34896",
    "network": "ipv4",
    "services": "0000000000000c05",
    "servicesnames": [
      "NETWORK",
      "BLOOM",
      "NETWORK_LIMITED",
      "HEADERS_COMPRESSED"
    ],
    "lastsend": 1715200494,
    "lastrecv": 1715200436,
    "last_transaction": 0,
    "last_block": 1715200219,
    "bytessent": 70135,
    "bytesrecv": 486133,
    "conntime": 1715200196,
    "timeoffset": 0,
    "pingtime": 0.105995,
    "minping": 0.095181,
    "version": 70233,
    "subver": "/Dash Core:21.1.0(dcg-masternode-7)/",
    "inbound": false,
    "bip152_hb_to": false,
    "bip152_hb_from": false,
    "masternode": false,
    "startingheight": 1131692,
    "synced_headers": 1131804,
    "synced_blocks": 1131804,
    "inflight": [
    ],
    "relaytxes": true,
    "addr_relay_enabled": true,
    "addr_processed": 519,
    "addr_rate_limited": 0,
    "permissions": [
    ],
    "bytessent_per_msg": {
      "dsq": 7802,
      "getdata": 35555,
      "getheaders2": 1053,
      "getsporks": 24,
      "govsync": 25182,
      "inv": 61,
      "ping": 96,
      "pong": 96,
      "sendaddrv2": 24,
      "sendcmpct": 33,
      "sendheaders2": 24,
      "verack": 24,
      "version": 161
    },
    "bytesrecv_per_msg": {
      "addrv2": 40,
      "block": 361498,
      "getheaders2": 1053,
      "govobj": 916,
      "govobjvote": 47150,
      "headers2": 62247,
      "inv": 9291,
      "mnauth": 152,
      "ping": 96,
      "pong": 96,
      "sendaddrv2": 24,
      "sendcmpct": 33,
      "senddsq": 25,
      "sendheaders2": 24,
      "spork": 2420,
      "ssc": 864,
      "verack": 24,
      "version": 180
    },
    "connection_type": "outbound-full-relay",
    "transport_protocol_type": "v1",
    "session_id": ""
  }
]
```

*See also*

* [GetAddedNodeInfo](../api/remote-procedure-calls-network.md#getaddednodeinfo): returns information about the given added node, or all added nodes (except onetry nodes). Only nodes which have been manually added using the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) will have their information displayed.
* [GetNetTotals](../api/remote-procedure-calls-network.md#getnettotals): returns information about network traffic, including bytes in, bytes out, and the current time.
* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.

## ListBanned

*Added in Bitcoin Core 0.12.0*

The [`listbanned` RPC](../api/remote-procedure-calls-network.md#listbanned) lists all ***manually banned*** IPs/Subnets.

:::{note}
Dash Core 18.1.0 introduced changes to how misbehaving peers are treated. As a result they are no longer included in this RPC response. See the [release notes](https://github.com/dashpay/dash/blob/v18.1.0/doc/release-notes.md#changes-regarding-misbehaving-peers) for additional details.
:::

*Parameters: none*

*Result---information about each banned IP/Subnet*

| Name                    | Type            | Presence                    | Description |
| ----------------------- | --------------- | --------------------------- | ----------- |
| `result`                | object          | Required<br>(exactly 1)     | An array of objects each describing one entry. If there are no entries in the ban list, the array will be empty |
| →<br>Node               | object          | Optional<br>(0 or more)     | A ban list entry |
| → →<br>`address`        | string          | Required<br>(exactly 1)     | The IP/Subnet of the entry |
| → →<br>`banned_until`   | number<br>(int) | Required<br>(exactly 1)     | The Unix epoch time when the entry was added to the ban list |
| → →<br>`ban_created`    | number<br>(int) | Required<br>(exactly 1)     | The Unix epoch time until the IP/Subnet is banned |
| `ban_duration`          | number (int)    | Required<br>(exactly 1)     | The ban duration, in seconds. |
| `time_remaining`        | number (int)    | Required<br>(exactly 1)     | The time remaining until the ban expires, in seconds. |

*Examples from Dash Core 21.1.0*

```bash
dash-cli listbanned
```

Result:

```json
[
  {
    "address": "192.0.2.201/32",
    "ban_created": 1715614036,
    "banned_until": 1715617636,
    "ban_duration": 3600,
    "time_remaining": 3577
  },
  {
    "address": "192.0.2.101/32",
    "ban_created": 1715614056,
    "banned_until": 1715617656,
    "ban_duration": 3600,
    "time_remaining": 3597
  }
]
```

*See also*

* [SetBan](../api/remote-procedure-calls-network.md#setban): attempts add or remove a IP/Subnet from the banned list.
* [ClearBanned](../api/remote-procedure-calls-network.md#clearbanned): clears list of banned nodes.

## Ping

The [`ping` RPC](../api/remote-procedure-calls-network.md#ping) sends a P2P ping message to all connected nodes to measure ping time. Results are provided by the [`getpeerinfo` RPC](../api/remote-procedure-calls-network.md#getpeerinfo) pingtime and pingwait fields as decimal seconds. The P2P [`ping` message](../reference/p2p-network-control-messages.md#ping) is handled in a queue with all other commands, so it measures processing backlog, not just network ping.

*Parameters: none*

_Result---`null`_

| Name     | Type | Presence | Description        |
| -------- | ---- | -------- | ------------------ |
| `result` | null | Required | Always JSON `null` |

*Example from Dash Core 0.12.2*

```bash
dash-cli -testnet ping
```

(Success: no result printed.)

Get the results using the [`getpeerinfo` RPC](../api/remote-procedure-calls-network.md#getpeerinfo):

```bash
dash-cli -testnet getpeerinfo | grep ping
```

Results:

```json
        "pingtime" : 0.11790800,
        "pingtime" : 0.22673400,
        "pingtime" : 0.16451900,
        "pingtime" : 0.12465200,
        "pingtime" : 0.13267900,
        "pingtime" : 0.23983300,
        "pingtime" : 0.16764700,
        "pingtime" : 0.11337300,
```

*See also*

* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node.
* [P2P Ping Message](../reference/p2p-network-control-messages.md#ping)

## SetBan

*Added in Bitcoin Core 0.12.0*

The [`setban` RPC](../api/remote-procedure-calls-network.md#setban) attempts add or remove a IP/Subnet from the banned list.

*Parameter #1---IP/Subnet of the node*

| Name         | Type   | Presence                | Description                                                                                                                                                                                 |
| ------------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| IP(/Netmask) | string | Required<br>(exactly 1) | The node to add or remove as a string in the form of `<IP address>`.  The IP address may be a hostname resolvable through DNS, an IPv4 address, an IPv4-as-IPv6 address, or an IPv6 address |

*Parameter #2---whether to add or remove the node*

| Name    | Type   | Presence                | Description                                                                                                                                                                                                     |
| ------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Command | string | Required<br>(exactly 1) | What to do with the IP/Subnet address above.  Options are:<br>• `add` to add a node to the addnode list<br>• `remove` to remove a node from the list.  If currently connected, this will disconnect immediately |

*Parameter #3---time how long the ip is banned*

| Name    | Type             | Presence             | Description                                                                                                                                                          |
| ------- | ---------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bantime | numeric<br>(int) | Optional<br>(0 or 1) | Time in seconds how long (or until when if `absolute` is set) the entry is banned. The default is 24h which can also be overwritten by the -bantime startup argument |

*Parameter #4---whether a relative or absolute timestamp*

| Name     | Type | Presence             | Description                                                                              |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------------------------- |
| Absolute | bool | Optional<br>(0 or 1) | If set, the bantime must be a absolute timestamp in seconds since epoch (Jan 1 1970 GMT) |

_Result---`null` on success_

| Name     | Type | Presence                | Description        |
| -------- | ---- | ----------------------- | ------------------ |
| `result` | null | Required<br>(exactly 1) | Always JSON `null` |

*Example from Dash Core 0.12.2*

Ban the following node.

```bash
dash-cli -testnet setban 192.0.2.113 add 2592000
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [ListBanned](../api/remote-procedure-calls-network.md#listbanned): lists all manually banned IPs/Subnets.
* [ClearBanned](../api/remote-procedure-calls-network.md#clearbanned): clears list of banned nodes.

## SetNetworkActive

*Added in Bitcoin Core 0.14.0*

The [`setnetworkactive` RPC](../api/remote-procedure-calls-network.md#setnetworkactive) disables/enables all P2P network activity.

*Parameter #1---whether to disable or enable all P2P network activity*

| Name     | Type | Presence                | Description                                                                                          |
| -------- | ---- | ----------------------- | ---------------------------------------------------------------------------------------------------- |
| Activate | bool | Required<br>(exactly 1) | Set to `true` to enable all P2P network activity. Set to `false` to disable all P2P network activity |

_Result---`null` or error on failure_

| Name     | Type | Presence                | Description                                                                                 |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | JSON `null`.  The JSON-RPC error field will be set only if you entered an invalid parameter |

*Example from Dash Core 0.12.2*

```bash
dash-cli setnetworkactive true
```

Result (no output from `dash-cli` because result is set to `null`).

*See also*

* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.
