.. _developers:

==========
Developers
==========

This section includes documentation useful to developers and technical
writers interested in Dash.

Compiling
=========

Links to various guides to compile different Dash software will be
updated here soon.

Translating
===========

Translations of all Dash software are managed courtesty of `Transifex
<https://www.transifex.com/dash>`_. Guides for writing style,
terminology and the reST documentation language will be updated here
soon.

Testnet
=======

Testnet is a fully functioning Dash blockchain with the one key
exception that because the Dash on the network can be created freely, it
has no value. Testnet helps developers test new versions of Dash, as
well as test network operations using identical versions of the software
before they are carried out on the mainnet. There are a few other key
differences:

- Testnet operates on port 19999 (instead of 9999)
- Testnet addresses start with "y" instead of "X", ADDRESSVERSION is 140
  (instead of 76)
- Testnet balances are denominated in tDASH (instead of DASH)
- Protocol message header bytes are 0xcee2caff (instead of 0xbf0c6bbd)
- Bootstrapping uses different DNS seeds: test.dnsseed.masternode.io, 
  testnet-seed.darkcoin.qa, testnet-seed.dashpay.io
- Launching Dash Core in testnet mode shows an orange splash screen

To start Dash Core in testnet mode, find your dash.conf file and enter
the following line::

  testnet = 1

Tools and links
---------------

- **Test builds:** https://bamboo.dash.org
- **Bugtracker:** https://github.com/dashpay/dash/issues/new
- **Discussion and help:** https://www.dash.org/forum/topic/testing.53/
- **Masternode tools:** https://test.dashninja.pl/masternodes.html
- **Android wallet:** https://www.dash.org/forum/threads/dash-wallet-for-android-v5-testnet.14775/
- **Testnet for Bitcoin:** https://en.bitcoin.it/wiki/Testnet

Faucets
^^^^^^^

- https://test.faucet.dash.org - by flare
- http://test.faucet.dashninja.pl - by elbereth
- http://test.faucet.masternode.io - by coingun

Explorers
^^^^^^^^^

- https://test.explorer.dash.org - by flare
- https://test.insight.dash.siampm.com - by thelazier
- http://test.explorer.dashninja.pl - by elbereth
- http://test.insight.masternode.io:3001 - by coingun
- https://testnet-insight.dashevo.org/insight/

Pools
^^^^^

- https://test.pool.dash.org [stratum+tcp://test.stratum.dash.org] - by flare

P2Pool Nodes
^^^^^^^^^^^^

- http://test.p2pool.dash.siampm.com [stratum+tcp://103.58.149.157:17903] by thelazier
- http://p2pool.dashninja.pl:17903/static - by elbereth
- http://test.p2pool.masternode.io:18998/static - by coingun

Masternodes
-----------

Installing a masternode under testnet generally follows the same steps
as the :ref:`mainnet masternode installation guide <masternode-setup>`,
but with a few key differences:

- You will probably be running a development version of Dash instead of
  the stable release. See `here <https://bamboo.dash.org>`_ for
  downloadable builds, then choose **Develop > Latest Build >
  Artifacts**.
- When opening the firewall, port 19999 must be opened instead of (or in
  addition to) 9999. Use this command: ``ufw allow 19999/tcp``
- Your desktop wallet must be running in testnet mode. Add the following
  line to *dash.conf*: ``testnet = 1``
- When sending the collateral, you can get the 1000 tDASH for free from
  a faucet (see above)
- You cannot use dashman to install development versions of Dash. See
  the link to downloadable builds above.
- Your masternode configuration file must also specify testnet mode. Add
  the following line when setting up *dash.conf* on the masternode:
  testnet = 1
- When cloning sentinel, you may need to clone the development branch
  using the ``-b`` option, for example: ``git clone -b core-v0.12.2.x
  https://github.com/dashpay/sentinel.git``
- Once sentinel is installed, modify
  ``~/.dashcore/sentinel/sentinel.conf``, comment the mainnet line and
  uncomment: ``network=testnet``

Testnet 12.2
------------

