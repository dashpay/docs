```{eval-rst}
.. meta::
  :title: Address Index RPCs
  :description: A list of all the Address Index RPCs in Dash.
```

# Address Index RPCs

## GetAddressBalance

:::{note}
Requires `-addressindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

The [`getaddressbalance` RPC](../api/remote-procedure-calls-address-index.md#getaddressbalance) returns the balance for address(es).

*Parameter #1---an array of [addresses](../resources/glossary.md#address)*

Name | Type | Presence | Description
--- | --- | --- | ---
`addresses` | object | Required<br>(exactly 1) | An array of P2PKH or P2SH Dash address(es)
→Address | string (base58) | Required<br>(1 or more) | The base58check encoded address

*Result---the current balance in [duffs](../resources/glossary.md#duffs) and the total number of duffs received (including change)*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | An object listing the current balance and total amount received (including change), or an error if any address is invalid
→<br>`balance` | string | Required<br>(exactly 1) | The current balance in duffs
→<br>`balance_immature` | string | Required<br>(exactly 1) | The current immature balance in duffs
→<br>`balance_spendable` | string | Required<br>(exactly 1) | The current spendable balance in duffs
→<br>`received` | string | Required<br>(exactly 1) | The total number of duffs received (including change)

*Example from Dash Core 0.17.0*

Get the balance for an address:

```bash
dash-cli getaddressbalance '{"addresses": ["yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ"]}'
```

Result:

```json
{
  "balance": 876020488,
  "balance_immature": 776020488,
  "balance_spendable": 100000000,
  "received": 876020488
}
```

*See also*

* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account.
* [GetUnconfirmedBalance](../api/remote-procedure-calls-wallet.md#getunconfirmedbalance): returns the wallet's total unconfirmed balance.

## GetAddressDeltas

:::{note}
Requires `-addressindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

