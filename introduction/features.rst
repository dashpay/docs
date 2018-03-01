.. _features:

==================
Features
==================

.. _specifications:

Specifications
==================

-  Release date: 11PM EST, 18th January 2014
-  No premine
-  X11 hashing algorithm
-  2.5 minute block generation time
-  Block reward decreases by 7.14% per year
-  CPU/GPU/ASIC mining
-  Dark Gravity Wave difficulty adjustment algorithm
-  Total coins: :ref:`between 17.74M and 18.92M <emission_rate>`
-  Decentralized masternode network
-  Superior transaction anonymity using PrivateSend
-  Instant transactions using InstantSend
-  Two-tier network using masternodes to form the second tier
-  Decentralized Governance By Blockchain allows masternode owners to
   vote on budget proposals and decisions that affect Dash. Budget
   proposals fund Dash development and come directly from block rewards,
   i.e. Dash development is self-funded by its own blockchain.


.. _privatesend:

PrivateSend
==================

PrivateSend gives you true financial privacy by obscuring the origins of
your funds. All the Dash in your wallet is comprised of different
"inputs", which you can think of as separate, discrete coins. 
PrivateSenduses an innovative process to mix your inputs with the inputs
of two other people, without having your coins ever leave your wallet. 
You retain control of your money at all times.

The PrivateSend process works like this:

#. PrivateSend begins by breaking your transaction inputs down into
   standard denominations. These denominations are 0.01 Dash, 0.1 DASH,
   1 DASH and 10 DASH -- much like the paper money you use every day.
#. Your wallet then sends requests to specially configured software
   nodes on the network, called "masternodes". These masternodes are
   informed then that you are interested in mixing a certain
   denomination. No identifiable information is sent to the masternodes,
   so they never know "who" you are.
#. When two other people send similar messages, indicating that they
   wish to mix the same denomination, a mixing session begins. The
   masternode mixes up the inputs and instructs all three users' wallets
   to pay the now-transformed input back to themselves. Your wallet pays
   that denomination directly to itself, but in a different address
   (called a change address).
#. In order to fully obscure your funds, your wallet must repeat this
   process a number of times with each denomination. Each time the
   process is completed, it's called a "round". Each round of
   PrivateSend makes it exponentially more difficult to determine where
   your funds originated.
#. This mixing process happens in the background without any
   intervention on your part. When you wish to make a transaction, your
   funds will already be anonymized. No additional waiting is required.

**IMPORTANT:** Your wallet only contains 1000 of these "change
addresses". Every time a mixing event happens, one of your addresses is
used up. Once enough of them are used, your wallet must create more
addresses. It can only do this, however, if you have automatic backups
enabled. Consequently, users who have backups disabled will also have
PrivateSend disabled.


.. _instantsend:

InstantSend
==================

InstantSend technology will allow for cryptocurrencies such as Dash to 
compete with nearly instantaneous transaction systems such as credit 
cards for point-of-sale situationswhile not relying on a centralized 
authority. Widespread vendor acceptance of Dash and InstantSend could
revolutionize cryptocurrency by shortening the delay in confirmation of
transactions from as long as an hour (with Bitcoin) to as little as a 
few seconds.

InstantSend was introduced in a whitepaper called `Transaction Locking 
and Masternode Consensus: A Mechanism for Mitigating Double Spending
Attacks <https://github.com/dashpay/docs/raw/master/pdf/Dash%20Whitepaper%20-%20Transaction%20Locking%20and%20Masternode%20Consensus.pdf>`_.

.. _masternode_network:

Masternodes
==================

In addition to traditional Proof of Work (PoW) rewards for mining Dash,
users are also rewarded for running and maintaining special servers
called masternodes. Thanks to this innovative two tier network, Dash can
offer innovative features in a trustless and decentralized way.

What is a Dash masternode?
--------------------------

Dash uses special servers called masternodes to power PrivateSend,
InstantSend, and the governance and treasury system. Users are rewarded
for running masternodes; 45% of the block reward is allocated to pay the
masternode network.

Masternodes enable the following services:

-  **InstantSend** allows for near-instant transactions. Dash
   InstantSend transactions are fully confirmed within two seconds.
-  **PrivateSend** gives financial privacy by obscuring the source of
   funds on the blockchain.
