# Historical Reference

:::{attention}
The following information is deprecated and for historical reference only. It describes features that have been redesigned and no longer operate as described below.
:::

## InstantSend (original)

:::{tip}
Check the [Dash features guide](../guide/dash-features-instantsend.md) for details of the current InstantSend design.
:::

Dash Core's InstantSend feature provides a way to lock transaction inputs and enable secure, instantaneous transactions. Since Dash Core 0.13.0, any qualifying transaction is automatically upgraded to InstantSend by the network without a need for the sending wallet to explicitly request it. For these simple transactions (those containing 4 or fewer inputs), the previous requirement for a special InstantSend transaction fee was also removed. The criteria for determining eligibility can be found in the lists of limitations below.

The following video provides an overview with a good introduction to the details including the InstantSend vulnerability that was fixed in Dash Core 0.12.2. Some specific points in the video are listed here for quick reference:

* 2:00 - InstantSend restrictions
* 5:00 - Masternode quorum creation
* 6:00 - Input locking
* 7:45 - Quorum score calculation / Requirement for block confirmations
* 9:00 - Description of Dash Core pre-0.12.2 InstantSend vulnerability
* 13:00 - Description of vulnerability fix / Post Dash Core 0.12.2 operation

<iframe width="100%" height="350" src="https://www.youtube-nocookie.com/embed/n4PELomRiFY?rel=0;start=0" title="Matt Robertson - InstantSend - The Dash Conference"></iframe>

*InstantSend Data Flow*

| **InstantSend Client** | **Direction**  | **Peers**   | **Description** |
| --- | :---: | --- | --- |
| [`inv` message](../reference/p2p-network-data-messages.md#inv) (ix)          | → |                         | Client sends inventory for transaction lock request
|                             | ← | [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (ix)  | Peer responds with request for transaction lock request
| `ix` message                | → |                         | Client sends InstantSend transaction lock request
|                             | ← | [`inv` message](../reference/p2p-network-data-messages.md#inv) (txlvote) | Masternodes in the [quorum](../guide/dash-features-masternode-quorums.md#quorum-configuration) respond with votes
| [`getdata` message](../reference/p2p-network-data-messages.md#getdata) (txlvote) | → |                         | Client requests vote
|                             | ← | `txlvote` message       | Peer responds with vote

Once an InstantSend lock has been requested, the `instantsend` field of various RPCs (e.g. the [`getmempoolentry` RPC](../api/remote-procedure-calls-blockchain.md#getmempoolentry)) is set to `true`. Then, if a sufficient number of votes approve the transaction lock, the InstantSend transaction is approved the `instantlock` field of the RPC is set to `true`.

If an InstantSend transaction is a valid transaction but does not receive a transaction lock, it reverts to being a standard transaction.

There are a number of limitations on InstantSend transactions:

* The lock request will timeout 15 seconds after the first vote is seen (`INSTANTSEND_LOCK_TIMEOUT_SECONDS`)
* The lock request will fail if it has not been locked after 60 seconds (`INSTANTSEND_FAILED_TIMEOUT_SECONDS`)
* A “per-input” fee of 0.0001 DASH per input is required for non-simple transactions (inputs >=5) since they place a higher load on the masternodes. This fee was most recently decreased by [DIP-0001](https://github.com/dashpay/dips/blob/master/dip-0001.md).
* To be used in an InstantSend transaction, an input must have at least the number confirmations (block depth) indicated by the table below

| **Network** | **Confirmations Required** |
| --- | --- |
| Mainnet | 6 Blocks |
| Testnet | 2 Blocks |
| Regtest | 2 Blocks |
| Devnet  | 2 Blocks |

There are some further limitations on Automatic InstantSend transactions:

* DIP3 must be active
* Spork 16 must be enabled
* Mempool usage must be lower than 10% (`AUTO_IX_MEMPOOL_THRESHOLD`). As of Dash Core 0.13.0, this corresponds to a mempool size of 30 MB (`DEFAULT_MAX_MEMPOOL_SIZE` = 300 MB).

**Historical Note**

Prior to Dash Core 0.13.0, `instantsend` and `instantlock` values were not available via RPC. At that time, the InstantSend system worked as described below.

Once a sufficient number of votes approved the transaction lock, the InstantSend transaction was approved and showed 5 confirmations (`DEFAULT_INSTANTSEND_DEPTH`).

NOTE: The 5 "pseudo-confirmations" were shown to convey confidence that the transaction was secure from double-spending and DID NOT indicate the transaction had already been confirmed to a block depth of 5 in the blockchain.
