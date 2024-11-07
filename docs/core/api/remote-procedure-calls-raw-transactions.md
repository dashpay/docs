```{eval-rst}
.. meta::
  :title: Raw Transaction RPCs
  :description: A list of remote procedure calls in Dash Core that are used to work with raw transactions and partially signed transactions (PSBT).
```

# Raw Transactions

## AnalyzePSBT

The analyzepsbt RPC analyzes and provides information about the current status of a PSBT and its inputs.

_Parameter #1---psbt_

| Name   | Type   | Presence                | Description                                     |
| ------ | ------ | ----------------------- | ----------------------------------------------- |
| `psbt` | string | Required<br>(Exactly 1) | The base64-encoded partially signed transaction |

_Result:_

| Name                         | Type    | Presence                 | Description                                                                                                              |
| ---------------------------- | ------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `result`                     | object  | Required<br>(exactly 1)  | A JSON object                                                                                                            |
| → `inputs`                   | array   | Required<br>(exactly 1 ) | An array that contains main details about the PSBT.                                                                      |
| →→`has_utxo`                 | boolean | Required (exactly 1)     | Whether a UTXO is provided                                                                                               |
| →→`is_final`                 | boolean | Required (exactly 1)     | Whether the input is finalized                                                                                           |
| →→`missing`                  | object  | Optional (0 or 1)        | A JSON object that includes the data missing to complete the input.                                                      |
| →→→`pubkeys`                 | array   | Optional (0 or 1)        | Array containing public key data.                                                                                        |
| →→→→`hex`                    | string  | Required<br>(0 or more)  | Public key ID, hash160 of the public key, of a public key whose BIP 32 derivation path is missing.                       |
| →→→`signatures`              | array   | Optional (0 or 1)        | Array containing public key data                                                                                         |
| →→→→`hex`                    | string  | Required<br>(0 or more)  | Public key ID, hash160 of the public key, of a public key whose signature is missing.                                    |
| →→→ `"redeemscript" : "hex"` | string  | Optional<br>(0 or 1)     | Hash160 of the redeemScript that is missing.                                                                             |
| →→ `"next" : "str"`          | string  | Optional<br>(0 or 1)     | Role of the next person that this input needs to go to                                                                   |
| → `estimated_vsize`          | numeric | Optional (0 or 1)        | Estimated vsize of the final signed transaction                                                                          |
| → `estimated_feerate`        | numeric | Optional (0 or 1)        | Estimated feerate of the final signed transaction in DASH/kB. Shown only if all UTXO slots in the PSBT have been filled. |
| → `fee`                      | numeric | Optional (0 or 1)        | The transaction fee paid. Shown only if all UTXO slots in the PSBT have been filled.                                     |
| → `"next" : "str"`           | string  | Required<br>(exactly 1)  | Role of the next person that this psbt needs to go to                                                                    |
| → `"error" : "str"`          | string  | Required<br>(exactly 1)  | Error message if there is one                                                                                            |

_Example from Dash Core 18.2.0_

```bash
dash-cli -testnet analyzepsbt cHNidP8BAHcCAAAAAWtJCIbAGYsCjGxcsUXE6zsQVaIkp6EFqt7/QbaeyR4GAQAAAAD/////AgAgX6ASAAAAGXapFEhUhUJfqZUE7BY4rEIT88/J8y7ziKzAqPm+AQAAABl2qRSBHqzBTbjrtbZEhtxDQAwCJrQopIisAAAAAAAAAAA=
```

Result:

```
{
  "inputs": [
    {
      "has_utxo": false,
      "is_final": false,
      "next": "updater"
    }
  ],
  "next": "updater"
}
```

_See also:_

* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combines multiple partially-signed Dash transactions into one transaction.
* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## CombinePSBT

The [`combinepsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#combinepsbt) combines multiple partially-signed Dash transactions into one transaction. Implements the Combiner role. This should be used only with `createrawtransaction` and `fundrawtransaction`. `createpsbt` and `walletcreatefundedpsbt` should be used for new applications.

_Parameter #1---txs_

| Name         | Type   | Presence                | Description                                                 |
| ------------ | ------ | ----------------------- | ----------------------------------------------------------- |
| Transactions | string | Required<br>(exactly 1) | An array of base64 strings of partially signed transactions |
| → psbt       | string | Required<br>(exactly 1) | A base64 string of a PSBT                                   |

_Result---psbt_

| Name     | Type   | Presence                | Description                                     |
| -------- | ------ | ----------------------- | ----------------------------------------------- |
| `result` | string | Required<br>(Exactly 1) | The base64-encoded partially signed transaction |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet combinepsbt '["cHNidP8BAFUCAAAAAQcxBA7Cdee2EvS1IyiRPzCVxbt9wFnrqry3AMUBOYvqAAAAAAD/////AQDh9QUAAAAAGXapFLBKVDBt/eE2UU3EUaAiMeuIUMC1iKwAAAAAAAEA3wIAAAAB9LcsqdmAuKwHgkt0HMpJuSx8RnBxL73+ORGz4ogdt+gBAAAAakcwRAIgJR7zIP4o/GRTAyvswKmdFDx+PBO/tB24s0ydQcRpOZECIAvm3Q2xMIpdAAhl17yQAkQjElRbZEIbcr7pGCpNbzqsASEDIcX0+C0b8ib3pvxlx809S7xOmAj0NH3i9vFe8pUTvHX+////AgBlzR0AAAAAF6kUJOSskBQ3xyDtInRjI2eW1QraJ9eHIcmaOwAAAAAZdqkUPU2zmkAo79MmS8yW1oYUjb7jz0qIrOosCQAiAgN+48COTyy1UqO7c63g5A9YEMnBIiYF+FcREEaGgxAHukcwRAIgfwcMEFPrmy81y5NWFj8M0CHUBlzzQxr4RoxSmzvmVIQCIH22f9/A/K0keQ7rKcya0E5zTlnYDnly8VJIrj2yUgflAQEER1IhA37jwI5PLLVSo7tzreDkD1gQycEiJgX4VxEQRoaDEAe6IQK1B5TV+2qTmU+/c3Pzl61bklYbfj9yg+jbdGyMoKE/vFKuAAA=", "cHNidP8BAFUCAAAAAQcxBA7Cdee2EvS1IyiRPzCVxbt9wFnrqry3AMUBOYvqAAAAAAD/////AQDh9QUAAAAAGXapFLBKVDBt/eE2UU3EUaAiMeuIUMC1iKwAAAAAAAEA3wIAAAAB9LcsqdmAuKwHgkt0HMpJuSx8RnBxL73+ORGz4ogdt+gBAAAAakcwRAIgJR7zIP4o/GRTAyvswKmdFDx+PBO/tB24s0ydQcRpOZECIAvm3Q2xMIpdAAhl17yQAkQjElRbZEIbcr7pGCpNbzqsASEDIcX0+C0b8ib3pvxlx809S7xOmAj0NH3i9vFe8pUTvHX+////AgBlzR0AAAAAF6kUJOSskBQ3xyDtInRjI2eW1QraJ9eHIcmaOwAAAAAZdqkUPU2zmkAo79MmS8yW1oYUjb7jz0qIrOosCQAiAgK1B5TV+2qTmU+/c3Pzl61bklYbfj9yg+jbdGyMoKE/vEcwRAIgP3PuTCqVSU0Cx5UDknTwmAFJ6N80sV+YiUmy392/4BUCIEB6QOZe3SJeJ3OVmBCmoEPWcHqbstIvxhCxJ2h+fkSZAQEER1IhA37jwI5PLLVSo7tzreDkD1gQycEiJgX4VxEQRoaDEAe6IQK1B5TV+2qTmU+/c3Pzl61bklYbfj9yg+jbdGyMoKE/vFKuAAA="]'
```

Result:

```
cHNidP8BAFUCAAAAAQcxBA7Cdee2EvS1IyiRPzCVxbt9wFnrqry3AMUBOYvqAAAAAAD/////AQDh9QUAAAAAGXapFLBKVDBt/eE2UU3EUaAiMeuIUMC1iKwAAAAAAAEA3wIAAAAB9LcsqdmAuKwHgkt0HMpJuSx8RnBxL73+ORGz4ogdt+gBAAAAakcwRAIgJR7zIP4o/GRTAyvswKmdFDx+PBO/tB24s0ydQcRpOZECIAvm3Q2xMIpdAAhl17yQAkQjElRbZEIbcr7pGCpNbzqsASEDIcX0+C0b8ib3pvxlx809S7xOmAj0NH3i9vFe8pUTvHX+////AgBlzR0AAAAAF6kUJOSskBQ3xyDtInRjI2eW1QraJ9eHIcmaOwAAAAAZdqkUPU2zmkAo79MmS8yW1oYUjb7jz0qIrOosCQAiAgN+48COTyy1UqO7c63g5A9YEMnBIiYF+FcREEaGgxAHukcwRAIgfwcMEFPrmy81y5NWFj8M0CHUBlzzQxr4RoxSmzvmVIQCIH22f9/A/K0keQ7rKcya0E5zTlnYDnly8VJIrj2yUgflASICArUHlNX7apOZT79zc/OXrVuSVht+P3KD6Nt0bIygoT+8RzBEAiA/c+5MKpVJTQLHlQOSdPCYAUno3zSxX5iJSbLf3b/gFQIgQHpA5l7dIl4nc5WYEKagQ9Zwepuy0i/GELEnaH5+RJkBAQRHUiEDfuPAjk8stVKju3Ot4OQPWBDJwSImBfhXERBGhoMQB7ohArUHlNX7apOZT79zc/OXrVuSVht+P3KD6Nt0bIygoT+8Uq4AAA==
```

_See also:_

* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## CombineRawTransaction

The [`combinerawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction) combine multiple partially signed transactions into one transaction.

The combined transaction may be another partially signed transaction or a fully signed transaction.

_Parameter #1---txs_

| Name | Type   | Presence | Description                                                  |
| ---- | ------ | -------- | ------------------------------------------------------------ |
| txs  | string | Required | A json array of hex strings of partially signed transactions |

_Result---hex-encoded raw transaction with signature(s)_

| Name     | Type   | Presence                | Description                                                                    |
| -------- | ------ | ----------------------- | ------------------------------------------------------------------------------ |
| `result` | string | Required<br>(Exactly 1) | The resulting raw transaction in serialized transaction format encoded as hex. |

_Example from Dash Core 0.15.0_

The following example shows a fully signed two input transaction being assembled  
by combining two partially signed transactions. The first hex-encoded string is  
the transaction with only the first input signed. The second hex-encoded string is  
the transaction with only the second input signed.

```bash
dash-cli -testnet combinerawtransaction '[
 "0200000002fdb27b4f2b80a5fd3b96602618a6ccf7bdde504bf90989610b19ed6ecd769520010000006b483045022100f8770316327966fb1972338d14db8d38048455da8b62f6350b117c797cea459e02206c63c103cf53ce1d24a313b3e6853913fa14febafd733e683b6eb46a7beec0fa012103c67d86944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9ffffffff0d052e9b13c53bb342d772767732ffe4fa9f1c150629d3fa79655267baa7c86a0100000000ffffffff0200ca9a3b000000001976a9144139b147b5cef5fef5bcdb02fcdf55e426f74dbb88ac00daf89a000000001976a91465f53f2095c99ce152ff3bc8a8f027d8a77cbdcb88ac00000000",
 "0200000002fdb27b4f2b80a5fd3b96602618a6ccf7bdde504bf90989610b19ed6ecd7695200100000000ffffffff0d052e9b13c53bb342d772767732ffe4fa9f1c150629d3fa79655267baa7c86a010000006b4830450221008c3abc11ea84cc98cf674afc5b6d3d078d672768d289f2ab976ea4b2a49129fc022008470458b1b179800e7f5348196d510d2f147e69fe836c94135fc5c620312acd012102912ba98d6641f79864d04d41523167f5db267e45d1633e9243a0be7efb675719ffffffff0200ca9a3b000000001976a9144139b147b5cef5fef5bcdb02fcdf55e426f74dbb88ac00daf89a000000001976a91465f53f2095c99ce152ff3bc8a8f027d8a77cbdcb88ac00000000"
]'
```

Result:

```bash
0200000002fdb27b4f2b80a5fd3b96602618a6ccf7bdde504bf90989610b19ed6ecd7695\
20010000006b483045022100f8770316327966fb1972338d14db8d38048455da8b62f635\
0b117c797cea459e02206c63c103cf53ce1d24a313b3e6853913fa14febafd733e683b6e\
b46a7beec0fa012103c67d86944315838aea7ec80d390b5d09b91b62483370d4979da5cc\
f7a7df77a9ffffffff0d052e9b13c53bb342d772767732ffe4fa9f1c150629d3fa796552\
67baa7c86a010000006b4830450221008c3abc11ea84cc98cf674afc5b6d3d078d672768\
d289f2ab976ea4b2a49129fc022008470458b1b179800e7f5348196d510d2f147e69fe83\
6c94135fc5c620312acd012102912ba98d6641f79864d04d41523167f5db267e45d1633e\
9243a0be7efb675719ffffffff0200ca9a3b000000001976a9144139b147b5cef5fef5bc\
db02fcdf55e426f74dbb88ac00daf89a000000001976a91465f53f2095c99ce152ff3bc8\
a8f027d8a77cbdcb88ac00000000
```

_See also:_

* [AnalyzePSBT](../api/remote-procedure-calls-raw-transactions.md#analyzepsbt): analyzes and provides information about the current status of a PSBT and its inputs.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.
* [Serialized Transaction Format](../reference/transactions-raw-transaction-format.md)

## ConvertToPSBT

The [`converttopsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#converttopsbt) converts a network serialized transaction to a PSBT. This should be used only with `createrawtransaction` and `fundrawtransaction`. `createpsbt` and `walletcreatefundedpsbt` should be used for new applications.

_Parameter #1---hexstring_

| Name | Type   | Presence | Description                         |
| ---- | ------ | -------- | ----------------------------------- |
| hex  | string | Required | The hex string of a raw transaction |

_Parameter #2---permitsigdata_

| Name | Type | Presence | Description                                                                                                                                 |
| ---- | ---- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| data | bool | Optional | If true, any signatures in the input will be discarded and conversion will continue. If false, RPC will fail if any signatures are present. |

_Result---psbt_

| Name     | Type   | Presence                | Description                                       |
| -------- | ------ | ----------------------- | ------------------------------------------------- |
| `result` | string | Required<br>(Exactly 1) | The resulting raw transaction is a base64-encoded |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet converttopsbt 02000000016b490886c0198b028c6c5cb145c4eb3b1055a224a7a105aadeff41b69ec91e060100000000ffffffff0200205fa0120000001976a914485485425fa99504ec1638ac4213f3cfc9f32ef388acc0a8f9be010000001976a914811eacc14db8ebb5b64486dc43400c0226b428a488ac00000000
```

Result:

```
cHNidP8BAHcCAAAAAWtJCIbAGYsCjGxcsUXE6zsQVaIkp6EFqt7/QbaeyR4GAQAAAAD/////AgAgX6ASAAAAGXapFEhUhUJfqZUE7BY4rEIT88/J8y7ziKzAqPm+AQAAABl2qRSBHqzBTbjrtbZEhtxDQAwCJrQopIisAAAAAAAAAAA=
```

_See also:_

* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format.
* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.
* [Serialized Transaction Format](../reference/transactions-raw-transaction-format.md)
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## CreatePSBT

The [`createpsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#createpsbt) creates a transaction in the Partially Signed Transaction (PST) format.

Implements the Creator role.

_Parameter #1---Inputs_

| Name              | Type         | Presence                | Description                                                                                                |
| ----------------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| Transactions      | array        | Required<br>(exactly 1) | An array of objects, each one to be used as an input to the transaction                                    |
| → Input           | object       | Required<br>(1 or more) | An object describing a particular input                                                                    |
| → →<br>`txid`     | string (hex) | Required<br>(exactly 1) | The TXID of the outpoint to be spent encoded as hex in RPC byte order                                      |
| → →<br>`vout`     | number (int) | Required<br>(exactly 1) | The output index number (vout) of the outpoint to be spent; the first output in a transaction is index `0` |
| → →<br>`Sequence` | number (int) | Optional<br>(0 or 1)    | The sequence number to use for the input                                                                   |

_Parameter #2---Outputs_

| Name           | Type                   | Presence                | Description                                                                                               |
| -------------- | ---------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| Outputs        | array                  | Required<br>(exactly 1) | A JSON array with outputs as key-value pairs                                                              |
| → Output       | object                 | Required<br>(1 or more) | An object describing a particular output                                                                  |
| → →<br>Address | string : number (Dash) | Optional<br>(0 or 1)    | A key-value pair. The key (string) is the Dash address, the value (float or string) is the amount in DASH |
| → →<br>Data    | `data` : string (hex)  | Optional<br>(0 or 1)    | A key-value pair. The key must be `data`, the value is hex encoded data                                   |

_Parameter #3---locktime_

| Name     | Type          | Presence             | Description                                                                                                            |
| -------- | ------------- | -------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Locktime | numeric (int) | Optional<br>(0 or 1) | Indicates the earliest time a transaction can be added to the block chain. Non-0 value also locktime-activates inputs. |

_Result---the raw transaction in base64_

| Name   | Type   | Presence                | Description                                           |
| ------ | ------ | ----------------------- | ----------------------------------------------------- |
| Result | string | Required<br>(Exactly 1) | The resulting raw transaction (base64-encoded string) |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet createpsbt "[{\"txid\":\"2662c87e1761ed5f4e98a0640b2608114d86f282824a51bd624985d236c71178\",\"vout\":0}]" "[{\"data\":\"00010203\"}]"
```

Result:

```
cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=
```

_See also:_

* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## CreateRawTransaction

The [`createrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction) creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.

