```{eval-rst}
.. meta::
  :title: InstantSend Messages
  :description: The network messages in this section play a role in controlling Dash's InstantSend feature, utilizing the masternode network for secure and fast transactions.
```

# InstantSend Messages

The following network messages all help control the InstantSend feature of Dash. InstantSend uses the masternode network to lock transaction inputs and enable secure, instantaneous transactions. For additional details, refer to the Developer Guide [InstantSend section](../guide/dash-features-instantsend.md).

## clsig

*Added in protocol version 70214 of Dash Core*

The [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) is used to indicate a successful ChainLock for the designated [block height](../resources/glossary.md#block-height). The Chainlock ensures that no other [blocks](../resources/glossary.md#block) can replace the one with the indicated block hash. This determination is made by agreement of a [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum) (LLMQ) which creates the BLS signature in the message.

Once a [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig) is received, clients must reject any other blocks for the indicated block height as described in [DIP8 (ChainLocks)](https://github.com/dashpay/dips/blob/master/dip-0008.md). This increases security by preventing reorganization of a block with a ChainLock (and all blocks below it).

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 4 | nHeight | int32_t | Block height
| 32 | blockHash | uint256 | Block hash
| 96 | sig | CBLSSignature | LLMQ BLS signature<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

The following annotated hexdump shows a [`clsig` message](../reference/p2p-network-instantsend-messages.md#clsig). (The message header has been omitted.)

``` text
c1310100 ................................... Block Height: 78273

03bb286a877135fad3b33ea9cce9a525
e5edc0879411afaff513b30100000000 ........... Block Hash

12a3331fd8d0008804edaaf94c57b491
d36f38f1993d06dfff71df9ec83da463
dcd5497d105932e609016dac075f02df
1259951e3bcebfcc26afc904f6cd92df
7ff9b8c6c2ac9dcc9cb1a7dc7ec03bcc
005574710c3aabc2f8670959cf8bc9b5 ........... LLMQ BLS Signature
```

## isdlock

:::{note}
*Added in protocol version 70220 of Dash Core*
:::

The [`isdlock` message](../reference/p2p-network-instantsend-messages.md#isdlock) is used to provide details of transactions that have been locked by InstantSend. The message includes all details present in the [`islock` message](../reference/p2p-network-deprecated-messages.md#islock) along with additional version and cycle information introduced by [DIP22](https://github.com/dashpay/dips/blob/master/dip-0022.md).  This enables nodes to determine what quorum signed the message and validate the signature in the future after the quorum is no longer active. Additional details about the change are available in [DIP22 - Making InstantSend Deterministic using Quorum Cycles](https://github.com/dashpay/dips/blob/master/dip-0022.md).

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | version | uint8 | The version of the islock message |
| 1-9 | inputsSize | compactSize uint | Number of inputs |
| 36 * `inputsSize`| inputs | COutPoint | Outpoints used in the transaction |
| 32 | txid | uint256 | TXID of the locked transaction |
| 32 | cycleHash | uint256 | Block hash of first block of the cycle in which the quorum signing this islock is active |
| 96 | sig | byte[] | LLMQ BLS Signature<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation |

The following annotated hexdump shows a [`isdlock` message](../reference/p2p-network-instantsend-messages.md#isdlock). (The message header has been omitted.)

``` text
01 ......................................... Message version: 1
11 ......................................... Number of inputs: 17

Input 1
| d735fb8cb1b2c4f852e090824ed1b671
| 93a6ed82dfb959487c80c9d520ce270b ......... Previous outpoint TXID
| 01000000 ................................. Previous outpoint index: 1

Input 2
| c8ad33361d9dbc2f0a0e981987fa5c9c
| a3df83991dddccab6498ac40d2976423 ......... Previous outpoint TXID
| 01000000 ................................. Previous outpoint index: 1

| [...] .................................... 15 transaction inputs omitted

f3fd4540b5240abfeba62b766754647a
32580ab3be974b0b63ac16d619675fee ........... TXID

ea830004232454df5db2c96b3da3c741
d7729b0a293c967f7647a2731e000000 ........... Cycle hash

9853fbfbc3592a06200e41617d30713f
861586c7503972ecd09d00731f4fcd6c
712a03c37906a14475e0e903e3ea9185
043673aa8e6ff402eaea7adbdf06d2ab
141fdd115a7162904e8a43c8f3efb67d
05870b1b00c88445f77fa9cb1cb16c01 ........... LLMQ BLS Signature (96 bytes)
```
