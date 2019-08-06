.. meta::
   :description: Technical guides for merchants using Dash. API and SDK resources.
   :keywords: dash, merchants, payment processor, API, SDK, insight, blockcypher, gocoin, instantsend, python, .NET, java, javascript, nodejs, php, objective-c, vending machines

.. _integration:

====================
Integration Overview
====================

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Dash_v0.13_IntegrationOverview.pdf>`__.

`Dash Core <https://github.com/dashpay/dash>`__ is a “fork” of
`Bitcoin Core <https://github.com/bitcoin/bitcoin>`__ and shares many common functionalities. Key differences relate
to existing JSON-RPC commands which have been customized to support
unique functionalities such as InstantSend.

1. **General Information:** Dash is a “Proof of Work” network and is
   similar to Bitcoin.

   a. Block Time: ~2.6 Minutes per Block
   b. Github Source: https://github.com/dashpay/dash
   c. Latest Release: https://github.com/dashpay/dash/releases

2. **JSON-RPC Interface:** The majority of commands are unchanged from
   Bitcoin making integration into existing systems relatively
   straightforward. Note that the following commands have been modified 
   to support InstantSend:

   - `getrawmempool <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `getmempoolancestors <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `getmempooldescendants <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `getmempoolentry <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `getrawtransaction <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `decoderawtransaction <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `gettransaction <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `listtransactions <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
   - `listsinceblock <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__

3. **Block Hashing Algorithm:** Dash uses the “X11” algorithm in place
   of SHA256 used in Bitcoin. It’s important to note, however, that this
   only affects the hashing of the Block itself. All other internals
   utilize SHA256 hashes (transactions, merkle root, etc) which allows
   for most existing libraries to work in the Dash ecosystem. 

4. **Special Transactions:** Dash Core v0.13.x introduces the concept of
   “Special Transactions”. Please see the `Transaction Type Integration Guide <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-Dash-v0.13.0-Transaction-Types.pdf>`__ 
   for more information.


.. _integration-special-transactions:

Special Transactions
====================

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-Dash-v0.13.0-Transaction-Types.pdf>`__.

Dash 0.13.0 and higher implement `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__, 
which form a basis for new transaction types that provide on-chain
metadata to assist various consensus mechanisms. The following special
transaction types exist:

+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| Release | Version | Type | Payload Size   | Payload | Payload JSON | Transaction Purpose                                                                            |
+=========+=========+======+================+=========+==============+================================================================================================+
| v0.13.0 | 3       | 0    | n/a            | n/a     | n/a          | Standard Transaction                                                                           |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 1    | <variable int> | <hex>   | proRegTx     | `Masternode Registration <https://dash-docs.github.io/en/developer-reference#proregtx>`__      |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 2    | <variable int> | <hex>   | proUpServTx  | `Update Masternode Service <https://dash-docs.github.io/en/developer-reference#proupservtx>`__ |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 3    | <variable int> | <hex>   | proUpRegTx   | `Update Masternode Operator <https://dash-docs.github.io/en/developer-reference#proupregtx>`__ |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 4    | <variable int> | <hex>   | proUpRevTx   | `Masternode Revocation <https://dash-docs.github.io/en/developer-reference#prouprevtx>`__      |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 5    | <variable int> | <hex>   | cbTx         | `Masternode List Merkle Proof <https://dash-docs.github.io/en/developer-reference#cbtx>`__     |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 6    | <variable int> | <hex>   | qcTx         | `Quorum Commitment <https://dash-docs.github.io/en/developer-reference#qctx>`__                |
+---------+---------+------+----------------+---------+--------------+------------------------------------------------------------------------------------------------+

Integration notes:

1. `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__ 
   are a foundational component of Dash Core v0.13.0 and introduce a new
   Transaction Version and related “Payload” to the network.

2. Integrated Systems must be able to `serialize and deserialize <https://github.com/dashpay/dips/blob/master/dip-0002.md#serialization-hashing-and-signing>`__ 
   these new Transaction Types in order to accurately encode and decode
   Raw Transaction data.

3. From a `backwards compatibility <https://github.com/dashpay/dips/blob/master/dip-0002.md#compatibility>`__ 
   perspective, the 4 byte (32-bit) ``version`` field included in Legacy
   Transactions has been split into two fields: ``version`` and ``type``
   (each consisting of 2 bytes).

