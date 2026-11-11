```{eval-rst}
.. meta::
  :title: Message Headers
  :description: All network protocol messages utilize a standardized container format, comprising a required message header and an optional payload.
```

# Message Headers

All messages in the network protocol use the same container format, which provides a required multi-field [message header](../resources/glossary.md#message-header) and an optional payload. The message header format is:

| Bytes | Name         | Data Type | Description
| :-------: |--------------|-----------|-------------
| 4     | start string | char[4]   | Magic bytes indicating the originating network; used to seek to next message when stream state is unknown.
| 12    | command name | char[12]  | ASCII string which identifies what message type is contained in the payload.  Followed by nulls (0x00) to pad out byte count; for example: `version\0\0\0\0\0`.
| 4     | payload size | uint32_t  | Number of bytes in payload.  The current maximum number of bytes ([`MAX_SIZE`](https://github.com/dashpay/dash/blob/v0.15.x/src/serialize.h#L29)) allowed in the payload by Dash Core is 32 MiB---messages with a payload size larger than this will be dropped or rejected.
| 4     | checksum     | char[4]   | *Added in protocol version 209.* <br><br>First 4 bytes of SHA256(SHA256(payload)) in internal byte order.<br /><br /> If payload is empty, as in `verack` and [`getaddr` messages](../reference/p2p-network-control-messages.md#getaddr), the checksum is always 0x5df6e0e2 (SHA256(SHA256(<empty string>))).

## BIP324 v2 transport

Connections using the [BIP324](https://github.com/bitcoin/bips/blob/master/bip-0324.mediawiki) v2 encrypted transport (supported since protocol version 70235 / Dash Core 22.0.0 and enabled by default since Dash Core 22.1.0) do not use the message header described above. Instead, each encrypted packet that carries a message begins its contents with the message type, encoded either as a 1-byte short ID or as a `0x00` byte followed by the 12-byte command name. Bitcoin messages use the short IDs 1–28 assigned by BIP324, and Dash-specific messages use short IDs 128–167 (see `V2_BITCOIN_IDS` and `V2_DASH_IDS` in [`src/net.cpp`](https://github.com/dashpay/dash/blob/v24.0.0/src/net.cpp#L906-L991) for the full mapping). As of protocol version 70240, the [`platformban` message](../reference/p2p-network-masternode-messages.md#platformban) uses short ID 168 when the negotiated protocol version is 70240 or higher; otherwise it is sent with the long (12-byte command name) encoding.

## Example

The following example is an annotated hex dump of a [mainnet](../resources/glossary.md#mainnet) message header from a [`verack` message](../reference/p2p-network-control-messages.md#verack) which has no payload.

``` text
bf0c6bbd ................... Start string: Mainnet
76657261636b000000000000 ... Command name: verack + null padding
00000000 ................... Byte count: 0
5df6e0e2 ................... Checksum: SHA256(SHA256(<empty>))
```