_Parameter #1---Inputs_

| Name              | Type         | Presence                | Description                                                                                                |
| ----------------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| Transactions      | array        | Required<br>(exactly 1) | An array of objects, each one to be used as an input to the transaction                                    |
| → Input           | object       | Required<br>(1 or more) | An object describing a particular input                                                                    |
| → →<br>`txid`     | string (hex) | Required<br>(exactly 1) | The TXID of the outpoint to be spent encoded as hex in RPC byte order                                      |
| → →<br>`vout`     | number (int) | Required<br>(exactly 1) | The output index number (vout) of the outpoint to be spent; the first output in a transaction is index `0` |
| → →<br>`Sequence` | number (int) | Optional<br>(0 or 1)    | Added in Dash Core 0.12.3.0.<br><br>The sequence number to use for the input                               |

_Parameter #2---Outputs_

| Name           | Type                   | Presence                | Description                                                                                               |
| -------------- | ---------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| Outputs        | array                  | Required<br>(exactly 1) | A JSON array with outputs as key-value pairs                                                              |
| → Output       | object                 | Required<br>(1 or more) | An object describing a particular output                                                                  |
| → →<br>Address | string : number (Dash) | Optional<br>(0 or 1)    | A key-value pair. The key (string) is the Dash address, the value (float or string) is the amount in DASH |
| → →<br>Data    | `data` : string (hex)  | Optional<br>(0 or 1)    | A key-value pair. The key must be `data`, the value is hex encoded data                                   |

_Parameter #3---locktime_

| Name     | Type          | Presence             | Description                                                               |
| -------- | ------------- | -------------------- | ------------------------------------------------------------------------- |
| Locktime | numeric (int) | Optional<br>(0 or 1) | Indicates the earliest time a transaction can be added to the block chain |

_Result---the unsigned raw transaction in hex_

| Name     | Type   | Presence                | Description                                                                                                                                                                                                                      |
| -------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result` | string | Required<br>(Exactly 1) | The resulting unsigned raw transaction in serialized transaction format encoded as base-64.  If the transaction couldn't be generated, this will be set to JSON `null` and the JSON-RPC error field may contain an error message |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet createrawtransaction '''
  [
    {
      "txid": "061ec99eb641ffdeaa05a1a724a255103bebc445b15c6c8c028b19c08608496b",
      "vout" : 1
    }
  ]''' \
  '''
  [
    {
      "ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv": 800
    },
    {
      "yY6AmGopsZS31wy1JLHR9P6AC6owFaXwuh": 74.99
    }
  ]''' \
  0
```

Result:

```text
02000000016b490886c0198b028c6c5cb145c4eb3b1055a224a7a105aadeff41b69ec91e06010000\
0000ffffffff0200205fa0120000001976a914485485425fa99504ec1638ac4213f3cfc9f32ef388\
acc0a8f9be010000001976a914811eacc14db8ebb5b64486dc43400c0226b428a488ac00000000
```

_See also:_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.
* [Serialized Transaction Format](../reference/transactions-raw-transaction-format.md)

## DecodePSBT

