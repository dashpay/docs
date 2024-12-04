```{eval-rst}
.. meta::
  :title: CoinJoin
  :description: CoinJoin is Dash Core’s mixing feature which gives you consumer grade financial privacy by shuffling your Dash with other users. 
```

# CoinJoin

Dash Core's mixing feature provides a way to improve privacy by performing non-custodial CoinJoin. For additional details, reference this [Official Documentation page](https://docs.dash.org/en/stable/introduction/features.html#privatesend).

The following video provides an overview with a good introduction to the details:

<iframe width="100%" height="350" src="https://www.youtube-nocookie.com/embed/vgCId3wJc5Y?rel=0" title="How Dash's 'PrivateSend' Works Under the Hood"></iframe>

## Wallet Preparation

The [wallet](../resources/glossary.md#wallet) completes two operations in this phase:

1. Split value into inputs matching the CoinJoin [denominations](../resources/glossary.md#denominations) by sending [transactions](../resources/glossary.md#transaction) to itself

2. Split value into [inputs](../resources/glossary.md#input) to use for collateral by sending transactions to itself

**Note**: Both these operations incur the standard [transaction fee](../resources/glossary.md#transaction-fee) like any other transaction

**Creating Denominations**

The CoinJoin denominations include a bit mapping to easily differentiate them. The [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa) and [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq) use this bit shifted integer instead of sending the actual denomination. The table below lists the bit, its associated integer value used in P2P messages, and the actual Dash value.

| **Bit** | **Denom. (Integer)** | **Denomination (DASH)** |
| --- | --- | --- |
| 0   |  1 | 10.0001              |
| 1   |  2 | 01.00001             |
| 2   |  4 | 00.100001            |
| 3   |  8 | 00.0100001           |
| 4   | 16 | 00.00100001          |

Protocol version 70213 added a 5th denomination (0.001 DASH).

[Example Testnet denomination creation transaction](https://testnet-insight.dashevo.org/insight/tx/f0174fc87d68a18617c2990df4d9455c0459c601d2d6473934357a66f9b8b70a)

**Creating Collaterals**

Collaterals are used to pay CoinJoin fees, but are kept separate from the denominations to maximize privacy. Since protocol version 70213, the minimum collateral fee is 1/10 of the smallest denomination for all sessions regardless of denomination. In Dash Core, collaterals are created with enough value to pay 4 collateral fees (4 x 0.001 DASH). ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/common.h#L109))

In protocol versions > 70208, Dash Core can use any [input](../resources/glossary.md#input) from 1x the minimum collateral amount to the maximum collateral amount.

[Example Testnet collateral creation transaction](https://testnet-insight.dashevo.org/insight/tx/8f9b15973983876f7ce4eb2c32b09690dfb0432d2caf6c6df516196a8d17689f)

[Example Testnet collateral payment transaction](https://testnet-insight.dashevo.org/insight/tx/de51e6f7c5ef75aad0dbb0a808ef4873d7ef6d67b25f3a658d5a241db4f3eeeb)

## CoinJoin Processing

This phase involves exchanging a sequence of messages with a [masternode](../resources/glossary.md#masternode) so it can construct a denominate transaction with inputs from the clients in its pool.

### Data Flow

:::{attention}
Since protocol version 70234 (Dash Core 22.0.0), the [`dsq`
message](../reference/p2p-network-privatesend-messages.md#dsq) is broadcast using the inventory
system instead of being relayed to all connected peers. This reduces the bandwidth needs for all
nodes, especially highly connected masternodes.
:::

|   | **Clients** | **Direction**  | **Masternode**   | **Description** |
| --- | --- | :---: | --- | --- |
| 0 | | | | Client determines whether to join an existing pool or create a new one |
| 1 | [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa)                            | → |                            | Client asks to join pool or have the masternode create a new one
| 2 |                                                | ← | [`dssu` message](../reference/p2p-network-privatesend-messages.md#dssu)       | Masternode provides a pool status update (Typical - State: `POOL_STATE_QUEUE`, Message: `MSG_NOERR`)
| 3 |                                                | ← | [`inv` message](../reference/p2p-network-data-messages.md#inv) (dsq)   | Masternode notifies clients when it is ready to receive inputs by sending a `dsq` inventory message
| 4 | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (dsq)                                  | → |            | Client requests a [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq)
| 5 |                                                | ← | [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq)        | Masternode responds with the requested [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq)
| 6 | [`dsi` message](../reference/p2p-network-privatesend-messages.md#dsi)                                 | → |                       | Upon receiving a [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq) with the Ready bit set, clients each provide a list of their inputs (unsigned), collateral, and a list of outputs where funds should be sent
| 7 |                                                | ← | [`dssu` message](../reference/p2p-network-privatesend-messages.md#dssu)       | Masternode provides a pool status update (typical - State: `POOL_STATE_ACCEPTING_ENTRIES`, Message: `MSG_ENTRIES_ADDED`)
| 8 |                                                | ← | [`dsf` message](../reference/p2p-network-privatesend-messages.md#dsf)        | Masternode sends the final transaction containing all clients inputs (unsigned) and all client outputs to each client for verification
| 9 |                                                | ← | [`dssu` message](../reference/p2p-network-privatesend-messages.md#dssu)       | Masternode provides a pool status update (Typical - State: `POOL_STATE_SIGNING`, Message: `MSG_NOERR`)
| 10 | [`dss` message](../reference/p2p-network-privatesend-messages.md#dss)                                | → |                       | After verifying the final transaction, clients each sign their own inputs with the `SIGHASH_ALL \| SIGHASH_ANYONECANPAY` signature type and send them back
| 11 |                                               | ← | [`dsc` message](../reference/p2p-network-privatesend-messages.md#dsc)        | Masternode verifies the signed inputs, creates a [`dstx` message](../reference/p2p-network-privatesend-messages.md#dstx) to broadcast the transaction, and notifies clients that the denominate transaction is complete (Typical - Message: `MSG_SUCCESS`)
| 12 |                                                | ← | [`inv` message](../reference/p2p-network-data-messages.md#inv)        | Masternode broadcasts a `dstx` inventory message
| 13 | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (dstx)                                 | → |            | (Optional)

### Additional notes

_**Step 0 - Pool Selection**_

* Existing pool information is derived from the Queue messages seen by the client
* Dash Core attempts to join an existing pool and only requests creation of a new one if that fails, although this is not a requirement that alternative implementations would be required to follow

_**Step 1 - Pool Request**_

* The [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa) contains a collateral transaction
  * This transaction uses a collateral [input](../resources/glossary.md#input) created in the [Wallet Preparation](#wallet-preparation) phase
  * The collateral is a signed [transaction](../resources/glossary.md#transaction) that pays the collateral back to a client [address](../resources/glossary.md#address) minus a fee of 0.001 DASH

_**Steps 3-5 - Queue**_

:::{attention}
Clients must respond to the Queue ready within 30 seconds or risk forfeiting the collateral they provided in the [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa) (Step 1) ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/coinjoin.h#L43))
:::

* When a masternode starts a new queue, it broadcasts an inventory message notifying all [peers](../resources/glossary.md#peer) of an available [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq). Interested clients can then request the full `dsq` message. Prior to protocol version 70234, `dsq` messages were directly relayed to all peers.
* Sessions have a variable number of participants defined by the range `nPoolMinParticipants` ([3](https://github.com/dashpay/dash/blob/v21.1.x/src/chainparams.cpp#L298) for mainnet, 2 for other networks) to `nPoolMaxParticipants` ([20](https://github.com/dashpay/dash/blob/v21.1.x/src/chainparams.cpp#L299)).
* The masternode sends an inventory message for a [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq) with the ready bit set once it has received valid [`dsa` messages](../reference/p2p-network-privatesend-messages.md#dsa) from either:
    1. The maximum number of clients
    2. Greater than the minimum number of clients and the timeout has been reached ([30 seconds](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/coinjoin.h#L43))

_**Step 6 - Inputs**_

* The collateral transaction can be the same in the [`dsi` message](../reference/p2p-network-privatesend-messages.md#dsi) as the one in the [`dsa` message](../reference/p2p-network-privatesend-messages.md#dsa) (Step 1) as long as it has not been spent
* Each client can provide up to 9 (`COINJOIN_ENTRY_MAX_SIZE`) inputs (and an equal number of outputs) to be used ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/coinjoin.h#L46))
* This is the only message in the process that contains enough information to link a wallet's CoinJoin inputs with its outputs
  * This message is sent directly between a client and the masternode processing the session (not relayed across the Dash network) so no other clients see it

_**Step 8 - Final Transaction (unsigned)**_

* Once the masternode has received valid [`dsi` messages](../reference/p2p-network-privatesend-messages.md#dsi) from all clients, it creates the final transaction and sends a [`dsf` message](../reference/p2p-network-privatesend-messages.md#dsf)
  * Inputs/outputs are ordered deterministically as defined by [BIP-69](https://github.com/dashevo/bips/blob/master/bip-0069.mediawiki#Abstract) to avoid leaking any data ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/server.cpp#L301-L302))
  * Clients must sign their inputs to the Final Transaction within 15 seconds or risk forfeiting the collateral they provided in the [`dsi` message](../reference/p2p-network-privatesend-messages.md#dsi) (Step 4) ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/coinjoin.h#L44))

_**Step 12 - Final Transaction broadcast**_

As of protocol version 70213, up to 5 (`MASTERNODE_MAX_MIXING_TXES`) un-mined [`dstx` messages](../reference/p2p-network-privatesend-messages.md#dstx) per masternode are allowed. ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/masternode/meta.h#L21))

_**General**_

  With the exception of the [`dsq` message](../reference/p2p-network-privatesend-messages.md#dsq) and the [`dstx` message](../reference/p2p-network-privatesend-messages.md#dstx) (which need to be public and do not expose any private information), all CoinJoin P2P messages are sent directly between the masternode processing the transaction and the relevant client(s).

## Fees

**Processing Fees**

* If processing completes successfully, Dash Core charges the collateral randomly in 1/10 denominate transactions to pay miners ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/server.cpp#L432-449))
* Clients that abuse the system by failing to respond to [`dsq` messages](../reference/p2p-network-privatesend-messages.md#dsq) or [`dsf` messages](../reference/p2p-network-privatesend-messages.md#dsf) within the timeout periods may forfeit their collateral. Dash Core charges the abuse fee in 1/3 cases ([Dash Core Reference](https://github.com/dashpay/dash/blob/v21.1.x/src/coinjoin/server.cpp#L363-L381))

**Sending Fees**

To maintain privacy when using CoinJoin funds, transactions must fully spend all inputs to a single output (with the remainder becoming the fee - i.e. no [change output](../resources/glossary.md#change-output)). This can result in large fees depending on the value being sent.

For example, an extreme case is sending the minimum non-dust value (546 duffs). This results in an extremely large transaction fee because the minimum denomination (0.00100001 DASH or 100,001 duffs) must be fully spent with no change. This results in a fee of 0.00999464 DASH and a sent value of only 0.00000546 DASH as shown by the calculation below.

100001 duffs (smallest CoinJoin denomination) - 546 duffs (value to send) = 99455 duffs (fee)
