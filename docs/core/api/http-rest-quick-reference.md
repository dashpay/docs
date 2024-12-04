# Quick Reference

* [GET Block](../api/http-rest-requests.md#get-block) gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block. _Updated in Bitcoin Core 0.13.0_
* [GET Block/NoTxDetails](../api/http-rest-requests.md#get-blocknotxdetails) gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block.  The JSON object includes TXIDs for transactions within the block rather than the complete transactions [GET block](../api/http-rest-requests.md#get-block) returns. _Updated in Bitcoin Core 0.13.0_
* [GET BlockHashByHeight](../api/http-rest-requests.md#get-blockhashbyheight) returns the hash of a block in best-block-chain at the height provided. The hash can be returned as a JSON object or serialized as binary or hex. _Added in Dash Core 18.0.0_
* [GET ChainInfo](../api/http-rest-requests.md#get-chaininfo) returns information about the current state of the block chain. _Updated in Bitcoin Core 0.12.0_
* [GET GetUtxos](../api/http-rest-requests.md#get-getutxos) returns an UTXO set given a set of outpoints. _New in Bitcoin Core 0.11.0_
* [GET Headers](../api/http-rest-requests.md#get-headers) returns a specified amount of block headers in upward direction. _Updated in Bitcoin Core 0.13.0_
* [GET MemPool/Contents](../api/http-rest-requests.md#get-mempoolcontents) returns all transaction in the memory pool with detailed information. _New in Bitcoin Core 0.12.0_
* [GET MemPool/Info](../api/http-rest-requests.md#get-mempoolinfo) returns information about the node's current transaction memory pool. _New in Bitcoin Core 0.12.0_
* [GET Tx](../api/http-rest-requests.md#get-tx) gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so this method may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings. _Updated in Bitcoin Core 0.13.0_