The [`decodepsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#decodepsbt) returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.

_Parameter #1---The PSBT base64 string_

| Name   | Type   | Presence                | Description            |
| ------ | ------ | ----------------------- | ---------------------- |
| `psbt` | string | Required<br>(exactly 1) | The PSBT base64 string |

_Result---the decoded transaction_

| Name                             | Type         | Presence                | Description                                                                                                                                                                                                                                                                             |
| -------------------------------- | ------------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                         | object       | Required<br>(exactly 1) | An object describing the decoded transaction, or JSON `null` if the transaction could not be decoded                                                                                                                                                                                    |
| →<br>`tx`                        | string (hex) | Required<br>(exactly 1) | The decoded network-serialized unsigned transaction. The layout is the same as the output of [decoderawtransaction](#decoderawtransaction).                                                                                                                                             |
| →<br>`unknown`                   | object       | Required<br>(exactly 1) | The unknown global fields                                                                                                                                                                                                                                                               |
| →→<br>Unknown                    | object       | Required<br>(0 or more) | An unknown key-value pair                                                                                                                                                                                                                                                               |
| →<br>`inputs`                    | array        | Required<br>(exactly 1) | An array of objects with each object being an input vector (vin) for this transaction                                                                                                                                                                                                   |
| → →<br>Input                     | object       | Required<br>(1 or more) | An object describing one of this transaction's inputs.  May be a regular input or a coinbase                                                                                                                                                                                            |
| → → →<br>`non_witness_utxo`      | object       | Optional<br>(0 or more) | Decoded network transaction for non-witness UTXOs                                                                                                                                                                                                                                       |
| → → →<br>`partial_signatures`    | object       | Optional<br>(0 or more) | An object containing partial signatures                                                                                                                                                                                                                                                 |
| → → →→<br>`pubkey`               | string       | Required<br>(1 or more) | The public key and signature that corresponds to it                                                                                                                                                                                                                                     |
| → → →<br>`sighash`               | string       | Optional<br>(0 or 1)    | The sighash type to be used                                                                                                                                                                                                                                                             |
| → → →<br>`redeem_script`         | object       | Optional<br>(0 or more) |                                                                                                                                                                                                                                                                                         |
| → → → →<br>`asm`                 | string       | Required<br>(exactly 1) | The signature script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                               |
| → → → →<br>`hex`                 | string (hex) | Required<br>(exactly 1) | The signature script encoded as hex                                                                                                                                                                                                                                                     |
| → → → →<br>`type`                | string       | Optional<br>(0 or 1)    | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts |
| → → →<br>`bip32_derivs`          | object       | Optional<br>(0 or more) |                                                                                                                                                                                                                                                                                         |
| → → →→<br>`pubkey`               | object       | Optional<br>(0 or more) | The public key with the derivation path as the value.                                                                                                                                                                                                                                   |
| → → →→→<br>`master_fingerprint`  | object       | Optional<br>(0 or more) | The fingerprint of the master key                                                                                                                                                                                                                                                       |
| → → →→→<br>`path`                | object       | Optional<br>(0 or more) | The public key's path                                                                                                                                                                                                                                                                   |
| → → →<br>`final_scriptsig`       | object       | Optional<br>(0 or more) |                                                                                                                                                                                                                                                                                         |
| → → → →<br>`asm`                 | string       | Required<br>(exactly 1) | The signature script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                               |
| → → → →<br>`hex`                 | string (hex) | Required<br>(exactly 1) | The signature script encoded as hex                                                                                                                                                                                                                                                     |
| → → →<br>`unknown`               | object       | Optional<br>(0 or more) | The unknown global fields                                                                                                                                                                                                                                                               |
| → → → →<br>Unknown               | object       | Required<br>(0 or more) | An unknown key-value pair                                                                                                                                                                                                                                                               |
| →<br>`vout`                      | array        | Required<br>(exactly 1) | An array of objects each describing an output vector (vout) for this transaction.  Output objects will have the same order within the array as they have in the transaction, so the first output listed will be output 0                                                                |
| → →<br>Output                    | object       | Required<br>(1 or more) | An object describing one of this transaction's outputs                                                                                                                                                                                                                                  |
| → → →<br>`redeem_script`         | object       | Required<br>(exactly 1) | An object describing the pubkey script                                                                                                                                                                                                                                                  |
| → → → →<br>`asm`                 | string       | Required<br>(exactly 1) | The pubkey script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                                  |
| → → → →<br>`hex`                 | string (hex) | Required<br>(exactly 1) | The pubkey script encoded as hex                                                                                                                                                                                                                                                        |
| → → → →<br>`type`                | string       | Optional<br>(0 or 1)    | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts |
| → → →<br>`bip32_derivs`          | array        | Optional<br>(0 or more) | Array of JSON objects                                                                                                                                                                                                                                                                   |
| → → →→<br>BIP32 Deriv            | object       | Optional<br>(0 or more) | An object containing BIP32 derivation infomation                                                                                                                                                                                                                                        |
| →→  → →→<br>`pubkey`             | object       | Optional<br>(0 or more) | The public key this path corresponds to                                                                                                                                                                                                                                                 |
| → → → →→<br>`master_fingerprint` | object       | Optional<br>(0 or more) | The fingerprint of the master key                                                                                                                                                                                                                                                       |
| → → →→→<br>`path`                | object       | Optional<br>(0 or more) | The public key's path                                                                                                                                                                                                                                                                   |
| →<br>`fee`                       | number (int) | Optional<br>(0 or 1)    | The transaction fee paid if all UTXOs slots in the PSBT have been filled                                                                                                                                                                                                                |

_Example from Dash Core 18.0.0_

Decode a one-input, one-output transaction:

```bash
dash-cli -testnet decodepsbt cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=
```

Result:

```json
{
  "tx": {
    "txid": "5954a007baf3f012af1484b42d24057f9b1541dd65003bababb1a53c9f7eabe4",
    "version": 2,
    "type": 0,
    "size": 66,
    "locktime": 0,
    "vin": [
      {
        "txid": "2662c87e1761ed5f4e98a0640b2608114d86f282824a51bd624985d236c71178",
        "vout": 0,
        "scriptSig": {
          "asm": "",
          "hex": ""
        },
        "sequence": 4294967295
      }
    ],
    "vout": [
      {
        "value": 0.00000000,
        "valueSat": 0,
        "n": 0,
        "scriptPubKey": {
          "asm": "OP_RETURN 50462976",
          "hex": "6a0400010203",
          "type": "nulldata"
        }
      }
    ]
  },
  "unknown": {
  },
  "inputs": [
    {
      "non_witness_utxo": {
        "txid": "2662c87e1761ed5f4e98a0640b2608114d86f282824a51bd624985d236c71178",
        "version": 2,
        "type": 0,
        "size": 225,
        "locktime": 542805,
        "vin": [
          {
            "txid": "427c8d2f712b72150496d53b67403a984b6fb41f37f6c0a85115d12c50b78b94",
            "vout": 1,
            "scriptSig": {
              "asm": "304402204fe4fc488c955f286c52c848ec7950b40ec476e1b434c6add686b474bdde09a902206222d291fd9da341408aa8a4720f5a6959997715a1ddf8187e75277b6bfcae7e[ALL] 03c67d86944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9",
              "hex": "47304402204fe4fc488c955f286c52c848ec7950b40ec476e1b434c6add686b474bdde09a902206222d291fd9da341408aa8a4720f5a6959997715a1ddf8187e75277b6bfcae7e012103c67d86944315838aea7ec80d390b5d09b91b62483370d4979da5ccf7a7df77a9"
            },
            "sequence": 4294967294
          }
        ],
        "vout": [
          {
            "value": 1.64030388,
            "valueSat": 164030388,
            "n": 0,
            "scriptPubKey": {
              "asm": "OP_DUP OP_HASH160 cefc464904c03814c01906e197dc759a745e47ee OP_EQUALVERIFY OP_CHECKSIG",
              "hex": "76a914cefc464904c03814c01906e197dc759a745e47ee88ac",
              "reqSigs": 1,
              "type": "pubkeyhash",
              "addresses": [
                "yfBtG4d5ZRWXWo8JQrbVcCzpKyJRhcGyYk"
              ]
            }
          },
          {
            "value": 10.00000000,
            "valueSat": 1000000000,
            "n": 1,
            "scriptPubKey": {
              "asm": "OP_DUP OP_HASH160 3ef9bcbe92f77c8fadd0566eea7ff8d47f22bde0 OP_EQUALVERIFY OP_CHECKSIG",
              "hex": "76a9143ef9bcbe92f77c8fadd0566eea7ff8d47f22bde088ac",
              "reqSigs": 1,
              "type": "pubkeyhash",
              "addresses": [
                "yS4Rv9VJnUvwcwggLzi88pu6jTPVya52Ba"
              ]
            }
          }
        ]
      },
      "final_scriptSig": {
        "asm": "3044022005d5f8010e0d8cfd601e6136330a4122492ac3573718a1ef30c2bc3f31b760390220273a18050f61026ea3aa4d9c2c58ad51dd7f88bd64bbcc3dba769d8cd7ec09da[ALL] 0267da91139a4f14d97eaf7800ea9e7cb9ffa8fc232ece8b38a3d127891e6f71e8",
        "hex": "473044022005d5f8010e0d8cfd601e6136330a4122492ac3573718a1ef30c2bc3f31b760390220273a18050f61026ea3aa4d9c2c58ad51dd7f88bd64bbcc3dba769d8cd7ec09da01210267da91139a4f14d97eaf7800ea9e7cb9ffa8fc232ece8b38a3d127891e6f71e8"
      }
    }
  ],
  "outputs": [
    {
    }
  ],
  "fee": 1.64030388
}
```

## DecodeRawTransaction

The [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction) decodes a serialized transaction hex string into a JSON object describing the transaction.

_Parameter #1---serialized transaction in hex_

| Name                   | Type         | Presence                | Description                                                |
| ---------------------- | ------------ | ----------------------- | ---------------------------------------------------------- |
| Serialized Transaction | string (hex) | Required<br>(exactly 1) | The transaction to decode in serialized transaction format |

_Result---the decoded transaction_

| Name                    | Type           | Presence                | Description                                                                                                                                                                                                                                                                                                                      |
| ----------------------- | -------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                | object         | Required<br>(exactly 1) | An object describing the decoded transaction, or JSON `null` if the transaction could not be decoded                                                                                                                                                                                                                             |
| →<br>`txid`             | string (hex)   | Required<br>(exactly 1) | The transaction's TXID encoded as hex in RPC byte order                                                                                                                                                                                                                                                                          |
| →<br>`version`          | number (int)   | Required<br>(exactly 1) | The transaction format version number                                                                                                                                                                                                                                                                                            |
| →<br>`type`             | number (int)   | Required<br>(exactly 1) | _Added in Dash Core 0.13.0.0_<br><br>The transaction format type                                                                                                                                                                                                                                                                 |
| →<br>`size`             | number (int)   | Required<br>(exactly 1) | _Added in Bitcoin Core 0.12.0_<br><br>The serialized transaction size                                                                                                                                                                                                                                                            |
| →<br>`locktime`         | number (int)   | Required<br>(exactly 1) | The transaction's locktime: either a Unix epoch date or block height; see the [locktime parsing rules](../guide/transactions-locktime-and-sequence-number.md#locktime-parsing-rules)                                                                                                                                              |
| →<br>`vin`              | array          | Required<br>(exactly 1) | An array of objects with each object being an input vector (vin) for this transaction.  Input objects will have the same order within the array as they have in the transaction, so the first input listed will be input 0                                                                                                       |
| → →<br>Input            | object         | Required<br>(1 or more) | An object describing one of this transaction's inputs.  May be a regular input or a coinbase                                                                                                                                                                                                                                     |
| → → →<br>`txid`         | string         | Optional<br>(0 or 1)    | The TXID of the outpoint being spent, encoded as hex in RPC byte order.  Not present if this is a coinbase transaction                                                                                                                                                                                                           |
| → → →<br>`vout`         | number (int)   | Optional<br>(0 or 1)    | The output index number (vout) of the outpoint being spent.  The first output in a transaction has an index of `0`.  Not present if this is a coinbase transaction                                                                                                                                                               |
| → → →<br>`scriptSig`    | object         | Optional<br>(0 or 1)    | An object describing the signature script of this input.  Not present if this is a coinbase transaction                                                                                                                                                                                                                          |
| → → → →<br>`asm`        | string         | Required<br>(exactly 1) | The signature script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                                                                        |
| → → → →<br>`hex`        | string (hex)   | Required<br>(exactly 1) | The signature script encoded as hex                                                                                                                                                                                                                                                                                              |
| → → →<br>`coinbase`     | string (hex)   | Optional<br>(0 or 1)    | The coinbase (similar to the hex field of a scriptSig) encoded as hex.  Only present if this is a coinbase transaction                                                                                                                                                                                                           |
| → → →<br>`value`        | number (Dash)  | Optional<br>(exactly 1) | The number of Dash paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled                                                                                                                                                                                                                                 |
| → → →<br>`valueSat`     | number (duffs) | Optional<br>(exactly 1) | The number of duffs paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled                                                                                                                                                                                                                                |
| → → → →<br>`addresses`  | string : array | Optional<br>(0 or 1)    | The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types.<br><br>Only present if `spentindex` enabled                                                                               |
| → → → → →<br>Address    | string         | Required<br>(1 or more) | A P2PKH or P2SH address                                                                                                                                                                                                                                                                                                          |
| → → →<br>`sequence`     | number (int)   | Required<br>(exactly 1) | The input sequence number                                                                                                                                                                                                                                                                                                        |
| →<br>`vout`             | array          | Required<br>(exactly 1) | An array of objects each describing an output vector (vout) for this transaction.  Output objects will have the same order within the array as they have in the transaction, so the first output listed will be output 0                                                                                                         |
| → →<br>Output           | object         | Required<br>(1 or more) | An object describing one of this transaction's outputs                                                                                                                                                                                                                                                                           |
| → → →<br>`value`        | number (Dash)  | Required<br>(exactly 1) | The number of Dash paid to this output.  May be `0`                                                                                                                                                                                                                                                                              |
| → → →<br>`valueSat`     | number (duffs) | Required<br>(exactly 1) | The number of duffs paid to this output.  May be `0`                                                                                                                                                                                                                                                                             |
| → → →<br>`n`            | number (int)   | Required<br>(exactly 1) | The output index number of this output within this transaction                                                                                                                                                                                                                                                                   |
| → → →<br>`scriptPubKey` | object         | Required<br>(exactly 1) | An object describing the pubkey script                                                                                                                                                                                                                                                                                           |
| → → → →<br>`asm`        | string         | Required<br>(exactly 1) | The pubkey script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                                                                           |
| → → → →<br>`hex`        | string (hex)   | Required<br>(exactly 1) | The pubkey script encoded as hex                                                                                                                                                                                                                                                                                                 |
| → → → →<br>`reqSigs`    | number (int)   | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The number of signatures required; this is always `1` for P2PK, P2PKH, and P2SH (including P2SH multisig because the redeem script is not available in the pubkey script).  It may be greater than 1 for bare multisig.  This value will not be returned for `nulldata` or `nonstandard` script types (see the `type` key below) |
| → → → →<br>`type`       | string         | Optional<br>(0 or 1)    | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts                                          |
| → → →<br>`address` | string | Optional<br>(0 or 1) | Dash address (only if a well-defined address exists) |
| → → → →<br>`addresses`  | string : array | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types                                                                                                                            |
| → → → → →<br>Address    | string         | Required<br>(1 or more) | A P2PKH or P2SH address                                                                                                                                                                                                                                                                                                          |
| →<br>`extraPayloadSize` | number (int)   | Optional<br>(0 or 1)    | _Added in Dash Core 0.13.0.0_<br><br>Size of the DIP2 extra payload. Only present if it's a DIP2 special transaction                                                                                                                                                                                                             |
| →<br>`extraPayload`     | string (hex)   | Optional<br>(0 or 1)    | _Added in Dash Core 0.13.0.0_<br><br>Hex encoded DIP2 extra payload data. Only present if it's a DIP2 special transaction                                                                                                                                                                                                        |

_Example from Dash Core 21.1.0_

Decode a signed one-input, two-output transaction:

```bash
dash-cli -testnet decoderawtransaction 02000000015d0b26079696875e9fc3cb480420aae3c8\
b1da628fbb14cc718066df7fe7c5fd010000006a47304402202cfa683981898ad9adb89534\
23a38f7185ed41e163aa195d608fbe5bc3034910022034e2376aaed1c6576c0dad79d626ee\
27f706baaed86dabb105979c3e6f6e1cb9012103d14eb001cf0908f3a2333d171f6236497a\
82318a6a6f649b4d7fd8e5c8922e08feffffff021e3f4b4c000000001976a914b02ae52066\
542b4aec5cf45c7cae3183d7bd322788ac00f90295000000001976a914252c9de3a0ebd5c9\
5886187b24969d4ccdb5576e88ac943d0000
```

Result:

```json
{
  "txid": "f4de3be04efa18e203c9d0b7ad11bb2517f5889338918ed300a374f5bd736ed7",
  "version": 2,
  "type": 0,
  "size": 225,
  "locktime": 15764,
  "vin": [
    {
      "txid": "fdc5e77fdf668071cc14bb8f62dab1c8e3aa200448cbc39f5e87969607260b5d",
      "vout": 1,
      "scriptSig": {
        "asm": "304402202cfa683981898ad9adb8953423a38f7185ed41e163aa195d608fbe5bc3034910022034e2376aaed1c6576c0dad79d626ee27f706baaed86dabb105979c3e6f6e1cb9[ALL] 03d14eb001cf0908f3a2333d171f6236497a82318a6a6f649b4d7fd8e5c8922e08",
        "hex": "47304402202cfa683981898ad9adb8953423a38f7185ed41e163aa195d608fbe5bc3034910022034e2376aaed1c6576c0dad79d626ee27f706baaed86dabb105979c3e6f6e1cb9012103d14eb001cf0908f3a2333d171f6236497a82318a6a6f649b4d7fd8e5c8922e08"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 12.79999774,
      "valueSat": 1279999774,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 b02ae52066542b4aec5cf45c7cae3183d7bd3227 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914b02ae52066542b4aec5cf45c7cae3183d7bd322788ac",
        "address": "ycNwAN4DQ7Xnw5XLKg84SR4U1GE22FfLNQ",
        "type": "pubkeyhash"
      }
    },
    {
      "value": 25.00000000,
      "valueSat": 2500000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 252c9de3a0ebd5c95886187b24969d4ccdb5576e OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914252c9de3a0ebd5c95886187b24969d4ccdb5576e88ac",
        "address": "yPi1JKw5fn8bMFsCCtnkGagogW6GXwGktZ",
        "type": "pubkeyhash"
      }
    }
  ]
}
```

Decode a coinbase special transaction (CbTx):

```bash
dash-cli -testnet decoderawtransaction 03000500010000000000000000000000000000000000\
000000000000000000000000000000ffffffff2703ae50011a4d696e656420627920416e74\
506f6f6c2021000b01201da9196f0000000007000000ffffffff02809e4730000000001976\
a914cbd7bfcc50351180132b2c0698cb90ad74c473c788ac809e4730000000001976a91488\
a060bc2dfe05780ae4dcb6c98b12436c35a93988ac00000000460200ae50010078e5c08b39\
960887bf95185c381bdb719e60b6925fa12af78a8824fade927387c757acb6bac63da84f92\
45e20cfd5d830382ac634d434725ca6349ab5db920a3
```

Result:

```json
{
  "txid": "25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56",
  "version": 3,
  "type": 5,
  "size": 229,
  "locktime": 0,
  "vin": [
    {
      "coinbase": "03ae50011a4d696e656420627920416e74506f6f6c2021000b01201da9196f0000000007000000",
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 8.10000000,
      "valueSat": 810000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 cbd7bfcc50351180132b2c0698cb90ad74c473c7 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914cbd7bfcc50351180132b2c0698cb90ad74c473c788ac",
        "address": "yeuGUfPMrbEqAS2Pw1wonYgEPbM4LAA9LK",
        "type": "pubkeyhash"
      }
    },
    {
      "value": 8.10000000,
      "valueSat": 810000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 88a060bc2dfe05780ae4dcb6c98b12436c35a939 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91488a060bc2dfe05780ae4dcb6c98b12436c35a93988ac",
        "address": "yYmrsYP3XYMZr1cGtha3QzmuNB1C7CfyhV",
        "type": "pubkeyhash"
      }
    }
  ],
  "extraPayloadSize": 70,
  "extraPayload": "0200ae50010078e5c08b39960887bf95185c381bdb719e60b6925fa12af78a8824fade927387c757acb6bac63da84f9245e20cfd5d830382ac634d434725ca6349ab5db920a3",
  "cbTx": {
    "version": 2,
    "height": 86190,
    "merkleRootMNList": "877392defa24888af72aa15f92b6609e71db1b385c1895bf870896398bc0e578",
    "merkleRootQuorums": "a320b95dab4963ca2547434d63ac8203835dfd0ce245924fa83dc6bab6ac57c7"
  }
}
```

_See also:_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.

## DecodeScript

The [`decodescript` RPC](../api/remote-procedure-calls-raw-transactions.md#decodescript) decodes a hex-encoded P2SH redeem script.

_Parameter #1---a hex-encoded redeem script_

| Name          | Type         | Presence                | Description                                                    |
| ------------- | ------------ | ----------------------- | -------------------------------------------------------------- |
| Redeem Script | string (hex) | Required<br>(exactly 1) | The redeem script to decode as a hex-encoded serialized script |

_Result---the decoded script_

| Name             | Type         | Presence                | Description                                                                                                                                                                                                                                   |
| ---------------- | ------------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`         | object       | Required<br>(exactly 1) | An object describing the decoded script, or JSON `null` if the script could not be decoded                                                                                                                                                    |
| →<br>`asm`       | string       | Required<br>(exactly 1) | The redeem script in decoded form with non-data-pushing opcodes listed.  May be empty                                                                                                                                                         |
| →<br>`reqSigs`   | number (int) | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The number of signatures required; this is always `1` for P2PK or P2PKH within P2SH.  It may be greater than 1 for P2SH multisig.  This value will not be returned for `nonstandard` script types (see the `type` key above)                  |
| →<br>`type`      | string       | Optional<br>(0 or 1)    | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script inside P2SH<br>• `pubkeyhash` for a P2PKH script inside P2SH<br>• `multisig` for a multisig script inside P2SH<br>• `nonstandard` for unknown scripts |
| →<br>`addresses` | array        | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>A P2PKH addresses used in this script, or the computed P2PKH addresses of any pubkeys in this script.  This array will not be returned for `nonstandard` script types                                                                         |
| → →<br>Address   | string       | Required<br>(1 or more) | A P2PKH address                                                                                                                                                                                                                               |
| →<br>`p2sh`      | string (hex) | Required<br>(exactly 1) | The P2SH address of this redeem script                                                                                                                                                                                                        |

