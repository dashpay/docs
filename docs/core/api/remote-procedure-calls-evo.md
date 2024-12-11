```{eval-rst}
.. meta::
  :title: Evo RPCs
  :description: A list of all the Evolution-related remote procedure calls in Dash Core.
```

# Evo RPCs

## BLS

*Added in Dash Core 0.13.0*

The [`bls` RPC](../api/remote-procedure-calls-evo.md#bls) provides a set of commands to execute BLS-related actions.

### BLS FromSecret

The `bls fromsecret` RPC parses a BLS secret key and returns the secret/public key pair.

*Parameter #1---secret key*

| Name     | Type         | Presence                | Description        |
| -------- | ------------ | ----------------------- | ------------------ |
| `secret` | string (hex) | Required<br>(exactly 1) | The BLS secret key |

*Parameter #2---legacy*

| Name     | Type    | Presence             | Description                                                                                            |
| -------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------------ |
| `legacy` | boolean | Optional<br>(0 or 1) | Use the legacy BLS scheme (default=`true` prior to v19 hard fork; default=`false` after v19 hard fork) |

*Result---the secret/public key pair*

| Name          | Type         | Presence                | Description                               |
| ------------- | ------------ | ----------------------- | ----------------------------------------- |
| `result`      | object       | Required<br>(exactly 1) | BLS key pair                              |
| →<br>`secret` | string (hex) | Required<br>(exactly 1) | A BLS secret key                          |
| →<br>`public` | string (hex) | Required<br>(exactly 1) | A BLS public key                          |
| →<br>`scheme` | string       | Required<br>(exactly 1) | BLS scheme (valid schemes: legacy, basic) |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet bls fromsecret 32c017a69fb03e0b8c1be270974570a350b043a685e9acbdc6493dbd9f8a7f1a
```

Result:

```json
{
  "secret": "32c017a69fb03e0b8c1be270974570a350b043a685e9acbdc6493dbd9f8a7f1a",
  "public": "90b75db03beab716159c3d80a448954a0ff2a10e25d260934c29839abe68abc546f53a0ec83e8201b22eb48e8e61eb4e",
  "scheme": "basic"
}
```

*See also*

* [BLS Generate](#bls-generate)

### BLS Generate

The `bls generate` RPC creates a new BLS secret/public key pair.

:::{note}
Since the v19 hard fork activation, BLS keys are generated using the basic scheme by default.
:::

*Parameter #1---legacy*

| Name     | Type    | Presence             | Description                                                                                            |
| -------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------------ |
| `legacy` | boolean | Optional<br>(0 or 1) | Use the legacy BLS scheme (default=`true` prior to v19 hard fork; default=`false` after v19 hard fork) |

*Result---a secret/public key pair*

| Name          | Type         | Presence                | Description                               |
| ------------- | ------------ | ----------------------- | ----------------------------------------- |
| `result`      | object       | Required<br>(exactly 1) | BLS key pair                              |
| →<br>`secret` | string (hex) | Required<br>(exactly 1) | A BLS secret key                          |
| →<br>`public` | string (hex) | Required<br>(exactly 1) | A BLS public key                          |
| →<br>`scheme` | string       | Required<br>(exactly 1) | BLS scheme (valid schemes: legacy, basic) |

*Example from Dash Core 19.0.0* (post hard fork activation)

```bash
dash-cli -testnet bls generate
```

Result:

```json
{
  "secret": "32c017a69fb03e0b8c1be270974570a350b043a685e9acbdc6493dbd9f8a7f1a",
  "public": "90b75db03beab716159c3d80a448954a0ff2a10e25d260934c29839abe68abc546f53a0ec83e8201b22eb48e8e61eb4e",
  "scheme": "basic"
}
```

*See also*

* [BLS FromSecret](#bls-fromsecret)

## ProTx

*Added in Dash Core 0.13.0*

The [`protx` RPC](../api/remote-procedure-calls-evo.md#protx) provides a set of commands to execute ProTx related actions.

### ProTx Diff

The `protx diff` RPC calculates a diff and a proof between two masternode list.

*Parameter #1---start block height*

| Name        | Type         | Presence                | Description               |
| ----------- | ------------ | ----------------------- | ------------------------- |
| `baseBlock` | number (int) | Required<br>(Exactly 1) | The starting block height |

*Parameter #2---end block height*

| Name    | Type         | Presence                | Description             |
| ------- | ------------ | ----------------------- | ----------------------- |
| `block` | number (int) | Required<br>(Exactly 1) | The ending block height |

*Parameter #3---extended fields*

| Name       | Type    | Presence             | Description                                                                                      |
| ---------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------ |
| `extended` | boolean | Optional<br>(0 or 1) | *Added in Dash Core 18.1.0*<br>Show additional fields (e.g. `payoutAddress`) (default=`false`) |

*Result---JSON provider registration transaction details*

| Name                           | Type         | Presence                | Description |
| ------------------------------ | ------------ | ----------------------- | ----------- |
| `result`                       | array        | Required<br>(exactly 1) | An array of objects each containing a provider transaction, or JSON `null` if an error occurred |
| →<br>`nVersion`                | number       | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>Simplified masternode list version returned |
| →<br>`baseBlockHash`           | string (hex) | Required<br>(exactly 1) | The hash of the base block as hex in RPC byte order |
| →<br>`blockHash`               | string (hex) | Required<br>(exactly 1) | The hash of the ending block as hex in RPC byte order |
| →<br>`cbTxMerkleTree`          | string (hex) | Required<br>(exactly 1) | The coinbase transaction merkle tree |
| →<br>`cbTx`                    | string (hex) | Required<br>(exactly 1) | The coinbase transaction |
| →<br>`deletedMNs`              | array        | Required<br>(exactly 1) | An array of deleted masternode hashes |
| →<br>`mnlist`                  | array        | Required<br>(exactly 1) | An array of masternode details |
| → →<br>`nVersion`              | number       | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>BLS version<br>`1` - Legacy BLS scheme<br>`2` - [Basic BLS scheme](https://github.com/dashpay/dash/issues/5001) |
| → →<br>`nType`                 | number       | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>Type of masternode<br> `0` - Regular masternode<br>`1` - Evolution masternode |
| → →<br>`proRegTxHash`          | string (hex) | Required<br>(exactly 1) | The hash of the initial provider registration transaction as hex in RPC byte order |
| → →<br>`confirmedHash`         | string (hex) | Required<br>(exactly 1) | The hash of the block where the ProRegTx was mined |
| → →<br>`service`               | string       | Required<br>(exactly 1) | The IP address/Port of the masternode |
| → →<br>`pubKeyOperator`        | string (hex) | Required<br>(exactly 1) | The operator public key |
| → →<br>`votingAddress`         | string       | Required<br>(exactly 1) | The voting address |
| → →<br>`isValid`               | bool         | Required<br>(exactly 1) | Set to `true` if masternode is valid |
| → →<br>`platformHTTPPort`      | number       | Optional<br>(0 or 1)    | **Added in Dash Core 19.0.0**<br>TCP port of Platform HTTP/API interface (evonodes only) |
| → →<br>`platformNodeID`        | string (hex) | Optional<br>(0 or 1)    | **Added in Dash Core 19.0.0**<br>Platform P2P node ID, derived from P2P public key (evonodes only) |
| → →<br>`payoutAddress`         | string       | Optional<br>(0 or 1)    | *Added in Dash Core 18.1.0*<br>The owner's payout address. Only included if the `extended` parameter is set to `true`. |
| → →<br>`operatorPayoutAddress` | string       | Required<br>(exactly 1) | *Added in Dash Core 18.1.0*<br>The operator's payout address.  Only included if the `extended` parameter is set to `true`. |
| →<br>`deletedQuorums`          | array        | Required<br>(exactly 1) | An array of deleted quorums |
| → →<br>`llmqType`              | number       | Required<br>(exactly 1) | The quorum type |
| → →<br>`quorumHash`            | string (hex) | Required<br>(exactly 1) | The hash of the quorum |
| →<br>`newQuorums`              | array        | Required<br>(exactly 1) | An array of new quorums |
| → →<br>`version`               | number       | Required<br>(exactly 1) | The quorum version |
| → →<br>`llmqType`              | number       | Required<br>(exactly 1) | The quorum type |
| → →<br>`quorumHash`            | string (hex) | Required<br>(exactly 1) | The hash of the quorum |
| → →<br> `quorumIndex`          | number       | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The index of the quorum |
| → →<br>`signersCount`          | number       | Required<br>(exactly 1) | The number of signers for the quorum |
| → →<br>`signers`               | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Bitset representing the aggregated signers of this final commitment |
| → →<br>`validMembersCount`     | number       | Required<br>(exactly 1) | The number of valid members in the quorum |
| → →<br>`validMembers`          | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Bitset of valid members in this commitment |
| → →<br>`quorumPublicKey`       | string (hex) | Required<br>(exactly 1) | The public key of the quorum |
| → →<br>`quorumVvecHash`        | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>The SHA256 hash of the quorum verification vector |
| → →<br>`quorumSig`             | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Recovered threshold signature |
| → →<br>`membersSig`            | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Aggregated BLS signatures from all included commitments |
| →<br>`merkleRootMNList`        | string (hex) | Required<br>(exactly 1) | Merkle root of the masternode list |
| →<br>`merkleRootQuorums`       | string (hex) | Optional<br>(0 or 1)    | *Added in Coinbase Transaction version 2 (Dash Core 0.14.0)*<br>Merkle root of the masternode list. |
| →<br>`quorumsCLSigs`           | array        | Optional<br>(0 or 1)    | **Added in Coinbase Transaction version 3 (Dash Core 20.0.0)**<br>An array of objects containing ChainLock signature details. Only present after v20 hard fork activation. |
| → →<br>ChainLock signature     | object       | Optional<br>(0 or more) | Key: ChainLock signature<br>Value: array of quorum indexes |
| → → →<br>Quorum index          | number       | Required<br>(1 or more) | Quorum index indicating a `newQuorums` entry that used this ChainLock signature for their member calculation |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx diff 100000 100500 true
```

Result (truncated):

```json
{
  "nVersion": 1,
  "baseBlockHash": "000000008650f09124958e7352f844f9c15705171ac38ee6668534c5c238b916",
  "blockHash": "000000000bcc2322bbfa41dbae3bc56f1468c4773c355a41671595e3cc9fbe71",
  "cbTxMerkleTree": "03000000039c07679a6b4ca6f2865a6f6c3a4f188f74a211be75146f32f134212da580468a097c57203dc8d46de9db73463ae7a68704d823dd05dd97075116e83914136b1bdf955363517189da760b89ac71957734c6389315b74e41a23ed35ae85b3784960107",
  "cbTx": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff4c03948801046c09df5c08fabe6d6d7804018887034cffffffff000000000000000000000000000000000000000000010000000000000057ffffd37c0100000d2f6e6f64655374726174756d2f000000000200240e43000000001976a914b7ce0ea9ce2010f58ba4aaa6caa76671c438e89088acf6230e43000000001976a9145889b4d255f6867504666d79e521be5cce30a4fd88ac00000000460200948801004cd4af41e87dedc9f93914689b6c8e90f20aa5ffb701dfcaabe716e682fd5fbd6aa200e13378d938ef435f1ce952594574ac956a6cd8ace46e6ba07a68161709",
  "deletedMNs": [
    "e7d524e0b6b55bdba9721cc71f4e472eafbcaaa138c35899af3edfcad93eb6e2"
  ],
  "mnList": [
    {
      "nVersion": 1,
      "nType": 0,
      "proRegTxHash": "488910d2554fbc8f803011dd107b993b185ed6eeb7efef6dedfd74ec6656f58b",
      "confirmedHash": "00000000031c08dad48934c9e2a0bf3dac307aa1b6106ed8aa4345b5423166cd",
      "service": "51.38.80.34:19999",
      "pubKeyOperator": "8b63fa3eb2ed4caba1fec3647bcec7a2886b5cde5b2cec6b5a60dc04193e959d21e96cbfa41388159450f244578de9a9",
      "votingAddress": "yXRzKxTbQUGWCqYwXnMWw5SnNCPj19NBGZ",
      "isValid": true,
      "payoutAddress": "yWPKEmx59zHRyyVFgC5xYXAZvGoaHCxTDE"
    },
    {
      "nVersion": 1,
      "nType": 0,
      "proRegTxHash": "9dadb2198c6c3f7d9aef77493ee2f8f0513198bada377078a99a1128ffa1b2b0",
      "confirmedHash": "00000000006fef47babe96126b70087c46defeb9527de07a52e417fe7fcd2fce",
      "service": "34.83.230.157:19999",
      "pubKeyOperator": "963984167b298d8d77b1be02e38e2493a75251cf9abecc7facee85512eabab7b05ffe053e8956d98ad4a3c20b77ade1e",
      "votingAddress": "yW5QUL6GqNswhSdMnWjcyAZ871VKrdY4jS",
      "isValid": true,
      "payoutAddress": "yMvjw8sFTBZy72sgGVHHwisF1ETmhr9ngq"
    }
  ],
  "deletedQuorums": [
    {
      "llmqType": 1,
      "quorumHash": "0000000004557649b0e4e3efddfab854ec08e26838cebc7eb42fff52d0602a06"
    },
    {
      "llmqType": 1,
      "quorumHash": "00000000156618545aecc80d2dbb0385cc200a63137ddad75278ba3069ad2615"
    }
  ],
  "newQuorums": [
    {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "0000000006393472bb9a01853bcf86f62c3744a329f1ef7812b45f9ec68cf802",
      "quorumIndex": 0,
      "signersCount": 49,
      "signers": "fffffffeffff03",
      "validMembersCount": 49,
      "validMembers": "fffffffeffff03",
      "quorumPublicKey": "8999f54dab1dd04cabdd70532b929ec69e4d252f3283eadce1defd4b6a9550a7b2bdb303261a1b39733ebc1c089dbb17",
      "quorumVvecHash": "65fe94b2ea695ca03428b32f03bc22cbee5c61fb85b170c6f6aca42562244283",
      "quorumSig": "0e925a8fcfd8722ff52a9feb9780ecfc1173a0715dfa17b6af9fd7a0abd2f13953e3111b2c92cbb7b892423a984dc8440ad5842d294b1e10b34361227922a3b24395495475cef16688e626074426003ceb48021560e22582010a0338947eec03",
      "membersSig": "80266b6ae1eea601fc50e46e00fb9d56596230fee64673e42bd61e17ccf65d45973ab6f9a96cee4e3b6db69ce9d9e81205b3e8ee81fab42699ce54ec78f70667fa0571c8cf78b6c2ec991956c2e0e6553bbfcb4a92e8e5529238185c1765682f"
    },
    {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "000000001cd753a7cdead3abaff75a6d6e009108e0b28c66b07042a940471706",
      "quorumIndex": 0,
      "signersCount": 50,
      "signers": "ffffffffffff03",
      "validMembersCount": 50,
      "validMembers": "ffffffffffff03",
      "quorumPublicKey": "8282dc910667713e033b75cf59b3d415ba0d8cfa38eda468bdf6da1f67a66f13eef9e2a5b5280dc215320a47d84dcd06",
      "quorumVvecHash": "5e1f653b26dba9bb59ed0e6cb7dd1335df11801189cdf282e53585c6eeff75ef",
      "quorumSig": "1234604b562c454896b369b54a3c5e0f98b55d4e67b35be171860cd100a35a70bfe3280c4d2f878cbd6ae0f8163fab0d19f63aab5f57fa645aa73fda9eb2ed77a24054ae0f8a46d2a93a2958cd8a96430fa7b63f3f891ef434ad55b7302ea611",
      "membersSig": "9545aa8277d340d234a76855972599f029d9f0d8b76ebed65178d7e584eb12541dd2c59877b592dd658cd765ac3b68fd1932cd5089108db0f32aa83e6b242a857d7a8c76db1a4f107dc8df0ecd6aab9443ed073dd0c91d19fdaff57c7ee3d65b"
    }
  ],
  "merkleRootMNList": "bd5ffd82e616e7abcadf01b7ffa50af2908e6c9b681439f9c9ed7de841afd44c",
  "merkleRootQuorums": "091716687aa06b6ee4acd86c6a95ac74455952e91c5f43ef38d97833e100a26a",
  "quorumsCLSigs": [
    {
      "82492bd4bcd9cd24b89011f11368e06d79942579cfa957fad51429553a45d9990cc10e8b475f59d5b29cedb7598edd300ccb43614f4c15055ea8b172d0dad174f6e8ea83814d7cd2dd528ec7a882e941e909763f70b1065bcdce384be559c31b": [
        6,
        30,
        86
      ]
    },
    {
      "aa3759de99561b451f24d95945674ae8e73ceb0dcd9ce303228599993080e20f0add1a99e24e241bc905e66eb6155c4e07adbbf2232f476495aabb48e6761af3e07f6660c2607e54dc2efaee38934f714aeff9199a818fd2dcc043edbb7d429b": [
        13,
        37,
        93
      ]
    }
  ]
}
```

*See also: none*

### ProTx Info

The `protx info` RPC returns detailed information about a deterministic masternode.

*Parameters*

| Name        | Type         | Presence                | Description               |
| ----------- | ------------ | ----------------------- | ------------------------- |
| `proTxHash` | string | Required<br>(Exactly 1) | The hash of the initial ProRegTx |
| `blockHash` | string | Optional<br>(0 or 1) | The hash of the block to get deterministic masternode state at. Defaults to chain tip if not provided. |

*Result--Details about a specific deterministic masternode*

| Name                                | Type         | Presence                | Description                                                                                |
| ----------------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------ |
| `result`                            | object       | Required<br>(exactly 1) | A JSON object containing a provider transaction, or JSON `null` if an error occurred            |
| <br>Provider Transaction            | object/null  | Required<br>(exactly 1) | An object containing a provider transaction                                                     |
| →<br>`type`                         | string       | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>The type of masternode                                         |
| →<br>`proTxHash`                    | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order                                   |
| →<br>`collateralHash`               | string (hex) | Required<br>(exactly 1) | The hash of the collateral transaction as hex in RPC byte order                                 |
| →<br>`collateralIndex`              | number (int) | Required<br>(exactly 1) | The collateral index                                                                            |
| →<br>`collateralAddress`          | string       | Required<br>(exactly 1) | The collateral address                                                                          |
| →<br>`operatorReward`               | number (float) | Required<br>(exactly 1) | The operator reward %. The value must be between `0.00` and `100.00`.                         |
| →<br>`state`                        | object/null  | Required<br>(exactly 1) | An object containing a provider transaction state                                               |
| → →<br>`version`                    | number (int) | Required<br>(exactly 1) | **Added in Dash Core 19.2.0**<br>The version of the most recent ProRegTx or ProUpRegTx          |
| → →<br>`service`                    | string       | Required<br>(exactly 1) | The masternode's IP:Port                                                                        |
| → →<br>`registeredHeight`           | number (int) | Required<br>(exactly 1) | The height where the masternode was registered                                                  |
| → →<br>`lastPaidHeight`             | number (int) | Required<br>(exactly 1) | The height where the masternode was last paid                                                   |
| → →<br>`consecutivePayments`        | number (int) | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>The number of consecutive payments the masternode has received in the payment cycle |
| → →<br>`PoSePenalty`                | number (int) | Required<br>(exactly 1) | The masternode's proof of service penalty                                                       |
| → →<br>`PoSeRevivedHeight`          | number (int) | Required<br>(exactly 1) | The height where the masternode recovered from a proof of service ban                           |
| → →<br>`PoSeBanHeight`              | number (int) | Required<br>(exactly 1) | The height where the masternode was banned for proof of service violations                      |
| → →<br>`revocationReason`           | number (int) | Required<br>(exactly 1) | The reason for a ProUpRegTx revocation                                                          |
| → →<br>`ownerAddress`               | string       | Required<br>(exactly 1) | The owner address                                                                               |
| → →<br>`votingAddress`              | string       | Required<br>(exactly 1) | The voting address                                                                              |
| → →<br>`payoutAddress`              | string       | Required<br>(exactly 1) | The owner's payout address                                                                      |
| → →<br>`pubKeyOperator`             | string (hex) | Required<br>(exactly 1) | The operator public key                                                                         |
| → →<br>`operatorPayoutAddress`      | string       | Required<br>(exactly 1) | The operator's payout address                                                                   |
| →<br>`confirmations`                | number (int) | Required<br>(exactly 1) | The number of confirmations this ProTx has                                                      |
| →<br>`wallet`                       | object/null  | Required<br>(exactly 1) | An object containing a wallet details related to this ProTx                                     |
| → →<br>`hasOwnerKey`                | bool         | Required<br>(exactly 1) | The owner key is present in this wallet                                                         |
| → →<br>`hasOperatorKey`             | bool         | Required<br>(exactly 1) | The operator key is present in this wallet                                                      |
| → →<br>`hasVotingKey`               | bool         | Required<br>(exactly 1) | The voting key is present in this wallet                                                        |
| → →<br>`ownsCollateral`             | bool         | Required<br>(exactly 1) | The collateral is owned by this wallet                                                          |
| → →<br>`ownsPayeeScript`            | bool         | Required<br>(exactly 1) | The payee script is owned by this wallet                                                        |
| → →<br>`ownsOperatorRewardScript`   | bool         | Required<br>(exactly 1) | The operator reward script is owned by this wallet                                              |
| →<br>`metaInfo`                     | object/null  | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>An object containing a metainfo related to this ProTx      |
| → →<br>`lastDSQ`                    | string       | Required<br>(exactly 1) | The owner key is present in this wallet                                                         |
| → →<br>`mixingTxCount`              | string       | Required<br>(exactly 1) | The operator key is present in this wallet                                                      |
| → →<br>`outboundAttemptCount`       | integer      | Required<br>(exactly 1) | **Added in Dash Core 19.2.0**<br>Number of outbound attempts                                                                     |
| → →<br>`lastOutboundAttempt`        | integer      | Required<br>(exactly 1) | Unix epoch time of the last outbound attempted                                                  |
| → →<br>`lastOutboundAttemptElapsed` | integer      | Required<br>(exactly 1) | Elapsed time since last outbound attempt                                                        |
| → →<br>`lastOutboundSuccess`        | integer      | Required<br>(exactly 1) | Unix epoch time of the last successful outbound connection                                      |
| → →<br>`lastOutboundSuccessElapsed` | integer      | Required<br>(exactly 1) | Elapsed time since last successful outbound attempt                                             |

*Example from Dash Core 20.1.0*

```bash
dash-cli -testnet protx info\
 b43dadbd485e4d1e1d202ea5180f0ad4e8e7f05e97a7e566a764ed714356bd1f
```

Result:

```json
{
  "type": "Regular",
  "proTxHash": "b43dadbd485e4d1e1d202ea5180f0ad4e8e7f05e97a7e566a764ed714356bd1f",
  "collateralHash": "acc1127471fb4417e2ca6420948143c82dfdd3595d5cb4336e19356df4e5715c",
  "collateralIndex": 1,
  "collateralAddress": "yMitd7GcJRUF8AeWhT7nWB9bDoruWM7tRb",
  "operatorReward": 0,
  "state": {
    "version": 1,
    "service": "47.111.181.207:20001",
    "registeredHeight": 247288,
    "lastPaidHeight": 0,
    "consecutivePayments": 0,
    "PoSePenalty": 369,
    "PoSeRevivedHeight": -1,
    "PoSeBanHeight": 247428,
    "revocationReason": 0,
    "ownerAddress": "yaMGQThTVPUf1LBqVqa1jMTtLW7ByVbN78",
    "votingAddress": "yQ8oETtF1pRQfBP4iake2e5zyCCm85CAET",
    "payoutAddress": "yZw2EYuVkTNUzUqd7mfXRNhCMReonL99tu",
    "pubKeyOperator": "90c0e9ec9dc5f08b1d4d0211920fe5d96a225c555a4ba7dd7f6cb14e271c925f2fc72316a01282973f9ad9cf1e39e038"
  },
  "confirmations": 602825,
  "wallet": {
    "hasOwnerKey": false,
    "hasOperatorKey": false,
    "hasVotingKey": false,
    "ownsCollateral": false,
    "ownsPayeeScript": false,
    "ownsOperatorRewardScript": false
  },
  "metaInfo": {
    "lastDSQ": 0,
    "mixingTxCount": 0,
    "outboundAttemptCount": 0,
    "lastOutboundAttempt": 0,
    "lastOutboundAttemptElapsed": 1686685781,
    "lastOutboundSuccess": 0,
    "lastOutboundSuccessElapsed": 1686685781
  }
}
```

### ProTx List

The `protx list` RPC returns a list of provider transactions.

Lists all ProTxs in your wallet or on-chain, depending on the given type. If `type` is not specified, it defaults to `registered`. All types have the optional argument `detailed` which if set to `true` will result in a detailed list being returned. If set to `false`, only the hashes of the ProTx will be returned.

*Parameter #1---type*

| Name   | Type   | Presence             | Description |
| ------ | ------ | -------------------- | ----------- |
| `type` | string | Optional<br>(0 or 1) | The type of ProTxs to list:<br>`registered` - all ProTxs registered at height<br>`valid` - all active/valid ProTxs at height<br>`evo` - List only ProTxs corresponding to evonodes at the given chain height<br>`wallet` - all ProTxs found in the current wallet<br><br>Height defaults to current chain-tip if one is not provided |

*Parameter #2---detailed*

| Name       | Type | Presence             | Description                                                                                                                  |
| ---------- | ---- | -------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `detailed` | bool | Optional<br>(0 or 1) | If set to `false` (default), only ProTx hashes are returned. If set to `true`, a detailed list of ProTx details is returned. |

*Parameter #3---height*

| Name     | Type         | Presence             | Description                                                |
| -------- | ------------ | -------------------- | ---------------------------------------------------------- |
| `height` | number (int) | Optional<br>(0 or 1) | List ProTxs from this height (default: current chain tip). |

*Result (if `detailed` was `false`)---provider registration transaction hash*

| Name     | Type                | Presence                | Description                                  |
| -------- | ------------------- | ----------------------- | -------------------------------------------- |
| `result` | string (hex): array | Required<br>(exactly 1) | Array of provider transaction (ProTx) hashes |

*Result (if `detailed` was `true`)---JSON provider registration transaction details*

| Name                                | Type         | Presence                | Description                                                                                     |
| ----------------------------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `result`                            | array        | Required<br>(exactly 1) | An array of objects each containing a provider transaction, or JSON `null` if an error occurred |
| <br>Provider Transaction            | object/null  | Required<br>(exactly 1) | An object containing a provider transaction                                                     |
| →<br>`type`                         | string       | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>The type of masternode                                         |
| →<br>`proTxHash`                    | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order                                   |
| →<br>`collateralHash`               | string (hex) | Required<br>(exactly 1) | The hash of the collateral transaction as hex in RPC byte order                                 |
| →<br>`collateralIndex`              | number (int) | Required<br>(exactly 1) | The collateral index                                                                            |
| → →<br>`collateralAddress`          | string       | Required<br>(exactly 1) | The collateral address                                                                          |
| →<br>`operatorReward`               | number (float) | Required<br>(exactly 1) | The operator reward %. The value must be between `0.00` and `100.00`.                         |
| →<br>`state`                        | object/null  | Required<br>(exactly 1) | An object containing a provider transaction state                                               |
| → →<br>`version`                    | number (int) | Required<br>(exactly 1) | **Added in Dash Core 19.2.0**<br>The version of the most recent ProRegTx or ProUpRegTx                                           |
| → →<br>`service`                    | string       | Required<br>(exactly 1) | The masternode's IP:Port                                                                        |
| → →<br>`registeredHeight`           | number (int) | Required<br>(exactly 1) | The height where the masternode was registered                                                  |
| → →<br>`lastPaidHeight`             | number (int) | Required<br>(exactly 1) | The height where the masternode was last paid                                                   |
| → →<br>`consecutivePayments`        | number (int) | Required<br>(exactly 1) | **Added in Dash Core 19.0.0**<br>The number of consecutive payments the masternode has received in the payment cycle |
| → →<br>`PoSePenalty`                | number (int) | Required<br>(exactly 1) | The masternode's proof of service penalty                                                       |
| → →<br>`PoSeRevivedHeight`          | number (int) | Required<br>(exactly 1) | The height where the masternode recovered from a proof of service ban                           |
| → →<br>`PoSeBanHeight`              | number (int) | Required<br>(exactly 1) | The height where the masternode was banned for proof of service violations                      |
| → →<br>`revocationReason`           | number (int) | Required<br>(exactly 1) | The reason for a ProUpRegTx revocation                                                          |
| → →<br>`ownerAddress`               | string       | Required<br>(exactly 1) | The owner address                                                                               |
| → →<br>`votingAddress`              | string       | Required<br>(exactly 1) | The voting address                                                                              |
| → →<br>`payoutAddress`              | string       | Required<br>(exactly 1) | The owner's payout address                                                                      |
| → →<br>`pubKeyOperator`             | string (hex) | Required<br>(exactly 1) | The operator public key                                                                         |
| → →<br>`operatorPayoutAddress`      | string       | Required<br>(exactly 1) | The operator's payout address                                                                   |
| →<br>`confirmations`                | number (int) | Required<br>(exactly 1) | The number of confirmations this ProTx has                                                      |
| →<br>`wallet`                       | object/null  | Required<br>(exactly 1) | An object containing a wallet details related to this ProTx                                     |
| → →<br>`hasOwnerKey`                | bool         | Required<br>(exactly 1) | The owner key is present in this wallet                                                         |
| → →<br>`hasOperatorKey`             | bool         | Required<br>(exactly 1) | The operator key is present in this wallet                                                      |
| → →<br>`hasVotingKey`               | bool         | Required<br>(exactly 1) | The voting key is present in this wallet                                                        |
| → →<br>`ownsCollateral`             | bool         | Required<br>(exactly 1) | The collateral is owned by this wallet                                                          |
| → →<br>`ownsPayeeScript`            | bool         | Required<br>(exactly 1) | The payee script is owned by this wallet                                                        |
| → →<br>`ownsOperatorRewardScript`   | bool         | Required<br>(exactly 1) | The operator reward script is owned by this wallet                                              |
| →<br>`metaInfo`                     | object/null  | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>An object containing a metainfo related to this ProTx      |
| → →<br>`lastDSQ`                    | string       | Required<br>(exactly 1) | The owner key is present in this wallet                                                         |
| → →<br>`mixingTxCount`              | string       | Required<br>(exactly 1) | The operator key is present in this wallet                                                      |
| → →<br>`outboundAttemptCount`       | integer      | Required<br>(exactly 1) | **Added in Dash Core 19.2.0**<br>Number of outbound attempts                                                                     |
| → →<br>`lastOutboundAttempt`        | integer      | Required<br>(exactly 1) | Unix epoch time of the last outbound attempted                                                  |
| → →<br>`lastOutboundAttemptElapsed` | integer      | Required<br>(exactly 1) | Elapsed time since last outbound attempt                                                        |
| → →<br>`lastOutboundSuccess`        | integer      | Required<br>(exactly 1) | Unix epoch time of the last successful outbound connection                                      |
| → →<br>`lastOutboundSuccessElapsed` | integer      | Required<br>(exactly 1) | Elapsed time since last successful outbound attempt                                             |

*Example from Dash Core 19.2.0*

```bash
dash-cli -testnet protx list
```

Result:

```json
[
  "2b4a07a9b04dc42a0c19b85edb60954a27acaadfe3ee21d0171385778f34e1c2",
  "61e6d780178d353940c4cb9b3073ac0c50792bbcf0b15c1750d2028b71e34929",
  "ca193751f3cbed2aa4f1b33b0acc48c7ed8b9a3679858d69cf23157a4f545176",
  "ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd"
]
```

List of ProTxs which are active/valid at the given chain height.

```bash
dash-cli -testnet protx list valid false 7090
```

Result:

```json
[
  "c48a44a9493eae641bea36992bc8c27eaaa33adb1884960f55cd259608d26d2f"
]
```

Detailed list of ProTxs which are active/valid at the given chain height.

```bash
dash-cli -testnet protx list valid true 7090
```

Result:

```json
[
  {
    "type": "Regular",
    "proTxHash": "c48a44a9493eae641bea36992bc8c27eaaa33adb1884960f55cd259608d26d2f",
    "collateralHash": "e3270ff48c4b802d56ee58d3d53777f7f9c289964e4df0842518075fc81345b1",
    "collateralIndex": 3,
    "operatorReward": 0,
    "state": {
      "version": 1,
      "service": "173.61.30.231:19013",
      "registeredHeight": 7090,
      "lastPaidHeight": 0,
      "consecutivePayments": 0,
      "PoSePenalty": 0,
      "PoSeRevivedHeight": -1,
      "PoSeBanHeight": -1,
      "revocationReason": 0,
      "ownerAddress": "yTMDce5yEpiPqmgPrPmTj7yAmQPJERUSVy",
      "votingAddress": "yTMDce5yEpiPqmgPrPmTj7yAmQPJERUSVy",
      "payoutAddress": "yU3UdrmS6KpWwBDLQTkp1KjXePwWsMbYdj",
      "pubKeyOperator": "8700add55a28ef22ec042a2f28e25fb4ef04b3024a7c56ad7eed4aebc736f312d18f355370dfb6a5fec9258f464b227e"
    },
    "confirmations": -1,
    "wallet": {
      "hasOwnerKey": false,
      "hasOperatorKey": false,
      "hasVotingKey": false,
      "ownsCollateral": false,
      "ownsPayeeScript": false,
      "ownsOperatorRewardScript": false
    },
    "metaInfo": {
      "lastDSQ": 0,
      "mixingTxCount": 0,
      "outboundAttemptCount": 0,
      "lastOutboundAttempt": 0,
      "lastOutboundAttemptElapsed": 1686684013,
      "lastOutboundSuccess": 0,
      "lastOutboundSuccessElapsed": 1686684013
    }
  }
]
```

### ProTx List Diff

The `protx listdiff` RPC calculates a full MN list diff between two masternode lists.

*Parameter #1---baseBlock*

| Name        | Type    | Presence             | Description              |
| ----------- | ------- | -------------------- | ------------------------ |
| `baseBlock` | numeric | Required (exactly 1) | The starting block height|

*Parameter #2---block*

| Name    | Type    | Presence             | Description            |
| ------- | ------- | -------------------- | -----------------------|
| `block` | numeric | Required (exactly 1) | The ending block height|

*Example from Dash Core*

```bash
dash-cli -testnet protx listdiff 7100 7135
```

Result:

```json
{
  "baseHeight": 7100,
  "blockHeight": 7135,
  "addedMNs": [
    {
      "type": "Regular",
      "proTxHash": "682b3e58e283081c51f2e8e7a7de5c7312a2e8074affaf389fafcc39c4805404",
      "collateralHash": "4955dcb8f9f56705b2ce480369c8a0e50b05c3dd1770160c4ddd47515a87e290",
      "collateralIndex": 1,
      "collateralAddress": "ySbK2DePJxPzkeHD2ccnMmsJjvBK5tJSPU",
      "operatorReward": 0,
      "state": {
        "version": 1,
        "service": "64.193.62.206:19999",
        "registeredHeight": 7134,
        "lastPaidHeight": 7135,
        "consecutivePayments": 0,
        "PoSePenalty": 0,
        "PoSeRevivedHeight": -1,
        "PoSeBanHeight": -1,
        "revocationReason": 0,
        "ownerAddress": "yid7uAsVJzvSLrEekHuGNuY3KWCqJopyJ8",
        "votingAddress": "yid7uAsVJzvSLrEekHuGNuY3KWCqJopyJ8",
        "payoutAddress": "yf7kAvZXd49hnWaScRbbLP9LMKDvz1f1tp",
        "pubKeyOperator": "05f2269374676476f00068b7cb168d124b7b780a92e8564e18edf45d77497abd9debf186ee98001a0c9a6dfccbab7a0a"
      }
    }
  ],
  "removedMNs": [
  ],
  "updatedMNs": [
    {
      "c48a44a9493eae641bea36992bc8c27eaaa33adb1884960f55cd259608d26d2f": {
        "lastPaidHeight": 7134
      }
    }
  ]
}
```

### ProTx Register

The `protx register` RPC creates a ProRegTx referencing an existing collateral and and sends it to the network.

*Parameter #1---collateral address*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key*

| Name             | Type         | Presence                | Description                                                                                                                                            |
| ---------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #6---voting address*

| Name            | Type   | Presence                | Description                                                                                                                                                                                                         |
| --------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                                                                              |
| ---------------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator. The value must be between `0.00` and `100.00`.<br>**Note**: If non-zero, `ipAndPort` must be zero as well. |

*Parameter #8---payout address*

| Name            | Type   | Presence                | Description                                             |
| --------------- | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Parameter #10---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

*Result if `submit` is not set or set to `true`---provider registration transaction hash*

| Name     | Type         | Presence                | Description                                       |
| -------- | ------------ | ----------------------- | ------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider registration transaction (ProRegTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx register\
 8b2eab3413abb6e04d17d1defe2b71039ba6b6f72ea1e5dab29bb10e7b745948 1\
 2.3.4.5:2345 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\
 88d719278eef605d9c19037366910b59bc28d437de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8c22f4a914a6c5566\
 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt
```

Result:

```text
61e6d780178d353940c4cb9b3073ac0c50792bbcf0b15c1750d2028b71e34929
```

*Result if `submit` set to `false`---serialized and signed provider registration transaction*

| Name     | Type         | Presence                | Description                                                        |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Serialized and signed provider registration transaction (ProRegTx) |

*Example from Dash Core 0.17.0*

```bash
dash-cli -testnet protx register\ 
b16e6f6ac71d16a8be46a78491bbdba20910287f59471a46514b88d7203bac6b 1 2.3.4.5:2345\ 
yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 
8ae227ffcbd4cbdc7ae2fe3e63264701ef6af1de71e6cade51867ecb7ed58b63862568522bab933987d0d043fa5590e1\ 
yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt\ 
yUYTxqjpCfAAK4vgxXtBPywRBtZqsxN7Vy false
```

Result:

```text
0300010001fe1caa50e5b8181be868fbd9fbd93affeb6c4a91a3c73373a6b25d548c7e6d41010000\
006b48304502210081d206a8332d5b8715ca831155ef5c7e339d33cde2b0b27310b95aafc8c560f9\
02204029d00d2b5515565321ec1fd6748fa0544b7356d9a389e4d1ce6ab4bb64d364012103c67d86\
944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9feffffff01a6f0433e0000\
00001976a9145a375814e9caf5b8575a8221be246457e5c5c28d88ac00000000fd12010100000000\
006bac3b20d7884b51461a47597f281009a2dbbb9184a746bea8161dc76a6f6eb101000000000000\
00000000000000ffff0203040509291636e84d02310b0b458f3eb51d8ea8b2e684b7ce8ae227ffcb\
d4cbdc7ae2fe3e63264701ef6af1de71e6cade51867ecb7ed58b63862568522bab933987d0d043fa\
5590e11636e84d02310b0b458f3eb51d8ea8b2e684b7cef4011976a914fc136008111fcc7a05be6c\
ec66f97568727a9e5188acb3ccf680086ae11217236efcccd67b0b72e83c79a043d6c6d064378fdd\
5f21204120fac89c76d3f116d95a675e112ddbdbb7a78f957506299fe592662acd44b46f262d1c4d\
47d9401e0a569a5488728e09542d0545ab56f8249a4b21e03445fa411e
```

### ProTx Register Legacy

:::{note}
Since the v19 hard fork activation, this command must be used if a legacy scheme BLS key is being used to register a masternode. In all other cases the [`protx register`RPC](#protx-register) should be used instead.

Legacy scheme BLS keys are created if the [`bls generate` RPC](#bls-generate) is run prior to v19 hard fork activation OR if a legacy key is explicitly generated using the [`bls generate legacy` RPC](#bls-generate).
:::

The `protx register_legacy` RPC works similar to `protx register`, but parses the operator key using the legacy BLS scheme. The collateral is specified through `collateralHash` and `collateralIndex` and must be an unspent transaction output spendable by this wallet. It must also not be used by any other masternode. This RPC requires a wallet passphrase to be set with walletpassphrase call if wallet is encrypted.

*Parameter #1---collateral hash*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                             |
| -------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. <br>The corresponding private key does not have to be known by this wallet. <br>The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key*

| Name                       | Type         | Presence                | Description                                                                                                                                                                |
| -------------------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator BLS public key. <br>The BLS private key does not have to be known. <br>It has to match the BLS private key which is later used when operating the masternode. |

*Parameter #6---voting address*

| Name                     | Type   | Presence                | Description                                                                                                                                                                                                                   |
| ------------------------ | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_register` | string | Required<br>(exactly 1) | The voting key address. <br>The private key does not have to be known by your wallet. <br>It has to match the private key which is later used when voting on proposals. If set to an empty string, ownerAddress will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                      |
| ---------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------ |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator. <br>The value must be between `0.00` and `100.00`. |

*Parameter #8---payout address*

| Name                     | Type   | Presence                | Description                                             |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                                       |
| ------------------ | ------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx.<br> If not specified, `payoutAddress` will be used. <br>The private key belonging to this address must be known in your wallet. |

*Parameter #10---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

*Result if `submit` is not set or set to `true`---provider registration transaction hash*

| Name     | Type         | Presence                | Description                                       |
| -------- | ------------ | ----------------------- | ------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider registration transaction (ProRegTx) hash |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx register_legacy\
 8b2eab3413abb6e04d17d1defe2b71039ba6b6f72ea1e5dab29bb10e7b745948 1\ 0
 2.3.4.5:2345 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 88d719278eef605d9c19037366910b59bc28d437de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8c22f4a914a6c5566\
 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt
```

Result:

```text
61e6d780178d353940c4cb9b3073ac0c50792bbcf0b15c1750d2028b71e34929
```

*Result if `submit` set to `false`---serialized and signed provider registration transaction*

| Name     | Type         | Presence                | Description                                                        |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Serialized and signed provider registration transaction (ProRegTx) |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx register_legacy\
 8b2eab3413abb6e04d17d1defe2b71039ba6b6f72ea1e5dab29bb10e7b745948 1\ 0
 2.3.4.5:2345 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 88d719278eef605d9c19037366910b59bc28d437de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8c22f4a914a6c5566\
 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt false
```

Result:

```text
0300010001fe1caa50e5b8181be868fbd9fbd93affeb6c4a91a3c73373a6b25d548c7e6d41010000\
006b48304502210081d206a8332d5b8715ca831155ef5c7e339d33cde2b0b27310b95aafc8c560f9\
02204029d00d2b5515565321ec1fd6748fa0544b7356d9a389e4d1ce6ab4bb64d364012103c67d86\
944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9feffffff01a6f0433e0000\
00001976a9145a375814e9caf5b8575a8221be246457e5c5c28d88ac00000000fd12010100000000\
006bac3b20d7884b51461a47597f281009a2dbbb9184a746bea8161dc76a6f6eb101000000000000\
00000000000000ffff0203040509291636e84d02310b0b458f3eb51d8ea8b2e684b7ce8ae227ffcb\
d4cbdc7ae2fe3e63264701ef6af1de71e6cade51867ecb7ed58b63862568522bab933987d0d043fa\
5590e11636e84d02310b0b458f3eb51d8ea8b2e684b7cef4011976a914fc136008111fcc7a05be6c\
ec66f97568727a9e5188acb3ccf680086ae11217236efcccd67b0b72e83c79a043d6c6d064378fdd\
5f21204120fac89c76d3f116d95a675e112ddbdbb7a78f957506299fe592662acd44b46f262d1c4d\
47d9401e0a569a5488728e09542d0545ab56f8249a4b21e03445fa411e
```

### ProTx Register Fund

The `protx register_fund` RPC creates and funds a ProRegTx with the 1,000 DASH necessary for a masternode and then sends it to the network.

*Parameter #1---collateral address*

| Name                | Type   | Presence                | Description                                |
| ------------------- | ------ | ----------------------- | ------------------------------------------ |
| `collateralAddress` | string | Required<br>(exactly 1) | The Dash address to send the collateral to |

*Parameter #2---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #3---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #4---operator public key*

| Name             | Type         | Presence                | Description                                                                                                                                            |
| ---------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #5---voting address*

| Name            | Type   | Presence                | Description                                                                                                                                                                                                         |
| --------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #6---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #7---payout address*

| Name            | Type   | Presence                | Description                                             |
| --------------- | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #8---fund address*

| Name          | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fundAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Parameter #9---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

*Result if `submit` is not set or set to `true`---provider registration transaction hash*

| Name     | Type         | Presence                | Description                                       |
| -------- | ------------ | ----------------------- | ------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider registration transaction (ProRegTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx register_fund yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\
 3.4.5.6:3456 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw\
 0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\
 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw 5 yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7
```

Result:

```text
ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd
```

*Result if `submit` set to `false`---serialized and signed provider registration transaction*

| Name     | Type         | Presence                | Description                                                        |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Serialized and signed provider registration transaction (ProRegTx) |

*Example from Dash Core 0.17.0*

```bash
dash-cli -testnet protx register_fund yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 
3.4.5.6:3456 yURczr3qY31xkQZfFu8eZvKz19eAEPQxsd\ 
0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\
yURczr3qY31xkQZfFu8eZvKz19eAEPQxsd 5 yUYTxqjpCfAAK4vgxXtBPywRBtZqsxN7Vy\ 
yRMFHxcJ2aS2vfo5whhE2Gg73dfQVm8LAF 0
```

Result:

```text
030001000156701575e76bca5720fa364ea6efc4b713279710dd1b8906797d18bd7048b71a010000\
006b4830450221009178a387b3d82e3606e6484373508ef1ed4c1d7d98f8a0ca0851687c59edacaa\
02204d245d20689b5be1100536faaadbb1781e3a67a55e9ecc613adb2a34f419c3cd012103109325\
a92f9e6d31d2ebd0595d471275ae8d635db2a0c42358f387e1af69c14dfeffffff0200e876481700\
00001976a9141636e84d02310b0b458f3eb51d8ea8b2e684b7ce88ac8c7a918b300000001976a914\
372fd07f715c33ce88873a8e758d890e017cf02588ac00000000d101000000000000000000000000\
000000000000000000000000000000000000000000000000000000000000000000000000000000ff\
ff030405060d8058ebf95961c207ebd525793ccb43f60ce34a5cd50e02146e9c34cfbcb3f3037574\
a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d5158ebf95961\
c207ebd525793ccb43f60ce34a5cd5f4011976a9145a375814e9caf5b8575a8221be246457e5c5c2\
8d88ac45084a0f63d6f06767c941ffd5af4ed17ea0e28afa481e46b2bdbadbd8446c8c00\
```

### ProTx Register Fund Legacy

:::{note}
Since the v19 hard fork activation, this command must be used if a legacy scheme BLS key is being used to register a masternode. In all other cases the [`protx register_fund` RPC](#protx-register-fund) should be used instead.

Legacy scheme BLS keys are created if the [`bls generate` RPC](#bls-generate) is run prior to v19 hard fork activation OR if a legacy key is explicitly generated using the [`bls generate legacy` RPC](#bls-generate).
:::

The `protx register_fund_legacy` RPC creates, funds, and sends a ProTx to the network. The resulting transaction will move 1000 DASH to the address specified by `collateralAddress` and will then function as the collateral of your masternode. A few of the limitations you see in the arguments are temporary and might be lifted after DIP3 is fully deployed.

*Parameter #1---collateral address*

| Name                | Type   | Presence                | Description                                |
| ------------------- | ------ | ----------------------- | ------------------------------------------ |
| `collateralAddress` | string | Required<br>(exactly 1) | The Dash address to send the collateral to |

*Parameter #2---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #3---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #4---operator public key*

| Name                      | Type         | Presence                | Description                                                                                                                                                                |
| ------------------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator BLS public key. <br>The BLS private key does not have to be known. <br>It has to match the BLS private key which is later used when operating the masternode. |

*Parameter #5---voting address*

| Name            | Type   | Presence                | Description                                                                                                                                                                                                         |
| --------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #6---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #7---payout address*

| Name                     | Type   | Presence                | Description                                             |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #8---fund address*

| Name          | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fundAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Parameter #9---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

\*Result if `submit` is not set or set to `true`

| Name     | Type         | Presence                | Description        |
| -------- | ------------ | ----------------------- | ------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | The transaction id |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx register_fund_legacy yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\
 3.4.5.6:3456 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw\
 0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\
 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw 5 yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7
```

Result:

```text
ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd
```

*Result if `submit` set to `false`---serialized and signed provider registration transaction*

| Name     | Type         | Presence                | Description                               |
| -------- | ------------ | ----------------------- | ----------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | The serialized signed ProTx in hex format |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx register_fund_legacy yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 
3.4.5.6:3456 yURczr3qY31xkQZfFu8eZvKz19eAEPQxsd\ 
0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\ 
yURczr3qY31xkQZfFu8eZvKz19eAEPQxsd 5 yUYTxqjpCfAAK4vgxXtBPywRBtZqsxN7Vy\ 
yRMFHxcJ2aS2vfo5whhE2Gg73dfQVm8LAF 0
```

Result:

```text
030001000156701575e76bca5720fa364ea6efc4b713279710dd1b8906797d18bd7048b71a010000\
006b4830450221009178a387b3d82e3606e6484373508ef1ed4c1d7d98f8a0ca0851687c59edacaa\
02204d245d20689b5be1100536faaadbb1781e3a67a55e9ecc613adb2a34f419c3cd012103109325\
a92f9e6d31d2ebd0595d471275ae8d635db2a0c42358f387e1af69c14dfeffffff0200e876481700\
00001976a9141636e84d02310b0b458f3eb51d8ea8b2e684b7ce88ac8c7a918b300000001976a914\
372fd07f715c33ce88873a8e758d890e017cf02588ac00000000d101000000000000000000000000\
000000000000000000000000000000000000000000000000000000000000000000000000000000ff\
ff030405060d8058ebf95961c207ebd525793ccb43f60ce34a5cd50e02146e9c34cfbcb3f3037574\
a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d5158ebf95961\
c207ebd525793ccb43f60ce34a5cd5f4011976a9145a375814e9caf5b8575a8221be246457e5c5c2\
8d88ac45084a0f63d6f06767c941ffd5af4ed17ea0e28afa481e46b2bdbadbd8446c8c00\
```

### ProTx Register Prepare

The `protx register_prepare` RPC creates an unsigned ProTx and a message that must be signed externally with the private key that corresponds to `collateralAddress` to prove collateral ownership. The prepared transaction will also contain inputs and outputs to cover fees. The ProTx must be passed to [`protx register_submit`](#protx-register-submit).

*Parameter #1---collateral address*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form 'IP:PORT'.<br>Must be unique on the network.<br>Can be set to '0', which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key*

| Name             | Type         | Presence                | Description                                                                                                                                            |
| ---------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #6---voting address*

| Name            | Type   | Presence                | Description                                                                                                                                                                                                         |
| --------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #8---payout address*

| Name            | Type   | Presence                | Description                                             |
| --------------- | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---unsigned transaction and message to sign*

| Name                     | Type            | Presence                | Description                                                                                                                          |
| ------------------------ | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `result`                 | object          | Required<br>(exactly 1) | JSON object containing an unsigned provider transaction and the message to be signed externally, or JSON `null` if an error occurred |
| →<br>`tx`                | string (hex)    | Required<br>(exactly 1) | The serialized unsigned ProRegTx in hex format                                                                                       |
| →<br>`collateralAddress` | string          | Required<br>(exactly 1) | The collateral address                                                                                                               |
| →<br>`signMessage`       | string (base64) | Required<br>(exactly 1) | The string message that needs to be signed with the collateral key.                                                                  |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx register_prepare\
 df41e398bb245e973340d434d386f431dbd69735a575721b0b6833856e7d31ec 1 \
 9.8.7.6:9876 yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz\
 06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280c\
 yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz 1.2 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt
```

Result:

```json
{
  "tx": "0300010001912b88876fee2f8e43e23b5e81276c163cf23d867bad4148170cb106ef9023700000000000feffffff0125623ba40b0000001976a914736e155c1039a269d4019c66219d2a18f0fee27588ac00000000d1010000000000ec317d6e8533680b1b7275a53597d6db31f486d334d44033975e24bb98e341df0100000000000000000000000000ffff090807062694ca6b243168b30461d1f19e2bb89a965a5bac067e06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280cca6b243168b30461d1f19e2bb89a965a5bac067e78001976a914fc136008111fcc7a05be6cec66f97568727a9e5188ace5f6b70ac55411727e25178bd417b9b03f837ad7155d90ad286f3a427203fb9f00",
  "collateralAddress": "yWuKWhDzGQqZL8rw6kGxGrfe6P8bUC2S4f",
  "signMessage": "yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt|120|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|69a49e18c1253b90d39322f7e2f7af74524401bc33a27645e697e74a214e3e1e"
}
```

### ProTx Register Prepare Legacy

:::{note}
Since the v19 hard fork activation, this command must be used if a legacy scheme BLS key is being used to register a masternode. In all other cases the [`protx register_prepare` RPC](#protx-register-prepare) should be used instead.

Legacy scheme BLS keys are created if the [`bls generate` RPC](#bls-generate) is run prior to v19 hard fork activation OR if a legacy key is explicitly generated using the [`bls generate legacy` RPC](#bls-generate).
:::

The `protx register_prepare_legacy` RPC Creates an unsigned ProTx and a message that must be signed externally with the private key that corresponds to collateralAddress to prove collateral ownership. The prepared transaction will also contain inputs and outputs to cover fees.

*Parameter #1---collateral address*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form 'IP:PORT'.<br>Must be unique on the network.<br>Can be set to '0', which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key*

| Name                      | Type         | Presence                | Description                                                                                                                                            |
| ------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #6---voting address*

| Name                     | Type   | Presence                | Description                                                                                                                                                                                                         |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_register` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #8---payout address*

| Name                      | Type   | Presence                | Description                                             |
| ------------------------- | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---unsigned transaction and message to sign*

| Name                     | Type            | Presence                | Description                                                                                                                          |
| ------------------------ | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `result`                 | object          | Required<br>(exactly 1) | JSON object containing an unsigned provider transaction and the message to be signed externally, or JSON `null` if an error occurred |
| →<br>`tx`                | string (hex)    | Required<br>(exactly 1) | The serialized unsigned ProRegTx in hex format                                                                                       |
| →<br>`collateralAddress` | string          | Required<br>(exactly 1) | The collateral address                                                                                                               |
| →<br>`signMessage`       | string (base64) | Required<br>(exactly 1) | The string message that needs to be signed with the collateral key.                                                                  |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx register_prepare_legacy\ 
df41e398bb245e973340d434d386f431dbd69735a575721b0b6833856e7d31ec 1  0 9.8.7.6:9876\ 
yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz\ 
06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280c\ 
yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz 1.2 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt
```

Result:

```json
{
  "tx": "0300010001912b88876fee2f8e43e23b5e81276c163cf23d867bad4148170cb106ef9023700000000000feffffff0125623ba40b0000001976a914736e155c1039a269d4019c66219d2a18f0fee27588ac00000000d1010000000000ec317d6e8533680b1b7275a53597d6db31f486d334d44033975e24bb98e341df0100000000000000000000000000ffff090807062694ca6b243168b30461d1f19e2bb89a965a5bac067e06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280cca6b243168b30461d1f19e2bb89a965a5bac067e78001976a914fc136008111fcc7a05be6cec66f97568727a9e5188ace5f6b70ac55411727e25178bd417b9b03f837ad7155d90ad286f3a427203fb9f00",
  "collateralAddress": "yWuKWhDzGQqZL8rw6kGxGrfe6P8bUC2S4f",
  "signMessage": "yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt|120|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|69a49e18c1253b90d39322f7e2f7af74524401bc33a27645e697e74a214e3e1e"
}
```

### ProTx Register Evo

The `protx register_evo` RPC functions similar to `protx register_fund_evo`, but with an externally referenced collateral. The collateral is specified through `collateralHash` and `collateralIndex` and must be an unspent transaction output spendable by this wallet. It must also not be used by any other masternode. Requires the wallet passphrase to be provide with the [`walletpassphrase` RPC](../api/remote-procedure-calls-wallet.md#walletpassphrase) if the wallet is encrypted.

*Parameter #1---collateral address*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key*

| Name                      | Type         | Presence                | Description                                                                                                                                            |
| ------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #6---voting address*

| Name                     | Type   | Presence                | Description                                                                                                                                                                                                         |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_register` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                                                                              |
| ---------------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator. The value must be between `0.00` and `100.00`.<br>**Note**: If non-zero, `ipAndPort` must be zero as well. |

*Parameter #8---payout address*

| Name                     | Type   | Presence                | Description                                             |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---platform node ID*

| Name             | Type   | Presence                | Description                                        |
| ---------------- | ------ | ----------------------- | -------------------------------------------------- |
| `platformNodeID` | string | Required<br>(exactly 1) | Platform P2P node ID, derived from P2P public key. |

*Parameter #10---platform p2p port*

| Name              | Type   | Presence                | Description                                                   |
| ----------------- | ------ | ----------------------- | ------------------------------------------------------------- |
| `platformP2PPort` | number | Required<br>(exactly 1) | TCP port of Platform HTTP/API interface (network byte order). |

*Parameter #11---platform p2p port*

| Name              | Type   | Presence                | Description                                                                              |
| ----------------- | ------ | ----------------------- | ---------------------------------------------------------------------------------------- |
| `platformP2PPort` | number | Required<br>(exactly 1) | TCP port of Dash Platform peer-to-peer communication between nodes (network byte order). |

*Parameter #12---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Parameter #13---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

*Result if `submit` is not set or set to `true`---provider registration transaction hash*

| Name     | Type         | Presence                | Description                                       |
| -------- | ------------ | ----------------------- | ------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider registration transaction (ProRegTx) hash |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx register_evo
 8b2eab3413abb6e04d17d1defe2b71039ba6b6f72ea1e5dab29bb10e7b745948\ 
1 2.3.4.5:2345\ 
yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\ 
88d719278eef605d9c19037366910b59bc28d437de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8c22f4a914a6c5566\ 
yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5\ 
yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt\ 
f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821 22822
```

Result:

```text
61e6d780178d353940c4cb9b3073ac0c50792bbcf0b15c1750d2028b71e34929
```

*Result if `submit` set to `false`---serialized and signed provider registration transaction*

| Name     | Type         | Presence                | Description                                                        |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Serialized and signed provider registration transaction (ProRegTx) |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx register_evo\
 8b2eab3413abb6e04d17d1defe2b71039ba6b6f72ea1e5dab29bb10e7b745948 1\
 2.3.4.5:2345 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6\
 88d719278eef605d9c19037366910b59bc28d437de4a8db4d76fda6d6985dbdf10404fb9bb5cd0e8c22f4a914a6c5566\
 yNLuVTXJbjbxgrQX5LSMi7hV19We8hT2d6 5 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt\ f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821 22822 false
```

Result:

```text
0300010001fe1caa50e5b8181be868fbd9fbd93affeb6c4a91a3c73373a6b25d548c7e6d41010000\
006b48304502210081d206a8332d5b8715ca831155ef5c7e339d33cde2b0b27310b95aafc8c560f9\
02204029d00d2b5515565321ec1fd6748fa0544b7356d9a389e4d1ce6ab4bb64d364012103c67d86\
944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9feffffff01a6f0433e0000\
00001976a9145a375814e9caf5b8575a8221be246457e5c5c28d88ac00000000fd12010100000000\
006bac3b20d7884b51461a47597f281009a2dbbb9184a746bea8161dc76a6f6eb101000000000000\
00000000000000ffff0203040509291636e84d02310b0b458f3eb51d8ea8b2e684b7ce8ae227ffcb\
d4cbdc7ae2fe3e63264701ef6af1de71e6cade51867ecb7ed58b63862568522bab933987d0d043fa\
5590e11636e84d02310b0b458f3eb51d8ea8b2e684b7cef4011976a914fc136008111fcc7a05be6c\
ec66f97568727a9e5188acb3ccf680086ae11217236efcccd67b0b72e83c79a043d6c6d064378fdd\
5f21204120fac89c76d3f116d95a675e112ddbdbb7a78f957506299fe592662acd44b46f262d1c4d\
47d9401e0a569a5488728e09542d0545ab56f8249a4b21e03445fa411e
```

### ProTx Register Fund Evo

The `protx register_fund_evo` RPC creates, funds, and sends a ProTx to the network. The resulting transaction will move 4000 Dash to the address specified by `collateralAddress` and will then function as the collateral of your evonode. A few of the limitations you see in the arguments are temporary and might be lifted after DIP3 is fully deployed. Requires the wallet passphrase to be provide with the [`walletpassphrase` RPC](../api/remote-procedure-calls-wallet.md#walletpassphrase) if the wallet is encrypted.

*Parameter #1---collateral address*

| Name                | Type   | Presence                | Description                                |
| ------------------- | ------ | ----------------------- | ------------------------------------------ |
| `collateralAddress` | string | Required<br>(exactly 1) | The Dash address to send the collateral to |

*Parameter #2---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form `IP:PORT`.<br>Must be unique on the network.<br>Can be set to `0`, which will require a ProUpServTx afterwards. |

*Parameter #3---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #4---operator public key register*

| Name                       | Type         | Presence                | Description                                                                                                                                            |
| -------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #5---voting address register*

| Name                     | Type   | Presence                | Description                                                                                                                                                                                                         |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_register` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #6---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #7---payout address register*

| Name                     | Type   | Presence                | Description                                             |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #8---platform node ID*

| Name             | Type   | Presence                | Description                                        |
| ---------------- | ------ | ----------------------- | -------------------------------------------------- |
| `platformNodeID` | string | Required<br>(exactly 1) | Platform P2P node ID, derived from P2P public key. |

*Parameter #9---platform p2p port*

| Name              | Type   | Presence                | Description                                                                              |
| ----------------- | ------ | ----------------------- | ---------------------------------------------------------------------------------------- |
| `platformP2PPort` | number | Required<br>(exactly 1) | TCP port of Dash Platform peer-to-peer communication between nodes (network byte order). |

*Parameter #10---platform http port*

| Name               | Type   | Presence                | Description                                                   |
| ------------------ | ------ | ----------------------- | ------------------------------------------------------------- |
| `platformHTTPPort` | number | Required<br>(exactly 1) | TCP port of Platform HTTP/API interface (network byte order). |

*Parameter #11---fund address*

| Name          | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fundAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Parameter #12---whether to submit to the network or not*

| Name     | Type | Presence             | Description                                                            |
| -------- | ---- | -------------------- | ---------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | If `true` (default), the resulting transaction is sent to the network. |

\*Result if `submit` is not set or set to `true`

| Name     | Type         | Presence                | Description        |
| -------- | ------------ | ----------------------- | ------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | The transaction ID |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx register_fund_evo yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\
 3.4.5.6:3456 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw\ 
 0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\
 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw 5 yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\
 f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821 22822
```

Result:

```text
ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd
```

\*Result if `submit` set to `false`

| Name     | Type         | Presence                | Description                               |
| -------- | ------------ | ----------------------- | ----------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | The serialized signed ProTx in hex format |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx register_fund_evo yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\
 3.4.5.6:3456 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw\
 0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51\
 yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw 5 yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7\ f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821 22822 0
```

Result:

```text
030001000156701575e76bca5720fa364ea6efc4b713279710dd1b8906797d18bd7048b71a010000\
006b4830450221009178a387b3d82e3606e6484373508ef1ed4c1d7d98f8a0ca0851687c59edacaa\
02204d245d20689b5be1100536faaadbb1781e3a67a55e9ecc613adb2a34f419c3cd012103109325\
a92f9e6d31d2ebd0595d471275ae8d635db2a0c42358f387e1af69c14dfeffffff0200e876481700\
00001976a9141636e84d02310b0b458f3eb51d8ea8b2e684b7ce88ac8c7a918b300000001976a914\
372fd07f715c33ce88873a8e758d890e017cf02588ac00000000d101000000000000000000000000\
000000000000000000000000000000000000000000000000000000000000000000000000000000ff\
ff030405060d8058ebf95961c207ebd525793ccb43f60ce34a5cd50e02146e9c34cfbcb3f3037574\
a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d5158ebf95961\
c207ebd525793ccb43f60ce34a5cd5f4011976a9145a375814e9caf5b8575a8221be246457e5c5c2\
8d88ac45084a0f63d6f06767c941ffd5af4ed17ea0e28afa481e46b2bdbadbd8446c8c00\
```

### ProTx Register Prepare Evo

The `protx register_prepare_evo` RPC creates an unsigned ProTx and a message that must be signed externally with the private key that corresponds to `collateralAddress` to prove collateral ownership. The prepared transaction will also contain inputs and outputs to cover fees.

*Parameter #1---collateral address*

| Name             | Type         | Presence                | Description                     |
| ---------------- | ------------ | ----------------------- | ------------------------------- |
| `collateralHash` | string (hex) | Required<br>(exactly 1) | The collateral transaction hash |

*Parameter #2---collateral index*

| Name              | Type         | Presence                | Description                             |
| ----------------- | ------------ | ----------------------- | --------------------------------------- |
| `collateralIndex` | string (hex) | Required<br>(exactly 1) | The collateral transaction output index |

*Parameter #3---IP Address and port*

| Name        | Type   | Presence                | Description                                                                                                                             |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form 'IP:PORT'.<br>Must be unique on the network.<br>Can be set to '0', which will require a ProUpServTx afterwards. |

*Parameter #4---owner address*

| Name           | Type   | Presence                | Description                                                                                                                                                                                                     |
| -------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ownerAddress` | string | Required<br>(exactly 1) | The Dash address to use for payee updates and proposal voting. The corresponding private key does not have to be known by this wallet. The address must be unused and must differ from the `collateralAddress`. |

*Parameter #5---operator public key register*

| Name                      | Type         | Presence                | Description                                                                                                                                            |
| ------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `operatorPubKey_register` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. |

*Parameter #6---voting address register*

| Name                     | Type   | Presence                | Description                                                                                                                                                                                                         |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_register` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, `ownerAddress` will be used. |

*Parameter #7---operator reward*

| Name             | Type   | Presence                | Description                                                                                     |
| ---------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `operatorReward` | number | Required<br>(exactly 1) | The fraction in % to share with the operator.<br>The value must be between `0.00` and `100.00`. |

*Parameter #8---payout address register*

| Name                     | Type   | Presence                | Description                                             |
| ------------------------ | ------ | ----------------------- | ------------------------------------------------------- |
| `payoutAddress_register` | string | Required<br>(exactly 1) | The Dash address to use for masternode reward payments. |

*Parameter #9---platform node ID*

| Name             | Type         | Presence                | Description                                        |
| ---------------- | ------------ | ----------------------- | -------------------------------------------------- |
| `platformNodeID` | string (hex) | Required<br>(exactly 1) | Platform P2P node ID, derived from P2P public key. |

*Parameter #10---platform p2p port*

| Name              | Type    | Presence                | Description                                        |
| ----------------- | ------- | ----------------------- | -------------------------------------------------- |
| `platformP2PPort` | numeric | Required<br>(exactly 1) | Platform P2P node ID, derived from P2P public key. |

*Parameter #11---platform http port*

| Name               | Type    | Presence                | Description                                                   |
| ------------------ | ------- | ----------------------- | ------------------------------------------------------------- |
| `platformHTTPPort` | numeric | Required<br>(exactly 1) | TCP port of Platform HTTP/API interface (network byte order). |

*Parameter #12---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---unsigned transaction and message to sign*

| Name                     | Type         | Presence                | Description                                                                                                                          |
| ------------------------ | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `result`                 | object       | Required<br>(exactly 1) | JSON object containing an unsigned provider transaction and the message to be signed externally, or JSON `null` if an error occurred |
| →<br>`tx`                | string (hex) | Required<br>(exactly 1) | The serialized unsigned ProRegTx in hex format                                                                                       |
| →<br>`collateralAddress` | string       | Required<br>(exactly 1) | The collateral address                                                                                                               |
| →<br>`signMessage`       | string (hex) | Required<br>(exactly 1) | The string message that needs to be signed with the collateral key.                                                                  |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet protx register_prepare_evo\ 
 df41e398bb245e973340d434d386f431dbd69735a575721b0b6833856e7d31ec\ 
 1  9.8.7.6:9876 yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz\ 
 06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280c\ 
 yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz 1.2 yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt\ 
 f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821 22822
```

Result:

```json
{
  "tx": "0300010001912b88876fee2f8e43e23b5e81276c163cf23d867bad4148170cb106ef9023700000000000feffffff0125623ba40b0000001976a914736e155c1039a269d4019c66219d2a18f0fee27588ac00000000d1010000000000ec317d6e8533680b1b7275a53597d6db31f486d334d44033975e24bb98e341df0100000000000000000000000000ffff090807062694ca6b243168b30461d1f19e2bb89a965a5bac067e06849865d01e4f73a6d5a025117e48f50b897e14235800501c8bfb8a6365cc8dbf5ddb67a3635d0f1dcc7d46a7ee280cca6b243168b30461d1f19e2bb89a965a5bac067e78001976a914fc136008111fcc7a05be6cec66f97568727a9e5188ace5f6b70ac55411727e25178bd417b9b03f837ad7155d90ad286f3a427203fb9f00",
  "collateralAddress": "yWuKWhDzGQqZL8rw6kGxGrfe6P8bUC2S4f",
  "signMessage": "yjJJLkYDUN6X8gWjXbCoKEXoiLeKxxMMRt|120|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|yemjhGQ99V5ayJMjoyGGPtxteahii6G1Jz|69a49e18c1253b90d39322f7e2f7af74524401bc33a27645e697e74a214e3e1e"
}
```

### ProTx Update Service Evo

The `protx update_service_evo` RPC creates and sends a ProUpServTx to the network. This will update the IP address and the Platform fields of an evonode. If this is done for an evonode that was PoSe-banned, the ProUpServTx will also revive this evonode.

*Parameter #1---initial provider registration transaction hash*

| Name        | Type         | Presence                | Description                                                   |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------------- |
| `proTxHash` | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Parameter #2---IP Address and port*

| Name        | Type   | Presence                | Description                                                          |
| ----------- | ------ | ----------------------- | -------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form 'IP:PORT'.<br>Must be unique on the network. |

*Parameter #3---operator key*

| Name          | Type         | Presence                | Description                                                                      |
| ------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------- |
| `operatorKey` | string (hex) | Required<br>(exactly 1) | The operator BLS private key associated with the registered operator public key. |

*Parameter #4---platform Node ID*

| Name             | Type   | Presence                | Description                                        |
| ---------------- | ------ | ----------------------- | -------------------------------------------------- |
| `platformNodeID` | string | Required<br>(exactly 1) | Platform P2P node ID, derived from P2P public key. |

*Parameter #5---platform P2P Port*

| Name              | Type    | Presence                | Description                                                                              |
| ----------------- | ------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| `platformP2PPort` | numeric | Required<br>(exactly 1) | TCP port of Dash Platform peer-to-peer communication between nodes (network byte order). |

*Parameter #6---platform HTTP Port*

| Name               | Type    | Presence                | Description                                                   |
| ------------------ | ------- | ----------------------- | ------------------------------------------------------------- |
| `platformHTTPPort` | numeric | Required<br>(exactly 1) | TCP port of Platform HTTP/API interface (network byte order). |

*Parameter #7---operator payout address*

| Name                    | Type   | Presence             | Description                                                                                                                                                                                         |
| ----------------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPayoutAddress` | string | Optional<br>(0 or 1) | The Dash address used for operator reward payments. Only allowed when the ProRegTx had a non-zero `operatorReward` value. If set to an empty string, the currently active payout address is reused. |

*Parameter #8---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                                       |
| ------------------ | ------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `operatorPayoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---provider update service transaction hash*

| Name     | Type         | Presence                | Description                                            |
| -------- | ------------ | ----------------------- | ------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Provider update service transaction (ProUpServTx) hash |

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnetprotx update_service_evo\
 ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd\
 4.3.2.1:4321\
 4da7e1ea30fb9e55c73ad23df0b9d3d34342acb24facf4b19420e1a26ae272d1\ 
 f2dbd9b0a1f541a7c44d34a58674d0262f5feca5 22821  22822
```

Result:

```bash
5b6cfa1bdd3c8b7e0b9550b9c4e809381f81a410bc7f241d3879dd736fd51270
```

### ProTx Register Submit

The `protx register_submit` RPC combines the unsigned ProTx and a signature of the signMessage, signs all inputs which were added to cover fees and submits the resulting transaction to the network. Note: See [`protx register_prepare`](#protx-register-prepare) for more info about creating a ProTx and a message to sign.

*Parameter #1---collateral address*

| Name | Type         | Presence                | Description                                                                         |
| ---- | ------------ | ----------------------- | ----------------------------------------------------------------------------------- |
| `tx` | string (hex) | Required<br>(exactly 1) | The serialized unsigned transaction previously returned by `protx register_prepare` |

*Parameter #2---collateral index*

| Name  | Type            | Presence                | Description                                                             |
| ----- | --------------- | ----------------------- | ----------------------------------------------------------------------- |
| `sig` | string (base64) | Required<br>(exactly 1) | The signature signed with the collateral key. Must be in base64 format. |

*Result---provider registration transaction hash*

| Name     | Type         | Presence                | Description                                       |
| -------- | ------------ | ----------------------- | ------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider registration transaction (ProRegTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx register_submit\
 03000100012d988526d5d1efd32320023c92eff09c2963dcb021b0de9761\
 17e5e37dc7a7870000000000feffffff015f603ba40b0000001976a9140c\
 37e07eb5c608961769e6506c23c11e9f9fe00988ac00000000d101000000\
 00002d988526d5d1efd32320023c92eff09c2963dcb021b0de976117e5e3\
 7dc7a7870100000000000000000000000000ffff05060708162e243dd366\
 bf4a329968d77eac9fb63481a600938d125e1b7cba03ca2a097e402185e6\
 160232ea53e6d62898a3be8617b06ff347d967543228bd9b605547c3d478\
 b0a838ca243dd366bf4a329968d77eac9fb63481a600938dc4091976a914\
 e9bf4e6f26fecf1dfc1e04dde43472df378628b888ac6a048e7f645e8adc\
 305ccfd8652066046a0702596af13b8ac97803ade256da2900\
 \
 H90IvqVtFjZkwLJb08yMEgGixs0/FpcdvwImBcir4cYLJhD3pdX+lKD2GsPl6KNxghVXNk5/HpOdBoWAHo9u++Y=
```

Result:

```text
273ce3ebe24183ee4117b10e054cdbb108a3bde5d2f286129e29480d46a3f573
```

### ProTx Revoke

The `protx revoke` RPC creates and sends a ProUpRevTx to the network.

*Parameter #1---initial provider registration transaction hash*

| Name        | Type         | Presence                | Description                                                   |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------------- |
| `proTxHash` | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Parameter #2---operator private key*

| Name             | Type         | Presence                | Description                                                               |
| ---------------- | ------------ | ----------------------- | ------------------------------------------------------------------------- |
| `operatorKey`    | string (hex) | Required<br>(exactly 1) | The operator private key belonging to the registered operator public key. |

*Parameter #3---reason*

| Name     | Type   | Presence                | Description                |
| -------- | ------ | ----------------------- | -------------------------- |
| `reason` | number | Optional<br>(0 or 1)    | The reason for revocation. This is  informational and does not effect the revocation:<br>`0` - Reason not specified<br>`1` - Termination of service<br>`2` - Compromised keys<br>`3` - Change of keys |

*Parameter #4---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---provider update revoke transaction hash*

| Name     | Type         | Presence                | Description                                          |
| -------- | ------------ | ----------------------- | ---------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider update revoke transaction (ProUpRevTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx revoke\
 "ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd"\
 "4da7e1ea30fb9e55c73ad23df0b9d3d34342acb24facf4b19420e1a26ae272d1"
```

Result:

```bash
2aad36dd2ab254bee06b0b5dad51e7603691b72058d5806fd94e1d2d19a7c209
```

### ProTx Update Registrar

:::{attention}
Following the Dash Core v19 hard fork activation, masternodes registered prior to the hard fork must use the [`protx update_registrar_legacy` RPC](#protx-update-registrar-legacy) unless they have already updated to a basic scheme BLS key.
:::

The `protx update_registrar` RPC creates and sends a ProUpRegTx to the network.

*Parameter #1---initial provider registration transaction hash*

| Name        | Type         | Presence                | Description                                                   |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------------- |
| `proTxHash` | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Parameter #2---operator public key*

| Name             | Type         | Presence                | Description                                                                                                                                                                                                                               |
| ---------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPubKey` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. If set to an empty string, the currently active operator BLS public key is reused. |

*Parameter #3---voting address*

| Name            | Type   | Presence                | Description                                                                                                                                                                                                                               |
| --------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress` | string | Required<br>(exactly 1) | The voting address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, the currently active voting key address is reused. |

*Parameter #4---operator payout address*

| Name            | Type   | Presence             | Description                                                                                                                       |
| --------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `payoutAddress` | string | Optional<br>(0 or 1) | The Dash address to use for masternode reward payments. If set to an empty string, the currently active payout address is reused. |

*Parameter #5---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                               |
| ------------------ | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `payoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---provider update registrar transaction hash*

| Name     | Type         | Presence                | Description                                             |
| -------- | ------------ | ----------------------- | ------------------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Provider update registrar transaction (ProUpRegTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx update_registrar\
 "ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd"\
 "0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51"\
 "yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw" "yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7"
```

Result:

```bash
702390ef06b10c174841ad7b863df23c166c27815e3be2438e2fee6f87882b91
```

### ProTx Update Registrar Legacy

:::{note}
Since the v19 hard fork activation, this command must be used if a legacy scheme BLS key is being used to registrar update a masternode. This would include all masternodes registered prior to the hard fork that have not already updated to a new basic scheme BLS key.
:::

The `protx update_registrar_legacy` RPC creates and sends a ProUpRegTx to the network. This will update the operator key, voting key and payout address of the masternode specified by `proTxHash`. The owner key of the masternode must be known to your wallet. Requires the wallet passphrase to be provide with the [`walletpassphrase` RPC](../api/remote-procedure-calls-wallet.md#walletpassphrase) if the wallet is encrypted.

*Parameter #1---initial provider registration transaction hash*

| Name        | Type         | Presence                | Description                                                   |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------------- |
| `proTxHash` | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Parameter #2---operator public key*

| Name                    | Type         | Presence                | Description                                                                                                                                                                                                                               |
| ----------------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPubKey_update` | string (hex) | Required<br>(exactly 1) | The operator public key. The private key does not have to be known. It has to match the private key which is later used when operating the masternode. If set to an empty string, the currently active operator BLS public key is reused. |

*Parameter #3---voting address*

| Name                   | Type   | Presence                | Description                                                                                                                                                                                                                                   |
| ---------------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `votingAddress_update` | string | Required<br>(exactly 1) | The voting key address. The private key does not have to be known by your wallet. It has to match the private key which is later used when voting on proposals. If set to an empty string, the currently active voting key address is reused. |

*Parameter #4---operator payout address*

| Name                   | Type   | Presence             | Description                                                                                                                       |
| ---------------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `payoutAddress_update` | string | Optional<br>(0 or 1) | The Dash address to use for masternode reward payments. If set to an empty string, the currently active payout address is reused. |

*Parameter #5---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                                                |
| ------------------ | ------ | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund ProTx. If not specified, payoutAddress is the one that is going to be used. The private key belonging to this address must be known in your wallet. |

*Result---provide transaction ID*

| Name     | Type         | Presence                | Description            |
| -------- | ------------ | ----------------------- | ---------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Receive transaction ID |

*Example from Dash Core 19.0.0*

```bash
dash-cli -testnet protx update_registrar_legacy\
 "ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd"\
 "0e02146e9c34cfbcb3f3037574a1abb35525e2ca0c3c6901dbf82ac591e30218d1711223b7ca956edf39f3d984d06d51"\
 "yX2cDS4kcJ4LK4uq9Hd4TG7kURV3sGLZrw" "yakx4mMRptKhgfjedNzX5FGQq7kSSBF2e7"
```

Result:

```bash
702390ef06b10c174841ad7b863df23c166c27815e3be2438e2fee6f87882b91
```

### ProTx Update Service

The `protx update_service` RPC creates and sends a ProUpServTx to the network.

*Parameter #1---initial provider registration transaction hash*

| Name        | Type         | Presence                | Description                                                   |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------------- |
| `proTxHash` | string (hex) | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Parameter #2---IP Address and port*

| Name        | Type   | Presence                | Description                                                          |
| ----------- | ------ | ----------------------- | -------------------------------------------------------------------- |
| `ipAndPort` | string | Required<br>(exactly 1) | IP and port in the form 'IP:PORT'.<br>Must be unique on the network. |

*Parameter #3---operator key*

| Name          | Type         | Presence                | Description                                                                      |
| ------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------- |
| `operatorKey` | string (hex) | Required<br>(exactly 1) | The operator BLS private key associated with the registered operator public key. |

*Parameter #4---operator payout address*

| Name                    | Type   | Presence             | Description                                                                                                                                                                                         |
| ----------------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operatorPayoutAddress` | string | Optional<br>(0 or 1) | The Dash address used for operator reward payments. Only allowed when the ProRegTx had a non-zero `operatorReward` value. If set to an empty string, the currently active payout address is reused. |

*Parameter #5---fee source address*

| Name               | Type   | Presence             | Description                                                                                                                                                                                                       |
| ------------------ | ------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feeSourceAddress` | string | Optional<br>(0 or 1) | If specified, the wallet will only use coins from this address to fund the ProTx. If not specified, `operatorPayoutAddress` will be used. The private key belonging to this address must be known in your wallet. |

*Result---provider update service transaction hash*

| Name     | Type         | Presence                | Description                                            |
| -------- | ------------ | ----------------------- | ------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | Provider update service transaction (ProUpServTx) hash |

*Example from Dash Core 0.13.0*

```bash
dash-cli -testnet protx update_service\
 ba1b3330e16a0876b7a186e7ceb689f03ec646e611e91d7139de021bbf13afdd\
 "4.3.2.1:4321"\
 4da7e1ea30fb9e55c73ad23df0b9d3d34342acb24facf4b19420e1a26ae272d1
```

Result:

```bash
5b6cfa1bdd3c8b7e0b9550b9c4e809381f81a410bc7f241d3879dd736fd51270
```

## Quorum

*Added in Dash Core 0.14.0*

The [`quorum` RPC](../api/remote-procedure-calls-evo.md#quorum) provides a set of commands for quorums (LLMQs).

### Quorum List

The `quorum list` RPC displays a list of on-chain quorums.

*Parameter #1---quorum count*

| Name    | Type   | Presence             | Description                                                                      |
| ------- | ------ | -------------------- | -------------------------------------------------------------------------------- |
| `count` | number | Optional<br>(0 or 1) | Number of quorums to list. Will list active quorums if `count` is not specified. |

*Result---a list of quorums*

| Name               | Type         | Presence                | Description             |
| ------------------ | ------------ | ----------------------- | ----------------------- |
| `result`           | object       | Required<br>(exactly 1) | Quorum list             |
| →<br>Quorum        | array        | Required<br>(1 or more) | Array of quorum details |
| → →<br>Quorum Hash | string (hex) | Optional<br>(0 or more) | A quorum hash           |

*Example from Dash Core 0.14.0*

```bash
dash-cli -testnet quorum list
```

Result:

```json
{
  "llmq_50_60": [
    "00000000023cc6dde69bed898c83fe2328ef38b1ea9da14a599efa14caef0b7d",
    "000000002b968fb3b2fc2ff18d6e89611e366b4d38a6d0437e99bd7c37f2fd83",
    "000000000301054c038b07b5b51493d5efc3f078e3aede6eb603c47943d1cc78",
    "000000000e901278c00c896754a06f8d45d0268c6aff6e72ffb3007d07c10e73",
    "000000001bc592f2a8676203835bc6ad442abeadb9c22b8d6a2999db07354b01",
    "000000000896c37ef8a32318ee871589394f1578473b8825275b610690e47db0",
    "00000000133b192b2319a0716ad18e5788981fff51856f61205af5d6a634ba41",
    "0000000004946f3f9f82a298985f73080d62627d51f6f4ba77f3cd8c6788b3d0",
    "0000000005cb014d3df9bac0ba379f1d5b8b75f0e6d7c408d43ac1db330ec641",
    "0000000006c1653c7ee747f140dd7daa1da23a541e67a0fc0dc88db3482ec4d5"
  ],
  "llmq_400_60": [
    "0000000007697fd69a799bfa26576a177e817bc0e45b9fcfbf48b362b05aeff2"
  ],
  "llmq_400_85": [
  ]
}
```

### Quorum Info

The `quorum info` RPC returns information about a specific quorum.

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                               |
| ---------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorums](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md) to list:<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---quorum hash*

| Name         | Type         | Presence                | Description                  |
| ------------ | ------------ | ----------------------- | ---------------------------- |
| `quorumHash` | string (hex) | Required<br>(exactly 1) | The block hash of the quorum |

*Parameter #3---secret key share*

| Name             | Type | Presence             | Description                                     |
| ---------------- | ---- | -------------------- | ----------------------------------------------- |
| `includeSkShare` | bool | Optional<br>(0 or 1) | Include the secret key share (default: `false`) |

*Result---information about a quorum*

| Name                                  | Type         | Presence                | Description                                                                                                                                                                            |
| ------------------------------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                              | object       | Required<br>(exactly 1) | Quorum list                                                                                                                                                                            |
| →<br>`height`                         | number       | Required<br>(exactly 1) | Block height of the quorum                                                                                                                                                             |
| →<br>`type`                           | string       | Required<br>(exactly 1) | Type of LLMQ                                                                                                                                                                           |
| →<br>`quorumHash`                     | string (hex) | Required<br>(exactly 1) | The hash of the quorum                                                                                                                                                                 |
| →<br>`quorumIndex`                    | number       | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The index of the quorum                                                                                                                               |
| →<br>`minedBlock`                     | string (hex) | Required<br>(exactly 1) | The hash of the block that established the quorum                                                                                                                                      |
| →<br>`previousConsecutiveDKGFailures` | number       | Optional<br>(0 or 1)    | **Added in Dash Core 19.0**<br>The number of previous consecutive DKG failures for the corresponding `quorumIndex` before the currently active one. Only present for rotating quorums. |
| →<br>`members`                        | array        | Required<br>(exactly 1) | An array containing quorum member details                                                                                                                                              |
| → →<br>Member                         | object       | Required<br>(1 or more) | An object describing a particular member                                                                                                                                               |
| → → →<br>`proTxHash`                  | string (hex) | Required<br>(exactly 1) | The masternode's Provider Registration transaction hash                                                                                                                                |
| → → →<br>`service`                    | string       | Required<br>(exactly 1) | *Added in Dash Core 18.1.0*<br>The masternode's IP:Port                                                                                                                              |
| → → →<br>`pubKeyOperator`             | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.15.0*<br>The masternode's Operator public key                                                                                                                    |
| → → →<br>`valid`                      | bool         | Required<br>(exactly 1) | Indicates if the member is valid                                                                                                                                                       |
| → → →<br>`pubKeyShare`                | string       | Optional<br>(0 or 1)    | Member public key share                                                                                                                                                                |
| →<br>`quorumPublicKey`                | string       | Required<br>(exactly 1) | Quorum public key                                                                                                                                                                      |
| →<br>`secretKeyShare`                 | string       | Optional<br>(exactly 1) | Quorum secret key share                                                                                                                                                                |

*Example from Dash Core 18.1.0*

```bash
dash-cli -testnet quorum info 1 \
  000000ebd10368ca387ce380539fad9c8ba21108a3bfd6fedeecb60d28f56ae9 true
```

Result (truncated):

```json
{
  "height": 819240,
  "type": "llmq_50_60",
  "quorumHash": "000000ebd10368ca387ce380539fad9c8ba21108a3bfd6fedeecb60d28f56ae9",
  "quorumIndex": 0,
  "minedBlock": "00000548588369399691ad308a3c588a7bf842a40347e23ef40655e315898146",
  "members": [
    {
      "proTxHash": "f77ec12ec8adb91a3a158c5f9cc3f7e2521d65eac6cda1e44763daa603a77570",
      "service": "35.89.202.171:19999",
      "pubKeyOperator": "16f8048e511e7c0c2b495a9b20030b315d75bca283b70af25d16c8809c7f2a786225c2fe47ff1c92aa8ebf586be91abc",
      "valid": true,
      "pubKeyShare": "12c305fdc5ec06785d2e89a8b64c291128e4a2034889e9f1539d9194954051a304d8bf1649a2d3a95aac200884e8e99d"
    },
    {"Truncated data":"..."},
    {
      "proTxHash": "2cd3833e1cef622e875096c70d6eb6c7083a250a6b26ca27edb3aa21ac05e3d1",
      "service": "89.47.162.137:19999",
      "pubKeyOperator": "8fc1d0cea417ed963e50d876a38bf0846b536b7e8809826e163bc9ea0f749ea8ebe00c6642e71bb84000549bda5bb1d0",
      "valid": true,
      "pubKeyShare": "8662927148ed33b8f0000f1666c277e14df9838c9dce4e3fb273866603b93502e70108408f81698e0b47cb3b5aff3a30"
    }
  ],
  "quorumPublicKey": "18401a5c5d8d8145cea2843e0c37f10d06de642ce7665599ad35dce9f7a3027b42375a9e138e185867bfe5359fd952f2",
  "secretKeyShare": "4d39c4c1cb856a5e2d96efffb4cf3695b57b5d0fb4e289e7b2be3b7592a6dfa6"
}
```

### Quorum DKGInfo

:::{versionadded} 20.1.0
:::

The `quorum dkginfo` RPC returns information about active and upcoming DKG sessions.

*Parameters: none*

*Result---information about DKG*

| Name                                  | Type         | Presence                | Description |
| ------------------------------------- | ------------ | ----------------------- | ----------- |
| `result`                              | object       | Required<br>(exactly 1) | Quorum info |
| →<br>`active_dkgs` | number | Required<br>(exactly 1) | Total number of active DKG sessions this node is participating in currently
| →<br>`next_dkg`    | number | Required<br>(exactly 1) | The number of blocks until the next potential DKG session |

*Example from Dash Core 20.1.0*

```bash
dash-cli -testnet quorum dkginfo
```

Result (truncated):

```json
{
  "active_dkgs": 0,
  "next_dkg": 10
}
```

### Quorum DKGStatus

The `quorum list` RPC displays the status of the current DKG process.

*Parameter #1---detail level*

| Name           | Type   | Presence             | Description                                                                                                                                                                                                                                                      |
| -------------- | ------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `detail_level` | number | Optional<br>(0 or 1) | Detail level of output (default: 0):<br>`0` - Only show counts (*default*)<br>`1` - Show member indexes<br>`2` - Show member's ProTxHashes<br><br>*Note: Works only when Spork 17 is enabled and only displays details related to the node running the command.* |

*Result (if detail level was 0 or omitted)---JSON DKG details*

| Name                                      | Type             | Presence                | Description                                                                                                                                                                      |
| ----------------------------------------- | ---------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                                  | array            | Required<br>(exactly 1) | An array of objects each containing a provider transaction, or JSON `null` if an error occurred                                                                                  |
| →<br>`time`                               | number           | Required<br>(exactly 1) | The Unix epoch time                                                                                                                                                              |
| →<br>`timeStr`                            | string           | Required<br>(exactly 1) | The UTC time as a string                                                                                                                                                         |
| →<br>`session`                            | array of objects | Required<br>(exactly 1) | Array of objects containing DKG Session information                                                                                                                              |
| → →<br>Session                            | object           | Required<br>(exactly 1) | DKG session object                                                                                                                                                               |
| → → →<br>`llmqType`                       | string           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>[Quorum type name](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md)                                                          |
| → → →<br>`quorumIndex`                    | number           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The index of the quorum                                                                                                                         |
| → → →<br>`status`                         | object           | Required<br>(exactly 1) | DKG session status information                                                                                                                                                   |
| → → → →<br>`llmqType`                     | number           | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |
| → → → →<br>`quorumHash`                   | string (hex)     | Required<br>(exactly 1) | The block hash of the quorum                                                                                                                                                     |
| → → → →<br>`quorumHeight`                 | number           | Required<br>(exactly 1) | The block height of the quorum                                                                                                                                                   |
| → → → →<br>`phase`                        | number           | Required<br>(exactly 1) | The active DKG phase<br>`1` - Initialized<br>`2` - Contributing<br>`3` - Complaining<br>`4` - Justifying<br>`5` - Committing<br>`6` - Finalizing                                 |
| → → → →<br>`sentContributions`            | bool             | Required<br>(exactly 1) | True when contributions have been sent                                                                                                                                           |
| → → → →<br>`sentComplaint`                | bool             | Required<br>(exactly 1) | True when complaints have been sent                                                                                                                                              |
| → → → →<br>`sentJustification`            | bool             | Required<br>(exactly 1) | True when justifications have been sent                                                                                                                                          |
| → → → →<br>`sentPrematureCommitment`      | bool             | Required<br>(exactly 1) | True when premature commitments have been sent                                                                                                                                   |
| → → → →<br>`aborted`                      | bool             | Required<br>(exactly 1) | True if the DKG session has been aborted                                                                                                                                         |
| → → → →<br>`badMembers`                   | number           | Required<br>(exactly 1) | Number of bad members                                                                                                                                                            |
| → → → →<br>`weComplain`                   | number           | Required<br>(exactly 1) | Number of complaints sent                                                                                                                                                        |
| → → → →<br>`receivedContributions`        | number           | Required<br>(exactly 1) | Number of contributions received                                                                                                                                                 |
| → → → →<br>`receivedComplaints`           | number           | Required<br>(exactly 1) | Number of complaints received                                                                                                                                                    |
| → → → →<br>`receivedJustifications`       | number           | Required<br>(exactly 1) | Number of justifications received                                                                                                                                                |
| → → → →<br>`receivedPrematureCommitments` | number           | Required<br>(exactly 1) | Number of premature commitments received                                                                                                                                         |
| →<br>`quorumConnections`                  | array of objects | Required<br>(exactly 1) | **Modified in Dash Core 18.0.0**<br>Array of objects containing quorum connection information                                                                                    |
| → →<br>Quorum type                        | object           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>An object describing connection information for a quorum index and type                                                                         |
| → → →<br>`llmqType`                       | string           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>[Quorum type name](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md)                                                          |
| → → →<br>`quorumIndex`                    | number           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The index of the quorum                                                                                                                         |
| → → →<br>`pQuorumBaseBlockIndex`          | number           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The height of the quorum's base block                                                                                                           |
| → → → <br>`quorumHash`                    | string (hex)     | Required<br>(exactly 1) | The block hash of the quorum                                                                                                                                                     |
| → → →<br>`pindexTip`                      | number           | Required<br>(exactly 1) | *Added in Dash Core 18.0.0*<br>The height of the quorum's index tip                                                                                                            |
| → → →<br>`quorumConnections`              | array of objects | Required<br>(exactly 1) | Array of objects containing quorum connection information                                                                                                                        |
| → → → →<br>Connection                     | object           | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>An object describing a quorum connection                                                                                                    |
| → → → →→<br>`proTxHash`                   | string (hex)     | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>The hash of the quorum member's provider registration transaction as hex in RPC byte order                                                  |
| → → → →→<br>`connected`                   | boolean          | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Whether or not the connection is active                                                                                                     |
| → → → →→<br>`address`                     | string           | Optional<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Address                                                                                                                                     |
| → → → →→<br>`outbound`                    | boolean          | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Whether or not this is an outbound connection                                                                                               |
| →<br>`minableCommitments`                 | object           | Required<br>(exactly 1) | Object containing minable commitments                                                                                                                                            |

*Result (if detail level was 1)---JSON DKG details including member index*

Note: detail level 1 includes all level 0 fields and expands the following fields.

| Name                                    | Type  | Presence                | Description                                                       |
| --------------------------------------- | ----- | ----------------------- | ----------------------------------------------------------------- |
| → → →<br>`badMembers`                   | array | Required<br>(exactly 1) | Array containing the member index for each bad member             |
| → → →<br>`weComplain`                   | array | Required<br>(exactly 1) | Array containing the member index for each complaint sent         |
| → → →<br>`receivedContributions`        | array | Required<br>(exactly 1) | Array containing the member index for each contribution received  |
| → → →<br>`receivedComplaints`           | array | Required<br>(exactly 1) | Array containing the member index for each complaint received     |
| → → →<br>`receivedJustifications`       | array | Required<br>(exactly 1) | Array containing the member index for each justification received |
| → → →<br>`receivedPrematureCommitments` | array | Required<br>(exactly 1) | Array containing the member index for each commitment received    |

*Result (if detail level was 2)---JSON DKG details including member index and ProTx hash*

Note: detail level 2 includes all level 0 fields, adds the `allMembers` field, and expands several fields.

| Name                                    | Type         | Presence                | Description                                                                                                                           |
| --------------------------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| → → →<br>`badMembers`                   | array        | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a bad member                                      |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`weComplain`                   | object       | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a member being complained about                   |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`receivedContributions`        | object       | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a member a contribution was received from         |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`receivedComplaints`           | object       | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a member a complaint was received from            |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`receivedJustifications`       | object       | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a member a justification was received from        |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`receivedPrematureCommitments` | object       | Required<br>(exactly 1) | An array of objects with each object containing the member index and ProTx hash for a member a premature commitment was received from |
| → → → →<br>Member                       | object       | Required<br>(0 or more) | An object describing quorum member details                                                                                            |
| → → → → →<br>`memberIndex`              | number       | Required<br>(exactly 1) | The quorum member's index                                                                                                             |
| → → → → →<br>`proTxHash`                | string (hex) | Required<br>(exactly 1) | The hash of the quorum member's provider registration transaction as hex in RPC byte order                                            |
| → → →<br>`allMembers`                   | array        | Required<br>(exactly 1) | Array containing the provider registration transaction hash for all quorum members                                                    |

*Example from Dash Core 18.0.0*

```bash
dash-cli -testnet quorum dkgstatus
```

Result (truncated):

```json
{
  "time": 1644854935,
  "timeStr": "2022-02-14T16:08:55Z",
  "session": [
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 0,
      "status": {
        "llmqType": 101,
        "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
        "quorumHeight": 6072,
        "phase": 6,
        "sentContributions": true,
        "sentComplaint": false,
        "sentJustification": false,
        "sentPrematureCommitment": true,
        "aborted": false,
        "badMembers": 0,
        "weComplain": 0,
        "receivedContributions": 12,
        "receivedComplaints": 0,
        "receivedJustifications": 0,
        "receivedPrematureCommitments": 12
      }
    }
  ],
  "quorumConnections": [
    {
      "llmqType": "llmq_50_60",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_400_60",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6048,
      "quorumHash": "0000000a428025892b1d62bd27b0bf8eee521218d12f9a459a7bde20a944a3bc",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_100_67",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "ec4ca45ccce7d7f94ab824a9f4840c3a85731c8bc70ba21953992009214c7e1d",
          "connected": true,
          "address": "34.219.73.212:49030",
          "outbound": false
        },
        {
          "proTxHash": "895cb52efac54f92ed726ad9da15fd6a8c94fcabae2f9c41ad81be0c214e0d1e",
          "connected": true,
          "address": "35.88.228.131:46084",
          "outbound": false
        },
      ]
    },
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 1,
      "pQuorumBaseBlockIndex": 6073,
      "quorumHash": "000000b1823c0d77dcfbd6a11404ddbcfc259a503aec9a7aadfdfabc7602a7be",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "93b2f08a18d9ac165aad16d66d8492721f4556e53d3a2d28b045cc992ce65725",
          "connected": true,
          "address": "54.191.24.26:38528",
          "outbound": false
        },
      ]
    }
  ],
  "minableCommitments": [
    {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    },
    {
      "version": 1,
      "llmqType": 4,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    }
  ]
}
```

*Example from Dash Core 18.0.0 (detail_level: 1)*

```bash
dash-cli -testnet quorum dkgstatus 1
```

Result (truncated):

```json
{
  "time": 1644854935,
  "timeStr": "2022-02-14T16:08:55Z",
  "session": [
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 0,
      "status": {
        "llmqType": 101,
        "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
        "quorumHeight": 6072,
        "phase": 6,
        "sentContributions": true,
        "sentComplaint": false,
        "sentJustification": false,
        "sentPrematureCommitment": true,
        "aborted": false,
        "badMembers": [
        ],
        "weComplain": [
        ],
        "receivedContributions": [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11
        ],
        "receivedComplaints": [
        ],
        "receivedJustifications": [
        ],
        "receivedPrematureCommitments": [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11
        ]
      }
    }
  ],
  "quorumConnections": [
    {
      "llmqType": "llmq_50_60",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_100_67",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
],
  "minableCommitments": [
    {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    },
    {
      "version": 1,
      "llmqType": 4,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    }
  ]
}

```

*Example from Dash Core 18.0.0 (detail_level: 2)*

```bash
dash-cli -testnet quorum dkgstatus 2
```

Result (truncated):

```json
{
  "time": 1644854935,
  "timeStr": "2022-02-14T16:08:55Z",
  "session": [
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 0,
      "status": {
        "llmqType": 101,
        "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
        "quorumHeight": 6072,
        "phase": 6,
        "sentContributions": true,
        "sentComplaint": false,
        "sentJustification": false,
        "sentPrematureCommitment": true,
        "aborted": false,
        "badMembers": [
        ],
        "weComplain": [
        ],
        "receivedContributions": [
          {
            "memberIndex": 0,
            "proTxHash": "6503cd51fd93d0923eaee599b8f48dceb639b0f1a7e5dfd064d439c9729e1b48"
          },
          {
            "memberIndex": 1,
            "proTxHash": "f9bf9e69ef111ca5218804f004c5e31abd971699847f52364e88301559cab6f8"
          },
          {
            "memberIndex": 2,
            "proTxHash": "895cb52efac54f92ed726ad9da15fd6a8c94fcabae2f9c41ad81be0c214e0d1e"
          },
          {
            "memberIndex": 3,
            "proTxHash": "fd1fe03e178b397baa304fdcb98c7e99b6d39768029490270e17b53f4fef7aa3"
          },
          {
            "memberIndex": 4,
            "proTxHash": "ec4ca45ccce7d7f94ab824a9f4840c3a85731c8bc70ba21953992009214c7e1d"
          },
          {
            "memberIndex": 5,
            "proTxHash": "9c3173a86ef146920ad37f3b0c4f9be0f08063c1d194aaa9602d766a5de782a9"
          },
          {
            "memberIndex": 6,
            "proTxHash": "856c3dd446c0791e800aa24f6a726431a0d4df6ed3cfb3a71b1bf3951764cbf3"
          },
          {
            "memberIndex": 7,
            "proTxHash": "38e2e295b4ed4f2d93731951537fd2fa31bee87833b61443a6961117a0c970a8"
          },
          {
            "memberIndex": 8,
            "proTxHash": "e76cdb5c9e004fb9bf83bfcebf7bf59bcbe925a1d348d3e5cfb108910e45d0d1"
          },
          {
            "memberIndex": 9,
            "proTxHash": "8abb1f227473e188d0e3ff39201badd49d22f8b323f9cfdd096d109f50614b6c"
          },
          {
            "memberIndex": 10,
            "proTxHash": "8675ed9f95526868ce4cf88ffe5a26ccff90b7623516735219c6e16731e4288a"
          },
          {
            "memberIndex": 11,
            "proTxHash": "e657b9abffe8326c25236ccfb28408617d3f5c3704d703edc1271db37db62b5d"
          }
        ],
        "receivedComplaints": [
        ],
        "receivedJustifications": [
        ],
        "receivedPrematureCommitments": [
          {
            "memberIndex": 0,
            "proTxHash": "6503cd51fd93d0923eaee599b8f48dceb639b0f1a7e5dfd064d439c9729e1b48"
          },
          {
            "memberIndex": 1,
            "proTxHash": "f9bf9e69ef111ca5218804f004c5e31abd971699847f52364e88301559cab6f8"
          },
          {
            "memberIndex": 2,
            "proTxHash": "895cb52efac54f92ed726ad9da15fd6a8c94fcabae2f9c41ad81be0c214e0d1e"
          },
          {
            "memberIndex": 3,
            "proTxHash": "fd1fe03e178b397baa304fdcb98c7e99b6d39768029490270e17b53f4fef7aa3"
          },
          {
            "memberIndex": 4,
            "proTxHash": "ec4ca45ccce7d7f94ab824a9f4840c3a85731c8bc70ba21953992009214c7e1d"
          },
          {
            "memberIndex": 5,
            "proTxHash": "9c3173a86ef146920ad37f3b0c4f9be0f08063c1d194aaa9602d766a5de782a9"
          },
          {
            "memberIndex": 6,
            "proTxHash": "856c3dd446c0791e800aa24f6a726431a0d4df6ed3cfb3a71b1bf3951764cbf3"
          },
          {
            "memberIndex": 7,
            "proTxHash": "38e2e295b4ed4f2d93731951537fd2fa31bee87833b61443a6961117a0c970a8"
          },
          {
            "memberIndex": 8,
            "proTxHash": "e76cdb5c9e004fb9bf83bfcebf7bf59bcbe925a1d348d3e5cfb108910e45d0d1"
          },
          {
            "memberIndex": 9,
            "proTxHash": "8abb1f227473e188d0e3ff39201badd49d22f8b323f9cfdd096d109f50614b6c"
          },
          {
            "memberIndex": 10,
            "proTxHash": "8675ed9f95526868ce4cf88ffe5a26ccff90b7623516735219c6e16731e4288a"
          },
          {
            "memberIndex": 11,
            "proTxHash": "e657b9abffe8326c25236ccfb28408617d3f5c3704d703edc1271db37db62b5d"
          }
        ],
        "allMembers": [
          "6503cd51fd93d0923eaee599b8f48dceb639b0f1a7e5dfd064d439c9729e1b48",
          "f9bf9e69ef111ca5218804f004c5e31abd971699847f52364e88301559cab6f8",
          "895cb52efac54f92ed726ad9da15fd6a8c94fcabae2f9c41ad81be0c214e0d1e",
          "fd1fe03e178b397baa304fdcb98c7e99b6d39768029490270e17b53f4fef7aa3",
          "ec4ca45ccce7d7f94ab824a9f4840c3a85731c8bc70ba21953992009214c7e1d",
          "9c3173a86ef146920ad37f3b0c4f9be0f08063c1d194aaa9602d766a5de782a9",
          "856c3dd446c0791e800aa24f6a726431a0d4df6ed3cfb3a71b1bf3951764cbf3",
          "38e2e295b4ed4f2d93731951537fd2fa31bee87833b61443a6961117a0c970a8",
          "e76cdb5c9e004fb9bf83bfcebf7bf59bcbe925a1d348d3e5cfb108910e45d0d1",
          "8abb1f227473e188d0e3ff39201badd49d22f8b323f9cfdd096d109f50614b6c",
          "8675ed9f95526868ce4cf88ffe5a26ccff90b7623516735219c6e16731e4288a",
          "e657b9abffe8326c25236ccfb28408617d3f5c3704d703edc1271db37db62b5d"
        ]
      }
    }
  ],
  "quorumConnections": [
    {
      "llmqType": "llmq_50_60",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_100_67",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "e3a1bc7820e24820ab557c7dc7650b5a6ec326adac9599f42ed981e4227bdc0e",
          "connected": true,
          "address": "54.187.0.112:20001",
          "outbound": true
        },
      ]
    },
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 0,
      "pQuorumBaseBlockIndex": 6072,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "ec4ca45ccce7d7f94ab824a9f4840c3a85731c8bc70ba21953992009214c7e1d",
          "connected": true,
          "address": "34.219.73.212:49030",
          "outbound": false
        },
        {
          "proTxHash": "895cb52efac54f92ed726ad9da15fd6a8c94fcabae2f9c41ad81be0c214e0d1e",
          "connected": true,
          "address": "35.88.228.131:46084",
          "outbound": false
        },
      ]
    },
    {
      "llmqType": "llmq_devnet",
      "quorumIndex": 1,
      "pQuorumBaseBlockIndex": 6073,
      "quorumHash": "000000b1823c0d77dcfbd6a11404ddbcfc259a503aec9a7aadfdfabc7602a7be",
      "pindexTip": 6082,
      "quorumConnections": [
        {
          "proTxHash": "bfcfc61bb222d4744276a3591df2239c540da36f4638ce234a4490ac35254607",
          "connected": true,
          "address": "54.68.152.187:54748",
          "outbound": false
        },
        {
          "proTxHash": "93b2f08a18d9ac165aad16d66d8492721f4556e53d3a2d28b045cc992ce65725",
          "connected": true,
          "address": "54.191.24.26:38528",
          "outbound": false
        },
      ]
    }
  ],
  "minableCommitments": [
    {
      "version": 1,
      "llmqType": 1,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    },
    {
      "version": 1,
      "llmqType": 4,
      "quorumHash": "0000003d2100d243f73bd65b392f21a1023f7dfecc54505511c897a5896c0c2c",
      "quorumIndex": 0,
      "signersCount": 0,
      "signers": "00000000000000000000000000",
      "validMembersCount": 0,
      "validMembers": "00000000000000000000000000",
      "quorumPublicKey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "quorumVvecHash": "0000000000000000000000000000000000000000000000000000000000000000",
      "quorumSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "membersSig": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    }
  ]
}
```

### Quorum Sign

The `quorum sign` RPC requests threshold-signing for a message.

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                      |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---id*

| Name | Type         | Presence                | Description                                                                                                                                                                                                                                                                                                                                           |
| ---- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID. Signing request ids for ChainLocks and InstantSend are calculated as described in:<br> \* The [ChainLocks DIP](https://github.com/dashpay/dips/blob/master/dip-0008.md#signing-attempts)<br> \* The [LLMQ InstantSend DIP](https://github.com/dashpay/dips/blob/master/dip-0010.md#finalization-and-creation-of-islock-messages). |

:::{note}
For general signing requests, any 32 byte hex string can be provided as the request id. Note that if a quorum hash is not specified in parameter 4, a quorum will be selected automatically based in part on this value.
:::

*Parameter #3---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Parameter #4---quorum hash*

| Name         | Type         | Presence             | Description           |
| ------------ | ------------ | -------------------- | --------------------- |
| `quorumHash` | string (hex) | Optional<br>(0 or 1) | The quorum identifier |

*Parameter #5---submit*

| Name     | Type | Presence             | Description                                                                                                                                                                       |
| -------- | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `submit` | bool | Optional<br>(0 or 1) | *Added in Dash Core 0.17.0*<br><br>Submits the signature share to the network if this is `true` (default). Returns an object containing the signature share if this is `false`. |

*Result---(if submit = `true`) status*

| Name   | Type | Presence                | Description                        |
| ------ | ---- | ----------------------- | ---------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on success |

*Result---(if submit = `false`) signature share JSON object*

| Name                | Type         | Presence                | Description                                                                                                                                                                      |
| ------------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| result              | object       | Required<br>(exactly 1) | JSON object containing signature share details                                                                                                                                   |
| →<br>`llmqType`     | number       | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |
| →<br>`quorumHash`   | string (hex) | Required<br>(exactly 1) | The quorum identifier                                                                                                                                                            |
| →<br>`quorumMember` | number       | Required<br>(exactly 1) | Which quorum member created this signature share                                                                                                                                 |
| →<br>`id`           | string (hex) | Required<br>(exactly 1) | Signing request ID                                                                                                                                                               |
| →<br>`msgHash`      | string (hex) | Required<br>(exactly 1) | Hash of the message that was signed                                                                                                                                              |
| →<br>`signHash`     | string (hex) | Required<br>(exactly 1) | Hash of `llmqType`, `quorumHash`, `id`, and `msgHash`                                                                                                                            |
| →<br>`signature`    | string (hex) | Required<br>(exactly 1) | Signature share                                                                                                                                                                  |

*Example from Dash Core 0.17.0*

Submit signature share to network (default):

```bash
dash-cli -testnet quorum sign 1 \
  "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234" \
  "51c11d287dfa85aef3eebb5420834c8e443e01d15c0b0a8e397d67e2e51aa239"
