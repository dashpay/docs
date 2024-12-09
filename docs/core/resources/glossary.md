```{eval-rst}
.. _resources-glossary:
```

# Glossary

## 51 percent attack

The ability of someone controlling a majority of network hash rate to revise transaction history and prevent new transactions from confirming.

## Address

A 20-byte hash formatted using base58check to produce either a P2PKH or P2SH Dash address. Currently the most common way users exchange payment information.

## Base58

The method used in Dash for converting 160-bit hashes into P2PKH and P2SH addresses. Also used in other parts of Dash, such as encoding private keys for backup in WIP format. Not the same as other base58 implementations.

## Base58check

The method used in Dash for converting 160-bit hashes into P2PKH and P2SH addresses. Also used in other parts of Dash, such as encoding private keys for backup in WIP format. Not the same as other base58 implementations.

## BIP32

The Hierarchical Deterministic (HD) key creation and transfer protocol (BIP32), which allows creating child keys from parent keys in a hierarchy. Wallets using the HD protocol are called HD wallets.

## BIP70 payment protocol

The protocol defined in BIP70 (and other BIPs) which lets spenders get signed payment details from receivers.

## Block

One or more transactions prefaced by a block header and protected by proof of work. Blocks are the data stored on the block chain.

## Block chain

A chain of blocks with each block referencing the block that preceded it. The most-difficult-to-recreate chain is the best block chain.

## Block header

An 80-byte header belonging to a single block which is hashed repeatedly to create proof of work.

## Block height

The number of blocks preceding a particular block on a block chain. For example, the genesis block has a height of zero because zero block preceded it.

## Block reward