_Example from Dash Core 21.0.0_

A 2-of-3 P2SH multisig pubkey script:

```bash
dash-cli -testnet decodescript 522102eacba539d92eb88d4e73bb32\
749d79f53f6e8d7947ac40a71bd4b26c13b6ec29210311f97539724e0de38fb1\
ff79f5148e5202459d06ed07193ab18c730274fd0d882103251f25a5c0291446\
d801ba6df122f67a7dd06c60a9b332b7b29cc94f3b8f57d053ae
```

Result:

```json
{
  "asm": "2 02eacba539d92eb88d4e73bb32749d79f53f6e8d7947ac40a71bd4b26c13b6ec29 0311f97539724e0de38fb1ff79f5148e5202459d06ed07193ab18c730274fd0d88 03251f25a5c0291446d801ba6df122f67a7dd06c60a9b332b7b29cc94f3b8f57d0 3 OP_CHECKMULTISIG",
  "type": "multisig",
  "p2sh": "8uJLxDxk2gEMbidF5vT8XLS2UCgQmVcroW"
}
```

_See also:_

* [CreateMultiSig](../api/remote-procedure-calls-util.md#createmultisig): creates a P2SH multi-signature address.

## FinalizePSBT

The [`finalizepsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt) finalizes the inputs of a PSBT. The PSBT produces a network serialized transaction if the transaction is fully signed. This can broadcast with `sendrawtransaction`. Otherwise, a PSBT will be created which has the `final_scriptSig` fields filled for inputs that are complete.  
Implements the Finalizer and Extractor roles.

_Parameter #1---psbt_

| Name | Type   | Presence | Description               |
| ---- | ------ | -------- | ------------------------- |
| psbt | string | Required | A base64 string of a PSBT |

_Parameter #2---extract_

| Name | Type | Presence | Description                                                                                                                                |
| ---- | ---- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| data | bool | Optional | If true, and the transaction is complete, extract and return the complete transaction in normal network serialization instead of the PSBT. |

_Result---psbt_

| Name           | Type         | Presence                | Description                                                      |
| -------------- | ------------ | ----------------------- | ---------------------------------------------------------------- |
| → <br>psbt     | string       | Optional<br>(0 or 1)    | The base64-encoded partially signed transaction if not extracted (present if `complete` is `false`)|
| → <br>hex      | string (hex) | Optional<br>(0 or 1)    | The hex-encoded network transaction if extracted (present if `complete` is `true`)                |
| → <br>complete | bool         | Required<br>(Exactly 1) | If the transaction has a complete set of signatures              |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet finalizepsbt cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAQDhAgAAAAGUi7dQLNEVUajA9jcftG9LmDpAZzvVlgQVcitxL418QgEAAABqRzBEAiBP5PxIjJVfKGxSyEjseVC0DsR24bQ0xq3WhrR0vd4JqQIgYiLSkf2do0FAiqikcg9aaVmZdxWh3fgYfnUne2v8rn4BIQPGfYaUQxWDiup+yA05C10JuRtiSDNw1Jedpcz3p993qf7///8CtOfGCQAAAAAZdqkUzvxGSQTAOBTAGQbhl9x1mnReR+6IrADKmjsAAAAAGXapFD75vL6S93yPrdBWbup/+NR/Ir3giKxVSAgAAQdqRzBEAiAF1fgBDg2M/WAeYTYzCkEiSSrDVzcYoe8wwrw/MbdgOQIgJzoYBQ9hAm6jqk2cLFitUd1/iL1ku8w9unadjNfsCdoBIQJn2pETmk8U2X6veADqnny5/6j8Iy7Oizij0SeJHm9x6AAA
```

Result:

```json
{
  "hex": "02000000017811c736d2854962bd514a8282f2864d1108260b64a0984e5fed61177ec86226000000006a473044022005d5f8010e0d8cfd601e6136330a4122492ac3573718a1ef30c2bc3f31b760390220273a18050f61026ea3aa4d9c2c58ad51dd7f88bd64bbcc3dba769d8cd7ec09da01210267da91139a4f14d97eaf7800ea9e7cb9ffa8fc232ece8b38a3d127891e6f71e8ffffffff010000000000000000066a040001020300000000",
  "complete": true
}
```

_See also:_

* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format.
* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## FundRawTransaction

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`fundrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#fundrawtransaction) adds inputs to a transaction until it has enough in value to meet its out value.  This will not modify existing inputs, and will add one change output to the outputs.  
Note that inputs which were signed may need to be resigned after completion since in/outputs have been added.  The inputs added will not be signed, use signrawtransaction for that.  
All existing inputs must have their previous output transaction be in the wallet.

_Parameter #1---The hex string of the raw transaction_

| Name       | Type         | Presence                | Description                           |
| ---------- | ------------ | ----------------------- | ------------------------------------- |
| Hex string | string (hex) | Required<br>(exactly 1) | The hex string of the raw transaction |

_Parameter #2---Additional options_

Note: For backwards compatibility, passing in a `true` instead of an object will result in `{"includeWatching": true}`.

| Name                           | Type               | Presence                | Description|
| ------------------------------ | ------------------ | ----------------------- | ---------- |
| Options                        | Object             | Optional<br>(0 or 1)    | Additional options. For backward compatibility: passing in a true instead of an object will result in {"includeWatching":true} |
| → <br>`add_inputs`             | bool               | Optional<br>(0 or 1)    | If inputs are specified, automatically include more if they are not enough. Defaults to `true`. |
| → <br>`changeAddress`          | string             | Optional<br>(0 or 1)    | The address to receive the change. If not set, the address is chosen from address pool                                                                                                                                    |
| → <br>`changePosition`         | nummeric (int)     | Optional<br>(0 or 1)    | The index of the change output. If not set, the change position is randomly chosen |
| `includeWatching`              | bool               | Optional<br>(0 or 1)    | Inputs from watch-only addresses are also considered. The default is `false` for non-watching-only wallets and `true` for watching-only wallets                                                                           |
| → <br>`lockUnspent`            | bool               | Optional<br>(0 or 1)    | The selected outputs are locked after running the rpc call. The default is `false`. This applies to manually selected coins also since Dash Core 20.1.0. |
| → <br>`feeRate`                | numeric (bitcoins) | Optional<br>(0 or 1)    | The specific feerate  you are willing to pay (BTC per KB). If not set, the wallet determines the fee |
| → <br>`subtractFeeFromOutputs` | array              | Optional<br>(0 or 1)    | A json array of integers. The fee will be equally deducted from the amount of each specified output. The outputs are specified by their zero-based index, before any change output is added.                              |
| → →<br>Output index            | numeric (int)      | Optional<br>(0 or more) | A output index number (vout) from which the fee should be subtracted. If multiple vouts are provided, the total fee will be divided by the number of vouts listed and each vout will have that amount subtracted from it. |
| → <br>`conf_target`            | numberic (int)     | Optional<br>(0 or 1)    | Confirmation target (in blocks), or fee rate (for DASH/kB or duff/B estimate modes) |
| → <br>`estimate_mode`          | string             | Optional<br>(0 or 1)    | The fee estimate mode, must be one of (case insensitive):<br>`unset`<br>`economical`<br>`conservative`<br>`DASH/kB`<br>`duff/B` |

_Result---information about the created transaction_

| Name            | Type               | Presence                | Description                                                                            |
| --------------- | ------------------ | ----------------------- | -------------------------------------------------------------------------------------- |
| `result`        | object             | Required<br>(exactly 1) | An object including information about the created transaction                          |
| → <br>hex       | string (hex)       | Required<br>(Exactly 1) | The resulting unsigned raw transaction in serialized transaction format encoded as hex |
| → <br>fee       | numeric (bitcoins) | Required<br>(Exactly 1) | Fee in BTC the resulting transaction pays                                              |
| → <br>changepos | numeric (int)      | Required<br>(Exactly 1) | The position of the added change output, or `-1` if no change output was added         |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet fundrawtransaction 01000000000100205fa012000000\
1976a914485485425fa99504ec1638ac4213f3cfc9f32ef388ac00000000
```

Result:

```text
{
  "hex": "01000000016b490886c0198b028c6c5cb145c4eb3b1055a224a7a105aadeff41b69ec91e060100000000feffffff023e1207bf010000001976a914bd652a167e7ad674f7815dc549bea9c57a7f919b88ac00205fa0120000001976a914485485425fa99504ec1638ac4213f3cfc9f32ef388ac00000000",
  "changepos": 0,
  "fee": 0.00000226
}
```

_See also:_

* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.
* [Serialized Transaction Format](../reference/transactions-raw-transaction-format.md)

```{eval-rst}
.. _api-rpc-raw-transactions-getassetunlockstatuses:
```

## GetAssetUnlockStatuses

The [`getassetunlockstatuses` RPC](../api/remote-procedure-calls-raw-transactions.md#getassetunlockstatuses) returns the status of the provided Asset Unlock indexes at the tip of the chain or at a particular block height if specified.

_Parameters_

| Name    | Type  | Presence | Description |
| ------- | ----- | -------- | ----------- |
| Indexes | array | Required | An array of Asset Unlock indexes (no more than 100). Each element is a numeric Asset Unlock index. |
| height | numeric | Optional (0 or 1) | The maximum block height to check. If not specified, the chain's tip is used. |

_Result---Status of the Asset Unlock indexes_

| Name   | Type  | Presence                | Description |
| ------ | ----- | ----------------------- | ----------- |
| Result | array | Required (Exactly 1)    | An array with the status of each Asset Unlock index. Each element in the array is a JSON object containing the index and its status. |
| → Index data | object | Required<br>(1 or more) | Details for an Asset Unlock index |
| → → <br>index | numeric | Required<br>(Exactly 1) | The Asset Unlock index |
| → → <br>status | string | Required<br>(Exactly 1) | Status of the Asset Unlock index. The possible outcomes per each index are:<br>- `chainlocked`: If the Asset Unlock index is mined on a ChainLocked block or up to the given block height.<br>- `mined`: If no ChainLock information is available for the mined Asset Unlock index.<br>- `mempooled`: If the Asset Unlock index is in the mempool.<br>- `unknown`: If none of the above are valid.<br>Note: If a specific block height is passed on request, then only `chainlocked` and `unknown` outcomes are possible. |

_Example from Dash Core 20.1.0_

```bash
dash-cli getassetunlockstatuses '["1", "2"]'
```

Result:

```json
[
  {
    "index": 1,
    "status": "chainlocked"
  },
  {
    "index": 2,
    "status": "mempooled"
  }
]
```

_See also: none_

```{eval-rst}
.. _api-rpc-raw-transactions-getrawtransaction:
```

## GetRawTransaction

The [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so the RPC may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings.

Note: By default this function only works for mempool transactions. When called with a blockhash argument, getrawtransaction will return the transaction if the specified block is available and the transaction is found in that block. When called without a blockhash argument, getrawtransaction will return the transaction if it is in the mempool, or if `-txindex` is enabled and the transaction is in a block in the blockchain. Use the [`gettransaction` RPC](../api/remote-procedure-calls-wallet.md#gettransaction) for wallet transactions.

As of Dash Core 18.0.0, transactions with unspent outputs will no longer be included unless `-txindex` is enabled.

:::{note}
If you begin using `txindex=1` after downloading the block chain, you must rebuild your indexes by starting Dash Core with the option  `-reindex`.  This may take several hours to complete, during which time your node will not process new blocks or transactions. This reindex only needs to be done once.
:::

_Parameter #1---the TXID of the transaction to get_

| Name | Type         | Presence                | Description                                                          |
| ---- | ------------ | ----------------------- | -------------------------------------------------------------------- |
| TXID | string (hex) | Required<br>(exactly 1) | The TXID of the transaction to get, encoded as hex in RPC byte order |

_Parameter #2---whether to get the serialized or decoded transaction_

| Name    | Type | Presence             | Description                                                                                                                                                                                                                                |
| ------- | ---- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Verbose | bool | Optional<br>(0 or 1) | _Updated in Dash Core 0.12.3 / Bitcoin Core 0.14.0_<br><br>Set to `false` (the default) to return the serialized transaction as hex.  Set to `true` to return a decoded transaction in JSON.  Before 0.12.3, use `0` and `1`, respectively |

_Parameter #3---hash of a block to look in for the transaction_

| Name       | Type | Presence             | Description                                                                                   |
| ---------- | ---- | -------------------- | --------------------------------------------------------------------------------------------- |
| Block Hash | string | Optional<br>(0 or 1) | _Added in Dash Core 0.16.0_<br><br>The hash of the block in which to look for the transaction |

_Result (if transaction not found)---`null`_

| Name     | Type | Presence                | Description                                                                                                                                                                                                                                                  |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result` | null | Required<br>(exactly 1) | If the transaction wasn't found, the result will be JSON `null`.  This can occur because the transaction doesn't exist in the block chain or memory pool, or because it isn't part of the transaction index.  See the Dash Core `-help` entry for `-txindex` |

```{eval-rst}
.. _rpc-raw-txs-getrawtx-hex:
```

_Result (if verbose=`false`)---the serialized transaction_

| Name     | Type         | Presence                | Description                                                                          |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------ |
| `result` | string (hex) | Required<br>(exactly 1) | If the transaction was found, this will be the serialized transaction encoded as hex |

```{eval-rst}
.. _rpc-raw-txs-getrawtx-decoded:
```

_Result (if verbose=`true`)---the decoded transaction_

| Name                        | Type           | Presence                | Description                                                                                                                                                                                                                                                                                                                      |
| --------------------------- | -------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                    | object         | Required<br>(exactly 1) | If the transaction was found, this will be an object describing it                                                                                                                                                                                                                                                               |
| →<br>`in_active_chain`      | bool           | Optional<br>(0 or 1)    | ) Whether specified block is in the active chain or not (only present with explicit `blockhash` argument) |
| →<br>`txid`                 | string (hex)   | Required<br>(exactly 1) | The transaction's TXID encoded as hex in RPC byte order                                                                                                                                                                                                                                                                          |
| →<br>`size`                 | number (int)   | Required<br>(exactly 1) | _Added in Bitcoin Core 0.12.0_<br><br>The serialized transaction size                                                                                                                                                                                                                                                            |
| →<br>`version`              | number (int)   | Required<br>(exactly 1) | The transaction format version number                                                                                                                                                                                                                                                                                            |
| →<br>`type`                 | number (int)   | Required<br>(exactly 1) | _Added in Dash Core 0.13.0.0_<br><br>The transaction format type                                                                                                                                                                                                                                                                 |
| →<br>`locktime`             | number (int)   | Required<br>(exactly 1) | The transaction's locktime: either a Unix epoch date or block height; see the [locktime parsing rules](../guide/transactions-locktime-and-sequence-number.md#locktime-parsing-rules)                                                                                                                                              |
| →<br>`vin`                  | array          | Required<br>(exactly 1) | An array of objects with each object being an input vector (vin) for this transaction.  Input objects will have the same order within the array as they have in the transaction, so the first input listed will be input 0                                                                                                       |
| → →<br>Input                | object         | Required<br>(1 or more) | An object describing one of this transaction's inputs.  May be a regular input or a coinbase                                                                                                                                                                                                                                     |
| → → →<br>`txid`             | string         | Optional<br>(0 or 1)    | The TXID of the outpoint being spent, encoded as hex in RPC byte order.  Not present if this is a coinbase transaction                                                                                                                                                                                                           |
| → → →<br>`vout`             | number (int)   | Optional<br>(0 or 1)    | The output index number (vout) of the outpoint being spent.  The first output in a transaction has an index of `0`.  Not present if this is a coinbase transaction                                                                                                                                                               |
| → → →<br>`scriptSig`        | object         | Optional<br>(0 or 1)    | An object describing the signature script of this input.  Not present if this is a coinbase transaction                                                                                                                                                                                                                          |
| → → → →<br>`asm`            | string         | Required<br>(exactly 1) | The signature script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                                                                        |
| → → → →<br>`hex`            | string (hex)   | Required<br>(exactly 1) | The signature script encoded as hex                                                                                                                                                                                                                                                                                              |
| → → →<br>`coinbase`         | string (hex)   | Optional<br>(0 or 1)    | The coinbase (similar to the hex field of a scriptSig) encoded as hex.  Only present if this is a coinbase transaction                                                                                                                                                                                                           |
| → → →<br>`value`            | number (Dash)  | Optional<br>(exactly 1) | The number of Dash paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled                                                                                                                                                                                                                                 |
| → → →<br>`valueSat`         | number (duffs) | Optional<br>(exactly 1) | The number of duffs paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled                                                                                                                                                                                                                                |
| → → → →<br>`addresses`      | string : array | Optional<br>(0 or 1)    | The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types.<br><br>Only present if `spentindex` enabled                                                                               |
| → → → → →<br>Address        | string         | Required<br>(1 or more) | A P2PKH or P2SH address                                                                                                                                                                                                                                                                                                          |
| → → →<br>`sequence`         | number (int)   | Required<br>(exactly 1) | The input sequence number                                                                                                                                                                                                                                                                                                        |
| →<br>`vout`                 | array          | Required<br>(exactly 1) | An array of objects each describing an output vector (vout) for this transaction.  Output objects will have the same order within the array as they have in the transaction, so the first output listed will be output 0                                                                                                         |
| → →<br>Output               | object         | Required<br>(1 or more) | An object describing one of this transaction's outputs                                                                                                                                                                                                                                                                           |
| → → →<br>`value`            | number (Dash)  | Required<br>(exactly 1) | The number of Dash paid to this output.  May be `0`                                                                                                                                                                                                                                                                              |
| → → →<br>`valueSat`         | number (duffs) | Required<br>(exactly 1) | The number of duffs paid to this output.  May be `0`                                                                                                                                                                                                                                                                             |
| → → →<br>`n`                | number (int)   | Required<br>(exactly 1) | The output index number of this output within this transaction                                                                                                                                                                                                                                                                   |
| → → →<br>`scriptPubKey`     | object         | Required<br>(exactly 1) | An object describing the pubkey script                                                                                                                                                                                                                                                                                           |
| → → → →<br>`asm`            | string         | Required<br>(exactly 1) | The pubkey script in decoded form with non-data-pushing opcodes listed                                                                                                                                                                                                                                                           |
| → → → →<br>`hex`            | string (hex)   | Required<br>(exactly 1) | The pubkey script encoded as hex                                                                                                                                                                                                                                                                                                 |
| → → → →<br>`reqSigs`        | number (int)   | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The number of signatures required; this is always `1` for P2PK, P2PKH, and P2SH (including P2SH multisig because the redeem script is not available in the pubkey script).  It may be greater than 1 for bare multisig.  This value will not be returned for `nulldata` or `nonstandard` script types (see the `type` key below) |
| → → → →<br>`type`           | string         | Optional<br>(0 or 1)    | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts                                          |
| → → →<br>`address` | string | Optional<br>(0 or 1) | Dash address (only if a well-defined address exists) |
| → → → →<br>`addresses`      | string : array | Optional<br>(0 or 1)    | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types                                                                                                                            |
| → → → → →<br>Address        | string         | Required<br>(1 or more) | A P2PKH or P2SH address                                                                                                                                                                                                                                                                                                          |
| →<br>`extraPayloadSize`     | number (int)   | Optional<br>(0 or 1)    | _Added in Dash Core 0.13.0.0_<br><br>Size of the DIP2 extra payload. Only present if it's a DIP2 special transaction                                                                                                                                                                                                             |
| →<br>`extraPayload`         | string (hex)   | Optional<br>(0 or 1)    | _Added in Dash Core 0.13.0.0_<br><br>Hex encoded DIP2 extra payload data. Only present if it's a DIP2 special transaction                                                                                                                                                                                                        |
| →<br>`hex`                  | string (hex)   | Required<br>(exactly 1) | The serialized, hex-encoded data for the provided `txid`                                                                                                                                                                                                                                                                         |
| →<br>`blockhash`            | string (hex)   | Optional<br>(0 or 1)    | If the transaction has been included in a block on the local best block chain, this is the hash of that block encoded as hex in RPC byte order                                                                                                                                                                                   |
| →<br>`height`               | number (int)   | Optional<br>(0 or 1)    |  If the transaction has been included in a block on the local best block chain, this is the block height where the transaction was mined.  Otherwise, this is `-1`. Not shown for mempool transactions. |
| →<br>`confirmations`        | number (int)   | Optional<br>(0 or 1)    | If the transaction has been included in a block on the local best block chain, this is how many confirmations it has.  Otherwise, this is `0`. Not shown for mempool transactions. |
| →<br>`time`                 | number (int)   | Optional<br>(0 or 1)    | If the transaction has been included in a block on the local best block chain, this is the block header time of that block (may be in the future)                                                                                                                                                                                |
| →<br>`blocktime`            | number (int)   | Optional<br>(0 or 1)    | This field is currently identical to the time field described above                                                                                                                                                                                                                                                              |
| →<br>`instantlock`          | bool           | Required<br>(exactly 1) | If set to `true`, this transaction is either protected by an [InstantSend](../resources/glossary.md#instantsend) lock or it is in a block that has received a [ChainLock](../resources/glossary.md#chainlock) |
| →<br>`instantlock_internal` | bool           | Required<br>(exactly 1) | If set to `true`, this transaction has an [InstantSend](../resources/glossary.md#instantsend) lock |
| →<br>`chainlock`            | bool           | Required<br>(exactly 1) | _Added in Dash Core 0.14.0_<br><br>If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org)                                                                                                                                                                                           |

_Examples from Dash Core 21.1.0_

A classical transaction in serialized transaction format:

```bash
dash-cli getrawtransaction \
  88a3fe6bf2ab4425dbf57d75ce761efa2e45556ec36b4fd5b6af6c00f01ebd63
```

Result (wrapped):

```text
02000000016634e15fe22fe84554833f109916fced5af30fac0849a211f17f326\
162280f14010000006a47304402207b8f61bebe3560b6ef70de3e10b59bdc6093\
1d09cf0626026bfe3064dcfcf1c00220048ad98398cb294fa19335110db3ce5a4\
66b74cbbf234bf2b4855b264a03ef790121027b90f229e7027758f0c8b39d2d48\
5b88ed5b63b34e58e0dad2a07e3e8eb03373feffffff0278f5110400000000197\
6a9148907e625c343ac9c6b56e8180f73af1d23350d0c88acd007290e00000000\
1976a914dd01754e43690f41feef2cc7974bc2e5101e9f2788accf880d00
```

Get the same transaction in JSON:

```bash
dash-cli getrawtransaction \
88a3fe6bf2ab4425dbf57d75ce761efa2e45556ec36b4fd5b6af6c00f01ebd63 \
1
```

Result:

```json
{
  "txid": "88a3fe6bf2ab4425dbf57d75ce761efa2e45556ec36b4fd5b6af6c00f01ebd63",
  "version": 2,
  "type": 0,
  "size": 225,
  "locktime": 886991,
  "vin": [
    {
      "txid": "140f286261327ff111a24908ac0ff35aedfc1699103f835445e82fe25fe13466",
      "vout": 1,
      "scriptSig": {
        "asm": "304402207b8f61bebe3560b6ef70de3e10b59bdc60931d09cf0626026bfe3064dcfcf1c00220048ad98398cb294fa19335110db3ce5a466b74cbbf234bf2b4855b264a03ef79[ALL] 027b90f229e7027758f0c8b39d2d485b88ed5b63b34e58e0dad2a07e3e8eb03373",
        "hex": "47304402207b8f61bebe3560b6ef70de3e10b59bdc60931d09cf0626026bfe3064dcfcf1c00220048ad98398cb294fa19335110db3ce5a466b74cbbf234bf2b4855b264a03ef790121027b90f229e7027758f0c8b39d2d485b88ed5b63b34e58e0dad2a07e3e8eb03373"
      },
      "value": 3.05867613,
      "valueSat": 305867613,
      "address": "yeuA2vwH1Zba2pGs3NaeJh53ZuW97h2jXJ",
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 0.68285816,
      "valueSat": 68285816,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 8907e625c343ac9c6b56e8180f73af1d23350d0c OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a9148907e625c343ac9c6b56e8180f73af1d23350d0c88ac",
        "address": "yYoztKLNFLvbNYAPMUGoa5iHz5SBtNLEK8",
        "type": "pubkeyhash"
      },
      "spentTxId": "194e514c9814f7e34be3f8c696fff5871bda40bef2f87be1ff8075f691ef6e0b",
      "spentIndex": 0,
      "spentHeight": 887750
    },
    {
      "value": 2.37570000,
      "valueSat": 237570000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 dd01754e43690f41feef2cc7974bc2e5101e9f27 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914dd01754e43690f41feef2cc7974bc2e5101e9f2788ac",
        "address": "ygU1vv8a2fhiM2gYUF1GjQAcjxgZUKY5MD",
        "type": "pubkeyhash"
      },
      "spentTxId": "b9748455ee0bc7d3142a621b7a1f41d1b03a40283922d54cd4d168c16d20102a",
      "spentIndex": 0,
      "spentHeight": 888363
    }
  ],
  "hex": "02000000016634e15fe22fe84554833f109916fced5af30fac0849a211f17f326162280f14010000006a47304402207b8f61bebe3560b6ef70de3e10b59bdc60931d09cf0626026bfe3064dcfcf1c00220048ad98398cb294fa19335110db3ce5a466b74cbbf234bf2b4855b264a03ef790121027b90f229e7027758f0c8b39d2d485b88ed5b63b34e58e0dad2a07e3e8eb03373feffffff0278f51104000000001976a9148907e625c343ac9c6b56e8180f73af1d23350d0c88acd007290e000000001976a914dd01754e43690f41feef2cc7974bc2e5101e9f2788accf880d00",
  "blockhash": "0000009f3480f5e2b6821af57ccbfeb064d9e18b6e9e669aad238f2b0059df1a",
  "height": 886992,
  "confirmations": 192439,
  "time": 1692025132,
  "blocktime": 1692025132,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}
```

A special transaction (CbTx) in serialized transaction format:

```bash
dash-cli getrawtransaction \
  25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56
```

Result (wrapped):

```text
030005000100000000000000000000000000000000000000000000000000000000000\
00000ffffffff2703ae50011a4d696e656420627920416e74506f6f6c2021000b0120\
1da9196f0000000007000000ffffffff02809e4730000000001976a914cbd7bfcc503\
51180132b2c0698cb90ad74c473c788ac809e4730000000001976a91488a060bc2dfe\
05780ae4dcb6c98b12436c35a93988ac00000000460200ae50010078e5c08b3996088\
7bf95185c381bdb719e60b6925fa12af78a8824fade927387c757acb6bac63da84f92\
45e20cfd5d830382ac634d434725ca6349ab5db920a3
```

Get the same transaction in JSON:

```bash
dash-cli getrawtransaction \
25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56 \
1
```

Result:

```json
{
  "txid": "25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56",
  "version": 3,
  "type": 5,
  "size": 229,
  "locktime": 0,
  "vin": [
    {
      "coinbase": "03ae50011a4d696e656420627920416e74506f6f6c2021000b01201da9196f0000000007000000",
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 8.10000000,
      "valueSat": 810000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 cbd7bfcc50351180132b2c0698cb90ad74c473c7 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914cbd7bfcc50351180132b2c0698cb90ad74c473c788ac",
        "address": "yeuGUfPMrbEqAS2Pw1wonYgEPbM4LAA9LK",
        "type": "pubkeyhash"
      },
      "spentTxId": "1790b286922d1a439bdc056939bc902a222f9d66ee63d8427805617eedf835bd",
      "spentIndex": 83,
      "spentHeight": 94680
    },
    {
      "value": 8.10000000,
      "valueSat": 810000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 88a060bc2dfe05780ae4dcb6c98b12436c35a939 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91488a060bc2dfe05780ae4dcb6c98b12436c35a93988ac",
        "address": "yYmrsYP3XYMZr1cGtha3QzmuNB1C7CfyhV",
        "type": "pubkeyhash"
      }
    }
  ],
  "extraPayloadSize": 70,
  "extraPayload": "0200ae50010078e5c08b39960887bf95185c381bdb719e60b6925fa12af78a8824fade927387c757acb6bac63da84f9245e20cfd5d830382ac634d434725ca6349ab5db920a3",
  "cbTx": {
    "version": 2,
    "height": 86190,
    "merkleRootMNList": "877392defa24888af72aa15f92b6609e71db1b385c1895bf870896398bc0e578",
    "merkleRootQuorums": "a320b95dab4963ca2547434d63ac8203835dfd0ce245924fa83dc6bab6ac57c7"
  },
  "hex": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff2703ae50011a4d696e656420627920416e74506f6f6c2021000b01201da9196f0000000007000000ffffffff02809e4730000000001976a914cbd7bfcc50351180132b2c0698cb90ad74c473c788ac809e4730000000001976a91488a060bc2dfe05780ae4dcb6c98b12436c35a93988ac00000000460200ae50010078e5c08b39960887bf95185c381bdb719e60b6925fa12af78a8824fade927387c757acb6bac63da84f9245e20cfd5d830382ac634d434725ca6349ab5db920a3",
  "blockhash": "00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b",
  "height": 86190,
  "confirmations": 993241,
  "time": 1556114577,
  "blocktime": 1556114577,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true
}
```

_See also:_

* [GetRawTransactionMulti](../api/remote-procedure-calls-raw-transactions.md#getrawtransactionmulti): gets hex-encoded serialized transactions or a JSON object describing the transactions.
* [GetSpecialTxes](../api/remote-procedure-calls-blockchain.md#getspecialtxes): returns an array of special transactions found in the specified block
* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction.

## GetRawTransactionMulti

The [`getrawtransactionmulti` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransactionmulti) gets hex-encoded serialized transactions or a JSON object describing the transactions. This RPC returns the same type of information as the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction).

_Parameter #1---block hashes and transaction hash list_

| Name | Type         | Presence                | Description |
| ---- | ------------ | ----------------------- | ----------- |
| Transactions | object | Required<br>(exactly 1) | A JSON object with block hashes as keys and lists of transaction hashes as values (no more than 100 in total) |
|→<br>Block Hash | array | Required<br>(1 or more) | The block hash and the list of transaction ids to fetch. Note: if a block hash of `0` is provided, mempool transactions will be returned. |
|→ →<br>Transaction ID | string | Required<br>(1 or more) | A transaction ID |

_Parameter #2---whether to get the serialized or decoded transaction_

| Name    | Type | Presence             | Description |
| ------- | ---- | -------------------- | ----------- |
| Verbose | bool | Optional<br>(0 or 1) | Set to `false` (the default) to return the serialized transaction as hex.  Set to `true` to return a decoded transaction in JSON. |

_Result (if transactions not found)---`null`_

| Name     | Type | Presence                | Description |
| -------- | ---- | ----------------------- | ----------- |
| `result` | null | Required<br>(exactly 1) | If no transactions were found, the result will be JSON `null`.  This can occur because the transactions don't exist in the block chain or memory pool, or because it isn't part of the transaction index.  See the Dash Core `-help` entry for `-txindex` |

_Result (if verbose=`false`)---the serialized transactions_

| Name     | Type         | Presence                | Description |
| -------- | ------------ | ----------------------- | ----------- |
| `result` | object | Required<br>(exactly 1) | If the transaction was found, this will be an object containing the serialized transaction encoded as hex. |
|→<br>TXID / Raw tx | string:string | Required<br>(1 or more) | A key/value pair with the transaction ID (key) and raw transaction data (value). See the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#rpc-raw-txs-getrawtx-hex) for an example of the hex transaction data. |

_Result (if verbose=`true`)---the decoded transactions_

| Name                        | Type           | Presence                | Description |
| --------------------------- | -------------- | ----------------------- | ----------- |
| `result`                    | object         | Required<br>(exactly 1) | If the transaction was found, this will be an object describing it |
|→<br>TXID / Decoded tx | string:string | Required<br>(1 or more) | A key/value pair with the transaction ID (key) and decoded transaction data represented in JSON (value). See the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#rpc-raw-txs-getrawtx-decoded) for an example of the decoded transaction data. |

_Examples from Dash Core 20.1.0_

Transactions in serialized transaction format:

```bash
dash-cli -testnet getrawtransactionmulti '{"0000014b04deb0fe0884d3ca81a6239016c2a4838cd4b34494858630e457c62c": ["0667ab03bebb827057fcd55285d68dc10f30ef07dd04d1468c9f25888c22333c", "5c278dd4ca54b9c14789357f0311bcbf1b6d3182bcc76d229cb15cfbe6255ed0"]}' false
```

Result:

```json
{
  "0667ab03bebb827057fcd55285d68dc10f30ef07dd04d1468c9f25888c22333c": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff060373ad0e0101ffffffff0283706e04000000001976a914c69a0bda7daaae481be8def95e5f347a1d00a4b488ac89514b0d000000001976a91464f2b2b84f62d68a2cd7f7f5fb2b5aa75ef716d788ac00000000af030073ad0e00c63f1ca6d2a0570754d3851f70fae6215fa7741b3d4fd1d988e35add12b22827731b17f8cc2324ca927164dc67064a73aed41a19f418b05dcd57415a627ed9b90081a911644ec88204526c31b16666ba3f514caaaef72ce5bbaa4babb19f35bdd4ef1c7adefd414879f5805526fb9b9cd01566dc35d9599ed58e679373666e938ea0214c14368673f4e5b9766686b6d147ec567c4cd004766a0fa8f2280ab5494e9eca329808000000",
  "5c278dd4ca54b9c14789357f0311bcbf1b6d3182bcc76d229cb15cfbe6255ed0": "03000600000000000000fd4901010073ad0e00030001d0c2ab39e1fddbcdee48d2c2c2e807586603d6ff1b31189e46b95849eb00000032ffffffffffff0332ffffffffffff03a1f0b0ce837010f234e3b5906ac171adf25b46fb535e7de4831128c19dc9939a71039d227e355a9b47d7612dd0a3a3d51c588284eb43a9ba7b4f62589db5a16ae1b50305a16093fe5a7c8d9c6ab35e4e97021398ecabbf90ab1199e9c649c8abe65af1a77de449980720775ec2efda5cb1b0e23a002f32a2825f02b070c627e90220bb30a37dd4072ffebffeaa81ba5ca2335137a76da711c86b11666b7e8794846caf4170f9bb99b31f9837408f9f13a5b548cda8a6bf6c980f0351584079b5e4c710123217e7876c4bd2f935b6f098306cd75c07231780cd68e27e97283e37180372cd266ebba1e0c514bd6c304ae58c71c9b1653f4df6bc33553fa22adde4429cbc3ecb9eda76bd4d256eabbb98d4"
}
```

_See also:_

* [GetRawTransaction](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction): gets a hex-encoded serialized transaction or a JSON object describing the transaction.
* [GetSpecialTxes](../api/remote-procedure-calls-blockchain.md#getspecialtxes): returns an array of special transactions found in the specified block
* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction.

## GetTxChainlocks

The [`gettxchainlocks` RPC](../api/remote-procedure-calls-raw-transactions.md#gettxchainlocks) returns the block height each transaction was mined at and indicates whether it is in the mempool, ChainLocked, or neither.

_Parameter #1---Transaction IDs_

| Name   | Type   | Presence                | Description |
| ------ | ------ | ----------------------- | ----------- |
| `txids` | array  | Required<br>(exactly 1) | A JSON array of up to 100 transaction IDs |
| → Transaction ID | string | Required<br>(1 to 100) | A transaction hash |

_Result---transaction information_

| Name                 | Type         | Presence                | Description |
| -------------------- | ------- | ----------------------- | ----------- |
| `result`             | array   | Required<br>(exactly 1) | An array of objects providing transaction information for each transaction ID in the input array. |
| →<br>Transaction info | object | Optional<br>(0 or more) | An object containting transaction details |
| →<br>`height`        | number  | Required<br>(exactly 1) | Height of the block containing the transaction (-1 if the transaction is not in a block) |
| →<br>`chainlock`     | bool    | Required<br>(exactly 1) | ChainLock status for the block containing the transaction |
| →<br>`mempool`       | bool    | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br><br>Mempool status for the transaction |

_Example from Dash Core 20.1.0_

```bash
dash-cli -testnet gettxchainlocks "[\"d743b1ab2ff390bcc60b4672c293d95909989ca402fdea487f582b22da051ce8\", \"dd7a41e421c4f522353a8f91f077e15a1325518e60812d0c6c9995c1d61ab60e\"]"
```

Result:

```json
[
  {
    "height": 957527,
    "chainlock": true,
    "mempool": false
  },
  {
    "height": -1,
    "chainlock": false,
    "mempool": true
  }
]
```

*See also: none*

## JoinPSBTs

The [`joinpsbts` RPC](../api/remote-procedure-calls-raw-transactions.md#joinpsbts) joins multiple distinct PSBTs with different inputs and outputs into one PSBT with inputs and outputs from all of the PSBTs. No input in any of the PSBTs can be in more than one of the PSBTs.

_Parameter #1---Transactions_

| Name   | Type   | Presence                | Description                                                     |
| ------ | ------ | ----------------------- | --------------------------------------------------------------- |
| `txs`  | array  | Required<br>(exactly 1) | A JSON array of base64 strings of partially signed transactions |
| → PSBT | string | Required<br>(1 or more) | A PSBT base64 string                                            |

_Result---the combined raw transaction in base64_

| Name   | Type   | Presence                | Description                                           |
| ------ | ------ | ----------------------- | ----------------------------------------------------- |
| Result | string | Required<br>(Exactly 1) | The resulting raw transaction (base64-encoded string) |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet joinpsbts "[\"cHNidP8BAEICAAAAAfisRhf3kqdGJdB8vKvQz81ze9cH6bh0RKZfFTMsXatUAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=\", \"cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=\"]"
```

Result:

```
cHNidP8BAHoCAAAAAvisRhf3kqdGJdB8vKvQz81ze9cH6bh0RKZfFTMsXatUAAAAAAD/////eBHHNtKFSWK9UUqCgvKGTREIJgtkoJhOX+1hF37IYiYAAAAAAP////8CAAAAAAAAAAAGagQAAQIDAAAAAAAAAAAGagQAAQIDAAAAAAAAAAAA
```

_See also:_

* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.

## SendRawTransaction

The [`sendrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction) validates a transaction and broadcasts it to the peer-to-peer network.

_Parameter #1---a serialized transaction to broadcast_

| Name        | Type         | Presence                | Description                                            |
| ----------- | ------------ | ----------------------- | ------------------------------------------------------ |
| Transaction | string (hex) | Required<br>(exactly 1) | The serialized transaction to broadcast encoded as hex |

_Parameter #2--whether to allow high fees_

| Name         | Type   | Presence             | Description                                                                                                                                                                                                                                                                                                                            |
| ------------ | ------ | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `maxfeerate` | number | Optional<br>(0 or 1) | Reject transactions whose fee rate is higher than the specified value, expressed in DASH/kB. **Breaking change: parameter changed from `allowhighfees` to `maxfeerate` in Dash Core 18.0.0.** |

_Parameter #3--whether to use InstantSend_

| Name            | Type | Presence             | Description                                     |
| --------------- | ---- | -------------------- | ----------------------------------------------- |
| Use InstantSend | bool | Optional<br>(0 or 1) | _Deprecated and ignored since Dash Core 0.15.0_ |

_Parameter #4--whether to bypass policy limits_

| Name          | Type | Presence             | Description                      |
| ------------- | ---- | -------------------- | -------------------------------- |
| Bypass Limits | bool | Optional<br>(0 or 1) | Bypass transaction policy limits |

_Result---a TXID or error message_

| Name     | Type              | Presence                | Description                                                                                                                                                                                                                                                                                                                          |
| -------- | ----------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result` | null/string (hex) | Required<br>(exactly 1) | If the transaction was accepted by the node for broadcast, this will be the TXID of the transaction encoded as hex in RPC byte order.  If the transaction was rejected by the node, this will set to `null`, the JSON-RPC error field will be set to a code, and the JSON-RPC message field may contain an informative error message |

_Examples from Dash Core 0.12.2_

Broadcast a signed transaction:

```bash
dash-cli -testnet sendrawtransaction 01000000016b490886c0198b\
028c6c5cb145c4eb3b1055a224a7a105aadeff41b69ec91e0601000000694630\
43022033a61c56fa0867ed67b76b023204a9dc0ee6b0d63305dc5f65fe943354\
45ff2f021f712f55399d5238fc7146497c431fc4182a1de0b96fc22716e0845f\
561d542e012102eacba539d92eb88d4e73bb32749d79f53f6e8d7947ac40a71b\
d4b26c13b6ec29ffffffff0200205fa0120000001976a914485485425fa99504\
ec1638ac4213f3cfc9f32ef388acc0a8f9be010000001976a914811eacc14db8\
ebb5b64486dc43400c0226b428a488ac00000000
```

Result:

```text
2f124cb550d9967b81914b544dea3783de23e85d67a9816f9bada665ecfe1cd5
```

_See also:_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.

## SignRawTransactionWithKey

The [`signrawtransactionwithkey` RPC](#signrawtransactionwithkey) signs inputs for a transaction in the serialized transaction format using private keys provided in the call.

_Parameter #1---the transaction to sign_

| Name        | Type         | Presence                | Description                                         |
| ----------- | ------------ | ----------------------- | --------------------------------------------------- |
| Transaction | string (hex) | Required<br>(exactly 1) | The transaction to sign as a serialized transaction |

_Parameter #2---private keys for signing_

| Name         | Type            | Presence                | Description                                                                                                                                                                                                                                                  |
| ------------ | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Private Keys | array           | Required<br>(exactly 1) | An array holding private keys.  If any keys are provided, only they will be used to sign the transaction (even if the wallet has other matching keys).  If this array is empty or not used, and wallet support is enabled, keys from the wallet will be used |
| →<br>Key     | string (base58) | Required<br>(1 or more) | A private key in base58check format to use to create a signature for this transaction                                                                                                                                                                        |

_Parameter #3---unspent transaction output details_

| Name                  | Type         | Presence                | Description                                                                                            |
| --------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------ |
| Dependencies          | array        | Optional<br>(0 or 1)    | The previous outputs being spent by this transaction                                                   |
| →<br>Output           | object       | Optional<br>(0 or more) | An output being spent                                                                                  |
| → →<br>`txid`         | string (hex) | Required<br>(exactly 1) | The TXID of the transaction the output appeared in.  The TXID must be encoded in hex in RPC byte order |
| → →<br>`vout`         | number (int) | Required<br>(exactly 1) | The index number of the output (vout) as it appeared in its transaction, with the first output being 0 |
| → →<br>`scriptPubKey` | string (hex) | Required<br>(exactly 1) | The output's pubkey script encoded as hex                                                              |
| → →<br>`redeemScript` | string (hex) | Optional<br>(0 or 1)    | If the pubkey script was a script hash, this must be the corresponding redeem script                   |
| → →<br>`amount`       | numeric      | Required<br>(exactly 1) | The amount of Dash spent                                                                               |

_Parameter #4---signature hash type_

| Name    | Type   | Presence             | Description                                                                                                                                                                                                                                                                                                                                                |
| :------ | :----- | :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SigHash | string | Optional<br>(0 or 1) | The type of signature hash to use for all of the signatures performed.  (You must use separate calls to the [`signrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#signrawtransactionwithkey) if you want to use different signature hash types for different signatures.  The allowed values are: `ALL`, `NONE`, `SINGLE`, `ALL \| ANYONECANPAY`,`NONE \| ANYONECANPAY`, and `SINGLE \| ANYONECANPAY` |

_Result---the transaction with any signatures made_

| Name            | Type         | Presence                | Description                                                                                                                                                                                            |
| --------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result`        | object       | Required<br>(exactly 1) | The results of the signature                                                                                                                                                                           |
| →<br>`hex`      | string (hex) | Required<br>(exactly 1) | The resulting serialized transaction encoded as hex with any signatures made inserted.  If no signatures were made, this will be the same transaction provided in parameter #1                         |
| →<br>`complete` | bool         | Required<br>(exactly 1) | The value `true` if transaction is fully signed; the value `false` if more signatures are required. Once `true` the transaction can be sent using the [`sendrawtransaction` RPC](#sendrawtransaction). |

_Example from Dash Core 0.17.0_

Sign the raw transaction hex generated from the [`createrawtransaction` RPC](#createrawtransaction):

```bash
dash-cli -testnet signrawtransactionwithkey 020000000121f39228a11ddf197ac3658e\
93bd264d0afd927f0cdfc7caeb760537e529c94a0100000000ffffffff01809698000000000019\
76a914fe64a96d6660e30c433e1189082466a95bdf9ceb88ac00000000 \
[\"cSxm6ji1SQ7vF1r8QhcsE1AZ42ZJqs5CEAAnD18iV18ZCQ2u3gGa\"]
```

Result:

```json
{
  "hex": "020000000121f39228a11ddf197ac3658e93bd264d0afd927f0cdfc7caeb760537e529c94a010000006b483045022100811c5679ef097b0e5a338fc3cd05ee50e1802680ea8a172d0fd3a81da3c1fc2002204804b18a44e888ac1ee9b6a7cbadc211ecdc30f8c889938c95125206e39554220121025d81ce6581e547dd34194385352053abb17f0246768d75443b25ded5e37d594fffffffff0180969800000000001976a914fe64a96d6660e30c433e1189082466a95bdf9ceb88ac00000000",
  "complete": true
}
```

_See also:_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.

## TestMemPoolAccept

The [`testmempoolaccept` RPC](../api/remote-procedure-calls-raw-transactions.md#testmempoolaccept) returns the results of mempool acceptance tests indicating if raw transaction (serialized, hex-encoded) would be accepted by mempool.

_Parameter #1---raw txs_

| Name     | Type  | Presence                | Description |
| -------- | ----- | ----------------------- | ----------- |
| `rawtxs` | array | Required<br>(exactly 1) | An array of hex strings of raw transactions (the length must be one for now) |

_Parameter #2---set max fee rate_

| Name         | Type   | Presence             | Description |
| ------------ | ------ | -------------------- | ----------- |
| `maxfeerate` | number | Optional<br>(0 or 1) | Reject transactions whose fee rate is higher than the specified value, expressed in DASH/kB. Changed from `allowhighfees` in Dash Core 18.0.0. |

_Result---mempool acceptance test results_

| Name                 | Type         | Presence                | Description |
| -------------------- | ------------ | ----------------------- | ----------- |
| `result`             | array        | Required<br>(exactly 1) | The result of the mempool acceptance test for each raw transaction in the input array. |
| →<br>`txid`          | string (hex) | Required<br>(exactly 1) | The TXID of the transaction the output appeared in.  The TXID must be encoded in hex in RPC byte order |
| `package-error` | string | Optional<br>(0 or 1) | Package validation error, if any (only possible if rawtxs had more than 1 transaction). |
| →<br>`allowed`       | bool         | Required<br>(exactly 1) | Whether this tx would be accepted to the mempool and pass client-specified maxfeerate. If not present, the tx was not fully validated due to a failure in another tx in the list. |
| `vsize`         | number (int) | Required<br>(exactly 1) | Virtual transaction size. |
| `fees`          | object       | Optional<br>(0 or 1)    | Transaction fees (only present if 'allowed' is true). |
| →<br>`base`     | number       | Required<br>(exactly 1) | Transaction fee in DASH. |
| →<br>`reject-reason` | string       | Optional<br>(0 or 1)    | A rejection string that is only present when 'allowed' is false. |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet testmempoolaccept [\"020000000234a2863f9781a7200330e700e684804bb2407d225c4e940c9cfb772f22fc0748000000006a47304402203b5a7899b6be2f33d30c1a71940c51f38074f4224a1ad6dee03dcc65f8646072022050d711115cd7291c2f094e3a3cfda14441721b1438e406b963b5660274ba4475012103e2fe477e31365d784d98514c7c9294283620d4a9775f01da5d3ba52f4c7286f5feffffff34a2863f9781a7200330e700e684804bb2407d225c4e940c9cfb772f22fc0748010000006a473044022018901985d2c94492111a45ed51bac88e02f1bb4a8382eacf5f474d70878c19f4022046e309e548f95a64b05e8ef70fae0ff86bf83cbed3055591580e0b5f5597c3a2012103109325a92f9e6d31d2ebd0595d471275ae8d635db2a0c42358f387e1af69c14dfeffffff020f530f00000000001976a9145799a5df43d34b05cdf03347af9102b67a6d154a88ac00e1f505000000001976a91464d51a27c8b8434458bac0193039bae55ca023c388ac151c0900\"]
```

Result:

```json
[
  {
    "txid": "06464b9c80413a49ab3c618f769a11647b6011f9ad15094eb423916ae5bc0c23",
    "allowed": false,
    "reject-reason": "18: txn-already-in-mempool"
  }
]
```

_See also:_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.
* [SignRawTransactionWithKey](#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.

## UTXOUpdatePSBT

The [`utxoupdatepsbt` RPC](../api/remote-procedure-calls-raw-transactions.md#utxoupdatepsbt) updates a PSBT with  data from output descriptors, UTXOs retrieved from the UTXO set or the mempool.

_Parameter #1---psbt_

| Name | Type   | Presence | Description               |
| ---- | ------ | -------- | ------------------------- |
| psbt | string | Required | A base64 string of a PSBT |

_Parameter #2---descriptors_

| Name                               | Type             | Presence                | Description                                                                              |
| ---------------------------------- | ---------------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| psbt                               | array            | Optional<br>(0 or 1)    | An array of either strings or objects                                                    |
| →<br>Output descriptor             | string           | Optional<br>(0 or 1)    | An output descriptor                                                                     |
| →<br>Output object                 | object           | Optional<br>(0 or 1)    | An object with an output descriptor and extra information                                |
| → →<br>`desc`                      | string           | Required<br>(exactly 1) | An output descriptor                                                                     |
| → →<br>`range`<br>(`n` or `[n,n]`) | numeric or array | Optional<br>(0 or 1)    | Up to what index HD chains should be explored (either end or [begin,end]) (default=1000) |

_Result---the raw transaction in base64_

| Name   | Type   | Presence                | Description                                           |
| ------ | ------ | ----------------------- | ----------------------------------------------------- |
| Result | string | Required<br>(Exactly 1) | The resulting raw transaction (base64-encoded string) |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet utxoupdatepsbt cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=
```

Result:

```
cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA=
```

_See also:_

* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs.
