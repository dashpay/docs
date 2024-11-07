```{eval-rst}
.. meta::
  :title: Protocol Versions
  :description: The table in this section lists some notable versions of the Dash P2P network protocol, with the most recent versions listed first.
```

# Protocol Versions

## Dash Protocol Versions

The table below lists some notable versions of the P2P network protocol, with the most recent versions listed first.

As of Dash Core 21.1, the most recent protocol version is 70233.

| Version | Initial Release                    | Major Changes
|---------|------------------------------------|--------------
| 70233 | [Dash Core 21.1](https://github.com/dashpay/dash/blob/v21.1.0/doc/release-notes.md) <br> (Aug 2024) | • [Enhanced hard fork update](https://github.com/dashpay/dash/pull/6175)
| 70232 | [Dash Core 21.0](https://github.com/dashpay/dash/blob/v21.0.0/doc/release-notes.md) <br> (Jul 2024) | • Masternode reward location reallocation<br>• Mainnet spork hardening<br>• Experimental descriptor wallet support
| 70231 | [Dash Core 20.1](https://github.com/dashpay/dash/blob/v20.1.0/doc/release-notes.md) <br> (Mar 2024) | • HD wallets by default<br>• Legacy InstantSend deprecated (`islock` p2p and inv messages)
| 70230 | [Dash Core 20.0](https://github.com/dashpay/dash/blob/v20.0.0/doc/release-notes.md) <br> (Nov 2023) | • [DIP 29](https://github.com/dashpay/dips/blob/master/dip-0028.md): ChainLock-based random beacon<br>• [Treasury expansion](https://www.dashcentral.org/p/TREASURY-REALLOCATION-60-20-20)<br>• Sentinel functionality integrated into Core<br>• Asset lock transactions<br>• [Coinbase transaction updates](https://github.com/dashpay/dips/blob/master/dip-0004.md) and changes to [DIP 4](https://github.com/dashpay/dips/blob/master/dip-0004.md)
| 70228 | [Dash Core 19.2.0](https://github.com/dashpay/dash/blob/v19.2.0/doc/release-notes.md) <br> (Jun 2023) | • Store protx version in simplified masternode list entries and use to serialize/deserialize masternode BLS operator keys
| 70227 | [Dash Core 19.0.0](https://github.com/dashpay/dash/blob/v19.0.0/doc/release-notes.md) <br> (Apr 2023) | • [DIP 28](https://github.com/dashpay/dips/blob/master/dip-0028.md): Evolution masternodes (4000 DASH collateral)<br>• Removed [`reject` message](../reference/p2p-network-deprecated-messages.md#reject)
| 70224 | Dash Core 18.2.0 <br> (Jan 2023) | • None (CoinJoin bugfix only)
| 70223 (unchanged) | Dash Core 18.1.0 <br> (Oct 2022) | • [BIP 70](https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki) support removed (Bitcoin backport)<br>• Account API removed (previously deprecated)<br>• Auto-loading wallets<br>
| 70223 | Dash Core 18.0.0 <br> (Aug 2022) | • [DIP 22](https://github.com/dashpay/dips/blob/master/dip-0022.md): Deterministic InstantSend<br>• Governance proposal fee reduction<br>• Multi-wallet GUI support<br>• [DIP 24](https://github.com/dashpay/dips/blob/master/dip-0024.md): LLMQ Rotation<br>
| 70219  | Dash Core 0.17.0 <br>(Q2 2021)  | • [DIP 20](https://github.com/dashpay/dips/blob/master/dip-0020.md) Opcode [additions](../reference/transactions-opcodes.md#expanded-opcodes) <br>• Governance system improvements <br>• Add LLMQ for Dash Platform <br>• RPC updates to support Dash Platform <br>• Removal of [spork](../reference/p2p-network-control-messages.md#spork) 22 <br>• Hard fork auto-recovery <br>• Non-HD to HD wallet upgrade option <br>• [DIP 21](https://github.com/dashpay/dips/blob/master/dip-0021.md) DKG data sharing/recovery
| 70218  | Dash Core 0.16.0 <br>(Q3 2020)  | • Block reward [reallocation](../reference/block-chain-serialized-blocks.md#block-reward-reallocation)<br>• Concentrated recovery for LLMQ signatures<br>• Wallet GUI refresh<br>• Expanded [PoSe](../guide/dash-features-proof-of-service.md) (masternode version checks) <br>• Removal of [sporks](../reference/p2p-network-control-messages.md#spork) 15, 16, and 20<br>• PrivateSend updates
| 70216  | Dash Core 0.15.0 <br>(Q1 2020)  | • Mempool sync (via [`mempool` message](../reference/p2p-network-data-messages.md#mempool))<br>• Updated [default P2P/RPC ports](../reference/p2p-network-constants-and-defaults.md) for RegTest and Devnet networks<br>• Removal of `alert` message<br>• Removal of legacy InstantSend<br>• Removal of [sporks](../reference/p2p-network-control-messages.md#spork) 5 and 12<br>• Deprecation of [sporks](../reference/p2p-network-control-messages.md#spork) 15, 16, and 20
| 70215  | Dash Core 0.14.0.1 <br>(May 2019)  | • None (Governance bugfix only)
| 70214  | Dash Core 0.14.0.0 <br>(May 2019)  | • [Long-Living Masternode Quorum](../resources/glossary.md#long-living-masternode-quorum)<br>• [ChainLocks](../resources/glossary.md#chainlock)<br>• PrivateSend improvements<br>• Experimental LLMQ InstantSend<br>• Bitcoin Core 0.15 backports
| 70213  | Dash Core 0.13.0.x <br>(Jan 2019)  | • [Special Transactions](../resources/glossary.md#special-transactions)<br>• Deterministic Masternode List<br>• Coinbase Special Transaction<br>• Automatic InstantSend
| 70210  | Dash Core 0.12.3.x <br>(July 2018)  | • Named Devnets<br>• New signature format / Spork 6 addition<br>• Bitcoin Core 0.13/0.14 backports<br>• [BIP90](https://github.com/bitcoin/bips/blob/master/bip-0090.mediawiki): Buried deployments<br>• [BIP147](https://github.com/bitcoin/bips/blob/master/bip-0147.mediawiki): NULLYDUMMY enforcement<br>• [BIP152](https://github.com/bitcoin/bips/blob/master/bip-0152.mediawiki) Compact Blocks<br>• Transaction version increased to 2<br>• Zero fee transactions removed<br>• Pruning in Lite Mode
| 70208  | Dash Core 0.12.2.x <br>(Nov 2017)  | • [DIP1](https://github.com/dashpay/dips/blob/master/dip-0001.md) (2MB blocks)<br>• Fee reduction (10x)<br>• InstantSend fix<br>• PrivateSend improvements<br>• _Experimental_ HD wallet<br>• Local Masternode support removed
| 70206  | Dash Core 0.12.1.x <br>(Mar 2017)  | • Switch to Bitcoin Core 0.12.1<br>• BIP-0065 (CheckLockTimeVerify)<br>• BIP-0112 (CheckSequenceVerify)
| 70103  | Dash Core 0.12.0.x <br>(Aug 2015)  | • Switch to Bitcoin Core 0.10<br>• Decentralized budget system<br>• New IX implementation
| 70076  | Dash Core 0.11.2.x <br>(Mar 2015)  | • Masternode enhancements<br>• Mining/relay policy enhancements<br>• BIP-66 - strict DER encoding for signatures
| 70066  | Dash Core 0.11.1.x <br>(Feb 2015)  | • InstantX fully implemented<br>• [Spork](../resources/glossary.md#spork) fully implemented<br>• Masternode payment updates<br>• Rebrand to Dash (0.11.1.26)
| 70052  | Dash Core 0.11.0.x <br>(Jan 2015)  | • Switch from fork of Litecoin 0.8 to Bitcoin 0.9.3<br>• Rebrand to Darkcoin Core
| 70051  | Dash Core 0.10.0.x <br>(Sep 2014)  | • Release of the originally closed source implementation of DarkSend
| 70002  | Dash Core 0.9.0.x <br>(Mar 2014)   | • Masternode implementation<br>• Rebrand to Darkcoin
| 70002  | Dash Core 0.8.7 <br>(Jan 2014)     | Initial release of Dash (branded XCoin) as a fork of Litecoin 0.8

## Bitcoin Protocol Versions

Historical Bitcoin protocol versions for reference shown below since Dash is a [fork](../resources/glossary.md#fork) of Bitcoin Core.

| Version | Initial Release                    | Major Changes
|---------|------------------------------------|--------------
| 70012   | Bitcoin Core 0.12.0 <br>(Feb 2016) | [BIP130](https://github.com/bitcoin/bips/blob/master/bip-0130.mediawiki): <br>• Added [`sendheaders` message](../reference/p2p-network-control-messages.md#sendheaders).
| 70011   | Bitcoin Core 0.12.0 <br>(Feb 2016) | [BIP111](https://github.com/bitcoin/bips/blob/master/bip-0111.mediawiki): <br>• `filter*` messages are disabled without NODE_BLOOM after and including this version.
| 70002   | Bitcoin Core 0.9.0 <br>(Mar 2014)  | • Send multiple [`inv` messages](../reference/p2p-network-data-messages.md#inv) in response to a [`mempool` message](../reference/p2p-network-data-messages.md#mempool) if necessary <br><br>[BIP61](https://github.com/bitcoin/bips/blob/master/bip-0061.mediawiki): <br>• Added [`reject` message](../reference/p2p-network-deprecated-messages.md#reject)
| 70001   | Bitcoin Core 0.8.0 <br>(Feb 2013)  | • Added [`notfound` message](../reference/p2p-network-data-messages.md#notfound). <br><br>[BIP37](https://github.com/bitcoin/bips/blob/master/bip-0137.mediawiki): <br>• Added [`filterload` message](../reference/p2p-network-control-messages.md#filterload). <br>• Added [`filteradd` message](../reference/p2p-network-control-messages.md#filteradd). <br>• Added [`filterclear` message](../reference/p2p-network-control-messages.md#filterclear). <br>• Added [`merkleblock` message](../reference/p2p-network-data-messages.md#merkleblock). <br>• Added relay field to [`version` message](../reference/p2p-network-control-messages.md#version) <br>• Added `MSG_FILTERED_BLOCK` inventory type to [`getdata` message](../reference/p2p-network-data-messages.md#getdata).
| 60002   | Bitcoin Core 0.7.0 <br>(Sep 2012)  | [BIP35](https://github.com/bitcoin/bips/blob/master/bip-0035.mediawiki): <br>• Added [`mempool` message](../reference/p2p-network-data-messages.md#mempool). <br>• Extended [`getdata` message](../reference/p2p-network-data-messages.md#getdata) to allow download of memory pool transactions
| 60001   | Bitcoin Core 0.6.1 <br>(May 2012)  | [BIP31](https://github.com/bitcoin/bips/blob/master/bip-0031.mediawiki): <br>• Added nonce field to [`ping` message](../reference/p2p-network-control-messages.md#ping) <br>• Added [`pong` message](../reference/p2p-network-control-messages.md#pong)
| 60000   | Bitcoin Core 0.6.0 <br>(Mar 2012)  | [BIP14](https://github.com/bitcoin/bips/blob/master/bip-0014.mediawiki): <br>• Separated protocol version from Bitcoin Core version
| 31800   | Bitcoin Core 0.3.18 <br>(Dec 2010) | • Added [`getheaders` message](../reference/p2p-network-data-messages.md#getheaders) and [`headers` message](../reference/p2p-network-data-messages.md#headers).
| 31402   | Bitcoin Core 0.3.15 <br>(Oct 2010) | • Added time field to [`addr` message](../reference/p2p-network-control-messages.md#addr).
| 311     | Bitcoin Core 0.3.11 <br>(Aug 2010) | • Added `alert` message.
| 209     | Bitcoin Core 0.2.9 <br>(May 2010)  | • Added checksum field to message headers.
| 106     | Bitcoin Core 0.1.6 <br>(Oct 2009)  | • Added receive IP address fields to [`version` message](../reference/p2p-network-control-messages.md#version).