The amount that miners may claim as a reward for creating a block. Equal to the sum of the [block subsidy](#block-subsidy) (newly available duffs) plus the transactions fees paid by transactions included in the block.

## Block subsidy

The amount of new Dash created in each block. It comprises the non-fee part of the [block reward](#block-reward).

## Block size limit

The maximum size in bytes that the consensus rules allow a block to be. The current block size limit is 2000000 bytes.

## Blocks-first sync

Synchronizing the block chain by downloading each block from a peer and then validating it.

## blocktransactions

A P2P Networking data structure used to provide some of the transactions in a block as requested.

## blocktransactionsrequest

A P2P Networking data structure used to list transaction indexes in a block being requested by a peer.

## Bloom filter

A filter used primarily by SPV clients to request only matching transactions and merkle blocks from full nodes.

## Chain code

In HD wallets, 256 bits of entropy added to the public and private keys to help them generate secure child keys; the master chain code is usually derived from a seed along with the master private key

## ChainLock

ChainLocks are a feature enabling near instant consensus on the valid chain. ChainLocks use Long-Living Masternode Quorums to sign mined blocks. This mitigates 51 percent attacks and reduces uncertainty when receiving funds.

See also:

* [ChainLocks (Core Guide)](../guide/dash-features-chainlocks.md)
* [ChainLocks Overview (User docs)](chainlocks)
* [DIP-8: ChainLocks](https://github.com/dashpay/dips/blob/master/dip-0008.md)
* [ChainLock integration developer info](integration-chainlocks)

## Change output

An output in a transaction which returns duffs to the spender, thus preventing too much of the input value from going to transaction fees.

## Child key

In HD wallets, a key derived from a parent key. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Child pays for parent

Selecting transactions for mining not just based on their fees but also based on the fees of their ancestors (parents) and descendants (children).

## Child private key

In HD wallets, a key derived from a parent key. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Child public key

In HD wallets, a key derived from a parent key. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Coinbase

A special field used as the sole input for coinbase transactions. The coinbase allows claiming the block reward and provides up to 100 bytes for arbitrary data.

## Coinbase block height

The current block's height encoded into the first bytes of the coinbase field.

## Coinbase transaction

The first transaction in a block. Always created by a miner, it includes a single coinbase.

## CoinJoin

A masternode managed, decentralized [CoinJoin](https://en.bitcoin.it/wiki/CoinJoin) service for creating an on-demand system of removing the history from coins on the network. CoinJoin processes inputs while allowing each participant to retain control of their coins at all times so the process can be done without trusting a third party.

## CompactSize

A type of variable-length integer commonly used in the Dash P2P protocol and Dash serialized data structures.

## Compressed public key

An ECDSA public key that is 33 bytes long rather than the 65 bytes of an uncompressed public key.

## Confirmations

A score indicating the number of blocks on the best block chain that would need to be modified to remove or modify a particular transaction. A confirmed transaction has a confirmation score of one or higher.

## Consensus

When several nodes (usually most nodes on the network) all have the same blocks in their locally-validated best block chain.

## Consensus rules

The block validation rules that full nodes follow to stay in consensus with other nodes.

## Dark Gravity Wave

An open source difficulty-adjusting algorithm for Bitcoin-based cryptocurrencies that was first used in Dash. Difficulty adjusts every block based on historical statistical data to ensure consistent block issuance regardless of hash rate fluctuation.

## Dash address encoding

The method used in Dash for converting 160-bit hashes into P2PKH and P2SH addresses. Also used in other parts of Dash, such as encoding private keys for backup in WIP format. Not the same as other base58 implementations.

## Data-pushing opcode

Any opcode from 0x01 to 0x4e which pushes data on to the script evaluation stack.

## Decentralized Governance By Blockchain

The method used in Dash for funding development and making decisions regarding the project direction and priorities.

## Denominations

Denominations of Dash value, usually measured in fractions of a dash but sometimes measured in multiples of a duff. One dash equals 100,000,000 duffs.

## Devnet

A development environment in which developers can obtain and spend duffs that have no real-world value on a network that is very similar to the Dash mainnet. Multiple independent devnets can coexist without interference. Devnets can be either public or private.

## Difficulty

How difficult it is to find a block relative to the difficulty of finding the easiest possible block. The easiest possible block has a proof-of-work difficulty of 1.

## DNS seed

A DNS server which returns IP addresses of full nodes on the Dash network to assist in peer discovery.

## Double spend

A transaction that uses the same input as an already broadcast transaction. The attempt of duplication, deceit, or conversion, will be adjudicated when only one of the transactions is recorded in the blockchain.

## Duffs

Denominations of Dash value, usually measured in fractions of a dash but sometimes measured in multiples of a duff. One dash equals 100,000,000 duffs.

## ECDSA private key

The private portion of a keypair which can create signatures that other people can verify using the public key.

## ECDSA signatures

A value related to a public key which could only have reasonably been created by someone who has the private key that created that public key. Used in Dash to authorize spending duffs previously sent to a public key.

## Escrow contract

A transaction in which a spender and receiver place funds in a 2-of-2 (or other m-of-n) multisig output so that neither can spend the funds until they're both satisfied with some external outcome.

## Evolution

Code name for a decentralized currency platform built on the Dash blockchain technology. The goal is to provide simple access to the unique features and benefits of Dash to assist in the creation of decentralized technology.

## Extended key

In the context of HD wallets, a public key or private key extended with the chain code to allow them to derive child keys.

## Extended private key

In the context of HD wallets, a public key or private key extended with the chain code to allow them to derive child keys.

## Extended public key

In the context of HD wallets, a public key or private key extended with the chain code to allow them to derive child keys.

## Evolution masternode (EvoNode)

Evolution masternodes are a new type of [masternode](#masternode) created to host Dash Platform – a Web3 technology stack for building decentralized applications on the Dash network. The collateral required to own an evonode is 4000 DASH, as opposed to 1000 DASH for regular masternodes. Evonodes serve Platform along with Core, while regular masternodes only serve Core. The recommended specs for evonodes are higher than those for regular masternodes.

## Fork

When two or more blocks have the same block height, forking the block chain. Typically occurs when two or more miners find blocks at nearly the same time. Can also happen as part of an attack.

## Genesis block

The first block in the Dash block chain.

## Hard fork

A permanent divergence in the block chain, commonly occurs when non-upgraded nodes can't validate blocks created by upgraded nodes that follow newer consensus rules.

## Hardened extended key

A variation on HD wallet extended keys where only the hardened extended private key can derive child keys. This prevents compromise of the chain code plus any private key from putting the whole wallet at risk.

## Hardened extended private key

A variation on HD wallet extended keys where only the hardened extended private key can derive child keys. This prevents compromise of the chain code plus any private key from putting the whole wallet at risk.

## HD wallet

The Hierarchical Deterministic (HD) key creation and transfer protocol (BIP32), which allows creating child keys from parent keys in a hierarchy. Wallets using the HD protocol are called HD wallets.

## HD wallet seed

A potentially-short value used as a seed to generate the master private key and master chain code for an HD wallet.

## Header

An 80-byte header belonging to a single block which is hashed repeatedly to create proof of work.

## Header chain

A chain of block headers with each header linking to the header that preceded it; the most-difficult-to-recreate chain is the best header chain

## headerandshortids

A P2P Networking data structure used to relay a block header, the short transactions IDs used for matching already-available transactions, and a select few transactions which a peer may be missing.

## Headers-first sync

Synchronizing the block chain by downloading block headers before downloading the full blocks.

## High-priority transaction

Transactions that don't have to pay a transaction fee because their inputs have been idle long enough to accumulated large amounts of priority. Note: As of Dash Core 0.12.3, all transactions require a fee. Also, coin age priority logic was removed in Dash Core 0.14.0.

## Index

An index number used in the HD wallet formula to generate child keys from a parent key

## Initial block download

The process used by a new node (or long-offline node) to download a large number of blocks to catch up to the tip of the best block chain.

## Input

An input in a transaction which contains three fields: an outpoint, a signature script, and a sequence number. The outpoint references a previous output and the signature script allows spending it.

## InstantSend

InstantSend is a service that allows for near-instant transactions. Through this system, inputs can be locked to specific transactions and verified by consensus of the masternode network. InstantSend allows for zero-confirmation transactions to be safely accepted and re-spent prior to being mined into a block.

See also:

* [InstantSend (Core Guide)](../guide/dash-features-instantsend.md)
* [InstantSend Overview (User docs)](instantsend)
* [DIP-10: LLMQ InstantSend](https://github.com/dashpay/dips/blob/master/dip-0010.md)
* [InstantSend integration developer info](integration-instantsend)

## Internal byte order

The standard order in which hash digests are displayed as strings---the same format used in serialized blocks and transactions.

## Inventory

A data type identifier and a hash; used to identify transactions, blocks, and objects available for download through the Dash P2P network.

## Key index

An index number used in the HD wallet formula to generate child keys from a parent key.

## Key pair

A private key and its derived public key.

## Locktime

Part of a transaction which indicates the earliest time or earliest block when that transaction may be added to the block chain.

## Long-Living Masternode Quorum

Long-Living Masternode Quorums (LLMQs) are a Dash innovation that enable masternodes to perform threshold signing of consensus-related messages (e.g. InstantSend transactions). LLMQs provide a more scalable, general use quorum system than the ephemeral ones used prior to Dash Core version 0.14.

## M-of-N multisig

A pubkey script that provides *n* number of pubkeys and requires the corresponding signature script provide *m* minimum number signatures corresponding to the provided pubkeys.

## Mainnet

The original and main network for Dash transactions, where duffs have real economic value.

## Majority Hash Rate Attack

The ability of someone controlling a majority of network hash rate to revise transaction history and prevent new transactions from confirming.

## Malleability

The ability of someone to change (mutate) unconfirmed transactions without making them invalid, which changes the transaction's txid, making child transactions invalid.

## Master chain code and private key

In HD wallets, the master chain code and master private key are the two pieces of data derived from the root seed.

## Master private key

In HD wallets, the master chain code and master private key are the two pieces of data derived from the root seed.

## Masternode

A computer that provides second-tier Dash functionality (InstantSend, CoinJoin, decentralized governance). Masternodes are incentivized by receiving part of the block reward, but must hold 1000 Dash as collateral to prevent sybil attacks.

See also: [Evolution masternode](#evolution-masternode-evonode)

## Merkle block

A partial merkle tree connecting transactions matching a bloom filter to the merkle root of a block.

## Merkle root

The root node of a merkle tree, a descendant of all the hashed pairs in the tree. Block headers must include a valid merkle root descended from all transactions in that block.

## Merkle tree

A tree constructed by hashing paired data (the leaves), then pairing and hashing the results until a single hash remains, the merkle root. In Dash, the leaves are almost always transactions from a single block.

## Message header

The four header fields prefixed to all messages on the Dash P2P network.

## Miner

Mining is the act of creating valid Dash blocks, which requires demonstrating proof of work, and miners are devices that mine or people who own those devices.

## Miner Activated Soft Fork

A Soft Fork activated by through miner signaling.

## Miner fee

The amount paid to the miner who includes a transaction in a block. This equals 25% of the amount remaining when the value of all outputs in a transaction are subtracted from all inputs in a transaction. The remaining 75% is paid to the masternode eligible for payment at the block height where the transaction is mined. Related to [transaction fee](#transaction-fee).

## Miners

Mining is the act of creating valid Dash blocks, which requires demonstrating proof of work, and miners are devices that mine or people who own those devices.

## Minimum relay fee

The minimum transaction fee a transaction must pay for a full node to relay that transaction to other nodes. There is no one minimum relay fee---each node chooses its own policy.

## Mining

Mining is the act of creating valid Dash blocks, which requires demonstrating proof of work, and miners are devices that mine or people who own those devices.

## Multi-phased fork

A spork is a mechanism unique to Dash used to safely deploy new features to the network through network-level variables to avoid the risk of unintended network forking during upgrades. Dash Core 21.0.0 [hardened all spork values on mainnet](https://github.com/dashpay/dash/blob/v21.0.0/doc/release-notes.md#mainnet-spork-hardening). On test networks, spork values can still be updated dynamically.

## Multisig

A pubkey script that provides *n* number of pubkeys and requires the corresponding signature script provide *m* minimum number signatures corresponding to the provided pubkeys.

## nBits

The target is the threshold below which a block header hash must be in order for the block to be valid, and nBits is the encoded form of the target threshold as it appears in the block header.

## Network

The Dash P2P network which broadcasts transactions and blocks.

## Network magic

Four defined bytes which start every message in the Dash P2P protocol to allow seeking to the next message.

## nLockTime

Part of a transaction which indicates the earliest time or earliest block when that transaction may be added to the block chain.

## Node

A computer that connects to the Dash network.

## Null data (OP_RETURN) transaction

A transaction type that adds arbitrary data to a provably unspendable pubkey script that full nodes don't have to store in their UTXO database.

## Opcode

Operation codes from the Dash Script language which push data or perform functions within a pubkey script or signature script.

## Orphan block

Blocks whose parent block has not been processed by the local node, so they can't be fully validated yet.

## Outpoint

The data structure used to refer to a particular transaction output, consisting of a 32-byte TXID and a 4-byte output index number (vout).

## Output

An output in a transaction which contains two fields: a value field for transferring zero or more duffs and a pubkey script for indicating what conditions must be fulfilled for those duffs to be further spent.

## Output index

The sequentially-numbered index of outputs in a single transaction starting from 0.

## P2PKH address

A Dash payment address comprising a hashed public key, allowing the spender to create a standard pubkey script that Pays To PubKey Hash (P2PKH).

## P2SH address

A Dash payment address comprising a hashed script, allowing the spender to create a standard pubkey script that Pays To Script Hash (P2SH). The script can be almost any valid pubkey script.

## P2SH multisig

A P2SH output where the redeem script uses one of the multisig opcodes. Up until Bitcoin Core 0.10.0, P2SH multisig scripts were standard transactions, but most other P2SH scripts were not.

## P2SH output

A Dash payment address comprising a hashed script, allowing the spender to create a standard pubkey script that Pays To Script Hash (P2SH). The script can be almost any valid pubkey script.

## P2SH pubkey script

A Dash payment address comprising a hashed script, allowing the spender to create a standard pubkey script that Pays To Script Hash (P2SH). The script can be almost any valid pubkey script.

## Parent chain code

In HD wallets, 256 bits of entropy added to the public and private keys to help them generate secure child keys; the master chain code is usually derived from a seed along with the master private key

## Parent key

In HD wallets, a key used to derive child keys. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Parent private key

In HD wallets, a key used to derive child keys. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Parent public key

In HD wallets, a key used to derive child keys. The key can be either a private key or a public key, and the key derivation may also require a chain code.

## Pay To PubKey Hash

A Dash payment address comprising a hashed public key, allowing the spender to create a standard pubkey script that Pays To PubKey Hash (P2PKH).

## Pay To Script Hash

A Dash payment address comprising a hashed script, allowing the spender to create a standard pubkey script that Pays To Script Hash (P2SH). The script can be almost any valid pubkey script.

## Payment protocol

The protocol defined in BIP70 (and other BIPs) which lets spenders get signed payment details from receivers.

## Peer

A computer that connects to the Dash network.

## Point function

The ECDSA function used to create a public key from a private key.

## Previous block header hash

A field in the block header which contains the SHA256(SHA256()) hash of the previous block's header.

## Private key

The private portion of a keypair which can create signatures that other people can verify using the public key.

## PrivateSend

A masternode managed, decentralized CoinJoin service for creating an on-demand system of removing the history from coins on the network. CoinJoin processes inputs while allowing each participant to retain control of their coins at all times so the process can be done without trusting a third party.

## Proof of work

A hash below a target value which can only be obtained, on average, by performing a certain amount of brute force work---therefore demonstrating proof of work.

## Pubkey script

A script included in outputs which sets the conditions that must be fulfilled for those duffs to be spent. Data for fulfilling the conditions can be provided in a signature script. Pubkey Scripts are called a scriptPubKey in code.

## Public key

The public portion of a keypair which can be used to verify signatures made with the private portion of the keypair.

## Raw block

A complete block in its binary format---the same format used to calculate total block byte size; often represented using hexadecimal.

## Raw format

Complete transactions in their binary format; often represented using hexadecimal. Sometimes called raw format because of the various Dash Core commands with "raw" in their names.

## Raw transaction

Complete transactions in their binary format; often represented using hexadecimal. Sometimes called raw format because of the various Dash Core commands with "raw" in their names.

## Replace-by-fee

NOT IMPLEMENTED IN DASH. Replacing one version of an unconfirmed transaction with a different version of the transaction that pays a higher transaction fee. May use BIP125 signaling.

## Redeem script

A script similar in function to a pubkey script. One copy of it is hashed to create a P2SH address (used in an actual pubkey script) and another copy is placed in the spending signature script to enforce its conditions.

## Regression test mode

A local testing environment in which developers can almost instantly generate blocks on demand for testing events, and can create private duffs with no real-world value.

## Root seed

A potentially-short value used as a seed to generate the master private key and master chain code for an HD wallet.

## RPC byte order

A hash digest displayed with the byte order reversed; used in Dash Core RPCs, many block explorers, and other software.

## scriptSig

Data generated by a spender which is almost always used as variables to satisfy a pubkey script. Signature Scripts are called scriptSig in code.

## secp256k1 signatures

A value related to a public key which could only have reasonably been created by someone who has the private key that created that public key. Used in Dash to authorize spending duffs previously sent to a public key.

## Sentinel

An autonomous agent for persisting, processing and automating Dash governance objects and tasks, and for expanded functions in Dash Evolution. **Note**: Sentinel was deprecated in Dash Core v20.0 when its functionality was integrated into Dash Core.

## Sequence number

Part of all transactions. A number intended to allow unconfirmed time-locked transactions to be updated before being finalized; not currently used except to disable locktime in a transaction

## Serialized block

A complete block in its binary format---the same format used to calculate total block byte size; often represented using hexadecimal.

## Serialized transaction

Complete transactions in their binary format; often represented using hexadecimal. Sometimes called raw format because of the various Dash Core commands with "raw" in their names.

## SIGHASH flag

A flag to Dash signatures that indicates what parts of the transaction the signature signs. (The default is SIGHASH_ALL.) The unsigned parts of the transaction may be modified.

## SIGHASH_ALL

Default signature hash type which signs the entire transaction except any signature scripts, preventing modification of the signed parts.

## SIGHASH_ANYONECANPAY

A signature hash type which signs only the current input.

## SIGHASH_NONE

Signature hash type which only signs the inputs, allowing anyone to change the outputs however they'd like.

## SIGHASH_SINGLE

Signature hash type that signs the output corresponding to this input (the one with the same index value), this input, and any other inputs partially. Allows modification of other outputs and the sequence number of other inputs.

## Signature

A value related to a public key which could only have reasonably been created by someone who has the private key that created that public key. Used in Dash to authorize spending duffs previously sent to a public key.

## Signature hash

A flag to Dash signatures that indicates what parts of the transaction the signature signs. (The default is SIGHASH_ALL.) The unsigned parts of the transaction may be modified.

## Signature script

Data generated by a spender which is almost always used as variables to satisfy a pubkey script. Signature Scripts are called scriptSig in code.

## Simplified Payment Verification

A method for verifying if particular transactions are included in a block without downloading the entire block. The method is used by some lightweight clients.

## Soft fork

A softfork is a change to the dash protocol wherein only previously valid blocks/transactions are made invalid. Since old nodes will recognise the new blocks as valid, a softfork is backward-compatible.

## Special transactions

Special Transactions provide a way to include non-financial, consensus-assisting metadata (e.g. masternode lists) on-chain.

## Spork

A spork is a mechanism unique to Dash used to safely deploy new features to the network through network-level variables to avoid the risk of unintended network forking during upgrades. Dash Core 21.0.0 [hardened all spork values on mainnet](https://github.com/dashpay/dash/blob/v21.0.0/doc/release-notes.md#mainnet-spork-hardening). On test networks, spork values can still be updated dynamically.

## Stale block

Blocks which were successfully mined but which aren't included on the current best block chain, likely because some other block at the same height had its chain extended first.

## Standard block relay

The regular block relay method: announcing a block with an inv message and waiting for a response.

## Standard transaction

A transaction that passes Dash Core's IsStandard() and IsStandardTx() tests. Only standard transactions are mined or broadcast by peers running the default Dash Core software.

## Start string

Four defined bytes which start every message in the Dash P2P protocol to allow seeking to the next message.

## Superblock

Special blocks that pay out funded budget proposals approved by masternode votes via the decentralized governance system. Superblocks are issued monthly and have a coinbase that can be much larger than normal. The superblock value is provided by the [portion of block subsidy](../reference/block-chain-serialized-blocks.md#block-reward) set aside for superblock payouts.

## Target

The target is the threshold below which a block header hash must be in order for the block to valid, and nBits is the encoded form of the target threshold as it appears in the block header.

## Testnet

A global testing environment in which developers can obtain and spend duffs that have no real-world value on a network that is very similar to the Dash mainnet.

## Transaction

A transaction spending satoshis.

## Transaction fee

The amount remaining when the value of all outputs in a transaction are subtracted from all inputs in a transaction; the fee is split between the miner (25%) that creates the block containing the transaction and the masternode (75%) eligible for payment in that block.

## Transaction identifiers

Identifiers used to uniquely identify a particular transaction; specifically, the sha256d hash of the transaction. Also known as TXIDs.

## Transaction version number

A version number prefixed to transactions to allow upgrading.

## Unconfirmed transaction

A score indicating the number of blocks on the best block chain that would need to be modified to remove or modify a particular transaction. A confirmed transaction has a confirmation score of one or higher.

## Unencrypted wallet

A wallet that has not been encrypted with the encryptwallet RPC.

## Unique addresses

Address which are only used once to protect privacy and increase security.

## Unlocked wallet

An encrypted wallet that has been unlocked with the walletpassphrase RPC.

## Unsolicited block push

When a miner sends a block message without sending an inv message first.

## Unspent transaction output

An Unspent Transaction Output (UTXO) that can be spent as an input in a new transaction.

## User Activated Soft Fork

A Soft Fork activated by flag day or node enforcement instead of miner signaling.

## Wallet

Software that stores private keys and monitors the block chain (sometimes as a client of a server that does the processing) to allow users to spend and receive duffs.

## Wallet Import Format

A data interchange format designed to allow exporting and importing a single private key with a flag indicating whether or not it uses a compressed public key.

## Wallet support

A Dash Core ./configure option that enables (default) or disables the wallet.

## Watch-only address

An address or pubkey script stored in the wallet without the corresponding private key, allowing the wallet to watch for outputs but not spend them.

## X11

Chained hashing algorithm created by Evan Duffield that utilizes a sequence of eleven scientific hashing algorithms for the proof-of-work.