```

Result:

```json
false
```

Return signature share object:

```bash
dash-cli -testnet quorum sign 100 \
  "0000000000000000000000000000000000000000000000000000000000000001" \
  "0000000000000000000000000000000000000000000000000000000000000002" \
  "53d959f609a654cf4e5e3c083fd6c47b7ec6cb73af4ac7329149688337b8ef9a" false
```

Result:

```json
{
  "llmqType": 100,
  "quorumHash": "53d959f609a654cf4e5e3c083fd6c47b7ec6cb73af4ac7329149688337b8ef9a",
  "quorumMember": 2,
  "id": "0000000000000000000000000000000000000000000000000000000000000001",
  "msgHash": "0000000000000000000000000000000000000000000000000000000000000002",
  "signHash": "39458221939396a45a2e348caada646eabd52849990827d40e33eb1399097b3c",
  "signature": "9716545a0c28ff70900a71fabbadf3c13e4ae562032122902405365f1ebf3da813c8a97d765eb8b167ff339c1638550c13822217cf06b609ba6a78f0035684ca7b4afdb7146ce74a30cfb6770f852aade8c27ffec67c79f85be31964573fb51c"
}
```

### Quorum GetData

The [`quorum getdata` RPC](#quorum-getdata) sends a [`qgetdata` message](../reference/p2p-network-quorum-messages.md#qgetdata) to a specified peer, requesting specific quorum-related data from that peer.

_Parameter #1---the internal node ID_

| Name     | Type   | Presence                | Description |
|----------|--------|-------------------------|-------------|
| `nodeId` | number | Required<br>(exactly 1) | The internal nodeId of the peer from which quorum data is requested |

_Parameter #2---the LLMQ type_

| Name      | Type   | Presence                | Description |
|-----------|--------|-------------------------|-------------|
| `llmqType`| number | Required<br>(exactly 1) | The LLMQ type associated with the quorum data being requested    |

_Parameter #3---the quorum hash_

| Name         | Type   | Presence                | Description |
|--------------|--------|-------------------------|-------------|
| `quorumHash` | string | Required<br>(exactly 1) | The quorum hash for the quorum data being requested          |

_Parameter #4---the data mask_

| Name        | Type   | Presence                | Description |
|-------------|--------|-------------------------|-------------|
| `dataMask`  | number | Required<br>(exactly 1) | Specifies the type of data requested. Possible values are:<br>`1` - Quorum verification vector<br>`2` - Encrypted contributions for member specified by `proTxHash` (`proTxHash` must be specified if this option is used)<br>`3` - Both (1 and 2) |

_Parameter #5---the ProTxHash_

| Name       | Type   | Presence                  | Description |
|------------|--------|---------------------------|-------------|
| `proTxHash`| string | Optional<br>(default="") | The ProTxHash for the contributions requested. Must be a member of the specified LLMQ. Cannot be specified if `dataMask` is set to `1`. Required if `dataMask` is set to `2`. |

_Result---execution result_

| Name                | Type            | Presence                | Description |
|---------------------|-----------------|-------------------------|-------------|
| `success`           | bool            | Required<br>(exactly 1) | Displays `true` if the data request was successful or `false` if it failed |

_Example from Dash Core 22.0.0_

Requesting the quorum verification vector from a peer with node ID `12` for a quorum of type `2`:

```bash
dash-cli quorum getdata 1 2 "000000822d2b1b311af360750b6448917f10d8b92d2ea2a7bbae221e859354f9" 1
```

Result:

```text
true
```

_See also_

* [Quorum List](#quorum-list): displays a list of on-chain quorums.

### Quorum GetRecSig

The `quorum getrecsig` RPC gets the recovered signature for a previous threshold-signing message request.

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                      |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---id*

| Name | Type         | Presence                | Description        |
| ---- | ------------ | ----------------------- | ------------------ |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #3---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Result---recovered signature*

| Name              | Type         | Presence                | Description                                                                                                                                                                      |
| ----------------- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| result            | bool         | Required<br>(exactly 1) | Recovered signature details                                                                                                                                                      |
| →<br>`llmqType`   | number       | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |
| →<br>`quorumHash` | string (hex) | Required<br>(exactly 1) | The block hash of the quorum                                                                                                                                                     |
| →<br>`id`         | string (hex) | Required<br>(exactly 1) | The signing session ID                                                                                                                                                           |
| →<br>`msgHash`    | string (hex) | Required<br>(exactly 1) | The message hash                                                                                                                                                                 |
| →<br>`sig`        | string (hex) | Required<br>(exactly 1) | The recovered signature                                                                                                                                                          |
| →<br>`hash`       | string (hex) | Required<br>(exactly 1) | The hash of the recovered signature                                                                                                                                              |

*Example from Dash Core 0.14.0*

```bash
dash-cli -testnet quorum getrecsig 1 \
  "e980ebf295b42f24b03321ffb255818753b2b211e8c46b61c0b6fde91242d12f" \
  "907087d4720850e639b7b5cc41d7a6d020e5a50debb3bc3974f0cb3d7d378ea4"
