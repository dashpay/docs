```{eval-rst}
.. meta::
  :title: Serialized Blocks
  :description: Describes the structure of serialized Dash blocks and how the block reward is divided among miners, masternodes, and the governance system.
```

# Serialized Blocks

Under current [consensus rules](../resources/glossary.md#consensus-rules), a
[block](../resources/glossary.md#block) is not valid unless its serialized size is less than or
equal to 2 MB. All fields described below are counted towards the serialized size.

| Bytes    | Name         | Data Type        | Description |
| - | - | - | - |
| 80       | block header | block_header     | The [block header](../resources/glossary.md#block-header) in the format described in the [block header section](../reference/block-chain-block-headers.md).
| *Varies* | txn_count    | [compactSize uint](../resources/glossary.md#compactsize) | The total number of transactions in this block, including the coinbase transaction.
| *Varies* | txns         | [raw transaction](../resources/glossary.md#raw-transaction)  | Every transaction in this block, one after another, in raw transaction format.  Transactions must appear in the data stream in the same order their TXIDs appeared in the first row of the merkle tree.  See the [merkle tree section](../reference/block-chain-block-headers.md#merkle-trees) for details.

## Coinbase

The first transaction in a block must be a [coinbase
transaction](../resources/glossary.md#coinbase-transaction) which should collect and spend any
[transaction fee](../resources/glossary.md#transaction-fee) paid by transactions included in this
block.

### Block Subsidy

Until the coin limit (~18 million Dash) is hit, all blocks are entitled to receive a block subsidy
of newly created Dash value. The newly created value should be spent in the coinbase transaction.

The block subsidy declines by ~7.1% per year until all Dash is mined. Subsidy calculations are
performed by the Dash Core
[GetBlockSubsidy()](https://github.com/dashpay/dash/blob/v19.x/src/validation.cpp#L1010) function.

#### Treasury expansion

In September of 2023, the Dash network approved a
[proposal](https://www.dashcentral.org/p/TREASURY-REALLOCATION-60-20-20) to double the governance
budget by modifying the block subsidy allocation. The new allocation designates 20% for miners, 20%
for the governance system budget, and 60% for masternodes. The expansion went into effect when
the Dash Core v20 hard fork activated in December 2023.

| Subsidy allocation | Purpose |
|-|-|
| 20% | Mining reward |
| 20% | Governance budget |
| 60% | Masternode reward |

### Block Reward

Together, the transaction fees and block subsidy are called the [block
reward](../resources/glossary.md#block-reward). A coinbase transaction is invalid if it tries to
spend more value than is available from the block reward.

The block reward is divided into three main parts: [miner](../resources/glossary.md#miner),
[masternode](../resources/glossary.md#masternode), and
[superblock](../resources/glossary.md#superblock). The miner and masternode portions add up to 80%
of the block subsidy with the remainder allocated to the governance system.

Once Dash Platform is released, Dash Core will further divides the masternode reward into Core
(62.5%) and Platform (37.5%) portions. The Core portion will be paid out directly in the coinbase.
The Platform portion will go into the Platform credit pool and then distributed by Platform to
[evonodes](../resources/glossary.md#evolution-masternode-evonode) providing Platform services.

The following table details how the block subsidy and fees are allocated between miners, masternodes, and the governance system.

| Payee | Block subsidy | Transaction fees | Description |
| ----- | :-----: | :-------: | -|
| Superblock | 20% | - | Payment for maintenance/expansion of the ecosystem (Core development, marketing, integration, etc.)
| Miner | 20% | 25% | Payment for mining
| Masternode | 60% | 75% | Payment for masternode services including [CoinJoin](../guide/dash-features-coinjoin.md), [InstantSend](../guide/dash-features-instantsend.md), [Governance](https://docs.dash.org/en/stable/introduction/features.html#decentralized-governance), etc.

<img src="https://files.readme.io/fa5bfbe-mining-banner-1.svg" alt="Mining" style="width:50%;text-align:center;"/>

#### Block Reward Reallocation

:::{attention}
This block reward reallocation process was superseded by the [treasury
expansion](#treasury-expansion) that was approved by the network in 2023 and subsequently activated
by the Dash Core v20 hard fork at block 1987776.
:::

Dash Core v0.16 included logic to gradually adjust the block reward allocation once the BIP-9
activation threshold was met. The reward reallocation was signaled via BIP-9 bit 5 and was activated
at block 1374912 upon signaling by a sufficient number of blocks.

This reallocation will eventually result in miners receiving 40% of the non-governance block subsidy
and masternodes receiving 60% of it rather than the 50/50 split that was used for several years.

**Reward reallocation changes**

Reward reallocation changes began at the first superblock following activation (block 1379128) and
then occurred every three superblock cycles (approximately once per quarter) until the [treasury
expansion](#treasury-expansion) hard fork went into effect.

| Quarter | Block     | Miner % | Masternode % | Change \(%\) |
| :-: | :-: | :-: | :-: | :-:
| -               | -                    | 50     | 50          | 0.00%      |
| Q4 2020 | 1,379,128      | 48.7   | 51.3        | 1.30%       |
| Q1 2021   | 1,428,976    | 47.4    | 52.6        | 1.30%      |
| Q2 2021  | 1,478,824     | 46.7   | 53.3        | 0.70%      |
| Q3 2021  | 1,528,672     | 46.0  | 54.0         | 0.70%      |
| Q4 2021  | 1,578,520     | 45.4   | 54.6        | 0.60%     |
| Q1 2022  | 1,628,368     | 44.8   | 55.2        | 0.60%     |
| Q2 2022 | 1,678,216      | 44.3   | 55.7        | 0.50%      |
| Q3 2022 | 1,728,064     | 43.8   | 56.2        | 0.50%      |
| Q4 2022 | 1,777,912       | 43.3   | 56.7        | 0.50%       |
| Q1 2023  | 1,827,760     | 42.8   | 57.2        | 0.50%      |
| Q2 2023 | 1,877,608      | 42.3   | 57.7       | 0.50%     |
| Q3 2023 | 1,927,456      | 41.8   | 58.2        | 0.50%       |
| ***Q4 2023*** | ***1,977,304***      | ***41.5***   | ***58.5***        | ***0.30%***       |
| Q1 2024 *  | 2,027,152      | 41.2   | 58.8        | 0.30%       |
| Q2 2024 * | 2,077,000     | 40.9   | 59.1        | 0.30%       |
| Q3 2024 * | 2,126,848      | 40.6   | 59.4        | 0.30%      |
| Q4 2024 * | 2,176,696      | 40.3   | 59.7        | 0.30%       |
| Q1 2025 *  | 2,226,544     | 40.1   | 59.9        | 0.20%       |
| Q2 2025 * | 2,276,392     | 40      | 60           | 0.10%       |

\* The 2024 and 2025 changes were superseded by the [treasury
expansion](#treasury-expansion) activated by hard fork in December 2023.
