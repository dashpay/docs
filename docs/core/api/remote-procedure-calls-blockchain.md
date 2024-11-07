```{eval-rst}
.. meta::
  :title: Blockchain RPCs
  :description: A list of all the Blockchain RPCs in Dash.
```

# Blockchain RPCs

## GetBestBlockHash

The [`getbestblockhash` RPC](../api/remote-procedure-calls-blockchain.md#getbestblockhash) returns the header hash of the most recent block on the best blockchain.

*Parameters: none*

*Result---hash of the tip from the best block chain*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex) | Required<br>(exactly 1) | The hash of the block header from the most recent block on the best block chain, encoded as hex in RPC byte order

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getbestblockhash
```

Result:

``` text
00000bafbc94add76cb75e2ec92894837288a481e5c005f6563d91623bf8bc2c
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.

## DumpTxOutset

Write the serialized UTXO set to disk.

*Parameter #1---path to output file*

Name | Type | Presence | Description
--- | --- | --- | ---
path | string (hex) | Required<br>(exactly 1) | Path to the output file. If relative, will be prefixed by datadir.

*Result*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred
→<br>`coins_written` | number (int) | Required<br>(exactly 1) | the number of coins written in the snapshot
→<br>`base_hash` | string (hex) | Required<br>(exactly 1) | the hash of the base of the snapshot
→<br>`base_height` | number (int) | Required<br>(exactly 1) | the height of the base of the snapshot
→<br>`path` | string (str) | Required<br>(exactly 1) | the absolute path that the snapshot was written to

*Example from Dash Core 18.1.0*

> dash-cli dumptxoutset a

Result:

``` json
{
  "coins_written": 4313775,
  "base_hash": "000000000000000ef8f6b8f9b73ae4c516b961b7bbc01945b48d84b954ae68a1",
  "base_height": 1412676,
  "path": "/Users/username/Library/Application Support/DashCore/a"
}
```

## GetBestChainLock

The [`getbestchainlock` RPC](../api/remote-procedure-calls-blockchain.md#getbestchainlock) returns the information about the best ChainLock.

Throws an error if there is no known ChainLock yet.

*Parameters: none*

*Result*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred
→<br>`blockhash` | string (hex) | Required<br>(exactly 1) | The hash of the block encoded as hex in RPC byte order
→<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→<br>`signature` | string (hex) | Required<br>(exactly 1) | The BLS signature of the ChainLock
→<br>`known_block` | boolean | Required<br>(exactly 1) | True if the block is known by this node

*Example from Dash Core 0.17.0*

``` bash
dash-cli -testnet getbestchainlock
```

Result:

``` json
{
  "blockhash": "00000c0e7a866e67444813858b976886d839aff28f56dc178c92ed1390c97f4e",
  "height": 405044,
  "signature": "960ead08adcc3fcf5e576f9e6ad290251325db900d19d961f5ece398b5389390b8a44e8986199c201ac348a89bc8534a0f7153c61c54157a241c521131025e5054b7c4298065069e478abdaea4d6c861848061e32c0d903ddeb5ee6036e8ddcf",
  "known_block": true
}
```

*See also: none*

```{eval-rst}
.. _api-rpc-blockchain-getblock:
```

## GetBlock

The [`getblock` RPC](../api/remote-procedure-calls-blockchain.md#getblock) gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.

*Parameter #1---block hash*

Name | Type | Presence | Description
--- | --- | --- | ---
Block Hash | string (hex) | Required<br>(exactly 1) | The hash of the header of the block to get, encoded as hex in RPC byte order

*Parameter #2---whether to get JSON or hex output*

Name | Type | Presence | Description
--- | --- | --- | ---
Verbosity | number (int) | Optional<br>(0 or 1) | Set to one of the following verbosity levels:<br>• `0` - Get the block as a string in the hex-encoded serialized block format;<br>• `1` - Get the decoded block as a JSON object (default)<br>• `2` - Get the decoded block as a JSON object with transaction details

*Result (if verbosity was `0`)---a serialized block*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex)/null | Required<br>(exactly 1) | The requested block as a serialized block, encoded as hex, or JSON `null` if an error occurred

*Result (if verbosity was `1` or omitted)---a JSON block with transaction hashes*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred
→<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of this block's block header encoded as hex in RPC byte order.  This is the same as the hash provided in parameter #1
→<br>`confirmations` | number (int) | Required<br>(exactly 1) | The number of confirmations the transactions in this block have, starting at 1 when this block is at the tip of the best block chain.  This score will be -1 if the the block is not part of the best block chain
→<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→<br>`version` | number (int) | Required<br>(exactly 1) | This block's version number.  See [block version numbers](../reference/block-chain-block-headers.md#block-versions)
→<br>`versionHex` | string (hex) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.13.0*<br><br>The block version formatted in hexadecimal
→<br>`merkleroot` | string (hex) | Required<br>(exactly 1) | The merkle root for this block, encoded as hex in RPC byte order
→<br>`time` | number (int) | Required<br>(exactly 1) | The value of the *time* field in the block header, indicating approximately when the block was created
→<br>`mediantime` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The median block time in Unix epoch time  
→<br>`nonce` | number (int) | Required<br>(exactly 1) | The nonce which was successful at turning this particular block into one that could be added to the best block chain
→<br>`bits` | string (hex) | Required<br>(exactly 1) | The value of the *nBits* field in the block header, indicating the target threshold this block's header had to pass
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | The estimated amount of work done to find this block relative to the estimated amount of work done to find block 0
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes miners had to check from the genesis block to this block, encoded as big-endian hex
→<br>`nTx` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>The number of transactions in the block
→<br>`previousblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the header of the previous block, encoded as hex in RPC byte order.  Not returned for genesis block
→<br>`nextblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the next block on the best block chain, if known, encoded as hex in RPC byte order
→<br>`chainlock` | bool | Required<br>(exactly 1) | *Added in Dash Core 0.14.0*<br><br>If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org)
→<br>`size` | number (int) | Required<br>(exactly 1) | The size of this block in serialized block format, counted in bytes
→<br>`tx` | array | Required<br>(exactly 1) | An array containing the TXIDs of all transactions in this block.  The transactions appear in the array in the same order they appear in the serialized block
→ →<br>TXID | string (hex) | Required<br>(1 or more) | The TXID of a transaction in this block, encoded as hex in RPC byte order
→<br>`cbTx` | object | Required<br>(exactly 1) | Coinbase special transaction details
→ →<br>`version` | number (int) | Required<br>(exactly 1) | The version of the Coinbase special transaction (CbTx)
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→ →<br>`merkleRootMNList` | string (hex) | Required<br>(exactly 1) | The merkle root for the masternode list
→ →<br>`merkleRootQuorums` | string (hex) | Required<br>(exactly 1) | The merkle root for the quorum list
→ →<br>`bestCLHeightDiff` | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The best ChainLock height difference
→ →<br>`bestCLSignature` | string (hex) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The best ChainLock signature
→ →<br>`creditPoolBalance` | number (real) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The balance of the credit pool