4. Refer to the `Special Transactions <https://dash-docs.github.io/en/developer-reference#special-transactions>`__ 
   section of the dash developer reference for additional detail on
   these data types, e.g. <variable int>.

5. `InstantSend <https://docs.dash.org/en/stable/integration/technical.html#instantsend>`__ 
   status and Payload JSON (e.g. ``proRegTx``) is included in the 
   JSON-RPC response, please note that this data is not part of the
   calculated hash and is provided for convenience.

See the `v0.13.0 transaction types integration documentation (PDF) <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-Dash-v0.13.0-Transaction-Types.pdf>`__
for worked examples of each transaction type.


.. _integration-instantsend:

InstantSend
===========

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Dash_v0.13_InstantSend.pdf>`__.

InstantSend is a feature provided by the Dash network that allows for
zero-confirmation transactions to be safely accepted and re-spent. All
valid transactions are secured by the Dash network at the moment of
broadcast. Every secured transaction is included in the next block in
accordance with standard blockchain principles.

InstantSend is enabled by the Masternode Network which comprises
approximately 5,000 masternode servers. These nodes are differentiated
from standard nodes by having proven ownership of 1,000 Dash, making the
network `highly resistant to Sybil attacks <https://en.wikipedia.org/wiki/Sybil_attack>`__. 
Masternodes form `Long-Living Masternode Quorums (LLMQs) <https://github.com/dashpay/dips/blob/master/dip-0006.md>`__, 
which are responsible for providing near instant certainty to the transaction
participants that the transaction inputs cannot be respent, and that the
transaction will be included in a following block instead of a conflicting
transaction. 

This concept works as an extension to Nakamoto Consensus. InstantSend
enables transacted funds to be immediately and securely respent by the
recipient, even before the transaction is included in a block.


Receiving InstantSend Transactions
----------------------------------

Receiving an InstantSend Transaction introduces two requirements:

1. The ability to determine the “InstantSend Status” of a given 
   transaction.

2. The ability to adjust “Confirmation Status” independently of block 
   confirmation.

InstantSend Status is typically determined through direct connection
with the dash daemon, `ZMQ notification <https://github.com/dashpay/dash/blob/master/doc/instantsend.md#zmq>`__,
or through the usage of an external wallet notification script.

**Direct Connection:** InstantSend Status can be identified through
direct connection with the Dash daemon using JSON-RPC protocol. The
“instantlock” attribute of the JSON response reflects the status of the
transaction and is included in the following commands:

- `getrawmempool <https://dash-docs.github.io/en/developer-reference#getrawmempool>`__
- `getmempoolancestors <https://dash-docs.github.io/en/developer-reference#getmempoolancestors>`__
- `getmempooldescendants <https://dash-docs.github.io/en/developer-reference#getmempooldescendants>`__
- `getmempoolentry <https://dash-docs.github.io/en/developer-reference#getmempoolentry>`__
- `getrawtransaction <https://dash-docs.github.io/en/developer-reference#getrawtransaction>`__
- `decoderawtransaction <https://dash-docs.github.io/en/developer-reference#decoderawtransaction>`__
- `gettransaction <https://dash-docs.github.io/en/developer-reference#gettransaction>`__
- `listtransactions <https://dash-docs.github.io/en/developer-reference#listtransactions>`__
- `listsinceblock <https://dash-docs.github.io/en/developer-reference#listsinceblock>`__


**ZMQ Notification:** Whenever a transaction enters the mempool and
whenever a transaction is locked in the mempool, ZMQ notifications can
be broadcast by the node. A list of possible ZMQ notifications can be
found `here <https://github.com/dashpay/dash/blob/master/doc/zmq.md#usage>`__. 

The following notifications are relevant for recognizing transactions
and their corresponding instantlocks:

- zmqpubhashtx
- zmqpubhashtxlock
- zmqpubrawtx
- zmqpubrawtxlock

**Wallet Notification:** The Dash Core Daemon can be configured to 
execute an external script whenever an InstantSend transaction relating
to that wallet is observed. This is configured by adding the following
line to the dash.conf file::

  instantsendnotify=/path/to/concurrent/safe/handler %s

This is typically used with a wallet that has been populated with 
`watch-only <https://dash-docs.github.io/en/glossary/watch-only-address>`__ 
addresses.

Broadcasting InstantSend Transactions
-------------------------------------

Since Dash 0.14.0 established LLMQ on the Dash network, quorums will now
attempt to lock every valid transaction by default without any
additional fee or action by the sending wallet or user. A transaction is
eligible for InstantSend when each of its inputs is considered
confirmed. This is the case when at least one of the following circumstances is true: 