```

Result:

```json
{
  "llmqType": 1,
  "quorumHash": "00000000008344da08e4d262773ea545472fbf625f78b3ebfe5fc067c33b1d22",
  "id": "e980ebf295b42f24b03321ffb255818753b2b211e8c46b61c0b6fde91242d12f",
  "msgHash": "907087d4720850e639b7b5cc41d7a6d020e5a50debb3bc3974f0cb3d7d378ea4",
  "sig": "1365171c408d686af2ca8f5fae91cdf9cf0b5eec60b0b161b9288a1c68e2cd68f225495a787415c924c5953a6282d131178aa6baf4c2673d19549fc627740cf71d295f8a38b9970525a7f248d54a548e16da285b5c1f3ec0740ad40edbcc8615",
  "hash": "d9b7f7904746fbb3eeaeec36fadc79b351f6a854cd22ee9e607592aee972fcb2"
}
```

### Quorum HasRecSig

The `quorum hasrecsig` RPC checks for a recovered signature for a previous threshold-signing message request.

:::{note}
Used for testing on the RegTest network only.
:::

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                      |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---id*

| Name | Type         | Presence                | Description        |
| ---- | ------------ | ----------------------- | ------------------ |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #3---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Result---status*

| Name   | Type | Presence                | Description                        |
| ------ | ---- | ----------------------- | ---------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on success |

*Example from Dash Core 0.14.0*

```bash
dash-cli -testnet quorum hasrecsig 1 \
  "e980ebf295b42f24b03321ffb255818753b2b211e8c46b61c0b6fde91242d12f" \
  "907087d4720850e639b7b5cc41d7a6d020e5a50debb3bc3974f0cb3d7d378ea4"
