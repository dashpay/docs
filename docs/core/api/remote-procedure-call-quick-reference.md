```{eval-rst}
.. _api-rpc-quick-reference:
.. meta::
  :title: Remote Procedure Call Quick Reference
  :description: A quick reference guide for all the RPCs in Dash.
```

# Quick Reference

## [Addressindex RPCs](../api/remote-procedure-calls-address-index.md)

These RPCs are all Dash-specific and not found in Bitcoin Core

* [GetAddressBalance](../api/remote-procedure-calls-address-index.md#getaddressbalance): returns the balance for address(es).
* [GetAddressDeltas](../api/remote-procedure-calls-address-index.md#getaddressdeltas): returns all changes for an address.
* [GetAddressMempool](../api/remote-procedure-calls-address-index.md#getaddressmempool): returns all mempool deltas for an address.
* [GetAddressTxids](../api/remote-procedure-calls-address-index.md#getaddresstxids): returns the txids for an address(es).
* [GetAddressUtxos](../api/remote-procedure-calls-address-index.md#getaddressutxos): returns all unspent outputs for an address.

## [Blockchain RPCs](../api/remote-procedure-calls-blockchain.md)

* [GetBestBlockHash](../api/remote-procedure-calls-blockchain.md#getbestblockhash): returns the header hash of the most recent block on the best block chain.
* [DumpTxOutset](../api/remote-procedure-calls-blockchain.md#dumptxoutset): Write the serialized UTXO set to disk. _New in Dash Core 18.1.0_
* [GetBestChainLock](../api/remote-procedure-calls-blockchain.md#getbestchainlock): returns the block hash of the best chainlock. _New in Dash Core 0.15.0_
* [GetBlock](../api/remote-procedure-calls-blockchain.md#getblock): gets a block with a particular header hash from the local block database either as a JSON object or as a serialized block. **_Updated in Dash Core 21.0.0_**
* [GetBlockChainInfo](../api/remote-procedure-calls-blockchain.md#getblockchaininfo): provides information about the current state of the block chain. **_Updated in Dash Core 21.0.0_**
* [GetBlockCount](../api/remote-procedure-calls-blockchain.md#getblockcount): returns the number of blocks in the local best block chain.
* [GetBlockFilter](../api/remote-procedure-calls-blockchain.md#getblockfilter): retrieves a [BIP157](https://github.com/bitcoin/bips/blob/master/bip-0157.mediawiki) content filter for a particular block. _New in Dash Core 18.0.0_
* [GetBlockFromPeer](../api/remote-procedure-calls-blockchain.md#getblockfrompeer): attempts to fetch a specific block from a given peer. **Updated in Dash Core 22.0.0**
* [GetBlockHash](../api/remote-procedure-calls-blockchain.md#getblockhash): returns the header hash of a block at the given height in the local best block chain.
* [GetBlockHashes](../api/remote-procedure-calls-blockchain.md#getblockhashes): returns array of hashes of blocks within the timestamp range provided (requires `timestampindex` to be enabled). New in Dash Core 0.12.1
* [GetBlockHeader](../api/remote-procedure-calls-blockchain.md#getblockheader): gets a block header with a particular header hash from the local block database either as a JSON object or as a serialized block header. _Updated in Dash Core 0.16.0_
* [GetBlockHeaders](../api/remote-procedure-calls-blockchain.md#getblockheaders): returns an array of items with information about the requested number of blockheaders starting from the requested hash. New in Dash Core 0.12.1
* [GetBlockStats](../api/remote-procedure-calls-blockchain.md#getblockstats): computes per block statistics for a given window. _Updated in Dash Core 18.0.0_
* [GetChainTips](../api/remote-procedure-calls-blockchain.md#getchaintips): returns information about the highest-height block (tip) of each local block chain. _Updated in Dash Core 0.12.3_
* [GetChainTxStats](../api/remote-procedure-calls-blockchain.md#getchaintxstats): compute statistics about the total number and rate of transactions in the chain. _Updated in Dash Core 18.0.0_
* [GetDifficulty](../api/remote-procedure-calls-blockchain.md#getdifficulty): returns the proof-of-work difficulty as a multiple of the minimum difficulty.
* [GetMemPoolAncestors](../api/remote-procedure-calls-blockchain.md#getmempoolancestors): returns all in-mempool ancestors for a transaction in the mempool. _Updated in Dash Core 20.0.0_
* [GetMemPoolDescendants](../api/remote-procedure-calls-blockchain.md#getmempooldescendants): returns all in-mempool descendants for a transaction in the mempool. _Updated in Dash Core 20.0.0_
* [GetMemPoolEntry](../api/remote-procedure-calls-blockchain.md#getmempoolentry): returns mempool data for given transaction (must be in mempool). _Updated in Dash Core 20.0.0_
* [GetMemPoolInfo](../api/remote-procedure-calls-blockchain.md#getmempoolinfo): returns information about the node's current transaction memory pool. _Updated in Dash Core 20.1.0_
* [GetRawMemPool](../api/remote-procedure-calls-blockchain.md#getrawmempool): returns all transaction identifiers (TXIDs) in the memory pool as a JSON array, or detailed information about each transaction in the memory pool as a JSON object. **Updated in Dash Core 22.0.0**
* [GetMerkleBlocks](../api/remote-procedure-calls-blockchain.md#getmerkleblocks): returns an array of hex-encoded merkleblocks for <count> blocks starting from <hash> which match <filter>. _New in Dash Core 0.15.0_
* [GetSpecialTxes](../api/remote-procedure-calls-blockchain.md#getspecialtxes): returns an array of special transactions found in the specified block _New in Dash Core 0.13.1_
* [GetSpentInfo](../api/remote-procedure-calls-blockchain.md#getspentinfo): returns the txid and index where an output is spent (requires `spentindex` to be enabled). New in Dash Core 0.12.1
* [GetTxOut](../api/remote-procedure-calls-blockchain.md#gettxout): returns details about an unspent transaction output (UTXO). **_Updated in Dash Core 21.0.0_**
* [GetTxOutProof](../api/remote-procedure-calls-blockchain.md#gettxoutproof): returns a hex-encoded proof that one or more specified transactions were included in a block.
* [GetTxOutSetInfo](../api/remote-procedure-calls-blockchain.md#gettxoutsetinfo): returns statistics about the confirmed unspent transaction output (UTXO) set. Note that this call may take some time and that it only counts outputs from confirmed transactions---it does not count outputs from the memory pool. _Updated in Dash Core 18.1.0_
* [PreciousBlock](../api/remote-procedure-calls-blockchain.md#preciousblock): treats a block as if it were received before others with the same work. _New in Dash Core 0.12.3_
* [PruneBlockChain](../api/remote-procedure-calls-blockchain.md#pruneblockchain): prunes the blockchain up to a specified height or timestamp. _New in Dash Core 0.12.3_
* [SaveMemPool](../api/remote-procedure-calls-blockchain.md#savemempool): dumps the mempool to disk. **Updated in Dash Core 22.0.0**
* [VerifyChain](../api/remote-procedure-calls-blockchain.md#verifychain): verifies each entry in the local block chain database.
* [VerifyTxOutProof](../api/remote-procedure-calls-blockchain.md#verifytxoutproof): verifies that a proof points to one or more transactions in a block, returning the transactions the proof commits to and throwing an RPC error if the block is not in our best block chain.

## [Control RPCs](../api/remote-procedure-calls-control.md)

* [Debug](../api/remote-procedure-calls-control.md#debug): changes the debug category from the console. _Updated in Dash Core 18.0.0_
* [GetMemoryInfo](../api/remote-procedure-calls-control.md#getmemoryinfo): returns information about memory usage. _Updated in Dash Core 0.15.0_
* [GetRPCInfo](../api/remote-procedure-calls-control.md#getrpcinfo): returns details about the RPC server. _New in Dash Core 18.0.0_
* [Help](../api/remote-procedure-calls-control.md#help): lists all available public RPC commands, or gets help for the specified RPC.  Commands which are unavailable will not be listed, such as wallet RPCs if wallet support is disabled. _Updated in Dash Core 0.17.0_
* [Logging](../api/remote-procedure-calls-control.md#logging): gets and sets the logging configuration _Updated in Dash Core 18.0.0_
* [Stop](../api/remote-procedure-calls-control.md#stop): safely shuts down the Dash Core server.
* [Uptime](../api/remote-procedure-calls-control.md#uptime): returns the total uptime of the server. _New in Dash Core 0.15.0_

## [Dash RPCs](../api/remote-procedure-calls-dash.md)

* [CoinJoin](../api/remote-procedure-calls-dash.md#coinjoin): controls the CoinJoin process. _Updated in Dash Core 0.12.3_
* [CoinJoinSalt](../api/remote-procedure-calls-dash.md#coinjoinsalt): controls the CoinJoin salt used in the process. It allows you to generate, retrieve, or set the salt. **Added in Dash Core 22.0.0**
* [GetCoinJoinInfo](../api/remote-procedure-calls-dash.md#getcoinjoininfo): returns an object containing an information about CoinJoin settings and state. **Updated in Dash Core 22.0.0**
* [GetGovernanceInfo](../api/remote-procedure-calls-dash.md#getgovernanceinfo): returns an object containing governance parameters. _Updated in Dash Core 20.0.0_
* [GetSuperblockBudget](../api/remote-procedure-calls-dash.md#getsuperblockbudget): returns the absolute maximum sum of superblock payments allowed.
* [GObject](../api/remote-procedure-calls-dash.md#gobject): provides a set of commands for managing governance objects and displaying information about them. _Updated in Dash Core 20.0.0_
* [Masternode](../api/remote-procedure-calls-dash.md#masternode): provides a set of commands for managing masternodes and displaying information about them. **Updated in Dash Core 22.0.0**
* [MasternodeList](../api/remote-procedure-calls-dash.md#masternodelist): returns a list of masternodes in different modes. _Updated in Dash Core 20.0.0_
* [MnSync](../api/remote-procedure-calls-dash.md#mnsync): returns the sync status, updates to the next step or resets it entirely. _Updated in Dash Core 0.14.0_
* [Spork](../api/remote-procedure-calls-dash.md#spork): shows information about the current state of sporks. _Updated in Dash Core 18.1.0_
* [SporkUpdate](../api/remote-procedure-calls-dash.md#sporkupdate): updates the value of the provided spork. _New in Dash Core 18.1.0_
* [VoteRaw](../api/remote-procedure-calls-dash.md#voteraw): compiles and relays a governance vote with provided external signature instead of signing vote internally

## [Evolution RPCs](../api/remote-procedure-calls-evo.md)

* [BLS](../api/remote-procedure-calls-evo.md#bls): provides a set of commands to execute BLS-related actions. _Updated in Dash Core 19.0.0_
* [ProTx](../api/remote-procedure-calls-evo.md#protx): provides a set of commands to execute ProTx related actions. _Updated in Dash Core 20.1.0_
* [Quorum](../api/remote-procedure-calls-evo.md#quorum): provides a set of commands for quorums (LLMQs). **Updated in Dash Core 22.0.0**
* [SubmitChainLock](../api/remote-procedure-calls-evo.md#submitchainlock): allows the submission of a ChainLock signature. _New in Dash Core 20.1.0_
* [VerifyChainLock](../api/remote-procedure-calls-evo.md#verifychainlock): tests if a quorum signature is valid for a ChainLock. _New in Dash Core 0.17.0_
* [VerifyISLock](../api/remote-procedure-calls-evo.md#verifyislock): tests if a quorum signature is valid for an InstantSend lock. _New in Dash Core 0.17.0_

## [Generating RPCs](../api/remote-procedure-calls-generating.md)

* [GenerateBlock](../api/remote-procedure-calls-generating.md#generateblock) mines a block with a set of ordered transactions immediately to a specified address or descriptor (before the RPC call returns). _New in Dash Core 18.1.0_
* [GenerateToAddress](../api/remote-procedure-calls-generating.md#generatetoaddress): mines blocks immediately to a specified address. _New in Dash Core 0.12.3_
* [GenerateToDescriptor](../api/remote-procedure-calls-generating.md#generatetodescriptor): mines blocks immediately to a specified descriptor. _New in Dash Core 18.1.0_

## [Mining RPCs](../api/remote-procedure-calls-mining.md)

* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software. _Updated in Dash Core 20.0.0_
* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information. _Updated in Dash Core 18.0.0_
* [GetNetworkHashPS](../api/remote-procedure-calls-mining.md#getnetworkhashps): returns the estimated network hashes per second based on the last n blocks.
* [PrioritiseTransaction](../api/remote-procedure-calls-mining.md#prioritisetransaction): adds virtual priority or fee to a transaction, allowing it to be accepted into blocks mined by this node (or miners which use this node) with a lower priority or fee. (It can also remove virtual priority or fee, requiring the transaction have a higher priority or fee to be accepted into a locally-mined block.) _Updated in Dash Core 0.14.0_
* [SubmitBlock](../api/remote-procedure-calls-mining.md#submitblock): accepts a block, verifies it is a valid addition to the block chain, and broadcasts it to the network. Extra parameters are ignored by Dash Core but may be used by mining pools or other programs.
* [SubmitHeader](../api/remote-procedure-calls-mining.md#submitheader): decodes the given hex data as a header and submits it as a candidate chain tip if valid. _New in Dash Core 18.0.0_

## [Network RPCs](../api/remote-procedure-calls-network.md)

* [AddNode](../api/remote-procedure-calls-network.md#addnode): attempts to add or remove a node from the addnode list, or to try a connection to a node once. **Updated in Dash Core 22.0.0**
* [AddPeerAddress](../api/remote-procedure-calls-network.md#addpeeraddress): adds the address of a potential peer to the address manager. **Updated in Dash Core 22.0.0**
* [ClearBanned](../api/remote-procedure-calls-network.md#clearbanned): clears list of banned nodes.
* [ClearDiscouraged](../api/remote-procedure-calls-network.md#cleardiscouraged): clears all discouraged nodes. _New in Dash Core 19.0.0_
* [DisconnectNode](../api/remote-procedure-calls-network.md#disconnectnode): immediately disconnects from a specified node. _Updated in Dash Core 0.15.0_
* [GetAddedNodeInfo](../api/remote-procedure-calls-network.md#getaddednodeinfo): returns information about the given added node, or all added nodes (except onetry nodes). Only nodes which have been manually added using the [`addnode` RPC](../api/remote-procedure-calls-network.md#addnode) will have their information displayed. **_Updated in Dash Core 21.0.0_**
* [GetConnectionCount](../api/remote-procedure-calls-network.md#getconnectioncount): returns the number of connections to other nodes.
* [GetNetTotals](../api/remote-procedure-calls-network.md#getnettotals): returns information about network traffic, including bytes in, bytes out, and the current time.
* [GetNetworkInfo](../api/remote-procedure-calls-network.md#getnetworkinfo): returns information about the node's connection to the network. **_Updated in Dash Core 21.0.0_**
* [GetNodeAddresses](../api/remote-procedure-calls-network.md#getnodeaddresses): returns the known addresses which can potentially be used to find new nodes in the network. **_Updated in Dash Core 21.0.0_**
* [GetPeerInfo](../api/remote-procedure-calls-network.md#getpeerinfo): returns data about each connected network node. **Updated in Dash Core 22.0.0**
* [ListBanned](../api/remote-procedure-calls-network.md#listbanned): lists all banned IPs/Subnets. **_Updated in Dash Core 21.0.0_**
* [Ping](../api/remote-procedure-calls-network.md#ping): sends a P2P ping message to all connected nodes to measure ping time. Results are provided by the [`getpeerinfo` RPC](../api/remote-procedure-calls-network.md#getpeerinfo) pingtime and pingwait fields as decimal seconds. The P2P [`ping` message](../reference/p2p-network-control-messages.md#ping) is handled in a queue with all other commands, so it measures processing backlog, not just network ping.
* [SetBan](../api/remote-procedure-calls-network.md#setban): attempts add or remove a IP/Subnet from the banned list.
* [SetNetworkActive](../api/remote-procedure-calls-network.md#setnetworkactive): disables/enables all P2P network activity.

## [Raw Transaction RPCs](../api/remote-procedure-calls-raw-transactions.md)

* [AnalyzePSBT](../api/remote-procedure-calls-raw-transactions.md#analyzepsbt): analyzes and provides information about the current status of a PSBT and its inputs. _New in Dash Core 18.2.0_
* [CombinePSBT](../api/remote-procedure-calls-raw-transactions.md#combinepsbt): combines multiple partially-signed Dash transactions into one transaction. _New in Dash Core 18.0.0_
* [CombineRawTransaction](../api/remote-procedure-calls-raw-transactions.md#combinerawtransaction): combine multiple partially signed transactions into one transaction. _New in Dash Core 0.15.0_
* [ConvertToPSBT](../api/remote-procedure-calls-raw-transactions.md#converttopsbt): converts a network serialized transaction to a PSBT. _New in Dash Core 18.0.0_
* [CreatePSBT](../api/remote-procedure-calls-raw-transactions.md#createpsbt): creates a transaction in the Partially Signed Transaction (PST) format. _New in Dash Core 18.0.0_
* [GetAssetUnlockStatuses](../api/remote-procedure-calls-raw-transactions.md#getassetunlockstatuses): returns the status of the provided Asset Unlock indexes at the tip of the chain or at a particular block height if specified. _New in Dash Core 20.1.0_
* [CreateRawTransaction](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction): creates an unsigned serialized transaction that spends a previous output to a new output with a P2PKH or P2SH address. The transaction is not stored in the wallet or transmitted to the network. _Updated in Dash Core 0.17.0_
* [DecodePSBT](../api/remote-procedure-calls-raw-transactions.md#decodepsbt): returns a JSON object representing the serialized, base64-encoded partially signed Dash transaction. _New in Dash Core 18.0.0_
* [DecodeRawTransaction](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction): decodes a serialized transaction hex string into a JSON object describing the transaction. **_Updated in Dash Core 21.0.0_**
* [DecodeScript](../api/remote-procedure-calls-raw-transactions.md#decodescript): decodes a hex-encoded P2SH redeem script. **_Updated in Dash Core 21.0.0_**
* [FinalizePSBT](../api/remote-procedure-calls-raw-transactions.md#finalizepsbt): finalizes the inputs of a PSBT. The PSBT produces a network serialized transaction if the transaction is fully signed. _New in Dash Core 18.0.0_
* [FundRawTransaction](../api/remote-procedure-calls-raw-transactions.md#fundrawtransaction): adds inputs to a transaction until it has enough in value to meet its out value. **_Updated in Dash Core 21.0.0_**
* [GetRawTransaction](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction): gets a hex-encoded serialized transaction or a JSON object describing the transaction. By default, Dash Core only stores complete transaction data for UTXOs and your own transactions, so the RPC may fail on historic transactions unless you use the non-default `txindex=1` in your Dash Core startup settings. **_Updated in Dash Core 21.0.0_**
* [GetRawTransactionMulti](../api/remote-procedure-calls-raw-transactions.md#getrawtransactionmulti): gets hex-encoded serialized transactions or a JSON object describing the multiple transactions. _New in Dash Core 20.1.0_
* [GetTxChainlocks](../api/remote-procedure-calls-raw-transactions.md#gettxchainlocks): returns the block height each transaction was mined at and whether it is ChainLocked or not. _Updated in Dash Core 20.1.0_
* [JoinPSBTs](../api/remote-procedure-calls-raw-transactions.md#joinpsbts): joins multiple distinct PSBTs with different inputs and outputs into one PSBT with inputs and outputs from all of the PSBTs.
* [SendRawTransaction](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction): validates a transaction and broadcasts it to the peer-to-peer network. _Updated in Dash Core 0.15.0_
* [SignRawTransactionWithKey](../api/remote-procedure-calls-raw-transactions.md#signrawtransactionwithkey): signs a transaction in the serialized transaction format using private keys provided in the call. _New in Dash Core 0.17.0_
* [TestMempoolAccept](../api/remote-procedure-calls-raw-transactions.md#testmempoolaccept): returns the results of mempool acceptance tests indicating if raw transaction (serialized, hex-encoded) would be accepted by mempool. _Updated in Dash Core 20.1.0_
* [UTXOUpdatePSBT](../api/remote-procedure-calls-raw-transactions.md#testmempoolaccept): updates a PSBT with data from output descriptors, UTXOs retrieved from the UTXO set or the mempool. _Updated in Dash Core 18.1.0_

## [Utility RPCs](../api/remote-procedure-calls-util.md)

* [CreateMultiSig](../api/remote-procedure-calls-util.md#createmultisig): creates a P2SH multi-signature address. _Updated in Dash Core 20.0.0_
* [DeriveAddresses](../api/remote-procedure-calls-util.md#deriveaddresses): derives one or more addresses corresponding to an output descriptor. _Updated in Dash Core 18.1.0_
* [EstimateSmartFee](../api/remote-procedure-calls-util.md#estimatesmartfee): estimates the transaction fee per kilobyte that needs to be paid for a transaction to begin confirmation within a certain number of blocks and returns the number of blocks for which the estimate is valid. _Updated in Dash Core 0.15.0_
* [GetDescriptorInfo](../api/remote-procedure-calls-util.md#getdescriptorinfo): analyses a descriptor. _New in Dash Core 18.0.0_
* [GetIndexInfo](../api/remote-procedure-calls-util.md#getindexinfo): returns the status of one or all available indices currently running in the node. _New in Dash Core 20.0.0_
* [SignMessageWithPrivKey](../api/remote-procedure-calls-util.md#signmessagewithprivkey): signs a message with a given private key.  _New in Dash Core 0.12.3_
* [ValidateAddress](../api/remote-procedure-calls-util.md#validateaddress): returns information about the given Dash address. _Updated in Dash Core 20.1.0_
* [VerifyMessage](../api/remote-procedure-calls-util.md#verifymessage): verifies a signed message.

## [Wallet RPCs](../api/remote-procedure-calls-wallet.md)

**Note:** the wallet RPCs are only available if Dash Core was built with [wallet support](../resources/glossary.md#wallet-support), which is the default.

* [AbandonTransaction](../api/remote-procedure-calls-wallet.md#abandontransaction): marks an in-wallet transaction and all its in-wallet descendants as abandoned. This allows their inputs to be respent.
* [AbortRescan](../api/remote-procedure-calls-wallet.md#abortrescan): stops current wallet rescan. _New in Dash Core 0.15.0_
* [AddMultiSigAddress](../api/remote-procedure-calls-wallet.md#addmultisigaddress): adds a P2SH multisig address to the wallet. _Updated in Dash Core 20.0.0_
* [BackupWallet](../api/remote-procedure-calls-wallet.md#backupwallet): safely copies `wallet.dat` to the specified file, which can be a directory or a path with filename.
* [CreateWallet](../api/remote-procedure-calls-wallet.md#createwallet): creates and loads a new wallet. **_Updated in Dash Core 21.0.0_**
* [DumpHDInfo](../api/remote-procedure-calls-wallet.md#dumphdinfo): returns an object containing sensitive private info about this HD wallet New in Dash Core 0.12.2
* [DumpPrivKey](../api/remote-procedure-calls-wallet.md#dumpprivkey): returns the wallet-import-format (WIP) private key corresponding to an address. (But does not remove it from the wallet.)
* [DumpWallet](../api/remote-procedure-calls-wallet.md#dumpwallet): creates or overwrites a file with all wallet keys in a human-readable format. _Updated in Dash Core 0.17.0_
* [EncryptWallet](../api/remote-procedure-calls-wallet.md#encryptwallet): encrypts the wallet with a passphrase.  This is only to enable encryption for the first time. After encryption is enabled, you will need to enter the passphrase to use private keys.
* [GetAddressInfo](../api/remote-procedure-calls-wallet.md#getaddressinfo): returns information about the given Dash address. **_Updated in Dash Core 21.0.0_**
* [GetAddressesByLabel](../api/remote-procedure-calls-wallet.md#getaddressesbylabel): returns a list of every address assigned to a particular label. _New in Dash Core 0.17.0_
* [GetBalance](../api/remote-procedure-calls-wallet.md#getbalance): gets the balance in decimal dash across all accounts or for a particular account. _Updated in Dash Core 18.1.0_
* [GetBalances](../api/remote-procedure-calls-wallet.md#getbalances): returns an object with all balances denominated in DASH. _Updated in Dash Core 18.2.0_
* [GetNewAddress](../api/remote-procedure-calls-wallet.md#getnewaddress): returns a new Dash address for receiving payments. If an account is specified, payments received with the address will be credited to that account. _Updated in Dash Core 0.17.0_
* [GetRawChangeAddress](../api/remote-procedure-calls-wallet.md#getrawchangeaddress): returns a new Dash address for receiving change. This is for use with raw transactions, not normal use.
* [GetReceivedByAddress](../api/remote-procedure-calls-wallet.md#getreceivedbyaddress): returns the total amount received by the specified address in transactions with the specified number of confirmations. It does not count coinbase transactions. _Updated in Dash Core 0.13.0_
* [GetReceivedByLabel](../api/remote-procedure-calls-wallet.md#getreceivedbylabel): returns the list of addresses assigned the specified label. _New in Dash Core 0.17.0_
* [GetTransaction](../api/remote-procedure-calls-wallet.md#gettransaction): gets detailed information about an in-wallet transaction. _Updated in Dash Core 20.0.0_
* [GetUnconfirmedBalance](../api/remote-procedure-calls-wallet.md#getunconfirmedbalance): returns the wallet's total unconfirmed balance.
* [GetWalletInfo](../api/remote-procedure-calls-wallet.md#getwalletinfo): provides information about the wallet.  _Updated in Dash Core 20.0.0_
* [ImportAddress](../api/remote-procedure-calls-wallet.md#importaddress): adds an address or pubkey script to the wallet without the associated private key, allowing you to watch for transactions affecting that address or pubkey script without being able to spend any of its outputs.
* [ImportElectrumWallet](../api/remote-procedure-calls-wallet.md#importelectrumwallet): imports keys from an Electrum wallet export file (.csv or .json) New in Dash Core 0.12.1
* [ImportDescriptors](../api/remote-procedure-calls-wallet.md#importdescriptors): imports multiple descriptors into the wallet. **_New in Dash Core 21.0.0_**
* [ImportMulti](../api/remote-procedure-calls-wallet.md#importmulti): imports addresses or scripts (with private keys, public keys, or P2SH redeem scripts) and optionally performs the minimum necessary rescan for all imports. _New in Dash Core 0.12.3_
* [ImportPrivKey](../api/remote-procedure-calls-wallet.md#importprivkey): adds a private key to your wallet. The key should be formatted in the wallet import format created by the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey).
* [ImportPrunedFunds](../api/remote-procedure-calls-wallet.md#importprunedfunds): imports funds without the need of a rescan. Meant for use with pruned wallets. _New in Dash Core 0.12.3_
* [ImportPubKey](../api/remote-procedure-calls-wallet.md#importpubkey): imports a public key (in hex) that can be watched as if it were in your wallet but cannot be used to spend
* [ImportWallet](../api/remote-procedure-calls-wallet.md#importwallet): imports private keys from a file in wallet dump file format (see the [`dumpwallet` RPC](../api/remote-procedure-calls-wallet.md#dumpwallet)). These keys will be added to the keys currently in the wallet.  This call may need to rescan all or parts of the block chain for transactions affecting the newly-added keys, which may take several minutes.
* [KeyPoolRefill](../api/remote-procedure-calls-wallet.md#keypoolrefill): fills the cache of unused pre-generated keys (the keypool).
* [ListAddressBalances](../api/remote-procedure-calls-wallet.md#listaddressbalances): lists addresses of this wallet and their balances _New in Dash Core 0.12.3_
* [ListAddressGroupings](../api/remote-procedure-calls-wallet.md#listaddressgroupings): lists groups of addresses that may have had their common ownership made public by common use as inputs in the same transaction or from being used as change from a previous transaction. _Updated in Dash Core 0.17.0_
* [ListDescriptors](../api/remote-procedure-calls-wallet.md#listdescriptors): lists descriptors imported into a descriptor-enabled wallet. **_New in Dash Core 21.0.0_**
* [ListLabels](../api/remote-procedure-calls-wallet.md#listlabels): returns the list of all labels, or labels that are assigned to addresses with a specific purpose. _New in Dash Core 0.17.0_
* [ListLockUnspent](../api/remote-procedure-calls-wallet.md#listlockunspent): returns a list of temporarily unspendable (locked) outputs.
* [ListReceivedByAddress](../api/remote-procedure-calls-wallet.md#listreceivedbyaddress): lists the total number of dash received by each address. _Updated in Dash Core 0.17.0_
* [ListReceivedByLabel](../api/remote-procedure-calls-wallet.md#listreceivedbylabel): lists the total number of dash received by each label. _New in Dash Core 0.17.0_
* [ListSinceBlock](../api/remote-procedure-calls-wallet.md#listsinceblock): gets all transactions affecting the wallet which have occurred since a particular block, plus the header hash of a block at a particular depth. _Updated in Dash Core 20.0.0_
* [ListTransactions](../api/remote-procedure-calls-wallet.md#listtransactions): returns the most recent transactions that affect the wallet. _Updated in Dash Core 20.0.0_
* [ListUnspent](../api/remote-procedure-calls-wallet.md#listunspent): returns an array of unspent transaction outputs belonging to this wallet. _Updated in Dash Core 18.1.0_
* [ListWalletDir](../api/remote-procedure-calls-wallet.md#listwalletdir): returns a list of wallets in the wallet directory. _New in Dash Core 18.0.0_
* [ListWallets](../api/remote-procedure-calls-wallet.md#listwallets): returns a list of currently loaded wallets. _New in Dash Core 0.15.0_
* [LoadWallet](../api/remote-procedure-calls-wallet.md#loadwallet): loads a wallet from a wallet file or directory. _Updated in Dash Core 18.1.0_
* [LockUnspent](../api/remote-procedure-calls-wallet.md#lockunspent): temporarily locks or unlocks specified transaction outputs. A locked transaction output will not be chosen by automatic coin selection when spending dash. Locks are stored in memory only, so nodes start with zero locked outputs and the locked output list is always cleared when a node stops or fails.
* [RemovePrunedFunds](../api/remote-procedure-calls-wallet.md#removeprunedfunds): deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds. _New in Dash Core 0.12.3_
* [RescanBlockChain](../api/remote-procedure-calls-wallet.md#rescanblockchain): rescans the local blockchain for wallet related transactions. _New in Dash Core 0.16.0_
* [ScanTxOutset](../api/remote-procedure-calls-wallet.md#scantxoutset): scans the unspent transaction output set for entries that match certain output descriptors. _New in Dash Core 18.0.0_
* [Send](../api/remote-procedure-calls-wallet.md#send): sends a transaction with specified outputs. **Updated in Dash Core 22.0.0**
* [SendMany](../api/remote-procedure-calls-wallet.md#sendmany): creates and broadcasts a transaction which sends outputs to multiple addresses. **Updated in Dash Core 22.0.0**
* [SendToAddress](../api/remote-procedure-calls-wallet.md#sendtoaddress): spends an amount to a given address. **Updated in Dash Core 22.0.0**
* [SetHDSeed](../api/remote-procedure-calls-wallet.md#sethdseed): sets or generates a new HD wallet seed **_New in Dash Core 21.0.0_**
* [SetLabel](../api/remote-procedure-calls-wallet.md#setlabel): sets the label associated with the given address.
* [SetCoinJoinAmount](../api/remote-procedure-calls-wallet.md#setcoinjoinamount): sets the amount of DASH to be processed _New in Dash Core 0.13.0_
* [SetCoinJoinRounds](../api/remote-procedure-calls-wallet.md#setcoinjoinrounds): sets the number of rounds to use _New in Dash Core 0.13.0_
* [SetTxFee](../api/remote-procedure-calls-wallet.md#settxfee): sets the transaction fee per kilobyte paid by transactions created by this wallet.
* [SetWalletFlag](../api/remote-procedure-calls-wallet.md#setwalletflag): changes the state of the given wallet flag for a wallet.
* [SignMessage](../api/remote-procedure-calls-wallet.md#signmessage): signs a message with the private key of an address.
* [SignRawTransactionWithWallet](../api/remote-procedure-calls-wallet.md#signrawtransactionwithwallet): signs a transaction in the serialized transaction format using private keys found in the wallet. _New in Dash Core 0.17.0_
* [UnloadWallet](../api/remote-procedure-calls-wallet.md#unloadwallet): unloads the wallet referenced by the request endpoint otherwise unloads the wallet specified in the argument. _Updated in Dash Core 20.0.0_
* [UpgradeToHD](../api/remote-procedure-calls-wallet.md#upgradetohd): upgrades non-HD wallets to HD. _New in Dash Core 0.17.0_
* [UpgradeWallet](../api/remote-procedure-calls-wallet.md#upgradewallet): upgrades wallet version. **_Updated in Dash Core 21.0.0_**
* [WalletCreateFundedPSBT](../api/remote-procedure-calls-wallet.md#walletcreatefundedpsbt): creates and funds a transaction in the Partially Signed Transaction (PST) format. Inputs will be added if supplied inputs are not enough. **_Updated in Dash Core 21.0.0_**
* [WalletLock](../api/remote-procedure-calls-wallet.md#walletlock): removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call `walletpassphrase` again before being able to call any methods which require the wallet to be unlocked.
* [WalletPassphrase](../api/remote-procedure-calls-wallet.md#walletpassphrase): stores the wallet decryption key in memory for the indicated number of seconds. Issuing the `walletpassphrase` command while the wallet is already unlocked will set a new unlock time that overrides the old one.
* [WalletPassphraseChange](../api/remote-procedure-calls-wallet.md#walletpassphrasechange): changes the wallet passphrase from 'old passphrase' to 'new passphrase'.
* [WalletProcessPSBT](../api/remote-procedure-calls-wallet.md#walletprocesspsbt): updates a PSBT with input information from a wallet and then allows the signing of inputs. _Updated in Dash Core 18.2.0_
* [WipeWalletTxes](../api/remote-procedure-calls-wallet.md#wipewallettxes): wipes wallet transactions. _New in Dash Core 19.3.0_

## [Wallet RPCs (Deprecated)](../api/remote-procedure-calls-wallet-deprecated.md)

**Note:** the wallet RPCs are only available if Dash Core was built with [wallet support](../resources/glossary.md#wallet-support), which is the default.

## [ZeroMQ (ZMQ) RPCs](../api/remote-procedure-calls-zmq.md)

* [GetZmqNotifications](../api/remote-procedure-calls-zmq.md#getzmqnotifications): returns information about the active ZeroMQ notifications. _Updated in Dash Core 18.0.0_

## [Removed RPCs](../api/remote-procedure-calls-removed.md)

* [GObject vote-conf](../api/remote-procedure-calls-removed.md#gobject-vote-conf): **was removed in Dash Core 20.0.0**
* [Protx Register HPMN](../api/remote-procedure-calls-evo.md#protx-register-evo): **was removed in Dash Core 22.0.0**
* [Protx Register Fund HPMN](../api/remote-procedure-calls-evo.md#protx-register-fund-evo): **was removed in Dash Core 22.0.0**
* [Protx Register Prepare HPMN](../api/remote-procedure-calls-evo.md#protx-register-prepare-evo): **was removed in Dash Core 22.0.0**
* [Protx Update Service HPMN](../api/remote-procedure-calls-evo.md#protx-update-service-evo): **was removed in Dash Core 22.0.0**