- the previous transaction referred to by the input is confirmed with 6 
  blocks
- the previous transaction is confirmed through an older InstantSend 
  lock
- the block containing the previous transaction is `ChainLocked <https://github.com/dashpay/dips/blob/master/dip-0008.md>`__

When checking the previous transaction for an InstantSend lock, it is
important to also do this on mempool (non-mined) transactions. This
allows chained InstantSend locking.


Additional Resources
--------------------

The following resources provide additional information about InstantSend
and are intended to help provide a more complete understanding of the
underlying technologies.

- `InstantSend Technical Information <https://github.com/dashpay/dash/blob/master/doc/instantsend.md#zmq>`__
- `InstantSend Developer Documentation <https://dash-docs.github.io/en/developer-guide#llmq-instantsend>`__
- `DIP0010: LLMQ InstantSend <https://github.com/dashpay/dips/blob/master/dip-0010.md>__
- `Product Brief: Dash Core v0.14 Release <https://blog.dash.org/product-brief-dash-core-release-v0-14-0-now-on-testnet-8f5f4ad45c96>`__


.. _api-services:

API Services
============

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-API.pdf>`__.

Several API services exist to facilitate quick and easy integration with
the Dash network for services including:

- Transaction broadcasting
- Exchange rates
- Currency conversion
- Invoice generation

API Services are typically leveraged to eliminate that requirement of
running your own infrastructure to support blockchain interactions. This
includes mechanisms such as:

- Forming and Broadcasting a Transaction to the network.
- Address generation using HD Wallets.
- Payment Processing using WebHooks.

There are a variety of options for supporting these methods, with the
key differentiator being the pricing model included and supported
features. The following list of API Providers attempts to outline these
key features/differentiators and also includes a link to related
documentation.


Insight
-------

.. image:: img/insight.png
   :width: 200px
   :align: right
   :target: https://github.com/dashevo/insight-api

https://github.com/dashevo/insight-api

The open-source Insight REST API provides you with a convenient,
powerful and simple way to read data from the Dash network and build
your own services with it. A practical guide to getting started with the
Insight API and Insight UI block explorer is available :ref:`here
<insight-api>`.

- Features: Transaction Broadcast, WebSocket Notifications.
- Pricing Model: Free / Open Source
- Documentation: https://github.com/dashevo/insight-api


BlockCypher
-----------

.. image:: img/blockcypher.png
   :width: 200px
   :align: right
   :target: https://www.blockcypher.com

https://www.blockcypher.com

BlockCypher is a simple, mostly RESTful JSON API for interacting with
blockchains, accessed over HTTP or HTTPS from the api.blockcypher.com
domain.

- Features: Transaction Broadcast, HD Wallet / Address Generation,
  WebSocket and WebHook Callbacks as well as Payment Forwarding.
  BlockCypher does not handle Private Keys.
- Pricing Model: Per API Call, 5000 Requests -> $85.00 per month
  (https://accounts.blockcypher.com/plans)
- Documentation: https://www.blockcypher.com/dev/dash/


BitGo
-----

.. image:: img/bitgo.png
   :width: 200px
   :align: right
   :target: https://www.bitgo.com

https://www.bitgo.com

BitGo provides a simple and robust RESTful API and client SDK to
integrate digital currency wallets with your application. Support for
Dash InstantSend is available.

- Features: Multi-Signature HD Wallets, Wallet Operations, WebSocket and
  WebHook Notifications, Custody Solutions
- Pricing Model: Per API Call
- Documentation: https://www.bitgo.com/api/v2/

ChainRider
----------

.. image:: img/chainrider.png
   :width: 200px
   :align: right
   :target: https://www.chainrider.io

https://www.chainrider.io

ChainRider is a cloud service providing a set of REST APIs for digital
currency management and exploration.

- Features: Blockchain queries, Event Notifications, Transaction
  Broadcast, Payment Processing, etc.
- Pricing Model: Free trial, pay per API call
- Documentation: https://www.chainrider.io/docs/dash


GoCoin
------

.. image:: img/gocoin.png
   :width: 200px
   :align: right
   :target: https://gocoin.com

https://gocoin.com

The GoCoin platform makes taking Dash as easy as installing a plugin.
Payment processing is already implemented for every major shopping
platform. GoCoin is focused on helping merchants in privacy-related
niches and specific industries, and handles all transaction risk for
all payments from your customers.

- Features: Invoicing, Exchange Rates, WebHook Callbacks. GoCoin holds
  Private Keys on their server allowing the merchant to withdraw funds
  in Cryptocurrency or convert to Fiat.
- Integrations: WooCommerce, Magento, Prestashop, VirtueMart, ZenCart,
  OpenCart, OSCommerce, UberCart, nopCommerce, WHMCS, NATS4, Shopify.
- Pricing Model: 1% Processing Fee (https://gocoin.com/fees)
- Documentation: https://gocoin.com/docs


CoinPayments
------------

.. image:: img/coinpayments.png
   :width: 200px
   :align: right
   :target: https://www.coinpayments.net

https://www.coinpayments.net

CoinPayments is an integrated payment gateway for cryptocurrencies
such as Dash. Shopping cart plugins are available for all popular
webcarts used today. CoinPayments can help you set up a new checkout,
or integrate with your pre-existing checkout.

- Features: Invoicing, Exchange Rates, WebHook Callbacks. CoinPayments
  holds Private Keys on their server allowing merchant to withdraw
  funds in Cryptocurrency or convert to Fiat.
- Integrations: aMember Pro, Arastta, Blesta, BoxBilling, Drupal,
  Ecwid, Hikashop, Magento, OpenCart, OSCommerce, PrestaShop, Tomato
  Cart, WooCommerce, Ubercart, XCart, ZenCart
- Pricing Model: 0.5% Processing Fee
  (https://www.coinpayments.net/help-fees)
- Documentation: https://www.coinpayments.net/apidoc


.. _sdk-resources:

SDK Resources
=============

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-SDK.pdf>`__.

