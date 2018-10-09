.. meta::
   :description: Dash testnet and devnets are used by Dash developers for testing using tDASH
   :keywords: dash, masternodes, testnet, devnet, faucet, masternodes, testing, mining pools

.. _testnet:

===================
Testnet and devnets
===================

With the release of Dash Core 12.3, Dash added support for a great new
feature — **named devnets**. Devnets are developer networks that combine
some aspects of testnet (the global and public testing network) and some
aspects of regtest (the local-only regression testing mode that provides
controlled block generation). Unlike testnet, multiple independent
devnets can be created and coexist without interference. For practical
documentation on how to use devnets, see the `developer documentation
<https://dash-docs.github.io/en/developer-examples#devnet-mode>`__ or
this `blog post <https://blog.dash.org/dash-devnets-bc27ecbf0085>`__.

Testnet is a fully functioning Dash blockchain with the one key
exception that because the Dash on the network can be created freely, it
has no value. This currency, known as tDASH, can be requested from a
faucet to help developers test new versions of Dash, as well as test
network operations using identical versions of the software before they
are carried out on the mainnet. There are a few other key differences:

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
===============

The links below were collected from various community sources and may
not necessarily be online or functioning at any given time. Please join
`Dash Nation Discord <http://dashchat.org>`_ or the `Dash Forum
<https://www.dash.org/forum/>`_ if you have a question relating to a
specific service.

- **Test builds:** https://jenkins.dash.org/blue/
- **Bugtracker:** https://github.com/dashpay/dash/issues/new
- **Discussion and help:** https://www.dash.org/forum/topic/testing.53/
- **Masternode tools:** https://test.dashninja.pl/masternodes.html
- **Android wallet:** https://www.dash.org/forum/threads/dash-wallet-for-android-v5-testnet.14775/
- **Testnet for Bitcoin:** https://en.bitcoin.it/wiki/Testnet

Faucets
-------

- https://test.faucet.dash.org - by flare
- http://test.faucet.dashninja.pl - by elbereth
- http://t.f.masternode.io - by coingun
- http://test.faucet.masternode.io - by coingun
- http://faucet.test.dash.crowdnode.io - ndrezza

Explorers
---------

- https://test.explorer.dash.org - by flare
- https://test.insight.dash.siampm.com - by thelazier
- https://test.explorer.dashninja.pl - by elbereth
- http://test.insight.masternode.io:3001 - by coingun
- http://insight.test.dash.crowdnode.io
- https://testnet-insight.dashevo.org/insight

Pools
-----

- https://test.pool.dash.org [stratum+tcp://test.stratum.dash.org] - by flare
- http://test.p2pool.dash.siampm.com [stratum+tcp://test.p2pool.dash.siampm.com:17903] by thelazier
- http://p2pool.dashninja.pl:17903/static - by elbereth
- http://test.p2pool.masternode.io:18998/static - by coingun

Masternodes
===========

Installing a masternode under testnet generally follows the same steps
as the :ref:`mainnet masternode installation guide <masternode-setup>`,
but with a few key differences:

- You will probably be running a development version of Dash instead of
  the stable release. See `here <https://jenkins.dash.org/blue>`__ for
  downloadable builds, then choose **dashpay-dash > develop** to view a
  list of recent builds.
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
- As for mainnet masternodes, the RPC username and password must contain
  alphanumeric characters only
- When cloning sentinel, you may need to clone the development branch
  using the ``-b`` option, for example: ``git clone -b core-v0.12.2.x
  https://github.com/dashpay/sentinel.git``
- Once sentinel is installed, modify
  ``~/.dashcore/sentinel/sentinel.conf``, comment the mainnet line and
  uncomment: ``network=testnet``
- The wallet holding the masternode collateral will expect to find the
  ``masternode.conf`` file in ``~/.dashcore/testnet3/masternode.conf``
  instead of ``~/.dashcore/masternode.conf``.

Testnet 12.3
============

In June 2018, the Dash team announced the start of testing of the
upcoming Dash 12.3 release. Extensive internal testing has already been
done on the 12.2 code, but there are numerous bugs that can only be
revealed with actual use by real people. The Dash team invites anybody
who is interested to download the software and become active on testnet.
This release includes:

- Named Devnets, to help developers quickly create multiple independent
  devnets
- New format of network message signatures
- Governance system improvements
- PrivateSend improvements
- Additional indexes cover P2PK now
- Support for pruned nodes in Lite Mode
- New Masternode Information Dialog

Discussion:

- https://www.dash.org/forum/threads/v12-3-testing.38475
- Testnet tools: https://docs.dash.org/en/latest/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.12.3.0-rc3


Testnet 12.2
============

In October 2017, the Dash team announced the launch of a testnet for
public testing of the upcoming 12.2 release of the Dash software.
Extensive internal testing has already been done on the 12.2 code, but
there are numerous bugs that can only be revealed with actual use by
real people. The Dash team invites anybody who is interested to download
the software and become active on testnet. This release includes:

- DIP0001 implementation https://github.com/dashpay/dips/blob/master/dip-0001.md
- 10x transaction fee reduction (including InstantSend fee)
- InstantSend vulnerability fix
- Lots of other bug fixes and performance improvements
- Experimental BIP39/BIP44 complaint HD wallet (disabled by default, should be fully functional but there is no GUI yet)

Discussion:

- Testnet 12.2 discussion: https://www.dash.org/forum/threads/v12-2-testing.17412/
- Testnet tools: https://www.dash.org/forum/threads/testnet-tools-resources.1768/
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest successfully built develop branch binaries:

- Dash Core: https://jenkins.dash.org/blue/organizations/jenkins/dashpay-dash/activity/?branch=develop
- Sentinel: https://github.com/dashpay/sentinel/tree/develop
