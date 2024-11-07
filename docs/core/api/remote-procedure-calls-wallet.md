```{eval-rst}
.. meta::
  :title: Wallet RPCs
  :description: A list of remote procedure calls in Dash that are used to perform wallet operations such as sending, creating and categorizing addresses, etc. 
```

# Wallet RPCs

:::{attention}
RPCs that require wallet support are **not available on masternodes** for security reasons. Such RPCs are designated with a "_Requires wallet support_" message.
:::

## AbandonTransaction

_Added in Bitcoin Core 0.12.0_

The [`abandontransaction` RPC](../api/remote-procedure-calls-wallet.md#abandontransaction) marks an in-wallet transaction and all its in-wallet descendants as abandoned. This allows their inputs to be respent.

_Parameter #1---a transaction identifier (TXID)_

| Name | Type         | Presence                | Description                                                                                              |
| ---- | ------------ | ----------------------- | -------------------------------------------------------------------------------------------------------- |
| TXID | string (hex) | Required<br>(exactly 1) | The TXID of the transaction that you want to abandon.  The TXID must be encoded as hex in RPC byte order |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                         |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | JSON `null` when the transaction and all descendants were abandoned |

_Example from Dash Core 0.12.2_

Abandons the transaction on your node.

```bash
dash-cli abandontransaction fa3970c341c9f5de6ab13f128cbfec58d732e736a505fe32137ad551c799ecc4
```

Result (no output from `dash-cli` because result is set to `null`).

_See also_

* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.

## AbortRescan

The [`abortrescan` RPC](../api/remote-procedure-calls-wallet.md#abortrescan) Stops current wallet rescan

Stops current wallet rescan triggered e.g. by an [`importprivkey` RPC](../api/remote-procedure-calls-wallet.md#importprivkey) call.

_Parameters: none_

_Result---`true` on success_

| Name     | Type | Presence                | Description                                                          |
| -------- | ---- | ----------------------- | -------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | `true` when the command was successful or `false` if not successful. |

_Example from Dash Core 0.15.0_

Abort the running wallet rescan

```bash
dash-cli -testnet abortrescan
```

Result:

```text
true
```

_See also: none_

## AddMultiSigAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`addmultisigaddress` RPC](../api/remote-procedure-calls-wallet.md#addmultisigaddress) adds a P2SH multisig address to the wallet. Each key is a Dash address or hex-encoded public key. This functionality is only intended for use with non-watchonly addresses. See [`importaddress` RPC](../api/remote-procedure-calls-wallet.md#importaddress) for watchonly p2sh address support. If 'label' is specified, assign address to that label.

_Parameter #1---the number of signatures required_

| Name     | Type         | Presence                | Description                                                                          |
| -------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------ |
| Required | number (int) | Required<br>(exactly 1) | The minimum (_m_) number of signatures required to spend this m-of-n multisig script |

_Parameter #2---the full public keys, or addresses for known public keys_

| Name                | Type   | Presence                | Description                                                                                                                                                                                                                                                                            |
| ------------------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Keys Or Addresses   | array  | Required<br>(exactly 1) | An array of strings with each string being a public key or address                                                                                                                                                                                                                     |
| →<br>Key Or Address | string | Required<br>(1 or more) | A public key against which signatures will be checked.  Alternatively, this may be a P2PKH address belonging to the wallet---the corresponding public key will be substituted.  There must be at least as many keys as specified by the Required parameter, and there may be more keys |

_Parameter #3---label_

| Name  | Type   | Presence             | Description                         |
| ----- | ------ | -------------------- | ----------------------------------- |
| Label | string | Optional<br>(0 or 1) | A label to assign the addresses to. |

_Result---P2SH address and hex-encoded redeem script_

| Name                | Type            | Presence                | Description                                      |
| ------------------- | --------------- | ----------------------- | ------------------------------------------------ |
| `result`            | object          | Required<br>(exactly 1) | An object describing the multisig address        |
| →<br>`address`      | string (base58) | Required<br>(exactly 1) | The P2SH address for this multisig redeem script |
| →<br>`redeemScript` | string (hex)    | Required<br>(exactly 1) | The multisig redeem script encoded as hex        |

_Example from Dash Core 20.0.0_

Adding a 1-of-2 P2SH multisig address with the label "test label" by combining one P2PKH address and one full public key:

```bash
dash-cli -testnet -rpcwallet="" addmultisigaddress 1 '''
  [
    "ySxkBWzPwMrZLAY9ZPitMnSwf4NSUBPbiH",
    "02594523b004e82849a66b3da096b1e680bf2ed5f7d03a3443c027aa5777bb6223"
  ]
'''  'test label'
```

Result:

```json
{
  "address": "8jYUv8hJcbSUPbwYmzp1XMPU6SXoic3hwi",
  "redeemScript": "512103283a224c2c014d1d0ef82b00470b6b277d71e227c0e2394f9baade5d666e57d32102594523b004e82849a66b3da096b1e680bf2ed5f7d03a3443c027aa5777bb622352ae",
  "descriptor": "sh(multi(1,[48de9d39]03283a224c2c014d1d0ef82b00470b6b277d71e227c0e2394f9baade5d666e57d3,[dec361f1]02594523b004e82849a66b3da096b1e680bf2ed5f7d03a3443c027aa5777bb6223))#vtc5zmh2"
}
```

(New P2SH multisig address also stored in wallet.)

_See also_

* [CreateMultiSig](../api/remote-procedure-calls-util.md#createmultisig): creates a P2SH multi-signature address.
* [DecodeScript](../api/remote-procedure-calls-raw-transactions.md#decodescript): decodes a hex-encoded P2SH redeem script.

## BackupWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`backupwallet` RPC](../api/remote-procedure-calls-wallet.md#backupwallet) safely copies `wallet.dat` to the specified file, which can be a directory or a path with filename.

_Parameter #1---destination directory or filename_

| Name        | Type   | Presence                | Description                                                                                                                                                                       |
| ----------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Destination | string | Required<br>(exactly 1) | A filename or directory name.  If a filename, it will be created or overwritten.  If a directory name, the file `wallet.dat` will be created or overwritten within that directory |

_Result---`null` or error_

| Name     | Type | Presence                | Description                                                                                                        |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `result` | null | Required<br>(exactly 1) | Always `null` whether success or failure.  The JSON-RPC error and message fields will be set if a failure occurred |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet backupwallet /tmp/backup.dat
```

_See also_

* [DumpWallet](../api/remote-procedure-calls-wallet.md#dumpwallet): creates or overwrites a file with all wallet keys in a human-readable format.
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.

## CreateWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`createwallet` RPC](../api/remote-procedure-calls-wallet.md#createwallet) creates and loads a new wallet.

_Parameter #1---wallet name_

| Name          | Type   | Presence                | Description                                                                                      |
| ------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------ |
| `wallet_name` | string | Required<br>(exactly 1) | The name for the new wallet. If this is a path, the wallet will be created at the path location. |

_Parameter #2---disable private keys_

| Name                   | Type | Presence             | Description                                                                         |
| ---------------------- | ---- | -------------------- | ----------------------------------------------------------------------------------- |
| `disable_private_keys` | bool | Optional<br>(0 or 1) | Disable the possibility of private keys. Only watchonlys are possible in this mode. |

_Parameter #3---blank_

| Name    | Type | Presence             | Description                                                                                                        |
| ------- | ---- | -------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `blank` | bool | Optional<br>(0 or 1) | Create a blank wallet. A blank wallet has no keys or HD seed. Use [`upgradetohd`](#upgradetohd) (mnemonic) or [`sethdseed`](#sethdseed) (WIF private key) to add an HD seed. |

_Parameter #4---passphrase_

| Name         | Type   | Presence             | Description                              |
| ------------ | ------ | -------------------- | ---------------------------------------- |
| `passphrase` | string | Optional<br>(0 or 1) | Encrypt the wallet with this passphrase. |

_Parameter #5---avoid coin reuse_

| Name          | Type | Presence             | Description                                                                                                |
| ------------- | ---- | -------------------- | ---------------------------------------------------------------------------------------------------------- |
| `avoid_reuse` | bool | Optional<br>(0 or 1) | Keep track of coin reuse, and treat dirty and clean coins differently with privacy considerations in mind. |

_Parameter #6---descriptors_

| Name          | Type | Presence             | Description                                                                                                                |
| ------------- | ---- | -------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `descriptors` | bool | Optional<br>(0 or 1) | Create a native descriptor wallet. The wallet will use descriptors internally to handle address creation.                   |

_Parameter #7---load on startup_

| Name              | Type | Presence             | Description                                                                                                                                |
| ----------------- | ---- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `load_on_startup` | bool | Optional<br>(0 or 1) | Save wallet name to persistent settings and load on startup. True to add wallet to startup list, false to remove, null to leave unchanged. |

_Result---wallet name and any warnings_

| Name           | Type   | Presence                | Description                                                                                                                   |
| -------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `result`       | object | Required<br>(exactly 1) | An object containing information about wallet creation                                                                        |
| →<br>`name`    | string | Required<br>(exactly 1) | The wallet name if created successfully. If the wallet was created using a full path, the `wallet_name` will be the full path |
| →<br>`warning` | string | Required<br>(exactly 1) | Warning message if wallet was not loaded cleanly.                                                                             |

_Example from Dash Core 0.17.0_

```bash
dash-cli -testnet createwallet new-wallet
```

Result:

```json
{
  "name": "new-wallet",
  "warning": ""
}
```

:::{note}
In the example above, a new directory named `new-wallet` was created in the current data directory (`~/.dashcore/testnet3/`). This new directory contains the wallet.dat file and other related wallet files for the new wallet.
:::

_See also_

* [LoadWallet](../api/remote-procedure-calls-wallet.md#loadwallet): loads a wallet from a wallet file or directory.

## DumpHDInfo

The [`dumphdinfo` RPC](../api/remote-procedure-calls-wallet.md#dumphdinfo) returns an object containing sensitive private info about this HD wallet

_Parameters: none_

_Result---HD wallet information_

| Name                       | Type   | Presence                | Description                                                       |
| -------------------------- | ------ | ----------------------- | ----------------------------------------------------------------- |
| Result                     | object | Required<br>(exactly 1) | An object containing sensitive private info about this HD wallet. |
| → <br>`hdseed`             | string | Required<br>(exactly 1) | The BIP-32 HD seed (in hex)                                       |
| → <br>`mnemonic`           | string | Required<br>(exactly 1) | The BIP-39 mnemonic for this HD wallet (English words)            |
| → <br>`mnemonicpassphrase` | string | Required<br>(exactly 1) | The BIP-39 mnemonic passphrase for this HD wallet (may be empty)  |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet dumphdinfo
```

Result (truncated for security reasons):

```json
{
  "hdseed": "20c63c3fb298ebd52de3 ...",
  "mnemonic": "cost circle shiver ...",
  "mnemonicpassphrase": ""
}
```

_See also: none_

## DumpPrivKey

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey) returns the wallet-import-format (WIP) private key corresponding to an address. (But does not remove it from the wallet.)

_Parameter #1---the address corresponding to the private key to get_

| Name          | Type            | Presence                | Description                                                                                                                              |
| ------------- | --------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| P2PKH Address | string (base58) | Required<br>(exactly 1) | The P2PKH address corresponding to the private key you want returned.  Must be the address corresponding to a private key in this wallet |

_Result---the private key_

| Name     | Type            | Presence                | Description                                                       |
| -------- | --------------- | ----------------------- | ----------------------------------------------------------------- |
| `result` | string (base58) | Required<br>(exactly 1) | The private key encoded as base58check using wallet import format |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet dumpprivkey ycBuREgSskHHkWLxDa9A5WppCki6PfFycL
```

Result:

```text
cQZZ4awQvcXXyES3CmUJqSgeTobQm9t9nyUr337kvUtsWsnvvMyw
```

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [DumpWallet](../api/remote-procedure-calls-wallet.md#dumpwallet): creates or overwrites a file with all wallet keys in a human-readable format.

## DumpWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet) creates or overwrites a file with all wallet keys in a human-readable format.

_Parameter #1---a filename_

| Name     | Type   | Presence                | Description                                                                                                                                                        |
| -------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Filename | string | Required<br>(exactly 1) | The filename with path (either absolute or relative to Dash Core) into which the wallet dump will be placed.  An existing file with that name will be overwritten. |

_Result---information about exported wallet_

| Name                   | Type         | Presence                | Description                                                         |
| ---------------------- | ------------ | ----------------------- | ------------------------------------------------------------------- |
| `result`               | object       | Required<br>(exactly 1) | An object describing dumped wallet file                             |
| →<br>`dashcoreversion` | string       | Required<br>(exactly 1) | Dash Core build details                                             |
| →<br>`lastblockheight` | int          | Required<br>(exactly 1) | Height of the most recent block received                            |
| →<br>`lastblockhash`   | string (hex) | Required<br>(exactly 1) | Hash of the most recent block received                              |
| →<br>`lastblocktime`   | string       | Required<br>(exactly 1) | Timestamp of the most recent block received                         |
| →<br>`keys`            | int          | Required<br>(exactly 1) | Number of keys dumped                                               |
| →<br>`filename`        | string       | Required<br>(exactly 1) | Name of the file the wallet was dumped to                           |
| →<br>`warning`         | string       | Required<br>(exactly 1) | Warning to not share the file due to it containing the private keys |

_Example from Dash Core 0.13.0_

Create a wallet dump and then print its first 10 lines.

```bash
dash-cli -testnet dumpwallet /tmp/dump.txt
head /tmp/dump.txt
```

Results:

```json
{
  "dashcoreversion": "v0.17.0.0",
  "lastblockheight": 250186,
  "lastblockhash": "0000000000a82fb1890de5da4740d0671910a436fe6fc4503a3e553adef073b4",
  "lastblocktime": "2018-10-23T12:50:44Z",
  "keys": 8135,
  "file": "/tmp/dump.txt",
  "warning": "/tmp/dump.txt file contains all private keys from this wallet. Do not share it with anyone!"
}
```

Results (the first 10 lines of the file):

```bash
>>>>>>>># Wallet dump created by Dash Core v0.13.0.0
>>>>>>>># * Created on 2020-12-09T18:40:52Z
>>>>>>>># * Best block at time of backup was 405635 (000000b2304f57eefd42cdd943e7736d479468beb08049b8f88d11ebc7cf6f02),
>>>>>>>>#   mined on 2020-12-09T18:40:23Z

cQZZ4awQvcXXyES3CmUJqSgeTobQm9t9nyUr337kvUtsWsnvvMyw 2018-12-14T17:24:37Z change=1 # addr=ycBuREgSskHHkWLxDa9A5WppCki6PfFycL
cTBRPnJoPjEMh67v1zes437v8Po5bFLDWKgEudTJMhVaLs1ZVGJe 2018-12-14T17:24:37Z change=1 # addr=yNsWkgPLN1u7p5dfWYnasYdgirU2J3tjUj
cRkkwrFnQUrih3QiT87sNy1AxyfjzqVYSyVYuL3qnJcSiQfE4QJa 2018-12-14T17:24:37Z change=1 # addr=yRkHzRbRKn8gBp5826mbaBvxLuBBNDVQg3
cQM7KoqQjHCCTrDhnfBEY1vpW9W65zRvaQeTb41UbFb6WX8Q8UkQ 2018-12-14T17:24:37Z change=1 # addr=yVEdefApUYiDLHApvvWCK5afTtJeQada8Y
cTGSKYaQTQabnjNSwCqpjYXiucVujTXiwp9dzmJV9cNAiayAJusi 2018-12-14T17:24:37Z change=1 # addr=ybQYgp21ZyZK8JuMLb2CVwG4TaWrXVXD5M
```

_See also_

* [BackupWallet](../api/remote-procedure-calls-wallet.md#backupwallet): safely copies `wallet.dat` to the specified file, which can be a directory or a path with filename.
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.

## EncryptWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`encryptwallet` RPC](../api/remote-procedure-calls-wallet.md#encryptwallet) encrypts the wallet with a passphrase.  This is only to enable encryption for the first time. After encryption is enabled, you will need to enter the passphrase to use private keys.

:::{warning}
If using this RPC on the command line, remember that your shell probably saves your command lines (including the value of the passphrase parameter). In addition, there is no RPC to completely disable encryption. If you want to return to an unencrypted wallet, you must create a new wallet and restore your data from a backup made with the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet).
:::

_Parameter #1---a passphrase_

| Name       | Type   | Presence                | Description                                                                     |
| ---------- | ------ | ----------------------- | ------------------------------------------------------------------------------- |
| Passphrase | string | Required<br>(exactly 1) | The passphrase to use for the encrypted wallet.  Must be at least one character |

_Result---a notice (with program shutdown)_

| Name     | Type   | Presence                | Description                                                                                               |
| -------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| `result` | string | Required<br>(exactly 1) | A notice that the server is stopping and that you need to make a new backup.  The wallet is now encrypted |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet encryptwallet "test"
```

Result:

```text
Wallet encrypted; Dash Core server stopping, restart to run with encrypted wallet.
The keypool has been flushed and a new HD seed was generated (if you are using
HD). You need to make a new backup.

```

_See also_

* [WalletPassphrase](../api/remote-procedure-calls-wallet.md#walletpassphrase): stores the wallet decryption key in memory for the indicated number of seconds. Issuing the `walletpassphrase` command while the wallet is already unlocked will set a new unlock time that overrides the old one.
* [WalletLock](../api/remote-procedure-calls-wallet.md#walletlock): removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call `walletpassphrase` again before being able to call any methods which require the wallet to be unlocked.
* [WalletPassphraseChange](../api/remote-procedure-calls-wallet.md#walletpassphrasechange): changes the wallet passphrase from 'old passphrase' to 'new passphrase'.

## GetAddressInfo

*Added in Dash Core 0.17.0*

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getaddressinfo` RPC](../api/remote-procedure-calls-wallet.md#getaddressinfo) returns information about the given Dash address. Note: Some information requires the address to be in the wallet.

_Parameter #1---a P2PKH or P2SH address_

| Name    | Type            | Presence                | Description |
| ------- | --------------- | ----------------------- | ----------- |
| Address | string (base58) | Required<br>(exactly 1) | The P2PKH or P2SH address encoded in base58check format |

_Result---returns information about the address_

| Name                       | Type             | Presence                | Description |
| -------------------------- | ---------------- | ----------------------- | ----------- |
| `result`                   | object           | Required<br>(exactly 1) | Information about the address |
| →<br>`address`             | string (base58)  | Required<br>(exactly 1) | The Dash address given as parameter |
| →<br>`scriptPubKey`        | string (hex)     | Required<br>(exactly 1) | The hex encoded scriptPubKey generated by the address |
| →<br>`ismine`              | bool             | Required<br>(exactly 1) | Set to `true` if the address belongs to the wallet; set to false if it does not.  Only returned if wallet support enabled |
| →<br>`iswatchonly`         | bool             | Required<br>(exactly 1) | Set to `true` if the address is watch-only.  Otherwise set to `false`.  Only returned if address is in the wallet |
| →<br>`solvable`            | bool             | Required<br>(exactly 1) | Whether we know how to spend coins sent to this address, ignoring the possible lack of private keys |
| →<br>`desc`                | string           | Optional<br>(0 or 1)    | A descriptor for spending coins sent to this address (only present when `solvable` is `true`) |
| →<br>`parent_desc`         | string           | Optional<br>(0 or 1)    | The descriptor used to derive this address if this is a descriptor wallet. |
| →<br>`isscript`            | bool             | Required<br>(exactly 1) | Set to `true` if a P2SH address; otherwise set to `false`.  Only returned if the address is in the wallet |
| →<br>`ischange`            | bool             | Required<br>(exactly 1) | Set to `true` if the address was used for change output. |
| →<br>`script`              | string           | Optional<br>(0 or 1)    | The output script type. Possible types include: `nonstandard`, `pubkey`, `pubkeyhash`, `scripthash`, `multisig`, `nulldata`. Only returned if `isscript` is true and the redeemscript is known. |
| →<br>`script`              | string           | Optional<br>(0 or 1)    | Only returned for P2SH addresses belonging to this wallet. This is the type of script:<br>• `pubkey` for a P2PK script inside P2SH<br>• `pubkeyhash` for a P2PKH script inside P2SH<br>• `multisig` for a multisig script inside P2SH<br>• `nonstandard` for unknown scripts |
| →<br>`hex`                 | string (hex)     | Optional<br>(0 or 1)    | Only returned for P2SH addresses belonging to this wallet.  This is the redeem script encoded as hex |
| →<br>`pubkeys`             | array            | Optional<br>(0 or 1)    | Array of pubkeys associated with the known redeemscript (only if `script` is "multisig") |
| → →<br>Pubkey              | string           | Optional<br>(0 or more) | A public key |
| →<br>`addresses`           | array            | Optional<br>(0 or 1)    | Array of addresses associated with the known redeemscript (only if "script" is "multisig"). |
| → →<br>Address             | string           | Optional<br>(0 or more) | An address. |
| →<br>`sigsrequired`        | number (int)     | Optional<br>(0 or 1)    | Only returned for multisig P2SH addresses belonging to the wallet.  The number of signatures required by this script |
| →<br>`pubkey`              | string (hex)     | Optional<br>(0 or 1)    | The public key corresponding to this address.  Only returned if the address is a P2PKH address in the wallet |
| →<br>`iscompressed`        | bool             | Optional<br>(0 or 1)    | Set to `true` if a compressed public key or set to `false` if an uncompressed public key.  Only returned if the address is a P2PKH address in the wallet |
| →<br>`timestamp`           | number (int)     | Optional<br>(0 or 1)    | The creation time of the key if available in seconds since epoch (Jan 1 1970 GMT) |
| →<br>`hdchainid`           | string (hash160) | Optional<br>(0 or 1)    | The ID of the HD chain |
| →<br>`hdkeypath`           | string           | Optional<br>(0 or 1)    | The HD keypath if the key is HD and available |
| →<br>`hdseedid`            | string (hex)     | Optional<br>(0 or 1)    | The Hash160 of the HD seed. |
| →<br>`hdmasterfingerprint` | string           | Optional<br>(0 or 1)    | The fingerprint of the master key |
| →<br>`labels`              | array            | Optional<br>(0 or 1)    | **Updated in Dash Core 21.0.0**<br>An array of labels associated with the address. Currently limited to one label but returned as an array to keep the API stable if multiple labels are enabled in the future. |

_Example from Dash Core 21.0.0_

Get info for the following P2PKH address from the wallet:

```bash
dash-cli getaddressinfo "yZ9fa6vzAS5yz3QjA8etgA4ka1GD2X9ouq"
```

Result:

```json
{
  "address": "yZ9fa6vzAS5yz3QjA8etgA4ka1GD2X9ouq",
  "scriptPubKey": "76a9148cc018804bcca348bae6c8cdf8c0890b09cc42ca88ac",
  "ismine": true,
  "solvable": true,
  "desc": "pkh([2849fa86/44'/1'/0'/0/1]03ad075b0b163e9cd17a24143f8914c51abc697e0706c7a0d54594b3487f0ff15c)#k2juu6h5",
  "iswatchonly": false,
  "isscript": false,
  "pubkey": "03ad075b0b163e9cd17a24143f8914c51abc697e0706c7a0d54594b3487f0ff15c",
  "iscompressed": true,
  "ischange": false,
  "timestamp": 1692213593,
  "hdchainid": "51cbaf0337e7f59ae8ad81360b20ebbb68019bab8d9d2d84ce39e20dc635b940",
  "hdkeypath": "m/44'/1'/0'/0/1",
  "hdmasterfingerprint": "2849fa86",
  "labels": [
    ""
  ]
}
```

Get info for the following P2SH multisig address from the wallet:

```bash
dash-cli -testnet getaddressinfo 8uJLxDxk2gEMbidF5vT8XLS2UCgQmVcroW
```

Result:

```json
{
  "address": "8uJLxDxk2gEMbidF5vT8XLS2UCgQmVcroW",
  "scriptPubKey": "a914a33155e490d146e656a9bac2cbee9c625ef42f0a87",
  "ismine": false,
  "solvable": false,
  "iswatchonly": false,
  "isscript": true,
  "ischange": false,
  "labels": [
    ""
  ]
}
```

_See also_

* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.
* [GetNewAddress](../api/remote-procedure-calls-wallet.md#getnewaddress): returns a new Dash address for receiving payments. If an account is specified, payments received with the address will be credited to that account.
* [ValidateAddress](../api/remote-procedure-calls-util.md#validateaddress): returns information about the given Dash address.

## GetAddressesByLabel

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getaddressesbylabel` RPC](../api/remote-procedure-calls-wallet.md#getaddressesbylabel) returns a list of every address assigned to a particular label.

_Parameter #1---the label name_

| Name  | Type   | Presence                | Description                                                                                                                          |
| ----- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Label | string | Required<br>(exactly 1) | The name of the label associated with the addresses to get.  To get addresses from the default account, pass an empty string (`""`). |

_Result---a list of addresses_

| Name        | Type   | Presence                | Description                                                                         |
| ----------- | ------ | ----------------------- | ----------------------------------------------------------------------------------- |
| `result`    | object | Required<br>(exactly 1) | A JSON object containing all addresses belonging to the specified label as keys.    |
| →Address    | object | Optional<br>(1 or more) | A JSON object with information about a P2PKH or P2SH address belonging to the label |
| →→`purpose` | string | Optional<br>(1 or more) | Purpose of address (`send` for sending address, `receive` for receiving address)    |

_Example from Dash Core 0.17.0_

Get the addresses assigned to the label "doc test":

```bash
dash-cli -testnet getaddressesbylabel "doc test"
```

Result:

```json
{
  "yacJKd6tRz2JSn8Wfp9GKgCbuowAEBivrA": {
    "purpose": "receive"
  }
}
```

_See also_

* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account.

## GetBalance

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getbalance` RPC](../api/remote-procedure-calls-wallet.md#getbalance) gets the total _available balance_ in Dash. The _available balance_ is what the wallet considers currently spendable, and is thus affected by options which limit spendability such as `-spendzeroconfchange`.

_Parameter #1---unused parameter_

| Name   | Type   | Presence             | Description                                                                                                                                                       |
| ------ | ------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Unused | string | Optional<br>(0 or 1) | **Deprecated: (previously account) will be removed in a later version of Dash Core**<br><br>Remains for backward compatibility. Must be excluded or set to `"*"`. |

_Parameter #2---the minimum number of confirmations_

| Name          | Type         | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------- | ------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations an externally-generated transaction must have before it is counted towards the balance.  Transactions generated by this node are counted immediately.  Typically, externally-generated transactions are payments to this wallet and transactions generated by this node are payments to other wallets.  Use `0` to count unconfirmed transactions.  Default is `1` |

_Parameter #3---whether to add the balance from transactions locked via InstantSend_

| Name      | Type | Presence                | Description                                          |
| --------- | ---- | ----------------------- | ---------------------------------------------------- |
| addlocked | bool | Optional<br>(exactly 1) | Add the balance from InstantSend locked transactions |

_Parameter #4---whether to include watch-only addresses_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                                 |
| ------------------ | ---- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is used as the default for watching-only wallets. |

_Parameter #5---avoids partial respends_

| Name        | Type | Presence             | Description                                                                                                                 |
| ----------- | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| avoid_reuse | bool | Optional<br>(0 or 1) | Do not include balance in dirty outputs; addresses are considered dirty if they have previously been used in a transaction. |

_Result---the balance in Dash_

| Name     | Type          | Presence                | Description                                          |
| -------- | ------------- | ----------------------- | ---------------------------------------------------- |
| `result` | number (dash) | Required<br>(exactly 1) | The balance of the account (or all accounts) in dash |

_Examples from Dash Core 0.17.0_

Get the balance, including transactions with at least three confirmations and those spent to watch-only addresses. Do not include InstantSend locked transactions.

```bash
dash-cli -testnet getbalance "*" 3 false true
```

Result:

```json
0.00000000
```

Get the balance, including transactions with at least three confirmations and those spent to watch-only addresses. Include the balance from InstantSend locked transactions.

```bash
dash-cli -testnet getbalance "" 3 true true
```

Result:

```json
1.00000000
```

_See also_

* [GetBalances](../api/remote-procedure-calls-wallet.md#getbalances): returns an object with all balances denominated in DASH.
* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.

## GetBalances

The `getbalances` RPC returns an object with all available balances denominated in DASH.

_Result---balances in Dash_

| Name                  | Type    | Presence                                      | Description                                                                                          |
| --------------------- | ------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `result`              | object  | Required<br>(exactly 1)                       | A JSON object returns an object with all balances in DASH.                                           |
| → `mine`              | object  | Optional<br>(1 or more)                       | A JSON object that has balances from outputs that the wallet can sign.                               |
| →→`trusted`           | numeric | Optional<br>(1 or more)                       | Trusted balance (outputs created by the wallet or confirmed outputs)                                 |
| →→`untrusted_pending` | numeric | Optional<br>(1 or more)                       | Untrusted pending balance (outputs created by others that are in the mempool)                        |
| →→`immature`          | numeric | Optional<br>(1 or more)                       | Balance from immature coinbase outputs                                                               |
| →→`used`              | numeric | Only present if avoid_reuse is set            | Balance from coins sent to addresses that were previously spent from (potentially privacy violating) |
| →→`coinjoin`          | numeric | Optional<br>(1 or more)                       | CoinJoin balance (outputs with enough rounds created by the wallet via mixing).                      |
| →`watchonly`          | object  | not present if wallet does not watch anything | Watchonly balances.                                                                                  |
| →→`trusted`           | numeric | Optional<br>(1 or more)                       | Trusted balance (outputs created by the wallet or confirmed outputs).                                |
| →→`untrusted_pending` | numeric | Optional<br>(1 or more)                       | Untrusted pending balance (outputs created by others that are in the mempool).                       |
| →→`immature`          | numeric | Optional<br>(1 or more)                       | Balance from immature coinbase outputs.                                                              |

_Example from Dash Core 18.2.0_

```bash
dash-cli getbalances
```

Result:

```
"mine": {
    "trusted": 0.00000000,
    "untrusted_pending": 0.00000000,
    "immature": 0.00000000,
    "used": 0.00000000,
    "coinjoin": 0.00000000
  }

```

_See also_

* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account.
* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.

## GetNewAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getnewaddress` RPC](../api/remote-procedure-calls-wallet.md#getnewaddress) returns a new Dash address for receiving payments. If `label` is specified, the address is added to the address book so payments received with the address will be associated with `label`.

_Parameter #1---an account name_

| Name    | Type   | Presence             | Description                                                                                                                                                                                                                                                               |
| ------- | ------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `label` | string | Optional<br>(0 or 1) | The label name for the address to be linked to. If not provided, the default label `""` is used. It can also be set to the empty string `""` to represent the default label. The label does not need to exist, it will be created if there is no label by the given name. |

_Result---a dash address never previously returned_

| Name     | Type            | Presence                | Description           |
| -------- | --------------- | ----------------------- | --------------------- |
| `result` | string (base58) | Required<br>(exactly 1) | The new Dash address. |

_Example from Dash Core 0.17.0_

Create a new address in the "doc test" account:

```bash
dash-cli -testnet getnewaddress "doc test"
```

Result:

```text
yPuNTqCGzXtU3eEV5jHvhhJkzEPyJLmVkb
```

_See also_

* [GetRawChangeAddress](../api/remote-procedure-calls-wallet.md#getrawchangeaddress): returns a new Dash address for receiving change. This is for use with raw transactions, not normal use.
* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account.

## GetRawChangeAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getrawchangeaddress` RPC](../api/remote-procedure-calls-wallet.md#getrawchangeaddress) returns a new Dash address for receiving change. This is for use with raw transactions, not normal use.

_Parameters: none_

_Result---a P2PKH address which can be used in raw transactions_

| Name     | Type            | Presence                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| -------- | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result` | string (base58) | Required<br>(exactly 1) | A P2PKH address which has not previously been returned by this RPC.  The address will be removed from the keypool but not marked as a receiving address, so RPCs such as the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet) will show it as a change address.  The address may already have been part of the keypool, so other RPCs such as the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet) may have disclosed it previously.  If the wallet is unlocked, its keypool will also be filled to its max (by default, 100 unused keys).  If the wallet is locked and its keypool is empty, this RPC will fail |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet getrawchangeaddress
```

Result:

```text
yXBr9BiJmugTzHPgByDmvjJMAkvhTmXVJ8
```

_See also_

* [GetNewAddress](../api/remote-procedure-calls-wallet.md#getnewaddress): returns a new Dash address for receiving payments. If an account is specified, payments received with the address will be credited to that account.

## GetReceivedByAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

![Warning icon](https://raw.githubusercontent.com/dashpay/docs-core/main/img/icons/icon_warning.svg) Note: This RPC only returns a balance for addresses contained in the local wallet.

The [`getreceivedbyaddress` RPC](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress) returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.

_Parameter #1---the address_

| Name    | Type   | Presence                | Description                                                                                                        |
| ------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Address | string | Required<br>(exactly 1) | **Only works for addresses contained in the local wallet**<br><br>The address whose transactions should be tallied |

_Parameter #2---the minimum number of confirmations_

| Name          | Type         | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------- | ------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations an externally-generated transaction must have before it is counted towards the balance.  Transactions generated by this node are counted immediately.  Typically, externally-generated transactions are payments to this wallet and transactions generated by this node are payments to other wallets.  Use `0` to count unconfirmed transactions.  Default is `1` |

_Parameter #3---whether to include transactions locked via InstantSend_

| Name      | Type | Presence                | Description                                          |
| --------- | ---- | ----------------------- | ---------------------------------------------------- |
| addlocked | bool | Optional<br>(exactly 1) | Add the balance from InstantSend locked transactions |

_Result---the amount of dash received_

| Name     | Type          | Presence                | Description                                                                              |
| -------- | ------------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| `result` | number (dash) | Required<br>(exactly 1) | The amount of dash received by the address, excluding coinbase transactions.  May be `0` |

_Example from Dash Core 0.13.0_

Get the dash received for a particular address, only counting  
transactions with six or more confirmations (ignore InstantSend locked transactions):

```bash
dash-cli -testnet getreceivedbyaddress yYoCWcjbykWsQJ7MVJrTMeQd8TZe5N4Q7g 6
```

Result:

```json
0.00000000
```

Get the dash received for a particular address, only counting  
transactions with six or more confirmations (include InstantSend locked transactions):

```bash
dash-cli -testnet getreceivedbyaddress yYoCWcjbykWsQJ7MVJrTMeQd8TZe5N4Q7g 6 true
```

Result:

```json
0.30000000
```

_See also: none_

## GetReceivedByLabel

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getreceivedbylabel` RPC](../api/remote-procedure-calls-wallet.md#getreceivedbylabel) returns the total amount received by addresses with <label> in transactions with specified minimum number of confirmations.

_Parameter #1---the label name_

| Name  | Type   | Presence                | Description                                              |
| ----- | ------ | ----------------------- | -------------------------------------------------------- |
| Label | string | Required<br>(exactly 1) | The selected label, may be the default label using `""`. |

_Parameter #2---the minimum number of confirmations_

| Name          | Type         | Presence             | Description                                                                                                                                                      |
| ------------- | ------------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations a transaction must have before it is counted towards the balance. Use `0` to count unconfirmed transactions.  Default is `1` |

_Parameter #3---whether to include transactions locked via InstantSend_

| Name      | Type | Presence                | Description                                                          |
| --------- | ---- | ----------------------- | -------------------------------------------------------------------- |
| addlocked | bool | Optional<br>(exactly 1) | Add the balance from InstantSend locked transactions (default=false) |

_Result---the number of DASH received_

| Name     | Type          | Presence                | Description                                                   |
| -------- | ------------- | ----------------------- | ------------------------------------------------------------- |
| `result` | number (dash) | Required<br>(exactly 1) | The total amount of DASH received for this label.  May be `0` |

_Example from Dash Core 0.17.0_

Get the DASH received by the "doc test" label with six or more confirmations:

```bash
dash-cli -testnet getreceivedbylabel "doc test" 6
```

Result:

```json
0.30000000
```

_See also_

* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.
* [GetAddressesByLabel](../api/remote-procedure-calls-wallet.md#getaddressesbylabel): returns a list of every address assigned to a particular label.
* [ListLabels](../api/remote-procedure-calls-wallet.md#listlabels): lists labels.

```{eval-rst}
.. _api-rpc-wallet-gettransaction:
```

## GetTransaction

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`gettransaction` RPC](../api/remote-procedure-calls-wallet.md#gettransaction) gets detailed information about an in-wallet transaction.

_Parameter #1---a transaction identifier (TXID)_

| Name | Type         | Presence                | Description                                                                                          |
| ---- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------- |
| TXID | string (hex) | Required<br>(exactly 1) | The TXID of the transaction to get details about.  The TXID must be encoded as hex in RPC byte order |

_Parameter #2---whether to include watch-only addresses in details and calculations_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is the default for watching-only wallets. |

_Parameter #3---whether or not to include the decoded transaction_

| Name    | Type | Presence                | Description                                                                                                      |
| ------- | ---- | ----------------------- | ---------------------------------------------------------------------------------------------------------------  |
| verbose | bool | Optional<br>(exactly 1) | Whether to include a `decoded` field containing the decoded transaction (equivalent to RPC [`decoderawtransaction`](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction)) |

_Result---a description of the transaction_

| Name                         | Type            | Presence                    | Description                                                                                                                                                                                                                                                                                                                                                                                   |
| ---------------------------- | --------------- | --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                     | object          | Required<br>(exactly 1)     | An object describing how the transaction affects the wallet                                                                                                                                                                                                                                                                                                                                   |
| →<br>`amount`                | number (dash)   | Required<br>(exactly 1)     | A positive number of dash if this transaction increased the total wallet balance; a negative number of dash if this transaction decreased the total wallet balance, or `0` if the transaction had no net effect on wallet balance                                                                                                                                                             |
| →<br>`fee`                   | number (dash)   | Optional<br>(0 or 1)        | If an outgoing transaction, this is the fee paid by the transaction reported as negative dash                                                                                                                                                                                                                                                                                                 |
| → <br>`confirmations`        | number (int)    | Required<br>(exactly 1)     | The number of confirmations the transaction has received.  Will be `0` for unconfirmed and `-1` for conflicted                                                                                                                                                                                                                                                                                |
| →<br>`instantlock`          | bool           | Required<br>(exactly 1) | If set to `true`, this transaction is either protected by an [InstantSend](../resources/glossary.md#instantsend) lock or it is in a block that has received a [ChainLock](../resources/glossary.md#chainlock) |
| →<br>`instantlock-internal` | bool           | Required<br>(exactly 1) | If set to `true`, this transaction has an [InstantSend](../resources/glossary.md#instantsend) lock.  Available for 'send' and 'receive' category of transactions. |
| → <br>`chainlock`            | bool            | Required<br>(exactly 1)     |  If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org) |
| → <br>`trusted`              | bool            | Optional<br>(0 or 1)        | Whether we consider the outputs of this unconfirmed transaction safe to spend. Only returned for unconfirmed transactions |
| → <br>`generated`            | bool            | Optional<br>(0 or 1)        | Set to `true` if the transaction is a coinbase.  Not returned for regular transactions |
| → <br>`blockhash`            | string (hex)    | Optional<br>(0 or 1)        | The hash of the block on the local best block chain which includes this transaction, encoded as hex in RPC byte order.  Only returned for confirmed transactions |
| → <br>`blockheight`          | string (hex)    | Optional<br>(0 or 1)        | The block height containing the transaction. Only returned for confirmed transactions |
| → <br>`blockindex`           | number (int)    | Optional<br>(0 or 1)        | The index of the transaction in the block that includes it.  Only returned for confirmed transactions |
| → <br>`blocktime`            | number (int)    | Optional<br>(0 or 1)        | The block header time (Unix epoch time) of the block on the local best block chain which includes this transaction.  Only returned for confirmed transactions |
| → <br>`trusted`              | bool            | Optional<br>(0 or 1)        | Whether we consider the outputs of this unconfirmed transaction safe to spend. Only returned for unconfirmed transactions |
| → <br>`txid`                 | string (hex)    | Required<br>(exactly 1)     | The TXID of the transaction, encoded as hex in RPC byte order                                                                                                                                                                                                                                                                                                                                 |
| → <br>`walletconflicts`      | array           | Required<br>(exactly 1)     | An array containing the TXIDs of other transactions that spend the same inputs (UTXOs) as this transaction.  Array may be empty                                                                                                                                                                                                                                                               |
| → →<br>TXID                  | string (hex)    | Optional<br>(0 or more)     | The TXID of a conflicting transaction, encoded as hex in RPC byte order                                                                                                                                                                                                                                                                                                                       |
| → <br>`time`                 | number (int)    | Required<br>(exactly 1)     | A Unix epoch time when the transaction was added to the wallet                                                                                                                                                                                                                                                                                                                                |
| → <br>`timereceived`         | number (int)    | Required<br>(exactly 1)     | A Unix epoch time when the transaction was detected by the local node, or the time of the block on the local best block chain that included the transaction                                                                                                                                                                                                                                   |
| → <br>`abandoned`            | bool            | Optional<br>(0 or 1)        | `true` if the transaction has been abandoned (inputs are respendable). Only available for the 'send' category of transactions.                                                                                                                                                                                                                                                                |
| → <br>`comment`              | string          | Optional<br>(0 or 1)        | For transaction originating with this wallet, a locally-stored comment added to the transaction.  Only returned if a comment was added                                                                                                                                                                                                                                                        |
| → <br>`to`                   | string          | Optional<br>(0 or 1)        | For transaction originating with this wallet, a locally-stored comment added to the transaction identifying who the transaction was sent to.  Only returned if a comment-to was added                                                                                                                                                                                                         |
| →<br>`DS`                    | bool            | Optional<br>(0 or 1)        | Set to 1 if a CoinJoin transaction                                                                                                                                                                                                                                                                                                                                                            |
| →<br>`details`               | array           | Required<br>(exactly 1)     | An array containing one object for each input or output in the transaction which affected the wallet                                                                                                                                                                                                                                                                                          |
| → → <br>`involvesWatchonly`  | bool            | Optional<br>(0 or 1)        | Set to `true` if the input or output involves a watch-only address.  Otherwise not returned                                                                                                                                                                                                                                                                                                   |
| → →<br>`address`             | string (base58) | Optional<br>(0 or 1)        | If an output, the address paid (may be someone else's address not belonging to this wallet).  If an input, the address paid in the previous output.  May be empty if the address is unknown, such as when paying to a non-standard pubkey script                                                                                                                                              |
| → →<br>`category`            | string          | Required<br>(exactly 1)     | Set to one of the following values:<br>• `send` if sending payment normally<br>• `coinjoin` if sending CoinJoin payment<br>• `receive` if this wallet received payment in a regular transaction<br>• `generate` if a matured and spendable coinbase<br>• `immature` if a coinbase that is not spendable yet<br>• `orphan` if a coinbase from a block that's not in the local best block chain |
| → →<br>`amount`              | number (dash)   | Required<br>(exactly 1)     | A negative dash amount if sending payment; a positive dash amount if receiving payment (including coinbases)                                                                                                                                                                                                                                                                                  |
| → →<br>`label`               | string          | Optional<br>(0 or 1)        | An optional comment for the address/transaction                                                                                                                                                                                                                                                                                                                                               |
| → →<br>`vout`                | number (int)    | Required<br>(exactly 1)     | For an output, the output index (vout) for this output in this transaction.  For an input, the output index for the output being spent in its transaction.  Because inputs list the output indexes from previous transactions, more than one entry in the details array may have the same output index                                                                                        |
| → →<br>`fee`                 | number (dash)   | Optional<br>(0 or 1)        | If sending payment, the fee paid as a negative dash value.  May be `0`.  Not returned if receiving payment                                                                                                                                                                                                                                                                                    |
| → →<br>`abandoned`           | bool            | Optional<br>(0 or 1)        | _Added in Bitcoin Core 0.12.1_<br><br>Indicates if a transaction is was abandoned:<br>• `true` if it was abandoned (inputs are respendable)<br>• `false`  if it was not abandoned<br>Only returned by _send_ category payments                                                                                                                                                                |
| →<br>`hex`                   | string (hex)    | Required<br>(exactly 1)     | The transaction in serialized transaction format                                                                                                                                                                                                                                                                                                                                              |
| →<br>`decoded`               | object          | Optional<br>(0 or 1)        | The decoded transaction (only present when `verbose` is passed), equivalent to the RPC [`decoderawtransaction` method](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction), or the RPC [`getrawtransaction` method](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) when `verbose` is passed.                                                                                                                                                                                                                  |

_Example from Dash Core 21.1.0_

```bash
dash-cli -testnet gettransaction \
  88a3fe6bf2ab4425dbf57d75ce761efa2e45556ec36b4fd5b6af6c00f01ebd63
```

Result:

```json
{
  "amount": 2.37570000,
  "confirmations": 192419,
  "instantlock": true,
  "instantlock_internal": false,
  "chainlock": true,
  "blockhash": "0000009f3480f5e2b6821af57ccbfeb064d9e18b6e9e669aad238f2b0059df1a",
  "blockheight": 886992,
  "blockindex": 1,
  "blocktime": 1692025132,
  "txid": "88a3fe6bf2ab4425dbf57d75ce761efa2e45556ec36b4fd5b6af6c00f01ebd63",
  "walletconflicts": [
  ],
  "time": 1692025132,
  "timereceived": 1692213632,
  "details": [
    {
      "address": "ygU1vv8a2fhiM2gYUF1GjQAcjxgZUKY5MD",
      "category": "receive",
      "amount": 2.37570000,
      "label": "First address",
      "vout": 1
    }
  ],
  "hex": "02000000016634e15fe22fe84554833f109916fced5af30fac0849a211f17f326162280f14010000006a47304402207b8f61bebe3560b6ef70de3e10b59bdc60931d09cf0626026bfe3064dcfcf1c00220048ad98398cb294fa19335110db3ce5a466b74cbbf234bf2b4855b264a03ef790121027b90f229e7027758f0c8b39d2d485b88ed5b63b34e58e0dad2a07e3e8eb03373feffffff0278f51104000000001976a9148907e625c343ac9c6b56e8180f73af1d23350d0c88acd007290e000000001976a914dd01754e43690f41feef2cc7974bc2e5101e9f2788accf880d00"
}
```

_See also_

* [GetRawTransaction](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction): gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so the RPC may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings.

## GetUnconfirmedBalance

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getunconfirmedbalance` RPC](../api/remote-procedure-calls-wallet.md#getunconfirmedbalance) returns the wallet's total unconfirmed balance.

_Parameters: none_

_Result---the balance of unconfirmed transactions paying this wallet_

| Name     | Type          | Presence                | Description                                                              |
| -------- | ------------- | ----------------------- | ------------------------------------------------------------------------ |
| `result` | number (dash) | Required<br>(exactly 1) | The total number of dash paid to this wallet in unconfirmed transactions |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet getunconfirmedbalance
```

Result (no unconfirmed incoming payments):

```json
0.00000000
```

_See also_

* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account.

## GetWalletInfo

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`getwalletinfo` RPC](../api/remote-procedure-calls-wallet.md#getwalletinfo) provides information about the wallet.

_Parameters: none_

_Result---information about the wallet_

| Name                           | Type             | Presence                | Description |
| ------------------------------ | ---------------- | ----------------------- | ----------- |
| `result`                       | object           | Required<br>(exactly 1) | An object describing the wallet |
| →<br>`walletname`              | string           | Required<br>(exactly 1) | The name of the wallet |
| →<br>`walletversion`           | number (int)     | Required<br>(exactly 1) | The version  |
| →<br>`format`                  | string           | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br><br>The database format (`bdb` or `sqlite`) |
| →<br>`balance`                 | number (dash)    | Required<br>(exactly 1) | **Deprecated** The total confirmed balance of the wallet.  The same as returned by the [`getbalance` RPC](../api/remote-procedure-calls-wallet.md#getbalance) with default parameters |
| →<br>`coinjoin_balance`        | number (dash)    | Required<br>(exactly 1) | **Deprecated** _Added in Dash Core 0.12.3_<br><br>The total CoinJoin balance of the wallet. Identical to `getbalances().mine.coinjoin`. |
| →<br>`unconfirmed_balance`     | number (dash)    | Required<br>(exactly 1) | **Deprecated** The total unconfirmed balance of the wallet.  The same as returned by the [`getunconfirmedbalance` RPC](../api/remote-procedure-calls-wallet.md#getunconfirmedbalance) with default parameters. Identical to `getbalances().mine.untrusted_pending`. |
| →<br>`immature_balance`        | number (dash)    | Required<br>(exactly 1) | **Deprecated**  The total immature balance of the wallet.  This includes mining/masternode rewards that cannot be spent yet. Identical to `getbalances().mine.immature`. |
| →<br>`txcount`                 | number (int)     | Required<br>(exactly 1) | The total number of transactions in the wallet (both spends and receives) |
| →<br>`timefirstkey`            | number (int)     | Required<br>(exactly 1) | The timestamp (seconds since Unix epoch) of the oldest known key in the wallet |
| →<br>`keypoololdest`           | number (int)     | Required<br>(exactly 1) | The date as Unix epoch time when the oldest key in the wallet key pool was created; useful for only scanning blocks created since this date for transactions |
| →<br>`keypoolsize`             | number (int)     | Required<br>(exactly 1) | The number of keys in the wallet keypool |
| →<br>`keypoolsize_hd_internal` | number (int)     | Optional<br>(0 or 1)    | How many new keys are pre-generated for internal use (used for change outputs, only appears if the wallet is using this feature, otherwise external keys are used) |
| →<br>`keys_left`               | number (int)     | Required<br>(exactly 1) | The number of unused keys left since the last automatic backup |
| →<br>`unlocked_until`          | number (int)     | Optional<br>(0 or 1)    | Only returned if the wallet was encrypted with the [`encryptwallet` RPC](../api/remote-procedure-calls-wallet.md#encryptwallet). A Unix epoch date when the wallet will be locked, or `0` if the wallet is currently locked |
| →<br>`paytxfee`                | number (float)   | Required<br>(exactly 1) | The transaction fee configuration, set in DASH/kB |
| →<br>`hdchainid`               | string (hash)    | Optional<br>(0 or 1)    | The ID of the HD chain |
| →<br>`hdaccountcount`          | number (int)     | Optional<br>(0 or 1)    | How many accounts of the HD chain are in this wallet |
| →<br>`hdaccounts`              | array of objects | Optional<br>(0 or 1)    | Array of JSON objects containing account info |
| → →<br> Account                | object           | Optional<br>(1 or more) | JSON object containing info about a specific account |
| → → →<br>`hdaccountindex` | number (int)     | Optional<br>(0 or 1)    | The index of the account |
| → → →<br>`hdexternalkeyindex`  | number (int)     | Optional<br>(0 or 1)    | Current external child key index |
| → → →<br>`hdinternalkeyindex`  | number (int)     | Optional<br>(0 or 1)    | Current internal child key index |
| →<br>`avoid_reuse`             | boolean          | Optional<br>(0 or 1)    | Whether this wallet tracks clean/dirty coins in terms of reuse |
| →<br>`scanning`                | object           | Required<br>(exactly 1) | \_Added in Dash Core 0.16.1\_\_<br><br>JSON object containing current scanning details (false (0) if no scan is in progress) |
| → →<br>`duration`              | number (int)     | Optional<br>(0 or 1)    | Elapsed seconds since scan start |
| → →<br>`progress`              | number (int)     | Optional<br>(0 or 1)    | Scanning progress percentage 0.0 to 1.0 |
| →<br>`private_keys_enabled`    | boolean          | Optional<br>(0 or 1)    | `false` if private keys are disabled for this wallet (enforced watch-only wallet) |

_Example from Dash Core 20.0.0_

```bash
dash-cli -testnet getwalletinfo
```

Result:

```json
{
  "walletname": "",
  "walletversion": 120200,
  "format": "bdb",
  "balance": 178659.22849018,
  "coinjoin_balance": 0.00100001,
  "unconfirmed_balance": 0.00000000,
  "immature_balance": 13.38239278,
  "txcount": 37712,
  "timefirstkey": 1544808277,
  "keypoololdest": 1659558297,
  "keypoolsize": 1000,
  "keypoolsize_hd_internal": 1000,
  "keys_left": 1000,
  "paytxfee": 0.00000000,
  "hdchainid": "xxxxxxxxe62a7766153dac6c90242b712dbb98f4d457b7fb46e09136zzzzzzzz",
  "hdaccountcount": 1,
  "hdaccounts": [
    {
      "hdaccountindex": 0,
      "hdexternalkeyindex": 2838,
      "hdinternalkeyindex": 7669
    }
  ],
  "avoid_reuse": false,
  "scanning": false,
  "private_keys_enabled": true
}
```

_See also_

* [ListTransactions](../api/remote-procedure-calls-wallet.md#listtransactions): returns the most recent transactions that affect the wallet.

## ImportAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`importaddress` RPC](../api/remote-procedure-calls-wallet.md#importaddress) adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.

_Parameter #1---the address or pubkey script to watch_

| Name              | Type                   | Presence                | Description                                                                              |
| ----------------- | ---------------------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| Address or Script | string (base58 or hex) | Required<br>(exactly 1) | Either a P2PKH or P2SH address encoded in base58check, or a pubkey script encoded as hex |

_Parameter #2---The account into which to place the address or pubkey script_

| Name  | Type   | Presence             | Description                                          |
| ----- | ------ | -------------------- | ---------------------------------------------------- |
| Label | string | Optional<br>(0 or 1) | An optional label.  Default is an empty string(\\")" |

_Parameter #3---whether to rescan the block chain_

| Name   | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                                                |
| ------ | ---- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Rescan | bool | Optional<br>(0 or 1) | Set to `true` (the default) to rescan the entire local block database for transactions affecting any address or pubkey script in the wallet (including transaction affecting the newly-added address or pubkey script).  Set to `false` to not rescan the block database (rescanning can be performed at any time by restarting Dash Core with the `-rescan` command-line argument).  Rescanning may take several minutes. |

_Parameter #4---whether to rescan the block chain_

| Name | Type | Presence             | Description                                |
| ---- | ---- | -------------------- | ------------------------------------------ |
| P2SH | bool | Optional<br>(0 or 1) | Add the P2SH version of the script as well |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                                                                             |
| -------- | ---- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the address or pubkey script is added to the wallet (or is already part of the wallet), JSON `null` will be returned |

_Example from Dash Core 0.12.2_

Add an address, rescanning the local block database for any transactions  
matching it.

```bash
dash-cli -testnet importaddress \
  yg89Yt5Tjzs9nRpX3wJCuvr7KuQvgkvmeC "watch-only test" true
```

Result:

(No output; success.)

Show that the address has been added:

```bash
dash-cli -testnet getaccount yg89Yt5Tjzs9nRpX3wJCuvr7KuQvgkvmeC
```

Result:

```text
watch-only test
```

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [ListReceivedByAddress](../api/remote-procedure-calls-wallet.md#listreceivedbyaddress): lists the total number of dash received by each address.

## ImportDescriptors

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**). Wallet must be unlocked.

Note: Importing descriptors can take a significant amount of time if a rescan is triggered, particularly if a timestamp far back in the past is used. During this time, other RPC calls may report that the imported keys, addresses, or scripts exist but related transactions are still missing.
:::

_Added in Dash Core 21.0.0_

The [`importdescriptors` RPC](../api/remote-procedure-calls-wallet.md#importdescriptors) imports multiple descriptors into the wallet, each with specific attributes. This action triggers a blockchain rescan from the specified start time to update the wallet with all relevant transactions.

_Parameter #1---descriptors to import_

| Name            | Type                 | Presence                | Description |
| --------------- | -------------------- | ----------------------- | ----------- |
| `requests`      | array                | Required<br>(exactly 1) | An array of JSON objects, each representing a descriptor to be imported. |
| →Request         | object               | Required<br>(1 or more) | JSON object containing descriptor data. |
| → →<br>`desc`     | string               | Required<br>(exactly 1) | Descriptor string to import. |
| → →<br>`active`   | bool                 | Optional<br>(0 or 1)    | If true, sets this descriptor as active for generating new addresses. Defaults to `false`. |
| → →<br>`range`    | numeric or array     | Optional<br>(0 or 1)    | If a ranged descriptor is used, this specifies the end or the range (in the form [begin,end]) to import. |
| → →<br>`next_index`| numeric             | Optional<br>(0 or 1)    | For active ranged descriptors, the next index from which to generate addresses. |
| → →<br>`timestamp`| integer / string    | Required<br>(exactly 1) | Time from which to start rescanning the blockchain for this descriptor, in UNIX epoch time. Use the string "now" to substitute the current synced blockchain time. "now" can be specified to bypass scanning, for outputs which are known to never have been used, and 0 can be specified to scan the entire blockchain. Blocks up to 2 hours before the earliest timestamp of all descriptors being imported will be scanned. |
| → →<br>`internal` | bool                 | Optional<br>(0 or 1)    | If true, treats outputs as change (not incoming payments). Defaults to `false`. |
| → →<br>`label`    | string               | Optional<br>(0 or 1)    | Label for the addresses. Only applicable if `internal` is false. Defaults to an empty string. |

_Result---execution result_

| Name                | Type   | Presence                | Description                                                                                      |
| ------------------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------ |
| `result`            | array  | Required<br>(exactly 1) | An array of objects containing results for each import request, mirroring the structure of the input array. |
| → Result            | object | Required<br>(1 or more) | Each result corresponding to an import request.                                                  |
| → → <br>`success`   | bool   | Required<br>(exactly 1) | Indicates whether the import was successful.                                                     |
| → → <br>`warnings`  | array  | Optional<br>(0 or more) | Lists any warnings related to the import.                                                        |
| → → <br>`error`     | object | Optional<br>(0 or 1)    | Contains error details if the import failed.                                                     |

_Examples_

```bash
dash-cli importdescriptors '[{ "desc": "<descriptor>", "timestamp": 1455191478, "internal": true }, { "desc": "<descriptor 2>", "label": "example 2", "timestamp": 1455191480 }]'
```

```bash
dash-cli importdescriptors '[{ "desc": "<descriptor>", "timestamp": "now", "active": true, "range": [0,100], "label": "my wallet" }]'
```

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet.
* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or script to the wallet without the associated private key.
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports keys from a wallet dump file, potentially triggering a rescan.

## ImportElectrumWallet

The [`importelectrumwallet` RPC](../api/remote-procedure-calls-wallet.md#importelectrumwallet) imports keys from an Electrum wallet export file (.csv or .json)

_Parameter #1---file name_

| Name      | Type   | Presence                | Description                                                       |
| --------- | ------ | ----------------------- | ----------------------------------------------------------------- |
| File Name | string | Required<br>(exactly 1) | The Electrum wallet export file (should be in csv or json format) |

_Parameter #2---index_

| Name  | Type         | Presence             | Description                                                                    |
| ----- | ------------ | -------------------- | ------------------------------------------------------------------------------ |
| Index | number (int) | Optional<br>(0 or 1) | Rescan the wallet for transactions starting from this block index (default: 0) |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                                  |
| -------- | ---- | ----------------------- | ---------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the Electrum keys are imported successfully, JSON `null` will be returned |

_Example from Dash Core 0.12.2_

```bash
dash-cli importelectrumwallet /tmp/electrum-export.csv
```

(Success: no result displayed.)

_See also: none_

## ImportMulti

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**). Wallet must be unlocked.
:::

_Added in Dash Core 0.12.3 / Bitcoin Core 0.14.0_

The [`importmulti` RPC](../api/remote-procedure-calls-wallet.md#importmulti) imports addresses or scripts (with private keys, public keys, or P2SH redeem scripts) and optionally performs the minimum necessary rescan for all imports.

_Parameter #1---the addresses/scripts to import_

| Name                  | Type                  | Presence                | Description                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------- | --------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Imports               | array                 | Required<br>(exactly 1) | An array of JSON objects, each one being an address or script to be imported                                                                                                                                                                                                                                                                                                                                                     |
| → Import              | object                | Required<br>(1 or more) | A JSON object describing a particular import                                                                                                                                                                                                                                                                                                                                                                                     |
| → →<br>`scriptPubKey` | string (hex)          | Optional<br>(0 or 1)    | The script (string) to be imported.  Must have either this field or `address` below                                                                                                                                                                                                                                                                                                                                              |
| → →<br>`address`      | string (base58)       | Optional<br>(0 or 1)    | The P2PKH or P2SH address to be imported.  Must have either this field or `scriptPubKey` above                                                                                                                                                                                                                                                                                                                                   |
| → →<br>`timestamp`    | number (int) / string | Required<br>(exactly 1) | The creation time of the key in Unix epoch time or the string “now” to substitute the current synced block chain time. The timestamp of the oldest key will determine how far back block chain rescans need to begin. Specify `now` to bypass scanning for keys which are known to never have been used.  Specify `0` to scan the entire block chain. Blocks up to 2 hours before the earliest key creation time will be scanned |
| → →<br>`redeemscript` | string                | Optional<br>(0 or 1)    | A redeem script. Only allowed if either the `address` field is a P2SH address or the `scriptPubKey` field is a P2SH scriptPubKey                                                                                                                                                                                                                                                                                                 |
| → →<br>`pubkeys`      | array                 | Optional<br>(0 or 1)    | Array of strings giving pubkeys that must occur in the scriptPubKey or redeemscript                                                                                                                                                                                                                                                                                                                                              |
| → →<br>`keys`         | array                 | Optional<br>(0 or 1)    | Array of strings giving private keys whose corresponding public keys must occur in the scriptPubKey or redeemscript                                                                                                                                                                                                                                                                                                              |
| → →<br>`internal`     | bool                  | Optional<br>(0 or 1)    | Stating whether matching outputs should be treated as change rather than incoming payments. The default is `false`                                                                                                                                                                                                                                                                                                               |
| → →<br>`watchonly`    | bool                  | Optional<br>(0 or 1)    | Stating whether matching outputs should be considered watched even when they're not spendable. This is only allowed if keys are empty. The default is `false`                                                                                                                                                                                                                                                                    |
| → →<br>`label`        | string                | Optional<br>(0 or 1)    | Label to assign to the address, only allowed with `internal` set to `false`. The default is an empty string (“”)                                                                                                                                                                                                                                                                                                                 |

_Parameter #2---options regarding the import_

| Name           | Type   | Presence             | Description                                                                                                                                                                                                                                                                                       |
| -------------- | ------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Option         | object | Optional<br>(0 or 1) | JSON object with options regarding the import                                                                                                                                                                                                                                                     |
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

## ImportPrivKey

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**). Wallet must be unlocked.
:::

The [`importprivkey` RPC](../api/remote-procedure-calls-wallet.md#importprivkey) adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).

_Parameter #1---the private key to import_

| Name        | Type            | Presence                | Description                                                                                       |
| ----------- | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------- |
| Private Key | string (base58) | Required<br>(exactly 1) | The private key to import into the wallet encoded in base58check using wallet import format (WIF) |

_Parameter #2---the account into which the key should be placed_

| Name    | Type   | Presence             | Description                                                                                                                                    |
| ------- | ------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Account | string | Optional<br>(0 or 1) | The name of an account to which transactions involving the key should be assigned.  The default is the default account, an empty string (\\")" |

_Parameter #3---whether to rescan the block chain_

| Name   | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------ | ---- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Rescan | bool | Optional<br>(0 or 1) | Set to `true` (the default) to rescan the entire local block database for transactions affecting any address or pubkey script in the wallet (including transaction affecting the newly-added address for this private key).  Set to `false` to not rescan the block database (rescanning can be performed at any time by restarting Dash Core with the `-rescan` command-line argument).  Rescanning may take several minutes.  Notes: if the address for this key is already in the wallet, the block database will not be rescanned even if this parameter is set |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                                                                |
| -------- | ---- | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the private key is added to the wallet (or is already part of the wallet), JSON `null` will be returned |

_Example from Dash Core 0.12.2_

Import the private key for the address  
ycBuREgSskHHkWLxDa9A5WppCki6PfFycL, giving it a label and scanning the  
entire block chain:

```bash
dash-cli -testnet importprivkey \
              cQZZ4awQvcXXyES3CmUJqSgeTobQm9t9nyUr337kvUtsWsnvvMyw \
              "test label" \
              true
```

(Success: no result displayed.)

_See also_

* [DumpPrivKey](../api/remote-procedure-calls-wallet.md#dumpprivkey): returns the wallet-import-format (WIP) private key corresponding to an address. (But does not remove it from the wallet.)
* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.
* [ImportPubKey](../api/remote-procedure-calls-wallet.md#importpubkey): imports a public key (in hex) that can be watched as if it were in your wallet but cannot be used to spend
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.

## ImportPrunedFunds

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

_Added in Dash Core 0.12.3 / Bitcoin Core 0.13.0_

The [`importprunedfunds` RPC](../api/remote-procedure-calls-wallet.md#importprunedfunds) imports funds without the need of a rescan. Meant for use with pruned wallets. Corresponding address or script must previously be included in wallet.  
The end-user is responsible to import additional transactions that subsequently spend the imported  
outputs or rescan after the point in the blockchain the transaction is included.

_Parameter #1---the raw transaction to import_

| Name            | Type            | Presence                | Description                                                            |
| --------------- | --------------- | ----------------------- | ---------------------------------------------------------------------- |
| Raw Transaction | string<br>(hex) | Required<br>(exactly 1) | A raw transaction in hex funding an already-existing address in wallet |

_Parameter #2---the tx out proof that cointains the transaction_

| Name         | Type            | Presence                | Description                                                     |
| ------------ | --------------- | ----------------------- | --------------------------------------------------------------- |
| TX Out Proof | string<br>(hex) | Required<br>(exactly 1) | The hex output from gettxoutproof that contains the transaction |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                    |
| -------- | ---- | ----------------------- | -------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the funds are added to wallet, JSON `null` will be returned |

_Example from Dash Core 0.12.3_

```bash
bitcoin-cli importprunedfunds "txhex" "txoutproof"
```

(Success: no result displayed.)

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [RemovePrunedFunds](../api/remote-procedure-calls-wallet.md#removeprunedfunds): deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds.

## ImportPubKey

The [`importpubkey` RPC](../api/remote-procedure-calls-wallet.md#importpubkey) imports a public key (in hex) that can be watched as if it were in your wallet but cannot be used to spend

_Parameter #1---the public key to import_

| Name       | Type         | Presence                | Description              |
| ---------- | ------------ | ----------------------- | ------------------------ |
| Public Key | string (hex) | Required<br>(exactly 1) | The public key to import |

_Parameter #2---the account into which the key should be placed_

| Name  | Type   | Presence             | Description                          |
| ----- | ------ | -------------------- | ------------------------------------ |
| Label | string | Optional<br>(0 or 1) | The label the key should be assigned |

_Parameter #3---whether to rescan the block chain_

| Name   | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------ | ---- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Rescan | bool | Optional<br>(0 or 1) | Set to `true` (the default) to rescan the entire local block database for transactions affecting any address or pubkey script in the wallet.  Set to `false` to not rescan the block database (rescanning can be performed at any time by restarting Dash Core with the `-rescan` command-line argument).  Rescanning may take several minutes.  Notes: if the address for this key is already in the wallet, the block database will not be rescanned even if this parameter is set |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                                                               |
| -------- | ---- | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the public key is added to the wallet (or is already part of the wallet), JSON `null` will be returned |

_Example from Dash Core 0.12.2_

Import the public key for the address, giving it a label and scanning the  
entire block chain:

```bash
dash-cli -testnet importpubkey \
    0210c1349657c1253d3d64d1b31d3500b09335bf12b8df061666e216f550a43249 \
    "test label" \
    true
```

(Success: no result displayed.)

_See also:_

* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.
* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.

## ImportWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`importwallet` RPC](../api/remote-procedure-calls-wallet.md#importwallet) imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.

_Parameter #1---the file to import_

| Name     | Type   | Presence                | Description                                                                |
| -------- | ------ | ----------------------- | -------------------------------------------------------------------------- |
| Filename | string | Required<br>(exactly 1) | The file to import.  The path is relative to Dash Core's working directory |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                                                                           |
| -------- | ---- | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If all the keys in the file are added to the wallet (or are already part of the wallet), JSON `null` will be returned |

_Example from Dash Core 0.12.2_

Import the file shown in the example subsection of the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet).

```bash
dash-cli -testnet importwallet /tmp/dump.txt
```

(Success: no result displayed.)

_See also_

* [DumpWallet](../api/remote-procedure-calls-wallet.md#dumpwallet): creates or overwrites a file with all wallet keys in a human-readable format.
* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).

## KeyPoolRefill

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`keypoolrefill` RPC](../api/remote-procedure-calls-wallet.md#keypoolrefill) fills the cache of unused pre-generated keys (the keypool).

_Parameter #1---the new keypool size_

| Name          | Type         | Presence             | Description                                                                                                                                                                                                                                                              |
| ------------- | ------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Key Pool Size | number (int) | Optional<br>(0 or 1) | The new size of the keypool; if the number of keys in the keypool is less than this number, new keys will be generated.  Default is `1000`.  The value `0` also equals the default.  The value specified is for this call only---the default keypool size is not changed |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                         |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the keypool is successfully filled, JSON `null` will be returned |

_Example from Dash Core 0.12.2_

Generate one extra key than the default:

```bash
dash-cli -testnet keypoolrefill 1001
```

(No result shown: success.)

_See also_

* [GetNewAddress](../api/remote-procedure-calls-wallet.md#getnewaddress): returns a new Dash address for receiving payments. If an account is specified, payments received with the address will be credited to that account.
* [GetWalletInfo](../api/remote-procedure-calls-wallet.md#getwalletinfo): provides information about the wallet.

## ListAddressBalances

The [`listaddressbalances` RPC](../api/remote-procedure-calls-wallet.md#listaddressbalances) lists addresses of this wallet and their balances

_Parameter #1---Minimum Amount_

| Name           | Type          | Presence             | Description                                                                        |
| -------------- | ------------- | -------------------- | ---------------------------------------------------------------------------------- |
| Minimum Amount | numeric (int) | Optional<br>(0 or 1) | Minimum balance in DASH an address should have to be shown in the list (default=0) |

_Result---an object containing the addresses and their balances_

| Name                | Type                              | Presence                | Description                                                                                                              |
| ------------------- | --------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `result`            | object                            | Required<br>(exactly 1) | An object containing key/value pairs corresponding to the addresses with balances > the minimum amount.  May be empty    |
| →<br>Address/Amount | string (base58):<br>number (DASH) | Optional<br>(1 or more) | A key/value pair with a base58check-encoded string containing the address as the key, and an amount of DASH as the value |

_Example from Dash Core 0.12.3_

```bash
dash-cli -testnet listaddressbalances 25
```

Result:

```json
{
  "yMQtQkcMBXrAZyqTGZeg7tQHzmbypGEP4w": 299.99990000,
  "yRyfgrHm4f5A8GGvqpqTFvbCrCQHJm1L4V": 99.13570000,
  "ybePwhPzUbiWzFhkgxPgP6iHnTLTyFH6sU": 123.45600000,
  "ycCdPQnjNEVRgrQY8j6mxEx9h7oaQpo5Ge": 500.00000000
}
```

_See also:_

* [ListAddressGroupings](../api/remote-procedure-calls-wallet.md#listaddressgroupings): lists groups of addresses that may have had their common ownership made public by common use as inputs in the same transaction or from being used as change from a previous transaction.

## ListAddressGroupings

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listaddressgroupings` RPC](../api/remote-procedure-calls-wallet.md#listaddressgroupings) lists groups of addresses that may have had their common ownership made public by common use as inputs in the same transaction or from being used as change from a previous transaction.

_Parameters: none_

_Result---an array of arrays describing the groupings_

| Name                   | Type              | Presence                | Description                                                                           |
| ---------------------- | ----------------- | ----------------------- | ------------------------------------------------------------------------------------- |
| `result`               | array             | Required<br>(exactly 1) | An array containing the groupings.  May be empty                                      |
| →<br>Groupings         | array             | Optional<br>(0 or more) | An array containing arrays of addresses which can be associated with each other       |
| → →<br>Address Details | array             | Required<br>(1 or more) | An array containing information about a particular address                            |
| → → →<br>Address       | string (base58)   | Required<br>(exactly 1) | The address in base58check format                                                     |
| → → →<br>Amount        | number (bitcoins) | Required<br>(exactly 1) | The amount in DASH                                                                    |
| → → →<br>Label         | string            | Optional<br>(0 or 1)    | _Replaced "Account" in Dash Core 0.17.0_<br>The label the address belongs to, if any. |

_Example from Dash Core 0.17.0_

```bash
dash-cli -testnet listaddressgroupings
```

Result (edited to only three results):

```json
[
  [
    [
      "yacJKd6tRz2JSn8Wfp9GKgCbuowAEBivrA",
      10.00000000,
      "Doc test"
    ]
  ],
  [
    [
      "ye5XTjKqXyrVizEzky255NXUsaNSPC2W7k",
      5.00000000,
      ""
    ]
  ]
]
```

_See also_

* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction.
* [ListAddressBalances](../api/remote-procedure-calls-wallet.md#listaddressbalances): lists addresses of this wallet and their balances

## ListDescriptors

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**). Wallet must be unlocked.
:::

_Added in Dash Core 21.0.0_

The [`listdescriptors` RPC](../api/remote-procedure-calls-wallet.md#listdescriptors) lists descriptors imported into a descriptor-enabled wallet.

_Result---execution result_

| Name              | Type           | Presence                | Description |
| ----------------- | -------------- | ----------------------- | ----------- |
| `wallet_name`     | string         | Required<br>(exactly 1) | Name of wallet this operation was performed on |
| `descriptors`     | array          | Required<br>(exactly 1) | An array of JSON objects, each describing a descriptor |
| → Descriptor      | object         | Required<br>(1 or more) | A JSON object describing a particular descriptor |
| → →<br>`desc`     | string         | Required<br>(exactly 1) | Descriptor string representation |
| → →<br>`timestamp`| number (int)   | Required<br>(exactly 1) | The creation time of the descriptor in Unix epoch time |
| → →<br>`active`   | bool           | Required<br>(exactly 1) | Indicates whether this descriptor is currently used to generate new addresses |
| → →<br>`internal` | bool           | Optional<br>(0 or 1)    | True if this descriptor is used to generate change addresses; False if used for receiving |
| → →<br>`range`    | array          | Optional<br>(0 or 1)    | Defined only for ranged descriptors |
| → →→<br>`start`   | number (int)   | Required<br>(exactly 1) | Range start inclusive |
| → →→<br>`end`     | number (int)   | Required<br>(exactly 1) | Range end inclusive |
| → →<br>`next`     | number (int)   | Optional<br>(0 or 1)    | The next index to generate addresses from; defined only for ranged descriptors |

_Example from Dash Core 21.1.0_

List all descriptors in a descriptor-enabled wallet:

```bash
dash-cli listdescriptors
```

Result (example output):

```json
{
  "wallet_name": "test-descriptor",
  "descriptors": [
    {
      "desc": "pkh([c7fe8acb/44'/1'/0']tpubDDgGSmowbmYWepHK5PJYCfzUFrKy1c7PHVumScWELYwwjaGBf73ZD1JD1xc2y4hKQDp4qHUKjxz8HQyJXmM5UQh797enQQSpq8vife8yva8/0/*)#tz4w30l2",
      "timestamp": 1715259431,
      "active": true,
      "internal": false,
      "range": [
        0,
        999
      ],
      "next": 0
    }
  ]
}
```

_See also_

* [ImportDescriptors](../api/remote-procedure-calls-wallet.md#importdescriptors): imports multiple descriptors into the wallet, each with specific attributes.

## ListLabels

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listlabels` RPC](../api/remote-procedure-calls-wallet.md#listlabels) returns the list of all labels, or labels that are assigned to addresses with a specific purpose.

_Parameter #1---purpose_

| Name    | Type   | Presence             | Description                                                                                                         |
| ------- | ------ | -------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Purpose | string | Optional<br>(0 or 1) | Address purpose to list labels for (`send`, `receive`). An empty string is the same as not providing this argument. |

_Result---a list of labels_

| Name       | Type   | Presence                | Description                                                                                        |
| ---------- | ------ | ----------------------- | -------------------------------------------------------------------------------------------------- |
| `result`   | array  | Required<br>(exactly 1) | A JSON array containing label names.  Must include, at the very least, the default account (`""`). |
| →<br>Label | string | Required<br>(1 or more) | The name of a label.                                                                               |

_Example from Dash Core 0.17.0_

Display labels used for receiving.

```bash
dash-cli -testnet listlabels "receive"
```

Result:

```json
[
  "",
  "Doc test"
]
```

_See also_

* [GetAddressesByLabel](../api/remote-procedure-calls-wallet.md#getaddressesbylabel): returns the list of addresses assigned the specified label.
* [ListReceivedByLabel](../api/remote-procedure-calls-wallet.md#listreceivedbylabel): lists the total number of Dash received by each label.

## ListLockUnspent

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listlockunspent` RPC](../api/remote-procedure-calls-wallet.md#listlockunspent) returns a list of temporarily unspendable (locked) outputs.

_Parameters: none_

_Result---an array of locked outputs_

| Name          | Type         | Presence                | Description                                                                                                                              |
| ------------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `result`      | array        | Required<br>(exactly 1) | An array containing all locked outputs.  May be empty                                                                                    |
| →<br>Output   | object       | Optional<br>(1 or more) | An object describing a particular locked output                                                                                          |
| → →<br>`txid` | string (hex) | Required<br>(exactly 1) | The TXID of the transaction containing the locked output, encoded as hex in RPC byte order                                               |
| → →<br>`vout` | number (int) | Required<br>(exactly 1) | The output index number (vout) of the locked output within the transaction.  Output index `0` is the first output within the transaction |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet listlockunspent
```

Result:

```json
[
  {
    "txid": "d3d57ec5e4168b7145e911d019e9713563c1f2db5b2d6885739ea887feca4c87",
    "vout": 0
  }
]
```

_See also_

* [LockUnspent](../api/remote-procedure-calls-wallet.md#lockunspent): temporarily locks or unlocks specified transaction outputs. A locked transaction output will not be chosen by automatic coin selection when spending dash. Locks are stored in memory only, so nodes start with zero locked outputs and the locked output list is always cleared when a node stops or fails.

## ListReceivedByAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listreceivedbyaddress` RPC](../api/remote-procedure-calls-wallet.md#listreceivedbyaddress) lists the total number of dash received by each address.

_Parameter #1---the minimum number of confirmations a transaction must have to be counted_

| Name          | Type         | Presence             | Description                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------- | ------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations an externally-generated transaction must have before it is counted towards the balance.  Transactions generated by this node are counted immediately.  Typically, externally-generated transactions are payments to this wallet and transactions generated by this node are payments to other wallets.  Use `0` to count unconfirmed transactions.  Default is `1` |

_Parameter #2---whether to include transactions locked via InstantSend_

| Name      | Type | Presence                | Description                                          |
| --------- | ---- | ----------------------- | ---------------------------------------------------- |
| addlocked | bool | Optional<br>(exactly 1) | Add the balance from InstantSend locked transactions |

_Parameter #3---whether to include empty accounts_

| Name          | Type | Presence             | Description                                                                                                                                                                                                                                                 |
| ------------- | ---- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Empty | bool | Optional<br>(0 or 1) | Set to `true` to display accounts which have never received a payment.  Set to `false` (the default) to only include accounts which have received a payment.  Any account which has received a payment will be displayed even if its current balance is `0` |

_Parameter #4---whether to include watch-only addresses in results_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is the default for watching-only wallets. |

_Parameter #5---limit returned information to a specific address_

**_Added in Dash Core 0.17.0_**

| Name           | Type   | Presence             | Description                                          |
| -------------- | ------ | -------------------- | ---------------------------------------------------- |
| Address Filter | string | Optional<br>(0 or 1) | If present, only return information for this address |

_Result---addresses, account names, balances, and minimum confirmations_

| Name                       | Type            | Presence                | Description                                                                                                                                                                                                                          |
| -------------------------- | --------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result`                   | array           | Required<br>(exactly 1) | An array containing objects each describing a particular address                                                                                                                                                                     |
| →<br>Address               | object          | Optional<br>(0 or more) | An object describing an address                                                                                                                                                                                                      |
| → →<br>`involvesWatchonly` | bool            | Optional<br>(0 or 1)    | Set to `true` if this address is a watch-only address which has received a spendable payment (that is, a payment with at least the specified number of confirmations and which is not an immature coinbase).  Otherwise not returned |
| → →<br>`address`           | string (base58) | Required<br>(exactly 1) | The address being described encoded in base58check                                                                                                                                                                                   |
| → →<br>`amount`            | number (dash)   | Required<br>(exactly 1) | The total amount the address has received in dash                                                                                                                                                                                    |
| → →<br>`confirmations`     | number (int)    | Required<br>(exactly 1) | The number of confirmations of the latest transaction to the address.  May be `0` for unconfirmed                                                                                                                                    |
| → →<br>`label`             | string          | Required<br>(exactly 1) | The account the address belongs to.  May be the default account, an empty string (\\")"                                                                                                                                              |
| → →<br>`txids`             | array           | Required<br>(exactly 1) | An array of TXIDs belonging to transactions that pay the address                                                                                                                                                                     |
| → → →<br>TXID              | string          | Optional<br>(0 or more) | The TXID of a transaction paying the address, encoded as hex in RPC byte order                                                                                                                                                       |

_Example from Dash Core 0.13.0_

List addresses with balances confirmed by at least six blocks, including  
watch-only addresses. Also include the balance from InstantSend locked transactions:

```bash
dash-cli -testnet listreceivedbyaddress 6 true false true
```

Result (edit to show only two entries):

```json
[
  {
    "address": "yV3ZTfwyfUmpspncMSitiwzh7EvqSGrqZA",
    "amount": 1000.00000000,
    "confirmations": 26779,
    "label": "",
    "txids": [
      "0456aaf51a8df21dd47c2a06ede046a5bf7403bcb95d14d1d71b178c189fb933"
    ]
  },
  {
    "involvesWatchonly" : true,
    "address": "yfoR9uM3rcDfUc7AEfUNm5BjVYGFw7uQ9w",
    "amount": 1877.78476068,
    "confirmations": 26876,
    "label": "Watching",
    "txids": [
      "cd64114c803a2a243cb6ce4eb5c98e60cd2c688be8e900b3b957fe520cf42601",
      "83d3f7f31926908962e336341b1895d5f734f9d7149bdb35f0381cc78019bd83"
    ]
  }
]
```

_See also_

* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.

## ListReceivedByLabel

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listreceivedbylabel` RPC](../api/remote-procedure-calls-wallet.md#listreceivedbylabel) lists the total number of Dash received by each label.

_Parameter #1---the minimum number of confirmations a transaction must have to be counted_

| Name          | Type         | Presence             | Description                                                                                                                                                       |
| ------------- | ------------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations a  transaction must have before it is counted towards the balance. Use `0` to count unconfirmed transactions.  Default is `1` |

_Parameter #2---whether to include transactions locked via InstantSend_

| Name      | Type | Presence                | Description                                          |
| --------- | ---- | ----------------------- | ---------------------------------------------------- |
| addlocked | bool | Optional<br>(exactly 1) | Add the balance from InstantSend locked transactions |

_Parameter #3---whether to include empty accounts_

| Name          | Type | Presence             | Description                                                                                                                                                                                                                                                 |
| ------------- | ---- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Empty | bool | Optional<br>(0 or 1) | Set to `true` to display accounts which have never received a payment.  Set to `false` (the default) to only include accounts which have received a payment.  Any account which has received a payment will be displayed even if its current balance is `0` |

_Parameter #4---whether to include watch-only addresses in results_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is the default for watching-only wallets. |

_Result---account names, balances, and minimum confirmations_

| Name                       | Type          | Presence                | Description                                                                                                                                                                                                                                               |
| -------------------------- | ------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                   | array         | Required<br>(exactly 1) | An array containing objects each describing an account.  At the very least, the default account (\\") will be included"                                                                                                                                   |
| →<br>Label                 | object        | Required<br>(1 or more) | An object describing a label                                                                                                                                                                                                                              |
| → →<br>`involvesWatchonly` | bool          | Optional<br>(0 or 1)    | Set to `true` if the balance of this account includes a watch-only address which has received a spendable payment (that is, a payment with at least the specified number of confirmations and which is not an immature coinbase).  Otherwise not returned |
| → →<br>`account`           | string        | Required<br>(exactly 1) | _Deprecated_<br>Backwards compatible alias for label                                                                                                                                                                                                      |
| → →<br>`amount`            | number (dash) | Required<br>(exactly 1) | The total amount received by this account in dash                                                                                                                                                                                                         |
| → →<br>`confirmations`     | number (int)  | Required<br>(exactly 1) | The number of confirmations received by the last transaction received by this account.  May be `0`                                                                                                                                                        |
| → →<br>`label`             | string        | Optional<br>(0 or 1)    | The label of the receiving address. The default label is `""`.                                                                                                                                                                                            |

_Example from Dash Core 0.17.0_

Get the balances for all non-empty accounts, including transactions which have been confirmed at least six times and InstantSend locked transactions:

```bash
dash-cli -testnet listreceivedbylabel 6 true false true
```

Result:

```json
[
  {
    "account": "",
    "amount": 5.00000000,
    "confirmations": 33,
    "label": ""
  },
  {
    "account": "Doc test",
    "amount": 10.00000000,
    "confirmations": 47,
    "label": "Doc test"
  }
]
```

_See also_

* [ListReceivedByAddress](../api/remote-procedure-calls-wallet.md#listreceivedbyaddress): lists the total number of dash received by each address.
* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions.

```{eval-rst}
.. _api-rpc-wallet-listsinceblock:
```

## ListSinceBlock

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listsinceblock` RPC](../api/remote-procedure-calls-wallet.md#listsinceblock) gets all transactions affecting the wallet which have occurred since a particular block, plus the header hash of a block at a particular depth.

_Parameter #1---a block header hash_

| Name        | Type         | Presence             | Description                                                                                                                                                                                                                                                                                                            |
| ----------- | ------------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Header Hash | string (hex) | Optional<br>(0 or 1) | The hash of a block header encoded as hex in RPC byte order.  All transactions affecting the wallet which are not in that block or any earlier block will be returned, including unconfirmed transactions.  Default is the hash of the genesis block, so all transactions affecting the wallet are returned by default |

_Parameter #2---the target confirmations for the lastblock field_

| Name                 | Type         | Presence             | Description                                                                                                                                                                                                                                                |
| -------------------- | ------------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Target Confirmations | number (int) | Optional<br>(0 or 1) | Sets the lastblock field of the results to the header hash of a block with this many confirmations.  This does not affect which transactions are returned.  Default is `1`, so the hash of the most recent block on the local best block chain is returned |

_Parameter #3---whether to include watch-only addresses in details and calculations_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is the default for watching-only wallets. |

_Parameter #4---include_removed_

| Name            | Type | Presence                   | Description                                                                                                           |
| --------------- | ---- | -------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| include_removed | bool | Optional<br>Default=`true` | Show transactions that were removed due to a reorg in the \\removed\" array (not guaranteed to work on pruned nodes)" |

**Result**

| Name                         | Type            | Presence                    | Description                                                                                                                                                                                                                                                                                                                                                                                   |
| ---------------------------- | --------------- | --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                     | object          | Required<br>(exactly 1)     | An object containing an array of transactions and the lastblock field                                                                                                                                                                                                                                                                                                                         |
| →<br>`transactions`          | array           | Required<br>(exactly 1)     | An array of objects each describing a particular **payment** to or from this wallet.  The objects in this array do not describe an actual transactions, so more than one object in this array may come from the same transaction.  This array may be empty                                                                                                                                    |
| → →<br>Payment               | object          | Optional<br>(0 or more)     | An payment which did not appear in the specified block or an earlier block                                                                                                                                                                                                                                                                                                                    |
| → <br>`involvesWatchonly`    | bool            | Optional<br>(0 or 1)        | Set to `true` if the payment involves a watch-only address.  Otherwise not returned                                                                                                                                                                                                                                                                                                           |
| → <br>`address`              | string (base58) | Optional<br>(0 or 1)        | The address paid in this payment, which may be someone else's address not belonging to this wallet.  May be empty if the address is unknown, such as when paying to a non-standard pubkey script                                                                                                                                                                                              |
| → <br>`category`             | string          | Required<br>(exactly 1)     | Set to one of the following values:<br>• `send` if sending payment normally<br>• `coinjoin` if sending CoinJoin payment<br>• `receive` if this wallet received payment in a regular transaction<br>• `generate` if a matured and spendable coinbase<br>• `immature` if a coinbase that is not spendable yet<br>• `orphan` if a coinbase from a block that's not in the local best block chain |
| → <br>`amount`               | number (dash)   | Required<br>(exactly 1)     | A negative dash amount if sending payment; a positive dash amount if receiving payment (including coinbases)                                                                                                                                                                                                                                                                                  |
| → <br>`vout`                 | number (int)    | Required<br>(exactly 1)     | For an output, the output index (vout) for this output in this transaction.  For an input, the output index for the output being spent in its transaction.  Because inputs list the output indexes from previous transactions, more than one entry in the details array may have the same output index                                                                                        |
| → <br>`fee`                  | number (dash)   | Optional<br>(0 or 1)        | If sending payment, the fee paid as a negative dash value.  May be `0`. Not returned if receiving payment                                                                                                                                                                                                                                                                                     |
| → <br>`confirmations`        | number (int)    | Required<br>(exactly 1)     | The number of confirmations the transaction has received.  Will be `0` for unconfirmed and `-1` for conflicted                                                                                                                                                                                                                                                                                |
| →<br>`instantlock`          | bool           | Required<br>(exactly 1) | If set to `true`, this transaction is either protected by an [InstantSend](../resources/glossary.md#instantsend) lock or it is in a block that has received a [ChainLock](../resources/glossary.md#chainlock) |
| →<br>`instantlock_internal` | bool           | Required<br>(exactly 1) | If set to `true`, this transaction has an [InstantSend](../resources/glossary.md#instantsend) lock |
| → <br>`chainlock`            | bool            | Required<br>(exactly 1)     |  If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org)                                                                                                                                                                                                                                                       |
| → <br>`generated`            | bool            | Optional<br>(0 or 1)        | Set to `true` if the transaction is a coinbase.  Not returned for regular transactions                                                                                                                                                                                                                                                                                                        |
| → <br>`blockhash`            | string (hex)    | Optional<br>(0 or 1)        | The hash of the block on the local best block chain which includes this transaction, encoded as hex in RPC byte order.  Only returned for confirmed transactions                                                                                                                                                                                                                              |
| → <br>`blockheight`            | string (hex)    | Optional<br>(0 or 1)        | The block height containing the transaction.                                                                                                                                                                                                                              |
| → <br>`blockindex`           | number (int)    | Optional<br>(0 or 1)        | The index of the transaction in the block that includes it.  Only returned for confirmed transactions                                                                                                                                                                                                                                                                                         |
| → <br>`blocktime`            | number (int)    | Optional<br>(0 or 1)        | The block header time (Unix epoch time) of the block on the local best block chain which includes this transaction.  Only returned for confirmed transactions                                                                                                                                                                                                                                 |
| → <br>`txid`                 | string (hex)    | Required<br>(exactly 1)     | The TXID of the transaction, encoded as hex in RPC byte order                                                                                                                                                                                                                                                                                                                                 |
| → <br>`walletconflicts`      | array           | Required<br>(exactly 1)     | An array containing the TXIDs of other transactions that spend the same inputs (UTXOs) as this transaction.  Array may be empty                                                                                                                                                                                                                                                               |
| → →<br>TXID                  | string (hex)    | Optional<br>(0 or more)     | The TXID of a conflicting transaction, encoded as hex in RPC byte order                                                                                                                                                                                                                                                                                                                       |
| → <br>`time`                 | number (int)    | Required<br>(exactly 1)     | A Unix epoch time when the transaction was added to the wallet                                                                                                                                                                                                                                                                                                                                |
| → <br>`timereceived`         | number (int)    | Required<br>(exactly 1)     | A Unix epoch time when the transaction was detected by the local node, or the time of the block on the local best block chain that included the transaction                                                                                                                                                                                                                                   |
| → <br>`abandoned`            | bool            | Optional<br>(0 or 1)        | `true` if the transaction has been abandoned (inputs are respendable). Only available for the 'send' category of transactions.                                                                                                                                                                                                                                                                |
| → <br>`comment`              | string          | Optional<br>(0 or 1)        | For transaction originating with this wallet, a locally-stored comment added to the transaction.  Only returned if a comment was added                                                                                                                                                                                                                                                        |
| → <br>`to`                   | string          | Optional<br>(0 or 1)        | For transaction originating with this wallet, a locally-stored comment added to the transaction identifying who the transaction was sent to.  Only returned if a comment-to was added                                                                                                                                                                                                         |
| →<br>`removed`               | array           | Optional<br>(0 or 1)        | Structure is the same as `transactions`. Only present if `include_removed` is `true`.<br>_Note_: transactions that were re-added in the active chain will appear as-is in this array, and may thus have a positive confirmation count.                                                                                                                                                        |
| →<br>`lastblock`             | string (hex)    | Required<br>(exactly 1)     | The header hash of the block with the number of confirmations specified in the _target confirmations_ parameter, encoded as hex in RPC byte order                                                                                                                                                                                                                                             |

_Example from Dash Core 20.0.0_

Get all transactions since a particular block (including watch-only transactions) and the header hash of the sixth most recent block.

```bash
dash-cli -testnet listsinceblock 0000015fb32d785efb2f792a194a14c11ef04141bb2778c04cea447cdccb4b6e 6 true true
```

Result (edited to show only two payments):

```json
{
  "transactions": [
    {
      "address": "yeTgphnEhKjfTx2f57Ncf4AHLPhGKo1pyN",
      "category": "send",
      "amount": -0.10000000,
      "label": "",
      "vout": 0,
      "fee": -0.00000225,
      "confirmations": 1090,
      "instantlock": true,
      "instantlock_internal": false,
      "chainlock": true,
      "blockhash": "000000f57f3228da3c544cd9a44e9b869648f0acd5e4cddcda10d576545a6363",
      "blockheight": 874910,
      "blockindex": 2,
      "blocktime": 1690306466,
      "txid": "54843571f544a46a2901a499857bbb79a340eba57f0c31e0c7cc8883ccdbc719",
      "walletconflicts": [
      ],
      "time": 1690306444,
      "timereceived": 1690306444,
      "abandoned": false
    },
    {
      "address": "yeTgphnEhKjfTx2f57Ncf4AHLPhGKo1pyN",
      "category": "receive",
      "amount": 0.10000000,
      "label": "",
      "vout": 0,
      "confirmations": 1090,
      "instantlock": true,
      "instantlock_internal": false,
      "chainlock": true,
      "blockhash": "000000f57f3228da3c544cd9a44e9b869648f0acd5e4cddcda10d576545a6363",
      "blockheight": 874910,
      "blockindex": 2,
      "blocktime": 1690306466,
      "txid": "54843571f544a46a2901a499857bbb79a340eba57f0c31e0c7cc8883ccdbc719",
      "walletconflicts": [
      ],
      "time": 1690306444,
      "timereceived": 1690306444
    },
  ],
  "removed": [
  ],
  "lastblock": "0000017d9ae3c1e4a53b5871936a09912aca5d6131b0cc0aeb886145abefc4e7"
}
```

_See also_

* [ListReceivedByAddress](../api/remote-procedure-calls-wallet.md#listreceivedbyaddress): lists the total number of dash received by each address.

```{eval-rst}
.. _api-rpc-wallet-listtransactions:
```

## ListTransactions

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listtransactions` RPC](../api/remote-procedure-calls-wallet.md#listtransactions) returns the most recent transactions that affect the wallet. If a label name is provided, this will return only incoming transactions paying to addresses with the specified label.

_Parameter #1---a label name_

| Name  | Type   | Presence             | Description                                                                                                                                                    |
| ----- | ------ | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Label | string | Optional<br>(0 or 1) | If set, should be a valid label name to return only incoming transactions with the specified label, or `"*"` to disable filtering and return all transactions. |

_Parameter #2---the number of transactions to get_

| Name  | Type         | Presence             | Description                                                          |
| ----- | ------------ | -------------------- | -------------------------------------------------------------------- |
| Count | number (int) | Optional<br>(0 or 1) | The number of the most recent transactions to list.  Default is `10` |

_Parameter #3---the number of transactions to skip_

| Name | Type         | Presence             | Description                                                                                                                 |
| ---- | ------------ | -------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Skip | number (int) | Optional<br>(0 or 1) | The number of the most recent transactions which should not be returned.  Allows for pagination of results.  Default is `0` |

_Parameter #4---whether to include watch-only addresses in details and calculations_

| Name               | Type | Presence             | Description                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | ---- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include Watch-Only | bool | Optional<br>(0 or 1) | If set to `true`, include watch-only addresses in details and calculations as if they were regular addresses belonging to the wallet.  If set to `false` (the default for non-watching only wallets), treat watch-only addresses as if they didn't belong to this wallet.<br>As of Dash Core 18.1, `true` is the default for watching-only wallets. |

_Result---payment details_

| Name                        | Type            | Presence                | Description                                                                                                                                                                                                                                                                                                                                                                        |
| --------------------------- | --------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `result`                    | array           | Required<br>(exactly 1) | An array containing objects, with each object describing a **payment** or internal accounting entry (not a transaction).  More than one object in this array may come from a single transaction.  Array may be empty                                                                                                                                                               |
| →<br>Payment                | object          | Optional<br>(0 or more) | A payment or internal accounting entry                                                                                                                                                                                                                                                                                                                                             |
| → →<br>`address`            | string (base58) | Optional<br>(0 or 1)    | The address paid in this payment, which may be someone else's address not belonging to this wallet.  May be empty if the address is unknown, such as when paying to a non-standard pubkey script or if this is in the _move_ category                                                                                                                                              |
| → →<br>`category`           | string          | Required<br>(exactly 1) | Set to one of the following values:<br>• `send` if sending payment<br>• `coinjoin` if sending CoinJoin funds<br>• `receive` if this wallet received payment in a regular transaction<br>• `generate` if a matured and spendable coinbase<br>• `immature` if a coinbase that is not spendable yet<br>• `orphan` if a coinbase from a block that's not in the local best block chain |
| → →<br>`amount`             | number (dash)   | Required<br>(exactly 1) | A negative dash amount if sending payment; a positive dash amount if receiving payment (including coinbases)                                                                                                                                                                                                                                                                       |
| → →<br>`label`              | string          | Optional<br>(0 or 1)    | A comment for the address/transaction                                                                                                                                                                                                                                                                                                                                              |
| → →<br>`vout`               | number (int)    | Optional<br>(0 or 1)    | For an output, the output index (vout) for this output in this transaction.  For an input, the output index for the output being spent in its transaction.  Because inputs list the output indexes from previous transactions, more than one entry in the details array may have the same output index.  Not returned for _move_ category payments                                 |
| → →<br>`fee`                | number (dash)   | Optional<br>(0 or 1)    | If sending payment, the fee paid as a negative dash value.  May be `0`. Not returned if receiving payment or for _move_ category payments                                                                                                                                                                                                                                          |
| → →<br>`confirmations`      | number (int)    | Optional<br>(0 or 1)    | The number of confirmations the transaction has received.  Will be `0` for unconfirmed and `-1` for conflicted.  Not returned for _move_ category payments                                                                                                                                                                                                                         |
| →<br>`instantlock`          | bool           | Required<br>(exactly 1) | If set to `true`, this transaction is either protected by an [InstantSend](../resources/glossary.md#instantsend) lock or it is in a block that has received a [ChainLock](../resources/glossary.md#chainlock) |
| →<br>`instantlock_internal` | bool           | Required<br>(exactly 1) | If set to `true`, this transaction has an [InstantSend](../resources/glossary.md#instantsend) lock |
| <br>`chainlock`             | bool            | Required<br>(exactly 1) |  If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org)                                                                                                                                                                                                                                            |
| → →<br>`generated`          | bool            | Optional<br>(0 or 1)    | Set to `true` if the transaction is a coinbase.  Not returned for regular transactions or _move_ category payments                                                                                                                                                                                                                                                                 |
| → →<br>`trusted`            | bool            | Optional<br>(0 or 1)    | Indicates whether we consider the outputs of this unconfirmed transaction safe to spend.  Only returned for unconfirmed transactions                                                                                                                                                                                                                                               |
| → →<br>`blockhash`          | string (hex)    | Optional<br>(0 or 1)    | The hash of the block on the local best block chain which includes this transaction, encoded as hex in RPC byte order.  Only returned for confirmed transactions                                                                                                                                                                                                                   |
| → →<br>`blockheight`        | string (hex)    | Optional<br>(0 or 1)    | The block height containing the transaction.
                                                        |
| → →<br>`blockindex`         | number (int)    | Optional<br>(0 or 1)    | The index of the transaction in the block that includes it.  Only returned for confirmed transactions                                                                                                                                                                                                                                                                              |
| → →<br>`blocktime`          | number (int)    | Optional<br>(0 or 1)    | The block header time (Unix epoch time) of the block on the local best block chain which includes this transaction.  Only returned for confirmed transactions                                                                                                                                                                                                                      |
| → →<br>`txid`               | string (hex)    | Optional<br>(0 or 1)    | The TXID of the transaction, encoded as hex in RPC byte order.  Not returned for _move_ category payments                                                                                                                                                                                                                                                                          |
| → →<br>`walletconflicts`    | array           | Optional<br>(0 or 1)    | An array containing the TXIDs of other transactions that spend the same inputs (UTXOs) as this transaction.  Array may be empty.  Not returned for _move_ category payments                                                                                                                                                                                                        |
| → → →<br>TXID               | string (hex)    | Optional<br>(0 or more) | The TXID of a conflicting transaction, encoded as hex in RPC byte order                                                                                                                                                                                                                                                                                                            |
| → →<br>`time`               | number (int)    | Required<br>(exactly 1) | A Unix epoch time when the transaction was added to the wallet                                                                                                                                                                                                                                                                                                                     |
| → →<br>`timereceived`       | number (int)    | Optional<br>(0 or 1)    | A Unix epoch time when the transaction was detected by the local node, or the time of the block on the local best block chain that included the transaction.  Not returned for _move_ category payments                                                                                                                                                                            |
| → →<br>`comment`            | string          | Optional<br>(0 or 1)    | For transaction originating with this wallet, a locally-stored comment added to the transaction.  Only returned in regular payments if a comment was added.  Always returned in _move_ category payments.  May be an empty string                                                                                                                                                  |
| → →<br>`to`                 | string          | Optional<br>(0 or 1)    | For transaction originating with this wallet, a locally-stored comment added to the transaction identifying who the transaction was sent to.  Only returned if a comment-to was added.  Never returned by _move_ category payments.  May be an empty string                                                                                                                        |
| → →<br>`otheraccount`       | string          | Optional<br>(0 or 1)    | This is the account the dash were moved from or moved to, as indicated by a negative or positive _amount_ field in this payment.  Only returned by _move_ category payments                                                                                                                                                                                                        |
| → →<br>`abandoned`          | bool            | Optional<br>(0 or 1)    | _Added in Bitcoin Core 0.12.1_<br><br>Indicates if a transaction is was abandoned:<br>• `true` if it was abandoned (inputs are respendable)<br>• `false`  if it was not abandoned<br>Only returned by _send_ category payments                                                                                                                                                     |

_Example from Dash Core 0.17.0_

List the most recent transaction including watch-only addresses.

```bash
dash-cli listtransactions "*" 1 0 true
```

Result:

```json
[
  {
    "address": "yeTgphnEhKjfTx2f57Ncf4AHLPhGKo1pyN",
    "category": "send",
    "amount": -0.10000000,
    "label": "",
    "vout": 1,
    "fee": -0.00002136,
    "confirmations": 641,
    "instantlock": true,
    "instantlock_internal": false,
    "chainlock": true,
    "blockhash": "000000f57f3228da3c544cd9a44e9b869648f0acd5e4cddcda10d576545a6363",
    "blockheight": 874910,
    "blockindex": 11,
    "blocktime": 1690306466,
    "txid": "14974ceb63f214fbb6a6876944a03b2c9e8a519b5115b3f18c76ef27994486df",
    "walletconflicts": [
    ],
    "time": 1690306449,
    "timereceived": 1690306449,
    "abandoned": false
  }
]
```

_See also_

* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction.
* [ListSinceBlock](../api/remote-procedure-calls-wallet.md#listsinceblock): gets all transactions affecting the wallet which have occurred since a particular block, plus the header hash of a block at a particular depth.

## ListUnspent

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`listunspent` RPC](../api/remote-procedure-calls-wallet.md#listunspent) returns an array of unspent transaction outputs belonging to this wallet. **Note:** as of Bitcoin Core 0.10.0, outputs affecting watch-only addresses will be returned; see the _spendable_ field in the results described below.

_Parameter #1---the minimum number of confirmations an output must have_

| Name                  | Type         | Presence             | Description                                                                                                                                                                          |
| --------------------- | ------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Minimum Confirmations | number (int) | Optional<br>(0 or 1) | The minimum number of confirmations the transaction containing an output must have in order to be returned.  Use `0` to return outputs from unconfirmed transactions. Default is `1` |

_Parameter #2---the maximum number of confirmations an output may have_

| Name                  | Type         | Presence             | Description                                                                                                                                    |
| --------------------- | ------------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Maximum Confirmations | number (int) | Optional<br>(0 or 1) | The maximum number of confirmations the transaction containing an output may have in order to be returned.  Default is `9999999` (~10 million) |

_Parameter #3---the addresses an output must pay_

| Name         | Type            | Presence                | Description                                                                  |
| ------------ | --------------- | ----------------------- | ---------------------------------------------------------------------------- |
| Addresses    | array           | Optional<br>(0 or 1)    | If present, only outputs which pay an address in this array will be returned |
| →<br>Address | string (base58) | Required<br>(1 or more) | A P2PKH or P2SH address                                                      |

_Parameter #4---include unsafe outputs_

| Name           | Type | Presence                    | Description                                                                                                |
| -------------- | ---- | --------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Include Unsafe | bool | Optional<br>(false or true) | Include outputs that are not safe to spend . See description of `safe` attribute below.  Default is `true` |

_Parameter #5---query options_

| Name          | Type | Presence | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------- | ---- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Query Options | json | Optional | JSON with query options. Available options:<br> - `minimumAmount`: Minimum value of each UTXO in DASH<br> - `maximumAmount`: Maximum value of each UTXO in DASH<br> - `maximumCount`: Maximum number of UTXOs<br> - `minimumSumAmount`: Minimum sum value of all UTXOs in DASH<br> - `coinType`: Filter coinTypes as follows:<br>0 = `ALL_COINS`, <br>1 = `ONLY_FULLY_MIXED`, <br>2 = `ONLY_READY_TO_MIX`, <br>3 = `ONLY_NONDENOMINATED`, <br>4 = `ONLY_MASTERNODE_COLLATERAL`, <br>5 = `ONLY_COINJOIN_COLLATERAL` |

_Result---the list of unspent outputs_

| Name                     | Type            | Presence                 | Description                                                                                                                                                                                                                                            |
| ------------------------ | --------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result`                 | array           | Required<br>(exactly 1)  | An array of objects each describing an unspent output.  May be empty                                                                                                                                                                                   |
| →<br>Unspent Output      | object          | Optional<br>(0 or more)  | An object describing a particular unspent output belonging to this wallet                                                                                                                                                                              |
| → →<br>`txid`            | string (hex)    | Required<br>(exactly 1)  | The TXID of the transaction containing the output, encoded as hex in RPC byte order                                                                                                                                                                    |
| → →<br>`vout`            | number (int)    | Required<br>(exactly 1)  | The output index number (vout) of the output within its containing transaction                                                                                                                                                                         |
| → →<br>`address`         | string (base58) | Optional<br>(0 or 1)     | The P2PKH or P2SH address the output paid.  Only returned for P2PKH or P2SH output scripts                                                                                                                                                             |
| → →<br>`scriptPubKey`    | string (hex)    | Required<br>(exactly 1)  | The output script paid, encoded as hex                                                                                                                                                                                                                 |
| → →<br>`redeemScript`    | string (hex)    | Optional<br>(0 or 1)     | If the output is a P2SH whose script belongs to this wallet, this is the redeem script                                                                                                                                                                 |
| → →<br>`amount`          | number (int)    | Required<br>(exactly 1)  | The amount paid to the output in dash                                                                                                                                                                                                                  |
| → →<br>`confirmations`   | number (int)    | Required<br>(exactly 1)  | The number of confirmations received for the transaction containing this output                                                                                                                                                                        |
| → →<br>`spendable`       | bool            | Required<br>(exactly 1)  | Set to `true` if the private key or keys needed to spend this output are part of the wallet.  Set to `false` if not (such as for watch-only addresses)                                                                                                 |
| → →<br>`solvable`        | bool            | Required<br>(exactly 1)  | _Added in Bitcoin Core 0.13.0_<br><br>Set to `true` if the wallet knows how to spend this output.  Set to `false` if the wallet does not know how to spend the output.  It is ignored if the private keys are available                                |
| → →<br>`desc`            | string          | Optional<br>(0 or 1)     | A descriptor for spending this output                                                                                                                                                                                                                  |
| → →<br>`reused`          | bool            | Optional<br>(0 or 1)     | _Added in Dash Core 18.1.0_<br>Whether this output is reused/dirty (sent to an address that was previously spent from)                                                                                                                               |
| → →<br>`safe`            | bool            | Required<br>(exactly 1)  | _Added in Bitcoin Core 0.15.0_<br><br>Whether this output is considered safe to spend. Unconfirmed transactions from outside keys are considered unsafe and are not eligible for spending by `fundrawtransaction` and `sendtoaddress`.                 |
| → →<br>`coinjoin_rounds` | number (int)    | Required<br>(exactly 1)  | The number of rounds                                                                                                                                                                                                                                   |

_Example from Dash Core 18.0.0_

Get all outputs confirmed at least 6 times for a particular address:

```bash
dash-cli -testnet listunspent 6 99999999 '''
  [
    "yYvsn6vdnkeq9VG1JbkfqKbjv3gUmFmnny"
  ]
'''
```

Result:

```json
[
  {
    "txid": "8181ac201ef2ff896f666589e98924f7cbbc885f1c42c766629f677e37cafc47",
    "vout": 0,
    "address": "yYvsn6vdnkeq9VG1JbkfqKbjv3gUmFmnny",
    "scriptPubKey": "76a9148a54e0c51084f0e5819a66bb1c4d01191f5caa3888ac",
    "amount": 0.01274051,
    "confirmations": 16007,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([8a54e0c5]0214889c34100d00aca6e7cbfe0fa72d83c28857585740bff5f3db6b37e51d9aaa)#wyvgzv2k",
    "safe": true,
    "coinjoin_rounds": -2
  }
]
```

Get all outputs for a particular address that have at least 1 confirmation and a maximum value of 10:

```shell
dash-cli -testnet listunspent 1 9999999 '''
  [
    "yYvsn6vdnkeq9VG1JbkfqKbjv3gUmFmnny"
  ]
  ''' true '''
  {
    "maximumAmount": "10"
  }
  '''
```

Result:

```json
[
  {
    "txid": "8181ac201ef2ff896f666589e98924f7cbbc885f1c42c766629f677e37cafc47",
    "vout": 0,
    "address": "yYvsn6vdnkeq9VG1JbkfqKbjv3gUmFmnny",
    "scriptPubKey": "76a9148a54e0c51084f0e5819a66bb1c4d01191f5caa3888ac",
    "amount": 0.01274051,
    "confirmations": 16008,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([8a54e0c5]0214889c34100d00aca6e7cbfe0fa72d83c28857585740bff5f3db6b37e51d9aaa)#wyvgzv2k",
    "safe": true,
    "coinjoin_rounds": -2
  }
]
```

_See also_

* [ListTransactions](../api/remote-procedure-calls-wallet.md#listtransactions): returns the most recent transactions that affect the wallet.
* [LockUnspent](../api/remote-procedure-calls-wallet.md#lockunspent): temporarily locks or unlocks specified transaction outputs. A locked transaction output will not be chosen by automatic coin selection when spending dash. Locks are stored in memory only, so nodes start with zero locked outputs and the locked output list is always cleared when a node stops or fails.

## ListWallets

The [`listwallets` RPC](../api/remote-procedure-calls-wallet.md#listwallets) returns a list of currently loaded wallets.

For full information on the wallet, use the [`getwalletinfo` RPC](../api/remote-procedure-calls-wallet.md#getwalletinfo).

_Parameters: none_

_Result_

| Name        | Type   | Presence                | Description                                                            |
| ----------- | ------ | ----------------------- | ---------------------------------------------------------------------- |
| `result`    | array  | Required<br>(exactly 1) | An array of strings containing a list of currently loaded wallet files |
| →<br>Wallet | string | Required<br>(0 or more) | The name of a wallet file                                              |

_Example from Dash Core 0.15.0_

```bash
dash-cli -testnet listwallets
```

Result:

```json
[
  "wallet.dat"
]
```

_See also: none_

## ListWalletDir

The [`listwalletdir` RPC](../api/remote-procedure-calls-wallet.md#listwalletdir) returns a list of wallets in the wallet directory.

For full information on the wallet, use the [`getwalletinfo` RPC](../api/remote-procedure-calls-wallet.md#getwalletinfo).

_Parameters: none_

_Result_

| Name      | Type   | Presence                | Description                                                                   |
| --------- | ------ | ----------------------- | ----------------------------------------------------------------------------- |
| `result`  | array  | Required<br>(exactly 1) | A JSON array of objects containing a list of wallets in the wallet directory. |
| →<br>name | string | Required<br>(0 or more) | The wallet name                                                               |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet listwalletdir
```

Result:

```json
{
  "wallets": [
    {
      "name": "demo"
    }
  ]
}
```

_See also_

* [GetWalletInfo](../api/remote-procedure-calls-wallet.md#getwalletinfo): provides information about the wallet.

## LoadWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`loadwallet` RPC](../api/remote-procedure-calls-wallet.md#loadwallet) loads a wallet from a wallet file or directory. Note that all wallet command-line options used when starting dashd will be applied to the new wallet (eg -zapwallettxes, upgradewallet, rescan, etc).

_Parameter #1---wallet name_

| Name     | Type   | Presence                | Description                                                                                                                                                                                 |
| -------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Filename | string | Required<br>(exactly 1) | The wallet directory or .dat file. The wallet can be specified as file/directory basename (which must be located in the `walletdir` directory), or as an absolute path to a file/directory. |

_Parameter #2---load on startup_

| Name            | Type    | Presence             | Description                                                                                                                                |
| --------------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| load_on_startup | boolean | Optional<br>(0 or 1) | Save wallet name to persistent settings and load on startup. True to add wallet to startup list, false to remove, null to leave unchanged. |

_Result---operation status_

| Name           | Type   | Presence                | Description                                                                      |
| -------------- | ------ | ----------------------- | -------------------------------------------------------------------------------- |
| `result`       | object | Required<br>(exactly 1) | An object containing the wallet name or warning message related to the operation |
| →<br>`name`    | string | Required                | The wallet name if loaded successfully                                           |
| →<br>`warning` | string | Required                | Warning message if wallet was not loaded cleanly                                 |

_Example from Dash Core 0.16.0_

```bash
dash-cli -testnet loadwallet wallet-test.dat
```

Result:

```json
{
  "name": "wallet-test.dat",
  "warning": ""
}
```

_See also_

* [CreateWallet](../api/remote-procedure-calls-wallet.md#createwallet): creates and loads a new wallet.
* [UnloadWallet](../api/remote-procedure-calls-wallet.md#unloadwallet): unloads the specified wallet.

## LockUnspent

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`lockunspent` RPC](../api/remote-procedure-calls-wallet.md#lockunspent) temporarily locks or unlocks specified transaction outputs. A locked transaction output will not be chosen by automatic coin selection when spending dash. Locks are stored in memory only, so nodes start with zero locked outputs and the locked output list is always cleared when a node stops or fails.

_Parameter #1---whether to lock or unlock the outputs_

| Name   | Type | Presence                | Description                                                                                                                                                                                                                                                                                       |
| ------ | ---- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Unlock | bool | Required<br>(exactly 1) | Set to `false` to lock the outputs specified in the following parameter.  Set to `true` to unlock the outputs specified.  If this is the only argument specified and it is set to `true`, all outputs will be unlocked; if it is the only argument and is set to `false`, there will be no change |

_Parameter #2---the outputs to lock or unlock_

| Name          | Type         | Presence                | Description                                                                                                            |
| ------------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Outputs       | array        | Optional<br>(0 or 1)    | An array of outputs to lock or unlock                                                                                  |
| →<br>Output   | object       | Required<br>(1 or more) | An object describing a particular output                                                                               |
| → →<br>`txid` | string       | Required<br>(exactly 1) | The TXID of the transaction containing the output to lock or unlock, encoded as hex in internal byte order             |
| → →<br>`vout` | number (int) | Required<br>(exactly 1) | The output index number (vout) of the output to lock or unlock.  The first output in a transaction has an index of `0` |

_Result---`true` if successful_

| Name     | Type | Presence                | Description                                                                                                                                    |
| -------- | ---- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `result` | bool | Required<br>(exactly 1) | Set to `true` if the outputs were successfully locked or unlocked.  If the outputs were already locked or unlocked, it will also return `true` |

_Example from Dash Core 0.12.2_

Lock two outputs:

```bash
dash-cli -testnet lockunspent false '''
  [
    {
      "txid": "d3d57ec5e4168b7145e911d019e9713563c1f2db5b2d6885739ea887feca4c87",
      "vout": 0
    },
    {
      "txid": "607897611b2f7c5b23297b2a352a8d6f4383f8d0782585f93220082d361f8db9",
      "vout": 1
    }
  ]
'''
```

Result:

```json
true
```

Verify the outputs have been locked:

```bash
dash-cli -testnet listlockunspent
```

Result

```json
[
  {
    "txid": "d3d57ec5e4168b7145e911d019e9713563c1f2db5b2d6885739ea887feca4c87",
    "vout": 0
  },
  {
    "txid": "607897611b2f7c5b23297b2a352a8d6f4383f8d0782585f93220082d361f8db9",
    "vout": 1
  }
]
```

Unlock one of the above outputs:

```bash
dash-cli -testnet lockunspent true '''
[
  {
    "txid": "607897611b2f7c5b23297b2a352a8d6f4383f8d0782585f93220082d361f8db9",
    "vout": 1
  }
]
'''
```

Result:

```json
true
```

Verify the output has been unlocked:

```bash
dash-cli -testnet listlockunspent
```

Result:

```json
[
  {
    "txid": "d3d57ec5e4168b7145e911d019e9713563c1f2db5b2d6885739ea887feca4c87",
    "vout": 0
  }
]
```

_See also_

* [ListLockUnspent](../api/remote-procedure-calls-wallet.md#listlockunspent): returns a list of temporarily unspendable (locked) outputs.
* [ListUnspent](../api/remote-procedure-calls-wallet.md#listunspent): returns an array of unspent transaction outputs belonging to this wallet.

## RemovePrunedFunds

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

_Added in Dash Core 0.12.3 / Bitcoin Core 0.13.0_

The [`removeprunedfunds` RPC](../api/remote-procedure-calls-wallet.md#removeprunedfunds) deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds. This will effect wallet balances.

_Parameter #1---the raw transaction to import_

| Name | Type            | Presence                | Description                                            |
| ---- | --------------- | ----------------------- | ------------------------------------------------------ |
| TXID | string<br>(hex) | Required<br>(exactly 1) | The hex-encoded id of the transaction you are removing |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                            |
| -------- | ---- | ----------------------- | ---------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | If the funds are removed from the wallet, JSON `null` will be returned |

_Example from Dash Core 0.12.3_

```bash
dash-cli removeprunedfunds bb7daff525b83fa6a847ab50bf7f8f14d6\
22761a19f69157b362ef3f25bda687
```

(Success: no result displayed.)

_See also_

* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [ImportPrunedFunds](../api/remote-procedure-calls-wallet.md#importprunedfunds): imports funds without the need of a rescan. Meant for use with pruned wallets.

## RescanBlockChain

The [`rescanblockchain` RPC](../api/remote-procedure-calls-wallet.md#rescanblockchain) rescans the local blockchain for wallet related transactions.

_Parameter #1---the start block height_

| Name         | Type    | Presence             | Description                                    |
| ------------ | ------- | -------------------- | ---------------------------------------------- |
| Start Height | integer | Optional<br>(0 or 1) | The block height where the rescan should start |

_Parameter #2---the stop block height_

| Name        | Type    | Presence             | Description                                  |
| ----------- | ------- | -------------------- | -------------------------------------------- |
| Stop Height | integer | Optional<br>(0 or 1) | The last block height that should be scanned |

_Result---`null` or start/end height details if parameters provided_

| Name                | Type    | Presence                | Description                                                                                      |
| ------------------- | ------- | ----------------------- | ------------------------------------------------------------------------------------------------ |
| `result`            | object  | Required<br>(exactly 1) | An object containing the start/end heights depending on the range of blocks scanned              |
| →<br>`start_height` | integer | Optional<br>(0 or 1)    | The block height where the rescan has started. If omitted, rescan started from the genesis block |
| →<br>`stop_height`  | integer | Optional<br>(0 or 1)    | The height of the last rescanned block. If omitted, rescan stopped at the chain tip              |

_Example from Dash Core 0.16.0_

```bash
dash-cli rescanblockchain
```

Result:

```json
{
  "start_height": 293600,
  "stop_height": 293602
}
```

_See also_

* [AbortRescan](../api/remote-procedure-calls-wallet.md#abortrescan): stops current wallet rescan.

## ScanTXOutset

:::{attention}
Experimental warning: this call may be removed or changed in future releases.
:::

The [`scantxoutset` RPC](../api/remote-procedure-calls-wallet.md#scantxoutset) scans the unspent transaction output set for entries that match certain output descriptors.

_Parameter #1---action_

| Name   | Type   | Presence                | Description                                                                                                                                                                                                   |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Action | string | Required<br>(exactly 1) | The action to execute:<br> - "start" for starting a scan,<br> - "abort" for aborting the current scan (returns true when abort was successful),<br> - "status" for progress report (in %) of the current scan |

_Parameter #2---scan objects_

| Name            | Type           | Presence                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------------- | -------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Scan Objects    | array          | Required<br>(exactly 1) | An array of scan objects. Every scan object is either a string descriptor or an object.                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| →<br>descriptor | string: object | Required<br>(1 or more) | An output descriptor; an object with output descriptor and metadata.<br>Examples of output descriptors are:<br> - `addr(<address>)`: Outputs whose scriptPubKey corresponds to the specified address (does not include P2PK)<br> - `raw(<hex script>)`: Outputs whose scriptPubKey equals the specified hex scripts<br> - `combo(<pubkey>)`: P2PK and P2PKH outputs for the given pubkey<br> - `pkh(<pubkey>)`: P2PKH outputs for the given pubkey<br> - `sh(multi(<n>,<pubkey>,<pubkey>,...))`: P2SH-multisig outputs for the given threshold and pubkeys |
| → →<br>desc     | string         | Required<br>(exactly 1) | An output descriptor                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| → →<br>range    | number (int)   | Optional<br>(0 or 1)    | The child index HD that chains should be explored (default: 1000)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

In the above, <pubkey> either refers to a fixed public key in hexadecimal notation, or to an xpub/xprv optionally followed by one or more path elements separated by "/", and optionally ending in "/_" (unhardened), or "/_'" or "/\*h" (hardened) to specify all unhardened or hardened child keys. In the latter case, a range needs to be specified by below if different from 1000.

_Result---The unspent and total amount_

| Name                    | Type         | Presence                | Description                                                                                            |
| ----------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------ |
| `result`                | object       | Required<br>(exactly 1) | An object containing the the unspent and total amounts.                                                |
| →<br>`success`          | bool         | Required<br>(exactly 1) | Whether the scan was completed                                                                         |
| →<br>`txouts`           | number (int) | Required<br>(exactly 1) | The number of unspent transaction outputs scanned                                                      |
| →<br>`height`           | number (int) | Required<br>(exactly 1) | The current block height (index)                                                                       |
| →<br>`bestblock`        | string (hex) | Required<br>(exactly 1) | The hash of the block at the tip of the chain                                                          |
| →<br>`unspents`         | array        | Required<br>(exactly 1) | An array containing unspent output objects                                                             |
| → →<br>Unspent output   | array        | Required<br>(1 or more) | An object containing unspent output information                                                        |
| → → →<br>`txid`         | string (hex) | Required<br>(exactly 1) | The TXID of the transaction the output appeared in.  The TXID must be encoded in hex in RPC byte order |
| → → →<br>`vout`         | number (int) | Required<br>(exactly 1) | The index number of the output (vout) as it appeared in its transaction, with the first output being 0 |
| → → →<br>`scriptPubKey` | string (hex) | Required<br>(exactly 1) | The output's pubkey script encoded as hex                                                              |
| → → →<br>`desc`         | string       | Required<br>(exactly 1) | A specialized descriptor for the matched scriptPubKey                                                  |
| → → →<br>`amount`       | number (int) | Required<br>(exactly 1) | The total amount in DASH of the unspent output                                                         |
| → → →<br>`height`       | number (int) | Required<br>(exactly 1) | The height of the unspent transaction output                                                           |
| →<br>`total_amount`     | numeric      | Required<br>(exactly 1) | The total amount of all found unspent outputs in DASH                                                  |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet scantxoutset start '["addr(yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ)"]'
```

Result:

```json
{
  "success": true,
  "txouts": 639756,
  "height": 667140,
  "bestblock": "000000ec777dd903c5a378ab209a7815b24a5365b5c53a0c22e64ef3350d33db",
  "unspents": [
    {
      "txid": "571028a9a2f69c5eec75dbae10c8724b8afd44530fac97936ae6676a9c61e03c",
      "vout": 0,
      "scriptPubKey": "76a914724c86a5dc23ecac05474d9be3ac76a6aa4bcb4488ac",
      "desc": "addr(yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ)#sycxjztu",
      "amount": 1.00000000,
      "height": 494777
    },
    {
      "txid": "3e76165230a3ff5bb8df0a9e278caa81f9a653c2b7a075f8dc16e56103c8f68e",
      "vout": 0,
      "scriptPubKey": "76a914724c86a5dc23ecac05474d9be3ac76a6aa4bcb4488ac",
      "desc": "addr(yWjoZBvnUKWhpKMbBkVVnnMD8Bzno9j6tQ)#sycxjztu",
      "amount": 7.76020488,
      "height": 494777
    }
  ],
  "total_amount": 8.76020488
}
```

_See also_

* [ListUnspent](../api/remote-procedure-calls-wallet.md#listunspent): returns an array of unspent transaction outputs belonging to this wallet.

## Send

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).

EXPERIMENTAL warning: This call may be changed in future releases.
:::

The [`send` RPC](../api/remote-procedure-calls-wallet.md#send) sends a transaction with specified outputs. This command creates and optionally broadcasts a transaction where none of the keys are duplicated in the output JSON array.

_Parameter #1---Outputs_

| Name    | Type         | Presence                | Description                                  |
| ------- | ------------ | ----------------------- | -------------------------------------------- |
| outputs | json array   | Required<br>(exactly 1) | A JSON array with outputs as key-value pairs. Each address can only appear once, and only one 'data' object is allowed.  |
| → Output       | object                | Required<br>(1 or more) | Each object in the array represents an output of the transaction. |
| → →<br>`address` | string: number (DASH) | Optional<br>(0 or 1)    | A key-value pair where the key is the Dash address and the value is the amount in DASH. The value can be specified as a numeric value or a string representing the amount. |
| → →<br>`data`    | string: string (hex)  | Optional<br>(0 or 1)    | A key-value pair where the key must be `"data"`, and the value is hex-encoded data. |

_Parameter #2---conf_target_

| Name         | Type          | Presence             | Description                               |
| ------------ | ------------- | -------------------- | ----------------------------------------- |
| conf_target  | numeric (int) | Optional<br>(0 or 1) | Confirmation target (in blocks) for the transaction, or fee rate (for DASH/kB or duff/B estimate modes). Uses wallet's default configuration. |

_Parameter #3---estimate_mode_

| Name           | Type   | Presence             | Description                                                                                                               |
| -------------- | ------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| estimate_mode  | string | Optional<br>(0 or 1) | The fee estimate mode. Must be one of: `unset`, `economical`, `conservative`, `DASH/kB`, `duff/B`. Default is `unset`.   |

_Parameter #4---Fee rate_

| Name     | Type    | Presence                | Description |
| -------- | ------- | ----------------------- | ----------- |
| fee_rate | number or string | Optional<br>(0 or 1)    | **Added in Dash Core 22.0.0**<br>Specify a fee rate in duffs/B (default=not set, fall back to wallet fee estimation). |

_Parameter #5---Options_

| Name                        | Type               | Presence                | Description                                         |
| --------------------------- | ------------------ | ----------------------- | --------------------------------------------------- |
| options                     | json object        | Optional<br>(0 or 1)    | Additional configuration settings for the transaction. |
| → <br>`add_inputs`          | bool               | Optional<br>(0 or 1)    | If set to `true`, automatically includes more inputs if the initially specified inputs are not sufficient. Defaults to `false`.|
| → <br>`add_to_wallet`       | bool               | Optional<br>(0 or 1)    | If `false`, returns the transaction as a serialized hex string and does not add it to the wallet or broadcast it. Defaults to `true`. |
| → <br>`change_address`      | string (hex)       | Optional<br>(0 or 1)    | The Dash address to receive the change. |
| → <br>`change_position`     | numeric (int)      | Optional<br>(0 or 1)    | The index of the change output. |
| → <br>`conf_target`         | numeric (int)      | Optional<br>(0 or 1)    | Confirmation target (in blocks) for the transaction, or fee rate for DASH/kB or duff/B estimate modes. Defaults to wallet's default configuration. |
| → <br>`estimate_mode`       | string             | Optional<br>(0 or 1)    | The fee estimate mode. Must be one of: `unset`, `economical`, `conservative`, `DASH/kB`, `duff/B`. Default is `unset`. |
| → <br>`include_watching`    | bool               | Optional<br>(0 or 1)    | Also select inputs which are watch only. Only solvable inputs can be used. Watch-only destinations are solvable if the public key and/or output script was imported, e.g. with `importpubkey` or `importmulti` with the 'pubkeys' or 'desc' field. |
| → `inputs`                  | array              | Optional<br>(0 or 1)    | Specify inputs instead of adding them automatically. Array of JSON objects |
| → → Input                   | object             | Required<br>(1 or more) | Each object in the array represents an input of the transaction.           |
| → → →<br>`txid`             | string (hex)       | Required<br>(exactly 1) | The transaction ID of the outpoint to be spent.                            |
| → → →<br>`vout`             | numeric (int)      | Required<br>(exactly 1) | The output number (vout) of the outpoint to be spent. |
| → → →<br>`sequence`         | numeric (int)      | Optional<br>(0 or 1)    | The sequence number to use for the input. |
| → <br>`locktime`            | numeric            | Optional<br>(0 or 1)    | Sets the transaction's locktime. If non-zero, it also activates the inputs. Default is `0`. |
| → <br>`lock_unspents`       | bool               | Optional<br>(0 or 1)    | If `true`, locks the selected unspent outputs. Defaults to `false`. |
| → <br>`psbt`                | bool               | Optional<br>(0 or 1)    | If `true`, always returns the transaction as a PSBT. Implies `add_to_wallet` is `false`. Default is automatic.|
| → `subtract_fee_from_outputs` | array            | Optional<br>(0 or 1)    | A JSON array of integers.  The fee will be equally deducted from the amount of each specified output. Those recipients will receive less funds than you enter in their corresponding amount field. If no outputs are specified here, the sender pays the fee. |
| → → Output index            | numeric (int)      | Required<br>(1 or more) | The zero-based output index, before a change output is added. |

_Result---transaction details_

| Name        | Type               | Presence                | Description                        |
| ----------- | ------------------ | ----------------------- | ---------------------------------- |
| Result      | object             | Required<br>(exactly 1) | JSON object containing transaction details |
| → `complete`  | bool               | Required<br>(exactly 1) | If the transaction has a complete set of signatures. |
| → `txid`      | string (hex)       | Required<br>(exactly 1) | The transaction id for the send. Only 1 transaction is created regardless of the number of addresses. |
| → `hex`       | string (hex)       | Optional<br>(0 or 1)    | If `add_to_wallet` is false, the hex-encoded raw transaction with signatures. |
| → `psbt`      | string             | Optional<br>(0 or 1)    | If more signatures are needed, or if `add_to_wallet` is false, the base64-encoded (partially) signed transaction. |

_Examples from Dash Core 21.0.0_

```bash
# Send with a fee rate of 1 duff/B
dash-cli send '{"XunLY9Tf7Zsef8gMGL2fhWA9ZmMjt4KPw0": 0.1}' 1 "duff/B"
```

```bash
# Create a transaction that should confirm in the next block, specify a particular input, and return result without adding to wallet or broadcasting
dash-cli send '{"XunLY9Tf7Zsef8gMGL2fhWA9ZmMjt4KPw0": 0.1}' 1 "economical" '{"add_to_wallet": false, "inputs": [{"txid":"a08e6907dbbd3d809776dbfc5d82e371b764ed838b5655e72f463568df1aadf0", "vout":1}]}'
```

_See also_

* [SendMany](../api/remote-procedure-calls-wallet.md#sendmany): creates and broadcasts a transaction which sends outputs to multiple addresses.
* [SendToAddress](../api/remote-procedure-calls-wallet.md#sendtoaddress): spends an amount to a given address.

## SendMany

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`sendmany` RPC](../api/remote-procedure-calls-wallet.md#sendmany) creates and broadcasts a transaction which sends outputs to multiple addresses.

_Parameter #1---unused parameter_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Unused | string | Required<br>(exactly 1) | **Deprecated: (previously account) will be removed in a later version of Dash Core**<br><br>Must be set to `""` for backwards compatibility. |

_Parameter #2---the addresses and amounts to pay_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Outputs             | object                          | Required<br>(exactly 1) | An object containing key/value pairs corresponding to the addresses and amounts to pay                                                               |
| →<br>Address/Amount | string (base58) : number (dash) | Required<br>(1 or more) | A key/value pair with a base58check-encoded string containing the P2PKH or P2SH address to pay as the key, and an amount of dash to pay as the value |

_Parameter #3---minimum confirmations_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Confirmations | number (int) | Optional<br>(0 or 1) | _Deprecated and ignored since Dash Core 18.0.0_ |

_Parameter #4--whether to add the balance from transactions locked via InstantSend_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| addlocked | bool | Optional<br>(0 or 1) | _Deprecated and ignored since Dash Core 18.0.0_ |

_Parameter #5---a comment_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Comment | string | Optional<br>(0 or 1) | A locally-stored (not broadcast) comment assigned to this transaction.  Default is no comment |

_Parameter #6---automatic fee subtraction_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Subtract Fee From Amount | array           | Optional<br>(0 or 1) | An array of addresses.  The fee will be equally divided by as many addresses as are entries in this array and subtracted from each address.  If this array is empty or not provided, the fee will be paid by the sender |
| →<br>Address             | string (base58) | Optional (0 or more) | An address previously listed as one of the recipients.                                                                                                                                                                  |

_Parameter #7---use InstantSend_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Use InstantSend | bool | Optional<br>(0 or 1) | _Deprecated and ignored since Dash Core 0.15.0_ |

_Parameter #8---use CoinJoin_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| Use CoinJoin | bool | Optional<br>(0 or 1) | If set to `true`, use CoinJoin funds only (default: false). |

_Parameter #9---confirmation target_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `conf_target` | number (int) | Optional<br>(0 or 1) | Confirmation target (in blocks) |

_Parameter #10---fee estimate mode_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `estimate_mode` | string | Optional<br>(0 or 1) | The fee estimate mode, must be one of:<br>`unset`<br>`economical`<br>`conservative`<br>`DASH/kB`<br>`duff/B` |

_Parameter #11---fee rate_

| Name     | Type    | Presence                | Description |
| -------- | ------- | ----------------------- | ----------- |
| `fee_rate` | number or string | Optional<br>(0 or 1)    | **Added in Dash Core 22.0.0**<br>Specify a fee rate in duffs/B (default=not set, fall back to wallet fee estimation). |

_Parameter #12---verbose_

| Name    | Type    | Presence                | Description |
| ------- | ------- | ----------------------- | ----------- |
| verbose | boolean | Optional<br>(0 or 1)    | If `true`, return extra information about the transaction. Default is `false` |

_Result---execution result_

If `verbose` is not set or set to `false`:

| Name | Type   | Presence                | Description                                       |
| ---- | ------ | ----------------------- | ------------------------------------------------- |
| hex  | string | Required<br>(exactly 1) | The transaction id for the send. Only one transaction is created regardless of the number of addresses |

If `verbose` is set to `true`:

| Name          | Type         | Presence                | Description                                       |
| ------------- | ------------ | ----------------------- | ------------------------------------------------- |
| result        | json object  | Required<br>(exactly 1) | A JSON object containing transaction details      |
| → txid        | string       | Required<br>(exactly 1) | The transaction id for the send. Only one transaction is created regardless of the number of addresses |
| → fee reason  | string       | Required<br>(exactly 1) | The transaction fee reason                        |

_Example from Dash Core 0.17.0_

Send 0.1 DASH to the first address and 0.2 DASH to the second address, with a comment of "Example Transaction".

```bash
dash-cli -testnet sendmany \
  "" \
  '''
    {
      "ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv": 0.1,
      "yhQrX8CZTTfSjKmaq5h7DgSShyEsumCRBi": 0.2
    } ''' \
  6       \
  false   \
  "Example Transaction"
```

Result:

```text
a7c0194a005a220b9bfeb5fdd12d5b90979c10f53de4f8a48a1495aa198a6b95
```

_Example from Dash Core 0.12.2 (CoinJoin)_

Send 0.1 DASH to the first address and 0.2 DASH to the second address using CoinJoin, with a comment of "Example Transaction".

```bash
dash-cli -testnet sendmany \
  "" \
  '''
    {
      "ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv": 0.1,
      "yhQrX8CZTTfSjKmaq5h7DgSShyEsumCRBi": 0.2
    } ''' \
  6       \
  false   \
  "Example Transaction"
  '''
    [""]
  '''    \
  false  \
  true
```

Result:

```text
43337c8e4f3b21bedad7765fa851a6e855e4bb04f60d6b3e4c091ed21ffc5753
```

_See also_

* [Send](../api/remote-procedure-calls-wallet.md#send): sends a transaction with specified outputs.
* [SendToAddress](../api/remote-procedure-calls-wallet.md#sendtoaddress): spends an amount to a given address.

## SendToAddress

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress) spends an amount to a given address.

_Parameter #1---to address_

| Name       | Type   | Presence                | Description                                              |
| ---------- | ------ | ----------------------- | -------------------------------------------------------- |
| To Address | string | Required<br>(exactly 1) | A P2PKH or P2SH address to which the dash should be sent |

_Parameter #2---amount to spend_

| Name   | Type          | Presence                | Description                 |
| ------ | ------------- | ----------------------- | --------------------------- |
| Amount | number (dash) | Required<br>(exactly 1) | The amount to spent in dash |

_Parameter #3---a comment_

| Name    | Type   | Presence             | Description                                                                                   |
| ------- | ------ | -------------------- | --------------------------------------------------------------------------------------------- |
| Comment | string | Optional<br>(0 or 1) | A locally-stored (not broadcast) comment assigned to this transaction.  Default is no comment |

_Parameter #4---a comment about who the payment was sent to_

| Name       | Type   | Presence             | Description                                                                                                                                                |
| ---------- | ------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Comment To | string | Optional<br>(0 or 1) | A locally-stored (not broadcast) comment assigned to this transaction.  Meant to be used for describing who the payment was sent to. Default is no comment |

_Parameter #5---automatic fee subtraction_

| Name                     | Type    | Presence             | Description                                                                                                                                      |
| ------------------------ | ------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Subtract Fee From Amount | boolean | Optional<br>(0 or 1) | The fee will be deducted from the amount being sent. The recipient will receive less dash than you enter in the amount field. Default is `false` |

_Parameter #6---use InstantSend_

| Name            | Type | Presence             | Description                                     |
| --------------- | ---- | -------------------- | ----------------------------------------------- |
| Use InstantSend | bool | Optional<br>(0 or 1) | _Deprecated and ignored since Dash Core 0.15.0_ |

_Parameter #7---use CoinJoin_

| Name         | Type | Presence             | Description                                                 |
| ------------ | ---- | -------------------- | ----------------------------------------------------------- |
| Use CoinJoin | bool | Optional<br>(0 or 1) | If set to `true`, use CoinJoin funds only (default: false). |

_Parameter #8---confirmation target_

| Name          | Type         | Presence             | Description                     |
| ------------- | ------------ | -------------------- | ------------------------------- |
| `conf_target` | number (int) | Optional<br>(0 or 1) | Confirmation target (in blocks) |

_Parameter #9---fee estimate mode_

| Name | Type | Presence | Description |
| ---- | ---- | -------- | ----------- |
| `estimate_mode` | string | Optional<br>(0 or 1) | The fee estimate mode, must be one of:<br>`unset`<br>`economical`<br>`conservative`<br>`DASH/kB`<br>`duff/B` |

_Parameter #10---avoids partial respends_

| Name          | Type    | Presence             | Description                                                                                                             |
| ------------- | ------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `avoid_reuse` | boolean | Optional<br>(0 or 1) | Avoid spending from dirty addresses; addresses are considered dirty if they have previously been used in a transaction. |

_Parameter #11---fee rate_

| Name     | Type    | Presence                | Description |
| -------- | ------- | ----------------------- | ----------- |
| `fee_rate` | number or string | Optional<br>(0 or 1)    | **Added in Dash Core 22.0.0**<br>Specify a fee rate in duffs/B (default=not set, fall back to wallet fee estimation). |

_Parameter #12---verbose_

| Name    | Type    | Presence                | Description |
| ------- | ------- | ----------------------- | ----------- |
| verbose | boolean | Optional<br>(0 or 1)    | If `true`, return extra information about the transaction. Default is `false` |

_Result---execution result_

If `verbose` is not set or set to `false`:

| Name | Type   | Presence                | Description                                       |
| ---- | ------ | ----------------------- | ------------------------------------------------- |
| hex  | string | Required<br>(exactly 1) | The transaction id for the send |

If `verbose` is set to `true`:

| Name          | Type         | Presence                | Description                                       |
| ------------- | ------------ | ----------------------- | ------------------------------------------------- |
| result        | json object  | Required<br>(exactly 1) | A JSON object containing transaction details      |
| → txid        | string       | Required<br>(exactly 1) | The transaction id for the send                   |
| → fee reason  | string       | Required<br>(exactly 1) | The transaction fee reason                        |

_Example from Dash Core 0.12.2_

Spend 0.1 dash to the address below with the comment "sendtoaddress  
example" and the comment-to "Nemo From Example.com":

```bash
dash-cli -testnet sendtoaddress ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv \
  1.0 "sendtoaddress example" "Nemo From Example.com"
```

Result:

```text
70e2029d363f0110fe8a0aa2ba7bd771a579453135568b2aa559b2cb30f875aa
```

_Example from Dash Core 0.12.2 (InstantSend)_

Spend 0.1 dash via InstantSend to the address below with the comment "sendtoaddress  
example" and the comment-to "Nemo From Example.com":

```bash
dash-cli -testnet sendtoaddress ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv \
  1.0 "sendtoaddress example" "Nemo From Example.com" false true
```

Result:

```text
af002b9c931b5efb5b2852df3d65efd48c3b9ac2ba0ef8a4cf97b894f3ff08c2
```

_Example from Dash Core 0.12.2 (CoinJoin)_

Spend 0.1 dash via CoinJoin to the address below with the comment "sendtoaddress  
example" and the comment-to "Nemo From Example.com":

```bash
dash-cli -testnet sendtoaddress ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv \
  1.0 "sendtoaddress example" "Nemo From Example.com" false false true
```

Result:

```text
949833bc49e0643f63e2afed1704ccccf005a93067a4e46165b06ace42544694
```

_Example from Dash Core 0.12.2 (InstantSend + CoinJoin)_

Spend 0.1 dash via InstantSend and CoinJoin to the address below with the  
comment "sendtoaddressexample" and the comment-to "Nemo From Example.com":

```bash
dash-cli -testnet sendtoaddress ySutkc49Khpz1HQN8AfWNitVBLwqtyaxvv \
  1.008 "sendtoaddress example" "Nemo From Example.com" false true true
```

Result:

```text
ba4bbe29fa06b67d6f3f3a73e381627e66abe22e217ce329aefad41ea72c3922
```

_See also_

* [Send](../api/remote-procedure-calls-wallet.md#send): sends a transaction with specified outputs.
* [SendMany](../api/remote-procedure-calls-wallet.md#sendmany): creates and broadcasts a transaction which sends outputs to multiple addresses.

## SetHDSeed

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

_Added in Dash Core 21.0.0_

The `sethdseed` RPC sets or generates a new HD wallet seed. Non-HD wallets will not be upgraded to
HD wallets. Wallets that are already HD cannot be updated to a new HD seed.

**Note:** You will need to make a new backup of your wallet after setting the HD wallet seed.
Requires wallet passphrase to be set with walletpassphrase call if wallet is encrypted.

_Parameter #1---newkeypool_

| Name        | Type    | Presence                | Description |
| ----------- | ------- | ----------------------- | ----------- |
| newkeypool  | boolean | Optional<br>(0 or 1)    | Whether to flush old unused addresses, including change addresses, from the keypool and regenerate it. Default is `true`. If `true`, the next address from `getnewaddress` and change address from `getrawchangeaddress` will be from this new seed. If `false`, addresses from the existing keypool will be used until it has been depleted. |

_Parameter #2---seed_

| Name | Type   | Presence                | Description |
| ---- | ------ | ----------------------- | ----------- |
| seed | string | Optional<br>(0 or 1)    | The WIF private key to use as the new HD seed. The seed value can be retrieved using the `dumpwallet` command. It is the private key marked `hdseed=1`. Default is a random seed. |

_Result---execution result_

| Name | Type     | Presence                | Description |
| ---- | -------- | ----------------------- | ----------- |
| null | json null| Required<br>(exactly 1) | No result   |

_Examples_

Set a new HD seed:

```bash
dash-cli sethdseed
```

_See also_

* [UpgradeToHD](../api/remote-procedure-calls-wallet.md#upgradetohd): upgrades non-HD wallets to HD.

## SetLabel

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`setlabel` RPC](../api/remote-procedure-calls-wallet.md#setlabel) sets the label associated with the given address.

_Parameter #1---a Dash address_

| Name    | Type            | Presence                | Description                                                   |
| ------- | --------------- | ----------------------- | ------------------------------------------------------------- |
| Address | string (base58) | Required<br>(exactly 1) | The P2PKH or P2SH Dash address to be associated with a label. |

_Parameter #2---a label_

| Name  | Type   | Presence                | Description                         |
| ----- | ------ | ----------------------- | ----------------------------------- |
| Label | string | Required<br>(exactly 1) | The label to assign to the address. |

_Result---`null` if successful_

| Name     | Type | Presence                | Description                                                              |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------------ |
| `result` | null | Required<br>(exactly 1) | Set to JSON `null` if the address was successfully placed in the account |

_Example from Dash Core 0.17.0_

Assign the "doc test" label to the provided address.

```bash
dash-cli -testnet setlabel yMTFRnrfJ4NpnYVeidDNHVwT7uuNsVjevq "doc test"
```

(Success: no result displayed.)

_See also_

* [ListLabels](../api/remote-procedure-calls-wallet.md#listlabels): returns the list of all labels, or labels that are assigned to addresses with a specific purpose.
* [GetAddressesByLabel](../api/remote-procedure-calls-wallet.md#getaddressesbylabel): returns the list of addresses assigned the specified label.

<span id="setprivatesendamount"></span>

## SetCoinJoinAmount

The [`setcoinjoinamount` RPC](../api/remote-procedure-calls-wallet.md#setcoinjoinamount) sets the amount of DASH to be processed with CoinJoin (previously named `setprivatesendamount` prior to Dash Core 0.17.0)

_Parameter #1---amount to process_

| Name   | Type | Presence                | Description                                                     |
| ------ | ---- | ----------------------- | --------------------------------------------------------------- |
| Amount | int  | Required<br>(exactly 1) | The number of DASH to process (minimum: 2, maximum: 21,000,000) |

_Result---`null` on success_

_Example from Dash Core 0.13.0_

```bash
dash-cli -testnet setcoinjoinamount 2000
```

(Success: no result displayed.)

_See also:_

* [SetCoinJoinRounds](../api/remote-procedure-calls-wallet.md#setcoinjoinrounds): sets the number of rounds to use

<span id="setprivatesendrounds"></span>

## SetCoinJoinRounds

The [`setcoinjoinrounds` RPC](../api/remote-procedure-calls-wallet.md#setcoinjoinrounds) sets the number of rounds to use (previously named `setprivatesendrounds` prior to Dash Core 0.17.0)

_Parameter #1---number of rounds to use_

| Name   | Type | Presence                | Description                                           |
| ------ | ---- | ----------------------- | ----------------------------------------------------- |
| Rounds | int  | Required<br>(exactly 1) | The number of rounds to use (minimum: 1, maximum: 16) |

_Result---`null` on success_

_Example from Dash Core 0.13.0_

```bash
dash-cli -testnet setcoinjoinrounds 4
```

(Success: no result displayed.)

_See also:_

* [SetCoinJoinAmount](../api/remote-procedure-calls-wallet.md#setcoinjoinamount): sets the amount of DASH to be processed with CoinJoin

## SetTxFee

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`settxfee` RPC](../api/remote-procedure-calls-wallet.md#settxfee) sets the transaction fee per kilobyte paid by transactions created by this wallet.

_Parameter #1---the transaction fee amount per kilobyte_

| Name                         | Type          | Presence                | Description                                                                                                                                                                  |
| ---------------------------- | ------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Transaction Fee Per Kilobyte | number (dash) | Required<br>(exactly 1) | The transaction fee to pay, in dash, for each kilobyte of transaction data.  Be careful setting the fee too low---your transactions may not be relayed or included in blocks |

_Result: `true` on success_

| Name     | Type        | Presence                | Description                                   |
| -------- | ----------- | ----------------------- | --------------------------------------------- |
| `result` | bool (true) | Required<br>(exactly 1) | Set to `true` if the fee was successfully set |

_Example from Dash Core 0.12.2_

Set the transaction fee per kilobyte to 10,000 duffs.

```bash
dash-cli -testnet settxfee 0.00010000
```

Result:

```json
true
```

_See also_

* [GetWalletInfo](../api/remote-procedure-calls-wallet.md#getwalletinfo): provides information about the wallet.
* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.

## SetWalletFlag

The SetWalletFlag RPC changes the state of the given wallet flag for a wallet.

\*Parameter #1---states the name of the flag to change

| Name | Type   | Presence                | Description                                                          |
| ---- | ------ | ----------------------- | -------------------------------------------------------------------- |
| flag | string | Required<br>(exactly 1) | The name of the flag to change. Current available flags: avoid_reuse |

\*Parameter #2---defining the new state

| Name  | Type    | Presence                   | Description    |
| ----- | ------- | -------------------------- | -------------- |
| value | boolean | Optional<br>(default TRUE) | The new state. |

_Result_

| Name              | Type                  | Presence                | Description                                                                   |
| ----------------- | --------------------- | ----------------------- | ----------------------------------------------------------------------------- |
| `result`          | object/null           | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred |
| →<br>`flag_name`  | str (string)          | Required<br>(exactly 1) | the name of the flag that was modified                                        |
| →<br>`flag_state` | true\|false (boolean) | Required<br>(0 or 1)    | the new state of the flag                                                     |
| →<br>`warnings`   | str (string)          | Required<br>(exactly 1) | any warnings associated with the change                                       |

_Example from Dash Core 18.1.0_

```bash
dash-cli setwalletflag avoid_reuse
```

Result:

```json
{
  "flag_name": "avoid_reuse",
  "flag_state": true,
  "warnings": "You need to rescan the blockchain in order to correctly mark used destinations in the past. Until this is done, some destinations may be considered unused, even if the opposite is the case."
}
```

_See also: none_

## SignMessage

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked or unencrypted wallet.
:::

The [`signmessage` RPC](../api/remote-procedure-calls-wallet.md#signmessage) signs a message with the private key of an address.

_Parameter #1---the address corresponding to the private key to sign with_

| Name    | Type            | Presence                | Description                                              |
| ------- | --------------- | ----------------------- | -------------------------------------------------------- |
| Address | string (base58) | Required<br>(exactly 1) | A P2PKH address whose private key belongs to this wallet |

_Parameter #2---the message to sign_

| Name    | Type   | Presence                | Description         |
| ------- | ------ | ----------------------- | ------------------- |
| Message | string | Required<br>(exactly 1) | The message to sign |

_Result---the message signature_

| Name     | Type            | Presence                | Description                                      |
| -------- | --------------- | ----------------------- | ------------------------------------------------ |
| `result` | string (base64) | Required<br>(exactly 1) | The signature of the message, encoded in base64. |

_Example from Dash Core 0.12.2_

Sign a the message "Hello, World!" using the following address:

```bash
dash-cli -testnet signmessage yNpezfFDfoikDuT1f4iK75AiLp2YLPsGAb "Hello, World!"
```

Result:

```text
H4XULzfHCf16In2ECk9Ta9QxQPq639zQto2JA3OLlo3JbUdrClvJ89+A1z+Z9POd6l8LJhn1jGpQYF8mX4jkQvE=
```

_See also_

* [VerifyMessage](../api/remote-procedure-calls-util.md#verifymessage): verifies a signed message.

## SignRawTransactionWithWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked wallet.
:::

The [`signrawtransactionwithwallet` RPC](#signrawtransactionwithwallet) signs a transaction in the serialized transaction format using private keys stored in the wallet.

_Parameter #1---the transaction to sign_

| Name        | Type         | Presence                | Description                                         |
| ----------- | ------------ | ----------------------- | --------------------------------------------------- |
| Transaction | string (hex) | Required<br>(exactly 1) | The transaction to sign as a serialized transaction |

_Parameter #2---unspent transaction output details_

| Name                  | Type         | Presence                | Description                                                                                            |
| --------------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------ |
| Dependencies          | array        | Optional<br>(0 or 1)    | The previous outputs being spent by this transaction                                                   |
| →<br>Output           | object       | Optional<br>(0 or more) | An output being spent                                                                                  |
| → →<br>`txid`         | string (hex) | Required<br>(exactly 1) | The TXID of the transaction the output appeared in.  The TXID must be encoded in hex in RPC byte order |
| → →<br>`vout`         | number (int) | Required<br>(exactly 1) | The index number of the output (vout) as it appeared in its transaction, with the first output being 0 |
| → →<br>`scriptPubKey` | string (hex) | Required<br>(exactly 1) | The output's pubkey script encoded as hex                                                              |
| → →<br>`redeemScript` | string (hex) | Optional<br>(0 or 1)    | If the pubkey script was a script hash, this must be the corresponding redeem script                   |
| → →<br>`amount`       | numeric      | Required<br>(exactly 1) | The amount of Dash spent                                                                               |

_Parameter #3---signature hash type_

| Name    | Type   | Presence             | Description                                                                                                                                                                                                                                                                                                         |                      |                            |                |
| :------ | :----- | :------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------- | :------------------------- | :------------- |
| SigHash | string | Optional<br>(0 or 1) | The type of signature hash to use for all of the signatures performed.  (You must use separate calls to the [`signrawtransactionwithwallet` RPC](#signrawtransactionwithwallet) if you want to use different signature hash types for different signatures.  The allowed values are: `ALL`, `NONE`, `SINGLE`, `ALL \| ANYONECANPAY`,`NONE \| ANYONECANPAY`, and`SINGLE \| ANYONECANPAY` |

_Result---the transaction with any signatures made_

| Name            | Type         | Presence                | Description                                                                                                                                                                    |
| --------------- | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `result`        | object       | Required<br>(exactly 1) | The results of the signature                                                                                                                                                   |
| →<br>`hex`      | string (hex) | Required<br>(exactly 1) | The resulting serialized transaction encoded as hex with any signatures made inserted.  If no signatures were made, this will be the same transaction provided in parameter #1 |
| →<br>`complete` | bool         | Required<br>(exactly 1) | The value `true` if transaction is fully signed; the value `false` if more signatures are required                                                                             |

_Example from Dash Core 0.17.0_

Sign the hex generated from the `createrawtransaction` RPC:

```bash
dash-cli -testnet signrawtransactionwithwallet 020000000121f39228a11ddf19\
7ac3658e93bd264d0afd927f0cdfc7caeb760537e529c94a0100000000ffffffff0180969\
800000000001976a914fe64a96d6660e30c433e1189082466a95bdf9ceb88ac00000000
```

Result:

```json
{
  "hex": "020000000121f39228a11ddf197ac3658e93bd264d0afd927f0cdfc7caeb760537e529c94a010000006b483045022100811c5679ef097b0e5a338fc3cd05ee50e1802680ea8a172d0fd3a81da3c1fc2002204804b18a44e888ac1ee9b6a7cbadc211ecdc30f8c889938c95125206e39554220121025d81ce6581e547dd34194385352053abb17f0246768d75443b25ded5e37d594fffffffff0180969800000000001976a914fe64a96d6660e30c433e1189082466a95bdf9ceb88ac00000000",
  "complete": true
}
```

_See also_

* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction.
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network.
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network.
* [SignRawTransactionWithKey](../api/remote-procedure-calls-raw-transactions.md#signrawtransactionwithkey): signs inputs for a transaction in the serialized transaction format using private keys provided in the call.

## UnloadWallet

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`unloadwallet` RPC](../api/remote-procedure-calls-wallet.md#unloadwallet) unloads the wallet referenced by the request endpoint otherwise unloads the wallet specified in the argument. Specifying the wallet name on a wallet endpoint is invalid.

_Parameter #1---wallet name_

| Name     | Type   | Presence                | Description                       |
| -------- | ------ | ----------------------- | --------------------------------- |
| Filename | string | Required<br>(exactly 1) | The name of the wallet to unload. If provided both here and in the RPC endpoint, the two must be identical. |

_Parameter #2---load of startup_

| Name            | Type    | Presence             | Description                                                                                                                                |
| --------------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| load_on_startup | boolean | Optional<br>(0 or 1) | Save wallet name to persistent settings and load on startup. True to add wallet to startup list, false to remove, null to leave unchanged. |

_Result---null on success_

_Example from Dash Core 0.17.0_

```bash
dash-cli -testnet unloadwallet wallet-test.dat
```

Result:

```shell
null
```

_See also_

* [LoadWallet](../api/remote-procedure-calls-wallet.md#loadwallet): loads a wallet from a wallet file or directory.

## UpgradeToHD

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**).
:::

The [`upgradetohd` RPC](../api/remote-procedure-calls-wallet.md#upgradetohd) upgrades non-HD wallets to HD.

_Parameters_

| Name                 | Type    | Presence             | Description                                                                                                                                                          |
| -------------------- | ------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `mnemonic`           | string  | Optional<br>(0 or 1) | Mnemonic as defined in BIP39 to use for the new HD wallet. Use an empty string `""` to generate a new random mnemonic.                                               |
| `mnemonicpassphrase` | string  | Optional<br>(0 or 1) | Optional mnemonic passphrase as defined in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki#From_mnemonic_to_seed)                             |
| `walletpassphrase`   | string  | Optional<br>(0 or 1) | If your wallet is encrypted you must have your wallet passphrase here. If your wallet is not encrypted, specifying wallet passphrase will trigger wallet encryption. |
| `rescan`             | boolean | Optional<br>(0 or 1) | Whether to rescan the blockchain for missing transactions or not (default=`false` if mnemonic is empty)                                                              |

_Result---`true` on success_

| Name     | Type | Presence                | Description                                                                |
| -------- | ---- | ----------------------- | -------------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | `true` when the command was successful or error message if not successful. |

_Example from Dash Core 0.17.0_

Upgrade wallet to HD without specifying any optional parameters:

```bash
dash-cli -testnet upgradetohd
```

```bash
true
```

_See also_

* [DumpHDInfo](../api/remote-procedure-calls-wallet.md#dumphdinfo):  returns an object containing sensitive private info about this HD wallet

## UpgradeWallet

The [`upgradewallet` RPC](#upgradewallet) upgrades the wallet to the latest version if no version number is specified. New keys may be generated and a new wallet backup will need to be made.

_Parameters_

| Name      | Type   | Presence             | Description                                                             |
| --------- | ------ | -------------------- | ----------------------------------------------------------------------- |
| `version` | number | Optional<br>(0 or 1) | The version number to upgrade to. Default is the latest wallet version. |

_Result---JSON object on success or failure_

| Name     | Type | Presence                | Description                                                                |
| -------- | ---- | ----------------------- | -------------------------------------------------------------------------- |
| `result` | object | Required<br>(exactly 1) | A JSON object which may contain an `error` field if the upgrade fails. |
| →<br>`error` | string | Optional<br>(0 or 1) | The error message describing why the upgrade failed, if applicable.    |

_Example from Dash Core 21.0.0_

Upgrade wallet without specifying any optional parameters:

```bash
dash-cli -testnet upgradewallet
```

Result (success indicated by empty object):

```json
{
}
```

_See also_

* [DumpHDInfo](../api/remote-procedure-calls-wallet.md#dumphdinfo):  returns an object containing sensitive private info about this HD wallet

## WalletCreateFundedPSBT

The [`walletcreatefundedpsbt` RPC](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt) creates and funds a transaction in the Partially Signed Transaction (PST) format. Inputs will be added if supplied inputs are not enough.

Implements the Creator and Updater roles.

_Parameter #1---Inputs_

| Name              | Type         | Presence                | Description                                                                                                |
| ----------------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| Inputs            | array        | Required<br>(exactly 1) | An array of objects, each one to be used as an input to the transaction. Leave empty to add inputs automatically. See `add_inputs` option. |
| → Input           | object       | Required<br>(1 or more) | An object describing a particular input                                                                    |
| → →<br>`txid`     | string (hex) | Required<br>(exactly 1) | The TXID of the outpoint to be spent encoded as hex in RPC byte order                                      |
| → →<br>`vout`     | number (int) | Required<br>(exactly 1) | The output index number (vout) of the outpoint to be spent; the first output in a transaction is index `0` |
| → →<br>`Sequence` | number (int) | Optional<br>(0 or 1)    | The sequence number to use for the input                                                                   |

_Parameter #2---Outputs_

| Name           | Type                  | Presence                | Description                                                                                               |
| -------------- | --------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| Outputs        | array                 | Required<br>(exactly 1) | A JSON array with outputs as key-value pairs                                                              |
| → Output       | object                | Required<br>(1 or more) | An object describing a particular output                                                                  |
| → →<br>Address | string: number (Dash) | Optional<br>(0 or 1)    | A key-value pair. The key (string) is the Dash address, the value (float or string) is the amount in DASH |
| → →<br>Data    | `data`: string (hex)  | Optional<br>(0 or 1)    | A key-value pair. The key must be `data`, the value is hex encoded data                                   |

_Parameter #3---locktime_

| Name     | Type          | Presence             | Description                                                                                                                          |
| -------- | ------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Locktime | numeric (int) | Optional<br>(0 or 1) | Indicates the earliest time a transaction can be added to the block chain (default=`0`). Non-0 value also locktime-activates inputs. |

_Parameter #4---Additional options_

| Name                           | Type              | Presence                | Description |
| ------------------------------ | ----------------- | ----------------------- | ----------- |
| Options                        | Object            | Optional<br>(0 or 1)    | Additional options |
| → <br>`add_inputs`             | bool              | Optional<br>(0 or 1)    | If inputs are specified, automatically include more if they are not enough. Defaults to `false`. |
| → <br>`changeAddress`          | string            | Optional<br>(0 or 1)    | The dash address to receive the change (default=pool address) |
| → <br>`changePosition`         | numeric (int)     | Optional<br>(0 or 1)    | The index of the change output (default=random) |
| → <br>`includeWatching`        | bool              | Optional<br>(0 or 1)    | Also select inputs which are watch only (default=`false` for non-watching only wallets and `true` for watching only-wallets) |
| → <br>`lockUnspents`           | bool              | Optional<br>(0 or 1)    | Lock selected unspent outputs (default=`false`). This applies to manually selected coins also since Dash Core 20.1.0. |
| → <br>`feeRate`                | numeric or string | Optional<br>(0 or 1)    | Set a specific fee rate in DASH/kB |
| → <br>`subtractFeeFromOutputs` | array             | Optional<br>(0 or 1)    | A json array of integers. The fee will be equally deducted from the amount of each specified output. The outputs are specified by their zero-based index, before any change output is added. Those recipients will receive less Dash than you enter in their corresponding amount field. If no outputs are specified here, the sender pays the fee. |
| → →<br>Output index            | numeric (int)     | Optional<br>(0 or more) | An output index number (vout) from which the fee should be subtracted. If multiple vouts are provided, the total fee will be divided by the number of vouts listed and each vout will have that amount subtracted from it. |
| → <br>`conf_target`            | numeric (int)     | Optional<br>(0 or 1)    | Confirmation target (in blocks) |
| → <br>`estimate_mode`          | numeric (int)     | Optional<br>(0 or 1)    | The fee estimate mode, must be one of:<br>`unset`<br>`economical`<br>`conservative`<br>`DASH/kB`<br>`duff/B` |

_Parameter #5---bip32derivs_

| Name          | Type | Presence                     | Description                                                                      |
| ------------- | ---- | ---------------------------- | -------------------------------------------------------------------------------- |
| `bip32derivs` | bool | Optional<br>(exactly 0 or 1) | Includes the BIP 32 derivation paths for public keys if known (default = `true`) |

_Result---information about the created transaction_

| Name              | Type               | Presence                | Description                                                                    |
| ----------------- | ------------------ | ----------------------- | ------------------------------------------------------------------------------ |
| `result`          | object             | Required<br>(exactly 1) | An object including information about the created transaction                  |
| → <br>`psbt`      | string (base64)    | Required<br>(Exactly 1) | The resulting raw transaction (base64-encoded string)                          |
| → <br>`fee`       | numeric (bitcoins) | Required<br>(Exactly 1) | Fee in DASH the resulting transaction pays                                     |
| → <br>`changepos` | numeric (int)      | Required<br>(Exactly 1) | The position of the added change output, or `-1` if no change output was added |

_Example from Dash Core 18.0.0_

```bash
dash-cli -testnet walletcreatefundedpsbt "[{\"txid\":\"2662c87e1761ed5f4e98a0640b2608114d86f282824a51bd624985d236c71178\",\"vout\":0}]" "[{\"data\":\"00010203\"}]"
```

Result:

```json
{
  "psbt": "cHNidP8BAGQCAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AgAAAAAAAAAABmoEAAECA6PmxgkAAAAAGXapFFNPqpebN9gMkzsFJWixaDCZ3S8OiKwAAAAAAAEA4QIAAAABlIu3UCzRFVGowPY3H7RvS5g6QGc71ZYEFXIrcS+NfEIBAAAAakcwRAIgT+T8SIyVXyhsUshI7HlQtA7EduG0NMat1oa0dL3eCakCIGIi0pH9naNBQIqopHIPWmlZmXcVod34GH51J3tr/K5+ASEDxn2GlEMVg4rqfsgNOQtdCbkbYkgzcNSXnaXM96ffd6n+////ArTnxgkAAAAAGXapFM78RkkEwDgUwBkG4ZfcdZp0XkfuiKwAypo7AAAAABl2qRQ++by+kvd8j63QVm7qf/jUfyK94IisVUgIAAAAAA==",
  "fee": 0.00000273,
  "changepos": 1
}
```

## WalletLock

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an unlocked wallet.
:::

The [`walletlock` RPC](../api/remote-procedure-calls-wallet.md#walletlock) removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call `walletpassphrase` again before being able to call any methods which require the wallet to be unlocked.

_Parameters: none_

_Result---`null` on success_

| Name     | Type | Presence                | Description               |
| -------- | ---- | ----------------------- | ------------------------- |
| `result` | null | Required<br>(exactly 1) | Always set to JSON `null` |

_Example from Dash Core 0.12.2_

```bash
dash-cli -testnet walletlock
```

(Success: nothing printed.)

_See also_

* [EncryptWallet](../api/remote-procedure-calls-wallet.md#encryptwallet): encrypts the wallet with a passphrase.  This is only to enable encryption for the first time. After encryption is enabled, you will need to enter the passphrase to use private keys.
* [WalletPassphrase](../api/remote-procedure-calls-wallet.md#walletpassphrase): stores the wallet decryption key in memory for the indicated number of seconds. Issuing the `walletpassphrase` command while the wallet is already unlocked will set a new unlock time that overrides the old one.
* [WalletPassphraseChange](../api/remote-procedure-calls-wallet.md#walletpassphrasechange): changes the wallet passphrase from 'old passphrase' to 'new passphrase'.

## WalletPassphrase

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an encrypted wallet.
:::

The [`walletpassphrase` RPC](../api/remote-procedure-calls-wallet.md#walletpassphrase) stores the wallet decryption key in memory for the indicated number of seconds. Issuing the `walletpassphrase` command while the wallet is already unlocked will set a new unlock time that overrides the old one.

:::{warning}
If using this RPC on the command line, remember that your shell probably saves your command lines (including the value of the passphrase parameter).
:::

_Parameter #1---the passphrase_

| Name       | Type   | Presence                | Description                            |
| ---------- | ------ | ----------------------- | -------------------------------------- |
| Passphrase | string | Required<br>(exactly 1) | The passphrase that unlocks the wallet |

_Parameter #2---the number of seconds to leave the wallet unlocked_

| Name    | Type         | Presence                | Description                                                                                    |
| ------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------- |
| Seconds | number (int) | Required<br>(exactly 1) | The number of seconds after which the decryption key will be automatically deleted from memory |

_Parameter #3---unlock for mixing processing only_

| Name        | Type | Presence             | Description                                                                                                      |
| ----------- | ---- | -------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Mixing Only | bool | Optional<br>(0 or 1) | If `true`, the wallet will be locked for sending functions but unlocked for mixing transactions (default: false) |

_Result---`null` on success_

| Name     | Type | Presence                | Description               |
| -------- | ---- | ----------------------- | ------------------------- |
| `result` | null | Required<br>(exactly 1) | Always set to JSON `null` |

_Example from Dash Core 0.12.2_

Unlock the wallet for 10 minutes (the passphrase is "test"):

```bash
dash-cli -testnet walletpassphrase test 600
```

(Success: no result printed.)

Unlock the wallet for CoinJoin processing transactions only for 10 minutes (the passphrase is "test"):

```bash
dash-cli -testnet walletpassphrase test 600 true
```

(Success: no result printed.)

_See also_

* [EncryptWallet](../api/remote-procedure-calls-wallet.md#encryptwallet): encrypts the wallet with a passphrase.  This is only to enable encryption for the first time. After encryption is enabled, you will need to enter the passphrase to use private keys.
* [WalletPassphraseChange](../api/remote-procedure-calls-wallet.md#walletpassphrasechange): changes the wallet passphrase from 'old passphrase' to 'new passphrase'.
* [WalletLock](../api/remote-procedure-calls-wallet.md#walletlock): removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call `walletpassphrase` again before being able to call any methods which require the wallet to be unlocked.

## WalletPassphraseChange

:::{note}
Requires [wallet](../resources/glossary.md#wallet) support (**unavailable on masternodes**) and an encrypted wallet.
:::

The [`walletpassphrasechange` RPC](../api/remote-procedure-calls-wallet.md#walletpassphrasechange) changes the wallet passphrase from 'old passphrase' to 'new passphrase'.

:::{warning}
If using this RPC on the command line, remember that your shell probably saves your command lines (including the value of the passphrase parameter).
:::

_Parameter #1---the current passphrase_

| Name               | Type   | Presence                | Description                   |
| ------------------ | ------ | ----------------------- | ----------------------------- |
| Current Passphrase | string | Required<br>(exactly 1) | The current wallet passphrase |

_Parameter #2---the new passphrase_

| Name           | Type   | Presence                | Description                       |
| -------------- | ------ | ----------------------- | --------------------------------- |
| New Passphrase | string | Required<br>(exactly 1) | The new passphrase for the wallet |

_Result---`null` on success_

| Name     | Type | Presence                | Description               |
| -------- | ---- | ----------------------- | ------------------------- |
| `result` | null | Required<br>(exactly 1) | Always set to JSON `null` |

_Example from Dash Core 0.12.2_

Change the wallet passphrase from "test" to "example":

```bash
dash-cli -testnet walletpassphrasechange "test" "example"
```

(Success: no result printed.)

_See also_

* [EncryptWallet](../api/remote-procedure-calls-wallet.md#encryptwallet): encrypts the wallet with a passphrase.  This is only to enable encryption for the first time. After encryption is enabled, you will need to enter the passphrase to use private keys.
* [WalletLock](../api/remote-procedure-calls-wallet.md#walletlock): removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call `walletpassphrase` again before being able to call any methods which require the wallet to be unlocked.
* [WalletPassphrase](../api/remote-procedure-calls-wallet.md#walletpassphrase): stores the wallet decryption key in memory for the indicated number of seconds. Issuing the `walletpassphrase` command while the wallet is already unlocked will set a new unlock time that overrides the old one.

## WalletProcessPSBT

The [`walletprocesspsbt` RPC](../api/remote-procedure-calls-wallet.md#walletprocesspsbt) updates a PSBT with input information from a wallet and then allows the signing of inputs.

_Parameter #1---PSBT_

| Name   | Type   | Presence                | Description                   |
| ------ | ------ | ----------------------- | ----------------------------- |
| `psbt` | string | Required<br>(exactly 1) | The transaction base64 string |

_Parameter #2---Sign Transaction_

| Name   | Type | Presence                     | Description                                           |
| ------ | ---- | ---------------------------- | ----------------------------------------------------- |
| `sign` | bool | Optional<br>(exactly 0 or 1) | Sign the transaction when updating (default = `true`) |

_Parameter #3---Signature Hash Type_

| Name          | Type   | Presence                     | Description                                                                                                                                                                                                                    |
| ------------- | ------ | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `sighashtype` | string | Optional<br>(exactly 0 or 1) | The signature hash type to sign with if not specified by the PSBT. Must be one of the following (default = ALL):<br> - ALL<br> - NONE<br> - SINGLE<br> - ALL\|ANYONECANPAY<br> - NONE\|ANYONECANPAY<br> - SINGLE\|ANYONECANPAY |

_Parameter #4---bip32derivs_

| Name          | Type | Presence                     | Description                                                                       |
| ------------- | ---- | ---------------------------- | --------------------------------------------------------------------------------- |
| `bip32derivs` | bool | Optional<br>(exactly 0 or 1) | Includes the BIP 32 derivation paths for public keys if known (default = `true`). |

_Result---the processed wallet_

| Name            | Type   | Presence                | Description                                         |
| --------------- | ------ | ----------------------- | --------------------------------------------------- |
| `result`        | object | Required<br>(exactly 1) | The results of the signature                        |
| →<br>`psbt`     | string | Required<br>(exactly 1) | The base64-encoded partially signed transaction     |
| →<br>`complete` | bool   | Required<br>(exactly 1) | If the transaction has a complete set of signatures |

_Example from Dash Core 18.0.0_

Change the wallet passphrase from "test" to "example":

```bash
dash-cli walletprocesspsbt "cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAAA="
```

Result:

```json
{
  "psbt": "cHNidP8BAEICAAAAAXgRxzbShUlivVFKgoLyhk0RCCYLZKCYTl/tYRd+yGImAAAAAAD/////AQAAAAAAAAAABmoEAAECAwAAAAAAAQDhAgAAAAGUi7dQLNEVUajA9jcftG9LmDpAZzvVlgQVcitxL418QgEAAABqRzBEAiBP5PxIjJVfKGxSyEjseVC0DsR24bQ0xq3WhrR0vd4JqQIgYiLSkf2do0FAiqikcg9aaVmZdxWh3fgYfnUne2v8rn4BIQPGfYaUQxWDiup+yA05C10JuRtiSDNw1Jedpcz3p993qf7///8CtOfGCQAAAAAZdqkUzvxGSQTAOBTAGQbhl9x1mnReR+6IrADKmjsAAAAAGXapFD75vL6S93yPrdBWbup/+NR/Ir3giKxVSAgAAQdqRzBEAiAF1fgBDg2M/WAeYTYzCkEiSSrDVzcYoe8wwrw/MbdgOQIgJzoYBQ9hAm6jqk2cLFitUd1/iL1ku8w9unadjNfsCdoBIQJn2pETmk8U2X6veADqnny5/6j8Iy7Oizij0SeJHm9x6AAA",
  "complete": true
}
```

_See also_

* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format.
* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combine multiple partially-signed Dash transactions into one transaction.
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT.
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction.
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT.
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format.

## WipeWalletTxes

The [`wipewallettxes` RPC](../api/remote-procedure-calls-wallet.md#wipewallettxes) wipes all transaction from the wallet. Note: Use the [`rescanblockchain` RPC](../api/remote-procedure-calls-wallet.md#rescanblockchain) to initiate the scanning progress and recover wallet transactions.

_Parameter #1---Keep confirmed txes_

| Name   | Type   | Presence                | Description                   |
| ------ | ------ | ----------------------- | ----------------------------- |
| `keep_confirmed` | boolean | Optional<br>(0 or 1) | Do not wipe confirmed transactions (default=`false`) |

_Result---`null` on success_

| Name     | Type | Presence                | Description                                                         |
| -------- | ---- | ----------------------- | ------------------------------------------------------------------- |
| `result` | null | Required<br>(exactly 1) | JSON `null` when the transaction and all descendants were abandoned |

_Example from Dash Core 20.0.0_

Wipe all transactions from the wallet:

```bash
dash-cli -testnet wipewallettxes
```

_See also_

* [RescanBlockchain](../api/remote-procedure-calls-wallet.md#rescanblockchain): rescans the local blockchain for wallet related transactions.