SDKs (Software Development Kits) are used to accelerate the design and
development of a product for the Dash Network. These resources can
either be used to interface with an API provider or for the creation of
standalone applications by forming transactions and/or performing
various wallet functions.


Dash Developer Guide
--------------------

.. image:: img/dash-logo.png
   :width: 200px
   :align: right
   :target: https://dash-docs.github.io/en/developer-guide

https://dash-docs.github.io/en/developer-guide

The Dash Developer Guide aims to provide the information you need to
understand Dash and start building Dash-based applications. To make the
best use of this documentation, you may want to install the current
version of Dash Core, either from source or from a pre-compiled
executable.

- Documentation: https://dash-docs.github.io/en/developer-guide

NodeJS/JavaScript: Dashcore
-------------------------------------

.. image:: img/bitcore.png
   :width: 200px
   :align: right
   :target: https://bitcore.io

https://bitcore.io

Dashcore is a fork of Bitcore and operates as a full Dash node — your
apps run directly on the peer-to-peer network. For wallet application
development, additional indexes have been added into Dash for querying
address balances, transaction history, and unspent outputs.

- Platform: NodeJS / Javascript
- Documentation: https://bitcore.io/api/lib
- Repository lib: https://github.com/dashevo/dashcore-lib
- Repository node: https://github.com/dashevo/dashcore-node
- See also: `Insight API <https://github.com/dashevo/insight-api>`__

PHP: Bitcoin-PHP
----------------

https://github.com/snogcel/bitcoin-php

Bitcoin-PHP is an implementation of Bitcoin with support for Dash using
mostly pure PHP.

- Platform: PHP
- Documentation: https://github.com/Bit-Wasp/bitcoin-php/blob/master/doc/Introduction.md
- Repository: https://github.com/snogcel/bitcoin-php

Python: PyCoin
--------------

https://github.com/DeltaEngine/pycoin

PyCoin is an implementation of a bunch of utility routines that may be
useful when dealing with Bitcoin and Dash. It has been tested
with Python 2.7, 3.6 and 3.7.

- Platform: Python
- Documentation: https://pycoin.readthedocs.io/en/latest/
- Repository: https://github.com/DeltaEngine/pycoin
- See also: `JSON-RPC Utilities <https://github.com/DeltaEngine/python-dashrpc>`__

Java: DashJ
-----------

.. image:: img/bitcoinj.png
   :width: 200px
   :align: right
   :target: https://github.com/HashEngineering/dashj 

https://github.com/HashEngineering/dashj 

DashJ is a library for working with the Dash protocol. It can maintain a
wallet, send/receive transactions (including InstantSend) without
needing a local copy of Dash Core, and has many other advanced features.
It's implemented in Java but can be used from any JVM compatible
language: examples in Python and JavaScript are included.