```

Result:

```text
true
```

### Quorum IsConflicting

The `quorum isconflicting` RPC checks if there is a conflict for a threshold-signing message request.

:::{note}
Used for testing on the RegTest network only.
:::

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                      |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---id*

| Name | Type         | Presence                | Description        |
| ---- | ------------ | ----------------------- | ------------------ |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #3---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Result---status*

| Name   | Type | Presence                | Description                        |
| ------ | ---- | ----------------------- | ---------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on success |

*Example from Dash Core 0.14.0*

```bash
dash-cli -testnet quorum isconflicting 1 \
  "e980ebf295b42f24b03321ffb255818753b2b211e8c46b61c0b6fde91242d12f" \
  "907087d4720850e639b7b5cc41d7a6d020e5a50debb3bc3974f0cb3d7d378ea4"
```

Result:

```text
false
```

### Quorum MemberOf

The [`quorum` RPC](../api/remote-procedure-calls-evo.md#quorum) checks which quorums the given masternode is a member of.

*Parameter #1---proTxHash*

| Name      | Type   | Presence                | Description                  |
| --------- | ------ | ----------------------- | ---------------------------- |
| proTxHash | string | Required<br>(exactly 1) | ProTxHash of the masternode. |

*Parameter #2---scanQuorumsCount*

| Name             | Type   | Presence | Description                                                                                                     |
| ---------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------- |
| scanQuorumsCount | number | Optional | Number of quorums to scan for. If not specified, the active quorum count for each specific quorum type is used. |

*Result---list of quorums the masternode is a member of*

| Name                     | Type             | Presence                | Description                                                                                  |
| ------------------------ | ---------------- | ----------------------- | -------------------------------------------------------------------------------------------- |
| `result`                 | Array of objects | Required<br>(exactly 1) | Array containing info for quorum's the masternode belongs to                                 |
| →<br>Quorum              | object           | Required<br>(0 or more) | An object describing quorum details                                                          |
| → →<br>`height`          | number           | Required<br>(exactly 1) | Block height of the quorum                                                                   |
| → →<br>`type`            | string           | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md) |
| → →<br>`quorumHash`      | string (hex)     | Required<br>(exactly 1) | The hash of the quorum                                                                       |
| → →<br>`minedBlock`      | string (hex)     | Required<br>(exactly 1) | The hash of the block that established the quorum                                            |
| → →<br>`quorumPublicKey` | string (hex)     | Required<br>(exactly 1) | Quorum public key                                                                            |
| → →<br>`isValidMember`   | bool             | Required<br>(exactly 1) | Indicates if the member is valid                                                             |
| → →<br>`memberIndex`     | number           | Required<br>(exactly 1) | Index of the member within the quorum                                                        |

*Example from Dash Core 0.15.0*

```bash
dash-cli -testnet quorum memberof 1 \
  39c07d2c9c6d0ead56f52726b63c15e295cb5c3ecf7fe1fefcfb23b2e3cfed1f 1