*Result (if verbosity was `2`---a JSON block with full transaction details*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred
→<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of this block's block header encoded as hex in RPC byte order.  This is the same as the hash provided in parameter #1
→<br>`confirmations` | number (int) | Required<br>(exactly 1) | The number of confirmations the transactions in this block have, starting at 1 when this block is at the tip of the best block chain.  This score will be -1 if the the block is not part of the best block chain
→<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→<br>`version` | number (int) | Required<br>(exactly 1) | This block's version number.  See [block version numbers](../reference/block-chain-block-headers.md#block-versions)
→<br>`versionHex` | string (hex) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.13.0*<br><br>The block version formatted in hexadecimal
→<br>`merkleroot` | string (hex) | Required<br>(exactly 1) | The merkle root for this block, encoded as hex in RPC byte order
→<br>`time` | number (int) | Required<br>(exactly 1) | The value of the *time* field in the block header, indicating approximately when the block was created
→<br>`mediantime` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The median block time in Unix epoch time  
→<br>`nonce` | number (int) | Required<br>(exactly 1) | The nonce which was successful at turning this particular block into one that could be added to the best block chain
→<br>`bits` | string (hex) | Required<br>(exactly 1) | The value of the *nBits* field in the block header, indicating the target threshold this block's header had to pass
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | The estimated amount of work done to find this block relative to the estimated amount of work done to find block 0
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes miners had to check from the genesis block to this block, encoded as big-endian hex
→<br>`nTx` | number (int) | Required<br>(exactly 1) | The number of transactions in the block
→<br>`previousblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the header of the previous block, encoded as hex in RPC byte order.  Not returned for genesis block
→<br>`nextblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the next block on the best block chain, if known, encoded as hex in RPC byte order
→<br>`chainlock` | bool | Required<br>(exactly 1) | *Added in Dash Core 0.14.0*<br><br>If set to `true`, this transaction is in a block that is locked (not susceptible to a chain re-org)
→<br>`size` | number (int) | Required<br>(exactly 1) | The size of this block in serialized block format, counted in bytes
→<br>`tx` | array | Required<br>(exactly 1) | An array containing the details for all transactions in this block.  The transactions appear in the array in the same order they appear in the serialized block
→ →<br>`txid` | string (hex) | Required<br>(exactly 1) | The transaction's TXID encoded as hex in RPC byte order
→ →<br>`size` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The serialized transaction size
→ →<br>`version` | number (int) | Required<br>(exactly 1) | The transaction format version number
→ →<br>`type` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 0.13.0.0*<br><br>The transaction format type
→ →<br>`locktime` | number (int) | Required<br>(exactly 1) | The transaction's locktime: either a Unix epoch date or block height; see the [locktime parsing rules](../guide/transactions-locktime-and-sequence-number.md#locktime-parsing-rules)
→ →<br>`vin` | array | Required<br>(exactly 1) | An array of objects with each object being an input vector (vin) for this transaction.  Input objects will have the same order within the array as they have in the transaction, so the first input listed will be input 0
→ → →<br>Input | object | Required<br>(1 or more) | An object describing one of this transaction's inputs.  May be a regular input or a coinbase
→ → → →<br>`txid` | string | Optional<br>(0 or 1) | The TXID of the outpoint being spent, encoded as hex in RPC byte order.  Not present if this is a coinbase transaction
→ → → →<br>`vout` | number (int) | Optional<br>(0 or 1) | The output index number (vout) of the outpoint being spent.  The first output in a transaction has an index of `0`.  Not present if this is a coinbase transaction
→ → → →<br>`scriptSig` | object | Optional<br>(0 or 1) | An object describing the signature script of this input.  Not present if this is a coinbase transaction
→ → → → →<br>`asm` | string | Required<br>(exactly 1) | The signature script in decoded form with non-data-pushing opcodes listed
→ → → → →<br>`hex` | string (hex) | Required<br>(exactly 1) | The signature script encoded as hex
→ → → →<br>`coinbase` | string (hex) | Optional<br>(0 or 1) | The coinbase (similar to the hex field of a scriptSig) encoded as hex.  Only present if this is a coinbase transaction
→ → → →<br>`value` | number (Dash) | Optional<br>(exactly 1) | The number of Dash paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled
→ → → →<br>`valueSat` | number (duffs) | Optional<br>(exactly 1) | The number of duffs paid to this output.  May be `0`.<br><br>Only present if `spentindex` enabled
→ → → → →<br>`addresses` | string : array | Optional<br>(0 or 1) | The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types.<br><br>Only present if `spentindex` enabled
→ → → → → →<br>Address | string | Required<br>(1 or more) | A P2PKH or P2SH address
→ → → →<br>`sequence` | number (int) | Required<br>(exactly 1) | The input sequence number
→ →<br>`vout` | array | Required<br>(exactly 1) | An array of objects each describing an output vector (vout) for this transaction.  Output objects will have the same order within the array as they have in the transaction, so the first output listed will be output 0
→ → →<br>Output | object | Required<br>(1 or more) | An object describing one of this transaction's outputs
→ → → →<br>`value` | number (Dash) | Required<br>(exactly 1) | The number of Dash paid to this output.  May be `0`
→ → → →<br>`valueSat` | number (duffs) | Required<br>(exactly 1) | The number of duffs paid to this output.  May be `0`
→ → → →<br>`n` | number (int) | Required<br>(exactly 1) | The output index number of this output within this transaction
→ → → →<br>`scriptPubKey` | object | Required<br>(exactly 1) | An object describing the pubkey script
→ → → → →<br>`asm` | string | Required<br>(exactly 1) | The pubkey script in decoded form with non-data-pushing opcodes listed
→ → → → →<br>`hex` | string (hex) | Required<br>(exactly 1) | The pubkey script encoded as hex
→ → → → →<br>`reqSigs` | number (int) | Optional<br>(0 or 1) | The number of signatures required; this is always `1` for P2PK, P2PKH, and P2SH (including P2SH multisig because the redeem script is not available in the pubkey script).  It may be greater than 1 for bare multisig.  This value will not be returned for `nulldata` or `nonstandard` script types (see the `type` key below)
→ → → → →<br>`type` | string | Optional<br>(0 or 1) | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts
→ → → → →<br>`addresses` | string : array | Optional<br>(0 or 1) | The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types
→ → → → → →<br>Address | string | Required<br>(1 or more) | A P2PKH or P2SH address
→ →<br>`extraPayloadSize` | number (int) | Optional<br>(0 or 1) | *Added in Dash Core 0.13.0.0*<br><br>Size of the DIP2 extra payload. Only present if it's a DIP2 special transaction
→ →<br>`extraPayload` | string (hex) | Optional<br>(0 or 1) | *Added in Dash Core 0.13.0.0*<br><br>Hex encoded DIP2 extra payload data. Only present if it's a DIP2 special transaction
→ →<br>`fee` | number | Optional<br>(0 or 1) | The transaction fee in DASH, omitted if block undo data is not available
→ →<br>`instantlock` | bool | Required<br>(exactly 1) | If set to `true`, this transaction is either protected by an [InstantSend](../resources/glossary.md#instantsend) lock or it is in a block that has received a [ChainLock](../resources/glossary.md#chainlock)
→ →<br>`instantlock_internal` | bool | Required<br>(exactly 1) | If set to `true`, this transaction has an [InstantSend](../resources/glossary.md#instantsend) lock
→<br>`cbTx` | object | Required<br>(exactly 1) | Coinbase special transaction details
→ →<br>`version` | number (int) | Required<br>(exactly 1) | The version of the Coinbase special transaction (CbTx)
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→ →<br>`merkleRootMNList` | string (hex) | Required<br>(exactly 1) | The merkle root for the masternode list
→ →<br>`merkleRootQuorums` | string (hex) | Required<br>(exactly 1) | The merkle root for the quorum list
→ →<br>`bestCLHeightDiff` | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The best ChainLock height difference
→ →<br>`bestCLSignature` | string (hex) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The best ChainLock signature
→ →<br>`creditPoolBalance` | number (real) | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>The balance of the credit pool

*Example from Dash Core 21.0.0*

Get a block in raw hex:

``` bash
dash-cli -testnet getblock \
            00000379fb0a60210eb58e736775784b4e0491ae23b65f7916988f9d780a9f93 \
            0
```

Result (wrapped):

``` text
00000020fdd8c7fa1c64fe932918d0a5c40209ab155f738291dec38c9e39690c\
22000000cac98c66d5f8828ec72b68a24d61e354a19434fa0569707b90e5cd47\
fefdd7653d425d6541f3031e468a050001030005000100000000000000000000\
00000000000000000000000000000000000000000000ffffffff060326ff0d01\
01ffffffff0283706e04000000001976a914c69a0bda7daaae481be8def95e5f\
347a1d00a4b488ac89514b0d000000001976a91421eca01872dbfce4bf20886a\
004f6caaa69c1ff788ac00000000af030026ff0d00581474bac547d8c933eb30\
4e1c98d241bf807a85ea706591dacee405b3e7d3fac4c4566f175ccb5e3ee12f\
0e869d2bb1ede63112975c8d147f8c072bd63960fe009849edd3f5f7c4ddfa54\
dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bb\
c2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299\
c225e3ee290a7c96a448b83ed97f1e9ed34be1da354566da8a0202000000
```

Get the same block in JSON:

``` bash
dash-cli -testnet getblock \
            00000379fb0a60210eb58e736775784b4e0491ae23b65f7916988f9d780a9f93
```

Result:

``` json
{
  "hash": "00000379fb0a60210eb58e736775784b4e0491ae23b65f7916988f9d780a9f93",
  "confirmations": 107991,
  "height": 917286,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "65d7fdfe47cde5907b706905fa3494a154e3614da2682bc78e82f8d5668cc9ca",
  "time": 1700610621,
  "mediantime": 1700609994,
  "nonce": 363078,
  "bits": "1e03f341",
  "difficulty": 0.0009888562457268011,
  "chainwork": "00000000000000000000000000000000000000000000000002d68d38fa5ef014",
  "nTx": 1,
  "previousblockhash": "000000220c69399e8cc3de9182735f15ab0902c4a5d0182993fe641cfac7d8fd",
  "nextblockhash": "0000039bbed5dba71339bf917be5a797123919f02d1d9bda78cae3ab5d38985e",
  "chainlock": true,
  "size": 382,
  "tx": [
    "65d7fdfe47cde5907b706905fa3494a154e3614da2682bc78e82f8d5668cc9ca"
  ],
  "cbTx": {
    "version": 3,
    "height": 917286,
    "merkleRootMNList": "fad3e7b305e4ceda916570ea857a80bf41d2981c4e30eb33c9d847c5ba741458",
    "merkleRootQuorums": "fe6039d62b078c7f148d5c971231e6edb12b9d860e2fe13e5ecb5c176f56c4c4",
    "bestCLHeightDiff": 0,
    "bestCLSignature": "9849edd3f5f7c4ddfa54dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bbc2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299c225e3ee290a7c96a448b83ed97f1e9ed34be1da3545",
    "creditPoolBalance": 86.32588902
  }
}
```

Get the same block in JSON with transaction details:

``` bash
dash-cli -testnet getblock \
            00000379fb0a60210eb58e736775784b4e0491ae23b65f7916988f9d780a9f93 2
```

Result:

``` json
{
  "hash": "00000379fb0a60210eb58e736775784b4e0491ae23b65f7916988f9d780a9f93",
  "confirmations": 107993,
  "height": 917286,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "65d7fdfe47cde5907b706905fa3494a154e3614da2682bc78e82f8d5668cc9ca",
  "time": 1700610621,
  "mediantime": 1700609994,
  "nonce": 363078,
  "bits": "1e03f341",
  "difficulty": 0.0009888562457268011,
  "chainwork": "00000000000000000000000000000000000000000000000002d68d38fa5ef014",
  "nTx": 1,
  "previousblockhash": "000000220c69399e8cc3de9182735f15ab0902c4a5d0182993fe641cfac7d8fd",
  "nextblockhash": "0000039bbed5dba71339bf917be5a797123919f02d1d9bda78cae3ab5d38985e",
  "chainlock": true,
  "size": 382,
  "tx": [
    {
      "txid": "65d7fdfe47cde5907b706905fa3494a154e3614da2682bc78e82f8d5668cc9ca",
      "version": 3,
      "type": 5,
      "size": 301,
      "locktime": 0,
      "vin": [
        {
          "coinbase": "0326ff0d0101",
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 0.74346627,
          "valueSat": 74346627,
          "n": 0,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 c69a0bda7daaae481be8def95e5f347a1d00a4b4 OP_EQUALVERIFY OP_CHECKSIG",
            "hex": "76a914c69a0bda7daaae481be8def95e5f347a1d00a4b488ac",
            "reqSigs": 1,
            "type": "pubkeyhash",
            "addresses": [
              "yeRZBWYfeNE4yVUHV4ZLs83Ppn9aMRH57A"
            ]
          }
        },
        {
          "value": 2.23039881,
          "valueSat": 223039881,
          "n": 1,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 21eca01872dbfce4bf20886a004f6caaa69c1ff7 OP_EQUALVERIFY OP_CHECKSIG",
            "hex": "76a91421eca01872dbfce4bf20886a004f6caaa69c1ff788ac",
            "reqSigs": 1,
            "type": "pubkeyhash",
            "addresses": [
              "yPQpcZ1EdtQXWHzNjZuvVCKXuESW5wZ5x1"
            ]
          }
        }
      ],
      "extraPayloadSize": 175,
      "extraPayload": "030026ff0d00581474bac547d8c933eb304e1c98d241bf807a85ea706591dacee405b3e7d3fac4c4566f175ccb5e3ee12f0e869d2bb1ede63112975c8d147f8c072bd63960fe009849edd3f5f7c4ddfa54dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bbc2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299c225e3ee290a7c96a448b83ed97f1e9ed34be1da354566da8a0202000000",
      "cbTx": {
        "version": 3,
        "height": 917286,
        "merkleRootMNList": "fad3e7b305e4ceda916570ea857a80bf41d2981c4e30eb33c9d847c5ba741458",
        "merkleRootQuorums": "fe6039d62b078c7f148d5c971231e6edb12b9d860e2fe13e5ecb5c176f56c4c4",
        "bestCLHeightDiff": 0,
        "bestCLSignature": "9849edd3f5f7c4ddfa54dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bbc2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299c225e3ee290a7c96a448b83ed97f1e9ed34be1da3545",
        "creditPoolBalance": 86.32588902
      },
      "hex": "03000500010000000000000000000000000000000000000000000000000000000000000000ffffffff060326ff0d0101ffffffff0283706e04000000001976a914c69a0bda7daaae481be8def95e5f347a1d00a4b488ac89514b0d000000001976a91421eca01872dbfce4bf20886a004f6caaa69c1ff788ac00000000af030026ff0d00581474bac547d8c933eb304e1c98d241bf807a85ea706591dacee405b3e7d3fac4c4566f175ccb5e3ee12f0e869d2bb1ede63112975c8d147f8c072bd63960fe009849edd3f5f7c4ddfa54dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bbc2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299c225e3ee290a7c96a448b83ed97f1e9ed34be1da354566da8a0202000000",
      "instantlock": true,
      "instantlock_internal": false
    }
  ],
  "cbTx": {
    "version": 3,
    "height": 917286,
    "merkleRootMNList": "fad3e7b305e4ceda916570ea857a80bf41d2981c4e30eb33c9d847c5ba741458",
    "merkleRootQuorums": "fe6039d62b078c7f148d5c971231e6edb12b9d860e2fe13e5ecb5c176f56c4c4",
    "bestCLHeightDiff": 0,
    "bestCLSignature": "9849edd3f5f7c4ddfa54dd43b06a8a6ca9043c6a6498cf0d757902e69301f780a5d6190ac0da904420bbc2e8079f590d0ebca384512f1c61910b51336e401759734189de9bdb9d26d299c225e3ee290a7c96a448b83ed97f1e9ed34be1da3545",
    "creditPoolBalance": 86.32588902
  }
}
```

*See also*

* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.

## GetBlockChainInfo

The [`getblockchaininfo` RPC](../api/remote-procedure-calls-blockchain.md#getblockchaininfo) provides information about the current state of the block chain.

*Parameters: none*

*Result---A JSON object providing information about the block chain*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | Information about the current state of the local block chain
→<br>`chain` | string | Required<br>(exactly 1) | The name of the block chain. Either `main` for mainnet, `test` for testnet, `regtest` for regtest, or `devnet-<name>` for devnets
→<br>`blocks` | number (int) | Required<br>(exactly 1) | The number of validated blocks in the local best block chain.  For a new node with just the hardcoded genesis block, this will be 0
→<br>`headers` | number (int) | Required<br>(exactly 1) | The number of validated headers in the local best headers chain.  For a new node with just the hardcoded genesis block, this will be zero.  This number may be higher than the number of *blocks*
→<br>`bestblockhash` | string (hex) | Required<br>(exactly 1) | The hash of the header of the highest validated block in the best block chain, encoded as hex in RPC byte order.  This is identical to the string returned by the [`getbestblockhash` RPC](../api/remote-procedure-calls-blockchain.md#getbestblockhash)
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | The difficulty of the highest-height block in the best block chain
→<br>`time` | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br><br>The block time expressed in UNIX epoch time
→<br>`mediantime` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The median time of the 11 blocks before the most recent block on the blockchain.  Used for validating transaction locktime under BIP113
→<br>`verificationprogress` | number (real) | Required<br>(exactly 1) | Estimate of what percentage of the block chain transactions have been verified so far, starting at 0.0 and increasing to 1.0 for fully verified.  May slightly exceed 1.0 when fully synced to account for transactions in the memory pool which have been verified before being included in a block
→<br>`initialblockdownload` | boolean | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>An estimate of whether this node is in [Initial Block Download](../guide/p2p-network-initial-block-download.md) mode (*debug information*)
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes checked from the genesis block to this block, encoded as big-endian hex
→<br>`size_on_disk` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>The estimated size of the block and undo files on disk
→<br>`pruned` | bool | Required<br>(exactly 1) | *Added in Bitcoin Core 0.11.0*<br><br>Indicates if the blocks are subject to pruning
→<br>`pruneheight` | number (int) | Optional<br>(0 or 1) | *Added in Bitcoin Core 0.11.0*<br><br>The lowest-height complete block stored if pruning is activated
→<br>`automatic_pruning` | bool | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Whether automatic pruning is enabled (only present if pruning is enabled)
→<br>`prune_target_size` | number (int) | Optional<br>(0 or 1) | *Added in Dash Core 0.16.0*<br><br>The target size used by pruning (only present if automatic pruning is enabled)
→<br>`softforks` | object | Required<br>(exactly 1) | **Revised significantly in Dash Core 20.0.0**<br><br>An object with each key describing a current or previous soft fork
→ →<br>Softfork | object | Required<br>(0 or more) | The name of a specific softfork
→ → →<br>`type`          | string  | Required | One of "buried", "bip9"
→ → →<br>`bip9`          | object  | Optional | Status of bip9 softforks (only for "bip9" type)
→ → → →<br>`status`       | string  | Required | One of "defined", "started", "locked_in", "active", "failed"
→ → → →<br>`bit`          | numeric | Optional | The bit (0-28) in the block version field used to signal this softfork (only for "started" status)
→ → → →<br>`start_time`   | numeric | Required | The minimum median time past of a block at which the bit gains its meaning
→ → → →<br>`timeout`      | numeric | Required | The median time past of a block at which the deployment is considered failed if not yet locked in
→ → → →<br>`since`        | numeric | Required | Height of the first block to which the status applies
→ → → →<br>`activation_height` | numeric | Optional | Expected activation height for this softfork (only for "locked_in" `status`)
→ → → →<br>`min_activation_height` | numeric | Optional | Minimum height of blocks for which the rules may be enforced
→ → → →<br>`ehf`          | bool | Required | `true` for EHF activated hard forks
→ → → →<br>`ehf_height`   | numeric | Optional | The minimum height at which miner's signals for the deployment matter. Below this height miner signaling cannot trigger hard fork lock-in. Not returned if `ehf` is `false` or if the minimum height is not known yet.
→ → → →<br>`statistics` | string : object | Required<br>(exactly 1) | *Added in Dash Core 0.15.0*<br><br>Numeric statistics about BIP9 signaling for a softfork (only for \started\" status)"
→ → → → →<br>`period` | numeric<br>(int) | Optional<br>(0 or 1) | *Added in Dash Core 0.15.0*<br><br>The length in blocks of the BIP9 signaling period.  Field is only shown when status is `started`
→ → → → →<br>`threshold` | numeric<br>(int) | Optional<br>(0 or 1) | *Added in Dash Core 0.15.0*<br><br>The number of blocks with the version bit set required to activate the feature.  Field is only shown when status is `started`
→ → → → →<br>`elapsed` | numeric<br>(int) | Optional<br>(0 or 1) | *Added in Dash Core 0.15.0*<br><br>The number of blocks elapsed since the beginning of the current period.  Field is only shown when status is `started`
→ → → → →<br>`count` | numeric<br>(int) | Optional<br>(0 or 1) | *Added in Dash Core 0.15.0*<br><br>The number of blocks with the version bit set in the current period.  Field is only shown when status is `started`
→ → → → →<br>`possible` | bool | Optional<br>(0 or 1) | *Added in Bitcoin Core 0.11.0*<br><br>Returns false if there are not enough blocks left in this period to pass activation threshold.  Field is only shown when status is `started`
→ → →<br>`height` | numeric | Optional | Height of the first block at which the rules are or will be enforced (only for "buried" type, or "bip9" type with "active" status)
→ → →<br>`active` | boolean | Required | True if the rules are enforced for the mempool and the next block
→<br>`warnings` | string | Optional<br>(0 or 1) | *Added in Dash Core 0.16.0*<br><br>Returns any network and blockchain warnings

*Example from Dash Core 21.0.0*

``` bash
dash-cli -testnet getblockchaininfo
```

Result:

``` json
{
  "chain": "test",
  "blocks": 1025413,
  "headers": 1025413,
  "bestblockhash": "000000a7f4dbe0865dbbfacf24d8cdb2914fc0ba2d24131ed7ea0b181bec532f",
  "difficulty": 0.002316476131335342,
  "time": 1715629755,
  "mediantime": 1715628900,
  "verificationprogress": 0.9999996933131421,
  "initialblockdownload": false,
  "chainwork": "000000000000000000000000000000000000000000000000030928dd71247c3d",
  "size_on_disk": 3508237778,
  "pruned": false,
  "softforks": {
    "bip34": {
      "type": "buried",
      "active": true,
      "height": 76
    },
    "bip66": {
      "type": "buried",
      "active": true,
      "height": 2075
    },
    "bip65": {
      "type": "buried",
      "active": true,
      "height": 2431
    },
    "bip147": {
      "type": "buried",
      "active": true,
      "height": 4300
    },
    "csv": {
      "type": "buried",
      "active": true,
      "height": 8064
    },
    "dip0001": {
      "type": "buried",
      "active": true,
      "height": 5500
    },
    "dip0003": {
      "type": "buried",
      "active": true,
      "height": 7000
    },
    "dip0008": {
      "type": "buried",
      "active": true,
      "height": 78800
    },
    "dip0020": {
      "type": "buried",
      "active": true,
      "height": 414100
    },
    "dip0024": {
      "type": "buried",
      "active": true,
      "height": 769700
    },
    "realloc": {
      "type": "buried",
      "active": true,
      "height": 387500
    },
    "v19": {
      "type": "buried",
      "active": true,
      "height": 850100
    },
    "v20": {
      "type": "bip9",
      "bip9": {
        "status": "active",
        "start_time": 1693526400,
        "timeout": 9223372036854775807,
        "ehf": false,
        "since": 905100,
        "min_activation_height": 0
      },
      "height": 905100,
      "active": true
    },
    "mn_rr": {
      "type": "bip9",
      "bip9": {
        "status": "defined",
        "start_time": 1693526400,
        "timeout": 9223372036854775807,
        "ehf": true,
        "since": 0,
        "min_activation_height": 0
      },
      "active": false
    }
  },
  "warnings": "Make sure to encrypt your wallet and delete all non-encrypted backups after you have verified that the wallet works!"
}
```

*See also*

* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.
* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network.
* [GetWalletInfo](../api/remote-procedure-calls-wallet.md#getwalletinfo): provides information about the wallet.

## GetBlockCount

The [`getblockcount` RPC](../api/remote-procedure-calls-blockchain.md#getblockcount) returns the number of blocks in the local best block chain.

*Parameters: none*

*Result---the number of blocks in the local best block chain*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | number (int) | Required<br>(exactly 1) | The number of blocks in the local best block chain.  For a new node with only the hardcoded genesis block, this number will be 0

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getblockcount
```

Result:

``` text
4627
```

*See also*

* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.

## GetBlockFromPeer

The `getblockfrompeer` RPC attempts to fetch a specific block from a given peer. The node must
already have the header for the block (e.g., by using the [`submitheader`
RPC](./remote-procedure-calls-mining.md#submitheader)).

*Parameter #1---the block hash to fetch*

Name       | Type     | Presence                | Description
-----------|----------|-------------------------|------------
blockhash  | string   | Required<br>(exactly 1)  | The block hash to try to fetch

*Parameter #2---the peer to fetch from*

Name       | Type   | Presence                | Description
-----------|--------|-------------------------|------------
peer_id    | number | Required<br>(exactly 1)  | The ID of the peer to fetch the block from. You can get peer IDs by using the [`getpeerinfo` RPC](./remote-procedure-calls-network.md#getpeerinfo).

*Result---execution result*

Name        | Type    | Presence                | Description
------------|---------|-------------------------|------------
`warnings`  | string  | Optional<br>(0 or 1)     | Any warnings or issues encountered during the block fetch attempt. If there are no warnings, this field will not appear.

Returns `{}` if a block request was successfully scheduled.

*Example from Dash Core 22.0.0*

Attempt to fetch block `00000021e19ebb597d74627a4df829768c3f26d3185d943a53773e4a681391bd` from peer ID `0`:

```bash
dash-cli -testnet getblockfrompeer "00000021e19ebb597d74627a4df829768c3f26d3185d943a53773e4a681391bd" 0
```

Result:

```json
{
  "warnings": "Block already downloaded"
}
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.

## GetBlockHash

The [`getblockhash` RPC](../api/remote-procedure-calls-blockchain.md#getblockhash) returns the header hash of a block at the given height in the local best block chain.

*Parameter---a block height*

Name | Type | Presence | Description
--- | --- | --- | ---
Block Height | number (int) | Required<br>(exactly 1) | The height of the block whose header hash should be returned.  The height of the hardcoded genesis block is 0

*Result---the block header hash*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex)/null | Required<br>(exactly 1) | The hash of the block at the requested height, encoded as hex in RPC byte order, or JSON `null` if an error occurred

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getblockhash 4000
```

Result:

``` text
00000ce22113f3eb8636e225d6a1691e132fdd587aed993e1bc9b07a0235eea4
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.

## GetBlockFilter

*Added in Dash Core 18.0.0*

The [`getblockfilter` RPC](../api/remote-procedure-calls-blockchain.md#getblockfilter) retrieves a [BIP157](https://github.com/bitcoin/bips/blob/master/bip-0157.mediawiki) content filter for a particular block.

:::{note}
Requires the `-blockfilterindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

*Parameter #1---blockhash*

Name | Type | Presence | Description
--- | --- | --- | ---
Hash | string | Required<br>(exactly 1) | The hash of the block

*Parameter #2---filtertype*

Name | Type | Presence | Description
--- | --- | --- | ---
Filter type | string | Optional<br>(0 or 1) | The type name of the filter (default: basic).

*Result---A JSON object with the encoded filter data*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | The hex-encoded filter data.
→<br>`filter` | string (hex) | Required<br>(exactly 1) | The hex-encoded filter data
→<br>`header` | string (hex) | Required<br>(exactly 1) | The hex-encoded filter header

*Example from Dash Core 18.0.0*

``` bash
dash-cli -testnet getblockfilter 0000004bb972bddf8d5b2bce517db07ff4c69a04e74e9c0bd2caa11ee23d0323 basic
```

Result:

``` json
{
  "filter": "038c72a18c696aca7a",
  "header": "f80b699589d1bfb1b269f948e9114034686c110273b01b6e4c0026ade1d6b968"
}
```

## GetBlockHashes

:::{note}
Requires `timestampindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

*Added in Dash Core 0.12.1*

The [`getblockhashes` RPC](../api/remote-procedure-calls-blockchain.md#getblockhashes) returns array of hashes of blocks within the timestamp range provided (requires `timestampindex` to be enabled).

*Parameter #1---high block timestamp*

Name | Type | Presence | Description
--- | --- | --- | ---
Block Timestamp | number (int) | Required<br>(exactly 1) | The block timestamp for the newest block hash that should be returned.

*Parameter #2---low block timestamp*

Name | Type | Presence | Description
--- | --- | --- | ---
Block Timestamp | number (int) | Required<br>(exactly 1) | The block timestamp for the oldest block hash that should be returned.

*Result---the block header hashes in the give time range*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | The hashes of the blocks in the requested time range
→<br>`hash` | string (hex) | Required<br>(1 or more) | The hash of a block in the chain, encoded as hex in RPC byte order

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getblockhashes 1507555793 1507554793
```

Result:

``` json
[
  "0000000010a16c6fbc6bd5cdc238c2beabcda334e97fde1500d59be4e6fc4b89",
  "000000009910885e811230c403e55aac6547d6df04ee671b2e8348524f73cab8",
  "000000004bbb3828db1c4d4491760336cec215087819ab656336f30d4095e3d2",
  "00000000ad2df2149aca2261a9a87c41e139dfe8f73d91db7ec0c1837fee21a0",
  "0000000074068a9e3a271d165da3deb28bc3f8c751dde97f460d8078d92a9d06"
]
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.

```{eval-rst}
.. _api-rpc-blockchain-getblockheader:
```

## GetBlockHeader

*Added in Bitcoin Core 0.12.0*

The [`getblockheader` RPC](../api/remote-procedure-calls-blockchain.md#getblockheader) gets a block header with a particular header hash from the local block database either as a JSON object or as a serialized block header.

*Parameter #1---header hash*

Name | Type | Presence | Description
--- | --- | --- | ---
Header Hash | string (hex) | Required<br>(exactly 1) | The hash of the block header to get, encoded as hex in RPC byte order

*Parameter #2---JSON or hex output*

Name | Type | Presence | Description
--- | --- | --- | ---
Format | bool | Optional<br>(0 or 1) | Set to `false` to get the block header in serialized block format; set to `true` (the default) to get the decoded block header as a JSON object

*Result (if format was `false`)---a serialized block header*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex)/null | Required<br>(exactly 1) | The requested block header as a serialized block, encoded as hex, or JSON `null` if an error occurred

*Result (if format was `true` or omitted)---a JSON block header*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the requested block, or JSON `null` if an error occurred
→<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of this block's block header encoded as hex in RPC byte order.  This is the same as the hash provided in parameter #1
→<br>`confirmations` | number (int) | Required<br>(exactly 1) | The number of confirmations the transactions in this block have, starting at 1 when this block is at the tip of the best block chain.  This score will be -1 if the the block is not part of the best block chain
→<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→<br>`version` | number (int) | Required<br>(exactly 1) | This block's version number.  See [block version numbers](../reference/block-chain-block-headers.md#block-versions)
→<br>`merkleroot` | string (hex) | Required<br>(exactly 1) | The merkle root for this block, encoded as hex in RPC byte order
→<br>`time` | number (int) | Required<br>(exactly 1) | The time of the block  
→<br>`mediantime` | number (int) | Required<br>(exactly 1) | The computed median time of the previous 11 blocks.  Used for validating transaction locktime under BIP113
→<br>`nonce` | number (int) | Required<br>(exactly 1) | The nonce which was successful at turning this particular block into one that could be added to the best block chain
→<br>`bits` | string (hex) | Required<br>(exactly 1) | The value of the *nBits* field in the block header, indicating the target threshold this block's header had to pass
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | The estimated amount of work done to find this block relative to the estimated amount of work done to find block 0
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes miners had to check from the genesis block to this block, encoded as big-endian hex
→<br>`nTx` | number (int) | Required<br>(exactly 1) | The number of transactions in the block
→<br>`previousblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the header of the previous block, encoded as hex in RPC byte order.  Not returned for genesis block
→<br>`nextblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the next block on the best block chain, if known, encoded as hex in RPC byte order

*Changes from Bitcoin - Following items not present in Dash result*

Name | Type | Presence | Description
--- | --- | --- | ---
→<br>`versionHex` | number (hex) | Required<br>(exactly 1) | This block's hex version number.  See [block version numbers](../reference/block-chain-block-headers.md#block-versions)

*Example from Dash Core 0.16.0*

Get a block header in raw hex:

``` bash
dash-cli -testnet getblockheader \
            00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b \
            false
```

Result (wrapped):

``` text
00000020272e374a06c87a0ce0e6ee1a0754c98b9ec2493e7c0ac7ba41a0\
730000000000568b3c4156090db4d8db5447762e95dd1d4c921c96801a9\
086720ded85266325916cc05caa94001c5caf3595
```

Get the same block in JSON:

``` bash
dash-cli -testnet getblockheader \
            00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b
```

Result:

``` json
{
  "hash": "00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b",
  "confirmations": 212900,
  "height": 86190,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56",
  "time": 1556114577,
  "mediantime": 1556113720,
  "nonce": 2503323484,
  "bits": "1c0094aa",
  "difficulty": 440.8261075201009,
  "chainwork": "0000000000000000000000000000000000000000000000000045ab6f9403a8e7",
  "nTx": 1,
  "previousblockhash": "000000000073a041bac70a7c3e49c29e8bc954071aeee6e00c7ac8064a372e27",
  "nextblockhash": "00000000001c6c962639a1aad4cd069f315560a824d489418dc1f26b50a58aed",
  "chainlock": true
}
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBlockHashes](../api/remote-procedure-calls-blockchain.md#getblockhashes): returns array of hashes of blocks within the timestamp range provided (requires `timestampindex` to be enabled).
* [GetBlockHeaders](../api/remote-procedure-calls-blockchain.md#getblockheaders): returns an array of items with information about the requested number of blockheaders starting from the requested hash.
* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.

```{eval-rst}
.. _api-rpc-blockchain-getblockheaders:
```

## GetBlockHeaders

*Added in Dash Core 0.12.1*

The [`getblockheaders` RPC](../api/remote-procedure-calls-blockchain.md#getblockheaders) returns an array of items with information about the requested number of blockheaders starting from the requested hash.

*Parameter #1---header hash*

Name | Type | Presence | Description
--- | --- | --- | ---
Header Hash | string (hex) | Required<br>(exactly 1) | The hash of the block header to get, encoded as hex in RPC byte order

*Parameter #2---number of headers to return*

Name | Type | Presence | Description
--- | --- | --- | ---
Count | number | Optional<br>(exactly 1) | The number of block headers to get

*Parameter #3---JSON or hex output*

Name | Type | Presence | Description
--- | --- | --- | ---
Verbose | bool | Optional<br>(0 or 1) | Set to `false` to get the block headers in serialized block format; set to `true` (the default) to get the decoded block headers as a JSON object

*Result (if format was `false`)---a serialized block header*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | The requested block header(s) as a serialized block
→<br>`header` | string (hex) | Required<br>(1 or more) | The block header encoded as hex in RPC byte order

*Result (if format was `true` or omitted)---a JSON block header*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of objects each containing a block header, or JSON `null` if an error occurred
→<br>Block Header | object/null | Required<br>(exactly 1) | An object containing a block header
→ →<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of this block's block header encoded as hex in RPC byte order.  This is the same as the hash provided in parameter #1
→ →<br>`confirmations` | number (int) | Required<br>(exactly 1) | The number of confirmations the transactions in this block have, starting at 1 when this block is at the tip of the best block chain.  This score will be -1 if the the block is not part of the best block chain
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The height of this block on its block chain
→ →<br>`version` | number (int) | Required<br>(exactly 1) | This block's version number.  See [block version numbers](../reference/block-chain-block-headers.md#block-versions)
→ →<br>`merkleroot` | string (hex) | Required<br>(exactly 1) | The merkle root for this block, encoded as hex in RPC byte order
→ →<br>`time` | number (int) | Required<br>(exactly 1) | The time of the block
→ →<br>`mediantime` | number (int) | Required<br>(exactly 1) | The computed median time of the previous 11 blocks.  Used for validating transaction locktime under BIP113
→ →<br>`nonce` | number (int) | Required<br>(exactly 1) | The nonce which was successful at turning this particular block into one that could be added to the best block chain
→ →<br>`bits` | string (hex) | Required<br>(exactly 1) | The value of the *nBits* field in the block header, indicating the target threshold this block's header had to pass
→ →<br>`difficulty` | number (real) | Required<br>(exactly 1) | The estimated amount of work done to find this block relative to the estimated amount of work done to find block 0
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes miners had to check from the genesis block to this block, encoded as big-endian hex
→<br>`nTx` | number (int) | Required<br>(exactly 1) | The number of transactions in the block
→ →<br>`previousblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the header of the previous block, encoded as hex in RPC byte order.  Not returned for genesis block
→ →<br>`nextblockhash` | string (hex) | Optional<br>(0 or 1) | The hash of the next block on the best block chain, if known, encoded as hex in RPC byte order

*Example from Dash Core 0.16.0*

Get two block headers in raw hex:

``` bash
dash-cli -testnet getblockheaders \
            00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b \
            2 false
```

Result (wrapped):

``` text
[
  "00000020272e374a06c87a0ce0e6ee1a0754c98b9ec2493e7c0ac7ba41a0730000000\
   000568b3c4156090db4d8db5447762e95dd1d4c921c96801a9086720ded8526632591\
   6cc05caa94001c5caf3595",
  "000000202be60663802ead0740cb6d6e49ee7824481280f03c71369eb90f7b00000000\
   006abd277facc8cf02886d88662dbcc2adb6d8de7a491915e74bed4d835656a4f1f26d\
   c05ced93001ccf81cabc"
]
```

Get the same two block headers in JSON:

``` bash
dash-cli -testnet getblockheader \
            00000000eb0af5aec7b673975a22593dc0cc763f71ba8de26292410273437078 \
            2 true
```

Result:

``` json
[
  {
    "hash": "00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b",
    "confirmations": 212910,
    "height": 86190,
    "version": 536870912,
    "versionHex": "20000000",
    "merkleroot": "25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56",
    "time": 1556114577,
    "mediantime": 1556113720,
    "nonce": 2503323484,
    "bits": "1c0094aa",
    "difficulty": 440.8261075201009,
    "chainwork": "0000000000000000000000000000000000000000000000000045ab6f9403a8e7",
    "nTx": 1,
    "previousblockhash": "000000000073a041bac70a7c3e49c29e8bc954071aeee6e00c7ac8064a372e27",
    "nextblockhash": "00000000001c6c962639a1aad4cd069f315560a824d489418dc1f26b50a58aed",
    "chainlock": true
  },
  {
    "hash": "00000000001c6c962639a1aad4cd069f315560a824d489418dc1f26b50a58aed",
    "confirmations": 212909,
    "height": 86191,
    "version": 536870912,
    "versionHex": "20000000",
    "merkleroot": "f1a45656834ded4be71519497aded8b6adc2bc2d66886d8802cfc8ac7f27bd6a",
    "time": 1556114930,
    "mediantime": 1556113903,
    "nonce": 3167388111,
    "bits": "1c0093ed",
    "difficulty": 443.0262219757585,
    "chainwork": "0000000000000000000000000000000000000000000000000045ad2a9c752d18",
    "nTx": 1,
    "previousblockhash": "00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b",
    "nextblockhash": "000000000076a17beb1bb56e6ec53579f8a604d2363c9a4f8ca3f63e6aca3423",
    "chainlock": true
  }
]
```

*See also*

* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBlockHashes](../api/remote-procedure-calls-blockchain.md#getblockhashes): returns array of hashes of blocks within the timestamp range provided (requires `timestampindex` to be enabled).
* [GetBlockHeader](../api/remote-procedure-calls-blockchain.md#getblockheader): gets a block header with a particular header hash from the local block database either as a JSON object or as a serialized block header.
* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.

## GetBlockStats

The [`getblockstats` RPC](../api/remote-procedure-calls-blockchain.md#getblockstats) computes per block statistics for a given window.

This RPC won't work for some heights if pruning is enabled. Since Dash Core 18.1, `-txindex` is no longer required and it works for all non-pruned blocks.

*Parameter #1---hash_or_height*

Name | Type | Presence | Description
--- | --- | --- | ---
hash_or_height | string or numeric | Required<br>(exactly 1) | The block hash or height of the target block

*Parameter #2---stats*

Name | Type | Presence | Description
--- | --- | --- | ---
stats | array | optional | Values to plot, by default all values (see result below)

*Result---a JSON object containing the requested statistics*

:::{note}
All amounts are in duffs.
:::

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing stats for the requested block, or JSON `null` if an error occurred
→<br>`avgfee` | numeric | Required<br>(exactly 1) | Average fee in the block
→<br>`avgfeerate` | numeric | Required<br>(exactly 1) | Average feerate (in duffs per byte)
→<br>`avgtxsize` | numeric | Required<br>(exactly 1) | Average transaction size
→<br>`blockhash` | string (hex) | Required<br>(exactly 1) | The block hash (to check for potential reorgs)
→<br>`feerate_percentiles` | array (num) | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br>Feerates at the 10th, 25th, 50th, 75th, and 90th percentile weight unit, which are in duffs per byte.
→ → <br>`10th_percentile_feerate` | numeric | Required<br>(exactly 1) | The 10th percentile feerate
→ → <br>`25th_percentile_feerate` | numeric | Required<br>(exactly 1) | The 25th percentile feerate
→ → <br>`50th_percentile_feerate` | numeric | Required<br>(exactly 1) | The 50th percentile feerate
→ → <br>`75th_percentile_feerate` | numeric | Required<br>(exactly 1) | The 75th percentile feerate
→ → <br>`90th_percentile_feerate` | numeric | Required<br>(exactly 1) | The 90th percentile feerate
→<br>`height` | numeric | Required<br>(exactly 1) | The height of the block
→<br>`ins` | numeric | Required<br>(exactly 1) | The number of inputs (excluding coinbase)
→<br>`maxfee` | numeric | Required<br>(exactly 1) | Maximum fee in the block
→<br>`maxfeerate` | numeric | Required<br>(exactly 1) | Maximum feerate (in duffs per byte)
→<br>`maxtxsize` | numeric | Required<br>(exactly 1) | Maximum transaction size
→<br>`medianfee` | numeric | Required<br>(exactly 1) | Truncated median fee in the block
→<br>~~medianfeerate~~ | ~~numeric~~ | ~~Required (exactly 1)~~ | **Removed in Dash Core 18.0.0**<br>~~Truncated median feerate (in duffs per byte)~~
→<br>`mediantime` | numeric | Required<br>(exactly 1) | The block median time past
→<br>`mediantxsize` | numeric | Required<br>(exactly 1) | Truncated median transaction size
→<br>`minfee` | numeric | Required<br>(exactly 1) | Minimum fee in the block
→<br>`minfeerate` | numeric | Required<br>(exactly 1) | Minimum feerate (in duffs per byte)
→<br>`mintxsize` | numeric | Required<br>(exactly 1) | Minimum transaction size
→<br>`outs` | numeric | Required<br>(exactly 1) | The number of outputs
→<br>`subsidy` | numeric | Required<br>(exactly 1) | The block subsidy
→<br>`time` | number (real) | Required<br>(exactly 1) | The block time
→<br>`total_out` | numeric | Required<br>(exactly 1) | Total amount in all outputs (excluding coinbase and thus reward [i.e. subsidy + totalfee])
→<br>`total_size` | numeric | Required<br>(exactly 1) | Total size of all non-coinbase transactions
→<br>`totalfee` | numeric | Required<br>(exactly 1) | The fee total
→<br>`txs` | numeric | Required<br>(exactly 1) | The number of transactions (including coinbase)
→<br>`utxo_increase` | numeric | Required<br>(exactly 1) | The increase/decrease in the number of unspent outputs
→<br>`utxo_size_inc` | numeric | Required<br>(exactly 1) | The increase/decrease in size for the utxo index (not discounting op_return and similar)

*Example from Dash Core 18.0.0*

``` bash
dash-cli getblockstats 1000 '["minfeerate","avgfeerate"]'
```

Result:

``` json
{
  "avgfeerate": 0,
  "minfeerate": 0
}
```

*See also: none*

## GetChainTips

The [`getchaintips` RPC](../api/remote-procedure-calls-blockchain.md#getchaintips) returns information about the highest-height block (tip) of each local block chain.

*Parameters: none*

*Result---an array of block chain tips*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of JSON objects, with each object describing a chain tip.  At least one tip---the local best block chain---will always be present
→<br>Tip | object | Required<br>(1 or more) | An object describing a particular chain tip.  The first object will always describe the active chain (the local best block chain)
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The height of the highest block in the chain.  A new node with only the genesis block will have a single tip with height of 0
→ →<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of the highest block in the chain, encoded as hex in RPC byte order
→<br>`difficulty` | number (real) | Required<br>(exactly 1) | The difficulty of the highest-height block in the best block chain (Added in Dash Core 0.12.1)
→<br>`chainwork` | string (hex) | Required<br>(exactly 1) | The estimated number of block header hashes checked from the genesis block to this block, encoded as big-endian hex (Added in Dash Core 0.12.1)
→ →<br>`branchlen` | number (int) | Required<br>(exactly 1) | The number of blocks that are on this chain but not on the main chain.  For the local best block chain, this will be `0`; for all other chains, it will be at least `1`
→ →<br>`forkpoint` | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.12.3*<br><br>Block hash of the last common block between this tip and the main chain
→ →<br>`status` | string | Required<br>(exactly 1) | The status of this chain.  Valid values are:<br>• `active` for the local best block chain<br>• `invalid` for a chain that contains one or more invalid blocks<br>• `headers-only` for a chain with valid headers whose corresponding blocks both haven't been validated and aren't stored locally<br>• `valid-headers` for a chain with valid headers whose corresponding blocks are stored locally, but which haven't been fully validated<br>• `valid-fork` for a chain which is fully validated but which isn't part of the local best block chain (it was probably the local best block chain at some point)<br>• `unknown` for a chain whose reason for not being the active chain is unknown

*Example from Dash Core 0.12.3*

``` bash
dash-cli -testnet getchaintips
```

``` json
[
  {
    "height": 110192,
    "hash": "000000000c6007f40c3b68a77b0e1319a89c0504ae1b391d071cf49fa7591dee",
    "difficulty": 18.38631407059958,
    "chainwork": "000000000000000000000000000000000000000000000000002cbd2546718747",
    "branchlen": 0,
    "forkpoint": "000000000c6007f40c3b68a77b0e1319a89c0504ae1b391d071cf49fa7591dee",
    "status": "active"
  }
]
```

*See also*

* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.
* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.
* [GetBlockChainInfo](../api/remote-procedure-calls-blockchain.md#getblockchaininfo): provides information about the current state of the block chain.

## GetChainTxStats

The [`getchaintxstats` RPC](../api/remote-procedure-calls-blockchain.md#getchaintxstats) compute statistics about the total number and rate of transactions in the chain.

*Parameter #1---nblocks*

Name | Type | Presence | Description
--- | --- | --- | ---
nblocks | number (int) | Optional | Size of the window in number of blocks (default: one month).

*Parameter #2---blockhash*

Name | Type | Presence | Description
--- | --- | --- | ---
blockhash | string | Optional | The hash of the block that ends the window.

*Result--statistics about transactions*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | Object containing transaction statistics
→<br>`time` | number (int) | Required<br>(exactly 1) | The timestamp for the statistics in UNIX format
→<br>`txcount` | number (int) | Required<br>(exactly 1) | The total number of transactions in the chain up to that point
→<br>`window_final_block_hash` | string (hex) | Required<br>(exactly 1) | *Added in Dash Core 0.17.0*<br><br>The hash of the final block in the window
→<br>`window_block_count` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Size of the window in number of blocks
→<br>`window_final_block_height` | number (int) | Required<br>(exactly 1) | _Added in Dash Core 18.0.0_<br><br>Height of the final block in window
→<br>`window_tx_count` | number (int) | Optional<br>(0 or 1) | *Added in Dash Core 0.16.0*<br><br>The number of transactions in the window. Only returned if `window_block_count` is > 0
→<br>`window_interval` | number (int) | Optional<br>(0 or 1) | *Added in Dash Core 0.16.0*<br><br>The elapsed time in the window in seconds. Only returned if `window_block_count` is > 0
→<br>`txrate` | number (int) | Optional<br>(0 or 1) | The average rate of transactions per second in the window. Only returned if `window_interval` is > 0

*Example from Dash Core 18.0.0*

``` bash
dash-cli -testnet getchaintxstats
```

Result:

``` json
{
  "time": 1634200935,
  "txcount": 5255650,
  "window_final_block_hash": "0000013524141f0e54137d266088c3d042cca340eabc4393414d7d0560866239",
  "window_final_block_height": 593815,
  "window_block_count": 17280,
  "window_tx_count": 33384,
  "window_interval": 2417430,
  "txrate": 0.0138097070028915
}

```

*See also: none*

## GetDifficulty

The [`getdifficulty` RPC](../api/remote-procedure-calls-blockchain.md#getdifficulty) returns the proof-of-work difficulty as a multiple of the minimum difficulty.

*Parameters: none*

*Result---the current difficulty*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | number (real) | Required<br>(exactly 1) | The difficulty of creating a block with the same target threshold (nBits) as the highest-height block in the local best block chain.  The number is a a multiple of the minimum difficulty

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet getdifficulty
```

Result:

``` text
1.069156225528583
```

*See also*

* [GetNetworkHashPS](../api/remote-procedure-calls-mining.md#getnetworkhashps): returns the estimated network hashes per second based on the last n blocks.
* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.

```{eval-rst}
.. _api-rpc-blockchain-getmempoolancestors:
```

## GetMemPoolAncestors

*Added in Dash Core 0.12.3*

The [`getmempoolancestors` RPC](../api/remote-procedure-calls-blockchain.md#getmempoolancestors) returns all in-mempool ancestors for a transaction in the mempool.

*Parameter #1---a transaction identifier (TXID)*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string (hex) | Required<br>(exactly 1) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order

*Parameter #2---desired output format*

Name | Type | Presence | Description
--- | --- | --- | ---
Format | bool | Optional<br>(0 or 1) | Set to `true` to get json objects describing each transaction in the memory pool; set to `false` (the default) to only get an array of TXIDs

*Result---list of ancestor transactions*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of TXIDs belonging to transactions in the memory pool.  The array may be empty if there are no transactions in the memory pool
→<br>TXID | string | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order

*Result (format: `true`)---a JSON object describing each transaction*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing transactions currently in the memory pool.  May be empty
→<br>TXID | string : object | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order
→ →<br>`size` | number (int) | Required<br>(exactly 1) | The size of the serialized transaction in bytes
→ →<br>`fee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee paid by the transaction in decimal bitcoins
→ →<br>`modifiedfee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee with fee deltas used for mining priority in decimal bitcoins
→ →<br>`time` | number (int) | Required<br>(exactly 1) | The time the transaction entered the memory pool, Unix epoch time format
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The block height when the transaction entered the memory pool
→ →<br>`descendantcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool descendant transactions (including this one)
→ →<br>`descendantsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool descendants (including this one)
→ →<br>`descendantfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool descendants (including this one)
→ →<br>`ancestorcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool ancestor transactions (including this one)
→ →<br>`ancestorsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool ancestors (including this one)
→ →<br>`ancestorfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool ancestors (including this one)
→ →<br>`fees` | object | Optional<br>(0 or 1) | Object containing fee information
→→→<br>`base` | number | Optional<br>(0 or 1) | Transaction fee in DASH
→→→<br>`modified` | number | Optional<br>(0 or 1) | Transaction fee with fee deltas used for mining priority in DASH
→→→<br>`ancestor` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool ancestors (including this one) in DASH
→→→<br>`descendent` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool descendants (including this one) in DASH
→ →<br>`depends` | array | Required<br>(exactly 1) | An array holding TXIDs of unconfirmed transactions this transaction depends upon (parent transactions).  Those transactions must be part of a block before this transaction can be added to a block, although all transactions may be included in the same block.  The array may be empty
→ → →<br>Depends TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions this transaction depends upon, encoded as hex in RPC byte order
→ →<br>`spentby` | array | Required<br>(exactly 1) |  **Added in Dash Core 20.0.0**<br>An array of unconfirmed transactions spending outputs from this transaction
→ → →<br>TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions spending from this transaction
→ →<br>`unbroadcast` | bool | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>True if this transaction  is currently unbroadcast (initial broadcast not yet acknowledged by any peers)
→ →<br>`instantlock` | bool | Required<br>(exactly 1) | Set to `true` if this transaction was locked via [InstantSend](../resources/glossary.md#instantsend)

*Examples from Dash Core 20.0.0*

The default (`false`):

``` bash
dash-cli getmempoolancestors c32b5d5d94a6d151b69bfd25d77e5b538dffba2445b957c81fcf9df1b90f4ba1
```

Result:

``` json
[
  "d64eb30e5435e7a4564df9d06525a8ab48858fdaf111661d1e7874a72cebc132"
]
```

Verbose output (`true`):

``` bash
dash-cli getmempoolancestors c32b5d5d94a6d151b69bfd25d77e5b538dffba2445b957c81fcf9df1b90f4ba1 true
```

Result:

``` json
{
    "177826190c3fd38a93a381a9b5ad7d955c3f2cf886f7c6f0d58647fb868cf9f5": {
    "fees": {
      "base": 0.00000226,
      "modified": 0.00000226,
      "ancestor": 0.00000226,
      "descendant": 0.00003226
    },
    "vsize": 226,
    "fee": 0.00000226,
    "modifiedfee": 0.00000226,
    "time": 1690318336,
    "height": 1909978,
    "descendantcount": 6,
    "descendantsize": 1648,
    "descendantfees": 3226,
    "ancestorcount": 1,
    "ancestorsize": 226,
    "ancestorfees": 226,
    "depends": [
    ],
    "spentby": [
      "127cfa4cd892ad78b9c1227bebfef2bb5a8a06636b659a734c0a5787004934ca"
    ],
    "instantlock": "true",
    "unbroadcast": false
  }
}
```

*See also*

* [GetMemPoolDescendants](../api/remote-procedure-calls-blockchain.md#getmempooldescendants): returns all in-mempool descendants for a transaction in the mempool.
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.

```{eval-rst}
.. _api-rpc-blockchain-getmempooldescendants:
```

## GetMemPoolDescendants

*Added in Dash Core 0.12.3*

The [`getmempooldescendants` RPC](../api/remote-procedure-calls-blockchain.md#getmempooldescendants) returns all in-mempool descendants for a transaction in the mempool.

*Parameter #1---a transaction identifier (TXID)*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string (hex) | Required<br>(exactly 1) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order

*Parameter #2---desired output format*

Name | Type | Presence | Description
--- | --- | --- | ---
Format | bool | Optional<br>(0 or 1) | Set to `true` to get json objects describing each transaction in the memory pool; set to `false` (the default) to only get an array of TXIDs

*Result---list of descendant transactions*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of TXIDs belonging to transactions in the memory pool.  The array may be empty if there are no transactions in the memory pool
→<br>TXID | string | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order

*Result (format: `true`)---a JSON object describing each transaction*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing transactions currently in the memory pool.  May be empty
→<br>TXID | string : object | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order
→ →<br>`size` | number (int) | Required<br>(exactly 1) | The size of the serialized transaction in bytes
→ →<br>`fee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee paid by the transaction in decimal bitcoins
→ →<br>`modifiedfee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee with fee deltas used for mining priority in decimal bitcoins
→ →<br>`time` | number (int) | Required<br>(exactly 1) | The time the transaction entered the memory pool, Unix epoch time format
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The block height when the transaction entered the memory pool
→ →<br>`descendantcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool descendant transactions (including this one)
→ →<br>`descendantsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool descendants (including this one)
→ →<br>`descendantfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool descendants (including this one)
→ →<br>`ancestorcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool ancestor transactions (including this one)
→ →<br>`ancestorsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool ancestors (including this one)
→ →<br>`ancestorfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool ancestors (including this one)
→ →<br>`fees` | object | Optional<br>(0 or 1) | Object containing fee information
→→→<br>`base` | number | Optional<br>(0 or 1) | Transaction fee in DASH
→→→<br>`modified` | number | Optional<br>(0 or 1) | Transaction fee with fee deltas used for mining priority in DASH
→→→<br>`ancestor` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool ancestors (including this one) in DASH
→→→<br>`descendent` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool descendants (including this one) in DASH
→ →<br>`depends` | array | Required<br>(exactly 1) | An array holding TXIDs of unconfirmed transactions this transaction depends upon (parent transactions).  Those transactions must be part of a block before this transaction can be added to a block, although all transactions may be included in the same block.  The array may be empty
→ → →<br>Depends TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions this transaction depends upon, encoded as hex in RPC byte order
→ →<br>`spentby` | array | Required<br>(exactly 1) |  **Added in Dash Core 20.0.0**<br>An array of unconfirmed transactions spending outputs from this transaction
→ → →<br>TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions spending from this transaction
→ →<br>`unbroadcast` | bool | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>True if this transaction  is currently unbroadcast (initial broadcast not yet acknowledged by any peers)
→ →<br>`instantlock` | bool | Required<br>(exactly 1) | Set to `true` if this transaction was locked via [InstantSend](../resources/glossary.md#instantsend)

*Examples from Dash Core 20.0.0*

The default (`false`):

``` bash
dash-cli getmempooldescendants 414735b9b4da8232299b25510628e321ba7d2adfb042f7c6437ad3b0f7793b80
```

Result:

``` json
[
  "94445715afd59a7ecc2fd6d62e42905194e91633e8f54b459f605fe0d780fe99"
]
```

Verbose output (`true`):

``` bash
dash-cli getmempooldescendants 414735b9b4da8232299b25510628e321ba7d2adfb042f7c6437ad3b0f7793b80 true
```

Result:

``` json
{
  "94445715afd59a7ecc2fd6d62e42905194e91633e8f54b459f605fe0d780fe99": {
    "fees": {
      "base": 0.00000225,
      "modified": 0.00000225,
      "ancestor": 0.00000450,
      "descendant": 0.00000225
    },
    "vsize": 225,
    "fee": 0.00000225,
    "modifiedfee": 0.00000225,
    "time": 1690906537,
    "height": 879144,
    "descendantcount": 1,
    "descendantsize": 225,
    "descendantfees": 225,
    "ancestorcount": 2,
    "ancestorsize": 450,
    "ancestorfees": 450,
    "depends": [
      "414735b9b4da8232299b25510628e321ba7d2adfb042f7c6437ad3b0f7793b80"
    ],
    "spentby": [
    ],
    "instantlock": "true",
    "unbroadcast": false
  }
}
```

*See also*

* [GetMemPoolAncestors](../api/remote-procedure-calls-blockchain.md#getmempoolancestors): returns all in-mempool ancestors for a transaction in the mempool.
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.

```{eval-rst}
.. _api-rpc-blockchain-getmempoolentry:
```

## GetMemPoolEntry

*Added in Dash Core 0.14.0*

The [`getmempoolentry` RPC](../api/remote-procedure-calls-blockchain.md#getmempoolentry) returns mempool data for given transaction (must be in mempool).

*Parameter #1---a transaction identifier (TXID)*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string (hex) | Required<br>(exactly 1) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order

*Result ---a JSON object describing the transaction*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing transactions currently in the memory pool.  May be empty
→<br>`vsize` | number (int) | Required<br>(exactly 1) | The virtual transaction size. This can be different from actual serialized size for high-sigop transactions.
→<br>`fee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee paid by the transaction in decimal bitcoins
→<br>`modifiedfee` | number (bitcoins) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The transaction fee with fee deltas used for mining priority in decimal bitcoins
→<br>`time` | number (int) | Required<br>(exactly 1) | The time the transaction entered the memory pool, Unix epoch time format
→<br>`height` | number (int) | Required<br>(exactly 1) | The block height when the transaction entered the memory pool
→<br>`descendantcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool descendant transactions (including this one)
→<br>`descendantsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool descendants (including this one)
→<br>`descendantfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool descendants (including this one)
→<br>`ancestorcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool ancestor transactions (including this one)
→<br>`ancestorsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool ancestors (including this one)
→<br>`ancestorfees` | number (int) | Required<br>(exactly 1) | **Deprecated in Dash Core 0.17.0**<br><br>The modified fees (see `modifiedfee` above) of in-mempool ancestors (including this one)
→ →<br>`fees` | object | Optional<br>(0 or 1) | Object containing fee information
→→→<br>`base` | number | Optional<br>(0 or 1) | Transaction fee in DASH
→→→<br>`modified` | number | Optional<br>(0 or 1) | Transaction fee with fee deltas used for mining priority in DASH
→→→<br>`ancestor` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool ancestors (including this one) in DASH
→→→<br>`descendent` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool descendants (including this one) in DASH
→<br>`depends` | array | Required<br>(exactly 1) | An array holding TXIDs of unconfirmed transactions this transaction depends upon (parent transactions).  Those transactions must be part of a block before this transaction can be added to a block, although all transactions may be included in the same block.  The array may be empty
→ →<br>Depends TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions this transaction depends upon, encoded as hex in RPC byte order
→<br>`spentby` | array | Required<br>(exactly 1) |  **Added in Dash Core 20.0.0**<br>An array of unconfirmed transactions spending outputs from this transaction
→ →<br>TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions spending from this transaction
→<br>`unbroadcast` | bool | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>True if this transaction  is currently unbroadcast (initial broadcast not yet acknowledged by any peers)
→<br>`instantlock` | bool | Required<br>(exactly 1) | Set to `true` if this transaction was locked via [InstantSend](../resources/glossary.md#instantsend)

*Example from Dash Core 20.0.0*

``` bash
dash-cli getmempoolentry 33136ead40c8ad0019be7ab8d8e430c1e336fd6f7fcfe204096c0da28d9a6225
```

Result:

``` json
{
  "fees": {
    "base": 0.00009350,
    "modified": 0.00009350,
    "ancestor": 0.00009350,
    "descendant": 0.00009350
  },
  "vsize": 374,
  "fee": 0.00009350,
  "modifiedfee": 0.00009350,
  "time": 1690317662,
  "height": 1909971,
  "descendantcount": 1,
  "descendantsize": 374,
  "descendantfees": 9350,
  "ancestorcount": 1,
  "ancestorsize": 374,
  "ancestorfees": 9350,
  "depends": [
  ],
  "spentby": [
  ],
  "instantlock": "true",
  "unbroadcast": false
}
```

*See also*

* [GetMemPoolAncestors](../api/remote-procedure-calls-blockchain.md#getmempoolancestors): returns all in-mempool ancestors for a transaction in the mempool.
* [GetMemPoolDescendants](../api/remote-procedure-calls-blockchain.md#getmempooldescendants): returns all in-mempool descendants for a transaction in the mempool.
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.

## GetMemPoolInfo

The [`getmempoolinfo` RPC](../api/remote-procedure-calls-blockchain.md#getmempoolinfo) returns information about the node's current transaction memory pool.

*Parameters: none*

*Result---information about the transaction memory pool*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing information about the memory pool
→<br>`loaded` | boolean | Required<br>(exactly 1) | True if the mempool is fully loaded
→<br>`size` | number (int) | Required<br>(exactly 1) | The number of transactions currently in the memory pool
→<br>`bytes` | number (int) | Required<br>(exactly 1) | The total number of bytes in the transactions in the memory pool
→<br>`usage` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.11.0*<br><br>Total memory usage for the mempool in bytes
`total_fee` | number (int) | Required<br>(exactly 1) | **Added in Dash Core 20.1.0**<br><br>Total fees for the mempool in DASH, ignoring fees modified through prioritizetransaction
→<br>`maxmempool` | number (int) | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>Maximum memory usage for the mempool in bytes
→<br>`mempoolminfee` | number | Required<br>(exactly 1) | *Added in Bitcoin Core 0.12.0*<br><br>The lowest fee per kilobyte paid by any transaction in the memory pool
→<br>`mempoolminfee` | number | Required<br>(exactly 1) | *Added in Dash Core 0.16.0*<br><br>Minimum fee rate in DASH/kB for tx to be accepted. Is the maximum of minrelaytxfee and minimum mempool fee
→<br>`minrelaytxfee` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 20.0.0*<br><br>Current minimum relay fee for transactions
→<br>`instantsendlocks` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 0.15.0*<br><br>Number of InstantSend locked transactions not yet in a block
→<br>`unbroadcastcount` | number (int) | Required<br>(exactly 1) | *Added in Dash Core 20.0.0*<br><br>Current number of transactions that haven't passed initial broadcast yet

*Example from Dash Core 20.1.0*

``` bash
dash-cli -testnet getmempoolinfo
```

Result:

``` json

{
  "loaded": true,
  "size": 3,
  "bytes": 1116,
  "usage": 5072,
  "total_fee": 0.00001116,
  "maxmempool": 300000000,
  "mempoolminfee": 0.00001000,
  "minrelaytxfee": 0.00001000,
  "instantsendlocks": 3,
  "unbroadcastcount": 0
}
```

*See also*

* [GetBlockChainInfo](../api/remote-procedure-calls-blockchain.md#getblockchaininfo): provides information about the current state of the block chain.
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.
* [GetTxOutSetInfo](../api/remote-procedure-calls-blockchain.md#gettxoutsetinfo): returns statistics about the confirmed unspent transaction output (UTXO) set. Note that this call may take some time and that it only counts outputs from confirmed transactions---it does not count outputs from the memory pool.

```{eval-rst}
.. _api-rpc-blockchain-getrawmempool:
```

## GetRawMemPool

The [`getrawmempool` RPC](../api/remote-procedure-calls-blockchain.md#getrawmempool) returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object.

*Parameter #1---verbose*

Name | Type | Presence | Description
--- | --- | --- | ---
Format | bool | Optional<br>(0 or 1) | Set to `true` to get verbose output describing each transaction in the memory pool; set to `false` (the default) to only get an array of TXIDs for transactions in the memory pool

*Parameter #2---mempool sequence*

Name | Type | Presence | Description
--- | --- | --- | ---
Format | bool | Optional<br>(0 or 1) | If verbose=false, returns a json object with transaction list and mempool sequence number attached.

*Result (format `false`)---an array of TXIDs*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of TXIDs belonging to transactions in the memory pool.  The array may be empty if there are no transactions in the memory pool
→<br>TXID | string | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order
→<br>mempool_sequence | number (int) | Optional<br>(0 or 1) | *Added in Dash Core 22.0.0*<br>The mempool sequence value

*Result (format: `true`)---a JSON object describing each transaction*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A object containing transactions currently in the memory pool.  May be empty
→<br>TXID | string : object | Optional<br>(0 or more) | The TXID of a transaction in the memory pool, encoded as hex in RPC byte order
→ →<br>`size` | number (int) | Required<br>(exactly 1) | The size of the serialized transaction in bytes
→ →<br>`fee` | amount (Dash) | Required<br>(exactly 1) | *Deprecated in Dash Core 0.17.0*<br>The transaction fee paid by the transaction in decimal Dash
→ →<br>`modifiedfee` | amount (Dash) | Required<br>(exactly 1) | *Deprecated in Dash Core 0.17.0*<br>The transaction fee with fee deltas used for mining priority in decimal Dash
→ →<br>`time` | number (int) | Required<br>(exactly 1) | The time the transaction entered the memory pool, Unix epoch time format
→ →<br>`height` | number (int) | Required<br>(exactly 1) | The block height when the transaction entered the memory pool
→ →<br>`descendantcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool descendant transactions (including this one)
→ →<br>`descendantsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool descendants (including this one)
→ →<br>`descendantfees` | number (int) | Required<br>(exactly 1) | *Deprecated in Dash Core 0.17.0*<br>The modified fees (see `modifiedfee` above) of in-mempool descendants (including this one)
→ →<br>`ancestorcount` | number (int) | Required<br>(exactly 1) | The number of in-mempool ancestor transactions (including this one)
→ →<br>`ancestorsize` | number (int) | Required<br>(exactly 1) | The size of in-mempool ancestors (including this one)
→ →<br>`ancestorfees` | number (int) | Required<br>(exactly 1) | *Deprecated in Dash Core 0.17.0*<br>The modified fees (see `modifiedfee` above) of in-mempool ancestors (including this one)
→ →<br>`fees` | object | Optional<br>(0 or 1) | Object containing fee information
→→→<br>`base` | number | Optional<br>(0 or 1) | Transaction fee in DASH
→→→<br>`modified` | number | Optional<br>(0 or 1) | Transaction fee with fee deltas used for mining priority in DASH
→→→<br>`ancestor` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool ancestors (including this one) in DASH
→→→<br>`descendent` | number | Optional<br>(0 or 1) | Modified fees (see above) of in-mempool descendants (including this one) in DASH
→ →<br>`depends` | array | Required<br>(exactly 1) | An array holding TXIDs of unconfirmed transactions this transaction depends upon (parent transactions).  Those transactions must be part of a block before this transaction can be added to a block, although all transactions may be included in the same block.  The array may be empty
→ → →<br>Depends TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions this transaction depends upon, encoded as hex in RPC byte order
→ →<br>`spentby` | array | Required<br>(exactly 1) | An array of unconfirmed transactions spending outputs from this transaction
→ → →<br>TXID | string | Optional (0 or more) | The TXIDs of any unconfirmed transactions spending from this transaction
→ →<br>`unbroadcast` | bool | Required<br>(exactly 1) | **Added in Dash Core 20.0.0**<br>True if this transaction  is currently unbroadcast (initial broadcast not yet acknowledged by any peers)
→ →<br>`instantlock` | bool | Required<br>(exactly 1) | *Added in Dash Core 0.12.3*<br><br>Set to `true` for locked [InstantSend](../resources/glossary.md#instantsend) transactions (masternode quorum has locked the transaction inputs via `isdlock` message). Set to `false` if the masternodes have not approved the [InstantSend](../resources/glossary.md#instantsend) transaction

*Examples from Dash Core 20.0.0*

The default (`false`):

``` bash
dash-cli getrawmempool
```

Result:

``` json
[
  "16f9a964f1bafbf2a745c2add0da31330b2ee521c2d411416d59c25343b9fb92",
  "664e9ca96802ec014469e0d2c34cc7c7e49c4a5a72613614ee97ebd193104376",
  "bbbfff097dff060a44622d6569c6f11d13ec29d3c204318ec2c2b8bf5b888487",
  "9e6cd0b8feb804b796a6a74e12c45d93c1ea39d3fd205b463e26c70f7f2063e9",
  "d541e8776b42ab9dc9a722bf38f99f0b38be0325193ebaf1576119e3dbc00a49",
  "4d1d77c26cf1184ff26d27cbbc78f95eada99965920c6bceeb508194bb7217e2",
  "e1eafdf61c1062a8e82fd6c42baa0a95f24b8f75fb81db94c4b9e41afc0405d2",
  "f4696ff8a75a0235fe7c9062a895a6e364fd7b3941b41a66efa513176bf3cb21",
  "8614e7a3f4208f69823f09e02c66a22813cac8de7bc05828c3847e39c6d8e323",
  "b8c9eea215addedd8f162e6c4881dd74a14dbd05c820d5149e29990ee5b869dd",
  "0a8ccaf37b2652b6ac400922be8cd4ea91267d19ec8e11e20f848d8e62bdef77",
  "bc0b7a1d1ee9976652949ef014637d107e8154d00484c62fc3a69cc004367244",
  "5446f81969179087b5b490d20b156d13a9d63d7a6d9f618ccda903722b0dab34",
  "50caf79821d946b46db0bb64d0e9d354680ce2b94257d5c7a28a1f65fefde226",
  "76e018d092d1cd8c4e2074ef6225e38f1d7cc5264980b0d1b5e484f944affa06",
  "b86f0408ae8c3126da6458df0c64b1bf19c2f512b40e5811b3130c9fecbc316d",
  "52d8e1ea95fcb1b9156ec7ff2ab82ae3e3040cf8328f86b4d96974990527cd90",
  "43619b452edc8647cbfe740b55a0c8f9716f6bd6bb258b3c7cb6e0be204a57d3",
  "a77d001facacf7d00b2721d246b6790c12018e6e89d6cd543478a84e63bb498a",
  "e4a409ee2fbb94925bdea0fa5a3040550fa85063c6343fba3c7b88122fba365f"
]
```

Verbose output (`true`):

``` bash
dash-cli getrawmempool true
```

Result:

``` json
"0994e854166beb6f15630e7b5aba0ef0e57b2a7235957bcbb8000c09449e9eba": {
    "fees": {
      "base": 0.00000225,
      "modified": 0.00000225,
      "ancestor": 0.00000225,
      "descendant": 0.00000225
    },
    "vsize": 225,
    "fee": 0.00000225,
    "modifiedfee": 0.00000225,
    "time": 1690318205,
    "height": 1909975,
    "descendantcount": 1,
    "descendantsize": 225,
    "descendantfees": 225,
    "ancestorcount": 1,
    "ancestorsize": 225,
    "ancestorfees": 225,
    "depends": [
    ],
    "spentby": [
    ],
    "instantlock": "false",
    "unbroadcast": false
  }
```

*See also*

* [GetMemPoolInfo](../api/remote-procedure-calls-blockchain.md#getmempoolinfo): returns information about the node's current transaction memory pool.
* [GetMemPoolEntry](../api/remote-procedure-calls-blockchain.md#getmempoolentry): returns mempool data for given transaction (must be in mempool).
* [GetTxOutSetInfo](../api/remote-procedure-calls-blockchain.md#gettxoutsetinfo): returns statistics about the confirmed unspent transaction output (UTXO) set. Note that this call may take some time and that it only counts outputs from confirmed transactions---it does not count outputs from the memory pool.

## GetMerkleBlocks

*Added in Dash Core 0.15.0*

The [`getmerkleblocks` RPC](../api/remote-procedure-calls-blockchain.md#getmerkleblocks) returns an array of hex-encoded merkleblocks for <count> blocks starting from <hash> which match <filter>.

*Parameter #1---filter*

Name | Type | Presence | Description
--- | --- | --- | ---
filter | string | Required<br>(exactly 1) | The hex encoded bloom filter

*Parameter #2---hash*

Name | Type | Presence | Description
--- | --- | --- | ---
hash | string | Required<br>(exactly 1) | The block hash

*Parameter #3---count*

Name | Type | Presence | Description
--- | --- | --- | ---
count | number (int) | Optional<br>Default/max=2000 |

*Result---the list of merkleblocks*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array of merkleblocks
→<br>Merkle Block | string (hex) | Optional<br>(1 or more) | A serialized, hex-encoded merkleblock

*Example from Dash Core 0.15.0*

``` bash
dash-cli getmerkleblocks \
  "2303028005802040100040000008008400048141010000f8400420800080025004000004130000000000000001" \
  "00000000007e1432d2af52e8463278bf556b55cf5049262f25634557e2e91202"
  2000
```

Result (truncated):

``` json
[
  "000000202c...aefc440107",
  "0000002058...9a17830103"
]
```

*See also: none*

## GetSpecialTxes

*Added in Dash Core 0.13.1*

The [`getspecialtxes` RPC](../api/remote-procedure-calls-blockchain.md#getspecialtxes) returns an array of special transactions found in the specified block

*Parameter #1---Block hash*

Name | Type | Presence | Description
--- | --- | --- | ---
`blockhash` | string | Required<br>(exactly 1) | The block hash.

*Parameter #2---Special transaction type*

Name | Type | Presence | Description
--- | --- | --- | ---
type | int | Optional<br>(0 or 1) | Filter special txes by type, -1 means all types (default: -1)

*Parameter #3---Result limit*

Name | Type | Presence | Description
--- | --- | --- | ---
count | int | Optional<br>(0 or 1) | The number of transactions to return (default: 10)

*Parameter #4---Results to skip*

Name | Type | Presence | Description
--- | --- | --- | ---
skip | int | Optional<br>(0 or 1) | The number of transactions to skip (default: 0)

*Parameter #5---Verbosity*

Name | Type | Presence | Description
--- | --- | --- | ---
verbosity | int | Optional<br>(0 or 1) | 0 for hashes, 1 for hex-encoded data, and 2 for JSON object<br>(default: 0)

*Result (if `verbosity` was `0`)---An array of transaction IDs*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex): array | Required<br>(exactly 1) | Array of special transaction hashes

*Result (if `verbosity` was `1`)---An array of serialized transactions*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex): array | Required<br>(exactly 1) | Array of serialized, hex-encoded data for the special transaction(s)

*Result (if `verbosity` was `2`)---An array of JSON objects*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string (hex): array of ojbects | Required<br>(exactly 1) | Array of special transaction objects in the format of the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction)

*Example from Dash Core 0.13.1*

List of Special Transactions hashes.

``` bash
dash-cli -testnet getspecialtxes \
0000003db0006ecaccdf5ae2cfa9d94406ef40ff65b9ec34668b87fca3da9226
```

Result:

``` json
[
  "1572a15f56307e413afe3cb7ea0017a1a3fd6d89c6c5f258cc17b2888a8e7fff",
  "89a6dc42063e4a792ec225db64dd9426742a5d1738e8821625d2ab920a6187b2",
  "fa3b3b0d3522becb02ddd15dd075f3d6ecc6a5a50b43c6c9f6d4703a9a8509d5"
]
```

List of Provider Registration Special Transactions (type: 1) in serialized, hex-encoded format.

``` bash
dash-cli -testnet getspecialtxes \
0000003db0006ecaccdf5ae2cfa9d94406ef40ff65b9ec34668b87fca3da9226 1 10 0 1
```

Result:

``` json
[
  "0300010001ea721d7420a9b58025894d08f9fecc73b7b87ed09277fa99dad5aa028ea357e1000000006b48304502210093c409672eed335f80630d7108c108d0b85ebe4d8be0758f8a3745f617c4b57302203175063605552c89f6de7f3dadc1773d5ef773b7cc0ccf98e6c5555ea75ba307012102b21d19fec95d9863c5b12fafeb60530e1cfc51d83f49ea9bca7192abb8b83e46feffffff01c4bb609a010000001976a9142efe9f9d3b36b133364d3cccbd27db75a0fbdcb788ac00000000fd120101000000000031567fbaf591ae9d2d0e9050bebce6a311cfd900616f851a3a630aa65e53f6940000000000000000000000000000ffffad3d1ee74a43c1ad3af209f75deaeb9216fc8339fd48d376f9b007ffa44583c9908f4aaca8dd97990c56043e475723f90940ef5fd7d493152540f25f58fb8c965ee5e1be4f850a661476c1ad3af209f75deaeb9216fc8339fd48d376f9b0e8031976a91454bbd7bd7c21553612d60ab16579e51efbcb135288acc281e8bf5a0dd22dfc9f1edeef9ef248f965a79210d997da37fb3e1dec76d1a4412096809bc005c860a0215cb008e3044b972688443b0b7a31ac5a04b728e63b1b5c5489e33dd666435f93c646523ad8a1d935a58957026749cbd0a9bf7e09a77388",
  "03000100012354b77c0f261f3d5b8424cbe67c2f27130f01c531732a08b8ae3f28aaa1b1fb000000006a473044022058323d3d9114492a7a7d350d5e3127d2dc550563968319987079c98f19ed519202204160cfe81adf1f41301136a3cbe03697baa1b14c3103b66bd839ace503dbf2630121026f83a8dad6b4695b136c399405b31d4031fd6631c469673d71eda479157ef9dcfeffffff0106b8609a010000001976a9142a855dc127bfdd5cc0ab73b71ff126e49aa409c488ac00000000fd1201010000000000b60dcb8bab5aba47435942c36ca4ee74ea5b662f4d7c7b528ce341915b2d5aec0100000000000000000000000000ffffad3d1ee74a428d3433cb6b9a1a29fdf07613172bbfdab744889689e308c9d2d8a3cb35f9d7bb7220b1eca82c952b82111119670dacae18a509628c775287e4e796128cd6379b80dffd7d8d3433cb6b9a1a29fdf07613172bbfdab744889610271976a91454bbd7bd7c21553612d60ab16579e51efbcb135288ac512010a2b992d7d5c1e1f999852855cc55162800025cfdf3b56c74e4734a2d97411f858532607cbd8848452dab1f216650def1d11a5abf3fa464c9ffcc7fec894a012a4b70ee5d3b983b5fe640f04a7f3e4fe67fbb5b7cccb71afa37888ad6cca48e"
]
```

List of Coinbase Special Transactions (type: 5) in JSON format.

``` bash
dash-cli -testnet getspecialtxes \
00000000007b0fb99e36713cf08012482478ee496e6dcb4007ad2e806306e62b 5 10 0 2
```

Result:

``` json
[
  {
    "txid": "25632685ed0d7286901a80961c924c1ddd952e764754dbd8b40d0956413c8b56",
    "size": 229,
    "version": 3,
    "type": 5,
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
          "reqSigs": 1,
          "type": "pubkeyhash",
          "addresses": [
            "yeuGUfPMrbEqAS2Pw1wonYgEPbM4LAA9LK"
          ]
        }
      },
      {
        "value": 8.10000000,
        "valueSat": 810000000,
        "n": 1,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 88a060bc2dfe05780ae4dcb6c98b12436c35a939 OP_EQUALVERIFY OP_CHECKSIG",
          "hex": "76a91488a060bc2dfe05780ae4dcb6c98b12436c35a93988ac",
          "reqSigs": 1,
          "type": "pubkeyhash",
          "addresses": [
            "yYmrsYP3XYMZr1cGtha3QzmuNB1C7CfyhV"
          ]
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
    "instantlock": false,
    "chainlock": false
  }
]
```

*See also:*

* [GetRawTransaction](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction): gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so the RPC may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings.

## GetSpentInfo

:::{note}
Requires `spentindex` Dash Core command-line/configuration-file parameter to be enabled.
:::

*Added in Dash Core 0.12.1*

The [`getspentinfo` RPC](../api/remote-procedure-calls-blockchain.md#getspentinfo) returns the txid and index where an output is spent (requires `spentindex` to be enabled).

*Parameter #1---the TXID of the output*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string (hex) | Required<br>(exactly 1) | The TXID of the transaction containing the relevant output, encoded as hex in RPC byte order

*Parameter #2---the start block height*

Name | Type | Presence | Description
--- | --- | --- | ---
Index | number (int) | Required<br>(exactly 1) | The block height to begin looking in

*Result---the TXID and spending input index*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | Information about the spent output.  If output wasn't found or if an error occurred, this will be JSON `null`
→<br>`txid` | string | Required<br>(exactly 1) | The output txid
→<br>`index` | number | Required<br>(exactly 1) | The spending input index

*Example from Dash Core 0.12.2*

Get the txid and index where an output is spent:

``` bash
dash-cli getspentinfo \
  '''
    {
      "txid": "0456aaf51a8df21dd47c2a06ede046a5bf7403bcb95d14d1d71b178c189fb933", \
      "index": 0
    }
  '''
```

Result:

``` json
{
  "txid": "14e874421350840e9d43965967c5a989e7d41ad361ef37484ee67d01d433ecfa",
  "index": 1,
  "height": 7742
}
```

*See also: none*

## GetTxOut

The [`gettxout` RPC](../api/remote-procedure-calls-blockchain.md#gettxout) returns details about an unspent transaction output (UTXO).

*Parameter #1---the TXID of the output to get*

Name | Type | Presence | Description
--- | --- | --- | ---
TXID | string (hex) | Required<br>(exactly 1) | The TXID of the transaction containing the output to get, encoded as hex in RPC byte order

*Parameter #2---the output index number (vout) of the output to get*

Name | Type | Presence | Description
--- | --- | --- | ---
Vout | number (int) | Required<br>(exactly 1) | The output index number (vout) of the output within the transaction; the first output in a transaction is vout 0

*Parameter #3---whether to display unconfirmed outputs from the memory pool*

Name | Type | Presence | Description
--- | --- | --- | ---
Unconfirmed | bool | Optional<br>(0 or 1) | Set to `true` to display unconfirmed outputs from the memory pool; set to `false` (the default) to only display outputs from confirmed transactions

*Result---a description of the output*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | Information about the output.  If output wasn't found, if it was spent, or if an error occurred, this will be JSON `null`
→<br>`bestblock` | string (hex) | Required<br>(exactly 1) | The hash of the header of the block on the local best block chain which includes this transaction.  The hash will encoded as hex in RPC byte order.  If the transaction is not part of a block, the string will be empty
→<br>`confirmations` | number (int) | Required<br>(exactly 1) | The number of confirmations received for the transaction containing this output or `0` if the transaction hasn't been confirmed yet
→<br>`value` | number (Dash) | Required<br>(exactly 1) | The amount of Dash spent to this output.  May be `0`
→<br>`scriptPubKey` | string : object | Optional<br>(0 or 1) | An object with information about the pubkey script.  This may be `null` if there was no pubkey script
→ →<br>`asm` | string | Required<br>(exactly 1) | The pubkey script in decoded form with non-data-pushing opcodes listed
→ →<br>`hex` | string (hex) | Required<br>(exactly 1) | The pubkey script encoded as hex
→ →<br>`reqSigs` | number (int) | Optional<br>(0 or 1) | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The number of signatures required; this is always `1` for P2PK, P2PKH, and P2SH (including P2SH multisig because the redeem script is not available in the pubkey script).  It may be greater than 1 for bare multisig.  This value will not be returned for `nulldata` or `nonstandard` script types (see the `type` key below)
→ →<br>`type` | string | Optional<br>(0 or 1) | The type of script.  This will be one of the following:<br>• `pubkey` for a P2PK script<br>• `pubkeyhash` for a P2PKH script<br>• `scripthash` for a P2SH script<br>• `multisig` for a bare multisig script<br>• `nulldata` for nulldata scripts<br>• `nonstandard` for unknown scripts
→ →<br>`address` | string | Optional<br>(0 or 1) | Dash address (only if a well-defined address exists)
→ →<br>`addresses` | string : array | Optional<br>(0 or 1) | **Deprecated in Dash Core 21.0.0** (returned only if config option -deprecatedrpc=addresses is passed)<br><br>The P2PKH or P2SH addresses used in this transaction, or the computed P2PKH address of any pubkeys in this transaction.  This array will not be returned for `nulldata` or `nonstandard` script types
→ → →<br>Address | string | Required<br>(1 or more) | A P2PKH or P2SH address
→<br>`coinbase` | bool | Required<br>(exactly 1) | Set to `true` if the transaction output belonged to a coinbase transaction; set to `false` for all other transactions.  Coinbase transactions need to have 101 confirmations before their outputs can be spent

*Example from Dash Core 0.15.0*

Get the UTXO from the following transaction from the first output index ("0"),
searching the memory pool if necessary.

``` bash
dash-cli -testnet gettxout \
  e0a06b47f0de6f3851a228d5ac377ac38b495adf04298c43e951e679c5b0aa8f \
  0 true
```

Result:

``` json
{
  "bestblock": "000000005651f6d7859793dee07d476a2f2a7338e66bbb41caf4b544c5b0318d",
  "confirmations": 2,
  "value": 25.00000000,
  "scriptPubKey": {
    "asm": "OP_DUP OP_HASH160 b66266c5017a759817f3bb99e8d9124bf5bb2e74 OP_EQUALVERIFY OP_CHECKSIG",
    "hex": "76a914b66266c5017a759817f3bb99e8d9124bf5bb2e7488ac",
    "type": "pubkeyhash",
    "address": "ycwoiAibTjpwnoCZSX7S4kiB2H8wULw9qo"
  },
  "coinbase": false
}
```

*See also*

* [GetRawTransaction](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction): gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so the RPC may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings.
* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction.

## GetTxOutProof

The [`gettxoutproof` RPC](../api/remote-procedure-calls-blockchain.md#gettxoutproof) returns a hex-encoded proof that one or more specified transactions were included in a block.

NOTE: By default this function only works when there is an
unspent output in the UTXO set for this transaction. To make it always work,
you need to maintain a transaction index, using the `-txindex` command line option, or
specify the block in which the transaction is included in manually (by block header hash).

*Parameter #1---the transaction hashes to prove*

Name | Type | Presence | Description
--- | --- | --- | ---
TXIDs | array | Required<br>(exactly 1) | A JSON array of txids to filter
→<br>`txid` | string | Required<br>(1 or more) | TXIDs of the transactions to generate proof for.  All transactions must be in the same block

*Parameter #2---the block to look for txids in*

Name | Type | Presence | Description
--- | --- | --- | ---
Header hash | string | Optional<br>(0 or 1) | If specified, looks for txid in the block with this hash

*Result---serialized, hex-encoded data for the proof*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string | Required<br>(exactly 1) | A string that is a serialized, hex-encoded data for the proof

*Example from Dash Core 0.12.2*

Get the hex-encoded proof that "txid" was included in block 000000012d774f3c7668f32bc448efeb93b317f312dd863679de3a007d47817f:

``` bash
dash-cli gettxoutproof \
  '''
    [
      "e0a06b47f0de6f3851a228d5ac377ac38b495adf04298c43e951e679c5b0aa8f"
    ]
  ''' \
  '000000012d774f3c7668f32bc448efeb93b317f312dd863679de3a007d47817f'
```

Result (wrapped):

``` text
01000020ed72cc6a7294782a7711d8fa7ef74716ef062dc50bb0820f7eec923801000000\
aa5d17c5128043803b67c7ab03e4d3ffbc9604b54f877f1c5cf9ed3adeaa19b2cd7ed659\
f838011d10a70a480200000002033c89c2baecba9fc983c85dcf365c2d9cc93aca1dee2e\
5ac18124464056542e8faab0c579e651e9438c2904df5a498bc37a37acd528a251386fde\
f0476ba0e00105
```

*See also*

* [VerifyTxOutProof](../api/remote-procedure-calls-blockchain.md#verifytxoutproof): verifies that a proof points to one or more transactions in a block, returning the transactions the proof commits to and throwing an RPC error if the block is not in our best block chain.
* [`merkleblock` message](../reference/p2p-network-data-messages.md#merkleblock): A description of the
  format used for the proof.

## GetTxOutSetInfo

The [`gettxoutsetinfo` RPC](../api/remote-procedure-calls-blockchain.md#gettxoutsetinfo) returns statistics about the confirmed unspent transaction output (UTXO) set. Note that this call may take some time and that it only counts outputs from confirmed transactions---it does not count outputs from the memory pool.

*Parameter #1---Selecting UTXO set hash*

Name | Type | Presence | Description
--- | --- | --- | ---
hash_type | string | Optional<br>(0 or 1) | Which UTXO set hash should be calculated. Options: 'hash_serialized_2' (the legacy algorithm), 'muhash', 'none'.

*Result---statistics about the UTXO set*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | Information about the UTXO set
→<br>`height` | number (int) | Required<br>(exactly 1) | The height of the local best block chain.  A new node with only the hardcoded genesis block will have a height of 0
→<br>`bestblock` | string (hex) | Required<br>(exactly 1) | The hash of the header of the highest block on the local best block chain, encoded as hex in RPC byte order
→<br>`transactions` | number (int) | Required<br>(exactly 1) | The number of transactions with unspent outputs
→<br>`txouts` | number (int) | Required<br>(exactly 1) | The number of unspent transaction outputs
→<br>`bogosize` | number (int) | Required<br>(exactly 1) | A meaningless metric for UTXO set size
→<br>`hash_serialized_2` | string (hex) | Optional<br>(exactly 1) |  The serialized hash (only present if 'hash_serialized_2' hash_type is chosen)
→<br>`muhash` | string (hex) | Optional<br>(exactly 1) | A SHA256(SHA256()) The serialized hash (only present if 'muhash' hash_type is chosen).
→<br>`disk_size` | number (int) | Required<br>(exactly 1) | The estimated size of the chainstate on disk
→<br>`total_amount` | number (Dash) | Required<br>(exactly 1) | The total amount of Dash in the UTXO set

*Example from Dash Core 0.15.0*

``` bash
dash-cli -testnet gettxoutsetinfo
```

Result:

``` json
{
  "height": 159358,
  "bestblock": "0000000000a705ef74a1fc134ea1eba49af8eead40b3df1fc4fb40f5940a0d60",
  "transactions": 187542,
  "txouts": 366996,
  "bogosize": 28344374,
  "hash_serialized_2": "d7326bdc2d9cb7d91580bfd47d6c2972ab1776c2c33c787873a5fd01986c9377",
  "disk_size": 21513509,
  "total_amount": 7517185.08574437
}
```

*See also*

* [GetBlockChainInfo](../api/remote-procedure-calls-blockchain.md#getblockchaininfo): provides information about the current state of the block chain.
* [GetMemPoolInfo](../api/remote-procedure-calls-blockchain.md#getmempoolinfo): returns information about the node's current transaction memory pool.

## PreciousBlock

*Added in Dash Core 0.12.3 / Bitcoin Core 0.14.0*

The [`preciousblock` RPC](../api/remote-procedure-calls-blockchain.md#preciousblock) treats a block as if it were received before others with the same work. A later `preciousblock` call can override the effect of an earlier one. The effects of `preciousblock` are not retained across restarts.

*Parameter #1---the block hash*

Name | Type | Presence | Description
--- | --- | --- | ---
Header Hash | string (hex) | Required<br>(exactly 1) | The hash of the block to mark as precious

*Result---`null` or error on failure*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | null | Required<br>(exactly 1) | JSON `null`.  The JSON-RPC error field will be set only if you entered an invalid block hash

*Example from Dash Core 0.12.3*

``` bash
dash-cli preciousblock 00000000034d77e287b63922a94f12e8c4ab9e\
1d8056060fd51f6153ea5dc757
```

Result (no output from `dash-cli` because result is set to `null`).

## PruneBlockChain

*Added in Dash Core 0.12.3 / Bitcoin Core 0.14.0*

The [`pruneblockchain` RPC](../api/remote-procedure-calls-blockchain.md#pruneblockchain) prunes the blockchain up to a specified height or timestamp. The `-prune` option needs to be enabled (disabled by default).

*Parameter #1---the block height or timestamp*

Name | Type | Presence | Description
--- | --- | --- | ---
Height | number (int) | Required<br>(exactly 1) | The block height to prune up to. May be set to a particular height, or a unix timestamp to prune blocks whose block time is at least 2 hours older than the provided timestamp

*Result---the height of the last block pruned*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | number (int) | Required<br>(exactly 1) | The height of the last block pruned

*Example from Dash Core 0.12.3*

``` bash
dash-cli pruneblockchain 413555
```

Result:

``` text
413555
```

*See also*

* [ImportPrunedFunds](../api/remote-procedure-calls-wallet.md#importprunedfunds): imports funds without the need of a rescan. Meant for use with pruned wallets.

## SaveMemPool

The [`savemempool` RPC](../api/remote-procedure-calls-blockchain.md#savemempool) dumps the mempool to disk.

*Parameters: none*

*Result---output filename*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object/null | Required<br>(exactly 1) | An object containing the filename the mempool was saved to
→<br>`filename` | string | Required<br>(exactly 1) | The directory and file where the mempool was saved

*Example from Dash Core 22.0.0*

``` bash
dash-cli savemempool
```

Result:

```json
{
  "filename": "/home/phez/.dashcore/testnet3/mempool.dat"
}
```

*See also: none*

## VerifyChain

The [`verifychain` RPC](../api/remote-procedure-calls-blockchain.md#verifychain) verifies each entry in the local block chain database.

*Parameter #1---how thoroughly to check each block*

Name | Type | Presence | Description
--- | --- | --- | ---
Check Level | number (int) | Optional<br>(0 or 1) | How thoroughly to check each block, from 0 to 4.  Default is the level set with the `-checklevel` command line argument; if that isn't set, the default is `3`.  Each higher level includes the tests from the lower levels<br><br>Levels are:<br>**0.** Read from disk to ensure the files are accessible<br>**1.**  Ensure each block is valid<br>**2.** Make sure undo files can be read from disk and are in a valid format<br>**3.** Test each block undo to ensure it results in correct state<br>**4.** After undoing blocks, reconnect them to ensure they reconnect correctly

*Parameter #2---the number of blocks to check*

Name | Type | Presence | Description
--- | --- | --- | ---
Number Of Blocks | number (int) | Optional<br>(0 or 1) | The number of blocks to verify.  Set to `0` to check all blocks.  Defaults to the value of the `-checkblocks` command-line argument; if that isn't set, the default is `288`

*Result---verification results*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | bool | Required<br>(exactly 1) | Set to `true` if verified; set to `false` if verification failed for any reason

*Example from Dash Core 0.12.2*

Verify the most recent 400 blocks in the most through way:

``` bash
dash-cli -testnet verifychain 4 400
```

Result (took < 1 second on a mobile workstation; it would've taken much longer on mainnet):

``` json
true
```

*See also*

* [GetBlockChainInfo](../api/remote-procedure-calls-blockchain.md#getblockchaininfo): provides information about the current state of the block chain.
* [GetTxOutSetInfo](../api/remote-procedure-calls-blockchain.md#gettxoutsetinfo): returns statistics about the confirmed unspent transaction output (UTXO) set. Note that this call may take some time and that it only counts outputs from confirmed transactions---it does not count outputs from the memory pool.

## VerifyTxOutProof

The [`verifytxoutproof` RPC](../api/remote-procedure-calls-blockchain.md#verifytxoutproof) verifies that a proof points to one or more transactions in a block, returning the transactions the proof commits to and throwing an RPC error if the block is not in our best block chain.

*Parameter #1---The hex-encoded proof generated by gettxoutproof*

Name | Type | Presence | Description
--- | --- | --- | ---
`proof` | string | Required | A hex-encoded proof

*Result---txid(s) which the proof commits to*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string | Required<br>(exactly 1) | The txid(s) which the proof commits to, or empty array if the proof cannot be validated

*Example from Dash Core 0.12.2*

Verify a proof:

``` bash
dash-cli verifytxoutproof \
01000020ed72cc6a7294782a7711d8fa7ef74716ef062dc50bb0820f7eec923801000000\
aa5d17c5128043803b67c7ab03e4d3ffbc9604b54f877f1c5cf9ed3adeaa19b2cd7ed659\
f838011d10a70a480200000002033c89c2baecba9fc983c85dcf365c2d9cc93aca1dee2e\
5ac18124464056542e8faab0c579e651e9438c2904df5a498bc37a37acd528a251386fde\
f0476ba0e00105
```

Result:

``` json
[
"e0a06b47f0de6f3851a228d5ac377ac38b495adf04298c43e951e679c5b0aa8f"
]
```

*See also*

* [GetTxOutProof](../api/remote-procedure-calls-blockchain.md#gettxoutproof): returns a hex-encoded proof that one or more specified transactions were included in a block.
* [`merkleblock` message](../reference/p2p-network-data-messages.md#merkleblock): A description of the format used for the proof.
