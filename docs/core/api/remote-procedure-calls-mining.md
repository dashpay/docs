```{eval-rst}
.. meta::
  :title: Mining RPCs
  :description: A list of remote procedure calls for mining in Dash.
```

# Mining RPCs

## GetBlockTemplate

The [`getblocktemplate` RPC](../api/remote-procedure-calls-mining.md#getblocktemplate) gets a block template or proposal for use with mining software. For more
information, please see the following resources:

* [Bitcoin Wiki GetBlockTemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [BIP22](https://github.com/bitcoin/bips/blob/master/bip-0022.mediawiki)
* [BIP23](https://github.com/bitcoin/bips/blob/master/bip-0023.mediawiki)

*Parameter #1---a JSON request object*

Name | Type | Presence | Description
--- | --- | --- | ---
Request | object | Optional<br>(exactly 1) | A JSON request object
→<br>`mode` | string | Optional<br>(exactly 1) | This must be set to \template\" or omitted"
→<br>`capabilities` | array (string) | Optional<br>(0 or more) | A list of strings
→ →<br>Capability | string | Optional<br>(exactly 1) | Client side supported feature, `longpoll`, `coinbasetxn`, `coinbasevalue`, `proposal`, `serverlist`, `workid`
→<br>`rules` | array (string) | Optional<br>(0 or more) | A list of strings
→ →<br>Rules | string | Optional<br>(exactly 1) | Client side supported softfork deployment, `csv`, `dip0001`, etc.

*Result---block template*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing a block template
→<br>`capabilities` | array (string) | Required<br>(1 or more) | The client side supported features
→ →<br>Capability | string | Optional<br>(0 or more) | A client side supported feature
→<br>`version` | number (int) | Required<br>(exactly 1) | The block version
→<br>`rules` | array (string) | Required<br>(1 or more) | The specific block rules that are to be enforced
→ →<br>Block Rule | string | Optional<br>(0 or more) | A specific block rule to be enforced
→<br>`vbavailable` | object | Required<br>(exactly 1) | Contains the set of pending, supported versionbit (BIP 9) softfork deployments
→ →<br>Bit Number | number | Required<br>(0 or more) | The bit number the named softfork rule
→<br>`vbrequired` | number | Required<br>(exactly 1) | The bit mask of versionbits the server requires set in submissions
→<br>`previousblockhash` | string (hex) | Required<br>(exactly 1) | The hash of current highest block
→<br>`transactions` | array (objects) | Optional<br>(0 or more) | Non-coinbase transactions to be included in the next block
→ →<br>Transaction | object | Optional<br>(0 or more) | Non-coinbase transaction
→ → →<br>`data` | string (hex) | Optional<br>(0 or more) | Transaction data encoded in hex (byte-for-byte)
→ → →<br>`txid` | string (hex) | Optional<br>(0 or more) | Transaction ID encoded in little-endian hexadecimal |
→ → →<br>`hash` | string (hex) | Optional<br>(0 or more) | The hash/id encoded in little-endian hex
→ → →<br>`depends` | array (numbers) | Required<br>(0 or more) | An array holding TXIDs of unconfirmed transactions this TX depends upon (parent transactions).
→ → → →<br>Transaction number | number | Optional<br>(1 or more) | Transactions before this one (by 1-based index in `transactions` list) that must be present in the final block if this one is
→ → →<br>`fee` | number | Required<br>(exactly 1) | The difference in value between transaction inputs and outputs (in duffs). For coinbase transactions, this is a negative number of the total collected block fees (ie., not including the block subsidy); if key is not present, fee is unknown and clients MUST NOT assume there isn't one
→ → →<br>`sigops` | number | Required<br>(exactly 1) | Total SigOps. If not present, the count is unknown (clients MUST NOT assume there aren't any)
→<br>`coinbaseaux` | object | Required<br>(exactly 1) | A object containing data that should be included in the coinbase scriptSig content
→<br>`coinbasevalue` | number | Required<br>(exactly 1) | The maximum allowable input to coinbase transaction, including the generation award and transaction fees (in duffs)
→<br>`coinbasetxn` | object | Required<br>(exactly 1) | **Removed in Dash Core 20.0.0**
`longpollid` | string | Required<br>(exactly 1) | An ID to include with a request to longpoll on an update to this template
→<br>`target` | string | Required<br>(exactly 1) | The hash target
→<br>`mintime` | number | Required<br>(exactly 1) | The minimum timestamp appropriate for next block time in seconds since epoch
→<br>`mutable` | array (string) | Required<br>(exactly 1) | The list of ways the block template may be changed
→ →<br>Value | string | Required<br>(0 or more) | A way the block template may be changed, e.g. 'time', 'transactions', 'prevblock'
→<br>`noncerange` | string | Required<br>(exactly 1) | A range of valid nonces
→<br>`sigoplimit` | number | Required<br>(exactly 1) | The limit of sigops in blocks
→<br>`sizelimit` | number | Required<br>(exactly 1) | The limit of block size
→<br>`curtime` | number | Required<br>(exactly 1) | The current timestamp in seconds since epoch
→<br>`bits` | string | Required<br>(exactly 1) | The compressed target of next block
→<br>`previousbits` | string | Required<br>(exactly 1) | The compressed target of  the current highest block
→<br>`height` | number | Required<br>(exactly 1) | The height of the next block
→<br>`masternode` | array (objects) | Required<br>(0 or more) | Required masternode payments that must be included in the next block
→ →<br>Masternode Payee | object | Optional<br>(0 or more) | Object containing a masternode payee's information  
→ → →<br>`payee` | string | Required<br>(exactly 1) | Payee address
→ → →<br>`script` | string | Required<br>(exactly 1) | Payee scriptPubKey
→ → →<br>`amount` | number | Required<br>(exactly 1) | Required amount to pay
→<br>`masternode_payments_started` | boolean | Required<br>(exactly 1) | True if masternode payments started
→<br>`masternode_payments_enforced` | boolean | Required<br>(exactly 1) | True if masternode payments enforced
→<br>`superblock` | array (objects) | Required<br>(0 or more) | The superblock payees that must be included in the next block
→ →<br>Superblock Payee | object | Optional<br>(0 or more) | Object containing a superblock payee's information
→ → →<br>`payee` | string | Required<br>(exactly 1) | Payee address
→ → →<br>`script` | string | Required<br>(exactly 1) | Payee scriptPubKey
→ → →<br>`amount` | number | Required<br>(exactly 1) | Required amount to pay
→<br>`superblocks_started` | boolean | Required<br>(exactly 1) | True if superblock payments started
→<br>`superblocks_enabled` | boolean | Required<br>(exactly 1) | True if superblock payments enabled
→<br>`coinbase_payload` | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.13.0*<br><br>Coinbase transaction payload data encoded in hexadecimal

*Example from Dash Core 20.0.0*

```bash
dash-cli -testnet getblocktemplate
```

Result:

```json
{
  "capabilities": [
    "proposal"
  ],
  "version": 536870912,
  "rules": [
    "v20",
    "mn_rr"
  ],
  "vbavailable": {
  },
  "vbrequired": 0,
  "previousblockhash": "000000487e77ca7d979fcb607e8967295f2b1dd8ddb2785d813b0ed6344f149a",
  "transactions": [
    {
      "data": "03000600000000000000fd49010100a3ff0d000300016b9e6f55fe33d217feaf77efdd4db8e662d323f6aa09fffd66a147e4da00000032ffffffffffff0332ffffffffffff03a99c278110c807da5a9bc9c8398a8ea7d65daa9d18c28c4c9169bd72b7711dafee8a064d78d88b6ae0cfd5c480d17253abfdad7415814e6c5fa2f61e70aa84a4ac25509eb033e578da15395eb61df03888f8ff5ec987254b59a01cf37b85097d29f1095f0f6a3c52583713e6578e8d24a93c3db9bc5deb55af5ea3e506e0beff0a4dc244dd9a0160381e79d4342489cac1603146b5e30b71f0c84ffa294e5cda75255a1a82ba2454351079a91fec876f8d4efad0f8ab1e9e7ee3302dd07717d32fdf4ab7f29e0ab8edf2d788c95d56c8790d6b4a84a13b2554ca6b1f9b0102ae178ab088189e8fa898268e135823514df4cec08ddb62032ec74b80a69b93bbe59e0624fac442ccc539083151be200384",
      "hash": "9b9f02cb05d3d323b503561608c9ca383a45ef57fb6ebd84ae0d81a653e30003",
      "depends": [
      ],
      "fee": 0,
      "sigops": 0
    },
    {
      "data": "03000600000000000000fd55010100a3ff0d000300046b9e6f55fe33d217feaf77efdd4db8e662d323f6aa09fffd66a147e4da00000064ffffffffffffffffffffffff0f64ffffffffffffffffffffffff0fa4c2c8b9a873a223fc84037d24e9d76dcf0ac8105d3cabbf84a5cd901a2f5369a7dc61cbc18085cc0c2f4c67b1805cfec4c3b4f89ea09f922fbbeb42f9a82bce64276174eacd9d20ddc0ff33931b14d291cd520a372176a2d28376381f5d36b77f48031d464897f18ff82438bdb38489986e0d5794e4da6503d13ae33115f62e19d94da430f06b44f9d7e6512d68783662295b96f72430b06e218a31d10fe9ef43e17c5840b67fe548bce240e0d6e02da3a0f718da47554ce3e364bafd16ec01544a7e5720d39202e7763ee03ade630cd9724dce36957a90ac4798180e0dec700270162bf8f5b4533ef34ef47b96494e6eb096d4d259b0df9f5572c368b805deaed36574c0d1aee286583b1dda06f1a5",
      "hash": "3409f455c1584155833227b171d83840de662dd33e216ede9b82d933bfcc2151",
      "depends": [
      ],
      "fee": 0,
      "sigops": 0
    },
    {
      "data": "03000600000000000000fd43010100a3ff0d000300066b9e6f55fe33d217feaf77efdd4db8e662d323f6aa09fffd66a147e4da00000019ffffff0119ffffff01a8c52eaf171fc29d25ecec2dd5fd3aded2f3e8c3f7721f4b9985025810fdb05444e797bed5a4cc0031f59138a14607a022179768c089b96a77e838857bbf03e7dd36002b029c7bafdce7ac4f4738d7548c23f27038f56c8795fc128b5e75059b9644047fa2c144f90388c45b998a6c19c7c0490d06c9c2e61fb24b8c609fada613b8c0de59d7d8aa355d4135b8dd64572b55cc4c9fb49a8dff515536cce91cb1a3c5dc5340e0806069ace3b5f2168af68e34a2e9cf1ffa43c00191ff5c06aa54706b64f41353efb845f251cf81c693a0db7a1996b3d42a12860ec53127f3c3a3052577467a257a4a6c0a9e60ec854648265d3de3ad57c97ad8f312d734f52789c7f48bf7d06c062a35c2def5b1d45c6a",
      "hash": "5715b73cdc829e71688d8974338cd96273b913a37ab4d03fabb027a770c83af6",
      "depends": [
      ],
      "fee": 0,
      "sigops": 0
    }
  ],
  "coinbaseaux": {
  },
  "coinbasevalue": 1672799096,
  "longpollid": "000000487e77ca7d979fcb607e8967295f2b1dd8ddb2785d813b0ed6344f149a156",
  "target": "0000012a59000000000000000000000000000000000000000000000000000000",
  "mintime": 1696363840,
  "mutable": [
    "time",
    "transactions",
    "prevblock"
  ],
  "noncerange": "00000000ffffffff",
  "sigoplimit": 40000,
  "sizelimit": 2000000,
  "curtime": 1696364934,
  "bits": "1e012a59",
  "previousbits": "1e012b17",
  "height": 917411,
  "masternode": [
    {
      "payee": "",
      "script": "6a",
      "amount": 376379796
    },
    {
      "payee": "yeRZBWYfeNE4yVUHV4ZLs83Ppn9aMRH57A",
      "script": "76a914c69a0bda7daaae481be8def95e5f347a1d00a4b488ac",
      "amount": 627299661
    }
  ],
  "masternode_payments_started": true,
  "masternode_payments_enforced": true,
  "superblock": [
  ],
  "superblocks_started": true,
  "superblocks_enabled": true,
  "coinbase_payload": "0300a3ff0d00739f69d98c43d95c201a42cae33abd9762429c6b598c5989cd4c0c0bf81a3a82c6d6e2c75f57c6d4e222461391b28cecfa399b5bfc6033613e5dc7f50e69e5f40081a244f815e87d92734728e5e0278c5b833e2ac0f6d1e5b47f83d7e8ce95f0b3da533feb1955472e29972e7f810e285519cb50648d2e9ca5ea442b56ae3da48b0fee25c99e67a9e1b63df38640a7cecfe80955f59b260aa384b64d5202feba3316298c85b8050000"
}
```

*See also*

* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.
* [SubmitBlock](../api/remote-procedure-calls-mining.md#submitblock): accepts a block, verifies it is a valid addition to the block chain, and broadcasts it to the network. Extra parameters are ignored by Dash Core but may be used by mining pools or other programs.
* [PrioritiseTransaction](../api/remote-procedure-calls-mining.md#prioritisetransaction): adds virtual priority or fee to a transaction, allowing it to be accepted into blocks mined by this node (or miners which use this node) with a lower priority or fee. (It can also remove virtual priority or fee, requiring the transaction have a higher priority or fee to be accepted into a locally-mined block.)

## GetMiningInfo

The [`getmininginfo` RPC](../api/remote-procedure-calls-mining.md#getmininginfo) returns various mining-related information.

*Parameters: none*

*Result---various mining-related information*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | Various mining-related information
→<br>`blocks` | number (int) | Required<br>(exactly 1) | The height of the highest block on the local best block chain
→<br>`currentblocksize` | number (int) | Optional<br>(0 or 1) | If generation was enabled since the last time this node was restarted, this is the size in bytes of the last block built by this node for header hash checking.
→<br>`currentblocktx` | number (int) | Optional<br>(0 or 1) | If generation was enabled since the last time this node was restarted, this is the number of transactions in the last block built by this node for header hash checking.
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | If generation was enabled since the last time this node was restarted, this is the difficulty of the highest-height block in the local best block chain.  Otherwise, this is the value `0`
→<br>`networkhashps` | number (int) | Required<br>(exactly 1) | An estimate of the number of hashes per second the network is generating to maintain the current difficulty.  See the [`getnetworkhashps` RPC](../api/remote-procedure-calls-mining.md#getnetworkhashps) for configurable access to this data
→<br>`pooledtx` | number (int) | Required<br>(exactly 1) | The number of transactions in the memory pool
→<br>`chain` | string | Required<br>(exactly 1) | Set to `main` for mainnet, `test` for testnet, and `regtest` for regtest
→<br>`warnings` | string | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Any network or blockchain warnings
→<br>`errors` | string | Optional<br>(0 or 1) | **Removed in Dash Core 0.17.0**<br><br>Only shown when dashd is started with `-deprecatedrpc=getmininginfo`

*Example from Dash Core 18.0.0*

```bash
dash-cli getmininginfo
```

Result:

```json
{
  "blocks": 292979,
  "difficulty": 0.0002441371325370145,
  "networkhashps": 3805.856874962192,
  "pooledtx": 0,
  "chain": "test",
  "warnings": "Warning: unknown new rules activated (versionbit 3)"
}
```

*See also*

* [GetMemPoolInfo](../api/remote-procedure-calls-blockchain.md#getmempoolinfo): returns information about the node's current transaction memory pool.
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.
* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software.

## GetNetworkHashPS

The [`getnetworkhashps` RPC](../api/remote-procedure-calls-mining.md#getnetworkhashps) returns the estimated network hashes per second based on the last n blocks.

*Parameter #1---number of blocks to average*

Name | Type | Presence | Description
--- | --- | --- | ---
`blocks` | number (int) | Optional<br>(0 or 1) | The number of blocks to average together for calculating the estimated hashes per second.  Default is `120`.  Use `-1` to average all blocks produced since the last difficulty change

*Parameter #2---block height*

Name | Type | Presence | Description
--- | --- | --- | ---
`height` | number (int) | Optional<br>(0 or 1) | The height of the last block to use for calculating the average.  Defaults to `-1` for the highest-height block on the local best block chain.  If the specified height is higher than the highest block on the local best block chain, it will be interpreted the same as `-1`

*Result---estimated hashes per second*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | number (int) | Required<br>(exactly 1) | The estimated number of hashes per second based on the parameters provided.  May be 0 (for Height=`0`, the genesis block) or a negative value if the highest-height block averaged has a block header time earlier than the lowest-height block averaged

*Example from Dash Core 0.12.2*

Get the average hashes per second for all the blocks since the last
difficulty change before block 6000.

```bash
dash-cli -testnet getnetworkhashps -1 6000
```

Result:

```text
22214011.90821117
```

*See also*

* [GetDifficulty](../api/remote-procedure-calls-blockchain.md#getdifficulty): returns the proof-of-work difficulty as a multiple of the minimum difficulty.
* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.

## PrioritiseTransaction

The [`prioritisetransaction` RPC](../api/remote-procedure-calls-mining.md#prioritisetransaction) adds virtual priority or fee to a transaction, allowing it to be accepted into blocks mined by this node (or miners which use this node) with a lower priority or fee. (It can also remove virtual priority or fee, requiring the transaction have a higher priority or fee to be accepted into a locally-mined block.)

*Parameter #1---the TXID of the transaction to modify*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string | Required<br>(exactly 1) | The TXID of the transaction whose virtual priority or fee you want to modify, encoded as hex in RPC byte order

*Parameter #2---the change to make to the virtual fee*

Name | Type | Presence | Description
--- | --- | --- | ---
Fee | number (int) | Required<br>(exactly 1) | **Warning:** this value is in duffs, not Dash<br><br>If positive, the virtual fee to add to the actual fee paid by the transaction; if negative, the virtual fee to subtract from the actual fee paid by the transaction.  No change is made to the actual fee paid by the transaction

*Result---`true` if the priority is changed*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | bool (true only) | Required<br>(exactly 1) | Always set to `true` if all three parameters are provided.  Will not return an error if the TXID is not in the memory pool.  If fewer or more than three arguments are provided, or if something goes wrong, will be set to `null`

*Example from Dash Core 0.14.0*

```bash
dash-cli -testnet prioritisetransaction \
    f86c74f27fdd9c7e618d69b3606eeae1710b3f02fabede6ae8c88dd7bb756942 \
    456789
```

Result:

```json
true
```

*See also*

* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.
* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software.

## SubmitBlock

The [`submitblock` RPC](../api/remote-procedure-calls-mining.md#submitblock) accepts a block, verifies it is a valid addition to the block chain, and broadcasts it to the network. Extra parameters are ignored by Dash Core but may be used by mining pools or other programs.

*Parameter #1---the new block in serialized block format as hex*

Name | Type | Presence | Description
--- | --- | --- | ---
Block | string (hex) | Required<br>(exactly 1) | The full block to submit in serialized block format as hex

*Parameter #2---dummy value*

Name | Type | Presence | Description
--- | --- | --- | ---
`dummy` | object | Optional<br>(0 or 1) | A dummy value for compatibility with BIP22. This value is ignored.

*Result---`null` or error string*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | null/string | Required<br>(exactly 1) | If the block submission succeeded, set to JSON `null`.  If submission failed, set to one of the following strings: `duplicate`, `duplicate-invalid`, `inconclusive`, or `rejected`.  The JSON-RPC `error` field will still be set to `null` if submission failed for one of these reasons

*Example from Dash Core 0.15.0*

Submit the following block with the a dummy value, "test".

```bash
dash-cli -testnet submitblock 0100002032e3965d5fdd7a883209d516599337eb4cb82f\
  7aea22ecc114942c1f00000000244388a3bd2c38a85bf337755a1a165d0df2b335e3886058\
  40e08a3cdf1ce1a4297ede598f6a011d027c1c300201000000010000000000000000000000\
  000000000000000000000000000000000000000000ffffffff1202791f0e2f5032506f6f6c\
  2d74444153482fffffffff044d75bb8b010000001976a914d4a5ea2641e9dd37f7a5ad5c92\
  9df4743518769188acac2ea68f010000001976a9148d0934de58f969df3b53a72b4f47211d\
  890ebf5588ac68b9ea03000000004341047559d13c3f81b1fadbd8dd03e4b5a1c73b05e2b9\
  80e00d467aa9440b29c7de23664dde6428d75cafed22ae4f0d302e26c5c5a5dd4d3e1b796d\
  7281bdc9430f35ac00000000000000002a6a28f47e935509fc85533dc78197e93e87d1c793\
  43bda495429d8e3680069f6a22780000000002000000000000000100000001078e0c77e3b0\
  4323d0834841f965543aaae2b275f684f55fbaf22e1c83bff97e010000006a473044022077\
  6e96d202cc4f50f79d269d7cd36712c7486282dda0cb6eae583c916c98b34c022070941efb\
  3201cf500cc6b879d6570fc477d4c3e6a8d91286e84465235f542c42012102dddbfc3fe06b\
  96e3a36f3e815222cd1cb9586b3193c4a0de030477f621956d51feffffff02a00bd1000000\
  00001976a914d7b47d4b40a23c389f5a17754d7f60f511c7d0ec88ac316168821300000019\
  76a914c9190e507834b78a624d7578f1ad3819592ca1aa88ac771f0000 \
  "test"
```

Result (the block above was already on a local block chain):

```text
duplicate
```

*See also*

* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software.

## SubmitHeader

The [`submitheader` RPC](../api/remote-procedure-calls-mining.md#submitheader) decodes the given hexdata as a header and submits it as a candidate chain tip if valid.
If invalid, it  throws.

*Parameter #1---hexdata*

Name | Type | Presence | Description
--- | --- | --- | ---
hexdata | string (hex) | Required<br>(exactly 1) | The block header data

*Result---`None`*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | None | Not Required<br> | N/A

*Example from Dash Core 18.0.0*

```bash
dash-cli -testnet submitheader 0000002037f7981be497c71524bb9f7454d80b1448f46b6f99c3cadfee4367f0c201000007a95ed6e4d19efa99f33c93b45ee2eab5b5a0ef230ac9c03ecc8a3b5ef8938f5b1978614745021ed6cb0000
```

Result:

```text
null
```

*See also: none*