```

Result:

```json
[
  {
    "height": 72000,
    "type": "llmq_400_60",
    "quorumHash": "0000000007697fd69a799bfa26576a177e817bc0e45b9fcfbf48b362b05aeff2",
    "minedBlock": "00000000014d910dca80944b52aa3f522d5604254043b8354d641912aace4343",
    "quorumPublicKey": "03a3fbbe99d80a9be8fc59fd4fe43dfbeba9119b688e97493664716cdf15ae47fad70fea7cb93f20fba10d689f9e3c02",
    "isValidMember": true,
    "memberIndex": 80
  }
]
```

*See also: none*

### Quorum ListExtended

The `quorum listextended` RPC returns an extended list of on-chain quorums.

*Parameter #1---height*

| Name     | Type    | Presence             | Description                                                                     |
| -------- | ------- | -------------------- | ------------------------------------------------------------------------------- |
| `height` | numeric | Optional<br>(0 or 1) | The height index. Will list active quorums at tip if "height" is not specified. |

*Result---list extended*

| Name                      | Type             | Presence                | Description                                                     |
| ------------------------- | ---------------- | ----------------------- | --------------------------------------------------------------- |
| `result`                  | object           | Required<br>(exactly 1) | Object containing an extended list of on-chain quorums          |
| →<br>`quorumName`         | array of objects | Required<br>(exactly 1) | List of quorum details per some quorum type                     |
| →→<br>`xxxx`              | object           | Required<br>(exactly 1) | Quorum hash. Note: most recent quorums come first               |
| →→→<br>`creationHeight`   | numeric          | Required<br>(exactly 1) | Block height where the DKG started                              |
| →→→<br>`quorumIndex`      | numeric          | Required<br>(exactly 1) | Quorum index (applicable only to rotated quorums)               |
| →→→<br>`minedBlockHash`   | string           | Required<br>(exactly 1) | Blockhash where the commitment was mined.                       |
| →→→<br> `numValidMembers` | numeric          | Required<br>(exactly 1) | The total of valid members.                                     |
| →→→<br> `healthRatio`     | numeric          | Required<br>(exactly 1) | The ratio of healthy members to quorum size. Range [0.0 - 1.0]. |

*Example from Dash Core 18.2.0*

```bash
dash-cli quorum listextended 1800330
```

Result:

```
{
  "llmq_60_75": [
    {
      "000000000000003892d192fe4c76865c398b117e6d28f4e5978f5fea07a392a0": {
        "quorumIndex": 0,
        "creationHeight": 1800288,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001e209abbe9ddf3d9d6f413ec76920de87071dd50ea90b38766": {
        "quorumIndex": 1,
        "creationHeight": 1800289,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000019273ab7f86e2a4e52779141a01373909cd058c48c23849bee": {
        "quorumIndex": 2,
        "creationHeight": 1800290,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000022b4e1fba61c99235ae6f233a76dded4c4ddc2919680cb54e8": {
        "quorumIndex": 3,
        "creationHeight": 1800291,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000016c2fe9dc3a0f3f66325351667b42985e46ab15a87dbe64df5": {
        "quorumIndex": 4,
        "creationHeight": 1800292,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002ef4d32dc86ec7cad427bd187991c868fd4cccbf62732cbbfb": {
        "quorumIndex": 5,
        "creationHeight": 1800293,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000d3cdd5dce4bbe7b327112bd5b637f96cb64cf07faedf7833b": {
        "quorumIndex": 6,
        "creationHeight": 1800294,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000022833d76c3ea60bb0f9cec5a9aee66012e3310561e7fff273": {
        "quorumIndex": 7,
        "creationHeight": 1800295,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000da0750d6d6df6c9aff6b1b37333a485c9e2a590943bf3a300": {
        "quorumIndex": 8,
        "creationHeight": 1800296,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000014d22d5fff6cc3645e3144b1831425a3fd19e376b8ae1fd14": {
        "quorumIndex": 9,
        "creationHeight": 1800297,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "0000000000000018193220b520572d4f9a622a6767358b2af5fd721a57dab2f0": {
        "quorumIndex": 10,
        "creationHeight": 1800298,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002a94bbb787ddf45687b5982e894157884067d6c5c8ed721495": {
        "quorumIndex": 11,
        "creationHeight": 1800299,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000ddc0112c3d2c625127ccac4311cb8031759a8238ed9e84d8b": {
        "quorumIndex": 12,
        "creationHeight": 1800300,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "000000000000002bb301832bf8d48ccf67256a7d470cb89348d3fb22bc75467d": {
        "quorumIndex": 13,
        "creationHeight": 1800301,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001439d25b7cec34aabd39454956ca0ef632a33ee1923b63bcb5": {
        "quorumIndex": 14,
        "creationHeight": 1800302,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000016ca53419e336df1f57c22e22e7347eb6ee185911eeb0eadbc": {
        "quorumIndex": 15,
        "creationHeight": 1800303,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "000000000000002f80f43d095ffd11397d69414b72dc3b22ca471ac7a18aa2d0": {
        "quorumIndex": 16,
        "creationHeight": 1800304,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "00000000000000207de79166196c12d914f69fa1c0895b9d51dfc66de1d670e6": {
        "quorumIndex": 17,
        "creationHeight": 1800305,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "0000000000000000d71b16a4160d5c9cc7751593be3c16328ddb2eee95957f13": {
        "quorumIndex": 18,
        "creationHeight": 1800306,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 57,
        "healthRatio": "0.95"
      }
    },
    {
      "0000000000000019530a9727b0a44d5551451a7d78608be53fdedcf3c9d8a443": {
        "quorumIndex": 19,
        "creationHeight": 1800307,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000027f61ba67222e4ab8a0c7713d0d2c38344c1f7159541ae663a": {
        "quorumIndex": 20,
        "creationHeight": 1800308,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000121db16ad865fa36be61404a78bba17e372df7e12597941796": {
        "quorumIndex": 21,
        "creationHeight": 1800309,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "000000000000002c024394c7e0fdc031d7904d538dd6e3688d765dd1dac62172": {
        "quorumIndex": 22,
        "creationHeight": 1800310,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001ca51cd8d63690283d2afa9ccb69e987c146439ecd25e8b8ae": {
        "quorumIndex": 23,
        "creationHeight": 1800311,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000096c70b0cd1fed28e481f1b74076c8591450357fff57a0cd1e": {
        "quorumIndex": 24,
        "creationHeight": 1800312,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000028d654215c87a18e86966d25d3d57a62e02ce5bb8a16407aa9": {
        "quorumIndex": 25,
        "creationHeight": 1800313,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000026116f41a22ef0c5c5442ebbd31e9226ea218ebaf2bef09e68": {
        "quorumIndex": 26,
        "creationHeight": 1800314,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002aa07eb158ab1a70d27a382921de2b940eab09b1d175da58f3": {
        "quorumIndex": 27,
        "creationHeight": 1800315,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000028f04886bb10557f2b62373bbeecc54e40b1306fc2960bf6fc": {
        "quorumIndex": 28,
        "creationHeight": 1800316,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001f57ef24b442689b83f459291f441f63d1d152f18669759bdf": {
        "quorumIndex": 29,
        "creationHeight": 1800317,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 59,
        "healthRatio": "0.98"
      }
    },
    {
      "000000000000000b1243e19772259b34f29a57bc807ebb155fbb68791af37610": {
        "quorumIndex": 30,
        "creationHeight": 1800318,
        "minedBlockHash": "0000000000000046e498ceae65713b6daf142db12ccb012fac488acbfd84aad5",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002c406fb450d718b989b951f3c230839062d929e1af7e3cbaee": {
        "quorumIndex": 31,
        "creationHeight": 1800031,
        "minedBlockHash": "000000000000002c9242df9a454e7e0aad7f7d4bf40c84c7adacc0e99c5d9a80",
        "numValidMembers": 60,
        "healthRatio": "1.00"
      }
    }
  ],
  "llmq_400_60": [
    {
      "000000000000003892d192fe4c76865c398b117e6d28f4e5978f5fea07a392a0": {
        "creationHeight": 1800288,
        "minedBlockHash": "00000000000000121db16ad865fa36be61404a78bba17e372df7e12597941796",
        "numValidMembers": 400,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002a19e055ca3767d6200b5b8a872e978610209721e8520c3916": {
        "creationHeight": 1800000,
        "minedBlockHash": "0000000000000008dcd194b9702bbf8fab74cf150ca6b2ec54377874839a0f60",
        "numValidMembers": 400,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000017e56702f42874c51b1869e5225f50765cabe9f1ee0b33fa5b": {
        "creationHeight": 1799712,
        "minedBlockHash": "0000000000000026f22894d7d24de94e57f2683cefae3c6fdb4e043e26750711",
        "numValidMembers": 399,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001f1672260b4edac3e5f278e55c09dc4d51e93b9a143f4bcc23": {
        "creationHeight": 1799424,
        "minedBlockHash": "000000000000002de4624c6476c3533bace5b8811a9ecf48ddeae624f94214c5",
        "numValidMembers": 400,
        "healthRatio": "1.00"
      }
    }
  ],
  "llmq_400_85": [
    {
      "000000000000002a19e055ca3767d6200b5b8a872e978610209721e8520c3916": {
        "creationHeight": 1800000,
        "minedBlockHash": "0000000000000008dcd194b9702bbf8fab74cf150ca6b2ec54377874839a0f60",
        "numValidMembers": 397,
        "healthRatio": "0.99"
      }
    },
    {
      "000000000000001f1672260b4edac3e5f278e55c09dc4d51e93b9a143f4bcc23": {
        "creationHeight": 1799424,
        "minedBlockHash": "000000000000002de4624c6476c3533bace5b8811a9ecf48ddeae624f94214c5",
        "numValidMembers": 400,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000003972108d2bd0d2e3ef5193b2709ab9f1938d91b446d52bbf1a": {
        "creationHeight": 1798848,
        "minedBlockHash": "00000000000000443ccd4f40d534dbc0031a505becf13ad14d8f3c15534db40d",
        "numValidMembers": 399,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000021318ce8dec7d7239bc4ffb407b51e7f75f89116348ab7f63d": {
        "creationHeight": 1798272,
        "minedBlockHash": "0000000000000025e4189f7d4ece51b344fd50f5660352e15d2af45e2476adde",
        "numValidMembers": 399,
        "healthRatio": "1.00"
      }
    }
  ],
  "llmq_100_67": [
    {
      "00000000000000096c70b0cd1fed28e481f1b74076c8591450357fff57a0cd1e": {
        "creationHeight": 1800312,
        "minedBlockHash": "0000000000000017553cc929c0bcd570b444f5caa46bb1c53ac9b6b4b587a6b1",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000003892d192fe4c76865c398b117e6d28f4e5978f5fea07a392a0": {
        "creationHeight": 1800288,
        "minedBlockHash": "000000000000000ddc0112c3d2c625127ccac4311cb8031759a8238ed9e84d8b",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000023d18e24d490138bc33061fb5d354d6a93b7e8655bb7fb5cd5": {
        "creationHeight": 1800264,
        "minedBlockHash": "000000000000002d698057b2a3424feaba9f5e2d2a3f8e18b0df3eda7a6d7ae1",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001410a901c3afa742d883c9fdabce4bc5ae511e5332b6ba4a2c": {
        "creationHeight": 1800240,
        "minedBlockHash": "000000000000001efdc8e694bd889398686a57859d2063880b9b22ff80e59992",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001e7c54a085503e8d8d50ad7255298a490db86d94d2190025b3": {
        "creationHeight": 1800216,
        "minedBlockHash": "000000000000002bab372f9a27d68cf1f3bf4a2c393d2228b8a60dea0d7069b0",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000012000e6134e98fdae4c5174e29fb4e92b97f72b5b31de8b22e": {
        "creationHeight": 1800192,
        "minedBlockHash": "00000000000000266fd7587535728e4f10a4aabdc6aeddce425166ff62498ee8",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000d7bfac2eb39c8ca7e34e406f10d34309e383bf6cd12955f33": {
        "creationHeight": 1800168,
        "minedBlockHash": "000000000000001ee28ea86d5682ea13ae10cfda81a5ec702def62a7190448fa",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000ec2e9281eb00e49d28794b7aa0e7bc2ca2087446f8bd950d2": {
        "creationHeight": 1800144,
        "minedBlockHash": "000000000000001aa3571b0b3433bf3d40e2f7065c9c62a7016cf9c6cbd1225d",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000df63557d980360d610b802fd3929444cadd2aaf052d11c80c": {
        "creationHeight": 1800120,
        "minedBlockHash": "000000000000000147ecaf84980dcceaee55053536c21c91906e9068641dbb8f",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000014ce6fe9b7c4c4237d21954e9f5bce96b0fa87ed6e780dea10": {
        "creationHeight": 1800096,
        "minedBlockHash": "00000000000000286fc19ecbb6f25c69cba2ceadc9064e5534c4efb252599ad3",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000061da2087af9502da3b7d8a443569b93dbe130e7a5e22bdab1": {
        "creationHeight": 1800072,
        "minedBlockHash": "0000000000000008866e1a7ee16a99c4baf59dd311a041314c9f1a6c2bd99666",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001e63afa146c3b3af04e11b103bf431b6795af6f27fa7e93b27": {
        "creationHeight": 1800048,
        "minedBlockHash": "0000000000000031106ea328f2aa48fd86f689dfb84376e7f3c6f9a71c5ff8e9",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000020d38f6a522b60b098a83ae65f29fc8c0ce998aad9a551117d": {
        "creationHeight": 1800024,
        "minedBlockHash": "0000000000000018c126af1636f8d82fc48bf2f919992d709f423a3d71cfa9ac",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000002a19e055ca3767d6200b5b8a872e978610209721e8520c3916": {
        "creationHeight": 1800000,
        "minedBlockHash": "000000000000000de079e14e271ad9714ff33adc5636922ba943a65e21b90a8a",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000383e3d518a7249e65ab5b642ea01456bd920124ec4985c56a": {
        "creationHeight": 1799976,
        "minedBlockHash": "000000000000002738b4c991238340cfe94e08a5ca88144ffbc90272d0f5c853",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000038267cd98aa082c4e43521edc6feaff53af21a8f134c1ed05f": {
        "creationHeight": 1799952,
        "minedBlockHash": "00000000000000064636f2fc5338f6d34033928614487e055cd3a54e7933b8f9",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000000acb20bef7d6a0a4b4b10a276c64d631d5c86fae05a33dfe0b": {
        "creationHeight": 1799928,
        "minedBlockHash": "0000000000000010fc8ee7e13fc198da76b25c598a59708327f44013e4e78aa0",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000005b452484413d52b186bf8a24174bb83ae673d03c04d9b3cc1": {
        "creationHeight": 1799904,
        "minedBlockHash": "000000000000000cb6c4587f83021b38cab2b1be05248ae8e06525da2078101a",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000013978d488be84a2b1a9a3fd936a1be6a250e4cdd8de0e7318e": {
        "creationHeight": 1799880,
        "minedBlockHash": "0000000000000021d6f2991e2c47875b7aa906a63f78457a1e7ee458962ba65d",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000008cc627164e04430716df733f61dfe01795e78b4bf60051294": {
        "creationHeight": 1799856,
        "minedBlockHash": "0000000000000010a8367e8d02a1774d3c54b075e2016e57ce90ef8a9426fcfa",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000003497f267d65d3a29dc7d79b2925833bc92dbaf5096572427d8": {
        "creationHeight": 1799832,
        "minedBlockHash": "000000000000000374f39b533e45c86ad8109140412b3ac4872f88acb1505799",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "0000000000000008556be7271f9942e38cbfe85ad8423b8c134fe0edbbd2c08e": {
        "creationHeight": 1799808,
        "minedBlockHash": "000000000000002309807a942f1e7ec628e92283df34d67db04e82c5c3907f21",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "00000000000000276299f465ea5ecd680b4f6a6c1cf63a213f4ad98c5974ba4b": {
        "creationHeight": 1799784,
        "minedBlockHash": "00000000000000129cd44a7f7a824116156a325f61a7a69822ebd49c18457d11",
        "numValidMembers": 100,
        "healthRatio": "1.00"
      }
    },
    {
      "000000000000001d6f064000bf1258786d73dc87a8bd2bad3913483ea3b9f3aa": {
        "creationHeight": 1799760,
        "minedBlockHash": "000000000000001b7b5a5653a1ef67ad355321c4f2fccd93f2b4c56605fc2fea",
        "numValidMembers": 99,
        "healthRatio": "0.99"
      }
    }
  ]
}

```

*See also: none*

### Quorum PlatformSign

:::{versionadded} 21.0.0
:::

The `quorum platformsign` RPC requests threshold-signing for a message. It signs messages only for
Platform quorums. It is equivalent to `quorum sign <platform LLMQ type>`.

*Parameter #1---id*

| Name | Type         | Presence                | Description |
| ---- | ------------ | ----------------------- | ----------- |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #2---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Parameter #3---quorum hash*

| Name         | Type         | Presence             | Description           |
| ------------ | ------------ | -------------------- | --------------------- |
| `quorumHash` | string (hex) | Optional<br>(0 or 1) | The quorum identifier |

*Parameter #4---submit*

| Name     | Type | Presence             | Description |
| -------- | ---- | -------------------- | ----------- |
| `submit` | bool | Optional<br>(0 or 1) | Submits the signature share to the network if this is `true` (default). Returns an object containing the signature share if this is `false`. |

*Result---(if submit = `true`) status*

| Name   | Type | Presence                | Description                        |
| ------ | ---- | ----------------------- | ---------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on success |

*Result---(if submit = `false`) signature share JSON object*

| Name                | Type         | Presence                | Description |
| ------------------- | ------------ | ----------------------- | ----------- |
| result              | object       | Required<br>(exactly 1) | JSON object containing signature share details |
| →<br>`llmqType`     | number       | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`4` - LLMQ_100_67 |
| →<br>`quorumHash`   | string (hex) | Required<br>(exactly 1) | The quorum identifier |
| →<br>`quorumMember` | number       | Required<br>(exactly 1) | Which quorum member created this signature share |
| →<br>`id`           | string (hex) | Required<br>(exactly 1) | Signing request ID |
| →<br>`msgHash`      | string (hex) | Required<br>(exactly 1) | Hash of the message that was signed |
| →<br>`signHash`     | string (hex) | Required<br>(exactly 1) | Hash of `llmqType`, `quorumHash`, `id`, and `msgHash` |
| →<br>`signature`    | string (hex) | Required<br>(exactly 1) | Signature share |

*Example from Dash Core 21.0.0*

Submit signature share to network (default):

```bash
dash-cli -testnet quorum platformsign \
  "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234" \
  "51c11d287dfa85aef3eebb5420834c8e443e01d15c0b0a8e397d67e2e51aa239"
```

Result:

```json
false
```

_See also_

* [Quorum Sign](#quorum-sign): requests threshold-signing for a message.
* [Quorum Info](#quorum-info): retrieves information about a specific quorum, including its members and the threshold required for signing.

### Quorum RotationInfo

The `quorum rotationinfo` RPC returns  quorum rotation information. The response is a JSON representation of the data that would be returned in a [`qrinfo` message](../reference/p2p-network-data-messages.md#qrinfo).

*Parameter #1---block request hash*

| Name               | Type         | Presence                | Description                   |
| ------------------ | ------------ | ----------------------- | ----------------------------- |
| `blockRequestHash` | string (hex) | Required<br>(exactly 1) | The block hash of the request |

*Parameter #2---extra share*

| Name         | Type | Presence             | Description                                                                                                           |
| ------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `extraShare` | bool | Optional<br>(0 or 1) | Request an extra share (default: false). This extra share would support validation against the previous set of LLMQs. |

*Parameter #3---base block hashes number*

| Name               | Type         | Presence                | Description                |
| ------------------ | ------------ | ----------------------- | -------------------------- |
| `baseBlockHash...` | string (hex) | Optional<br>(0 or more) | Block hashes (default: "") |

*Result---rotation info*

| Name                            | Type             | Presence                | Description                                                                                                |
| ------------------------------- | ---------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| `result`                        | object           | Required<br>(exactly 1) | Object containing quorum rotation info                                                                     |
| →<br>`extraShare`               | bool             | Required<br>(exactly 1) | Whether or not an extra share is included                                                                  |
| →<br>`quorumSnapshotAtHMinusC`  | object           | Required<br>(exactly 1) | Quorum snapshot at `h-c`                                                                                   |
| →<br>`quorumSnapshotAtHMinus2C` | object           | Required<br>(exactly 1) | Quorum snapshot at `h-2c`                                                                                  |
| →<br>`quorumSnapshotAtHMinus3C` | object           | Required<br>(exactly 1) | Quorum snapshot at `h-3c`                                                                                  |
| →<br>`mnListDiffTip`            | object           | Required<br>(exactly 1) | Masternode list diff for the tip                                                                           |
| →<br>`mnListDiffH`              | object           | Required<br>(exactly 1) | Masternode list diff for `h`                                                                               |
| →<br>`mnListDiffAtHMinusC`      | object           | Required<br>(exactly 1) | Masternode list diff for `h-c`                                                                             |
| →<br>`mnListDiffAtHMinus2C`     | object           | Required<br>(exactly 1) | Masternode list diff for `h-2c`                                                                            |
| →<br>`mnListDiffAtHMinus3C`     | object           | Required<br>(exactly 1) | Masternode list diff for `h-3c`                                                                            |
| →<br>`blockHashList`            | array            | Required<br>(exactly 1) | Array of block hashes. Returns the last successfully mined quorum per quorumIndex until `blockRequestHash` |
| →<br>`quorumSnapshotList`       | array of objects | Required<br>(exactly 1) | Array of quorum snapshot list objects                                                                      |
| →<br>`mnListDiffList`           | array of objects | Required<br>(exactly 1) | Array of masternode list diff objects                                                                      |

*Example from Dash Core 18.0.0*

```bash
dash-cli -testnet quorum rotationinfo 000001e1ef5f2e2bbc3de3b8b3c554e756ef2b7dcd1eb7552ff48fe319caff4b
```

Result (truncated):

```json
{
  "extraShare": false,
  "quorumSnapshotAtHMinusC": {
    "activeQuorumMembers": [
      true,
      false,
      // Content truncated
    ],
    "mnSkipListMode": 1,
    "mnSkipList": [
      7,
      1,
      6,
      7
    ]
  },
  "quorumSnapshotAtHMinus2C": {
    "activeQuorumMembers": [
      true,
      true,
      // Content truncated
    ],
    "mnSkipListMode": 1,
    "mnSkipList": [
      5,
      4,
      6,
      9
    ]
  },
  "quorumSnapshotAtHMinus3C": {
    "activeQuorumMembers": [
      true,
      true,
      // Content truncated
    ],
    "mnSkipListMode": 1,
    "mnSkipList": [
      4,
      3,
      7
    ]
  },
  "mnListDiffTip": {
    "baseBlockHash": "000008ca1832a4baf228eb1553c03d3a2c8e02399550dd6ea8d65cec3ef23d2e",
    "blockHash": "000001f10408e797a2b8f5dd8a7e5835b7b54c82bf4c7d913bb60a028cb64acb",
    "cbTxMerkleTree": "0100000001e862054f249eb3f84689d7bf5f42e89b1e540bd19feb5d656616e967c61837800101",
    "cbTx": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff050289070101ffffffff0200c817a8040000001976a914c0aa7affe002c1189d021ea819c2160f7100ef0288ac00ac23fc060000001976a914c0aa7affe002c1189d021ea819c2160f7100ef0288ac0000000046020089070000a0b1aca79a7d78ab800b5146a095e22033513ea6019164b0e46412e953400dd33953a26d62bed490814a65a7e9184094d0294d53676bf08272cc339f2cd41214",
    "deletedMNs": [
    ],
    "mnList": [
      {
        "proRegTxHash": "ef99baa5848b2e2d012db5b0c17958e4ef6578c2c31a60f8cc12225168014ba1",
        "confirmedHash": "000001d855b97191009c5ef8f915895ca2d51105c12df1671cb5faedbbb0f7ef",
        "service": "34.220.68.124:20001",
        "pubKeyOperator": "04bfadc894a7855412800db1941efc5284c0e19dd21512067e01bed98bfd939201e8bffd5de039177ef4ec15aa4c0bd5",
        "votingAddress": "yMPLoqwqfnsTdQTTzcmont2HRkQyUewram",
        "isValid": true
      },
      // Content truncated
    ],
    "deletedQuorums": [
    ],
    "newQuorums": [
      {
        "version": 2,
        "llmqType": 101,
        "quorumHash": "0000021a5928d86124863b0ad62585a6115b354424685c0ecc8adb00f29dd157",
        "quorumIndex": 3,
        "signersCount": 12,
        "signers": "ff0f",
        "validMembersCount": 12,
        "validMembers": "ff0f",
        "quorumPublicKey": "1252d661adab4e272767caa002e3fa1fa99ae95a8f2b75fa3f217801073032da15d3a21a19e6f1a3e1f09212cf87f8ae",
        "quorumVvecHash": "a8719a7be6b82bd052c99bc89a8e1ad831a2d33b2440f5a1cfe66d4be1f6ee8e",
        "quorumSig": "022288b10b1d94457de8312a884d520cf50058675c7f527a50629e27fd191142be594101213402b56f7a7e0736f71b70046c92bc4ad81a08cfecd7f3dbdecaf7050479f0227099c74f0be5ef302dd626701a1359075187fe799033619f6c8bf9",
        "membersSig": "8ef10d202123e5fea80c8c0cd0ad8c4094b605cb977a1e3f9205f7f08fe1da2f1b4c2fa1dcc147ef55eee1bd24bd783513941ae485425400743edc3f2bceaa83b6424e3aa7d4578864a962a2a37066dac4c09ae4fde4569225edec3476b153eb"
      },
      // Content truncated
    ],
    "merkleRootMNList": "d30d4053e91264e4b0649101a63e513320e295a046510b80ab787d9aa7acb1a0",
    "merkleRootQuorums": "1412d42c9f33cc7282f06b67534d29d0944018e9a7654a8190d4be626da25339"
  },
  "mnListDiffH": {}, // Content truncated
  "mnListDiffAtHMinusC": {}, // Content truncated
  "mnListDiffAtHMinus2C": {}, // Content truncated
  "mnListDiffAtHMinus3C": {}, // Content truncated
  "blockHashList": [
    "000000956145f9b48231bbb2a7acd54301823f5619854df4487879dff18f2d79",
    "0000002cc74d9300f5d8a5436cfaead69fd1aaf3d68a00e57bd89e878a76a841",
    "0000002911d8f6c21571280953e9e581a6996822fab82adfb766c44e49d050e4",
    "00000064edcdaea4f2962b3a7bf40bcb0aa8ee00a73da86c6bf80ef7c90af0ce"
  ],
  "quorumSnapshotList": [
    {
      "activeQuorumMembers": [
        true,
        true,
        // Content truncated
      ],
      "mnSkipListMode": 1,
      "mnSkipList": [
        9,
        1,
        3
      ]
    }
  ],
  "mnListDiffList": [
    {
      "baseBlockHash": "000008ca1832a4baf228eb1553c03d3a2c8e02399550dd6ea8d65cec3ef23d2e",
      "blockHash": "000001a6c183a9ec58e1130f3c745dd7729a793974e7d97a10b2a3cb20e42a0a",
      "cbTxMerkleTree": "010000000178e366554c6cfc0999d1991ba439d4c3b5f62b36f3f4f73c40f6d716f4a55d1a0101",
      "cbTx": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff0502c0060101ffffffff0200c817a8040000001976a914c0aa7affe002c1189d021ea819c2160f7100ef0288ac00ac23fc060000001976a914c0aa7affe002c1189d021ea819c2160f7100ef0288ac00000000460200c0060000a0b1aca79a7d78ab800b5146a095e22033513ea6019164b0e46412e953400dd3dc1437d53f3dcdb89ea5503743ea6ba4eba87c8fb2f47d8e12ea07acc1e39692",
      "deletedMNs": [
      ],
      "mnList": [], // Content truncated
      "deletedQuorums": [
      ],
      "newQuorums": [
        {
          "version": 2,
          "llmqType": 101,
          "quorumHash": "000002132c42566f37b89e90ae92277db8a89fa49bfbd1b2a638f9d10d92e219",
          "quorumIndex": 3,
          "signersCount": 12,
          "signers": "ff0f",
          "validMembersCount": 12,
          "validMembers": "ff0f",
          "quorumPublicKey": "920379ef7f296d9f8c5826c73ad78d026b4bb1dca97c83fb6c4bde23094482be631e375664a65eabd79138ed529e467c",
          "quorumVvecHash": "670e3972eb4f0b42f944fd1c333808ae93d66748f9876e42e91fe503f5dab3b7",
          "quorumSig": "151ee55b5ad68308d0a16ac47b237a6434bf205d80ffe4cbc5a0b84a70401d863cab7137c40edce2a6b92cd09f07c9ac18fd66c45a7077369f9dfc100ea2e5b5a49549e933ce4dafa8a9cbdb718de945fb805a5eb0c3f02c7159a5db6549a4e8",
          "membersSig": "10745b04fa0c164e99b75ff8641c32282468daf928a393f8f98de58b24cffff0faab999b5ffebbb2d804aa6367ca52270ff669041175f6743af534127259b6984fbaae935bd6929e810acb1424b67e4a7af90c64bae477accc88a85ebf3d3891"
        },
        // Content truncated
     ],
      "merkleRootMNList": "d30d4053e91264e4b0649101a63e513320e295a046510b80ab787d9aa7acb1a0",
      "merkleRootQuorums": "9296e3c1ac07ea128e7df4b28f7ca8eba46bea433750a59eb8cd3d3fd53714dc"
    }
  ]
}
```

### Quorum SelectQuorum

The `quorum selectquorum` RPC returns information about the quorum that would/should sign a request.

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                               |
| ---------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorums](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md) to list:<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---request id*

| Name | Type         | Presence                | Description    |
| ---- | ------------ | ----------------------- | -------------- |
| `id` | string (hex) | Required<br>(exactly 1) | The request ID |

*Result---quorum hash and list of quorum members*

| Name                    | Type             | Presence                | Description                                                   |
| ----------------------- | ---------------- | ----------------------- | ------------------------------------------------------------- |
| `result`                | Array of objects | Required<br>(exactly 1) | Array containing info for quorum's the masternode belongs to  |
| →<br>`quorumHash`       | string (hex)     | Required<br>(exactly 1) | The hash of the quorum                                        |
| →→<br>`recoveryMembers` | array            | Required<br>(exactly 1) | Array containing ProRegTx hashes                              |
| →→→<br>ProRegTx Hash    | string (hex)     | Required<br>(exactly 1) | The hash of the provider transaction as hex in RPC byte order |

*Example from Dash Core 0.16.0*

```bash
dash-cli -testnet quorum selectquorum 1 \
  b95205c3bba72e9edfbe7380ec91fe5a97e16a189e28f39b03c6822757ad1a34
```

Result:

```json
{
  "quorumHash": "00000ba8932486c66ed0742fd6b0f4e65afc75ab1e7886c6ef84580dfb7da34f",
  "recoveryMembers": [
    "0130c115522681b87082db1f45c38423d1a018a8e1559c2491103931e891c220",
    "dcd5dd71c4bd50c76d428f72b4a5731bd819720fbc656fff717548e2fe8cbd09",
    "a25c2f4549da0135411122ee9c2d37e8375577dc97431a282a5c374b4c71463a",
    "a1aaa653e5183d6a4525abfd0a76fc7d6a68393a1c4259117028dfce4fd215e1",
    "4c9eb7849590cca2aa18bf9aeeb1e4196c833740de2b111a7690eb62319b0735",
    "f38b8c5cb6c9e712aeeb150b9591cbdc70e99f9f26c1516955dd506b20dd9876",
    "afe12673c32de351e9f5a29178cd55656f03e64357be872536eb50b059032fe0",
    "651d56765c77b8c16b829a4a68f6d39cab40c913d0d365d7b7fd254ccc6cb2f1",
    "f88d0e5349d0bf7e4426a7461d7931d09f54c13edb6d83306c2521d19eb0b14b",
    "bdba1f169ab1e73c4dc96f4133b337c36907976e26a4612ffa5ae18869eba96c",
    "94044c070f9ce6bdd05c2b655ad2383c8402a74c10e0a9a3099d759b33cb7630",
    "515f77efd5983a765dc5740b0e0d3fae6e867917ca384467b24e31dda68c7369",
    "d1ebecfb816f5b4b5f34c91c0aab9c1b643c8567473e6ee35e02e01c9f2304c0",
    "2755d546b114aaec98589cf5b946e408a8996e4837234d2eee97e1da8c71e9ce",
    "b04b5240a8fc5ae62865dfa2e2558894f4b53d82fe88771e5345407b560d59bc",
    "53750150229202353bfbc3a2c866b993dd33a4c749d8f18ddcb1f5caf7e901ef",
    "7a5d1e05d4772feede8b9e71e17e013f99e77c622f13897b8a96339d6d06e1fc",
    "24f6fae5b5afd001d1046425f38e6ef523140afafc83013468bd31feb343f307",
    "18f2e176adf88043c41b406d0c97a2dd529d5daaca8b8ac49f72e6da30334926",
    "73191708ab5b21cc7ede9b12bc1e79de97ad5c4b9717a4fbf5de0ed1f3a5836a",
    "b57da176c0b6deae786afd318a8e00e351bed0f47ceac28f5b6d3d502f1c68d7",
    "161b2dcf8243162d11065eefd0948cb79d96dfa8ae869e34763a2bbd7d1d5d55",
    "fac81f18b3a968f5f881324d8eb38983f3f892c4999c2f46809c4de620b784d2",
    "42267d2c50a68350c880a488ec25ba0eac4e7cd436eb97c686fe0a6d035d25d3",
    "0be00b051c77fd4b6dac46a63b939f73726dc61dd80616e4573a9465f1aafa93"
  ]
}

```

*See also: none*

### Quorum Verify

The `quorum verify` RPC tests if a quorum signature is valid for a request id and a message hash.

*Parameter #1---LLMQ Type*

| Name       | Type   | Presence                | Description                                                                                                                                                                      |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `llmqType` | number | Required<br>(exactly 1) | [Type of quorum](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md):<br>`1` - LLMQ_50_60<br>`2` - LLMQ_400_60<br>`3` - LLMQ_400_85<br>`4` - LLMQ_100_67 |

*Parameter #2---id*

| Name | Type         | Presence                | Description        |
| ---- | ------------ | ----------------------- | ------------------ |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #3---message hash*

| Name      | Type         | Presence                | Description                      |
| --------- | ------------ | ----------------------- | -------------------------------- |
| `msgHash` | string (hex) | Required<br>(exactly 1) | Hash of the message to be signed |

*Parameter #4---signature*

| Name        | Type         | Presence                | Description                |
| ----------- | ------------ | ----------------------- | -------------------------- |
| `signature` | string (hex) | Required<br>(exactly 1) | Quorum signature to verify |

*Parameter #5---quorum hash*

| Name         | Type         | Presence             | Description                                                                     |
| ------------ | ------------ | -------------------- | ------------------------------------------------------------------------------- |
| `quorumHash` | string (hex) | Optional<br>(0 or 1) | The quorum identifier. Set to `""` if you want to specify `signHeight` instead. |

*Parameter #6---sign height*

| Name         | Type   | Presence             | Description                                                                       |
| ------------ | ------ | -------------------- | --------------------------------------------------------------------------------- |
| `signHeight` | number | Optional<br>(0 or 1) | The height at which the message was signed. Only works when `quorumHash` is `""`. |

*Result---status*

| Name   | Type | Presence                | Description                                     |
| ------ | ---- | ----------------------- | ----------------------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on verification success |

*Example from Dash Core 0.17.0*

Verify the provided signature was valid:

```bash
dash-cli -testnet quorum verify 1 \
  "2ceeaa7ff20de327ef65b14de692199d15b67b9458d0ded7d68735cce98dd039" \
  "8b5174d0e95b5642ebec23c3fe8f0bbf8f6993502f4210322871bba0e818ff3b" \
  "99cf2a0deb08286a2d1ffdd2564b35522fd748c8802e561abed330dea20df5cb5a5dffeddbe627ea32cb36de13d5b4a516fdfaebae9886b2f7969a5d112416cf8d1983ebcbf1463a64f7522505627e08b9c76c036616fbb1649271a2773a1653" \
  "000000583a348d1a0a5f753ef98e6a69f9bcd9b27919f10eb1a1c3edb6c79182"
```

Result:

```json
true
```

## SubmitChainlock

The [`submitchainlock` RPC](../api/remote-procedure-calls-evo.md#submitchainlock) is used to submit a ChainLock signature if the node does not yet have it.

*Parameters*

| Name      | Type   | Presence | Description |
| --------- | ------ | -------- | ----------- |
| blockHash | string | Required | The block hash of the ChainLock |
| signature | string | Required | The signature of the ChainLock |
| blockHeight | numeric | Required | The height of the ChainLock |

*Result---The height of the current best ChainLock*

| Name   | Type    | Presence                | Description |
| ------ | ------- | ----------------------- | ----------- |
| Result | numeric | Required (Exactly 1)    | The height of the current best ChainLock. If an error occurs, `-1` is returned. |

*Example from Dash Core 20.1.0*

```bash
dash-cli submitchainlock "000000f7e552718cf326024ba0b0110695300b730873de1942a4106b665fc034" "3045022100a59e3b0f..." 964445
```

Result:

```text
964445
```

*See also: none*

## VerifyChainLock

The `verifychainlock` RPC tests if a quorum signature is valid for a ChainLock.

*Parameter #1---block hash*

| Name        | Type         | Presence                | Description                     |
| ----------- | ------------ | ----------------------- | ------------------------------- |
| `blockhash` | string (hex) | Required<br>(exactly 1) | The block hash of the ChainLock |

*Parameter #2---signature*

| Name        | Type         | Presence                | Description                       |
| ----------- | ------------ | ----------------------- | --------------------------------- |
| `signature` | string (hex) | Required<br>(exactly 1) | The ChainLock signature to verify |

*Parameter #3---block height*

| Name          | Type   | Presence             | Description                                                                                           |
| ------------- | ------ | -------------------- | ----------------------------------------------------------------------------------------------------- |
| `blockHeight` | number | Optional<br>(0 or 1) | The height of the ChainLock. There will be an internal lookup of `blockHash` if this is not provided. |

*Result---status*

| Name   | Type | Presence                | Description                                     |
| ------ | ---- | ----------------------- | ----------------------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on verification success |

*Example from Dash Core 0.17.0*

Verify the provided signature was valid:

```bash
dash-cli -testnet verifychainlock \
  "00000036d5c520be6e9a32d3829efc983a7b5e88052bf138f80a2b3988689a24" \
  "97ec34efd1615b84af62495e54024880752f57790cf450ae974b80002440963592d96826e24f109e6c149411b70bb9a0035443752368590adae60365cf4251464e0423c1263e9c56a33eae9be9e9c79a117151b2173bcee93497008cace8d793"
```

Result:

```json
true
```

## VerifyISLock

The `verifyislock` RPC tests if a quorum signature is valid for an InstantSend Lock.

*Parameter #1---id*

| Name | Type         | Presence                | Description        |
| ---- | ------------ | ----------------------- | ------------------ |
| `id` | string (hex) | Required<br>(exactly 1) | Signing request ID |

*Parameter #2---transaction id*

| Name   | Type         | Presence                | Description               |
| ------ | ------------ | ----------------------- | ------------------------- |
| `txid` | string (hex) | Required<br>(exactly 1) | The transaction id (TXID) |

*Parameter #3---signature*

| Name        | Type         | Presence                | Description                              |
| ----------- | ------------ | ----------------------- | ---------------------------------------- |
| `signature` | string (hex) | Required<br>(exactly 1) | The InstantSend Lock signature to verify |

*Parameter #4---maximum height*

| Name        | Type   | Presence             | Description                               |
| ----------- | ------ | -------------------- | ----------------------------------------- |
| `maxHeight` | number | Optional<br>(0 or 1) | The maximum height to search quorums from |

*Result---status*

| Name   | Type | Presence                | Description                                     |
| ------ | ---- | ----------------------- | ----------------------------------------------- |
| result | bool | Required<br>(exactly 1) | True or false depending on verification success |

*Example from Dash Core 20.0.0*

Verify the provided signature was valid:

```bash
dash-cli -testnet verifyislock \
  "e5affbbb07084f15ff86bc5043978360a22c8bbacc10a09b973da2cfc32a0115" \
  "17e3d624ca71f06d91e35c01b0933ec7a34fd18a3700c4c3cbc947b59e91c6b2" \
  "b36f68abbb15be1948b0b55d392420b9fcc208361037f6dbbb7552f1fda9bae50800df265b037273f8ad310f0ec3af011166ba61002ac30dececee4e46d4e28de8553515cfdfa40fd04e7e3bf4932049f8b670e908b7b9a2bb69d5c1c59dd7f4"
```

Result:

```json
true
```
