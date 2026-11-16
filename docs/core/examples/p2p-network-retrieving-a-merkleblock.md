```{eval-rst}
.. meta::
  :title: Retrieving a MerkleBlock
  :description: This section walks through each step of the process, demonstrating basic network communication and merkle block processing.
```

# Retrieving a MerkleBlock

For the [`merkleblock` message](../reference/p2p-network-data-messages.md#merkleblock) documentation on the reference page, an actual [merkle block](../resources/glossary.md#merkle-block) was retrieved from the [network](../resources/glossary.md#network) and manually processed.  This section walks through each step of the process, demonstrating basic network communication and merkle block processing.

``` python
#!/usr/bin/env python3

from time import sleep
from hashlib import sha256
import struct
import sys

network_string = bytes.fromhex("bf0c6bbd")  # Mainnet

def send(msg,payload):
    ## Command is ASCII text, null padded to 12 bytes
    command = msg.encode() + ( ( 12 - len(msg) ) * b"\00" )

    ## Payload length is a uint32_t
    payload_raw = bytes.fromhex(payload)
    payload_len = struct.pack("<I", len(payload_raw))

    ## Checksum is first 4 bytes of SHA256(SHA256(<payload>))
    checksum = sha256(sha256(payload_raw).digest()).digest()[:4]

    sys.stdout.buffer.write(
        network_string
        + command
        + payload_len
        + checksum
        + payload_raw
    )
    sys.stdout.flush()
```

To connect to the P2P [network](../resources/glossary.md#network), the trivial Python function above was developed to compute message headers and send payloads decoded from hex. The [message header](../reference/p2p-network-message-headers.md) starts with the mainnet [start string](../resources/glossary.md#start-string). To connect to a testnet or regtest node instead, change it to `cee2caff` or `fcc1b7dc` and connect to that network's port (19999 or 19899).

``` python
## Create a version message
send("version",
      "62120100" # ........................ Protocol Version: 70242
    + "0000000000000000" # ................ Services: Headers Only (SPV)
    + "c6925e5400000000" # ................ Time: 1415484102
    + "00000000000000000000000000000000"
    + "0000ffff7f000001270f" # ............ Receiver IP Address/Port
    + "00000000000000000000000000000000"
    + "0000ffff7f000001270f" # ............ Sender IP Address/Port
    + "0000000000000000" # ................ Nonce (not used here)
    + "17" # .............................. Bytes in version string
    + "2f4461736820446f6373204578616d70"
    + "6c653a312e302f" # .................. Version string
    + "93050500" # ........................ Starting block height: 329107
    + "00" # .............................. Relay transactions: false
)
```

Peers on the network will not accept any requests until you send them a [`version` message](../reference/p2p-network-control-messages.md#version). Dash Core disconnects peers whose protocol version is below its minimum supported version (`MIN_PEER_PROTO_VERSION` in [`src/version.h`](https://github.com/dashpay/dash/blob/v24.0.1/src/version.h)). The receiving node will reply with their [`version` message](../reference/p2p-network-control-messages.md#version) and a [`verack` message](../reference/p2p-network-control-messages.md#verack).

``` python
sleep(1)
send("verack", "")
```

We're not going to validate their [`version` message](../reference/p2p-network-control-messages.md#version) with this simple script, but we will sleep a short bit and send back our own [`verack` message](../reference/p2p-network-control-messages.md#verack) as if we had accepted their [`version` message](../reference/p2p-network-control-messages.md#version).

``` python
send("filterload",
      "02"  # ........ Filter bytes: 2
    + "b50f" # ....... Filter: 1010 1101 1111 0000
    + "0b000000" # ... nHashFuncs: 11
    + "00000000" # ... nTweak: 0/none
    + "00" # ......... nFlags: BLOOM_UPDATE_NONE
)
```

We set a [bloom filter](../resources/glossary.md#bloom-filter) with the [`filterload` message](../reference/p2p-network-control-messages.md#filterload). This filter is described in the preceding sections.

``` python
send("getdata",
      "01" # ................................. Number of inventories: 1
    + "03000000" # ........................... Inventory type: filtered block
    + "a4deb66c0d726b0aefb03ed51be407fb"
    + "ad7331c6e8f9eef231b7000000000000" # ... Block header hash
)
```

We request a merkle block for transactions matching our filter, completing our script.

:::{note}
The filter, block header hash, and merkle block used in these examples come from the Bitcoin block chain, where this example originated, so a Dash node won't return a merkle block for them. To try the script on Dash, create a filter for a Dash transaction as shown in [Creating a Bloom Filter](../examples/p2p-network-creating-a-bloom-filter.md) and request the block that contains it.
:::

To run the script, we simply pipe it to the Unix [`netcat` command](https://en.wikipedia.org/wiki/Netcat) or one of its many clones, one of which is available for practically any platform. For example, with the original netcat and using hexdump (`hd`) to display the output:

``` bash
## Connect to the Dash Core peer running on localhost
python3 get-merkle.py | nc localhost 9999 | hd
```

Part of the response is shown in the [Parsing a MerkleBlock](../examples/p2p-network-parsing-a-merkleblock.md) section.