- Platform: Java
- Documentation: https://bitcoinj.github.io/getting-started
- Repository: https://github.com/HashEngineering/dashj
- Example application: https://github.com/tomasz-ludek/pocket-of-dash

Objective-C: Dash-Sync
----------------------

.. image:: img/dash-logo.png
   :width: 200px
   :align: right
   :target: https://github.com/dashevo/dashsync-iOS

https://github.com/dashevo/dashsync-iOS

Dash-Sync is an Objective-C Dash blockchain framework for iOS. It
implements all most relevant Bitcoin Improvement Proposals (BIPs) and
Dash Improvement Proposals (DIPs).

- Platform: iOS
- Repository: https://github.com/dashevo/dashsync-iOS

.NET: NBitcoin
--------------

.. image:: img/dash-logo.png
   :width: 200px
   :align: right
   :target: https://github.com/MetacoSA/NBitcoin

https://github.com/MetacoSA/NBitcoin

NBitcoin is the most complete Bitcoin library for the .NET platform, and
has been patched to include support for Dash. It implements all most
relevant Bitcoin Improvement Proposals (BIPs) and Dash Improvement
Proposals (DIPs). It also provides low level access to Dash primitives
so you can easily build your application on top of it.

- Platform: .NET
- Documentation: https://programmingblockchain.gitbooks.io/programmingblockchain/content/ 
- Repository: https://github.com/MetacoSA/NBitcoin
- See also: `JSON-RPC Utilities <https://github.com/cryptean/bitcoinlib>`__

BlockCypher
-----------

.. image:: img/blockcypher.png
   :width: 200px
   :align: right
   :target:  https://www.blockcypher.com

https://www.blockcypher.com

BlockCypher also offers client SDKs.

- Platform: Ruby, Python, Java, PHP, Go, NodeJS
- Repositories: https://www.blockcypher.com/dev/dash/#blockcypher-supported-language-sdks 

GoCoin
------

.. image:: img/gocoin.png
   :width: 200px
   :align: right
   :target: https://gocoin.com

https://gocoin.com

- Platform: JavaScript, PHP, Java, Ruby, .NET, Python
- Repositories: https://gocoin.com/docs 


Vending Machines
================

Community member moocowmoo has released code to help merchants build
their own vending machine and set it up to receive Dash InstantSend
payments. The Dashvend software can also be used to create any sort of
payment system, including point-of-sale systems, that can accept
InstantSend payments.

- `Open Source Code <https://github.com/moocowmoo/dashvend>`_
- `Demonstration website <http://code.dashndrink.com>`_
- `Demonstration video <https://www.youtube.com/watch?v=SX-3kwbam0o>`_


Price Tickers
=============

You can add a simple price ticker widget to your website using the
simple `code snippet generator from CoinGecko
<https://www.coingecko.com/en/widgets/ticker/dash/usd>`_.

.. raw:: html

    <div style="position: relative; margin-bottom: 1em; overflow: hidden; max-width: 70%; height: auto;">
        <iframe id='widget-ticker-preview' src='//www.coingecko.com/en/widget_component/ticker/dash/usd?id=dash' style='border:none; height:125px; width: 275px;' scrolling='no' frameborder='0' allowTransparency='true'></iframe>
    </div>

Similar widgets with different designs are available from `CoinLib
<https://coinlib.io/widgets>`_, `WorldCoinIndex
<https://www.worldcoinindex.com/Widget>`_ and `Cryptonator
<https://www.cryptonator.com/widget>`_, while an API providing similar
information is available from `DashCentral
<https://www.dashcentral.org/about/api>`_.

QR Codes
========

Many wallets are capable of generating QR codes which can be scanned to
simplify entry of the Dash address. Printing these codes or posting the
on your website makes it easy to receive payment and tips in Dash, both
online and offline.

- In Dash Core, go to the **Receive** tab, generate an address if
  necessary, and double-click it to display a QR code. Right click on
  the QR code and select **Save Image** to save a PNG file.
- In Dash for Android, tap **Request Coins** and then tap the QR code to
  display a larger image. You can screenshot this to save an image.
- In Dash for iOS, swipe to the left to display the **Receive Dash**
  screen. A QR code and address will appear. You can screenshot this to
  save an image.
- To generate a QR code from any Dash address, visit `CWA QR Code
  Generator <https://cwaqrgen.com/dash>`_ and simply paste your Dash
  address to generate an image.
