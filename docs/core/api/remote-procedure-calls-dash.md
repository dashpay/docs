```{eval-rst}
.. meta::
  :title: Dash RPCs
  :description: A list of remote procedure calls that classify under Dash RPCs.
```

# Dash RPCs

<span id="privatesend"></span>

## CoinJoin

As of Dash Core 0.12.3, this is not supported on masternodes since wallet functionality is disabled on them for security reasons.

The [`coinjoin` RPC](#coinjoin) controls the CoinJoin process (previously named `privatesend` prior to Dash Core 0.17.0).

| Name   | Type   | Presence                | Description                                                                                                |
| ------ | ------ | ----------------------- | ---------------------------------------------------------------------------------------------------------- |
| `mode` | string | Required<br>(exactly 1) | The command mode to use:<br>`start` - Start CoinJoin<br>`stop` - Stop CoinJoin<br>`reset` - Reset CoinJoin |

**Command Mode - `start`**

*Result---start command return status*

| Name     | Type   | Presence                | Description           |
| -------- | ------ | ----------------------- | --------------------- |
| `result` | string | Required<br>(exactly 1) | Command return status |

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet coinjoin start
```

Result:

```text
Mixing started successfully
```

**Command Mode - `stop`**

*Result---stop command return status*

| Name     | Type   | Presence                | Description           |
| -------- | ------ | ----------------------- | --------------------- |
| `result` | string | Required<br>(exactly 1) | Command return status |

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet coinjoin stop
```

Result:

```text
Mixing was stopped
```

**Command Mode - `reset`**

*Result---reset command return status*

| Name     | Type   | Presence                | Description           |
| -------- | ------ | ----------------------- | --------------------- |
| `result` | string | Required<br>(exactly 1) | Command return status |

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet coinjoin reset
```

Result:

```text
Mixing was reset
```

*See also: none*

## CoinJoinSalt

The [`coinjoinsalt` RPC](#coinjoinsalt) controls the CoinJoin salt used in the process. It allows
you to generate, retrieve, or set the salt.

| Name      | Type   | Presence                | Description                                                                                      |
| --------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------ |
| `command` | string | Required<br>(exactly 1) | The command mode to use:<br>`generate` - Generate new CoinJoin salt<br>`get` - Fetch existing CoinJoin salt<br>`set` - Set new CoinJoin salt |

**Command Mode - `generate`**

Generates a new CoinJoin salt and stores it in the wallet database. Note that a new salt cannot be
generated if CoinJoin mixing is in process or if the wallet has private keys disabled.

| Name        | Type    | Presence                        | Description |
| ----------- | ------- | ------------------------------- | ----------- |
| `overwrite` | boolean | Optional<br>(default: `false`)  | Allows generating new salt even if an existing salt is present and/or there is a CoinJoin balance |

*Result---generate command return status*

| Name     | Type    | Presence                | Description                        |
| -------- | ------- | ----------------------- | ---------------------------------- |
| `result` | boolean | Required<br>(exactly 1) | Status of CoinJoin salt generation |

*Examples*

```bash
dash-cli -testnet coinjoinsalt generate
```

Result:

```text
true
```

**Command Mode - `get`**

Fetches the existing CoinJoin salt. Note that the salt cannot be fetched if the wallet has private
keys disabled.

*Result---get command return value*

| Name  | Type   | Presence                | Description               |
| ----- | ------ | ----------------------- | ------------------------- |
| `salt` | string | Required<br>(exactly 1) | The current CoinJoin salt (in hexadecimal format) |

*Examples*

```bash
dash-cli -testnet coinjoinsalt get
```

Result:

```text
"c2ca...4546"
```

**Command Mode - `set`**

Sets a new CoinJoin salt. The salt cannot be set if CoinJoin mixing is in process or if the wallet
has private keys disabled. This command will overwrite the existing salt, and if a CoinJoin balance
is present, the wallet will rescan.

| Name        | Type    | Presence                        | Description |
| ----------- | ------- | ------------------------------- | ----------- |
| `salt`      | string  | Required<br>(exactly 1)         | The desired CoinJoin salt value for the wallet (in hexadecimal format) |
| `overwrite` | boolean | Optional<br>(default: `false`)  | Allows overwriting the salt even if a CoinJoin balance is present |

*Result---set command return status*

| Name     | Type    | Presence                | Description                            |
| -------- | ------- | ----------------------- | -------------------------------------- |
| `result` | boolean | Required<br>(exactly 1) | Status of CoinJoin salt change request |

*Examples*

```bash
dash-cli -testnet coinjoinsalt set f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
```

Result:

```text
true
```

*See also: none*

## GetGovernanceInfo

The [`getgovernanceinfo` RPC](#getgovernanceinfo) returns an object containing governance parameters.

*Parameters: none*

*Result---information about the governance system*

| Name                            | Type         | Presence                | Description |
| ------------------------------- | ------------ | ----------------------- | ----------- |
| `result`                        | object       | Required<br>(exactly 1) | Information about the governance system |
| →<br>`governanceminquorum`      | number (int) | Required<br>(exactly 1) | The absolute minimum number of votes needed to trigger a governance action |
| →<br>`proposalfee`              | number (int) | Required<br>(exactly 1) | The collateral transaction fee which must be paid to create a proposal in Dash |
| →<br>`superblockcycle`          | number (int) | Required<br>(exactly 1) | The number of blocks between superblocks |
| →<br>`superblockmaturitywindow` | number (int) | Required<br>(exactly 1) | The superblock trigger creation window |
| →<br>`lastsuperblock`           | number (int) | Required<br>(exactly 1) | The block number of the last superblock |
| →<br>`nextsuperblock`           | number (int) | Required<br>(exactly 1) | The block number of the next superblock |
| →<br>`fundingthreshold`         | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The number of absolute yes votes required for a proposal to be passing |
| →<br>`governancebudget`         | number (real) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The governance budget for the next superblock in DASH |

*Example from Dash Core 20.0.0*

``` bash
dash-cli -testnet getgovernanceinfo
```

Result:

``` json
{
  "governanceminquorum": 1,
  "proposalfee": 1.00000000,
  "superblockcycle": 24,
  "superblockmaturitywindow": 8,
  "lastsuperblock": 916632,
  "nextsuperblock": 916656,
  "fundingthreshold": 21,
  "governancebudget": 44.60797584
}
```

*See also:*

* [GObject](#gobject): provides a set of commands for managing governance objects and displaying information about them.

**<span id="getprivatesendinfo"></span>**

## GetCoinJoinInfo

The [`getcoinjoininfo` RPC](#getcoinjoininfo) returns an object containing an information about CoinJoin settings and state (previously named `getprivatesendinfo` prior to Dash Core 0.17.0).

*Parameters: none*

*Result---(for regular nodes) information about the pool*

| Name                     | Type                  | Presence                | Description |
| ------------------------ | --------------------- | ----------------------- | ----------- |
| `result`                 | object                | Required<br>(exactly 1) | Information about the pool |
| →<br>`enabled`           | bool                  | Required<br>(exactly 1) | Whether CoinJoin functionality is enabled |
| →<br>`multisession`      | bool                  | Required<br>(exactly 1) | Whether CoinJoin multisession option is enabled |
| →<br>`max_sessions`      | number (int)          | Required<br>(exactly 1) | How many parallel sessions can there be at once |
| →<br>`max_rounds`        | number (int)          | Required<br>(exactly 1) | How many rounds to process |
| →<br>`max_amount`        | number (int)          | Required<br>(exactly 1) | How many DASH to keep processed |
| →<br>`denoms_goal`       | number (int)          | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>How many inputs of each denominated amount to target |
| →<br>`denoms_hardcap`    | number (int)          | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br>Maximum limit of how many inputs of each denominated amount to create |
| →<br>`queue_size`        | number (int)          | Required<br>(exactly 1) | How many queues there are currently on the network |
| →<br>`running`           | bool                  | Required<br>(exactly 1) | Whether CoinJoin is currently running |
| →<br>`sessions`          | array of json objects | Required<br>(exactly 1) | Information about session(s) |
| → →<br>Session           | object                | Optional<br>(1 or more) | Information for a session |
| → → →<br>`protxhash`     | string                | Required<br>(exactly 1) | The ProTxHash of the masternode |
| → → →<br>`outpoint`      | string (txid-index)   | Required<br>(exactly 1) | The outpoint of the masternode |
| → → →<br>`service`       | string (host:port)    | Required<br>(exactly 1) | The IP address and port of the masternode |
| → → →<br>`denomination`  | number (int)          | Required<br>(exactly 1) | The denomination of the session (in DASH) |
| → → →<br>`state`         | string                | Required<br>(exactly 1) | Current state of the session |
| → → →<br>`entries_count` | number (int)          | Required<br>(exactly 1) | The number of entries in the session |
| →<br>`keys_left`         | number (int)          | Optional<br>(0 or 1) | *Changed to optional in Dash Core 22.0.0*<br>How many new keys are left since last automatic backup |
| →<br>`warnings`          | string                | Optional<br>(exactly 1) | Any warnings |

*Result---(for masternodes) information about the pool*

| Name                 | Type         | Presence                | Description |
| -------------------- | ------------ | ----------------------- | ----------- |
| `result`             | object       | Required<br>(exactly 1) | Information about the pool |
| →<br>`queue_size`    | number (int) | Required<br>(exactly 1) | How many queues there are currently on the network |
| →<br>`denomination`  | number (int) | Required<br>(exactly 1) | The denomination of the session (in DASH) |
| →<br>`state`         | string       | Required<br>(exactly 1) | Current state of the session |
| →<br>`entries_count` | number (int) | Required<br>(exactly 1) | The number of entries in the session |

*Example from Dash Core 0.17.0 (regular node)*

``` bash
dash-cli -testnet getcoinjoininfo
```

Result:

``` json
{
  "enabled": true,
  "multisession": true,
  "max_sessions": 4,
  "max_rounds": 16,
  "max_amount": 2000,
  "denoms_goal": 50,
  "denoms_hardcap": 300,
  "queue_size": 3,
  "running": true,
  "sessions": [
    {
      "protxhash": "0515c9a411df0f1bd9940d9a2e4f6d739c29c52fc8c045c383f1ff6acc87c7b7",
      "outpoint": "0a6520a6ef523de71fd0ca70441e1fd648483f094442d986b24e2c9391be61cf-29",
      "service": "54.170.119.85:26216",
      "denomination": 10.00010000,
      "state": "QUEUE",
      "entries_count": 0
    }
  ],
  "keys_left": 998,
  "warnings": ""
}
```

*See also: none*

## GetSuperblockBudget

The [`getsuperblockbudget` RPC](#getsuperblockbudget) returns the absolute maximum sum of superblock payments allowed.

*Parameter #1---block index*

| Name  | Type         | Presence                | Description          |
| ----- | ------------ | ----------------------- | -------------------- |
| index | number (int) | Required<br>(exactly 1) | The superblock index |

*Result---maximum sum of superblock payments*

| Name     | Type         | Presence                | Description                                                      |
| -------- | ------------ | ----------------------- | ---------------------------------------------------------------- |
| `result` | number (int) | Required<br>(exactly 1) | The absolute maximum sum of superblock payments allowed, in DASH |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getsuperblockbudget 7392
```

Result:

``` text
367.20
```

*See also:*

* [GetGovernanceInfo](#getgovernanceinfo): returns an object containing governance parameters.

## GObject

The [`gobject` RPC](#gobject) provides a set of commands for managing governance objects and displaying information about them.

### GObject Check

The `gobject check` RPC validates governance object data (*proposals only*).

*Parameter #1---object data (hex)*

| Name       | Type         | Presence                | Description                                    |
| ---------- | ------------ | ----------------------- | ---------------------------------------------- |
| `data-hex` | string (hex) | Required<br>(exactly 1) | The data (hex) of a governance proposal object |

*Result---governance object status*

| Name                 | Type   | Presence                | Description                     |
| -------------------- | ------ | ----------------------- | ------------------------------- |
| Result               | object | Required<br>(exactly 1) | Object containing status        |
| →<br>`Object Status` | string | Required<br>(exactly 1) | Status of the governance object |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet gobject check 7b22656e645f65706f6368223a3135363034353730\
35352c226e616d65223a2274657374222c227061796d656e745f61646472657373223a22796\
4354b4d52457333474c4d65366d544a597233597248316a75774e777246436642222c227061\
796d656e745f616d6f756e74223a352c2273746172745f65706f6368223a313536303435333\
439302c2274797065223a312c2275726c223a22687474703a2f2f746573742e636f6d227d
```

Result:

``` json
{
  "Object status": "OK"
}
```

### GObject Count

The `gobject count` RPC returns the count of governance objects and votes.

*Parameter #1---mode*

| Name   | Type   | Presence                | Description                                                                                                        |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `mode` | string | Optional<br>(exactly 1) | Result return format:<br>`json` (default)<br>`all` - Default before Dash Core 0.12.3 (for backwards compatibility) |

**Command Mode - `json`**

*Result---count of governance objects and votes*

| Name                 | Type   | Presence                | Description                             |
| -------------------- | ------ | ----------------------- | --------------------------------------- |
| Result               | object | Required<br>(exactly 1) | Information about the governance object |
| →<br>`objects_total` | int    | Required<br>(exactly 1) | Total object count                      |
| →<br>`proposals`     | int    | Required<br>(exactly 1) | Proposal count                          |
| →<br>`triggers`      | int    | Required<br>(exactly 1) | Trigger count                           |
| →<br>`other`         | int    | Required<br>(exactly 1) | Non-proposal/trigger count              |
| →<br>`erased`        | int    | Required<br>(exactly 1) | Erased count                            |
| →<br>`votes`         | int    | Required<br>(exactly 1) | Vote count                              |

_Example from Dash Core 0.14.0 (mode: `json`/default)_

``` bash
dash-cli -testnet gobject count
```

Result (wrapped):

``` json
{
  "objects_total": 3,
  "proposals": 3,
  "triggers": 0,
  "other": 0,
  "erased": 4,
  "votes": 18
}
```

**Command Mode - `all`**

*Result---count of governance objects and votes*

| Name     | Type   | Presence                | Description                               |
| -------- | ------ | ----------------------- | ----------------------------------------- |
| `result` | string | Required<br>(exactly 1) | The count of governance objects and votes |

_Example from Dash Core 0.14.0 (mode: `all`)_

``` bash
dash-cli -testnet gobject count all
```

Result (wrapped):

``` text
Governance Objects: 177 (Proposals: 177, Triggers: 0, Other: 0; Erased: 5), \
Votes: 9680
```

### GObject Deserialize

The `gobject deserialize` RPC deserializes a governance object from a hex string to JSON.

*Parameter #1---object data (hex)*

| Name       | Type         | Presence                | Description                           |
| ---------- | ------------ | ----------------------- | ------------------------------------- |
| `hex_data` | string (hex) | Required<br>(exactly 1) | The data (hex) of a governance object |

**Results**

The result output varies depending on the type of governance object being deserialized. Examples are shown below for both proposal and trigger object types.

**Result - Proposal**

*Result---governance proposal object deserialized to JSON*

| Name                     | Type   | Presence                | Description                                                                                               |
| ------------------------ | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------- |
| Result                   | object | Required<br>(exactly 1) | Array of governance objects                                                                               |
| → →<br>`end_epoch`       | string | Required<br>(exactly 1) | Governance object info as string                                                                          |
| → →<br>`name`            | string | Required<br>(exactly 1) | Proposal name                                                                                             |
| → →<br>`payment_address` | string | Required<br>(exactly 1) | Proposal payment address.<br>***Support for P2SH addresses (e.g. multisig) added in Dash Core v18.0.0.*** |
| → →<br>`payment_amount`  | string | Required<br>(exactly 1) | Proposal payment amount                                                                                   |
| → →<br>`start_epoch`     | int    | Required<br>(exactly 1) | Proposal start                                                                                            |
| → →<br>`type`            | int    | Required<br>(exactly 1) | Object type                                                                                               |
| → →<br>`url`             | string | Required<br>(exactly 1) | Proposal URL                                                                                              |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet gobject deserialize 7b22656e645f65706f6368223a313536303435\
373035352c226e616d65223a2274657374222c227061796d656e745f61646472657373223a22\
7964354b4d52457333474c4d65366d544a597233597248316a75774e777246436642222c2270\
61796d656e745f616d6f756e74223a352c2273746172745f65706f6368223a31353630343533\
3439302c2274797065223a312c2275726c223a22687474703a2f2f746573742e636f6d227d
```

Result:

``` json
{
  "end_epoch": 1560457055,
  "name": "test",
  "payment_address": "yd5KMREs3GLMe6mTJYr3YrH1juwNwrFCfB",
  "payment_amount": 5,
  "start_epoch": 1560453490,
  "type": 1,
  "url": "http://test.com"
}
```

**Result - Trigger**

*Result---governance trigger object deserialized to JSON*

| Name                        | Type         | Presence                | Description                      |
| --------------------------- | ------------ | ----------------------- | -------------------------------- |
| Result                      | object       | Required<br>(exactly 1) | Array of governance objects      |
| → →<br>`event_block_height` | int          | Required<br>(exactly 1) | Block height to activate trigger |
| → →<br>`payment_addresses`  | string       | Required<br>(exactly 1) | Proposal payment address         |
| → →<br>`payment_amounts`    | string       | Required<br>(exactly 1) | Proposal payment amount          |
| → →<br>`proposal_hashes`    | string (hex) | Required<br>(exactly 1) | Proposal hashes                  |
| → →<br>`type`               | int          | Required<br>(exactly 1) | Object type                      |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet gobject deserialize 7b226576656e745f626c6f636b5f68656967687\
4223a203131393539322c20227061796d656e745f616464726573736573223a20227954686d6e\
75565a316765516e79776f456147627079333362695435473573587a62222c20227061796d656\
e745f616d6f756e7473223a2022312e3335393631393331222c202270726f706f73616c5f6861\
73686573223a20223836333966636464653131626432373032373663396330333564366435346\
3653962393138323465366466373532636164376464646331616532663734386435222c202274\
797065223a20327d
```

Result (wrapped):

``` json
{
  "event_block_height": 119592,
  "payment_addresses": "yThmnuVZ1geQnywoEaGbpy33biT5G5sXzb",
  "payment_amounts": "1.35961931",
  "proposal_hashes": "8639fcdde11bd270276c9c035d6d54ce9b91824e6df752cad7dddc1ae2f748d5",
  "type": 2
}
```

### GObject Diff

The `gobject diff` RPC Lists governance objects differences since last diff.

*Parameter #1---signal*

| Name     | Type   | Presence                | Description                                                                                                         |
| -------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `signal` | string | Optional<br>(exactly 1) | Type of governance object signal: <br>• `valid`<br>• `funding`<br>• `delete`<br>• `endorsed`<br>• `all` (*DEFAULT*) |

*Parameter #2---type*

| Name   | Type   | Presence                | Description                                                                                |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------ |
| `type` | string | Optional<br>(exactly 1) | Type of governance object signal: <br>• `proposals`<br>• `triggers`<br>• `all` (*DEFAULT*) |

*Result---governance objects*

| Name                       | Type         | Presence                | Description                                                                                                                                                 |
| -------------------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Result                     | object       | Required<br>(exactly 1) | Information about the governance object                                                                                                                     |
| →<br>Governance Object(s)  | object       | Required<br>(1 or more) | Key: Governance object hash<br>Values: Governance object details                                                                                            |
| → →<br>`DataHex`           | string (hex) | Required<br>(exactly 1) | Governance object info as hex string                                                                                                                        |
| → →<br>`DataString`        | string       | Required<br>(exactly 1) | Governance object info as string                                                                                                                            |
| → →<br>`Hash`              | string (hex) | Required<br>(exactly 1) | Hash of this governance object                                                                                                                              |
| → →<br>`CollateralHash`    | string (hex) | Required<br>(exactly 1) | Hash of the collateral payment transaction                                                                                                                  |
| → →<br>`ObjectType`        | number       | Required<br>(exactly 1) | Object types:<br>`1` - Unknown<br>`2` - Proposal<br>`3` - Trigger                                                                                           |
| → →<br>`CreationTime`      | number       | Required<br>(exactly 1) | Object creation time as Unix epoch time                                                                                                                     |
| → →<br>`SigningMasternode` | string (hex) | Optional<br>(0 or 1)    | Signing masternode's vin (only present in triggers)                                                                                                         |
| → →<br>`AbsoluteYesCount`  | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`          | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`           | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`      | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`fLocalValidity`      | boolean      | Required<br>(exactly 1) | Valid by the blockchain                                                                                                                                     |
| →<br>`IsValidReason`       | string       | Required<br>(exactly 1) | `fLocalValidity` error result. Empty if no error returned.                                                                                                  |
| →<br>`fCachedValid`        | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as a valid and understood governance object (e.g, the serialized data is correct format, etc) |
| →<br>`fCachedFunding`      | boolean      | Required<br>(exactly 1) | Minimum network support has been reached for this object to be funded (doesn't mean it will be for sure though)                                             |
| →<br>`fCachedDelete`       | boolean      | Required<br>(exactly 1) | Minimum network support has been reached saying this object should be deleted from the system entirely                                                      |
| →<br>`fCachedEndorsed`     | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as endorsed                                                                                   |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject diff all all
```

Result (truncated):

``` json
{
  "17c2bd32005c5168a52f9b5caa74d875ee8a6867a6109f36923887ef6c36b301": {
    "DataHex": "5b5b2270726f706f73616c222c7b22656e645f65706f6368223a2231353037343533353731222c226e616d65223a227465737470726f706f73616c5f2d5f6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383931353037323634343939222c227061796d656e745f61646472657373223a2279697355653636445352487048504233514245426764574746637068435933626234222c227061796d656e745f616d6f756e74223a2232222c2273746172745f65706f6368223a2231353037323634343939222c2274797065223a312c2275726c223a2268747470733a2f2f7777772e6461736863656e7472616c2e6f72672f702f746573745f70726f706f73616c5f31353037323634343939227d5d5d",
    "DataString": "[[\"proposal\",{\"end_epoch\":\"1507453571\",\"name\":\"testproposal\",\"payment_address\":\"yisUe66DSRHpHPB3QBEBgdWGFcphCY3bb4\",\"payment_amount\":\"2\",\"start_epoch\":\"1507264499\",\"type\":1,\"url\":\"https://www.dashcentral.org/p/test_proposal_1507264499\"}]]",
    "Hash": "17c2bd32005c5168a52f9b5caa74d875ee8a6867a6109f36923887ef6c36b301",
    "CollateralHash": "a25c44b57931afd74530ce39741f91456446a8fd794d2f1c58c42d6f492647ad",
    "ObjectType": 1,
    "CreationTime": 1507264499,
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0,
    "fBlockchainValidity": true,
    "IsValidReason": "",
    "fCachedValid": true,
    "fCachedFunding": false,
    "fCachedDelete": false,
    "fCachedEndorsed": false
  }
}
```

### GObject Get

The `gobject get` RPC returns a governance object by hash.

*Parameter #1---object hash*

| Name              | Type         | Presence                | Description                     |
| ----------------- | ------------ | ----------------------- | ------------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | The hash of a governance object |

*Result---governance object details*

| Name                      | Type         | Presence                | Description                                                                                                                                                 |
| ------------------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Result                    | object       | Required<br>(exactly 1) | Information about the governance object                                                                                                                     |
| →<br>`DataHex`            | string (hex) | Required<br>(exactly 1) | Governance object info as hex string                                                                                                                        |
| →<br>`DataString`         | string       | Required<br>(exactly 1) | Governance object info as string                                                                                                                            |
| →<br>`Hash`               | string (hex) | Required<br>(exactly 1) | Hash of this governance object                                                                                                                              |
| →<br>`CollateralHash`     | string (hex) | Required<br>(exactly 1) | Hash of the collateral payment transaction                                                                                                                  |
| →<br>`ObjectType`         | number       | Required<br>(exactly 1) | Object types:<br>`1` - Unknown<br>`2` - Proposal<br>`3` - Trigger                                                                                           |
| →<br>`CreationTime`       | number       | Required<br>(exactly 1) | Object creation time as Unix epoch time                                                                                                                     |
| →<br>`FundingResult`      | object       | Required<br>(exactly 1) | Funding vote details                                                                                                                                        |
| → →<br>`AbsoluteYesCount` | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`         | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`          | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`     | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`ValidResult`        | object       | Required<br>(exactly 1) | Object validity vote details                                                                                                                                |
| → →<br>`AbsoluteYesCount` | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`         | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`          | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`     | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`DeleteResult`       | object       | Required<br>(exactly 1) | Delete vote details                                                                                                                                         |
| → →<br>`AbsoluteYesCount` | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`         | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`          | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`     | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`EndorsedResult`     | object       | Required<br>(exactly 1) | Endorsed vote details                                                                                                                                       |
| → →<br>`AbsoluteYesCount` | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`         | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`          | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`     | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`fLocalValidity`     | boolean      | Required<br>(exactly 1) | Valid by the blockchain                                                                                                                                     |
| →<br>`IsValidReason`      | string       | Required<br>(exactly 1) | `fLocalValidity` error result. Empty if no error returned.                                                                                                  |
| →<br>`fCachedValid`       | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as a valid and understood governance object (e.g, the serialized data is correct format, etc) |
| →<br>`fCachedFunding`     | boolean      | Required<br>(exactly 1) | Minimum network support has been reached for this object to be funded (doesn't mean it will be for sure though)                                             |
| →<br>`fCachedDelete`      | boolean      | Required<br>(exactly 1) | Minimum network support has been reached saying this object should be deleted from the system entirely                                                      |
| →<br>`fCachedEndorsed`    | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as endorsed                                                                                   |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject get \
 42253a7bec554b97a65d2889e6cb9a1cf308b3d47a778c704bf9cdc1fe1bf6ff
```

Result (wrapped):

``` json
{
  "DataHex": "5b5b2270726f706f73616c222c7b22656e645f65706f6368223a2231353037343339353130222c226e616d65223a227465737470726f706f73616c5f2d5f6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383931353037323530343338222c227061796d656e745f61646472657373223a22795668577955345933756456784d5234464b3333556741534a41436831436835516a222c227061796d656e745f616d6f756e74223a2232222c2273746172745f65706f6368223a2231353037323530343338222c2274797065223a312c2275726c223a2268747470733a2f2f7777772e6461736863656e7472616c2e6f72672f702f746573745f70726f706f73616c5f31353037323530343338227d5d5d",
  "DataString": "[[\"proposal\",{\"end_epoch\":\"1507439510\",\"name\":\"testproposal_-_abcdefghijklmnopqrstuvwxyz01234567891507250438\",\"payment_address\":\"yVhWyU4Y3udVxMR4FK33UgASJACh1Ch5Qj\",\"payment_amount\":\"2\",\"start_epoch\":\"1507250438\",\"type\":1,\"url\":\"https://www.dashcentral.org/p/test_proposal_1507250438\"}]]",
  "Hash": "42253a7bec554b97a65d2889e6cb9a1cf308b3d47a778c704bf9cdc1fe1bf6ff",
  "CollateralHash": "cb09bd0310c0a67cde9387ad4d8908a7ad9f5d89c5afd58e9332b8bd26a646c7",
  "ObjectType": 1,
  "CreationTime": 1507246694,
  "FundingResult": {
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0
  },
  "ValidResult": {
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0
  },
  "DeleteResult": {
    "AbsoluteYesCount": 31,
    "YesCount": 31,
    "NoCount": 0,
    "AbstainCount": 0
  },
  "EndorsedResult": {
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0
  },
  "fLocalValidity": true,
  "IsValidReason": "",
  "fCachedValid": true,
  "fCachedFunding": false,
  "fCachedDelete": false,
  "fCachedEndorsed": false
}
```

### GObject Getcurrentvotes

The `gobject getcurrentvotes` RPC gets only current (tallying) votes for a governance object hash (does not include old votes).

*Parameter #1---object hash*

| Name              | Type         | Presence                | Description                     |
| ----------------- | ------------ | ----------------------- | ------------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | The hash of a governance object |

*Parameter #2---transaction ID*

| Name   | Type   | Presence             | Description                                      |
| ------ | ------ | -------------------- | ------------------------------------------------ |
| `txid` | string | Optional<br>(0 or 1) | The transaction ID of the masternode collateral. |

*Parameter #3---output index*

| Name   | Type   | Presence             | Description                                                          |
| ------ | ------ | -------------------- | -------------------------------------------------------------------- |
| `vout` | string | Optional<br>(0 or 1) | Masternode collateral output index. This is required if txid present |

*Result---votes for specified governance*

| Name           | Type   | Presence                | Description                                                                                                             |
| -------------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Result         | object | Required<br>(exactly 1) | The governance object votes                                                                                             |
| →<br>Vote Info | string | Required<br>(1 or more) | Key: vote-hash<br><br>Value: vinMasternode, time, outcome, vote signal, and vote weight (1 vote / 1000 DASH collateral) |

*Example from Dash Core 19.0.0*

``` bash
dash-cli -testnet gobject getcurrentvotes 78941af577f639ac94440e4855a1ed8f\
  696f1506d1c0bed4f4b68f05be26d3ca
```

Result (truncated):

``` json
{
  "174aaba65982d25a23f437e2a66ec3836146ba7b7ce5b3fe2d5476907f7079d9": "2eab488e3a7b030303de0d18e357ce17a9fc6b8876705d61076bbe923b2e5fc8-1:1509354047:YES:DELETE:1",
  "444d4d871ec35479804f060c733f516908382642ec2dfce6044a59fcadfdcd60": "18e496fe85b61ac9a5fcaec1ef683c7e3fc9bce4a83c883608427ecfb1002fca-1:1508866932:YES:FUNDING:4",
  "d49a472c62e9d8105931829fc50ef6c6ce04a230507646ee0eaa615e863ef3a0": "18e496fe85b61ac9a5fcaec1ef683c7e3fc9bce4a83c883608427ecfb1002fca-1:1509117071:YES:DELETE:1",
  "78442507441d4524d2493b8568d130415c1eb394adb2fe38d6ffeb199115bc5d": "3df7fb192e21c34da99bdd10c34e58ecaf3f3c37d6b2289f0ffedba5050188cc-1:1509312524:YES:DELETE:4",
  "aa4dc9d3b9e74e8c1ffc725b737d07f8a32e43c64907e4bea19e64a86135f08a": "af9f5646ace92f76b3a01b0abe08716a0a7ded64074c2d2e712c93174b9013d1-1:1508866932:YES:FUNDING:1",
}
```

### GObject List

The `gobject list` RPC Lists governance objects (can be filtered by signal and/or object type).

*Parameter #1---signal*

| Name     | Type   | Presence                | Description                                                                                                         |
| -------- | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `signal` | string | Optional<br>(exactly 1) | Type of governance object signal: <br>• `valid`<br>• `funding`<br>• `delete`<br>• `endorsed`<br>• `all` (*DEFAULT*) |

*Parameter #2---type*

| Name   | Type   | Presence                | Description                                                                                |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------ |
| `type` | string | Optional<br>(exactly 1) | Type of governance object signal: <br>• `proposals`<br>• `triggers`<br>• `all` (*DEFAULT*) |

*Result---governance objects*

| Name                       | Type         | Presence                | Description                                                                                                                                                 |
| -------------------------- | ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Result                     | object       | Required<br>(exactly 1) | Information about the governance object                                                                                                                     |
| →<br>Governance Object(s)  | object       | Required<br>(1 or more) | Key: Governance object hash<br>Values: Governance object details                                                                                            |
| → →<br>`DataHex`           | string (hex) | Required<br>(exactly 1) | Governance object info as hex string                                                                                                                        |
| → →<br>`DataString`        | string       | Required<br>(exactly 1) | Governance object info as string                                                                                                                            |
| → →<br>`Hash`              | string (hex) | Required<br>(exactly 1) | Hash of this governance object                                                                                                                              |
| → →<br>`CollateralHash`    | string (hex) | Required<br>(exactly 1) | Hash of the collateral payment transaction                                                                                                                  |
| → →<br>`ObjectType`        | number       | Required<br>(exactly 1) | Object types:<br>`1` - Unknown<br>`2` - Proposal<br>`3` - Trigger                                                                                           |
| → →<br>`CreationTime`      | number       | Required<br>(exactly 1) | Object creation time as Unix epoch time                                                                                                                     |
| → →<br>`SigningMasternode` | string (hex) | Optional<br>(0 or 1)    | Signing masternode's vin (only present in triggers)                                                                                                         |
| → →<br>`AbsoluteYesCount`  | number       | Required<br>(exactly 1) | Number of `Yes` votes minus number of `No` votes                                                                                                            |
| → →<br>`YesCount`          | number       | Required<br>(exactly 1) | Number of `Yes` votes                                                                                                                                       |
| → →<br>`NoCount`           | number       | Required<br>(exactly 1) | Number of `No` votes                                                                                                                                        |
| → →<br>`AbstainCount`      | number       | Required<br>(exactly 1) | Number of `Abstain` votes                                                                                                                                   |
| →<br>`fLocalValidity`      | boolean      | Required<br>(exactly 1) | Valid by the blockchain                                                                                                                                     |
| →<br>`IsValidReason`       | string       | Required<br>(exactly 1) | `fLocalValidity` error result. Empty if no error returned.                                                                                                  |
| →<br>`fCachedValid`        | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as a valid and understood governance object (e.g, the serialized data is correct format, etc) |
| →<br>`fCachedFunding`      | boolean      | Required<br>(exactly 1) | Minimum network support has been reached for this object to be funded (doesn't mean it will be for sure though)                                             |
| →<br>`fCachedDelete`       | boolean      | Required<br>(exactly 1) | Minimum network support has been reached saying this object should be deleted from the system entirely                                                      |
| →<br>`fCachedEndorsed`     | boolean      | Required<br>(exactly 1) | Minimum network support has been reached flagging this object as endorsed                                                                                   |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject list all proposals
```

Result (truncated):

``` json
{
  "b370fa1afd61aca9aa879abea3087e29656a670478f281d4196efb4e7e893ffe": {
    "DataHex": "5b5b2270726f706f73616c222c7b22656e645f65706f6368223a2231353037343430303338222c226e616d65223a227465737470726f706f73616c5f2d5f6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383931353037323530393636222c227061796d656e745f61646472657373223a2279544c636f506d4e315963654432534345474d6b6e34395753565a4277626f646e6e222c227061796d656e745f616d6f756e74223a2232222c2273746172745f65706f6368223a2231353037323530393636222c2274797065223a312c2275726c223a2268747470733a2f2f7777772e6461736863656e7472616c2e6f72672f702f746573745f70726f706f73616c5f31353037323530393636227d5d5d",
    "DataString": "[[\"proposal\",{\"end_epoch\":\"1507440038\",\"name\":\"testproposal_-_abcdefghijklmnopqrstuvwxyz01234567891507250966\",\"payment_address\":\"yTLcoPmN1YceD2SCEGMkn49WSVZBwbodnn\",\"payment_amount\":\"2\",\"start_epoch\":\"1507250966\",\"type\":1,\"url\":\"https://www.dashcentral.org/p/test_proposal_1507250966\"}]]",
    "Hash": "b370fa1afd61aca9aa879abea3087e29656a670478f281d4196efb4e7e893ffe",
    "CollateralHash": "a51ea89c14735f8b5df37cd846b3561494cc616d4a741e4ef83b368d45c960ba",
    "ObjectType": 1,
    "CreationTime": 1507250966,
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0,
    "fBlockchainValidity": true,
    "IsValidReason": "",
    "fCachedValid": true,
    "fCachedFunding": false,
    "fCachedDelete": false,
    "fCachedEndorsed": false
  },
  "906ae4dbd285e1025832ac9b3160073ecbfeef094d34cf81b3d797a349c720ff": {
    "DataHex": "5b5b2270726f706f73616c222c7b22656e645f65706f6368223a2231353037343534383935222c226e616d65223a227465737470726f706f73616c5f2d5f6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383931353037323635383233222c227061796d656e745f61646472657373223a2279664e68484c4c695936577a5a646a51766137324a64395134313468516578514c68222c227061796d656e745f616d6f756e74223a2232222c2273746172745f65706f6368223a2231353037323635383233222c2274797065223a312c2275726c223a2268747470733a2f2f7777772e6461736863656e7472616c2e6f72672f702f746573745f70726f706f73616c5f31353037323635383233227d5d5d",
    "DataString": "[[\"proposal\",{\"end_epoch\":\"1507454895\",\"name\":\"testproposal_-_abcdefghijklmnopqrstuvwxyz01234567891507265823\",\"payment_address\":\"yfNhHLLiY6WzZdjQva72Jd9Q414hQexQLh\",\"payment_amount\":\"2\",\"start_epoch\":\"1507265823\",\"type\":1,\"url\":\"https://www.dashcentral.org/p/test_proposal_1507265823\"}]]",
    "Hash": "906ae4dbd285e1025832ac9b3160073ecbfeef094d34cf81b3d797a349c720ff",
    "CollateralHash": "1707470c4372ba048b72945365b4bb71afc8a986e0755c1f1e8a37bba21fde83",
    "ObjectType": 1,
    "CreationTime": 1507265823,
    "AbsoluteYesCount": 0,
    "YesCount": 0,
    "NoCount": 0,
    "AbstainCount": 0,
    "fBlockchainValidity": true,
    "IsValidReason": "",
    "fCachedValid": true,
    "fCachedFunding": false,
    "fCachedDelete": false,
    "fCachedEndorsed": false
  }
}
```

```{eval-rst}
.. _api-rpc-dash-gobject-prepare:
```

### GObject Prepare

The `gobject prepare` RPC prepares a governance object by signing and creating a collateral transaction. Dash Core v18.0.0 added support for directing proposal payouts to P2SH addresses such as multisig.

*Parameter #1---parent hash*

| Name          | Type         | Presence                | Description                                                            |
| ------------- | ------------ | ----------------------- | ---------------------------------------------------------------------- |
| `parent-hash` | string (hex) | Required<br>(exactly 1) | Hash of the parent object. Usually the root node which has a hash of 0 |

*Parameter #2---revision*

| Name       | Type | Presence                | Description            |
| ---------- | ---- | ----------------------- | ---------------------- |
| `revision` | int  | Required<br>(exactly 1) | Object revision number |

*Parameter #3---time*

| Name   | Type    | Presence                | Description                   |
| ------ | ------- | ----------------------- | ----------------------------- |
| `time` | int64_t | Required<br>(exactly 1) | Create time (Unix epoch time) |

*Parameter #4---data*

| Name       | Type         | Presence                | Description                                                                                                                                                                                                           |
| ---------- | ------------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data-hex` | string (hex) | Required<br>(exactly 1) | **Updated in Dash Core 0.14.0 to require all new proposals to use JSON serialization.**<br><br>Object data (JSON object with governance details). Additional details regarding this are provided in an example below. |

*Parameter #5---use-IS*

| Name     | Type    | Presence             | Description                                     |
| -------- | ------- | -------------------- | ----------------------------------------------- |
| `use-IS` | boolean | Optional<br>(0 or 1) | *Deprecated and ignored since Dash Core 0.15.0* |

*Parameter #6---outputHash*

| Name         | Type         | Presence             | Description                                                                          |
| ------------ | ------------ | -------------------- | ------------------------------------------------------------------------------------ |
| `outputHash` | string (hex) | Optional<br>(0 or 1) | *Added in Dash Core 0.13.0*<br><br>The single output to submit the proposal fee from |

*Parameter #7---outputIndex*

| Name          | Type    | Presence             | Description                                                                                              |
| ------------- | ------- | -------------------- | -------------------------------------------------------------------------------------------------------- |
| `outputIndex` | numeric | Optional<br>(0 or 1) | *Added in Dash Core 0.13.0*<br><br>The output index (required if the `outputHash` parameter is provided) |

*Result---collateral transaction ID*

| Name     | Type         | Presence                | Description                                   |
| -------- | ------------ | ----------------------- | --------------------------------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Transaction ID for the collateral transaction |

**Details of the `data-hex` field:**

The `data-hex` field is comprised of a JSON object as described in [GObject Deserialize](#gobject-deserialize) which is serialized to hex.

An example of a proposal JSON object is shown here:

``` json
{
  "end_epoch": 1560457055,
  "name": "test",
  "payment_address": "yd5KMREs3GLMe6mTJYr3YrH1juwNwrFCfB",
  "payment_amount": 5,
  "start_epoch": 1560453490,
  "type": 1,
  "url": "http://test.com"
}
```

To serialize the object, first remove all spaces from the JSON object as shown below:

``` json
{"end_epoch":1560457055,"name":"test","payment_address":"yd5KMREs3GLMe6mTJYr3YrH1juwNwrFCfB","payment_amount":5,"start_epoch":1560453490,"type":1,"url":"http://test.com"}
```

Then convert the string to its hex equivalent as shown below. This is what will be used for the `data-hex` field of the `gobject prepare` command:

``` bash
7b22656e645f65706f6368223a313536303435373035352c226e616d65223a2274657374222c\
227061796d656e745f61646472657373223a227964354b4d52457333474c4d65366d544a5972\
33597248316a75774e777246436642222c227061796d656e745f616d6f756e74223a352c2273\
746172745f65706f6368223a313536303435333439302c2274797065223a312c2275726c223a\
22687474703a2f2f746573742e636f6d227d
```

*Example from Dash Core 0.14.0*

``` bash
gobject prepare 0 1 1560449223 7b22656e645f65706f6368223a3135363034353730353\
52c226e616d65223a2274657374222c227061796d656e745f61646472657373223a227964354\
b4d52457333474c4d65366d544a597233597248316a75774e777246436642222c227061796d6\
56e745f616d6f756e74223a352c2273746172745f65706f6368223a313536303435333439302\
c2274797065223a312c2275726c223a22687474703a2f2f746573742e636f6d227d
```

Result (Collateral Transaction ID):

``` bash
3fd758e7a5761bb07b2850b8ba432ef42c1ea80f0921d2eab0682697dda78262
```

*See also:*

* [GObject List-Prepared](#gobject-list-prepared): returns a list of governance objects prepared by this wallet

### GObject List-Prepared

The `gobject list-prepared` RPC returns a list of governance objects prepared by this wallet with [`gobject prepare`](#gobject-prepare) sorted by their creation time.

*Parameter #1---count*

| Name    | Type         | Presence             | Description                         |
| ------- | ------------ | -------------------- | ----------------------------------- |
| `count` | number (int) | Optional<br>(0 or 1) | Maximum number of objects to return |

*Result---list of governance objects*

| Name                       | Type         | Presence                | Description                                                            |
| -------------------------- | ------------ | ----------------------- | ---------------------------------------------------------------------- |
| `result`                   | array        | Required<br>(exactly 1) | List of governance objects                                             |
| →<br>Governance Object     | object       | Required<br>(0 or more) | Proposal object                                                        |
| → →<br>`objectHash`        | string (hex) | Required<br>(exactly 1) | Proposal object hash                                                   |
| → →<br>`parentHash`        | string (hex) | Required<br>(exactly 1) | Hash of the parent object. Usually the root node which has a hash of 0 |
| → →<br>`collateralHash`    | string (hex) | Required<br>(exactly 1) | Hash of the collateral payment transaction                             |
| → →<br>`createdAt`         | number (int) | Required<br>(exactly 1) | Proposal creation time as Unix epoch time                              |
| → →<br>`revision`          | number (int) | Required<br>(exactly 1) | Proposal revision number                                               |
| → →<br>`data`              | object       | Required<br>(exactly 1) | Object containing governance object data                               |
| → → →<br>`end_epoch`       | string       | Required<br>(exactly 1) | Governance object info as string                                       |
| → → →<br>`name`            | string       | Required<br>(exactly 1) | Proposal name                                                          |
| → → →<br>`payment_address` | string       | Required<br>(exactly 1) | Proposal payment address                                               |
| → → →<br>`payment_amount`  | string       | Required<br>(exactly 1) | Proposal payment amount                                                |
| → → →<br>`start_epoch`     | number (int) | Required<br>(exactly 1) | Proposal start                                                         |
| → → →<br>`type`            | number (int) | Required<br>(exactly 1) | Object type                                                            |
| → → →<br>`url`             | string       | Required<br>(exactly 1) | Proposal URL                                                           |
| → → →<br>`hex`             | string (hex) | Required<br>(exactly 1) | Governance object data as hex                                          |

*Example from Dash Core 0.17.0*

``` bash
gobject list-prepared
```

Result (Collateral Transaction ID):

``` json
[
  {
    "objectHash": "307cde2e485968548cd1a19473bf48f788c16178d82f63cbe849c33988d9592b",
    "parentHash": "0000000000000000000000000000000000000000000000000000000000000000",
    "collateralHash": "987570add8979576cb8a4ee510df448fd2ae7097628b7980559489ecb116b0fa",
    "createdAt": 1608143561,
    "revision": 1,
    "data": {
      "end_epoch": 1608151237,
      "name": "test",
      "payment_address": "yd5KMREs3GLMe6mTJYr3YrH1juwNwrFCfB",
      "payment_amount": 5,
      "start_epoch": 1608147672,
      "type": 1,
      "url": "https://www.dash.org",
      "hex": "7b22656e645f65706f6368223a313630383135313233372c226e616d65223a2274657374222c227061796d656e745f61646472657373223a227964354b4d52457333474c4d65366d544a597233597248316a75774e777246436642222c227061796d656e745f616d6f756e74223a352c2273746172745f65706f6368223a313630383134373637322c2274797065223a312c2275726c223a2268747470733a2f2f7777772e646173682e6f7267227d"
    }
  }
]
```

*See also:*

* [GObject Prepared](#gobject-prepare): prepares a governance object by signing and creating a collateral transaction

```{eval-rst}
.. _api-rpc-dash-gobject-submit:
```

### GObject Submit

The `gobject submit` RPC submits a governance object to network (objects must first be prepared via `gobject prepare`).

Note: Parameters 1-4 should be the same values as the ones used for `gobject
prepare`.

*Parameter #1---parent hash*

| Name          | Type         | Presence                | Description                                                            |
| ------------- | ------------ | ----------------------- | ---------------------------------------------------------------------- |
| `parent-hash` | string (hex) | Required<br>(exactly 1) | Hash of the parent object. Usually the root node which has a hash of 0 |

*Parameter #2---revision*

| Name       | Type | Presence                | Description            |
| ---------- | ---- | ----------------------- | ---------------------- |
| `revision` | int  | Required<br>(exactly 1) | Object revision number |

*Parameter #3---time*

| Name   | Type    | Presence                | Description |
| ------ | ------- | ----------------------- | ----------- |
| `time` | int64_t | Required<br>(exactly 1) | Create time |

*Parameter #4---data*

| Name       | Type         | Presence                | Description                                                                                                                                                                                                                        |
| ---------- | ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data-hex` | string (hex) | Required<br>(exactly 1) | **Updated in Dash Core 0.14.0 to require all new proposals to use JSON serialization.**<br><br>Object data (JSON object with governance details). See [GObject Prepare](#gobject-prepare) for additional details about this field. |

*Parameter #5---fee transaction ID*

| Name   | Type         | Presence                | Description                                                   |
| ------ | ------------ | ----------------------- | ------------------------------------------------------------- |
| `data` | string (hex) | Required<br>(exactly 1) | **Updated in Dash Core 20.0.0 to remove support for trigger objects.**<br><br>Fee transaction ID - required for all objects |

*Result---governance object hash*

| Name     | Type         | Presence                | Description            |
| -------- | ------------ | ----------------------- | ---------------------- |
| `result` | string (hex) | Required<br>(exactly 1) | Governance object hash |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet gobject submit 0 1 1560449223 7b22656e645f65706f6368223a3\
13536303435373035352c226e616d65223a2274657374222c227061796d656e745f61646472\
657373223a227964354b4d52457333474c4d65366d544a597233597248316a75774e7772464\
36642222c227061796d656e745f616d6f756e74223a352c2273746172745f65706f6368223a\
313536303435333439302c2274797065223a312c2275726c223a22687474703a2f2f7465737\
42e636f6d227d \
3fd758e7a5761bb07b2850b8ba432ef42c1ea80f0921d2eab0682697dda78262
```

Result (Governance Object Hash):

``` bash
e353b2ab5f7e7cb24b95e00e153ec2a6339249672f18b8e8e144aa711678710d
```

*See also:*

* [GObject Prepared](#gobject-prepare): prepares a governance object by signing and creating a collateral transaction

### GObject Vote-alias

The `gobject vote-alias` RPC votes on a governance object by masternode alias (using masternode.conf setup).

*Parameter #1---governance hash*

| Name              | Type         | Presence                | Description                   |
| ----------------- | ------------ | ----------------------- | ----------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | Hash of the governance object |

*Parameter #2---vote signal*

| Name     | Type   | Presence                | Description                                  |
| -------- | ------ | ----------------------- | -------------------------------------------- |
| `signal` | string | Required<br>(exactly 1) | Vote signal: `funding`, `valid`, or `delete` |

*Parameter #3---vote outcome*

| Name      | Type   | Presence                | Description                             |
| --------- | ------ | ----------------------- | --------------------------------------- |
| `outcome` | string | Required<br>(exactly 1) | Vote outcome: `yes`, `no`, or `abstain` |

*Parameter #4---masternode alias*

| Name    | Type   | Presence                | Description                |
| ------- | ------ | ----------------------- | -------------------------- |
| `alias` | string | Required<br>(exactly 1) | Alias of voting masternode |

*Result---votes for specified governance*

| Name                    | Type   | Presence                | Description                               |
| ----------------------- | ------ | ----------------------- | ----------------------------------------- |
| Result                  | object | Required<br>(exactly 1) | The governance object votes               |
| →<br>`overall`          | string | Required<br>(1 or more) | Reports number of vote successes/failures |
| →<br>`detail`           | object | Required<br>(exactly 1) | Vote details                              |
| → →<br>Masternode Alias | object | Required<br>(1 or more) | Name of the masternode alias              |
| → → →<br>`result`       | string | Required<br>(exactly 1) | Vote result                               |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject vote-alias \
0bf97bce78b3b642c36d4ca8e9265f8f66de8774c220221f57739c1956413e2b \
funding yes MN01
```

Result:

``` json
{
  "overall": "Voted successfully 1 time(s) and failed 0 time(s).",
  "detail": {
    "MN01": {
      "result": "success"
    }
  }
}
```

### GObject Vote-many

The `gobject vote-many` RPC votes on a governance object by all masternodes (using masternode.conf setup).

*Parameter #1---governance hash*

| Name              | Type         | Presence                | Description                   |
| ----------------- | ------------ | ----------------------- | ----------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | Hash of the governance object |

*Parameter #2---vote signal*

| Name     | Type   | Presence                | Description                                  |
| -------- | ------ | ----------------------- | -------------------------------------------- |
| `signal` | string | Required<br>(exactly 1) | Vote signal: `funding`, `valid`, or `delete` |

*Parameter #3---vote outcome*

| Name      | Type   | Presence                | Description                             |
| --------- | ------ | ----------------------- | --------------------------------------- |
| `outcome` | string | Required<br>(exactly 1) | Vote outcome: `yes`, `no`, or `abstain` |

*Parameter #4---masternode alias*

| Name    | Type   | Presence                | Description                |
| ------- | ------ | ----------------------- | -------------------------- |
| `alias` | string | Required<br>(exactly 1) | Alias of voting masternode |

*Result---votes for specified governance*

| Name                    | Type   | Presence                | Description                               |
| ----------------------- | ------ | ----------------------- | ----------------------------------------- |
| Result                  | object | Required<br>(exactly 1) | The governance object votes               |
| →<br>`overall`          | string | Required<br>(1 or more) | Reports number of vote successes/failures |
| →<br>`detail`           | object | Required<br>(exactly 1) | Vote details                              |
| → →<br>Masternode Alias | object | Required<br>(1 or more) | Name of the masternode alias              |
| → → →<br>`result`       | string | Required<br>(exactly 1) | Vote result                               |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject vote-many \
0bf97bce78b3b642c36d4ca8e9265f8f66de8774c220221f57739c1956413e2b funding yes
```

``` json
{
  "overall": "Voted successfully 1 time(s) and failed 0 time(s).",
  "detail": {
    "MN01": {
      "result": "success"
    }
  }
}
```

*See also:*

* [GetGovernanceInfo](#getgovernanceinfo): returns an object containing governance parameters.
* [GetSuperblockBudget](#getsuperblockbudget): returns the absolute maximum sum of superblock payments allowed.

## Masternode

The [`masternode` RPC](#masternode) provides a set of commands for managing masternodes and displaying information about them.

### Masternode Connect

The [`masternode connect` RPC](#masternode-connect) initiates a connection to a specified masternode address, with optional support for the BIP324 v2 transport protocol.

_Parameter #1---the address of the masternode_

| Name      | Type   | Presence                | Description |
| --------- | ------ | ----------------------- | ----------- |
| address   | string | Required<br>(exactly 1) | The IP address and port of the masternode to connect to (e.g., `192.168.1.100:19999`) |

_Parameter #2---transport protocol options_

| Name         | Type    | Presence             | Description |
| ------------ | ------- | -------------------- | ----------- |
| v2transport  | bool    | Optional<br>(0 or 1) | Set to `true` to attempt connection using the BIP324 v2 transport protocol. Defaults to `false`. |

_Result---connection status_

| Name         | Type    | Presence                | Description |
| ------------ | ------- | ----------------------- | ----------- |
| `result`     | string  | Required<br>(exactly 1) | Command return status |

*Example from Dash Core 22.0.0*

Connect to a masternode at address `192.168.1.100` using the default transport protocol:

```bash
dash-cli masternode connect "192.168.1.100:19999"
```

Result:

```text
successfully connected
```

*See also: none*

### Masternode Count

The `masternode count` RPC prints the number of all known masternodes.

*Parameters: none*

*Result---number of known masternodes*

| Name             | Type   | Presence                | Description                                                            |
| ---------------- | ------ | ----------------------- | ---------------------------------------------------------------------- |
| `result`         | object | Required<br>(exactly 1) | Masternode count by mode                                               |
| →<br>`total`     | int    | Required<br>(exactly 1) | Count of all masternodes                                               |
| →<br>`enabled`   | int    | Required<br>(exactly 1) | Count of enabled masternodes                                           |
| →<br>`detailed`  | object | Required<br>(exactly 1) | *Added in Dash Core 19.0*<br>Breakdown of regular masternodes and evonodes |
| →→<br>`regular`  | object | Required<br>(exactly 1) | Breakdown of regular masternodes                                       |
| →→→<br>`total`   | int    | Required<br>(exactly 1) | Number of total regular masternodes                                    |
| →→→<br>`enabled` | int    | Required<br>(exactly 1) | Number of enabled regular masternodes                                  |
| →→<br>`evo`      | object | Required<br>(exactly 1) | Breakdown of evonodes                                                     |
| →→→<br>`total`   | int    | Required<br>(exactly 1) | Number of total evonodes                                                  |
| →→→<br>`enabled` | int    | Required<br>(exactly 1) | Number of enabled evonodes                                                |

*Example from Dash Core 20.0.0*

``` bash
dash-cli -testnet masternode count
```

Result:

``` bash
{
  "total": 516,
  "enabled": 116,
  "detailed": {
    "regular": {
      "total": 478,
      "enabled": 83
    },
    "evo": {
      "total": 38,
      "enabled": 33
    }
  }
}
```

### Masternode Current

:::{deprecated} 0.17.0
This RPC has been deprecated and will be removed in a future version of Dash Core
:::

The `masternode current` RPC prints info on current masternode winner to be paid the next block (calculated locally).

*Parameters: none*

*Result---current winning masternode info*

| Name             | Type   | Presence                | Description                                             |
| ---------------- | ------ | ----------------------- | ------------------------------------------------------- |
| Result           | object | Required<br>(exactly 1) | Winning masternode info                                 |
| →<br>`height`    | int    | Required<br>(exactly 1) | Block height                                            |
| →<br>`IP:port`   | string | Required<br>(exactly 1) | The IP address/port of the masternode                   |
| →<br>`proTxHash` | string | Required<br>(exactly 1) | The masternode's Provider Registration transaction hash |
| →<br>`outpoint`  | string | Required<br>(exactly 1) | The masternode's outpoint                               |
| →<br>`payee`     | string | Required<br>(exactly 1) | Payee address                                           |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet masternode current
```

Result:

``` json
{
  "height": 76179,
  "IP:port": "34.242.53.163:26155",
  "proTxHash": "9de76b8291d00026ab0af86306023c7b90f8e9229dc04916fe1335bf5e11f15d",
  "outpoint": "9de76b8291d00026ab0af86306023c7b90f8e9229dc04916fe1335bf5e11f15d-1",
  "payee": "yZnU7YJJgGQKvKPQFqXJ4k4DGSsRMhgLXx"
}
```

### Masternode List

The `masternode list` prints a list of all known masternodes.

This RPC uses the same parameters and returns the same data as  
[masternodelist](#masternodelist). Please reference it for full details.

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet masternode list \
 rank f6c83fd96bfaa47887c4587cceadeb9af6238a2c86fe36b883c4d7a6867eab0f
```

Result:

``` json
{
  "f6c83fd96bfaa47887c4587cceadeb9af6238a2c86fe36b883c4d7a6867eab0f-1": 11
}
```

### Masternode Outputs

The `masternode outputs` RPC prints masternode compatible outputs.

*Parameters: none*

*Result---masternode outputs*

| Name        | Type   | Presence                | Description                               |
| ----------- | ------ | ----------------------- | ----------------------------------------- |
| Result      | array  | Required<br>(exactly 1) | Masternode compatible outputs             |
| →<br>Output | string | Required<br>(0 or more) | Masternode compatible output (TXID:Index) |

*Example from Dash Core 18.1.0*

``` bash
dash-cli -testnet masternode outputs
```

Result:

``` json
[
  "f6c83fd96bfaa47887c4587cceadeb9af6238a2c86fe36b883c4d7a6867eab0f-1"
]
```

### Masternode Payments

The `masternode payments` RPC prints an array of deterministic masternodes and their payments for the specified block.

By default, payment information is returned for only the chain tip. More block winners can be requested via the optional `count` parameter.

*Parameter #1---block hash*

| Name       | Type         | Presence                | Description                                   |
| ---------- | ------------ | ----------------------- | --------------------------------------------- |
| Block Hash | string (hex) | Optional<br>(exactly 1) | The hash of the starting block (default: tip) |

*Parameter #2---count*

| Name  | Type         | Presence                | Description                                                                                                                                         |
| ----- | ------------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Count | number (int) | Optional<br>(exactly 1) | The number of blocks to return (default: 1). Will return <count> previous blocks if <count> is negative. Both 1 and -1 correspond to the chain tip. |

.  
*Result---masternode payments*

| Name                | Type             | Presence                | Description                                      |
| :------------------ | :--------------- | :---------------------- | :----------------------------------------------- |
| Result              | array of objects | Required<br>(exactly 1) | List of masternode payment info                  |
| →<br>Block Payment  | object           | Optional<br>(0 or more) | Masternode payment info for a block              |
| →→<br>`height`      | number (int)     | Required<br>(exactly 1) | The height of the block                          |
| →→<br>`blockhash`   | number (int)     | Required<br>(exactly 1) | The hash of the block                            |
| →→<br>`amount`      | number (int)     | Required<br>(exactly 1) | Amount received in this block by all masternodes |
| →→<br>`masternodes` | array of objects | Required<br>(exactly 1) | Masternodes that received payments in this block |
| →→→<br>Masternode   | object           | Required<br>(1 or more) | Masternode info                                  |
| →→→→<br>`proTxHash` | string (hex)     | Required<br>(exactly 1) | The hash of the corresponding ProRegTx           |
| →→→→<br>`amount`    | number (int)     | Required<br>(exactly 1) | Amount received by this masternode               |
| →→→→<br>`payees`    | array of objects | Required<br>(exactly 1) | Payees who received a share of this payment      |
| →→→→→<br>Payee      | objects          | Required<br>(1 or more) | Payee info                                       |
| →→→→→→<br>`address` | string           | Required<br>(1 or more) | Payee address                                    |
| →→→→→→<br>`script`  | string           | Required<br>(exactly 1) | Payee scriptPubKey                               |
| →→→→→→<br>`amount`  | number (int)     | Required<br>(exactly 1) | Amount received by this payee                    |

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet masternode payments
```

Result (block 407822):

``` json
[
  {
    "height": 407822,
    "blockhash": "0000030ae0ca262af12918eac9069e61c481e17ac65a26c87ee44427699c3f3a",
    "amount": 1253571429,
    "masternodes": [
      {
        "proTxHash": "c865b48a09801c61dce5804f28fe994c72577254ea1859cf1c37fe92b428e757",
        "amount": 1253571429,
        "payees": [
          {
            "address": "yP72QU7PMG8wNQVTtaQrCLVKCmbuDeAK91",
            "script": "76a9141e8efb321d5cad77e28e4e6b51546932579d02f588ac",
            "amount": 1253571429
          }
        ]
      }
    ]
  }
]
```

*See also:*

* [Masternode Winner](#masternode-winner): prints info on the next masternode winner to vote for.
* [Masternode Winners](#masternode-winners): prints the list of masternode winners.

### Masternode Status

The `masternode status` RPC prints masternode status information.

*Parameters: none*

*Result---masternode status info*

| Name                           | Type         | Presence                | Description                                                                                                                                                                                       |
| ------------------------------ | ------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Result                         | object       | Required<br>(exactly 1) | Masternode status info                                                                                                                                                                            |
| →<br>`outpoint`                | string       | Required<br>(exactly 1) | The masternode's outpoint                                                                                                                                                                         |
| →<br>`service`                 | string       | Required<br>(exactly 1) | The IP address/port of the masternode                                                                                                                                                             |
| →<br>`proTxHash`               | string (hex) | Optional<br>(0 or 1)    | The masternode's ProRegTx hash                                                                                                                                                                    |
| →<br>`type`                    | string       | Required<br>(exactly 1) | *Added in Dash Core 19.0*<br>The type of masternode                                                                                                                                               |
| →<br>`collateralHash`          | string (hex) | Optional<br>(0 or 1)    | The masternode's collateral hash                                                                                                                                                                  |
| →<br>`collateralIndex`         | int          | Optional<br>(0 or 1)    | Index of the collateral                                                                                                                                                                           |
| →<br>`dmnState`                | object       | Optional<br>(0 or 1)    | Deterministic Masternode State                                                                                                                                                                    |
| → →<br>`version`               | int          | Required<br>(exactly 1) | **Added in Dash Core 19.2.0**<br>The version of the most recent ProRegTx or ProUpRegTx                                                                                                            |
| → →<br>`service`               | string       | Required<br>(exactly 1) | The IP address/port of the masternode                                                                                                                                                             |
| → →<br>`registeredHeight`      | int          | Required<br>(exactly 1) | Block height at which the masternode was registered                                                                                                                                               |
| → →<br>`lastPaidHeight`        | int          | Required<br>(exactly 1) | Block height at which the masternode was last paid                                                                                                                                                |
| → →<br>`PoSePenalty`           | int          | Required<br>(exactly 1) | Current proof-of-service penalty                                                                                                                                                                  |
| → →<br>`PoSeRevivedHeight`     | int          | Required<br>(exactly 1) | Block height at which the masternode was last revived from a PoSe ban                                                                                                                             |
| → →<br>`PoSeBanHeight`         | int          | Required<br>(exactly 1) | Block height at which the masternode was last PoSe banned                                                                                                                                         |
| → →<br>`revocationReason`      | int          | Required<br>(exactly 1) | Reason code for of masternode operator key revocation                                                                                                                                             |
| → →<br>`ownerAddress`          | string       | Required<br>(exactly 1) | The owner address                                                                                                                                                                                 |
| → →<br>`votingAddress`         | string       | Required<br>(exactly 1) | The voting address                                                                                                                                                                                |
| → →<br>`platformNodeId`        | string       | Optional<br>(0 or 1)    | **Added in Dash Core 19.0.0**<br>Platform P2P node ID, derived from P2P public key (evonodes only)                                                                                                |
| → →<br>`platformP2PPort`       | int          | Optional<br>(0 or 1)    | **Added in Dash Core 19.0.0**<br>Platform P2P port (evonodes only)                                                                                                                                |
| → →<br>`platformHTTPPort`      | int          | Optional<br>(0 or 1)    | **Added in Dash Core 19.0.0**<br>TCP port of Platform HTTP/API interface (evonodes only)                                                                                                          |
| → →<br>`payoutAddress`         | string       | Required<br>(exactly 1) | The payout address                                                                                                                                                                                |
| → →<br>`pubKeyOperator`        | string       | Required<br>(exactly 1) | The operator public key                                                                                                                                                                           |
| → →<br>`operatorPayoutAddress` | string       | Optional<br>(0 or 1)    | The operator payout address                                                                                                                                                                       |
| →<br>`state`                   | string       | Required<br>(exactly 1) | The masternode's state. Valid states are:<br>• `WAITING_FOR_PROTX`<br>• `POSE_BANNED`<br>• `REMOVED`<br>• `OPERATOR_KEY_CHANGED`<br>• `PROTX_IP_CHANGED`<br>• `READY`<br>• `ERROR`<br>• `UNKNOWN` |
| →<br>`status`                  | string       | Required<br>(exactly 1) | The masternode's status (description based on current state)                                                                                                                                      |

*Example from Dash Core 19.2.0*

``` bash
dash-cli -testnet masternode status
```

Result:

``` json
{
  "outpoint": "6ce8545e25d4f03aba1527062d9583ae01827c65b234bd979aca5954c6ae3a59-27",
  "service": "34.214.48.68:19999",
  "proTxHash": "9cb04f271ba050132c00cc5838fb69e77bc55b5689f9d2d850dc528935f8145c",
  "type": "HighPerformance",
  "collateralHash": "6ce8545e25d4f03aba1527062d9583ae01827c65b234bd979aca5954c6ae3a59",
  "collateralIndex": 27,
  "dmnState": {
    "version": 2,
    "service": "34.214.48.68:19999",
    "registeredHeight": 850334,
    "lastPaidHeight": 852599,
    "consecutivePayments": 0,
    "PoSePenalty": 0,
    "PoSeRevivedHeight": -1,
    "PoSeBanHeight": -1,
    "revocationReason": 0,
    "ownerAddress": "yeJdYWA1rNSKxxfo7mE2eBUj3ejBGUR6UB",
    "votingAddress": "yeJdYWA1rNSKxxfo7mE2eBUj3ejBGUR6UB",
    "platformNodeID": "62e960a3f6b650feed98a266b3ccdf6e363562cf",
    "platformP2PPort": 36656,
    "platformHTTPPort": 1443,
    "payoutAddress": "yeRZBWYfeNE4yVUHV4ZLs83Ppn9aMRH57A",
    "pubKeyOperator": "b6ee48c7a71a9d8e0813e68ca09846245fa155285f24a62b0ce9cb0102b1994ec58af8ba2a01c09363bdcc395d41f3df"
  },
  "state": "READY",
  "status": "Ready"
}
```

### Masternode Winner

:::{deprecated} 0.17.0
This RPC has been deprecated and will be removed in a future version of Dash Core
:::

The `masternode winner` RPC prints info on the next masternode winner to vote for.

*Parameters: none*

*Result---next masternode winner info*

| Name             | Type   | Presence                | Description                                             |
| ---------------- | ------ | ----------------------- | ------------------------------------------------------- |
| Result           | object | Required<br>(exactly 1) | Winning masternode info                                 |
| →<br>`height`    | int    | Required<br>(exactly 1) | Block height                                            |
| →<br>`IP:port`   | string | Required<br>(exactly 1) | The IP address/port of the masternode                   |
| →<br>`proTxHash` | string | Required<br>(exactly 1) | The masternode's Provider Registration transaction hash |
| →<br>`outpoint`  | string | Required<br>(exactly 1) | The masternode's outpoint                               |
| →<br>`payee`     | string | Required<br>(exactly 1) | Payee address                                           |

*Example from Dash Core 0.14.0*

``` bash
dash-cli -testnet masternode winner
```

Result:

``` json
{
  "height": 76191,
  "IP:port": "34.242.53.163:26173",
  "proTxHash": "024608d03beb6a6065f14a29a837c68ae449ac1e17056819366ca0b72b6dd81f",
  "outpoint": "024608d03beb6a6065f14a29a837c68ae449ac1e17056819366ca0b72b6dd81f-1",
  "payee": "yhp182AnF7gUAyHiWgSbDrKqHKt2dzhoyW"
}
```

*See also:*

* [Masternode Payments](#masternode-payments): prints an array of deterministic masternodes and their payments for the specified block.
* [Masternode Winners](#masternode-winners): prints the list of masternode winners.

### Masternode Winners

The `masternode winners` RPC prints the list of masternode winners.

By default, the 10 previous block winners, the current block winner, and the next 20 block winners are displayed. More past block winners can be requested via the optional `count` parameter.

*Parameter #1---count*

| Name  | Type | Presence                | Description                                               |
| ----- | ---- | ----------------------- | --------------------------------------------------------- |
| Count | int  | Optional<br>(exactly 1) | Number of previous block winners to display (default: 10) |

*Parameter #2---filter*

| Name   | Type   | Presence                | Description                  |
| ------ | ------ | ----------------------- | ---------------------------- |
| Filter | string | Optional<br>(exactly 1) | Payment address to filter by |

*Result---masternode winners*

| Name                   | Type   | Presence                | Description                                                                                                                                   |
| ---------------------- | ------ | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Result                 | object | Required<br>(exactly 1) | Winning masternode info                                                                                                                       |
| →<br>Masternode Winner | int    | Required<br>(exactly 1) | Key: Block height<br>Value: payee address. As of Dash Core 0.17.0, all payees will be listed (e.g. both owner and operator where applicable). |

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet masternode winners
```

Result (current block - 37458):

``` json
{
  "37448": "ygSWwhyzU61FNEta8gDh8gfoH5EZZUvc5m,yP8A3cbdxRtLRduy5mXDsBnJtMzHWs6ZXr",
  "37449": "yjGZLzSSoFfTFgLDJrgniXfYxu3xF9xKQg",
  "37450": "yRTo1wXWoNnPFWcQVepKGXuLsoypnPkGWj",
  "37451": "yYMFRAYZ25XspHZ1EXC39wUMx9FhoC5VT2",
  "37452": "yX5y3otE4LitGYiSfZhVH4LdbwHShdzQ8v",
  "37453": "yX5y3otE4LitGYiSfZhVH4LdbwHShdzQ8v",
  "37454": "yUamtYUFhqUxCMny3JTcZJTyttVt8SYFug",
  "37455": "yU35XcdGMnj8Exa2ZZqCg4ongiNqQwpeUZ",
  "37456": "yaJc6tADbEjxQBAC69ugWNoTFpzxqkcgWd",
  "37457": "yf4WpwRX17p7YRkHJPQpHMXTwzi5s2VDcR",
  "37458": "ydbfUYWfLm6xg7Y5aBLjy38DvksrvNcHEc",
  "37459": "yYp9k2iuDptT2MB7qVZtVy6ModHtLXFjio",
  "37460": "yP1UHNx26ShYLej56SbHiTiPAUv2QppbUv",
  "37461": "yaCtZRpiYnVFMyWELHZF74v9ayLKCLPcC9",
  "37462": "ygYFnLHoVRyhRoxd6fXQ9nmEafX4eLoWkB",
  "37463": "yM5kTThWi8MnAFtZqx98Zipp1BbyypUZGK",
  "37464": "yeDY39aiqbBHbJft5F6rokR23EaZca6UTU",
  "37465": "yMME1ns1xfpGS2XbFPktsNyp7Cjr1BoJxb",
  "37466": "ycn5RWc4Ruo35FTS8bJwugVyCEkfVcrw9a",
  "37467": "yUTDkKKhbvDrnwkiaoP8HvqxTNC6rNnUe2",
  "37468": "yTstes2nSaSpvu9nTapiCGnjCLvLD5fUqt",
  "37469": "Unknown",
  "37470": "Unknown",
  "37471": "Unknown",
  "37472": "Unknown",
  "37473": "Unknown",
  "37474": "Unknown",
  "37475": "Unknown",
  "37476": "Unknown",
  "37477": "Unknown"
}
```

Get a filtered list of masternode winners

``` bash
dash-cli -testnet masternode winners 150 "yTZ99"
```

Result:

``` json
{
  "37338": "yTZ99fCnjNu33RDRtawf81iwJ9uxXFmkgM",
  "37339": "yTZ99fCnjNu33RDRtawf81iwJ9uxXFmkgM",
  "37432": "yTZ99fCnjNu33RDRtawf81iwJ9uxXFmkgM",
  "37433": "yTZ99fCnjNu33RDRtawf81iwJ9uxXFmkgM"
}
```

*See also:*

* [MasternodeList](#masternodelist): returns a list of masternodes in different modes.
* [Masternode Payments](#masternode-payments): prints an array of deterministic masternodes and their payments for the specified block.
* [Masternode Winner](#masternode-winner): prints info on the next masternode winner to vote for.

## Masternodelist

The [`masternodelist` RPC](#masternodelist) returns a list of masternodes in different modes.

*Parameter #1---List mode*

| Name   | Type   | Presence                                          | Description             |
| ------ | ------ | ------------------------------------------------- | ----------------------- |
| `mode` | string | Optional (exactly 1);<br>Required to use `filter` | The mode to run list in |

*Mode Options (Default=json)*

| Mode             | Description                                                                                                        |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ |
| `addr`           | Print IP address associated with a masternode (can be additionally filtered, partial match)                        |
| `recent`         | Print info in JSON format for active and recently banned masternodes (can be additionally filtered, partial match) |
| `full`           | Print info in format 'status payee lastpaidtime lastpaidblock IP' (can be additionally filtered, partial match)    |
| `evo`            | Print info in JSON format for evonodes only. **Added in Dash Core 20.0.0**                                         |
| `info`           | Print info in format 'status payee IP' (can be additionally filtered, partial match)                               |
| `json` (Default) | Print info in JSON format (can be additionally filtered, partial match)                                            |
| `lastpaidblock`  | Print the last block height a node was paid on the network                                                         |
| `lastpaidtime`   | Print the last time a node was paid on the network                                                                 |
| `owneraddress`   | Print the masternode owner Dash address                                                                            |
| `payee`          | Print Dash address associated with a masternode (can be additionally filtered, partial match)                      |
| `pubKeyOperator` | Print the masternode operator public key                                                                           |
| `status`         | Print masternode status: ENABLED / POSE_BANNED (can be additionally filtered, partial match)                       |
| `votingaddress`  | Print the masternode voting Dash address                                                                           |

*Parameter #2---List filter*

| Name     | Type   | Presence                | Description                                                                                                             |
| -------- | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `filter` | string | Optional<br>(exactly 1) | Filter results. Partial match by outpoint by default in all modes, additional matches in some modes are also available. |

*Result---the masternode list*

| Name                 | Type        | Presence                | Description                                                                                   |
| -------------------- | ----------- | ----------------------- | --------------------------------------------------------------------------------------------- |
| `result`             | object/null | Required<br>(exactly 1) | Information about the masternode sync status                                                  |
| →<br>Masternode Info | string      | Required<br>(1 or more) | The requested masternode info. Output varies based on selected `mode` and `filter` parameters |

*Example from Dash Core 20.0.0*

Get unfiltered Masternode list in default mode

``` bash
dash-cli -testnet masternodelist
```

Result (truncated):

``` json
{
  "ab3435c4974cffa8cf6e9a11d9a263c7efad367c4b22fcc75507c565027b51ecb1ba2a1602d9337eb3edb037d7c03b49"
  },
  "482cf74e7a615086514c261a9454db358290f05c6243089a3961ffdf14256d29-0": {
    "proTxHash": "9bc9b7a879c137114fd17b2af5c3825a6f78224cfac8afd7109e52f1b3a05bff",
    "address": "[::]:0",
    "payee": "Xdsbzw7a5wTCQYvCwLuQc7qnRuCcs7ehsK",
    "status": "POSE_BANNED",
    "type": "Regular",
    "pospenaltyscore": 4448,
    "consecutivePayments": 0,
    "lastpaidtime": 1660888856,
    "lastpaidblock": 1723759,
    "owneraddress": "XfJtpuZxEAYUofWKsHA7KNYpCKNxY98Hm3",
    "votingaddress": "Xh6M9FR9a8Wdb7aVvWeF8z9CxBAM9PgDbW",
    "collateraladdress": "Xs1yGUqc53XddB4E9FkHNYXtum5CCoGvbt",
    "pubkeyoperator": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
  },
  "a476f59677f43968ef22c12e250605e42b8ae6d0665fef1354c219ac1e3de82e-0": {
    "proTxHash": "af7b52f2333fbb5605105b3efd094547c2f77d81ca06aa97b784414c4d1efbff",
    "address": "100.24.78.251:9999",
    "payee": "XnpE5Mwr8GsVujK2eWVVJh718Zeap5FHLj",
    "status": "ENABLED",
    "type": "Regular",
    "pospenaltyscore": 0,
    "consecutivePayments": 0,
    "lastpaidtime": 1689823121,
    "lastpaidblock": 1906829,
    "owneraddress": "Xx7xCzbkHJnqbuqBk1zzGeuwopZ9x5UZvu",
    "votingaddress": "XkK53owYVX5Q2t8XPzkR4bzourNzgfkjts",
    "collateraladdress": "Xu2B3bvC75NuiYvudvJPR1npDdguyN7aWV",
    "pubkeyoperator": "8f8097c423ad5bccc3d631bf518a1f28ff60b31841e3c7b0d44e578f94d33b96b9fb485e1690b72608423f3e926ac8c7"
  }
}
```

Get a filtered Masternode list

``` bash
dash-cli -testnet masternodelist full "NEW"
```

Result:

``` json
{
  "cf9840b16f0c28e39beb89e06b995a12425f6a836ed899aa8203a448b31724c6-0": "           ENABLED 0 yP8A3cbdxRtLRduy5mXDsBnJtMzHWs6ZXr 1650381993 708881 52.36.244.225:19999",
  "6f506a5dbb0e88fe83242d4f9641b6f4a2616d22c889b74f29b5bfa6291dfdca-1": "       POSE_BANNED 365 ySLuZnXd8ciZNXV5FEWpqRryT4viJdwazM 1578387987 243103 3.20.70.18:10003",
  "52feab469665752944186952b361815ba53e5296457de6d1bd23baf80db36f0a-0": "           ENABLED 0 yac7gAK3cKuDnYD4RmGaJiMnCssgu7Q7A5 1650385230 708906 54.185.249.226:19999",
  "c44721bf0b5be6de4b7706eaef15c2d500bba148e21947907bd52f77d18bebbd-0": "           ENABLED 0 yP8A3cbdxRtLRduy5mXDsBnJtMzHWs6ZXr 1650397178 708981 34.219.169.55:19999",
  "893d83df0dfc05ac284b96c2b31d4db1d34552f814bd834b8c75f43c56945565-1": "           ENABLED 0 yP8A3cbdxRtLRduy5mXDsBnJtMzHWs6ZXr 1650385930 708913 54.213.219.155:19999",
  "23464abc2f724de235e69e72ef5068f1b2701521b88e7b2740b93978ff54909b-1": "       POSE_BANNED 346 yhDhNgubyF1NEmT6qtiTXTbr3KMiJwUTxk 1555111615  78830 198.199.74.241:19999",
  "d0e28cd51e674fe00af162877cb70e0ceed1906fef616b2d231ef009f6e4786a-0": "           ENABLED 0 yP8A3cbdxRtLRduy5mXDsBnJtMzHWs6ZXr 1650396597 708974 34.220.41.134:19999",
  "213a1c4beb216e8697d8d15701c248bcf91a889f4989fbb4275293b3aa697802-1": "       POSE_BANNED 0 yfzLmLJUEYcC8LEygLB6AQFxCwsF3fV9Fw 1564053511 143062 [::]:0"
}
```

*See also:*

* [Masternode](#masternode): provides a set of commands for managing masternodes and displaying information about them.
* [MnSync](#mnsync): returns the sync status, updates to the next step or resets it entirely.

## MnSync

The [`mnsync` RPC](#mnsync) returns the sync status, updates to the next step or resets it entirely.

*Parameter #1---Command mode*

| Name   | Type   | Presence                | Description                                                                                                                          |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `mode` | string | Required<br>(exactly 1) | The command mode to use:<br>`status` - Get masternode sync status<br>`next` - Move to next sync asset<br>`reset` - Reset sync status |

**Command Mode - `status`**

*Result---the sync status*

| Name                      | Type         | Presence                | Description                                                       |
| ------------------------- | ------------ | ----------------------- | ----------------------------------------------------------------- |
| `result`                  | object/null  | Required<br>(exactly 1) | Information about the masternode sync status                      |
| →<br>`AssetID`            | number (int) | Required<br>(exactly 1) | The sync asset ID                                                 |
| →<br>`AssetName`          | string       | Required<br>(exactly 1) | The sync asset name                                               |
| →<br>`AssetStartTime`     | number (int) | Required<br>(exactly 1) | The sync asset start time                                         |
| →<br>`Attempt`            | number (int) | Required<br>(exactly 1) | The sync attempt number                                           |
| →<br>`IsBlockchainSynced` | boolean      | Required<br>(exactly 1) | Blockchain sync status                                            |
| →<br>`IsSynced`           | boolean      | Required<br>(exactly 1) | Masternode sync status                                            |
| →<br>`IsFailed`           | boolean      | Required<br>(exactly 1) | *Removed in Dash Core 0.16.0*<br>Masternode list sync fail status |

Sync Assets

| AssetID | AssetName                                                                              |
| ------- | -------------------------------------------------------------------------------------- |
| 0       | MASTERNODE_SYNC_INITIAL (merged with `MASTERNODE_SYNC_BLOCKCHAIN` in Dash Core 0.16.0) |
| 1       | MASTERNODE_SYNC_BLOCKCHAIN (previously `MASTERNODE_SYNC_WAITING`)                      |
| 4       | MASTERNODE_SYNC_GOVERNANCE                                                             |
| -1      | MASTERNODE_SYNC_FAILED (removed in Dash Core 0.16.0)                                   |
| 999     | MASTERNODE_SYNC_FINISHED                                                               |

*Example from Dash Core 0.16.0*

Get Masternode sync status

``` bash
dash-cli -testnet mnsync status
```

Result:

``` json
{
  "AssetID": 999,
  "AssetName": "MASTERNODE_SYNC_FINISHED",
  "AssetStartTime": 1507662300,
  "Attempt": 0,
  "IsBlockchainSynced": true,
  "IsSynced": true,
}
```

**Command Mode - `next`**

*Result---next command return status*

| Name     | Type   | Presence                | Description           |
| -------- | ------ | ----------------------- | --------------------- |
| `result` | string | Required<br>(exactly 1) | Command return status |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet mnsync next
```

Result:

```text
sync updated to MASTERNODE_SYNC_GOVERNANCE
```

**Command Mode - `reset`**

*Result---reset command return status*

| Name     | Type   | Presence                | Description                                      |
| -------- | ------ | ----------------------- | ------------------------------------------------ |
| `result` | string | Required<br>(exactly 1) | Command return status:<br>`success` or `failure` |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet mnsync reset
```

Result:

```text
success
```

*See also:*

* [Masternode](#masternode): provides a set of commands for managing masternodes and displaying information about them.
* [MasternodeList](#masternodelist): returns a list of masternodes in different modes.

## Spork

The [`spork` RPC](#spork) shows information about the current state of sporks.

To display the status of sporks, use the `show` or `active` syntax.

*Parameter #1---Command mode*

| Name   | Type   | Presence                | Description                                                                                             |
| ------ | ------ | ----------------------- | ------------------------------------------------------------------------------------------------------- |
| `mode` | string | Required<br>(exactly 1) | The command mode to use:<br>`show` - Display spork values<br>`active` - Display spork activation status |

**Command Mode - `show`**

*Result---spork values*

| Name               | Type    | Presence                | Description                                    |
| ------------------ | ------- | ----------------------- | ---------------------------------------------- |
| `result`           | object  | Required<br>(exactly 1) | Object containing status                       |
| →<br>`Spork Value` | int64_t | Required<br>(1 or more) | Spork value (epoch datetime to enable/disable) |

*Example from Dash Core 18.1.0*

``` bash
dash-cli -testnet spork show
```

Result:

``` json
{
  "SPORK_2_INSTANTSEND_ENABLED": 0,
  "SPORK_3_INSTANTSEND_BLOCK_FILTERING": 0,
  "SPORK_9_SUPERBLOCKS_ENABLED": 0,
  "SPORK_17_QUORUM_DKG_ENABLED": 0,
  "SPORK_19_CHAINLOCKS_ENABLED": 0,
  "SPORK_21_QUORUM_ALL_CONNECTED": 1,
  "SPORK_23_QUORUM_POSE": 0
}
```

**Command Mode - `active`**

*Result---spork active status*

| Name                           | Type   | Presence                | Description              |
| ------------------------------ | ------ | ----------------------- | ------------------------ |
| `result`                       | object | Required<br>(exactly 1) | Object containing status |
| →<br>`Spork Activation Status` | bool   | Required<br>(1 or more) | Spork activation status  |

*Example from Dash Core 18.1.0*

``` bash
dash-cli -testnet spork active
```

Result:

``` json
{
  "SPORK_2_INSTANTSEND_ENABLED": true,
  "SPORK_3_INSTANTSEND_BLOCK_FILTERING": true,
  "SPORK_9_SUPERBLOCKS_ENABLED": true,
  "SPORK_17_QUORUM_DKG_ENABLED": true,
  "SPORK_19_CHAINLOCKS_ENABLED": true,
  "SPORK_21_QUORUM_ALL_CONNECTED": true,
  "SPORK_23_QUORUM_POSE": true
}
```

*See also:*

* [Sporkupdate](#sporkupdate): updates the value of the provided spork.

## Sporkupdate

The [`sporkupdate` RPC](#sporkupdate) updates the value of the provided spork.

:::{note}
Signing spork update messages requires `-sporkkey` to be set via the command line or dash.conf file.
:::

To update the state of a spork activation, use the `<name> [value]` syntax.

*Parameter #1---Spork name*

| Name   | Type   | Presence                | Description                     |
| ------ | ------ | ----------------------- | ------------------------------- |
| `name` | string | Required<br>(exactly 1) | The name of the spork to update |

*Parameter #2---Spork value*

| Name    | Type | Presence                | Description                   |
| ------- | ---- | ----------------------- | ----------------------------- |
| `value` | int  | Required<br>(exactly 1) | The value to assign the spork |

*Result---spork update status*

| Name     | Type   | Presence                | Description                         |
| -------- | ------ | ----------------------- | ----------------------------------- |
| `result` | string | Required<br>(exactly 1) | Update status (`success` or `null`) |

*Example from Dash Core 18.1.0*

``` bash
dash-cli -testnet spork SPORK_2_INSTANTSEND_ENABLED 0
```

Result:

``` bash
null
```

*See also:*

* [Spork](#spork): shows information about the current state of sporks.

## VoteRaw

The [`voteraw` RPC](#voteraw) compiles and relays a governance vote with provided external signature instead of signing vote internally

*Parameter #1---masternode collateral transaction hash*

| Name                            | Type         | Presence                | Description                                   |
| ------------------------------- | ------------ | ----------------------- | --------------------------------------------- |
| `masternode-collateral-tx-hash` | string (hex) | Required<br>(exactly 1) | Hash of the masternode collateral transaction |

*Parameter #2---masternode collateral transaction index*

| Name                             | Type   | Presence                | Description                                    |
| -------------------------------- | ------ | ----------------------- | ---------------------------------------------- |
| `masternode-collateral-tx-index` | string | Required<br>(exactly 1) | Index of the masternode collateral transaction |

*Parameter #3---governance hash*

| Name              | Type         | Presence                | Description                   |
| ----------------- | ------------ | ----------------------- | ----------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | Hash of the governance object |

*Parameter #4---vote signal*

| Name     | Type   | Presence                | Description                                  |
| -------- | ------ | ----------------------- | -------------------------------------------- |
| `signal` | string | Required<br>(exactly 1) | Vote signal: `funding`, `valid`, or `delete` |

*Parameter #5---vote outcome*

| Name      | Type   | Presence                | Description                             |
| --------- | ------ | ----------------------- | --------------------------------------- |
| `outcome` | string | Required<br>(exactly 1) | Vote outcome: `yes`, `no`, or `abstain` |

*Parameter #6---time*

| Name   | Type    | Presence                | Description |
| ------ | ------- | ----------------------- | ----------- |
| `time` | int64_t | Required<br>(exactly 1) | Create time |

*Parameter #7---vote signature*

| Name       | Type            | Presence                | Description                                                                                                                                                                                                                                                                                                                                               |
| ---------- | --------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vote-sig` | string (base64) | Required<br>(exactly 1) | The vote signature created by external application (i.e. [Dash Masternode Tool](https://github.com/Bertrand256/dash-masternode-tool) or [dashmnb](https://github.com/chaeplin/dashmnb)).<br><br>Must match the Dash Core ([governance vote signature format](https://github.com/dashpay/dash/blob/v0.15.x/src/governance/governance-vote.cpp#L180-L181)). |

*Result---votes for specified governance*

Name | Type | Presence | Description
--- | --- | --- | ---
Result | object | Required<br>(exactly 1) | The vote result

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet voteraw \
f6c83fd96bfaa47887c4587cceadeb9af6238a2c86fe36b883c4d7a6867eab0f 1 \
65a358fefaace40fc07053350be23e519178519290f963dab8ba92f6f85f98c3 \
funding yes 1512507255 \
H1jXKZQp1TZWBPW11E665OwmGBYV1038FohEr0au7zp+O5BCKmVDP/3rGq38ZMy3KOpwnBu6ehd6jlas79hsRBY=
```

Result:

``` bash
Voted successfully
```

*See also:*

* [GObject](#gobject): provides a set of commands for managing governance objects and displaying information about them.
