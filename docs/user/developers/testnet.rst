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
- Launching Dash Core in testnet mode shows an orange tray icon

To start Dash Core in testnet mode, find your dash.conf file and enter
the following line::

  testnet = 1

With the release of Dash Core 12.3, Dash added support for a great new
feature - **named devnets**. Devnets are developer networks that combine
some aspects of testnet (the global and public testing network) and some
aspects of regtest (the local-only regression testing mode that provides
controlled block generation). Unlike testnet, multiple independent
devnets can be created and coexist without interference. For practical
documentation on how to use devnets, see the :ref:`developer documentation
<core:examples-testing-applications>`
or this `blog post <https://blog.dash.org/dash-devnets-bc27ecbf0085>`__.

Tools and links
===============

The links below were collected from various community sources and may
not necessarily be online or functioning at any given time. Please join
`Dash Discord <http://staydashy.com/>`_ or the `Dash Forum
<https://www.dash.org/forum/>`_ if you have a question relating to a
specific service.

- **Nightly builds:** https://github.com/dashpay/dash-dev-branches/releases
- **Bugtracker:** https://github.com/dashpay/dash/issues/new
- **Discussion and help:** https://www.dash.org/forum/index.php?forums/testing.53/
- **Android wallet:** https://github.com/dashpay/dash-wallet/releases/latest
- **Testnet for Bitcoin:** https://en.bitcoin.it/wiki/Testnet
- **Release notes for previous versions:** https://github.com/dashpay/dash/tree/master/doc/release-notes/dash

Faucets
-------

- https://faucet.testnet.networks.dash.org - by Dash Core Group
- http://faucet.test.dash.crowdnode.io - by CrowdNode

Explorers
---------

- https://testnet-insight.dashevo.org/insight
- https://insight.testnet.networks.dash.org:3002/insight
- http://insight.testnet.networks.dash.org:3001/insight

Masternodes
===========

Installing a masternode under testnet generally follows the same steps
as the :ref:`mainnet masternode installation guide <masternode-setup>`,
but with a few key differences:

- You will probably be running a development version of Dash instead of the
  stable release. Choose the latest `nightly build
  <https://github.com/dashpay/dash-dev-branches/releases>`__ on GitHub.
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

