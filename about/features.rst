.. _features:

==================
Features
==================


Whitepaper
==================

A whitepaper is a document often issued with the release of a new
cryptocurrency to explain its Unique Value Proposition and describe
details of how it will function. The Dash Whitepaper is frequently
updated, but this page also provides links to the original version and
translations.

- `Dash Roadmap <https://github.com/dashpay/dash-roadmap>`_
- `Latest whitepaper and official translations <https://github.com/dashpay/dash/wiki/Whitepaper>`_
- `Original Darkcoin whitepaper (PDF) <https://github.com/dashpay/docs/raw/master/pdf/Dash%20Whitepaper%20-%20Darkcoin.pdf>`_
- `InstantSend whitepaper (PDF) <https://github.com/dashpay/docs/raw/master/pdf/Dash%20Whitepaper%20-%20Transaction%20Locking%20and%20Masternode%20Consensus.pdf>`_

.. _specifications:

Specifications
==================

-  Release date: 11PM EST, 18th January 2014 / No premine
-  X11 hashing algorithm: 11 rounds of scientific hashing functions
   (blake, bmw, groestl, jh, keccak, skein, luffa, cubehash, shavite,
   simd, echo)
-  Block reward is controlled by: 2222222/(((Difficulty+2600)/9)^2).
    Minimum base subsidy 5 Dash. Maximum 25 Dash.
-  CPU/GPU/ASIC mining
-  Block generation: 2.5 minutes
-  Difficulty Retargets using Dark Gravity Wave - Improved Kimoto
   Gravity Well - Exponential Moving Average weighted adjustment.
-  7.14% decrease in the number of coins generated per year
-  Total coins: `between 17.74M and
   18.92M <emission-rate>`__
-  Total coins: `between 17.74M and
   18.92M <emission-rate>`_
-  Total coins: :ref:`between 17.74M and
   18.92M <emission-rate>`
-  Total coins: :ref:`between 17.74M and
   18.92M (see `Emission Rate`_)
-  Total coins: between 17.74M and
   18.92M (see `Emission Rate`_)
-  Decentralized Masternode Network
-  Superior Transaction Anonymity using PrivateSend
-  Two-tier network using masternodes to form the second tier
-  Instant transactions (InstantSend) made possible by the masternode
   network
-  Decentralized Governance By Blockchain allows masternode owners to
   vote on budget proposals and decisions that affect Dash. Budget
   proposals fund Dash development and come directly from block rewards,
   i.e. Dash development is self-funded by its own blockchain.

.. _emission-rate:

Emission Rate
==================

Cryptocurrencies such as Dash and Bitcoin are created through a
cryptographically difficult process known as mining. Mining involves
repeatedly solving :ref:`hash algorithms <x11-hash-algorithm>` until a valid
solution for the current :ref:`mining difficulty <dark-gravity-wave>` is discovered. Once discovered, the miner is permitted to create new units 
of the currency. This is known as the block reward. To ensure that the 
currency is not subject to endless inflation, the block reward is 
reduced at regular intervals. Graphing this data results in a curve 
showing total coins in circulation, known as the coin emission rate. 

While Dash is based on Bitcoin, it significantly modifies the coin
emission rate to offer a smoother reduction in coin emission over time.
While Bitcoin reduces the coin emission rate by 50% every 4 years, Dash
reduces the emission by one-fourteenth (approx. 7.14%) every 210240
blocks (approx. 383.25 days). It can be seen that reducing the block
reward by a smaller amount each year offers a smoother transition to a
fee-based economy than Bitcoin.

.. _x11-hash-algorithm:

X11 Hash Algorithm
==================

X11 is a widely used hashing algorithm created by Dash core developer
Evan Duffield. X11’s chained hashing algorithm utilizes a sequence of
eleven scientific hashing algorithms for the proof-of-work. This is so
that the processing distribution is fair and coins will be distributed
in much the same way Bitcoin’s were originally. X11 was intended to make
ASICs much more difficult to create, thus giving the currency plenty of
time to develop before mining centralization became a threat. This
approach was largely successful; as of early 2016, ASICs for X11 now
exist and comprise a significant portion of the network hashrate, but
have not resulted in the level of centralization present in Bitcoin.

X11 is the name of the chained proof-of-work (**PoW**) algorithm that
was introduced in Dash (launched January 2014 as “Xcoin”). It was 
partially inspired by the chained-hashing approach of Quark, adding
further “depth” and complexity by increasing the number of hashes, yet
it differs from Quark in that the rounds of hashes are determined *a
priori* instead of having some hashes being randomly picked.

The X11 algorithm uses multiple rounds of 11 different hashes (blake,
bmw, groestl, jh, keccak, skein, luffa, cubehash, shavite, simd, echo),
thus making it one of the safest and more sophisticated cryptographic
hashes in use by modern cryptocurrencies.

The name X11 is not related to the open source GUI server that provides
a graphical interface to Unix/Linux users.

Advantages of X11
-----------------

The increased complexity and sophistication of the chained algorithm
provides enhanced levels of security and less uncertainty for a digital
currency, compared to single-hash PoW solutions that are not protected
against security risks like SPOF (Single Point Of Failure). For example,
a possible but not probable computing breakthrough that “breaks” the
SHA256 hash could jeopardize the entire Bitcoin network until the
network shifts through a hard fork to another cryptographic hash.

In the event of a similar computing breakthrough, a digital currency
using the X11 PoW would continue to function securely unless all 11
hashes were broken simultaneously. Even if some of the 11 hashes were to
prove unreliable, there would be adequate warning for a currency using
X11 to take measures and replace the problematic hashes with other more
reliable hashing algorithms.

Given the speculative nature of digital currencies and their inherent
uncertainties as a new field, the X11 algorithm can provide increased
confidence for its users and potential investors that single-hash
approaches cannot. Chained hashing solutions, like X11, provide
increased safety and longevity for store of wealth purposes, investment
diversification and hedging against risks associated with single-hash
currencies plagued by SPOF (Single Point Of Failure).

Evan Duffield, the creator of Dash and X11 chained-hash, has wrote on
several occasions that X11 was integrated into Dash not with the
intention to prevent ASIC manufacturers from creating ASICs for X11 in
the future, but rather to provide a similar migratory path that Bitcoin
had (CPUs, GPUs, ASICs).

Mining with X11
---------------

Information on mining with X11 can be found in the `Mining <mining>`_ 
section of this documentation.

.. _dark-gravity-wave:

Dark Gravity Wave
==================

**DGW** or *Dark Gravity Wave* is an open source difficulty-adjusting
algorithm for Bitcoin-based cryptocurrencies that was first used in 
Darkcoin/Dash and has been adopted by other digital currencies.

DGW was authored by Evan Duffield, the developer and creator of
X11/Darkcoin/Dash, as a response to a time-warp exploit found
in *Kimoto's Gravity Well*. 

In concept, DGW is similar to the Kimoto Gravity Well, adjusting the 
difficulty levels every block (instead of every 2016 blocks like 
Bitcoin) by using statistical data of the last blocks found. In this way
block issuing times can remain consistent, despite high fluctuations in hashpower. However it doesn't suffer from the time-warp exploit. 

Version 2.0 of DGW was implemented in Darkcoin/Dash from block 45,000 
onwards in order to completely alleviate the time-warp exploit. 

Version 3.0 was implemented on May 14 of 2014 to further improve
difficulty re-targeting with smoother transitions. It also fixes issues
with various architectures that had different levels of floating-point
accuracy through the use of integers.

