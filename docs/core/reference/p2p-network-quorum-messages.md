```{eval-rst}
.. meta::
  :title: Quorum Messages
  :description: The network messages in this section enable the long-living masternode quorum (LLMQ) features built in to Dash.
```

# Quorum Messages

The following network messages enable the long-living masternode quorum ([LLMQ](../resources/glossary.md#long-living-masternode-quorum)) features built in to Dash.

## Distributed Key Generation

The following network messages enable the creation of long living masternode quorums (LLMQs) as described in [DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md).

With the exception of the [`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit), these messages are for intra-quorum communication only and are not propagated on the Dash network.

### qcontrib

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qcontrib` message](../reference/p2p-network-quorum-messages.md#qcontrib) is used by each member of the DKG process to send key contributions to all other members.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 |  The quorum identifier
| 32 | proTxHash | uint256 | The [ProRegTx](../reference/transactions-special-transactions.md#proregtx) hash of the complaining member
| 1-9 | vvecSize | compactSize uint | The size of the verification vector
| 48 * `vvecSize` | vvec | BLSPubKey[] | The verification vector
| 48 | ephemeralPubKey | BLSPubKey | Ephemeral BLS public key used to encrypt secret key contributions<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation
| 32 | iv | uint256 | Initialization vector
| 1-9 | skCount | compactSize uint | Number of encrypted secret key contributions
| (1 + 32) * (`skCount`) | skContributions | byte[] | Secret key contributions encrypted to recipient masternodes’ BLS public operator key.<br><br>Each contribution consists of:<br>- Size: 1 byte<br>- Secret Key: 32 bytes
| 96 | sig | byte[] | BLS signature, signed with the operator key of the contributing masternode<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

More information can be found in the [Contribution phase section of DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#2-contribution-phase).

The following annotated hexdump shows a [`qcontrib` message](../reference/p2p-network-quorum-messages.md#qcontrib). (The message header has been omitted.)

``` text
01  ........................................ LLMQ Type: 1 (LLMQ_50_60)

cb9a1552340175a8232437eb8ceceaea
4b90a0f75caff20ee12d230b00000000 ...........  Quorum Hash

cd1c97c52ccf163ee5dc264d411efc90
b07729cd34d9d2e7c7b3ca4b2a4e77cf ........... ProRegTx Hash

1e ......................................... Verification Vector Size: 30

Verification Vector (Truncated)
| 8da71ba5030e28c6c4de5e0eb1660d0f
| a9fd21ef4fef700a556f10286c9c34fb
| beb36fffb5b2a552a40d6c8e27aac338
| [...]
| 99d8649d226261162bcb5a11617d1732
| 553b8358d85b1d9e12a88eb3e979fb7c
| e49b5a21a82a74e9d06233199cb73db4 ......... Verification Vector (1440 bytes)

8d664929b596cdc8eb835d652944d61b
7fd21fd60ba0288af4f9e3a10658c8a8
56467082c728e2037791166705ada03a ........... Ephemeral BLS Public Key

93037a05b65adad6f5d44edc43500bff
71605f0e5f90ab92e3e0b46461c1c64d ........... IV Seed

32 ......................................... Contribution count: 50
Contributions
| Secret Key Contribution #1
| | 20 ..................................... Contribution Size: 32 bytes
| | | 31f3e8e5b2cc2063ee7fd1dd469dca12
| | | 4bdf506ee46fe825d5537aa3ce838225 ..... Encrypted Secret Key contribution
|
| Secret Key Contribution #2
| | 20 ..................................... Contribution Size: 32 bytes
| | | a6b3ff696ffc5e0c0a9b444c515edc48
| | | 5a9ccea0268c2a445fac5e24feda51a9 ..... Encrypted Secret Key contribution
|
| [...] .................................... 47 contributions omitted
|
| Secret Key Contribution #50
| | 20 ..................................... Contribution Size: 32 bytes
| | | 25f54cff411a577db9a416a60067f512
| | | 0750c77720207eb1484c90767b72faf8 ..... Encrypted Secret Key contribution

81f1003546f6735849c5691af93d324d
3a719fc4bb6d719907de3bce9833228e
648d03cd80666d70600fa8c936d30046
07bd444af3e494fb2a21273fcfa51986
3c4e139c67d2ffe0df07ac27ae63a0c8
e000da1aeda5f98ec9e64b801681bfc1 ........... BLS signature (Operator Key)
```

### qcomplaint

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qcomplaint` message](../reference/p2p-network-quorum-messages.md#qcomplaint) is used to notify other members in the DKG process of any members that provided no contribution or an invalid secret key contribution. The notifications are divided into 2 fields:

* `badMembers` - Sets a bit for each member that failed to provide a contribution
* `complaints` - Sets a bit for each member that provided an invalid contribution

If a threshold number of quorum participants indicate a masternode didn't contribute, that masternode will be excluded from the quorum. Members that simply have a complaint against them are given an opportunity to respond (via a [`qjustify` message](../reference/p2p-network-quorum-messages.md#qjustify)) to attempt to prove to all participants that they did participate.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 |  The quorum identifier
| 32 | proTxHash | uint256 | The [ProRegTx](../reference/transactions-special-transactions.md#proregtx) hash of the complaining member
| 1-9 | badBitSize | compactSize uint | Number of bits in the bad members bitvector
| (`badBitSize` + 7) / 8 | badMembers | byte[] | The bad members bitvector
| 1-9 | complaintsBitSize | compactSize uint | Number of bits in the complaints bitvector
| (`complaints`<br>`BitSize` + 7) / 8 | complaints | byte[] | The complaints bitvector
| 96 | sig | byte[] | BLS signature, signed with the operator key of the contributing masternode<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

More information can be found in the [Complaining phase section of DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#3-complaining-phase).

The following annotated hexdump shows a [`qcomplaint` message](../reference/p2p-network-quorum-messages.md#qcomplaint). (The message header has been omitted.)

``` text
01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

b34b2bcb3430f403663e37be9c63c88e
4ca1f12c41846064cf960a0800000000 ........... Quorum Hash

b375607540bd9c6e4a5452d8c7a6a626
ec715222a0650321487843c79cac67d5 ........... ProRegTx hash

32 ......................................... Bad member bitvector size: 50
08800200004000 ............................. Bad members

32 ......................................... Complaints bitvector size: 50
00020080040000 ............................. Complaints

0639b0e8ccb667c161207ddc03183d4e
bb632eeb60f29e351963032a673abd61
3fb3e847dff78699481193cf385f0e08
0fdf518e26ef1e258b724408b1ee9d70
511696092b6c2ebfad5e24154a7f859f
0efe3fcb8d7042da624f7298876cc98e ........... BLS signature (Operator Key)
```

### qdata

*Added in protocol version 70219 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qdata` message](../reference/p2p-network-quorum-messages.md#qdata) is used to send quorum DKG data to a node that has requested it via a [`qgetdata` message](../reference/p2p-network-quorum-messages.md#qgetdata). The response will include one or more of the following depending on what was requested:

* Quorum verification vector for the request quorum
* Encrypted contributions for the request Protx hash

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 byte | quorumType | uint8_t | Type of the quorum the data is about.
| 32 bytes | quorumHash | uint256 | Hash of the quorum the data is about.
| 2 bytes | dataMask | uint16 | This value should be equal to the `dataMask` value of the requesting QGETDATA.
| 32 bytes | protxHash | uint256 | This is the protx hash of the member which can decrypt the data in `data_0002`. Included if 0x0002 is set in dataMask.
| 1 byte | error | uint8 | See [Possible error codes](#possible-error-codes)
| Variable | data_0001 | BLSVerificationVector | Included if `0x0001` is set in the `dataMask` value of the requesting QGETDATA.
| Variable | data_0002 | `<CBLSIESEncryptedObject`<br>`<CBLSSecretKey>>[]` | Included if `0x0002` is set in the `dataMask` value of the requesting QGETDATA.

**Verification Vector**

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1-9 | vvecSize | compactSize uint | The size of the verification vector
| 48 * `vvecSize` | vvec | BLSPubKey[] | The verification vector

**Encrypted Contributions**

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 48 | ephemeralPubKey | BLSPubKey | Ephemeral BLS public key used to encrypt secret key contributions
| 32 | ivSeed | uint256 | Seed used to create the AES initialization vectors
| 1-9 | dataSize | compactSize uint | The size of the data
| Variable | data | unsigned char[] | Encrypted data

#### Possible Error Codes

| Value | Name | Description |
| - | - | - |
| 0x00 | None | No error, this value will be represented if the QGETDATA request could be processed successfully.
| 0x01 | `QUORUM_TYPE_INVALID` | The quorum type provided in the `quorumType` field is invalid.
| 0x02 | `QUORUM_BLOCK_NOT_FOUND` | The hash provided in the `quorumHash` field wasn’t found in the active chain.
| 0x03 | `QUORUM_NOT_FOUND` | The quorum (combination of type and hash) wasn’t found in the active chain.
| 0x04 | `MASTERNODE_IS_NO_MEMBER` | The masternode with the protx-hash provided in the `protxHash` field is not a valid member of the requested quorum.
| 0x05 | `QUORUM_VERIFICATION_VECTOR_MISSING` | The quorum verification vector for the requested quorum is missing internally.
| 0x06 | `ENCRYPTED_CONTRIBUTIONS_MISSING` | The encrypted contributions for the requested member are missing for the requested quorum internally.

The following annotated hexdump shows a [`qdata` message](../reference/p2p-network-quorum-messages.md#qdata). (The message header has been omitted.)

``` text
04 ......................................... LLMQ Type: 4 (LLMQ_100_67)

250ff2f885949154570edb272d3bf64e
5fc3d8d63c4705aac106cd57da000000 ........... Quorum Hash

0100 ....................................... Data mask: 1 (Verification Vector)

8d7d9e4d9a10b8d5a1d2035d5427f8bb
c7ccb13df0c0e950b4d1b737808c2c72 ........... ProRegTx hash

00 ......................................... Error Code: 0 (None)

Data (Verification Vectors)
| 43 ....................................... Verification vector size: 0x43 (67)
|
| 0c59f5450d17b2b21e7ddccc8f86eb96
| 20c02af428fc1c2fefe4a04fb2803025 ......... Verification vector 1
| 
| 9dcfe843af100de279ed9e7eb50cdebf
| 8158abdc37872fac3269d70a7a9ea462 ......... Verification vector 2
| 
| Data truncated
|
| e8d3467d381a2069c3006db78a099ba3
| a1064d8d6782b8be7de610b37308a715 ......... Verification vector 67
```

### qgetdata

*Added in protocol version 70219 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qgetdata` message](../reference/p2p-network-quorum-messages.md#qgetdata) is used to request DKG data from a masternode. The response to a `qgetdata` message is a [`qdata` message](../reference/p2p-network-quorum-messages.md#qdata). These messages allows an LLMQ member to recover its DKG data if needed with the help of other members of that LLMQ type.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 | The quorum identifier
| 2 | dataMask | uint16_t | Specifies what data to request:<br>`1` - Quorum verification vector<br>`2` - Encrypted contributions for member defined by `proTxHash`  (`proTxHash` must be specified if this option is used)<br>`3` - Both verification vector and encrypted contributions
| 32 | proTxHash | uint256 | The [ProRegTx](../reference/transactions-special-transactions.md#proregtx) hash the contributions will be requested for. Must be a member of the specified LLMQ.

The following annotated hexdump shows a [`qgetdata` message](../reference/p2p-network-quorum-messages.md#qgetdata). (The message header has been omitted.)

``` text
04 ......................................... LLMQ Type: 4 (LLMQ_100_67)

250ff2f885949154570edb272d3bf64e
5fc3d8d63c4705aac106cd57da000000 ........... Quorum Hash

0100 ....................................... Data mask: 1

8d7d9e4d9a10b8d5a1d2035d5427f8bb
c7ccb13df0c0e950b4d1b737808c2c72 ........... ProRegTx hash
```

### qjustify

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qjustify` message](../reference/p2p-network-quorum-messages.md#qjustify) is used to respond to complaints. This provides a way for [nodes](../resources/glossary.md#node) that have been complained about to offer proof of correct behavior. If a valid justification is not provided, all other nodes mark it as a bad. If a valid justification is provided, the complaining node is marked as bad instead (since it submitted a bad complaint).

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 |  The quorum identifier
| 32 | proTxHash | uint256 | The [ProRegTx](../reference/transactions-special-transactions.md#proregtx) hash of the complaining member
| 1-9 | skContributions<br>Count | compactSize uint | Number of unencrypted secret key contributions
| 36 * `skContributions`<br>`Count` | skContribution | SKContribution | Member index and secret key contribution for members justifying complaints
| 96 | sig | byte[] | BLS signature, signed with the operator key of the contributing masternode<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

An `SKContribution` consists of:

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 4 | skContributionMember | uint32_t | Index of the member for which justification is provided
| 32 | skContributions | byte[] | Unencrypted secret key contribution for the member contained in skContributionMember

More information can be found in the [Justification phase section of DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#4-justification-phase).

The following annotated hexdump shows a [`qjustify` message](../reference/p2p-network-quorum-messages.md#qjustify). (The message header has been omitted.)

``` text
01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

b34b2bcb3430f403663e37be9c63c88e
4ca1f12c41846064cf960a0800000000 ........... Quorum Hash

e7d909afba6848f3fdf98b2da31db07e
3fbee621d58c469dce96d6283bcd4b25 ........... ProRegTx hash

05 ......................................... Contribution count: 5

Contribution #1
| 16000000 ................................. Member Index: 22
|
| 57b63ec5ae0a101f0d93bb60af70bf22
| c21bd3a7705e1aecb9559d6b151d953f ......... Unencrypted secret key contribution

Contribution #2
| 17000000 ................................. Member Index: 22
|
| 0ee1f0f0f2570589e81d2a4f8165b105
| 28436a1a75cf3469fa81090f2d856150 ......... Unencrypted secret key contribution

[...] ...................................... 3 more contributions omitted

8d63d10e242ac97c6324e9a40d6e690e
4bb7fe0750b7d204f7e988a324720189
68408d2d0621bbaba8380ad4aaf342ea
138ce9a59ed9ca82995c155609488dcc
5ac35f483b695a0624e5ab0745f7f9e2
051edf1b3b1f0e1b1d55d185d25e0ed7 ........... BLS signature (Operator Key)
```

### qpcommit

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qpcommit` message](../reference/p2p-network-quorum-messages.md#qpcommit) is used to exchange premature commitment messages for verification and selection of the final commitment.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 | The quorum identifier
| 32 | proTxHash | uint256 | The [ProRegTx](../reference/transactions-special-transactions.md#proregtx) hash of the complaining member
| 1-9 | validMembersSize | compactSize uint | Bit size of the `validMembers` bitvector
| (`valid`<br>`MembersSize` + 7) / 8 | validMembers | byte[] | Bitset of valid members in this commitment
| 48 | quorumPublicKey | uint256 | The quorum public key<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation
| 32 | quorumVvecHash | byte[] | The hash of the quorum verification vector
| 96 | quorumSig | BLSSig | Threshold signature, signed with the threshold signature share of the committing member<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation
| 96 | sig | byte[] | BLS signature, signed with the operator key of the contributing masternode<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

More information can be found in the [Commitment phase section of DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#5-commitment-phase).

The following annotated hexdump shows a [`qpcommit` message](../reference/p2p-network-quorum-messages.md#qpcommit). (The message header has been omitted.)

``` text
01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

cb9a1552340175a8232437eb8ceceaea
4b90a0f75caff20ee12d230b00000000 ........... Quorum Hash

59c38b8d6a0664411f92a6326e8ef070
7ecf185405252854ddb477d89127a32d ........... ProRegTx hash

32 ......................................... Valid member bitvector size: 50
ffffffffffff03 ............................. Valid members

102809b8649209a15fceb3984014eb39
70ca9bd2464b2f84353a3353f4d612eb
7ca6daaf723170cdbdad40c5cf44f87b ........... Quorum BLS Public Key

17431ce7dfecb9bba4ccba5921514d24
fe267c61078bdfe29d90774a3b766ad5 ........... Quorum Verification Vector Hash

94f7417e0ed56ada7116cf4f1e400748
deb2e2040babd540f21925b2eec8d4df
75d3e0fc3323d083db76f66ce6128a13
0f1b2c4725076dae2283bbecbf2e1230
72cc9cec244337008bf82a670ab9e2ee
6220dd736a1a70c9ca87867ca55f8665 ........... BLS Threshold signature

85723fe503bba8ac814eab0f28f1fd07
49927528c01b635d11d3f2843ce3f7e1
6223c7e9a9e1f70916159c965acae8bf
09d16dc85267ec4081907adc966eae69
b6a5077267fdc61cdb192faffa27bed9
2883559bab2ab81cef6253452622b30c ........... BLS signature (Operator Key)
```

### qfcommit

The [`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit) is used to finalize a [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum) setup by aggregating the information necessary to mine the on-chain [QcTx](../reference/transactions-special-transactions.md#qctx) special transaction. The message contains all the necessary information required to validate the long-living masternode quorum's signing results.

It is possible to receive multiple valid final commitments for the same DKG session. These should only differ in the number of signers, which can be ignored as long as there are at least `quorumThreshold` number of signers. The set of valid members for these final commitments should always be the same, as each member only creates a single premature commitment. This means that only one set of valid members (and thus only one quorum verification vector and quorum [public key](../resources/glossary.md#public-key)) can gain a majority. If the threshold is not reached, there will be no valid final commitment.

:::{note}
* Version 2 (Dash Core 18.0) - updated the `qfcommit` message to support a [new method](https://github.com/dashpay/dips/blob/master/dip-0024.md) of quorum creation for some quorum types. Note the addition of the `quorumIndex` field in version 2 messages.
* Versions 3/4 (Dash Core 19.0) - `quorumPublicKey`, `quorumSig`, and `sig` serialized using the basic BLS scheme (versions <3 use the legacy BLS scheme).

See the *Version differences summary* table below for more information.
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 2 | version | uint16_t | Version of the final commitment message
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 | The quorum identifier
| 2 | quorumIndex | uint16_t | **Added in version 2**<br><br>The quorum index
| 1-9 | signersSize | compactSize uint | Bit size of the signers bitvector
| (bitSize + 7) / 8 | signers | byte[] | Bitset representing the aggregated signers of this final commitment
| 1-9 | validMembersSize | compactSize uint | Bit size of the `validMembers` bitvector
| (bitSize + 7) / 8 | validMembers | byte[] | Bitset of valid members in this commitment
| 48 | quorumPublicKey | BLSPubKey | The quorum public key<br>**Note**: serialization varies based on `version`:<br>\* Version <3 - legacy BLS scheme<br>\* Version >= 3 - basic BLS scheme
| 32 | quorumVvecHash | uint256 | The hash of the quorum verification vector
| 96 | quorumSig | byte[] | Recovered threshold signature<br>**Note**: serialization varies based on `version`:<br>\* Version <3 - legacy BLS scheme<br>\* Version >= 3 - basic BLS scheme
| 96 | sig | byte[] | Aggregated BLS signatures from all included commitments<br>**Note**: serialization varies based on `version`:<br>\* Version <3 - legacy BLS scheme<br>\* Version >= 3 - basic BLS scheme

**Version differences summary**

| Version | Version Description | `quorumIndex` field | Status |
| :-: | - | :-: | - |
| 1 | Non-rotated quorum `qfcommit` serialized using legacy BLS scheme | Absent | Deprecated by the v19 hard fork |
| 2 | [Rotated quorum](https://github.com/dashpay/dips/blob/master/dip-0024.md) `qfcommit` serialized using legacy BLS scheme     | Present | Deprecated by the v19 hard fork |
| 3 | Non-rotated quorum `qfcommit` serialized using basic BLS scheme  | Absent  | Used since the v19 hard fork |
| 4 | [Rotated quorum](https://github.com/dashpay/dips/blob/master/dip-0024.md) `qfcommit` serialized using basic BLS scheme      | Present | Used since the v19 hard fork |

More information can be found in the [Finalization phase section of DIP6](https://github.com/dashpay/dips/blob/master/dip-0006.md#6-finalization-phase).

The following annotated hexdump shows a *version 3* [`qfcommit` message](../reference/p2p-network-quorum-messages.md#qfcommit). (The message header has been omitted.)

``` text
0300 ....................................... Message Version: 3
01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

05beb3edd9207ede3a42a15bbd04d597
744f6f9db9b9a68a025c7e5637000000 ........... Quorum Hash

32 ......................................... Signer bitvector size: 50
ffffffffffff03 ............................. Signers

32 ......................................... Valid member bitvector size: 50
ffffffffffff03 ............................. Valid members

91e6dfd0d8f33e4306afe0483d7649cc
68b5346f5c658206269083d49d2f1db7
8eedd22eecf748404a1fe12e24f074e1 ........... Quorum BLS Public Key

bc7da59621015e70e31310982e66acfe
25468daede7142234e7f3bf3b3297b21 ........... Quorum Verification Vector Hash

99f4d8af79cf99ba49c8c9295cbc0827
b2b6611a905dc347eec9ecbe6ec6ec64
c167ca252f2fc0ff772394c696c58f0c
0e00c4f556ab528e07d06d2e57391fd1
0c57e0521e43f8dfcfc8448665d41eba
7c103b915506476672b531b9ceca266f ........... Quorum BLS Recovered Threshold Sig

8f7bb2a10d4cbf6fe7c6cfc1ec52817f
97f025ba9c4c52ac4cfa02ba1c28f3aa
fb83c2f4b246f730b5e4aac36e9479d5
0d72db9055dbdc9e2c27dee6f876be66
928abbdf636d1405c59a5e35d4775049
97f0e3b5acd2c53448deaaf61fed9343 ........... Quorum Aggregate BLS Sig
```

The following annotated hexdump shows the structure of a *version 4* [`qfcommit`
message](../reference/p2p-network-quorum-messages.md#qfcommit). (The message header has been
omitted.) Note that this is not an actual message from a real network so the BLS and signature data
cannot be verified.

``` text
0400 ....................................... Message Version: 4
65 ......................................... LLMQ Type: 101 (LLMQ_DEVNET)

d3b0d23936c7c2f1d3fff8a8b92212af
511defff89d255e85a4ef8cdfb010000 ........... Quorum Hash

0100 ....................................... Quorum Index (1)

08 ......................................... Signer bitvector size: 8
fb ......................................... Signers

08 ......................................... Valid member bitvector size: 8
fb ......................................... Valid members

165b0f73242d61f89b4eb7d36e25fb01
808d94c1a2e7c74cd7f6b3fc8e384642
0da3459f6c0e5a4fc021f4ce9125a10c ........... Quorum BLS Public Key

83846dbe1e0b71ce7011c321810fd7ba
00768b84bb4c0c6b2ad25dee02c34eed ........... Quorum Verification Vector Hash

14710c202aaae8d3a825afc19a7ea1f9
be2b567a0423d8cd8c72354e4daa02c4
65d2e591218a6608722eb40eba322e2a
0090860548d3b8613a644ed71a4795e3
37aae3251fe0e077ccaab7432c564e39
cc427677fd92189c0b41d6f306581577 ........... Quorum BLS Recovered Threshold Sig

9250b9a40b7e0f4773715540256ab99f
8854970a0fe3313997bac10cef0a5b9f
f33100bfba8f60342fd3a0cac17af370
11a7594d8391b6ca1e3b987c5ed1e9d0
7cb35789e1ab4c340902ae99bce94879
5ee9bc60d59b3aad2eea15dea15d8093 ........... Quorum Aggregate BLS Sig
```

## Signing Sessions

The following network messages enable the long living masternode quorum (LLMQ) message signing sessions described in [DIP7](https://github.com/dashpay/dips/blob/master/dip-0007.md).

With the exception of the [`qsendrecsigs` message](../reference/p2p-network-quorum-messages.md#qsendrecsigs) and the [`qsigrec` message](../reference/p2p-network-quorum-messages.md#qsigrec), these messages are for intra-quorum communication only and are not propagated on the Dash network.

### qbsigs

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs) is used to send batched signature shares in response to a [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs).

:::{note}
The number of messages that can be sent in a batch is limited to 400 (as defined by `MAX_MSGS_TOTAL_BATCHED_SIGS` in Dash Core).
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | batchCount | compactSize uint | Number of batched signature shares |
| Varies | msgs | CBatchedSigShares | Batches of signature shares |

CBatchedSigShares:

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | sessionId | varint | Signing session ID |
| Varies | shareCount | compactSize uint | Number of shares |
| shareCount * 98 | sigShares | <uint16_t, CBLSLazySignature> | Index (2 bytes) and BLS Signature share (96 bytes) |

The following annotated hexdump shows a [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs). (The message header has been omitted.)

``` text
02 ......................................... Number of signature share batches: 2

Signature Share Batch 1
| 84d843 ................................... Session ID
|
| 01 ....................................... Share count: 1
|
| Share
| | 2100 ................................... Index
|
| | 0fbd0c0981b79544c3e80d1a2eed13fe
| | f08c731b0156654675209812f9b2b8f3
| | ec23868d26890a0e85e5cec4ad0e2d46
| | 01293cf7e41841fda5865063e7354f36
| | e8a5c13d2c2d265a778f41e807b3cc63
| | 81e202ecf923c62bbb69ecc713bdf86d ....... BLS Signature share

Signature Share Batch 2
| 84d844 ................................... Session ID
|
| 01 ....................................... Share Count: 1
|
| Share
| | 2100 ................................... Index
| |
| | 9570d97e41b78045b51fba3d4f1ea38d
| | 7a0e007535ce6beb1e03eff163b421fd
| | b8125142a12f92aa82770de7bb038207
| | 13ccc72dd6d9bf91ecc2835da54a0afb
| | 0c0fa5d7a214a020ca650ca202ddff29
| | c3cac4033098297d2aaee098db5bfe2f ....... BLS Signature share
```

### qgetsigs

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs) is used to request signature shares. The response to a [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs) is a [`qbsigs` message](../reference/p2p-network-quorum-messages.md#qbsigs).

:::{note}
The number of inventories in a [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs) is limited to 200 (as defined by `MAX_MSGS_CNT_QGETSIGSHARES` in Dash Core).
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | count | compactSize uint | Number of signature shares requested |
| Varies | sessionId | varint | Signing session ID
| Varies | invSize | compactSize uint | Inventory size
| Varies | inv | CAutoBitSet | Quorum signature inventory |

The following annotated hexdump shows a [`qgetsigs` message](../reference/p2p-network-quorum-messages.md#qgetsigs). (The message header has been omitted.)

``` text
02 ......................................... Count: 2

Signature share request 1
| 80db21 ................................... Session ID
| 32 ....................................... Inventory size: 50
| 012900 ................................... Inventory

Signature share request 2
| 80db22 ................................... Session ID
| 32 ....................................... Inventory Size: 50
| 012900 ................................... Inventory
```

### qsendrecsigs

*Added in protocol version 70214 of Dash Core*

The [`qsendrecsigs` message](../reference/p2p-network-quorum-messages.md#qsendrecsigs) is used to notify a [peer](../resources/glossary.md#peer) to send plain [LLMQ](../resources/glossary.md#long-living-masternode-quorum) recovered signatures (inventory type `MSG_QUORUM_RECOVERED_SIG`). Otherwise the peer would only announce/send the higher level messages produced when a recovered signature is found (e.g. InstantSend [`isdlock` messages](../reference/p2p-network-instantsend-messages.md#isdlock) or ChainLock [`clsig` messages](../reference/p2p-network-instantsend-messages.md#clsig)).

:::{note}
SPV nodes should not send this message as they are usually only interested in the higher level messages.
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | fSendRecSigs | bool | 0 - Notify peer to not send plain LLMQ recovered signatures<br>1 - Notify peer to send plain LLMQ recovered signatures (default for Dash Core nodes)

The following annotated hexdump shows a [`qsendrecsigs` message](../reference/p2p-network-quorum-messages.md#qsendrecsigs). (The message header has been omitted.)

``` text
01 ................................. Request recovered signatures: Enabled (1)
```

### qsigrec

*Added in protocol version 70214 of Dash Core*

The [`qsigrec` message](../reference/p2p-network-quorum-messages.md#qsigrec) is used to provide recovered signatures and related quorum details to [nodes](../resources/glossary.md#node) that have requested this information via the [`qsendrecsigs` message](../reference/p2p-network-quorum-messages.md#qsendrecsigs).

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 | The quorum hash
| 32 | id | uint256 | The signing request id
| 32 | msgHash | uint256 | The message hash
| 96 | sig | byte[] | The final recovered BLS threshold signature<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

More information can be found in the [Recovered threshold signatures section of DIP7](https://github.com/dashpay/dips/blob/master/dip-0007.md#recovered-threshold-signatures).

The following annotated hexdump shows a [`qsigrec` message](../reference/p2p-network-quorum-messages.md#qsigrec). (The message header has been omitted.)

**Note:** The following [`qsigrec` message](../reference/p2p-network-quorum-messages.md#qsigrec) corresponds to the example [`islock` message](../reference/p2p-network-deprecated-messages.md#islock) hexdump. The message hash below corresponds to the `islock` TXID field and the BLS signature matches the BLS signature of the `islock` example.

``` text
01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

7d0befca14fa9e594aa19deab138ef28
23fe838c89ed9be6ddc63c0200000000 ........... Quorum Hash

0f1937c60f35640d063eae8eb288af21
a2ec0ec69b58b20c52f5d438eaabd54d ........... Signing Request ID

e2e1c797576d8b13c83e929684b9aacd
553c20a34e2d11e38bdcaaf8e1de1680 ........... Message Hash

0f055c2064885d446f83d51b9bb09892
7ea0375a0f6a3f3402abf158ece67e00
81049b8a8f45d254b64574cef194ef31
197e450fba1196d652f2e1421d3b80ae
f429c10eabd4ab9289e9a8f80f6989b7
a11e5e7930deccc3e11a931fc9524f06 ........... LLMQ BLS Signature (96 bytes)
```

### qsigsesann

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qsigsesann` message](../reference/p2p-network-quorum-messages.md#qsigsesann) is used to announce the sessionId for a signing session. The sessionId will be used for all P2P messages related to that session.

:::{note}
The maximum number of inventories in a [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv) is limited to 200 (as defined by `MAX_MSGS_CNT_QSIGSHARESINV` in Dash Core).
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | count | compactSize uint | Number of session announcements |
| Varies | sessionId | varint | Signing session ID (must be less than the maximum uint32_t value)
| 1 | llmqType | uint8_t | The LLMQ type
| 32 | quorumHash | uint256 | The quorum identifier
| 32 | id | uint256 | The signing request id
| 32 | msgHash | uint256 | The message hash

The following annotated hexdump shows a [`qsigsesann` message](../reference/p2p-network-quorum-messages.md#qsigsesann). (The message header has been omitted.)

``` text
02 ......................................... Count: 2

Session Announcement 1
| 84d843 ................................... Session ID
|
| 01 ....................................... LLMQ Type: 1 (LLMQ_50_60)
|
| a34d3ae6b33cb1199c3e5e1cb5a2a55c
| 91e69bb5df2bf80ba1cb0a0d00000000 ......... Quorum Hash
|
| 89bbc2e5741a9f706e8d33dee4132037
| 8c33511768c5e3d6cdb2a1b7b731360b ......... Signing request ID
|
| d2b41a19237e370b4b091545b203bc0c
| 02ca7e0d5daebf12bb24b13064ed4149 ......... Message Hash

Session Announcement 2
| 84d844 ................................... Session ID
|
| 01 ....................................... LLMQ Type: 1 (LLMQ_50_60)
|
| a34d3ae6b33cb1199c3e5e1cb5a2a55c
| 91e69bb5df2bf80ba1cb0a0d00000000 ......... Quorum Hash
|
| 54f73deb42a8ed9b72b9c0535a72f54d
| 5789bbe0dbea2e184c3089f9e8f65c3e ......... Signing request ID
|
| af2e5d730cd37cd911b92db117b4ab99
| 90a3c0300ce39177d0d31be5b47c2361 ......... Message Hash
```

### qsigshare

*Added in protocol version 70217 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qsigshare` message](../reference/p2p-network-quorum-messages.md#qsigshare) (quorum signature share) announces one or more quorum signature shares known by the transmitting peer.

:::{note}
The maximum number of inventories in a [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv) is limited to 200 (as defined by `MAX_MSGS_CNT_QSIGSHARESINV` in Dash Core).
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | count | compactSize uint | Number of sig share announcements |
| 1 | llmqType | uint8_t | The type of LLMQ
| 32 | quorumHash | uint256 | The quorum hash
| 32 | id | uint256 | The signing request id
| 32 | msgHash | uint256 | The message hash
| 96 | sigShare | byte[] | The final recovered BLS threshold signature<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

The following annotated hexdump shows a [`qsigshare` message](../reference/p2p-network-quorum-messages.md#qsigshare). (The message header has been omitted.)

``` text
01 ......................................... Count: 1

01 ......................................... LLMQ Type: 1 (LLMQ_50_60)

613bc036d2a2f8914a28dafd04c7d61e
238d1a10703769d166706d4178010000 ........... Quorum Hash

0300 ....................................... Quorum Member

ac520a15c20b7dd115103dd9ccabee71
32a8bc8e1f258250f5fabdd1a2a0ef0e ........... Message ID

69779b1c59a524738ed9bd6e66c3c5f9
cd4b9bd93ebb83069eaab77dff30ca48 ........... Message Hash

0671499594b4a811d29b009f647215f0
32ac7ad90a76589ab91d20ac876daac1
8e20ae1901be093ade77c8fbc54a7927
11f397d025d3690ff48bfb476ab23ad0
8b68a618a63bb0319cf286902307a5be
a277386b48a7ae627d075da826aab694 ......... Signature Share
```

### qsigsinv

*Added in protocol version 70214 of Dash Core*

:::{note}
This message is used for intra-quorum communication and is only sent to the [masternodes](../resources/glossary.md#masternode) in the LLMQ and [nodes](../resources/glossary.md#node) that are monitoring in Watch Mode for auditing/debugging purposes.
:::

The [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv) (quorum signature inventory) announces one or more quorum signature share inventories known by the transmitting peer.

Info callout

:::{note}
The maximum number of inventories in a [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv) is limited to 200 (as defined by `MAX_MSGS_CNT_QSIGSHARESINV` in Dash Core).
:::

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| Varies | count | compactSize uint | Number of session announcements |
| Varies | sessionId | varint | Signing session ID (must be less than the maximum uint32_t value) |
| Varies | invSize | compactSize uint | Inventory size
| Varies | inv | CAutoBitSet | Quorum signature inventory |

The following annotated hexdump shows a [`qsigsinv` message](../reference/p2p-network-quorum-messages.md#qsigsinv). (The message header has been omitted.)

``` text
02 ......................................... Count: 2

84d844 ..................................... Session ID
32 ......................................... Inventory size: 50
011a040200 ................................. Inventory

84d843 ..................................... Session ID
32 ......................................... Inventory size: 50
011a0700 ................................... Inventory
```

## Debugging

### qwatch

*Added in protocol version 70214 of Dash Core*

The [`qwatch` message](../reference/p2p-network-quorum-messages.md#qwatch) tells the receiving [peer](../resources/glossary.md#peer) to relay [LLMQ](../resources/glossary.md#long-living-masternode-quorum) [DKG messages](#distributed-key-generation) and [Signing session messages](#signing-sessions) (e.g., [`qcontrib`](../reference/p2p-network-quorum-messages.md#qcontrib)).

This message is sent when a Dash Core node is started with the [`-watchquorums` option](../dashcore/wallet-arguments-and-commands-dashd.md#debuggingtesting-options) enabled.

There is no payload in a [`qwatch` message](../reference/p2p-network-quorum-messages.md#qwatch).  See the [message header section](../reference/p2p-network-message-headers.md) for an example of a message without a payload.
