# Proof of Service

```{eval-rst}
.. meta::
  :title: Dash Proof of Service
  :description: The Proof of Service (PoSe) scoring system motivates masternodes to deliver network services, penalizing non-participation by increasing PoSe scores and eventually disqualifying them from payment eligibility.
```

The Proof of Service (PoSe) scoring system helps incentivize [masternodes](../resources/glossary.md#masternode) to provide [network](../resources/glossary.md#network) services. Masternodes that neglect to participate receive an increased PoSe score which eventually results in them being excluded from masternode payment eligibility.

## Distributed Key Generation Participation Requirements

The following table lists the aspects of the DKG process a masternode must comply with to avoid receiving a PoSe score increase:

| Protocol Version | Proof of Service<br>Requirement |
| :-: | - |
| 70213+ | Exchange required messages (quorum contributions and quorum justifications) with other quorum members during the [LLMQ DKG process](../guide/dash-features-masternode-quorums.md#llmq-creation-dkg) (Dash Core 0.13.0+) |
| 70218+ | Have an open P2P port ([Dash Core 0.16.0+](https://github.com/dashpay/dash/pull/3390)). _Enforcement of this requirement is dependent on Spork 23 being enabled_ |
| 70218+ | Have a protocol version => [`MIN_MASTERNODE_PROTO_VERSION`](https://github.com/dashpay/dash/blob/v19.x/src/version.h#L23). During updates where this version is increased, masternodes will begin receiving PoSe score increases once > 80% of masternodes have upgrade ([Dash Core 0.16.0+](https://github.com/dashpay/dash/pull/3390)). _Enforcement of this requirement is dependent on Spork 23 being enabled_ |

## Proof of Service Score Weighting

The current PoSe scoring system is based only on participation in the [LLMQ](../resources/glossary.md#long-living-masternode-quorum) DKG process. This scoring system will expand over time to incorporate additional service requirements in support of the future Dash functionality.

| Service | Percent of Score | Requirement |
| ----------- | :----: | ------------------- |
| LLMQ DKG    | 100% | Participate in the DKG process used to establish LLMQs. Requires exchanging messages with other quorum members |

## **PoSe Score Calculation**

As shown in the following table, the PoSe Score always decreases by 1 per [block](../resources/glossary.md#block) as long as a masternode has not been banned. Once banned, the masternode can only be restored by sending a Provider Update Service ([ProUpServTx](../reference/transactions-special-transactions.md#proupservtx)) special transaction.

| PoSe Parameter | Value | Example Value |
| --- | --- | --- |
| Maximum PoSe Score | Number of registered masternodes | 5000 |
| PoSe Score Increases | Maximum PoSe Score * 2/3 | 3333 |
| PoSe Score Decreases | 1 (per block) | Always `1` |

The current PoSe scoring algorithm increases the PoSe score by 66% of the maximum score for each failed DKG session. Depending on timing, this allows for no more than 2 failures for a masternode within a payment cycle (i.e a number of blocks equal to the number of registered masternodes).

For example, using the values from above with 5000 masternodes:

* In the first 5000 block cycle, two DKG failures occur without the PoSe score exceeding the maximum. This happens since a sufficient number of blocks are mined prior to the second failure to drop the PoSe score below the threshold (`< 5000 - 3333`) that would result in banning.

* In the second 5000 block cycle, the second DKG failure occurs too close to the first and results in the PoSe score exceeding the maximum limit. This results in the masternode receiving a PoSe Ban.

| Payment Cycle | Block Number | Event | Score Change | PoSe Score | MN Status |
| :---: | :--- | --- | :---: | :---: | :---: |
| 1 | 1 | DKG Failure (1) | +3333 | 3333 | Valid |
| 1 | 1734 | 1733 Blocks Mined | -1733 | 1600 | Valid |
| 1 | 1734 | DKG Failure (2) | +3333 | 4933 | Valid |
| 1 | 5000 | 3266 Blocks Mined | -3266 | 1667 | Valid |
| | | End of Payment Cycle 1| | | |
| 2 | 5500 | 500 Blocks Mined | -500 | 1167 | Valid |
| 2 | 5500 | DKG Failure (3) | +3333 | 4500 | Valid |
| 2 | 7000 | 1500 Blocks Mined | -1500 | 3000 | Valid |
| 2 | 7000 | DKG Failure (4) | +3333 | 6333 | PoSe Banned |
| 2 | 10000 | End of Payment Cycle 2 | - | 6333 | PoSe Banned |
