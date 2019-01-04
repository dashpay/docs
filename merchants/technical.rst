.. meta::
   :description: Technical guides for merchants using Dash. API and SDK resources.
   :keywords: dash, merchants, payment processor, API, SDK, insight, blockcypher, gocoin, instantsend, vending machines

.. _merchants-technical:

================
Technical Guides
================

Dash Wallet Integration
=======================

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-Wallet-Integration.pdf>`__.

`Dash Core <https://github.com/dashpay/dash/releases>`__ is a fork of
Bitcoin and the majority of functionality included in the Dash Core
Daemon can be integrated in a similar manner. Key differences relate to
customizations to existing JSON-RPC commands to support unique
functionalities such as InstantSend. These differences, as well as more
general information, are summarized below.

1. **General Information:** Dash is a “Proof of Work” blockchain with
   attributes similar to that of Bitcoin.

   a. Block Time: ~2.6 Minutes per Block
   b. Blockchain Confirmations: 6 Confirmations (or 1 in the case of 
      InstantSend)
   c. Github Source: https://github.com/dashpay/dash
   d. Release Link: https://github.com/dashpay/dash/releases

2. **JSON-RPC Interface:** The majority of Bitcoin JSON-RPC commands are
   unchanged making integration into existing systems relatively
   straightforward. For a complete listing of RPC commands see the 
   `Developer Guide <https://dash-docs.github.io/en/developer-guide>`__.

   It’s worth noting that several key Transaction-related JSON-RPC
   commands have been modified to support InstantSend through the
   addition of an “InstantLock” field and are listed below:

   a. `GetTransaction <https://dash-docs.github.io/en/developer-reference#gettransaction>`__
   b. `ListTransactions <https://dash-docs.github.io/en/developer-reference#listtransactions>`__
   c. `ListSinceBlock <https://dash-docs.github.io/en/developer-reference#listsinceblock>`__

3. **Block Hashing Algorithm:** Dash uses the “X11” algorithm in place
   of SHA256 used in Bitcoin. It’s important to note, however, that this
   only affects the hashing of the Block itself. All other internals
   utilize SHA256 hashes (transactions, merkle root, etc) which allows 
   for most existing libraries to work in the Dash ecosystem.

4. **Supporting Libraries:** Due to the aforementioned differences in
   Hashing Algorithm only minor adjustments are required before using
   Bitcoin libraries on the Dash network. The most popular libraries
   have already been ported to Dash which has enabled support for most
   major programming languages. These resources are outlined in the
   :ref:`SDK Resources <sdk-resources>` section of this document.

.. _13-integration:

v0.13.0 Integration Notes
=========================

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/merchants/Integration-Resources-Dash-v0.13.0-Transaction-Types.pdf>`__.

Dash 0.13.0 implements `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__, 
which form a basis for new transaction types that will provide on-chain
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
   perspective, the 4 byte (32-bit) “version” field included in Legacy
   Transactions has been split into two fields: “version” and “type”
   (each consisting of 2 bytes).
4. `InstantSend <https://docs.dash.org/en/latest/merchants/technical.html#instantsend>`__ 
   status and Payload JSON (e.g. “proRegTx”) is included in the JSON-RPC
   response, please note that this data is not part of the calculated
   hash and is provided for convenience.

Legacy transaction structure::

  {
    "txid": <string>,
    "size": <int>,
    "version": 2,
    "locktime": 0,
    "vin": [],
    "vout": [ … ]
  }

Updated transaction structure::

  {
    "txid": <string>,
    "size": <int>,
    "version": 3,
    "type": <int>,
    "locktime": 0,
    "vin": [ … ],
    "vout": [ … ],
    "extraPayloadSize": <variable int>,
    "extraPayload": …
  }

See the `Special Transactions developer documentation <https://dash-docs.github.io/en/developer-reference#special-transactions>`__ 
for additional detail on these data types, e.g. ``<variable int>``. See 
the `v0.13.0 transaction types integration documentation (PDF) <https://github.com/dashpay/docs/raw/master/binary/merchants/Integration-Resources-Dash-v0.13.0-Transaction-Types.pdf>`__
for worked examples of each transaction type.

.. _api-services:

API Services
============

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-API.pdf>`__.

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

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-SDK.pdf>`__.

SDKs (Software Development Kits) are used to accelerate the design and
development of a product for the Dash Network. These resources can
either be used to interface with an API provider or for the creation of
standalone applications by forming transactions and/or performing
various wallet services.


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

NodeJS/JavaScript: Bitcore (Dashcore)
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

PHP: Bitcoin-PHP
----------------

https://github.com/Bit-Wasp/bitcoin-php

