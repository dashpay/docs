## Check documentation against Core help output

Compare this documentation
```
INSERT MARKDOWN TABLE FROM DOCS HERE
```

With the actual help output
```
INSERT "HELP <RPCNAME>" OUTPUT HERE
```

Only list any discrepancies (including parameters and/or response fields that have changed to be deprecated) and output markdown table entries in a copyable code block for items missing from the documentation. Use field descriptions from the provided help output without modifying them.

## Remove the excess whitespace at the end of tables

Remove the whitespace padding from the last column of this markdown table. do not worry about alignment of the end of the line but do include the ending "|" with a single space before it

## Create documentation for a new RPC

Use this RPC documentation as a template to create documentation for new RPCs:

```## ImportMulti

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**). Wallet must be unlocked.
:::

_Added in Dash Core 0.12.3 / Bitcoin Core 0.14.0_

The [`importmulti` RPC](../api/remote-procedure-calls-wallet.md#importmulti) imports addresses or scripts (with private keys, public keys, or P2SH redeem scripts) and optionally performs the minimum necessary rescan for all imports.

_Parameter #1---the addresses/scripts to import_

| Name                  | Type                  | Presence                | Description|
| --------------------- | --------------------- | ----------------------- | -----------|
| Imports               | array                 | Required<br>(exactly 1) | An array of JSON objects, each one being an address or script to be imported |
| → Import              | object                | Required<br>(1 or more) | A JSON object describing a particular import |
| → →<br>`scriptPubKey` | string (hex)          | Optional<br>(0 or 1)    | The script (string) to be imported. Must have either this field or `address` below |
| → →<br>`address`      | string (base58)       | Optional<br>(0 or 1)    | The P2PKH or P2SH address to be imported. Must have either this field or `scriptPubKey` above |
| → →<br>`timestamp`    | number (int) / string | Required<br>(exactly 1) | The creation time of the key in Unix epoch time or the string “now” to substitute the current synced block chain time. The timestamp of the oldest key will determine how far back block chain rescans need to begin. Specify `now` to bypass scanning for keys which are known to never have been used. Specify `0` to scan the entire block chain. Blocks up to 2 hours before the earliest key creation time will be scanned |
| → →<br>`redeemscript` | string                | Optional<br>(0 or 1)    | A redeem script. Only allowed if either the `address` field is a P2SH address or the `scriptPubKey` field is a P2SH scriptPubKey |
| → →<br>`pubkeys`      | array                 | Optional<br>(0 or 1)    | Array of strings giving pubkeys that must occur in the scriptPubKey or redeemscript |
| → →<br>`keys`         | array                 | Optional<br>(0 or 1)    | Array of strings giving private keys whose corresponding public keys must occur in the scriptPubKey or redeemscript |
| → →<br>`internal`     | bool                  | Optional<br>(0 or 1)    | Stating whether matching outputs should be treated as change rather than incoming payments. The default is `false` |
| → →<br>`watchonly`    | bool                  | Optional<br>(0 or 1)    | Stating whether matching outputs should be considered watched even when they're not spendable. This is only allowed if keys are empty. The default is `false` |
| → →<br>`label`        | string                | Optional<br>(0 or 1)    | Label to assign to the address, only allowed with `internal` set to `false`. The default is an empty string (“”) |

_Parameter #2---options regarding the import_

| Name           | Type   | Presence             | Description |
| -------------- | ------ | -------------------- | ----------- |
| Option         | object | Optional<br>(0 or 1) | JSON object with options regarding the import |
| → <br>`rescan` | bool   | Optional<br>(0 or 1) | Set to `true` (the default) to rescan the entire local block chain for transactions affecting any imported address or script. Set to `false` to not rescan after the import. Rescanning may take a considerable amount of time and may require re-downloading blocks if using block chain pruning |

_Result---execution result_

| Name                | Type            | Presence                | Description                                                                               |
| ------------------- | --------------- | ----------------------- | ----------------------------------------------------------------------------------------- |
| `result`            | array           | Required<br>(exactly 1) | An array of JSON objects, with each object describing the execution result of each import |
| → Result            | object          | Required<br>(1 or more) | A JSON object describing the execution result of an imported address or script            |
| → → <br>`success`   | string          | Required<br>(exactly 1) | Displays `true` if the import has been successful or `false` if it failed                 |
| → → <br>`error`     | string : object | Optional<br>(0 or 1)    | A JSON object containing details about the error. Only displayed if the import fails      |
| → → → <br>`code`    | number (int)    | Optional<br>(0 or 1)    | The error code                                                                            |
| → → → <br>`message` | string          | Optional<br>(0 or 1)    | The error message                                                                         |

_Example from Dash Core 0.12.3_

Import the address `ycCsAUKsjdmoP4qAXiS1cjYA4ixM48zJWe` (giving it a label and scanning the entire block chain) and the scriptPubKey `76a9146cf5870411edc31ba5630d61c7cddff55b884fda88ac` (giving a specific timestamp and label):

```bash
dash-cli importmulti '
  [
    {
      "scriptPubKey" : { "address": "ycCsAUKsjdmoP4qAXiS1cjYA4ixM48zJWe" },
      "timestamp" : 0,
      "label" : "Personal"
    },
    {
      "scriptPubKey" : "76a9146cf5870411edc31ba5630d61c7cddff55b884fda88ac",
      "timestamp" : 1493912405,
      "label" : "TestFailure"
    }
  ]' '{ "rescan": true }'
```

Result (scriptPubKey import failed because `internal` was not set to `true`):

```json
[
  {
    "success": true
  },
  {
    "success": false,
    "error": {
      "code": -8,
      "message": "Internal must be set for hex scriptPubKey"
    }
  }
]
```

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.
```


Create documentation for the following new RPC using the style of previously provided RPC documentation as a template:

```
INSERT "HELP <RPCNAME>" OUTPUT HERE
```