The Dash team has recently announced the launch of a testnet for public
testing of the upcoming 12.2 release of the Dash software. Unlike
mainnet, the DASH that exists on testnet has no real value, and since
its an entirely separate network, there is no risk to using new and
experimental software. Extensive internal testing has already been done
on the 12.2 code, but there are numerous bugs that can only be revealed
with actual use by real people. The Dash team invites anybody who is
interested to download the software and become active on testnet. This
release includes:

- DIP0001 implementation https://github.com/dashpay/dips/blob/master/dip-0001.md
- 10x transaction fee reduction (including InstantSend fee)
- InstantSend vulnerability fix
- Lots of other bug fixes and performance improvements
- Experimental BIP39/BIP44 complaint HD wallet (disabled by default, should be fully functional but there is no GUI yet)
- Testnet 12.2 discussion: https://www.dash.org/forum/threads/v12-2-testing.17412/
- Testnet tools: https://www.dash.org/forum/threads/testnet-tools-resources.1768/
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest binaries:

- Windows: https://bamboo.dash.org/browse/DASHW-DEV/latestSuccessful/artifact/JOB1/gitian-win-dash-dist/
- macOS: https://bamboo.dash.org/browse/DASHM-DEV/latestSuccessful/artifact/JOB1/gitian-osx-dash-dist/
- Linux: https://bamboo.dash.org/browse/DASHL-DEV/latestSuccessful/artifact/JOB1/gitian-linux-dash-dist/
- Raspberry Pi: https://bamboo.dash.org/browse/DASHP-DEV/latestSuccessful/artifact/JOB1/gitian-RPi2-dash-dist/
- Sentinel: https://github.com/dashpay/sentinel/tree/core-v0.12.2.x


Version History
===============

Full release notes and the version history of Dash are available here:

- https://github.com/dashpay/dash/blob/master/doc/release-notes.md


.. _understanding-sporks:

Sporks
======

A multi-phased fork, colloquially known as a "spork", is a mechanism
unique to Dash used to safely deploy new features to the network through
network-level variables to avoid the risk of unintended network forking
during upgrades. It can also be used to disable certain features if a
security vulnerability is discovered - see :ref:`here <sporks>` for a
brief introduction to sporks. This documentation describes the meaning
of each spork currently existing on the network, and how to check their
respective statuses.

Spork functions
---------------

Sporks are set using integer values. Many sporks may be set to a
particular epoch datetime (number of seconds that have elapsed since
January 1, 1970) to specify the time at which they will active. Enabled
sporks are set to 0 (seconds until activation). This function is often
used to set a spork enable date so far in the future that it is
effectively disabled until changed. The following sporks currently exist
on the network and serve functions as described below:

SPORK_2_INSTANTSEND_ENABLED
  Governs the ability of Dash clients to use InstandSend functionality.

SPORK_3_INSTANTSEND_BLOCK_FILTERING
  If enabled, masternodes will reject blocks containing transactions in
  conflict with locked but unconfirmed InstandSend transactions.

SPORK_5_INSTANTSEND_MAX_VALUE
  Enforces the maximum value in Dash that can be included in an
  InstantSend transaction.

SPORK_8_MASTERNODE_PAYMENT_ENFORCEMENT
  If enabled, miners must pay 50% of the block reward to a masternode
  currently pending selection or the block will be considered invalid.

SPORK_9_SUPERBLOCKS_ENABLED
  If enabled, superblocks are verified and issued to pay proposal
  winners.

SPORK_10_MASTERNODE_PAY_UPDATED_NODES
  Controls whether masternodes running an older protocol version are
  considered eligible for payment. This can be used as an incentive to
  encourage masternodes to update.

SPORK_12_RECONSIDER_BLOCKS
  Forces reindex of a specified number of blocks to recover from
  unintentional network forks.

SPORK_13_OLD_SUPERBLOCK_FLAG
  Deprecated. No network function since block 614820.

SPORK_14_REQUIRE_SENTINEL_FLAG
  Toggles whether masternodes with status are eligible for payment if
  status is WATCHDOG_EXPIRED, i.e. Sentinel is not running properly.

Viewing spork status
--------------------

The ``spork show`` and ``spork active`` commands issued in the debug
window (or from ``dash-cli`` on a masternode) allow you to interact with
sporks. You can open the debug window by selecting **Tools > Debug
console**.

.. figure:: img/dashcore-sporks.png
   :width: 300px

   spork show and spork active output in the Dash Core debug console