-  **Governance and Treasury** allows stakeholders in Dash to determine
   the direction of the project and devotes 10% of the block reward to
   development of the project and ecosystem (as of March 2017, our
   annual budget is $6.7 million).
-  **Dash Evolution** will make using cryptocurrency as easy as using
   PayPal.

Masternode owners must have possession of 1000 DASH, which they prove by
signing a message and broadcasting to the network. Those coins can be
moved at any time, but moving them will cause the masternode to fall out
of queue and stop earning rewards.

Masternode users also are given **voting rights** on proposals. Each
masternode has one vote and this vote can be used on budget proposals or
important decisions that affect Dash.

How much can you earn from hosting a Masternode?
------------------------------------------------

Masternodes cost money and effort to host so they are paid a share of
the block reward to incentivize them. With current masternode numbers
and rewards masternodes earn approximately a 8% return on 1000 Dash
(which means 6.97 Dash or USD1360 in July 2017) for the year of
2017. This `tool <https://stats.masternode.me/>`__ shows a
live calculation of masternode earnings. These rewards decrease by 7%
each year, but the rising value of Dash should offset these
reductions. As a matter of fact, masternodes were receiving 140 Dash per
month at the beginning of 2016, but this was actually less money than
today: USD600 per month. There is also the possibility for masternodes
to earn money from fees in the future.


.. _sporks:

Multi-Phased Fork ("Spork")
============================

In response to unforeseen issues with the rollout of the major "RC3"
update in June 2014, the Dash development team created a mechanism by
which updated code is released to the network, but not immediately made
active ("enforced"). This innovation allows for far smoother transitions
than in the traditional hard fork paradigm, as well as the collection of
test data in the live network environment. This process was originally
to be called "soft forking" but the community affectionately dubbed it
"the spork" and the name stuck!

New features or versions of Dash undergo extensive testing on testnet
before they are released to the main network. When a new feature or
version of Dash is released on mainnet, communication is sent out to
users informing them of the change and the need for them to update their
clients. Those who update their clients run the new code, but it is not
activated until a sufficient percentage of network participants (usually
80%) reach consensus on running it. In the event of errors occurring
with the new code, the client’s blocks are not rejected by the network
and unintended forks are avoided. Data about the error can then be
collected and forwarded to the development team. Once the development
team is satisfied with the new code’s stability in the mainnet
environment – and once acceptable network consensus is attained –
enforcement of the updated code can be activated remotely by multiple
members of the core development team signing a network message together
with their respective private keys. Should problems arise, the code can
be deactivated in the same manner, without the need for a network-wide
rollback or client update. For technical details on individual sporks,
see
`here <https://dashpay.atlassian.net/wiki/spaces/DOC/pages/128319489/Understanding+Sporks>`__.


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
was introduced in Dash (launched January 2014 as "Xcoin"). It was 
partially inspired by the chained-hashing approach of Quark, adding
further "depth" and complexity by increasing the number of hashes, yet
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
a possible but not probable computing breakthrough that "breaks" the
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

Information on mining with X11 can be found in the 
:ref:`Mining <mining>` section of this documentation.

.. _dark-gravity-wave:

Dark Gravity Wave
==================

**DGW** or *Dark Gravity Wave* is an open source difficulty-adjusting
algorithm for Bitcoin-based cryptocurrencies that was first used in Dash
and has since appeared in other digital currencies. DGW was authored by 
Evan Duffield, the developer and creator of Dash, as a response to a 
time-warp exploit found in *Kimoto's Gravity Well*. 

In concept, DGW is similar to the Kimoto Gravity Well, adjusting the 
difficulty levels every block (instead of every 2016 blocks like 
Bitcoin) based on statistical data from recently found blocks. This 
makes it possible to issue blocks with relatively consistent times, even 
if the hashing power experiences high fluctuations, without suffering 
from the time-warp exploit.

Version 2.0 of DGW was implemented in Dash from block 45,000 onwards in 
order to completely alleviate the time-warp exploit.

Version 3.0 was implemented on May 14 of 2014 to further improve
difficulty re-targeting with smoother transitions. It also fixes issues
with various architectures that had different levels of floating-point
accuracy through the use of integers.


.. _emission_rate:

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

