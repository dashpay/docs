```{eval-rst}
.. _ref-txs-special-txs:
.. meta::
  :title: Special Transactions
  :description: The Special Transactions framework provides Dash the flexibility to expand beyond the financial uses of classical transactions.
```

# Special Transactions

The [Special Transactions](../resources/glossary.md#special-transactions) framework established by [DIP2](https://github.com/dashpay/dips/blob/master/dip-0002.md) enabled the implementation of new on-chain features and [consensus](../resources/glossary.md#consensus) mechanisms. These transactions provide the flexibility to expand beyond the financial uses of classical transactions. DIP2 transactions modified classical transactions by:

1. Splitting the 32 bit `version` field into two 16 bit fields (`version` and `type`)
2. Adding support for a generic extra payload following the `lock_time` field. The maximum allowed size for a transaction version 3 extra payload is 10000 bytes (`MAX_TX_EXTRA_PAYLOAD`).

Classical (financial) transactions have a `type` of 0 while special transactions have a `type` defined in the DIP describing them. A list of current special transaction types is maintained in the [DIP repository](https://github.com/dashpay/dips/blob/master/dip-0002/special-transactions.md).

**Implemented Special Transactions**

| Release | Tx Version | Tx Type | Payload JSON                | Tx Purpose                               | Payload | Payload Size     |
| ------- | ---------- | ------- | --------------------------- | ---------------------------------------- | ------- | ---------------- |
| 0.12.3  | 2          | -       | n/a                         | n/a                                      | n/a     |                  |
| 0.13.0  | 3          | 0       | n/a                         | Standard (Classical) Transaction         | n/a     | n/a              |
| 0.13.0  | 3          | 1       | [ProRegTx](#proregtx)       | Masternode Registration                  | hex     | compactSize uint |
| 0.13.0  | 3          | 2       | [ProUpServTx](#proupservtx) | Update Masternode Service                | hex     | compactSize uint |
| 0.13.0  | 3          | 3       | [ProUpRegTx](#proupregtx)   | Update Masternode Operator               | hex     | compactSize uint |
| 0.13.0  | 3          | 4       | [ProUpRevTx](#prouprevtx)   | Masternode Operator Revocation           | hex     | compactSize uint |
| 0.13.0  | 3          | 5       | [CbTx](#cbtx)               | Masternode List Merkle Proof             | hex     | compactSize uint |
| 0.13.0  | 3          | 6       | [QcTx](#qctx)               | Long-Living Masternode Quorum Commitment | hex     | compactSize uint |
| 18.0.0  | 3          | 7       | [MnHfTx](#mnhftx)           | Masternode hard fork signal              | hex     | compactSize uint |
| 21.0.0  | 3          | 8       | [AssetLockTx](#assetlocktx)   | Asset Lock Transaction                   | hex     | compactSize uint |
| 21.0.0  | 3          | 9       | [AssetUnlocktx](#assetunlocktx)   | Asset Unlock Transaction                   | hex     | compactSize uint |

```{eval-rst}
.. _ref-txs-proregtx:
```

## ProRegTx

*Added in protocol version 70213 of Dash Core as described by [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md)*

The [masternode](../resources/glossary.md#masternode) Registration (ProRegTx) special transaction is used to join the masternode list by proving ownership of the 1000 DASH necessary to create a masternode.

A ProRegTx is created and sent using the [`protx` RPC](../api/remote-procedure-calls-evo.md#protx). The ProRegTx must either include an [output](../resources/glossary.md#output) with 1000 DASH (`protx register`) or refer to an existing unspent output holding 1000 DASH (`protx fund_register`). If the 1000 DASH is an output of the ProRegTx, the collateralOutpoint hash field should be null.

The special transaction type is 1 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | Provider transaction version number. Currently set to 1.  Updated to 2 after v19 hard fork.
| 2 | type | uint_16 | Masternode type. Default set to 0.
| 2 | mode | uint_16 | Masternode mode. Default set to 0.
| 36 | collateralOutpoint | COutpoint | The collateral outpoint.<br>**Note:** The hash will be null if the collateral is part of this transaction, otherwise it will reference an existing collateral.
| 16 | ipAddress | byte[] | IPv6 address in network byte order. Only IPv4 mapped addresses are allowed (to be extended in the future)
| 2 | port | uint_16 | Port (network byte order)
| 20 | KeyIdOwner | CKeyID | The public key hash used for owner related signing (ProTx updates, governance voting)
| 48 | PubKeyOperator | CBLSPublicKey | The BLS public key used for operational related signing (network messages, ProTx updates).<br>**Note**: serialization varies based on `version`:<br> - Version 1 - legacy BLS scheme<br> - Version 2 - basic BLS scheme
| 20 | KeyIdVoting | CKeyID | The public key hash used for voting.
| 2 | operatorReward | uint_16 | A value from 0 to 10000.
| 1-9 | scriptPayoutSize | compactSize uint | Size of the Payee Script.
| Variable | scriptPayout | Script | Payee script (p2pkh/p2sh)
| 32 | inputsHash | uint256 | Hash of all the outpoints of the transaction inputs
| 0 or 20 | platformNodeID | byte[] | ***Added by ProRegTx version 2 in Dash Core 19.0.0***<br>Dash Platform P2P node ID, derived from P2P public key. Only present for masternode type 1.
| 0 or 2 | platformP2PPort | uint_16 | ***Added by ProRegTx version 2 in Dash Core 19.0.0***<br>TCP port of Dash Platform peer-to-peer communication between nodes (network byte order). Only present for masternode type 1.
| 0 or 2 | platformHTTPPort | uint_16 | ***Added by ProRegTx version 2 in Dash Core 19.0.0***<br>TCP port of Platform HTTP/API interface (network byte order). Only present for masternode type 1.
| 1-9 | payloadSigSize |compactSize uint | Size of the Signature
| Variable | payloadSig | vector | Signature of the hash of the ProTx fields. Signed with the key corresponding to the collateral outpoint in case the collateral is not part of the ProRegTx itself, empty otherwise.

The following annotated hexdump shows a ProRegTx transaction referencing an existing collateral. (Parts of the classical transaction section have been omitted.)

``` text Version 1 ProRegTx (existing collateral)
0300 ....................................... Version (3)
0100 ....................................... Type (1 - ProRegTx)

[...] ...................................... Transaction inputs omitted
[...] ...................................... Transaction outputs omitted

00000000 ................................... locktime: 0 (a block height)

fd1201 ..................................... Extra payload size (274)

ProRegTx Payload
| 0100 ..................................... Version (1)
| 0000 ..................................... Type (0)
| 0000 ..................................... Mode (0)
|
| 4859747b0eb19bb2dae5a12ef7b6a69b
| 03712bfeded1174de0b6ab1334ab2e8b ......... Outpoint TXID
| 01000000 ................................. Outpoint index number: 1
|
| 00000000000000000000ffffc0000233 ......... IP Address: ::ffff:192.0.2.51
| 270f ..................................... Port: 9999
|
|
| 1636e84d02310b0b458f3eb51d8ea8b2e684b7ce . Owner pubkey hash (ECDSA)
| 88d719278eef605d9c19037366910b59bc28d437
| de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8
| c22f4a914a6c5566 ......................... Operator public key (BLS)
| 1636e84d02310b0b458f3eb51d8ea8b2e684b7ce . Voting pubkey hash (ECDSA)
|
| f401 ..................................... Operator reward (500 -> 5%)
|
| Payout script
| 19 ....................................... Bytes in pubkey script: 25
| | 76 ..................................... OP_DUP
| | a9 ..................................... OP_HASH160
| | 14 ..................................... Push 20 bytes as data
| | | fc136008111fcc7a05be6cec66f97568
| | | 727a9e51 ............................. PubKey hash
| | 88 ..................................... OP_EQUALVERIFY
| | ac ..................................... OP_CHECKSIG
|
| 0fcfb7d939078ba6a6b81ecf1dc2e05d
| e2776f49f7b503ac254798be6a672699 ......... Inputs hash
|
| Payload signature
| 41 ....................................... Signature Size (65)
| 200476f193b465764093014ba44bd4ff
| de2b3fc92794c4acda9cad6305ca172e
| 9e3d6b1cd6e30f86678dae8e6595e53d
| 2b30bc32141b6c0151eb58479121b3e6a4 ....... Signature
```

The following annotated hexdump shows a ProRegTx transaction creating a new collateral.

**Note the presence of the output, a null Outpoint TXID and the absence of a signature (since it isn't referring to an existing collateral).** (Parts of the classical transaction section have been omitted.)

``` text Version 1 ProRegTx
0300 ....................................... Version (3)
0100 ....................................... Type (1 - ProRegTx)

[...] ...................................... Transaction inputs omitted

02 ......................................... Number of outputs
| [...] .................................... 1 output omitted
|
| Masternode collateral output
| | 00e8764817000000 ....................... Duffs (1000 DASH)
| | 1976a9149e648c7e4b61482aa3
| | 9bd10e0bf0b5268768005f88ac ............. Script

00000000 ................................... locktime: 0 (a block height)

d1 ......................................... Extra payload size (209)

ProRegTx Payload
| 0100 ..................................... Version (1)
| 0000 ..................................... Type (0)
| 0000 ..................................... Mode (0)
|
| 00000000000000000000000000000000
| 00000000000000000000000000000000 ......... Outpoint TXID
| 01000000 ................................. Outpoint index number: 1
|
| 00000000000000000000ffffc0000233 ......... IP Address: ::ffff:192.0.2.51
| 270f ..................................... Port: 9999
|
| 757a2171bbf92517e358249f20c37a8ad2d7a5bc . Owner pubkey hash (ECDSA)
| 0e02146e9c34cfbcb3f3037574a1abb35525e2ca
| 0c3c6901dbf82ac591e30218d1711223b7ca956e
| df39f3d984d06d51 ......................... Operator public key (BLS)
| 757a2171bbf92517e358249f20c37a8ad2d7a5bc . Voting pubkey hash (ECDSA)
|
| f401 ..................................... Operator reward (500 -> 5%)
|
| Payout script
| 19 ....................................... Bytes in pubkey script: 25
| | 76 ..................................... OP_DUP
| | a9 ..................................... OP_HASH160
| | 14 ..................................... Push 20 bytes as data
| | | 9e648c7e4b61482aa39bd10e0bf0b526
| | | 8768005f ............................. PubKey hash
| | 88 ..................................... OP_EQUALVERIFY
| | ac ..................................... OP_CHECKSIG
|
| 57b115d681b9aff82824ff7e22af99d4
| ac4b39ad7be7cb70b662e9011827d589 ......... Inputs hash
|
| Payload signature
| 00 ....................................... Signature Size (0)
| .......................................... Signature (Empty)
```

### Example ProRegTx

```Text Raw Transaction hex
03000100013ea08d68bd3038b8ea3d92d43fa38047522896724b04f246827d74b703bd3f2801000000
6a47304402201fe458e3dc2c6072848418fedd48fe79081be3c818301ce0a97de4c1dd5ee2da02206f
601d0de9540ac53ef7f9c59c92ef594237f8b23dad3b04b1005ff85fb61a5d0121022dce9621ff449f
e1a12648da526b93e0c2f8e43d14f8c1650f95272569d932a6feffffff011ec89a3b000000001976a9
14955410003527bf2b360a7a390b9ff14b9106c63288ac00000000fd12010100000000005c71e5f46d
35196e33b45c5d59d3fd2dc84381942064cae21744fb717412c1ac0100000000000000000000000000
ffff2f6fb5cf4e2199e9dff4cd5a0abc61b5287a0ba48c0553d6358890c0e9ec9dc5f08b1d4d021192
0fe5d96a225c555a4ba7dd7f6cb14e271c925f2fc72316a01282973f9ad9cf1e39e03829dcf16f7a66
b832d3b84dbab400a1e9eb7f30ac00001976a914955410003527bf2b360a7a390b9ff14b9106c63288
ac835b69acdba709707c5cccdfcc342eacc87d6db0cc676896a01fe433a0620ae4411f5da2e5444c6a
1556c3d45798b9f95567b1625b3f0cbe69936a70e35ca76b381f0a5506de07274e5e24db8be77234ad
8fa023938f750a283b39b1bff17b2ad11f
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "b43dadbd485e4d1e1d202ea5180f0ad4e8e7f05e97a7e566a764ed714356bd1f",
  "version": 3,
  "type": 1,
  "size": 468,
  "locktime": 0,
  "vin": [
    {
      "txid": "283fbd03b7747d8246f2044b729628524780a33fd4923deab83830bd688da03e",
      "vout": 1,
      "scriptSig": {
        "asm": "304402201fe458e3dc2c6072848418fedd48fe79081be3c818301ce0a97de4c1dd5ee2da02206f601d0de9540ac53ef7f9c59c92ef594237f8b23dad3b04b1005ff85fb61a5d[ALL] 022dce9621ff449fe1a12648da526b93e0c2f8e43d14f8c1650f95272569d932a6",
        "hex": "47304402201fe458e3dc2c6072848418fedd48fe79081be3c818301ce0a97de4c1dd5ee2da02206f601d0de9540ac53ef7f9c59c92ef594237f8b23dad3b04b1005ff85fb61a5d0121022dce9621ff449fe1a12648da526b93e0c2f8e43d14f8c1650f95272569d932a6"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 9.99999518,
      "valueSat": 999999518,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 955410003527bf2b360a7a390b9ff14b9106c632 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914955410003527bf2b360a7a390b9ff14b9106c63288ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "yZw2EYuVkTNUzUqd7mfXRNhCMReonL99tu"
        ]
      }
    }
  ],
  "extraPayloadSize": 274,
  "extraPayload": "0100000000005c71e5f46d35196e33b45c5d59d3fd2dc84381942064cae21744fb717412c1ac0100000000000000000000000000ffff2f6fb5cf4e2199e9dff4cd5a0abc61b5287a0ba48c0553d6358890c0e9ec9dc5f08b1d4d0211920fe5d96a225c555a4ba7dd7f6cb14e271c925f2fc72316a01282973f9ad9cf1e39e03829dcf16f7a66b832d3b84dbab400a1e9eb7f30ac00001976a914955410003527bf2b360a7a390b9ff14b9106c63288ac835b69acdba709707c5cccdfcc342eacc87d6db0cc676896a01fe433a0620ae4411f5da2e5444c6a1556c3d45798b9f95567b1625b3f0cbe69936a70e35ca76b381f0a5506de07274e5e24db8be77234ad8fa023938f750a283b39b1bff17b2ad11f",
  "proRegTx": {
    "version": 1,
    "type": 0,
    "collateralHash": "acc1127471fb4417e2ca6420948143c82dfdd3595d5cb4336e19356df4e5715c",
    "collateralIndex": 1,
    "service": "47.111.181.207:20001",
    "ownerAddress": "yaMGQThTVPUf1LBqVqa1jMTtLW7ByVbN78",
    "votingAddress": "yQ8oETtF1pRQfBP4iake2e5zyCCm85CAET",
    "payoutAddress": "yZw2EYuVkTNUzUqd7mfXRNhCMReonL99tu",
    "pubKeyOperator": "90c0e9ec9dc5f08b1d4d0211920fe5d96a225c555a4ba7dd7f6cb14e271c925f2fc72316a01282973f9ad9cf1e39e038",
    "operatorReward": 0,
    "inputsHash": "e40a62a033e41fa0966867ccb06d7dc8ac2e34ccdfcc5c7c7009a7dbac695b83"
  },
  "hex": "03000100013ea08d68bd3038b8ea3d92d43fa38047522896724b04f246827d74b703bd3f28010000006a47304402201fe458e3dc2c6072848418fedd48fe79081be3c818301ce0a97de4c1dd5ee2da02206f601d0de9540ac53ef7f9c59c92ef594237f8b23dad3b04b1005ff85fb61a5d0121022dce9621ff449fe1a12648da526b93e0c2f8e43d14f8c1650f95272569d932a6feffffff011ec89a3b000000001976a914955410003527bf2b360a7a390b9ff14b9106c63288ac00000000fd12010100000000005c71e5f46d35196e33b45c5d59d3fd2dc84381942064cae21744fb717412c1ac0100000000000000000000000000ffff2f6fb5cf4e2199e9dff4cd5a0abc61b5287a0ba48c0553d6358890c0e9ec9dc5f08b1d4d0211920fe5d96a225c555a4ba7dd7f6cb14e271c925f2fc72316a01282973f9ad9cf1e39e03829dcf16f7a66b832d3b84dbab400a1e9eb7f30ac00001976a914955410003527bf2b360a7a390b9ff14b9106c63288ac835b69acdba709707c5cccdfcc342eacc87d6db0cc676896a01fe433a0620ae4411f5da2e5444c6a1556c3d45798b9f95567b1625b3f0cbe69936a70e35ca76b381f0a5506de07274e5e24db8be77234ad8fa023938f750a283b39b1bff17b2ad11f",
  "blockhash": "0000000016e9bd30f97d98be7abc7934e24a064b1c8e7fefcb641694fe53e5d4",
  "height": 247288,
  "confirmations": 611337,
  "time": 1578970980,
  "blocktime": 1578970980,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}

```

```{eval-rst}
.. _ref-txs-proupservtx:
```

## ProUpServTx

*Added in protocol version 70213 of Dash Core as described by [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md)*

The [masternode](../resources/glossary.md#masternode) Provider Update Service (ProUpServTx) special transaction is used to update the IP Address and port of a masternode. If a non-zero operatorReward was set in the initial [ProRegTx](#proregtx), the operator may also set the scriptOperatorPayout field in the ProUpServTx.

A ProUpServTx is only valid for masternodes in the registered masternodes subset. When processed, it updates the metadata of the masternode entry and revives the masternode if it was previously marked as PoSe-banned.

A ProUpServTx is created and sent using the [`protx update_service` RPC](../api/remote-procedure-calls-evo.md#protx-update-service).

The special transaction type used for ProUpServTx Transactions is 2 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | ProUpServTx version number. Currently set to 1. Updated to 2 after Dash Core 19.0.0 hard fork.
| 2 | type | uint_16 | ***Added by ProUpServTx version 2 in Dash Core 19.0.0***<br>Masternode type
| 32 | proTXHash | uint256 | The hash of the initial ProRegTx
| 16 | ipAddress | byte[] | IPv6 address in network byte order. Only IPv4 mapped addresses are allowed (to be extended in the future)
| 2 | port | uint_16 | Port (network byte order)
| 1-9 | scriptOperator<br>PayoutSize | compactSize uint | Size of the Operator Payee Script.
| Variable | scriptOperator<br>Payout | Script | Operator Payee script (p2pkh/p2sh)
| 32 | inputsHash | uint256 | Hash of all the outpoints of the transaction inputs
| 0 or 20 | platformNodeID | byte[] | ***Added by ProUpServTx version 2 in Dash Core 19.0.0***<br>Dash Platform P2P node ID, derived from P2P public key. Only present for masternode type 1.
| 0 or 2 | platformP2PPort | uint_16 | ***Added by ProUpServTx version 2 in Dash Core 19.0.0***<br>TCP port of Dash Platform peer-to-peer communication between nodes (network byte order). Only present for masternode type 1.
| 0 or 2 | platformHTTPPort | uint_16 | ***Added by ProUpServTx version 2 in Dash Core 19.0.0***<br>TCP port of Platform HTTP/API interface (network byte order). Only present for masternode type 1.
| 1-9 | payloadSigSize |compactSize uint | Size of the Signature<br>**Note:** not present in BLS implementation
| 96 | payloadSig | vector | BLS Signature of the hash of the ProUpServTx fields. Signed by the Operator.<br>**Note**:  serialization varies based on `version`:<br> - Version 1 - legacy BLS scheme<br> - Version 2 - basic BLS scheme

The following annotated hexdump shows a ProUpServTx transaction. (Parts of the
classical transaction section have been omitted.)

``` text Version 1 ProUpServTx
0300 ....................................... Version (3)
0200 ....................................... Type (2 - ProUpServTx)

[...] ...................................... Transaction inputs omitted
[...] ...................................... Transaction outputs omitted

00000000 ................................... locktime: 0 (a block height)

b5 ......................................... Extra payload size (181)

ProUpServTx Payload
| 0100 ..................................... Version (1)
|
| db60b8cecae691a3d078a2341d460b06
| b2914f6b092f1906b5c815589399b0ff ......... ProRegTx Hash
|
| 00000000000000000000ffffc0000233 ......... IP Address: ::ffff:192.0.2.51
| 270f ..................................... Port: 9999
|
| 00 ....................................... Operator payout script size (0)
| .......................................... Operator payout script (Empty)
|
| a9569d037b0eacc8bca05c5829c95283
| 4ac27d1c7e7df610500b7ba70fd46507 ......... Inputs hash
|
| Payload signature (BLS)
| 0267702ef85d186ef7fa32dc40c65f2f
| eca0a7465715eb7c30f81beb69e35ee4
| 1f6ff7f292b82a9caebb5aa961b0f915
| 02501becf629e93c0a01c76162d56a6c
| 65a9675c3ca9d5297f053e68f91393dd
| 789beed8ef7e8839695a334c2e1bd37c ......... BLS Signature (96 bytes)
```

### Example ProUpServTx

```Text Raw Transaction hex
0300020001f88750ccc24410679d87ee63df5c8dfd901329aa1fe60a74c183d560eee5218d01000000
6a473044022029090e49ba2e387e7b39df51fdd6ec1becdd568cdd0de79f5dca6084bee67738022058
3bb62418aa986d927b4487d6a7f0469c4bc54a0e7baa0c484e8c140c37b3d301210345184cc81d6cd9
8eef548206f23a1467c27fea65582d519daa0f7a88a6c45666feffffff01e7edd23b000000001976a9
147f95c0f808aff27883260bfaf9cfe2b84519a6b288ac00000000b702000000ff92ce2d64657cc3d4
d9d82547efca2206ec1d9f5dcf2776624bc0a58b12ed3b00000000000000000000ffffae22e9734e1f
0026ad5ada35511fc5b9d762b14b22510325ef8b82d21d59567f8e1c3c9e0c955ab99a62829e6317b1
943d97f66191b1c6714146540788e2d26a1007498dce455603f55aebacf1a38131048abf7d5a05d00e
9e93c1e91cc8cad239b4301b328f5fe1bcbae829ccd6a3f461e712873a188224829fc4b5fc01fa0fb2
9014b947d8f7
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json
{
  "txid": "f1d23a149955d48ef7bf81ce0a58d4f47ae28399ed3e4ef3c1f90a55a6a9e082",
  "version": 3,
  "type": 2,
  "size": 375,
  "locktime": 0,
  "vin": [
    {
      "txid": "8d21e5ee60d583c1740ae61faa291390fd8d5cdf63ee879d671044c2cc5087f8",
      "vout": 1,
      "scriptSig": {
        "asm": "3044022029090e49ba2e387e7b39df51fdd6ec1becdd568cdd0de79f5dca6084bee677380220583bb62418aa986d927b4487d6a7f0469c4bc54a0e7baa0c484e8c140c37b3d3[ALL] 0345184cc81d6cd98eef548206f23a1467c27fea65582d519daa0f7a88a6c45666",
        "hex": "473044022029090e49ba2e387e7b39df51fdd6ec1becdd568cdd0de79f5dca6084bee677380220583bb62418aa986d927b4487d6a7f0469c4bc54a0e7baa0c484e8c140c37b3d301210345184cc81d6cd98eef548206f23a1467c27fea65582d519daa0f7a88a6c45666"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 10.03679207,
      "valueSat": 1003679207,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 7f95c0f808aff27883260bfaf9cfe2b84519a6b2 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a9147f95c0f808aff27883260bfaf9cfe2b84519a6b288ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "yXx44e8DiK4rCaYmJUMHSp3zGTFFvFaWLg"
        ]
      }
    }
  ],
  "extraPayloadSize": 183,
  "extraPayload": "02000000ff92ce2d64657cc3d4d9d82547efca2206ec1d9f5dcf2776624bc0a58b12ed3b00000000000000000000ffffae22e9734e1f0026ad5ada35511fc5b9d762b14b22510325ef8b82d21d59567f8e1c3c9e0c955ab99a62829e6317b1943d97f66191b1c6714146540788e2d26a1007498dce455603f55aebacf1a38131048abf7d5a05d00e9e93c1e91cc8cad239b4301b328f5fe1bcbae829ccd6a3f461e712873a188224829fc4b5fc01fa0fb29014b947d8f7",
  "proUpServTx": {
    "version": 2,
    "type": 0,
    "proTxHash": "3bed128ba5c04b627627cf5d9f1dec0622caef4725d8d9d4c37c65642dce92ff",
    "service": "174.34.233.115:19999",
    "inputsHash": "5a950c9e3c1c8e7f56591dd2828bef250351224bb162d7b9c51f5135da5aad26"
  },
  "hex": "0300020001f88750ccc24410679d87ee63df5c8dfd901329aa1fe60a74c183d560eee5218d010000006a473044022029090e49ba2e387e7b39df51fdd6ec1becdd568cdd0de79f5dca6084bee677380220583bb62418aa986d927b4487d6a7f0469c4bc54a0e7baa0c484e8c140c37b3d301210345184cc81d6cd98eef548206f23a1467c27fea65582d519daa0f7a88a6c45666feffffff01e7edd23b000000001976a9147f95c0f808aff27883260bfaf9cfe2b84519a6b288ac00000000b702000000ff92ce2d64657cc3d4d9d82547efca2206ec1d9f5dcf2776624bc0a58b12ed3b00000000000000000000ffffae22e9734e1f0026ad5ada35511fc5b9d762b14b22510325ef8b82d21d59567f8e1c3c9e0c955ab99a62829e6317b1943d97f66191b1c6714146540788e2d26a1007498dce455603f55aebacf1a38131048abf7d5a05d00e9e93c1e91cc8cad239b4301b328f5fe1bcbae829ccd6a3f461e712873a188224829fc4b5fc01fa0fb29014b947d8f7",
  "blockhash": "0000024ea047afdb72b301d3a6501e1027b101c7bc047e1377da0efbe7495bcf",
  "height": 854855,
  "confirmations": 3772,
  "time": 1679598509,
  "blocktime": 1679598509,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}
```

```{eval-rst}
.. _ref-txs-proupregtx:
```

## ProUpRegTx

*Added in protocol version 70213 of Dash Core as described by [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md)*

The [masternode](../resources/glossary.md#masternode) Provider Update Registrar (ProUpRegTx) special transaction is used by a masternode owner to update masternode metadata (e.g. operator/voting key details or the payout script).

A ProUpRegTx is created and sent using the [`protx update_registrar` RPC](../api/remote-procedure-calls-evo.md#protx-update-registrar).

The special transaction type is 3 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | Provider update registrar transaction version number. Currently set to 1. Updated to 2 after Dash Core 19.0.0 hard fork.
| 32 | proTXHash | uint256 | The hash of the initial ProRegTx
| 2 | mode | uint_16 | Masternode mode. Default set to 0.
| 48 | PubKeyOperator | CBLSPublicKey | The BLS public key used for operational related signing (network messages, ProTx updates).<br>**Note**: serialization varies based on `version`:<br> - Version 1 - legacy BLS scheme<br> - Version 2 - basic BLS scheme
| 20 | KeyIdVoting | CKeyID | The public key hash used for voting.
| 1-9 | scriptPayoutSize | compactSize uint | Size of the Payee Script.
| Variable | scriptPayout | Script | Payee script (p2pkh/p2sh)
| 32 | inputsHash | uint256 | Hash of all the outpoints of the transaction inputs
| 1-9 | payloadSigSize |compactSize uint | Size of the Signature
| Variable | payloadSig | vector | Signature of the hash of the ProTx fields. Signed with the key corresponding to the collateral outpoint in case the collateral is not part of the ProRegTx itself, empty otherwise.

The following annotated hexdump shows a ProUpRegTx transaction referencing an
existing collateral. (Parts of the classical transaction section have been omitted.)

``` text Version 1 ProUpRegTx
0300 ....................................... Version (3)
0300 ....................................... Type (3 - ProUpRegTx)

[...] ...................................... Transaction inputs omitted
[...] ...................................... Transaction outputs omitted

00000000 ................................... locktime: 0 (a block height)

e4 ......................................... Extra payload size (228)

ProRegTx Payload
| 0100 ..................................... Version (1)
|
| ddaf13bf1b02de39711de911e646c63e
| f089b6cee786a1b776086ae130331bba ......... ProRegTx Hash
|
| 0000 ..................................... Mode (0)
|
| 0e02146e9c34cfbcb3f3037574a1abb35525e2ca
| 0c3c6901dbf82ac591e30218d1711223b7ca956e
| df39f3d984d06d51 ......................... Operator public key (BLS)
| 757a2171bbf92517e358249f20c37a8ad2d7a5bc . Voting pubkey hash (ECDSA)
|
| Payout script
| 19 ....................................... Bytes in pubkey script: 25
| | 76 ..................................... OP_DUP
| | a9 ..................................... OP_HASH160
| | 14 ..................................... Push 20 bytes as data
| | | 9e648c7e4b61482aa39bd10e0bf0b526
| | | 8768005f ............................. PubKey hash
| | 88 ..................................... OP_EQUALVERIFY
| | ac ..................................... OP_CHECKSIG
|
| 50b50b24193b2b16f0383125c1f4426e
| 883d256eeadee96d500f8c08b0e0f9e4 ......... Inputs hash
|
| Payload signature
| 41 ....................................... Signature Size (65)
| 1ffa8a27ae0301e414176d4c876cff2e
| 20b810683a68ab7dcea95de1f8f36441
| 4c56368f189a3ef7a59b83bd77f22431
| a73d347841a58768b94c771819dc2bbce3 ....... Signature
```

### Example ProUpRegTx

```Text Raw Transaction hex
0300030001f9485c88c87c282dc4de6b826afbba91c49aaa5bc75a0c0110465988573b5fd501000000
6a4730440220085ea9929647b789429fa07bc83cf2a1c457628bc686be1e3014fdc5c2f9cc22022037
47c39ad3a09a58a4b6f4ab6e8a08529cc9bdca86fe74689b1013b72ec6f92f012102ea1bcf94f4a787
a3a94f15ce0a954ea4131be49d0f545531c7df1720045b85fffeffffff0133edd23b000000001976a9
14dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088ac00000000e4020099bf316f8cb867be68dc9b
d89bf2b8b984eae2fa9fa6ac19e862459cb7cf79390000a73d8c1e640d29e2257042a39bbbac8d867f
69ae252e146884816b98ab0d0526ed4992d9cff22ef04878423f66583382f00e43355184a124cf6a37
1433e3fb1d792bd5421976a914dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088acbe428d911be8
7c670640d3cf73f1490b327be4b33a4fac8bcb70ca934199b4774120dc2d1ce8ea4188f04953528e11
2fd1402ab7434cdc5cc9f245468d952e1fa6d83701f90fc8e74c10bc32fec5c7e2beda675ce8a3cb85
9d25d8aa2cff5962ece6
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "ff5782f5537ef18b919b5ad0a2c605a72d83b4092434dcc8273e2d53ac0d0113",
  "version": 3,
  "type": 3,
  "size": 420,
  "locktime": 0,
  "vin": [
    {
      "txid": "d55f3b5788594610010c5ac75baa9ac491bafb6a826bdec42d287cc8885c48f9",
      "vout": 1,
      "scriptSig": {
        "asm": "30440220085ea9929647b789429fa07bc83cf2a1c457628bc686be1e3014fdc5c2f9cc2202203747c39ad3a09a58a4b6f4ab6e8a08529cc9bdca86fe74689b1013b72ec6f92f[ALL] 02ea1bcf94f4a787a3a94f15ce0a954ea4131be49d0f545531c7df1720045b85ff",
        "hex": "4730440220085ea9929647b789429fa07bc83cf2a1c457628bc686be1e3014fdc5c2f9cc2202203747c39ad3a09a58a4b6f4ab6e8a08529cc9bdca86fe74689b1013b72ec6f92f012102ea1bcf94f4a787a3a94f15ce0a954ea4131be49d0f545531c7df1720045b85ff"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 10.03679027,
      "valueSat": 1003679027,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 dc82946c9cee9ab3e8fef5a5d641a57bdf1523c0 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "ygRPwFLoC8WeW3ujqrskqHZiQvKpTHF6qv"
        ]
      }
    }
  ],
  "extraPayloadSize": 228,
  "extraPayload": "020099bf316f8cb867be68dc9bd89bf2b8b984eae2fa9fa6ac19e862459cb7cf79390000a73d8c1e640d29e2257042a39bbbac8d867f69ae252e146884816b98ab0d0526ed4992d9cff22ef04878423f66583382f00e43355184a124cf6a371433e3fb1d792bd5421976a914dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088acbe428d911be87c670640d3cf73f1490b327be4b33a4fac8bcb70ca934199b4774120dc2d1ce8ea4188f04953528e112fd1402ab7434cdc5cc9f245468d952e1fa6d83701f90fc8e74c10bc32fec5c7e2beda675ce8a3cb859d25d8aa2cff5962ece6",
  "proUpRegTx": {
    "version": 2,
    "proTxHash": "3979cfb79c4562e819aca69ffae2ea84b9b8f29bd89bdc68be67b88c6f31bf99",
    "votingAddress": "yiCk7DjwBbUGJuJofTA7eXU4hyybu123pD",
    "payoutAddress": "ygRPwFLoC8WeW3ujqrskqHZiQvKpTHF6qv",
    "pubKeyOperator": "a73d8c1e640d29e2257042a39bbbac8d867f69ae252e146884816b98ab0d0526ed4992d9cff22ef04878423f66583382",
    "inputsHash": "77b4994193ca70cb8bac4f3ab3e47b320b49f173cfd34006677ce81b918d42be"
  },
  "hex": "0300030001f9485c88c87c282dc4de6b826afbba91c49aaa5bc75a0c0110465988573b5fd5010000006a4730440220085ea9929647b789429fa07bc83cf2a1c457628bc686be1e3014fdc5c2f9cc2202203747c39ad3a09a58a4b6f4ab6e8a08529cc9bdca86fe74689b1013b72ec6f92f012102ea1bcf94f4a787a3a94f15ce0a954ea4131be49d0f545531c7df1720045b85fffeffffff0133edd23b000000001976a914dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088ac00000000e4020099bf316f8cb867be68dc9bd89bf2b8b984eae2fa9fa6ac19e862459cb7cf79390000a73d8c1e640d29e2257042a39bbbac8d867f69ae252e146884816b98ab0d0526ed4992d9cff22ef04878423f66583382f00e43355184a124cf6a371433e3fb1d792bd5421976a914dc82946c9cee9ab3e8fef5a5d641a57bdf1523c088acbe428d911be87c670640d3cf73f1490b327be4b33a4fac8bcb70ca934199b4774120dc2d1ce8ea4188f04953528e112fd1402ab7434cdc5cc9f245468d952e1fa6d83701f90fc8e74c10bc32fec5c7e2beda675ce8a3cb859d25d8aa2cff5962ece6",
  "instantlock": true,
  "instantlock_internal": true,
  "chainlock": false
}

```

```{eval-rst}
.. _ref-txs-prouprevtx:
```

## ProUpRevTx

*Added in protocol version 70213 of Dash Core as described by [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md)*

The [masternode](../resources/glossary.md#masternode) Operator Revocation (ProUpRevTx) special transaction allows an operator to revoke their key in case of compromise or if they wish to terminate service. If a masternode's operator key is revoked, the masternode becomes ineligible for payment until the owner provides a new operator key (via a ProUpRegTx).

A ProUpRevTx is created and sent using the [`protx revoke` RPC](../api/remote-procedure-calls-evo.md#protx-revoke).

The special transaction type used for ProUpServTx Transactions is 4 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | ProUpRevTx version number. Currently set to 1.  Updated to 2 after Dash Core 19.0.0 hard fork.
| 32 | proTXHash | uint256 | The hash of the initial ProRegTx
| 2 | reason | uint_16 | The reason for revoking the key.<br>`0` - Not specified<br>`1` - Termination of Service<br>`2` - Compromised Key<br>`3` - Change of key
| 32 | inputsHash | uint256 | Hash of all the outpoints of the transaction inputs
| 1-9 | payloadSigSize |compactSize uint | Size of the Signature<br>**Note:** not present in BLS implementation
| 96 | payloadSig | vector | BLS Signature of the hash of the ProUpServTx fields. Signed by the Operator.<br>**Note**:  serialization varies based on `version`:<br> - Version 1 - legacy BLS scheme<br> - Version 2 - basic BLS scheme

The following annotated hexdump shows a ProUpRevTx transaction. (Parts of the classical transaction section have been omitted.)

``` text Version 1 ProUpRevTx
0300 ....................................... Version (3)
0400 ....................................... Type (4 - ProUpRevTx)

[...] ...................................... Transaction inputs omitted
[...] ...................................... Transaction outputs omitted

00000000 ................................... locktime: 0 (a block height)

a4 ......................................... Extra payload size (164)

ProUpRevTx Payload
| 0100 ..................................... Version (1)
|
| ddaf13bf1b02de39711de911e646c63e
| f089b6cee786a1b776086ae130331bba ......... ProRegTx Hash
|
| 0000 ..................................... Reason: 0 (Not specified)
|
| cb0dfe113c87f8e9cde2c5d18aae12fc
| 8d0617c42c34ca5c2f2f6ab4b1dae164 ......... Inputs hash
|
| Payload signature (BLS)
| 0adaef4bf1a904308f1b0efbdfaffc93
| 864f9e047fd83415c831589180303711
| 0f0d8adb312ab43ddd7f8086042d3f5b
| 09029a6a16c341c9d2a62789b495fef4
| e068da711dac28106ff354db7249ae88
| 05877d82ff7d1af00ae2d303dea5eb3b ......... BLS Signature (96 bytes)
```

### Example ProUpRevTx

```text Raw transaction hex
03000400016f8a813df204873df003d6efc44e1906eaf6180a762513b1c91252826ce05916000000006b483045022100
9b50474beacd48b37340eb5715a5ebd92239e54595147b5c55018bc29f26bde302203f312cdd8009f3f03b9bb9a00074
361974a40f5f5fafaf16ba4378cb72adcc4201210250a5b41488dec3d4116ae5733d18d03326050aebc3958118d64773
9ad1a5de24feffffff01b974ed6d000000001976a914f0ae84a7ea8a0efd48c155eeeaaed6eb64c2812188ac00000000a4
01006f8a813df204873df003d6efc44e1906eaf6180a762513b1c91252826ce05916010082cf248cf6b8ac6a3cdc826eda
e582ead20421659ed891f9d4953a540616fb4f05279584b3339ed2ba95711ad28b18ee2878c4a904f76ea4d103e1d739
f22ff7e3b9b3db7d0c4a7e120abb4952c3574a18de34fa29828f9fe3f52bd0b1fac17acd04f7751967d782045ab6550536
53438f1dd1e14ba6adeb8351b78c9eb59bf4
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "6926d964bccfd4418e373f08cf41d3302f9616ee5d9bc40b18aa99fc18a3d4ea",
  "version": 3,
  "type": 4,
  "size": 357,
  "locktime": 0,
  "vin": [
    {
      "txid": "1659e06c825212c9b11325760a18f6ea06194ec4efd603f03d8704f23d818a6f",
      "vout": 0,
      "scriptSig": {
        "asm": "30450221009b50474beacd48b37340eb5715a5ebd92239e54595147b5c55018bc29f26bde302203f312cdd8009f3f03b9bb9a00074361974a40f5f5fafaf16ba4378cb72adcc42[ALL] 0250a5b41488dec3d4116ae5733d18d03326050aebc3958118d647739ad1a5de24",
        "hex": "4830450221009b50474beacd48b37340eb5715a5ebd92239e54595147b5c55018bc29f26bde302203f312cdd8009f3f03b9bb9a00074361974a40f5f5fafaf16ba4378cb72adcc4201210250a5b41488dec3d4116ae5733d18d03326050aebc3958118d647739ad1a5de24"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 18.44278457,
      "valueSat": 1844278457,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 f0ae84a7ea8a0efd48c155eeeaaed6eb64c28121 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914f0ae84a7ea8a0efd48c155eeeaaed6eb64c2812188ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "yiG45yiCksvpd1iLU5o3Dsj8GYRsWvGchu"
        ]
      }
    }
  ],
  "extraPayloadSize": 164,
  "extraPayload": "01006f8a813df204873df003d6efc44e1906eaf6180a762513b1c91252826ce05916010082cf248cf6b8ac6a3cdc826edae582ead20421659ed891f9d4953a540616fb4f05279584b3339ed2ba95711ad28b18ee2878c4a904f76ea4d103e1d739f22ff7e3b9b3db7d0c4a7e120abb4952c3574a18de34fa29828f9fe3f52bd0b1fac17acd04f7751967d782045ab655053653438f1dd1e14ba6adeb8351b78c9eb59bf4",
  "proUpRevTx": {
    "version": 1,
    "proTxHash": "1659e06c825212c9b11325760a18f6ea06194ec4efd603f03d8704f23d818a6f",
    "reason": 1,
    "inputsHash": "4ffb1606543a95d4f991d89e652104d2ea82e5da6e82dc3c6aacb8f68c24cf82"
  },
  "hex": "03000400016f8a813df204873df003d6efc44e1906eaf6180a762513b1c91252826ce05916000000006b4830450221009b50474beacd48b37340eb5715a5ebd92239e54595147b5c55018bc29f26bde302203f312cdd8009f3f03b9bb9a00074361974a40f5f5fafaf16ba4378cb72adcc4201210250a5b41488dec3d4116ae5733d18d03326050aebc3958118d647739ad1a5de24feffffff01b974ed6d000000001976a914f0ae84a7ea8a0efd48c155eeeaaed6eb64c2812188ac00000000a401006f8a813df204873df003d6efc44e1906eaf6180a762513b1c91252826ce05916010082cf248cf6b8ac6a3cdc826edae582ead20421659ed891f9d4953a540616fb4f05279584b3339ed2ba95711ad28b18ee2878c4a904f76ea4d103e1d739f22ff7e3b9b3db7d0c4a7e120abb4952c3574a18de34fa29828f9fe3f52bd0b1fac17acd04f7751967d782045ab655053653438f1dd1e14ba6adeb8351b78c9eb59bf4",
  "blockhash": "00000000052bba30e878367092bd76c287c184cf1ae48053860e2a8150b031a2",
  "height": 13899,
  "confirmations": 844713,
  "time": 1546027092,
  "blocktime": 1546027092,
  "instantlock": false,
  "instantlock_internal": false,
  "chainlock": false
}
```

```{eval-rst}
.. _ref-txs-cbtx:
```

## CbTx

*Added in protocol version 70213 of Dash Core as described by [DIP4](https://github.com/dashpay/dips/blob/master/dip-0004.md)*

The Coinbase (CbTx) special transaction adds information to the [block](../resources/glossary.md#block) [coinbase transaction](../resources/glossary.md#coinbase-transaction) that enables verification of the deterministic masternode list without the full chain (e.g. from [SPV](../resources/glossary.md#simplified-payment-verification) clients). This allows light-clients to properly verify [InstantSend](../resources/glossary.md#instantsend) transactions and support additional deterministic masternode list functionality in the future.

The special transaction type used for CbTx Transactions is 5 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | CbTx version number. Currently set to 2.
| 4 | height | uint32_t | Height of the block
| 32 | merkleRootMNList | uint256 | Merkle root of the masternode list
| 32 | merkleRootQuorums | uint256 | *Added by CbTx version 2 in v0.14.0*<br><br>Merkle root of currently active LLMQs
| 1-9 | bestCLHeightDiff | compactSize uint | ***Added by CbTx version 3 in v20.0.0***<br><br>Number of blocks between the current block and the last known block with a ChainLock
| 96 | bestCLSignature | CBLSSignature | ***Added by CbTx version 3 in Dash Core 20.0.0***<br>Best ChainLock signature known by the miner
| 8 | creditPoolBalance | int64_t | ***Added by CbTx version 3 in Dash Core v20.0.0***<br>Balance in the Platform credit pool

Version History

| CbTx<br>Version | First Supported<br>Protocol Version | Dash Core<br>Version |  Notes |
| ---------- | ----------- | -------- | -------- |
| 1 | 70213 | 0.13.0 | Enabled by [DIP3](https://github.com/dashpay/dips/blob/master/dip-0003.md) activation
| 2 | 70214 | 0.14.0 | Enabled by [DIP8](https://github.com/dashpay/dips/blob/master/dip-0008.md) activation
| 3 | 70230 | 20.0.0 | Enabled by [DIP29](https://github.com/dashpay/dips/blob/master/dip-0029.md) activation

The following annotated hexdump shows a CbTx transaction (v3).

An itemized coinbase transaction:

``` text
0300 ....................................... Version (3)
0500 ....................................... Type (5 - Coinbase)

01 ......................................... Number of inputs
| 00000000000000000000000000000000
| 00000000000000000000000000000000 ......... Previous outpoint TXID
| ffffffff ................................. Previous outpoint index
|
| 27 ....................................... Bytes in coinbase: 39
| |
| | 03 ..................................... Bytes in height
| | | da5c1e ............................... Height: 1989850
| |
| | 04d04580650800007588782d01000fe4
| | b883e5bda9e7a59ee4bb99e9b1bc04f09f909f . Arbitrary data
| 88f581b8 ................................. Sequence

02 ......................................... Output count
| Transaction Output
| | 53640f0300000000 ....................... Duffs (0.51340371 DASH)
| | 1976a9147c086eada12bdb10a265c16c
| | 08a7ae87366bd48188ac ................... Script
|
| Transaction Output 2
| | f82c2e0900000000 ....................... Duffs (1.54021112 DASH)
| | 1976a91453dc8bffae84a3851ab9fe29
| | 6417da85d5e7185888ac ................... P2PKH script

a0f04c20 ................................... Locktime

af ......................................... Extra payload size (175)

Coinbase Transaction Payload
| 0300 ..................................... Version (3)
|
| da5c1e00 ................................. Block height: 1989850
|
| 54e04067fa61cef61f1e91b0d52c21b2
| 8cdc69cc9d0383f0bb88ba0129b973e2 ......... MN List merkle root
|
| f67e47d5580e70c7e77af8b1a6670669
| c7424b896ab3d44d349a4988e9a8328d ......... Active LLMQ merkle root
|
| 00 ....................................... Best ChainLock height diff
|
| b22fef542f5c630e4f2a67ad56d30cf2
| a3dac55848abcd2bac30bf780318792b
| cdf32f7729443846c9fdc57050a131cd
| 12c0e54a16f6265e900f459e3b9dd434
| 21a0bc3f61efd49ce752e440e5131a8d
| 2758a280ad883b8eb902c49ee5b878b3 ......... ChainLock BLS signature
|
| 0000000000000000 ......................... Credit pool balance (0.0 DASH)
```

### Example CbTx

```Text Raw Transaction hex
03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff
03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff
2703da5c1e04d04580650800007588782d01000fe4b883e5bda9e7a59ee4bb99e9b1bc04f09f909f88
f581b80253640f03000000001976a9147c086eada12bdb10a265c16c08a7ae87366bd48188acf82c2e
09000000001976a91453dc8bffae84a3851ab9fe296417da85d5e7185888aca0f04c20af0300da5c1e
0054e04067fa61cef61f1e91b0d52c21b28cdc69cc9d0383f0bb88ba0129b973e2f67e47d5580e70c7
e77af8b1a6670669c7424b896ab3d44d349a4988e9a8328d00b22fef542f5c630e4f2a67ad56d30cf2
a3dac55848abcd2bac30bf780318792bcdf32f7729443846c9fdc57050a131cd12c0e54a16f6265e90
0f459e3b9dd43421a0bc3f61efd49ce752e440e5131a8d2758a280ad883b8eb902c49ee5b878b30000
000000000000
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "c550cae3f65d396a2f517a7220c7851cc3dc065e20141dadf9f19676348730f2",
  "version": 3,
  "type": 5,
  "size": 334,
  "locktime": 541913248,
  "vin": [
    {
      "coinbase": "03da5c1e04d04580650800007588782d01000fe4b883e5bda9e7a59ee4bb99e9b1bc04f09f909f",
      "sequence": 3095524744
    }
  ],
  "vout": [
    {
      "value": 0.51340371,
      "valueSat": 51340371,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 7c086eada12bdb10a265c16c08a7ae87366bd481 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a9147c086eada12bdb10a265c16c08a7ae87366bd48188ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "XmzfivrzYQ7B7oBMZKwPRdhjB1iNvX71XZ"
        ]
      }
    },
    {
      "value": 1.54021112,
      "valueSat": 154021112,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 53dc8bffae84a3851ab9fe296417da85d5e71858 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91453dc8bffae84a3851ab9fe296417da85d5e7185888ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "XiLG83Jj8reHt7YH4H4JQ16q7c2q78KCSz"
        ]
      }
    }
  ],
  "extraPayloadSize": 175,
  "extraPayload": "0300da5c1e0054e04067fa61cef61f1e91b0d52c21b28cdc69cc9d0383f0bb88ba0129b973e2f67e47d5580e70c7e77af8b1a6670669c7424b896ab3d44d349a4988e9a8328d00b22fef542f5c630e4f2a67ad56d30cf2a3dac55848abcd2bac30bf780318792bcdf32f7729443846c9fdc57050a131cd12c0e54a16f6265e900f459e3b9dd43421a0bc3f61efd49ce752e440e5131a8d2758a280ad883b8eb902c49ee5b878b30000000000000000",
  "cbTx": {
    "version": 3,
    "height": 1989850,
    "merkleRootMNList": "e273b92901ba88bbf083039dcc69dc8cb2212cd5b0911e1ff6ce61fa6740e054",
    "merkleRootQuorums": "8d32a8e988499a344dd4b36a894b42c7690667a6b1f87ae7c7700e58d5477ef6",
    "bestCLHeightDiff": 0,
    "bestCLSignature": "b22fef542f5c630e4f2a67ad56d30cf2a3dac55848abcd2bac30bf780318792bcdf32f7729443846c9fdc57050a131cd12c0e54a16f6265e900f459e3b9dd43421a0bc3f61efd49ce752e440e5131a8d2758a280ad883b8eb902c49ee5b878b3",
    "creditPoolBalance": 0.00000000
  },
  "hex": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff2703da5c1e04d04580650800007588782d01000fe4b883e5bda9e7a59ee4bb99e9b1bc04f09f909f88f581b80253640f03000000001976a9147c086eada12bdb10a265c16c08a7ae87366bd48188acf82c2e09000000001976a91453dc8bffae84a3851ab9fe296417da85d5e7185888aca0f04c20af0300da5c1e0054e04067fa61cef61f1e91b0d52c21b28cdc69cc9d0383f0bb88ba0129b973e2f67e47d5580e70c7e77af8b1a6670669c7424b896ab3d44d349a4988e9a8328d00b22fef542f5c630e4f2a67ad56d30cf2a3dac55848abcd2bac30bf780318792bcdf32f7729443846c9fdc57050a131cd12c0e54a16f6265e900f459e3b9dd43421a0bc3f61efd49ce752e440e5131a8d2758a280ad883b8eb902c49ee5b878b30000000000000000",
  "blockhash": "0000000000000025033c275e59b2b6beda724cf5ab49a96e001d080b68d00279",
  "height": 1989850,
  "confirmations": 135,
  "time": 1702905296,
  "blocktime": 1702905296,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}
```

```{eval-rst}
.. _ref-txs-qctx:
```

## QcTx

*Added in protocol version 70213 of Dash Core as described by [DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md)*

:::{note}
This special transaction has no inputs and no outputs and thus also pays no fee.
:::

The Quorum Commitment (QcTx) special transaction adds the best final commitment from a [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum) (LLMQ) Distributed Key Generation (DKG) session to the chain.

Since this special transaction pays no fees, it is mandatory by [consensus rules](../resources/glossary.md#consensus-rules) to ensure that miners include it. Exactly one quorum commitment transaction MUST be included in every [block](../resources/glossary.md#block) while in the mining phase of the LLMQ process until a valid commitment is present in a block.

If a DKG failed or a [miner](../resources/glossary.md#miner) did not receive a final commitment in-time, a null commitment has to be included in the special transaction payload. A null commitment must have the `signers` and `validMembers` bitsets set to the `quorumSize` and all bits set to zero. All other fields must be set to the null representation of the field’s types.

The special transaction type used for Quorum Commitment Transactions is 6 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 2 | version | uint_16 | Quorum Commitment version number. Currently set to 1. Will change to 2 after Dash Core v18.0 hard fork.
| 4 | height | uint32_t | Height of the block
| Variable | commitment | qfcommit | The payload of the [`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit)

The following annotated hexdump shows a QcTx transaction.

An itemized quorum commitment transaction (v1):

``` text
0300 ....................................... Version (3)
0600 ....................................... Type (6 - Quorum Commitment)

00 ......................................... Number of inputs
00 ......................................... Number of outputs

00000000 ................................... Locktime

fd4901 ..................................... Extra payload size (329)

Quorum Commitment Transaction Payload
| 0100 ..................................... Version (1)
|
| 934c0100 ................................. Block height: 85139
|
| Payload from the qfcommit message
| | 0100 ................................... Version (1)
| |
| | 01 ..................................... LLMQ Type (1)
| |
| | 6b2fd2c61cea32d939ee7fe185c7abc5
| | 01aa7001d973379f46b9200500000000 ....... Quorum hash
| |
| | 32 ..................................... Number of signers (50)
| | bfffffffffff03 ......................... Aggregrated signers bitvector
| |
| | 32 ..................................... Number of valid members (50)
| | bfffffffffff03 ......................... Valid members bitvector
| |
| | 9450e90f61a24a4205c92572666ed068
| | 40f617ac11a26d650c88769675e81197
| | 993858d8b695f120f0af7dd38c17a67e ....... Quorum public key (BLS)
| |
| | 912507814fe204c59e14720bc961c09f
| | f88a4fd1f15e9c2efd4e4f112720967d ....... Quorum verification vector hash
| |
| | Quorum threshold signature (BLS)
| | 0281c321090c2d2e59a0d3754dcfbc11
| | d76c26a152b50885d826915af4d95a73
| | 120d0e1ba7e96d89f40252e24109c323
| | 0971dda1f554d331985ca570c76b9a1a
| | ec699ec132838ae097c767d65d0a51d7
| | 017c62e062270b60b854ae912bc07437 ....... BLS Signatures (96 bytes)
| |
| | Aggregated signatures from all commitments (BLS)
| | 91f878a0ae620e2178bff06c3a3967d7
| | 433d4b82e7879bb927dd5cb605423c84
| | 0641fcddf3731da80d0515a172ff3666
| | 0f4eac88ee8fd7779e32e4f0be704078
| | df31601b87b95374cebb4b304afc543e
| | e0d4f461a2ba0e32a711197ca559dacf ....... BLS Signature (96 bytes)
```

### Example QcTx

```Text Raw Transaction hex
03000600000000000000fd49010100d3710b000100016deffc783c55e385653fe687fb5ec594
46e4c3a2146898ca297e02013300000032ffffffffffff0332ffffffffffff031636185ce736
08e3077536f0621bea1fbc78449f96e40b1f67ca7b50a7638562c716bc9d4fdaa7002be06e6e
54c49369d91c78768678912d3ec71d2d11d92e42488772bd3cdcaa2ce15a016e9eb998048af4
e3ce1100e5188d30c2769e811691f75e94b20fe4c3867b918483319b7f4c7b924599a621b876
fbfa943cd38017bb1226e55beb1df752ddc74470e04f38e8e644d5a74c2783f939b72728bcc6
c5b22b21ed8caf3bcfb90212a8ee6517afeb04ec5a9af7064c7df1f92b01b7cc71e7f76f6dbc
8e53cdd5d5f274566eece977e9431cc9bedf76a241ac95faea018e160bdf89270808acef4f63
1fcd8a551d896581455a37a33f8ef6202145bc1561a404798dffd339b105b5716937e4086f04
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction)

```json JSON Representation
{
  "txid": "82600f79f0f58299995775382af1e813bdbe593b270e4e891baec064307f2a54",
  "version": 3,
  "type": 6,
  "size": 342,
  "locktime": 0,
  "vin": [
  ],
  "vout": [
  ],
  "extraPayloadSize": 329,
  "extraPayload": "0100d3710b000100016deffc783c55e385653fe687fb5ec59446e4c3a2146898ca297e02013300000032ffffffffffff0332ffffffffffff031636185ce73608e3077536f0621bea1fbc78449f96e40b1f67ca7b50a7638562c716bc9d4fdaa7002be06e6e54c49369d91c78768678912d3ec71d2d11d92e42488772bd3cdcaa2ce15a016e9eb998048af4e3ce1100e5188d30c2769e811691f75e94b20fe4c3867b918483319b7f4c7b924599a621b876fbfa943cd38017bb1226e55beb1df752ddc74470e04f38e8e644d5a74c2783f939b72728bcc6c5b22b21ed8caf3bcfb90212a8ee6517afeb04ec5a9af7064c7df1f92b01b7cc71e7f76f6dbc8e53cdd5d5f274566eece977e9431cc9bedf76a241ac95faea018e160bdf89270808acef4f631fcd8a551d896581455a37a33f8ef6202145bc1561a404798dffd339b105b5716937e4086f04",
  "qcTx": {
    "version": 1,
    "height": 750035,
    "commitment": {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "0000003301027e29ca986814a2c3e44694c55efb87e63f6585e3553c78fcef6d",
      "quorumIndex": 0,
      "signersCount": 50,
      "signers": "ffffffffffff03",
      "validMembersCount": 50,
      "validMembers": "ffffffffffff03",
      "quorumPublicKey": "1636185ce73608e3077536f0621bea1fbc78449f96e40b1f67ca7b50a7638562c716bc9d4fdaa7002be06e6e54c49369",
      "quorumVvecHash": "0498b99e6e015ae12caadc3cbd728748422ed9112d1dc73e2d91788676781cd9",
      "quorumSig": "8af4e3ce1100e5188d30c2769e811691f75e94b20fe4c3867b918483319b7f4c7b924599a621b876fbfa943cd38017bb1226e55beb1df752ddc74470e04f38e8e644d5a74c2783f939b72728bcc6c5b22b21ed8caf3bcfb90212a8ee6517afeb",
      "membersSig": "04ec5a9af7064c7df1f92b01b7cc71e7f76f6dbc8e53cdd5d5f274566eece977e9431cc9bedf76a241ac95faea018e160bdf89270808acef4f631fcd8a551d896581455a37a33f8ef6202145bc1561a404798dffd339b105b5716937e4086f04"
    }
  },
  "hex": "03000600000000000000fd49010100d3710b000100016deffc783c55e385653fe687fb5ec59446e4c3a2146898ca297e02013300000032ffffffffffff0332ffffffffffff031636185ce73608e3077536f0621bea1fbc78449f96e40b1f67ca7b50a7638562c716bc9d4fdaa7002be06e6e54c49369d91c78768678912d3ec71d2d11d92e42488772bd3cdcaa2ce15a016e9eb998048af4e3ce1100e5188d30c2769e811691f75e94b20fe4c3867b918483319b7f4c7b924599a621b876fbfa943cd38017bb1226e55beb1df752ddc74470e04f38e8e644d5a74c2783f939b72728bcc6c5b22b21ed8caf3bcfb90212a8ee6517afeb04ec5a9af7064c7df1f92b01b7cc71e7f76f6dbc8e53cdd5d5f274566eece977e9431cc9bedf76a241ac95faea018e160bdf89270808acef4f631fcd8a551d896581455a37a33f8ef6202145bc1561a404798dffd339b105b5716937e4086f04",
  "blockhash": "000000adc9d8a9ff83e79d78efb30f70c73c1f22496bb5d86b775f1d79203fbe",
  "height": 750035,
  "confirmations": 108598,
  "time": 1656194626,
  "blocktime": 1656194626,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}

```

```{eval-rst}
.. _ref-txs-mnhftx:
```

## MnHfTx

*Fully implemented in protocol version 70230 of Dash Core as described by [DIP23](https://github.com/dashpay/dips/blob/master/dip-0023.md)*

:::{note}
This special transaction has no inputs and no outputs and thus also pays no fee
:::

The Masternode Hard Fork Signal (MnHfTx) special transaction adds the masternode hard fork signal produced by an LLMQ_400_85 quorum to the chain. Since this special transaction pays no fees, it is mandatory by consensus rules to ensure that miners include it. This can be done by any miner in any block, but it should only be included once.

The special transaction type used for Masternode Hard Fork Signal Transactions is 7 and the extra payload consists of the following data:

| Bytes | Name | Data type |  Description |
| ---------- | ----------- | -------- | -------- |
| 1 | version | uint_8 | Special transaction version number. Currently set to 1. Please note that this is *not* the same as the `versionBit` field of the `mnhfsignal` message. |
| 129 | commitment | mnhfsignal | The payload of the `mnhfsignal` message defined in [DIP23](https://github.com/dashpay/dips/blob/master/dip-0023.md#new-system) |

The `mnhfsignal` message contains:

| Bytes | Name | Data type | Description |
|-|-|-|-|
| 1 | versionBit | uint8_t | The version bit associated with the hard fork |
| 32 | quorumHash | uint256 | Hash of the quorum signing this message |
| 96 | sig | CBLSSig | BLS signature on `version` by a public key associated with the quorum referenced by `quorumHash` |

The following annotated hexdump shows a MnHfTx transaction. (Parts of the classical transaction section have been omitted.)

``` text
0300 ....................................... Version (3)
0700 ....................................... Type (7 - Masternode Hard Fork Signal)

00 ......................................... Number of inputs (0)
00 ......................................... Number of outputs (0)
00000000 ................................... Locktime (0)
82 ......................................... Extra payload size (130)

Masternode Hard Fork Payload
| 01 ....................................... MnHfTx version (1)
|
| Commitment Signal
| | 0a ..................................... Hard fork bit (10)
| | 
| | 27b679cb0c70b6d93f22d1a690c1e99f
| | 72fb9fdb4be9987c1000000000000000 ....... Quorum hash
| |
| | a12bc6a3d43e76fd6ab5d48dff119988
| | 11747bf51ffe722d9fda93ae892e4b18
| | a716f58045c86459d0dafd38ae1f7f52
| | 0519002983fc307e92fa606c3eb5ac8c
| | f6ca03a102889866d58c9207b483e0b9
| | 75baee63c1202209293ff7393222f812 ....... BLS signature
```

### Example MnHfTx

```Text Raw Transaction hex
0300070000000000000082010a27b679cb0c70b6d93f22d1a690c1e99f72fb9fdb4be9987c1000000000000000a12bc6a3d43e76fd6ab5d48dff11998811747bf51ffe722d9fda93ae892e4b18a716f58045c86459d0dafd38ae1f7f520519002983fc307e92fa606c3eb5ac8cf6ca03a102889866d58c9207b483e0b975baee63c1202209293ff7393222f812
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "5acff2cce2486b897258746202017649c5bdd873ece9e6d0298e5cccf0f23275",
  "version": 3,
  "type": 7,
  "size": 141,
  "locktime": 0,
  "vin": [
  ],
  "vout": [
  ],
  "extraPayloadSize": 130,
  "extraPayload": "010a27b679cb0c70b6d93f22d1a690c1e99f72fb9fdb4be9987c1000000000000000a12bc6a3d43e76fd6ab5d48dff11998811747bf51ffe722d9fda93ae892e4b18a716f58045c86459d0dafd38ae1f7f520519002983fc307e92fa606c3eb5ac8cf6ca03a102889866d58c9207b483e0b975baee63c1202209293ff7393222f812",
  "mnhfTx": {
    "version": 1,
    "signal": {
      "versionBit": 10,
      "quorumHash": "00000000000000107c98e94bdb9ffb729fe9c190a6d1223fd9b6700ccb79b627",
      "sig": "a12bc6a3d43e76fd6ab5d48dff11998811747bf51ffe722d9fda93ae892e4b18a716f58045c86459d0dafd38ae1f7f520519002983fc307e92fa606c3eb5ac8cf6ca03a102889866d58c9207b483e0b975baee63c1202209293ff7393222f812"
    }
  },
  "fee": 0.00000000,
  "hex": "0300070000000000000082010a27b679cb0c70b6d93f22d1a690c1e99f72fb9fdb4be9987c1000000000000000a12bc6a3d43e76fd6ab5d48dff11998811747bf51ffe722d9fda93ae892e4b18a716f58045c86459d0dafd38ae1f7f520519002983fc307e92fa606c3eb5ac8cf6ca03a102889866d58c9207b483e0b975baee63c1202209293ff7393222f812",
  "instantlock": true,
  "instantlock_internal": false
}
```

```{eval-rst}
.. _ref-txs-assetlocktx:
```

## AssetLockTx

The Asset Lock transaction is a DIP2-based special transaction that gives Platform the information to assign credits to [identities](inv:platform:std#explanations-identity).

The special transaction type used for asset lock transactions is 8 and the extra payload consists of the following data:

| Bytes | Name | Data type | Description |
|-|-|-|-|
| 1 | version | uint8_t | Asset lock payload version number |
| 1 | count | uint8_t | Number of accounts funded by this asset lock |
| Variable | credit_outputs | vector<TxOut> | The hash of the public key used to claim credits on Dash Platform, as well as the amount of Dash in duffs transferred into credits for this hash |

The following annotated hexdump shows an asset lock transaction.

``` text
0300 ....................................... Version (3)
0800 ....................................... Type (8 - Asset Lock)

01 ......................................... Number of inputs
| eecf4e8f1ffd3a3a4e5033d618231fd0
| 5e5f08c1a727aac420f9a26db9bf39eb ......... Previous outpoint TXID
| 01000000 ................................. Previous outpoint index (1)
|
| 6a ....................................... Bytes in script: 106
|
| 473044022026f169570532332f857cb6
| 4a0b7d9c0837d6f031633e1d6c395d7c
| 03b799460302207eba4c4575a66803ce
| cf50b61ff5f2efc2bd4e61dff00d9d48
| 47aa3d8b1a5e550121036cd0b73d304b
| acc80fa747d254fbc5f0bf944dd8c8b9
| 25cd161bb499b790d08d03 ................... Signature script
|
| 00000000 ................................. Sequence

02 ......................................... Number of outputs
| Transaction Output 1
| | 317dd0be03000000 ....................... Duffs (160.86236465 DASH)
| | 23 ..................................... Bytes in script: 35
| | 21022ca85dba11c4e5a6da3a00e73a08765
| | 319a5d66c2f6434b288494337b0c9ed2dac .... Script
|
| Transaction Output 2
| | 6df29c3b00000000 ....................... Duffs (10.00141421 DASH)
| | 02 ..................................... Bytes in script: 2
| | 6a00 ................................... Script (OP_RETURN)

00000000 ................................... Locktime

46 ......................................... Extra payload size (70)

Asset Lock Payload
| 01 ....................................... Version (1)
|
| 02 ....................................... Count: 2
|
| Credit Output 1
| | 00e1f50500000000 ....................... Duffs (100000000 DASH)
| | 1976a9147c75beb097957cc095
| | 37b615dde9ea6807719cdf88ac ............. Script
|
| Credit Output 2
| | 6d11a73500000000 ....................... Duffs (900141421 DASH)
| | 1976a9147c75beb097957cc095
| | 37b615dde9ea6807719cdf88ac ............. Script
```

### Example Asset Lock Transaction

```Text Raw Transaction hex
0300080001eecf4e8f1ffd3a3a4e5033d618231fd05e5f08c1a727aac420f9a26db9bf39eb0
10000006a473044022026f169570532332f857cb64a0b7d9c0837d6f031633e1d6c395d7c03
b799460302207eba4c4575a66803cecf50b61ff5f2efc2bd4e61dff00d9d4847aa3d8b1a5e5
50121036cd0b73d304bacc80fa747d254fbc5f0bf944dd8c8b925cd161bb499b790d08d0000
000002317dd0be030000002321022ca85dba11c4e5a6da3a00e73a08765319a5d66c2f6434b
288494337b0c9ed2dac6df29c3b00000000026a000000000046010200e1f505000000001976
a9147c75beb097957cc09537b615dde9ea6807719cdf88ac6d11a735000000001976a9147c7
5beb097957cc09537b615dde9ea6807719cdf88ac
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "fdb0e981c3febc6c2c032e6f51e6f063bfc6aaa9bd238985a442c93bd376fd57",
  "version": 3,
  "type": 8,
  "size": 283,
  "locktime": 0,
  "vin": [
    {
      "txid": "eb39bfb96da2f920c4aa27a7c1085f5ed01f2318d633504e3a3afd1f8f4ecfee",
      "vout": 1,
      "scriptSig": {
        "asm": "3044022026f169570532332f857cb64a0b7d9c0837d6f031633e1d6c395d7c03b799460302207eba4c4575a66803cecf50b61ff5f2efc2bd4e61dff00d9d4847aa3d8b1a5e55[ALL] 036cd0b73d304bacc80fa747d254fbc5f0bf944dd8c8b925cd161bb499b790d08d",
        "hex": "473044022026f169570532332f857cb64a0b7d9c0837d6f031633e1d6c395d7c03b799460302207eba4c4575a66803cecf50b61ff5f2efc2bd4e61dff00d9d4847aa3d8b1a5e550121036cd0b73d304bacc80fa747d254fbc5f0bf944dd8c8b925cd161bb499b790d08d"
      },
      "sequence": 0
    }
  ],
  "vout": [
    {
      "value": 160.86236465,
      "valueSat": 16086236465,
      "n": 0,
      "scriptPubKey": {
        "asm": "022ca85dba11c4e5a6da3a00e73a08765319a5d66c2f6434b288494337b0c9ed2d OP_CHECKSIG",
        "hex": "21022ca85dba11c4e5a6da3a00e73a08765319a5d66c2f6434b288494337b0c9ed2dac",
        "type": "pubkey"
      }
    },
    {
      "value": 10.00141421,
      "valueSat": 1000141421,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_RETURN 0",
        "hex": "6a00",
        "type": "nulldata"
      }
    }
  ],
  "extraPayloadSize": 70,
  "extraPayload": "010200e1f505000000001976a9147c75beb097957cc09537b615dde9ea6807719cdf88ac6d11a735000000001976a9147c75beb097957cc09537b615dde9ea6807719cdf88ac",
  "assetLockTx": {
    "version": 1,
    "creditOutputs": [
      {
        "value": 1.00000000,
        "valueSat": 100000000,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 7c75beb097957cc09537b615dde9ea6807719cdf OP_EQUALVERIFY OP_CHECKSIG",
          "hex": "76a9147c75beb097957cc09537b615dde9ea6807719cdf88ac",
          "address": "yXfXh3jFYHHxnJZVsXnPcktCENqPaAhcX1",
          "type": "pubkeyhash"
        }
      },
      {
        "value": 9.00141421,
        "valueSat": 900141421,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 7c75beb097957cc09537b615dde9ea6807719cdf OP_EQUALVERIFY OP_CHECKSIG",
          "hex": "76a9147c75beb097957cc09537b615dde9ea6807719cdf88ac",
          "address": "yXfXh3jFYHHxnJZVsXnPcktCENqPaAhcX1",
          "type": "pubkeyhash"
        }
      }
    ]
  }
}
```

```{eval-rst}
.. _ref-txs-assetunlocktx:
```

## AssetUnlockTx

:::{note}
This special transaction has no inputs
:::

The Asset Unlock transaction is a DIP2-based special transaction that enables Platform credits to be withdrawn back to Dash.

The special transaction type used for asset unlock transactions is 9 and the extra payload consists of the following data:

| Bytes | Name | Data type | Description |
|-|-|-|-|
| 1 | version | uint8_t | Asset unlock payload version number |
| 8 | index | uint64_t | The index of the transaction |
| 4 | fee | uint32_t | The transaction fee in duffs that should be awarded to the miner |
| 4 | requestedHeight | uint32_t | The payment chain block height known by platform at the moment of the withdrawal signing |
| 32 | quorumHash | uint256 | Hash of the quorum signing this message |
| 96 | quorumSig | CBLSSig | BLS signature for the entire transaction by a public key associated with the quorum referenced by `quorumHash` |

The following annotated hexdump shows an asset unlock transaction.

``` text
0300 ....................................... Version (3)
0900 ....................................... Type (9 - Asset Unlock)

00 ......................................... Number of inputs

01 ......................................... Number of outputs
| Transaction Output 1
| | 90cff40500000000 ....................... Duffs (0.99930000 DASH)
| | 23 ..................................... Bytes in script: 35
| | 2103d2c317552f5617f534065b9693fd4d7
| | a8925daacdb9d44e908f9ffb0d285ea61ac .... Script

00000000 ................................... Locktime

91 ......................................... Extra payload size (145)

Asset Unlock Payload
| 01 ....................................... Version (1)
|
| 6500000000000000 ......................... Index: 101
| 70110100 ................................. Fee: 70000
| db040000 ................................. Requested height: 1243
|
| 6f0f4a04d9a37a8c7791e90428d596d0
| caf5dc85292537ff92ffd361300c3101 ......... Quorum hash
|
| a533b35ae1d7685c6c795b7344963d48
| 589d536a1c2b22e6a580b46439adaaf8
| 51b4243b48be81d508ef3ff622bcba26
| 030b5bf8aa404dd3b5876727f4112a9d
| af99f27d250059679ae5abd30bc3029d
| eeeb7267c1fa6204f6976a3a7a2512ea ......... Quorum Signature
```

### Example AssetUnlockTx

```Text Raw Transaction hex
03000900000190cff40500000000232103d2c317552f5617f534065b9693fd4d7a8925daacd
b9d44e908f9ffb0d285ea61ac000000009101650000000000000070110100db0400006f0f4a
04d9a37a8c7791e90428d596d0caf5dc85292537ff92ffd361300c3101a533b35ae1d7685c6
c795b7344963d48589d536a1c2b22e6a580b46439adaaf851b4243b48be81d508ef3ff622bc
ba26030b5bf8aa404dd3b5876727f4112a9daf99f27d250059679ae5abd30bc3029deeeb726
7c1fa6204f6976a3a7a2512ea
```

The JSON representation of a raw transaction can be obtained with the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) or the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction).

```json JSON Representation
{
  "txid": "fb1b419b2b909f2ddb7fabee91d8e1aa7bb8e7114c83712ff20ba1859ec57b30",
  "version": 3,
  "type": 9,
  "size": 200,
  "locktime": 0,
  "vin": [
  ],
  "vout": [
    {
      "value": 0.99930000,
      "valueSat": 99930000,
      "n": 0,
      "scriptPubKey": {
        "asm": "03d2c317552f5617f534065b9693fd4d7a8925daacdb9d44e908f9ffb0d285ea61 OP_CHECKSIG",
        "hex": "2103d2c317552f5617f534065b9693fd4d7a8925daacdb9d44e908f9ffb0d285ea61ac",
        "type": "pubkey"
      }
    }
  ],
  "extraPayloadSize": 145,
  "extraPayload": "01650000000000000070110100db0400006f0f4a04d9a37a8c7791e90428d596d0caf5dc85292537ff92ffd361300c3101a533b35ae1d7685c6c795b7344963d48589d536a1c2b22e6a580b46439adaaf851b4243b48be81d508ef3ff622bcba26030b5bf8aa404dd3b5876727f4112a9daf99f27d250059679ae5abd30bc3029deeeb7267c1fa6204f6976a3a7a2512ea",
  "assetUnlockTx": {
    "version": 1,
    "index": 101,
    "fee": 70000,
    "requestedHeight": 1243,
    "quorumHash": "01310c3061d3ff92ff37252985dcf5cad096d52804e991778c7aa3d9044a0f6f",
    "quorumSig": "a533b35ae1d7685c6c795b7344963d48589d536a1c2b22e6a580b46439adaaf851b4243b48be81d508ef3ff622bcba26030b5bf8aa404dd3b5876727f4112a9daf99f27d250059679ae5abd30bc3029deeeb7267c1fa6204f6976a3a7a2512ea"
  }
}
```