Bitcoin-PHP is an implementation of Bitcoin with support for Dash using
mostly pure PHP.

- Platform: PHP
- Documentation: https://github.com/Bit-Wasp/bitcoin-php/blob/master/doc/Introduction.md
- Repository: https://github.com/Bit-Wasp/bitcoin-php

Python: PyCoin
--------------

https://github.com/richardkiss/pycoin

PyCoin is an implementation of a bunch of utility routines that may be
useful when dealing with Bitcoin and Dash. It has been tested
with Python 2.7, 3.6 and 3.7.

- Platform: Python
- Documentation: https://pycoin.readthedocs.io/en/latest/
- Repository: https://github.com/richardkiss/pycoin

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
- Example application: https://github.com/tomasz-ludek/pocket-of-dash

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


InstantSend
===========

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-InstantSend.pdf>`__.

InstantSend is a feature provided by the Dash network that allows for
0-confirmation transactions to be safely accepted by Merchants and other
service providers. Secured by the Masternode Network, this mechanism
eliminates the risk of a “Double Spend” by locking transaction inputs
for a given transaction at a protocol level.


InstantSend Transactions vs. Standard Transactions
--------------------------------------------------

From an integration perspective there are only minor differences between
an InstantSend Transaction and a Standard Transaction. Both transaction
types are formed in the same way and are signed using the same process;
the key difference is the fee structure and input requirements for
InstantSend. 

#. Fee Structure: InstantSend utilizes a “per-input” fee of 0.0001 DASH
   per Input.
#. Input Requirements: All inputs for an InstantSend transaction must
   have at least 6 confirmations.

In the event that a given transaction does not meet both criteria it
will revert to a standard transaction.

Receiving InstantSend Transactions
----------------------------------

InstantSend transactions are handled in the same way as a Standard
Transaction, typically through JSON-RPC, Insight API, or an internal
notification script / service that is configured at a server level.

#. JSON-RPC: The following RPC commands will include InstantSend-related
   information. Within the response you’ll find an “InstantLock” field
   the status of a given Transaction. This true/false (boolean) value
   will indicate whether an InstantSend has been observed.

   a. GetTransaction: https://dash-docs.github.io/en/developer-reference#gettransaction 
   b. ListTransactions: https://dash-docs.github.io/en/developer-reference#listtransactions 
   c. ListSinceBlock: https://dash-docs.github.io/en/developer-reference#listsinceblock 	

#. Insight API: Insight API can be used to detect InstantSend
   transactions and to push notifications to clients using WebSockets.
   The API can also be manually polled to retrieve Transaction
   information including InstantSend status.

   a. Web Socket: https://github.com/dashevo/insight-api#web-socket-api
   b. Transaction API: https://github.com/dashevo/insight-api#instantsend-transactions

#. Script Notify: The Dash Core Daemon can be configured to execute an
   external script whenever an InstantSend transaction relating to that
   wallet is observed. This is configured by adding the following line
   to the dash.conf file:

   ``instantsendnotify=/path/to/concurrent/safe/handler %s``

   *Note that only addresses imported to the wallet will be monitored for
   InstantSend Transactions.*

Broadcasting InstantSend Transactions
-------------------------------------

InstantSend Transactions can be constructed and broadcast using an
approach similar to Standard Transactions. Provided the InstantSend Fee
Structure and Input Requirements are met, an InstantSend can be
broadcast using JSON-RPC or Insight API as a Raw Transaction.

#. JSON-RPC: The “SendRawTransaction” RPC command can be utilized to
   broadcast a raw transaction using InstantSend. When utilizing this
   command be sure to set both optional parameters as “true”

   ``sendrawtransaction "hexstring" ( allowhighfees instantsend )``
   ``sendrawtransaction "hexstring" true true``

   More Information: https://dash-docs.github.io/en/developer-reference#sendrawtransaction 

#. Insight API: Raw Transactions can also be broadcast as an InstantSend
   using Insight API. In this case all that is required is to POST the
   raw transaction using the ``/tx/sendix`` route.

   More Information: https://github.com/dashevo/insight-api#instantsend-transaction 

Additional Resources
--------------------

The following resources provide additional information about InstantSend
and are intended to help provide a more complete understanding of the
underlying technologies.

- `InstantSend Whitepaper <https://dashpay.atlassian.net/wiki/download/attachments/75530298/Dash%20Whitepaper%20-%20InstantTX.pdf>`_
- `How Dash InstantSend Protect Merchants from Double Spends <https://www.youtube.com/watch?v=HJx82On8jig>`_
- `InstantSend Presentation from the Dash Conference London 2017 <https://www.youtube.com/watch?v=n4PELomRiFY>`_


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

You can add a simple price ticket widget to your website using the
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