The [`getaddressdeltas` RPC](../api/remote-procedure-calls-address-index.md#getaddressdeltas) returns all changes for an address.

*Parameter #1---an array of addresses*

Name | Type | Presence | Description
--- | --- | --- | ---
`addresses` | object | Required<br>(exactly 1) | An array of P2PKH or P2SH Dash address(es)
→Address | string (base58) | Required<br>(1 or more) | The base58check encoded address

*Parameter #2---the start block height*

Name | Type | Presence | Description
--- | --- | --- | ---
`start` | number (int) | Optional<br>(exactly 1) | The start block height

*Parameter #3---the end block height*

Name | Type | Presence | Description
--- | --- | --- | ---
`end` | number (int) | Optional<br>(exactly 1) | The end block height

*Result---information about all changes for the address(es)*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of JSON objects, with each object describing a transaction involving one of the requested addresses
→<br>Delta | object | Required<br>(1 or more) | An object describing a particular address delta
→→<br>`satoshis` | number | Required<br>(exactly 1) | The difference of duffs
→→<br>`txid` | string | Required<br>(exactly 1) | The related txid
→→<br>`blockindex` | number | Required<br>(exactly 1) | The related input or output index
→→<br>`height` | number | Required<br>(exactly 1) | The block height
→→<br>`address` | string | Required<br>(exactly 1) | The base58check encoded address

*Example from Dash Core 0.12.2*

Get the deltas for an address:

```bash
dash-cli getaddressdeltas '{"addresses": ["yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ"], "start":5000, "end":7500}'
```

Result:

```json
[
  {
    "satoshis": 10000100,
    "txid": "1fe86e463a9394d4ccd9a5ff1c6b483c95b4350ffdb055b55dc3615111e977de",
    "index": 18,
    "blockindex": 1,
    "height": 6708,
    "address": "yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ"
  },
  {
    "satoshis": -10000100,
    "txid": "6cb4379eec45cd3bb08b8f4c3a101b8cd89795e24f2cb8288a9941a85fb114cf",
    "index": 0,
    "blockindex": 1,
    "height": 7217,
    "address": "yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ"
  }
]
```

## GetAddressMempool

:::{note}
Requires `-addressindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

The [`getaddressmempool` RPC](../api/remote-procedure-calls-address-index.md#getaddressmempool) returns all mempool deltas for an address.

*Parameter #1---an array of addresses*

Name | Type | Presence | Description
--- | --- | --- | ---
`addresses` | object | Required<br>(exactly 1) | An array of P2PKH or P2SH Dash address(es)
→Address | string (base58) | Required<br>(1 or more) | The base58check encoded address

*Result---information about mempool deltas for the address(es)*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of JSON objects, with each object describing a transaction involving one of the requested addresses
→Mempool Deltas | object | Required<br>(1 or more) | An object describing a particular mempool address delta
→→<br>`address` | string | Required<br>(exactly 1) | The base58check encoded address
→→<br>`txid` | string | Required<br>(exactly 1) | The related txid
→→<br>`index` | number | Required<br>(exactly 1) | The related input or output index
→→<br>`satoshis` | number | Required<br>(exactly 1) | The difference of duffs
→→<br>`timestamp` | string | Required<br>(exactly 1) | The time the transaction entered the mempool (seconds)
→→<br>`prevtxid` | string | Required<br>(exactly 1) | The previous txid (if spending)
→→<br>`prevout` | string | Required<br>(exactly 1) | The previous transaction output index (if spending)

*Example from Dash Core 0.12.2*

Get the deltas for an address:

```bash
dash-cli getaddressmempool '{"addresses": ["yVcYtcKd3nSi85JFtE8ZSDPimj3VMTJB8k"]}'
```

Result:

```json
[
  {
    "address": "yVcYtcKd3nSi85JFtE8ZSDPimj3VMTJB8k",
    "txid": "e53d871df8b26116fbc1b766172323f9c477375133eec8ea5c66f1867a61a533",
    "index": 1,
    "satoshis": 100000000000,
    "timestamp": 1573753889
  }
]
```

## GetAddressTxids

:::{note}
Requires `-addressindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

The [`getaddresstxids` RPC](../api/remote-procedure-calls-address-index.md#getaddresstxids) returns the txids for an address(es).

*Parameter #1---an array of addresses*

Name | Type | Presence | Description
--- | --- | --- | ---
`addresses` | object | Required<br>(exactly 1) | An array of P2PKH or P2SH Dash address(es)
→Address | string (base58) | Required<br>(1 or more) | The base58check encoded address

*Parameter #2---the start block height*

Name | Type | Presence | Description
--- | --- | --- | ---
`start` | number (int) | Optional<br>(exactly 1) | The start block height

*Parameter #3---the end block height*

Name | Type | Presence | Description
--- | --- | --- | ---
`end` | number (int) | Optional<br>(exactly 1) | The end block height

*Result---information about txids for the address(es)*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of txids related to the requested address(es)
→<br>TXID | string | Required<br>(1 or more) | The transaction id

*Example from Dash Core 0.12.2*

Get the deltas for an address:

```bash
dash-cli getaddresstxids '{"addresses": ["yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ"], "start":5000, "end":7500}'
```

Result:

```json
[
  "1fe86e463a9394d4ccd9a5ff1c6b483c95b4350ffdb055b55dc3615111e977de",
  "6cb4379eec45cd3bb08b8f4c3a101b8cd89795e24f2cb8288a9941a85fb114cf"
]
```

## GetAddressUtxos

:::{note}
Requires `-addressindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

The [`getaddressutxos` RPC](../api/remote-procedure-calls-address-index.md#getaddressutxos) returns all unspent outputs for an address.

*Parameter #1---an array of addresses*

Name | Type | Presence | Description
--- | --- | --- | ---
`addresses` | object | Required<br>(exactly 1) | An array of P2PKH or P2SH Dash address(es)
→Address | string (base58) | Required<br>(1 or more) | The base58check encoded address

*Result---information about unspent outputs for the address(es)*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of JSON objects, with each object describing a transaction involving one of the requested addresses
→Unspent outputs | object | Required<br>(1 or more) | An object describing a particular unspent output for the requested address(es)
→→<br>`address` | string | Required<br>(exactly 1) | The base58check encoded address
→→<br>`txid` | string | Required<br>(exactly 1) | The output txid
→→<br>`outputIndex` | number | Required<br>(exactly 1) | The output index
→→<br>`script` | string | Required<br>(exactly 1) | The script hex encoded
→→<br>`satoshis` | number | Required<br>(exactly 1) | The number of duffs of the output
→→<br>`height` | number | Required<br>(exactly 1) | The block height

*Example from Dash Core 0.12.2*

Get the unspent outputs for an address:

```bash
dash-cli getaddressutxos '{"addresses": ["yLeC3F9UxJmFaRaf5yzH7FDc7RdvBasi84"]}'
```

Result:

```json
[
  {
    "address": "yLeC3F9UxJmFaRaf5yzH7FDc7RdvBasi84",
    "txid": "ef7bcd083db8c9551ca295698c3b7a6811288fae9944018d2a660a0f939bdb35",
    "outputIndex": 0,
    "script": "76a914038b8a73338c8f9c22024338198d63ff7c4cb4c088ac",
    "satoshis": 1000010000,
    "height": 7683
  }
]
```
