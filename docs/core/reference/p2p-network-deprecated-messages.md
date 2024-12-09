# Deprecated Messages

The following network messages have been recently deprecated and should no longer be used. To see
network messages removed longer ago, please see the [previous version of
documentation](https://docs.dash.org/projects/core/en/20.0.0/docs/reference/p2p-network-deprecated-messages.html).

## islock

:::{deprecated} 20.1.0
Dash protocol version 70231 removed support for non-deterministic InstantSend. The [`isdlock` message](../reference/p2p-network-instantsend-messages.md#isdlock) with expanded features replaced this message.
:::

The [`islock` message](../reference/p2p-network-deprecated-messages.md#islock) is used to provide details of transactions that have been locked by LLMQ-based InstantSend. The message includes the details of all transaction [inputs](../resources/glossary.md#input) along with the transaction ID and the BLS [signature](../resources/glossary.md#signature) of the [LLMQ](../resources/glossary.md#long-living-masternode-quorum) that approved the transaction lock.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1-9 | inputsSize | compactSize uint | Number of inputs |
| 36 * `inputsSize`| inputs | COutPoint | Outpoints used in the transaction |
| 32 | txid | uint256 | TXID of the locked transaction |
| 96 | sig | byte[] | LLMQ BLS Signature |

The following annotated hexdump shows a [`islock` message](../reference/p2p-network-deprecated-messages.md#islock). (The message header has been omitted.)

``` text
02 ......................................... Number of inputs: 2

Input 1
| 05f24f65a9d98ff543ba61f7f0ce9448
| 79632bf2517540a5bd8bde2fe8e94617 ......... Previous outpoint TXID
| 00000000 ................................. Previous outpoint index: 0

Input 2
| 05f24f65a9d98ff543ba61f7f0ce9448
| 79632bf2517540a5bd8bde2fe8e94617 ......... Previous outpoint TXID
| 01000000 ................................. Previous outpoint index: 1

e2e1c797576d8b13c83e929684b9aacd
553c20a34e2d11e38bdcaaf8e1de1680 ........... TXID

0f055c2064885d446f83d51b9bb09892
7ea0375a0f6a3f3402abf158ece67e00
81049b8a8f45d254b64574cef194ef31
197e450fba1196d652f2e1421d3b80ae
f429c10eabd4ab9289e9a8f80f6989b7
a11e5e7930deccc3e11a931fc9524f06 ........... LLMQ BLS Signature (96 bytes)
```

## reject

:::{deprecated} 19.0.0
:::

*Added in protocol version 70002 as described by BIP61.*

The [`reject` message](#reject) informs the receiving [node](../resources/glossary.md#node) that one of its previous messages has been rejected.

| Bytes    | Name          | Data Type        | Description
|----------|---------------|------------------|--------------
| *Varies* | message bytes | compactSize uint | The number of bytes in the following message field.
| *Varies* | message       | string           | The type of message rejected as ASCII text *without null padding*.  For example: "tx", "block", or "version".
| 1        | code          | char             | The reject message code.  See the table below.
| *Varies* | reason bytes  | compactSize uint | The number of bytes in the following reason field.  May be 0x00 if a text reason isn't provided.
| *Varies* | reason        | string           | The reason for the rejection in ASCII text.  This should not be displayed to the user; it is only for debugging purposes.
| *Varies* | extra data    | *varies*         | Optional additional data provided with the rejection.  For example, most rejections of [`tx` messages](../reference/p2p-network-data-messages.md#tx) or [`block` messages](../reference/p2p-network-data-messages.md#block) include the hash of the rejected transaction or block header.  See the code table below.

The following table lists message reject codes.  Codes are tied to the type of message they reply to; for example there is a 0x10 reject code for transactions and a 0x10 reject code for blocks.

| Code | In Reply To       | Extra Bytes | Extra Type | Description
|------|-------------------|-------------|------------|----------------
| 0x01 | *any message*     | 0           | N/A        | Message could not be decoded.  Be careful of [`reject` message](#reject) feedback loops where two peers each don't understand each other's [`reject` messages](#reject) and so keep sending them back and forth forever.
| 0x10 | [`block` message](../reference/p2p-network-data-messages.md#block)   | 32          | char[32]   | Block is invalid for some reason (invalid proof-of-work, invalid signature, etc).  Extra data may include the rejected block's header hash.
| 0x10 | [`tx` message](../reference/p2p-network-data-messages.md#tx)      | 32          | char[32]   | Transaction is invalid for some reason (invalid signature, output value greater than input, etc.).  Extra data may include the rejected transaction's TXID.
| 0x10 | `ix` message      | 32          | char[32]   | InstantSend transaction is invalid for some reason (invalid tx lock request, conflicting tx lock request, etc.).  Extra data may include the rejected transaction's TXID.
| 0x11 | [`block` message](../reference/p2p-network-data-messages.md#block)   | 32          | char[32]   | The block uses a version that is no longer supported.  Extra data may include the rejected block's header hash.
| 0x11 | [`version` message](../reference/p2p-network-control-messages.md#version) | 0           | N/A        | Connecting node is using a protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa)     | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dsi` message](../reference/p2p-network-privatesend-messages.md#dsi)     | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dsc` message](../reference/p2p-network-privatesend-messages.md#dsc)     | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dsf` message](../reference/p2p-network-privatesend-messages.md#dsf)     | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq)     | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`dssu` message](../reference/p2p-network-privatesend-messages.md#dssu)    | 0           | N/A        | Connecting node is using a CoinJoin protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`govsync` message](../reference/p2p-network-governance-messages.md#govsync) | 0           | N/A        | Connecting node is using a governance protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`govobj` message](../reference/p2p-network-governance-messages.md#govobj)  | 0           | N/A        | Connecting node is using a governance protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | [`govobjvote` message](../reference/p2p-network-governance-messages.md#govobjvote) | 0           | N/A        | Connecting node is using a governance protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | `mnget` message   | 0           | N/A        | Connecting node is using a masternode payment protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | `mnw` message     | 0           | N/A        | Connecting node is using a masternode payment protocol version that the rejecting node considers obsolete and unsupported.
| 0x11 | `txlvote` message | 0           | N/A        | Connecting node is using an InstantSend protocol version that the rejecting node considers obsolete and unsupported.
| 0x12 | [`tx` message](../reference/p2p-network-data-messages.md#tx)      | 32          | char[32]   | Duplicate input spend (double spend): the rejected transaction spends the same input as a previously-received transaction.  Extra data may include the rejected transaction's TXID.
| 0x12 | [`version` message](../reference/p2p-network-control-messages.md#version) | 0           | N/A        | More than one [`version` message](../reference/p2p-network-control-messages.md#version) received in this connection.
| 0x40 | [`tx` message](../reference/p2p-network-data-messages.md#tx)      | 32          | char[32]   | The transaction will not be mined or relayed because the rejecting node considers it non-standard---a transaction type or version unknown by the server.  Extra data may include the rejected transaction's TXID.
| 0x41 | [`tx` message](../reference/p2p-network-data-messages.md#tx)      | 32          | char[32]   | One or more output amounts are below the dust threshold.  Extra data may include the rejected transaction's TXID.
| 0x42 | [`tx` message](../reference/p2p-network-data-messages.md#tx)      |             | char[32]   | The transaction did not have a large enough fee or priority to be relayed or mined.  Extra data may include the rejected transaction's TXID.
| 0x43 | [`block` message](../reference/p2p-network-data-messages.md#block)   | 32          | char[32]   | The block belongs to a block chain which is not the same block chain as provided by a compiled-in checkpoint.  Extra data may include the rejected block's header hash.

Reject Codes

| Code | Description
|------|--------------
| 0x01 | Malformed
| 0x10 | Invalid
| 0x11 | Obsolete
| 0x12 | Duplicate
| 0x40 | Non-standard
| 0x41 | Dust
| 0x42 | Insufficient fee
| 0x43 | Checkpoint

The annotated hexdump below shows a [`reject` message](#reject). (The message header has been omitted.)

``` text
02 ................................. Number of bytes in message: 2
7478 ............................... Type of message rejected: tx
12 ................................. Reject code: 0x12 (duplicate)
15 ................................. Number of bytes in reason: 21
6261642d74786e732d696e707574732d
7370656e74 ......................... Reason: bad-txns-inputs-spent
394715fcab51093be7bfca5a31005972
947baf86a31017939575fb2354222821 ... TXID
```
