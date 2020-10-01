.. meta::
   :description: Dash testnet and devnets are used by Dash developers for testing using tDASH
   :keywords: dash, masternodes, testnet, devnet, faucet, masternodes, testing, pool, explorer, mining pools, block explorer

.. _testnet:

===================
Testnet and devnets
===================

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

With the release of Dash Core 12.3, Dash added support for a great new
feature — **named devnets**. Devnets are developer networks that combine
some aspects of testnet (the global and public testing network) and some
aspects of regtest (the local-only regression testing mode that provides
controlled block generation). Unlike testnet, multiple independent
devnets can be created and coexist without interference. For practical
documentation on how to use devnets, see the `developer documentation
<https://dashcore.readme.io/docs/core-examples-testing-applications>`__
or this `blog post <https://blog.dash.org/dash-devnets-bc27ecbf0085>`__.

Tools and links
===============

The links below were collected from various community sources and may
not necessarily be online or functioning at any given time. Please join
`Dash Nation Discord <http://dashchat.org>`_ or the `Dash Forum
<https://www.dash.org/forum/>`_ if you have a question relating to a
specific service.

- **Test builds:** https://gitlab.com/dashpay/dash/pipelines
- **Bugtracker:** https://github.com/dashpay/dash/issues/new
- **Discussion and help:** https://www.dash.org/forum/topic/testing.53/
- **Masternode tools:** https://test.dashninja.pl/masternodes.html
- **Android wallet:** https://github.com/dashevo/dash-wallet/releases/tag/v7.0.2
- **Testnet for Bitcoin:** https://en.bitcoin.it/wiki/Testnet

Faucets
-------

- https://testnet-faucet.dash.org - by Dash Core Group
- http://test.faucet.masternode.io - by coingun
- http://faucet.test.dash.crowdnode.io - by ndrezza
- https://test.faucet.dashninja.pl - by elbereth

Explorers
---------

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
  the stable release. See `here <https://gitlab.com/dashpay/dash/pipelines>`__
  for a list of builds, then choose the latest successful ``develop`` 
  build and click **Artifacts** to view a list of binaries.
- When opening the firewall, port 19999 must be opened instead of (or in
  addition to) 9999. Use this command: ``ufw allow 19999/tcp``
- Your desktop wallet must be running in testnet mode. Add the following
  line to *dash.conf*: ``testnet = 1``
- When sending the collateral, you can get the 1000 tDASH for free from
  a faucet (see above)
- Your masternode configuration file must also specify testnet mode. Add
  the following line when setting up *dash.conf* on the masternode:
  ``testnet = 1``
- As for mainnet masternodes, the RPC username and password must contain
  alphanumeric characters only
- When cloning sentinel, you may need to clone the development branch
  using the ``-b`` option, for example: ``git clone -b develop
  https://github.com/dashpay/sentinel.git``
- Once sentinel is installed, modify
  ``~/.dashcore/sentinel/sentinel.conf``, comment the mainnet line and
  uncomment: ``network=testnet``
- The wallet holding the masternode collateral will expect to find the
  ``masternode.conf`` file in ``~/.dashcore/testnet3/masternode.conf``
  instead of ``~/.dashcore/masternode.conf``.


Testnet 0.16.0
==============

In June 2020, the Dash team announced the start of testing of the
upcoming Dash 0.16.0 release. Extensive internal testing has already been
done on the 0.16.0 code, but there are numerous bugs that can only be
revealed with actual use by real people. The Dash team invites anybody
who is interested to download the software and become active on testnet.
This release includes:

- Block reward reallocation
- Core Wallet UI/UX Improvements
- Quorum Signing Optimizations
- Network Threading Improvement
- Minimum Protocol Check
- Bitcoin 0.16 and 0.17 Backports

Discussion:

- Testnet announcement: https://www.dash.org/forum/threads/v0-16-testing.50294/
- Product brief: https://blog.dash.org/updated-product-brief-dash-core-release-v0-16-0-d3debdb6242e
- Testnet tools: https://docs.dash.org/en/stable/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.16.0.0-rc3

Testnet 0.15.0
==============

In December 2019, the Dash team announced the start of testing of the
upcoming Dash 0.15.0 release. Extensive internal testing has already been
done on the 0.15.0 code, but there are numerous bugs that can only be
revealed with actual use by real people. The Dash team invites anybody
who is interested to download the software and become active on testnet.
This release includes:

- Bitcoin 0.15 backports
- Removal of legacy code

Discussion:

- Testnet announcement: https://www.dash.org/forum/threads/v15-0-testing.49140/
- Product brief: https://blog.dash.org/product-brief-dash-core-release-v0-15-0-acd7633a91ab
- Testnet tools: https://docs.dash.org/en/stable/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.15.0.0-rc4


Testnet 0.14.0
==============

In March 2019, the Dash team announced the start of testing of the
upcoming Dash 0.14.0 release. Extensive internal testing has already been
done on the 0.14.0 code, but there are numerous bugs that can only be
revealed with actual use by real people. The Dash team invites anybody
who is interested to download the software and become active on testnet.
This release includes:

- LLMQ DKGs
- LLMQ based ChainLocks
- LLMQ based InstantSend

Discussion:

- Testnet announcement: https://www.dash.org/forum/threads/v14-0-testing.44047/
- Product brief: https://blog.dash.org/product-brief-dash-core-release-v0-14-0-now-on-testnet-8f5f4ad45c96
- Testnet tools: https://docs.dash.org/en/stable/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.14.0.0-rc6


Testnet 0.13.0
==============

In November 2018, the Dash team announced the start of testing of the
upcoming Dash 0.13.0 release. Extensive internal testing has already been
done on the 0.13.0 code, but there are numerous bugs that can only be
revealed with actual use by real people. The Dash team invites anybody
who is interested to download the software and become active on testnet.
This release includes:

- Automatic InstantSend for Simple Transactions
- Deterministic Masternode List
- 3 Masternode Keys: Owner, Operator and Voting
- Special Transactions
- PrivateSend Improvements

Discussion: 

- Testnet announcement: https://www.dash.org/forum/threads/v13-0-testing.41945/
- Product brief: https://blog.dash.org/product-brief-dash-core-release-v0-13-0-5d7fddffb7ef
- Testnet tools: https://docs.dash.org/en/stable/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.13.0.0-rc11

Testnet 0.12.3
==============

In June 2018, the Dash team announced the start of testing of the
upcoming Dash 0.12.3 release. Extensive internal testing has already been
done on the 0.12.2 code, but there are numerous bugs that can only be
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

- https://www.dash.org/forum/threads/v12-3-testing.38475/
- Testnet tools: https://docs.dash.org/en/stable/developers/testnet.html
- Issue tracking: https://github.com/dashpay/dash/issues/new

Latest test binaries:

- https://github.com/dashpay/dash/releases/tag/v0.12.3.0-rc3


Testnet 0.12.2
==============

In October 2017, the Dash team announced the launch of a testnet for
public testing of the upcoming 0.12.2 release of the Dash software.
Extensive internal testing has already been done on the 0.12.2 code, but
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

- Dash Core: https://gitlab.com/dashpay/dash/pipelines
- Sentinel: https://github.com/dashpay/sentinel/tree/develop
