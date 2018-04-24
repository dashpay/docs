.. _merchants-technical:

================
Technical Guides
================

Several API services exist to facilitate quick and easy integration with
the Dash network for services including:

- Transaction broadcasting
- Exchange rates
- Currency conversion
- Invoice generation

API Services
============

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-API.pdf>`__.

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
your own services with it.

- Features: Transaction Broadcast, WebSocket Notifications.
- Pricing Model: Free / Open Source
- Documentation: https://github.com/dashevo/insight-api


BlockCypher
-----------

.. image:: img/blockcypher.png
   :width: 200px
   :align: right
   :target:  https://www.blockcypher.com

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
  (https://www.coinpayments.net/help- fees)
- Documentation: https://www.coinpayments.net/apidoc


SDK Resources
=============

This documentation is also available as a `PDF
<https://github.com/dashpay/docs/raw/master/binary/merchants
/Integration-Resources-SDK.pdf>`__.

SDKs (Software Development Kits) are used to accelerate the design and
development of a product for the Dash Network. These resources can
either be used to interface with an API provider or for the creation of
standalone applications.


Dash Developer Guide
--------------------

.. image:: img/dash.png
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


Bitcore
-------

.. image:: img/bitcore.png
   :width: 200px
   :align: right
   :target: https://bitcore.io

https://bitcore.io

Bitcore is a full Dash node — your apps run directly on the 
peer-to-peer network. For wallet application development, additional
indexes have been added into Dash for querying address balances,
transaction history, and unspent outputs.

- Platform: NodeJS / Javascript
- Documentation: https://bitcore.io/api/lib
- Repository: https://github.com/dashevo/bitcore-lib-dash


DashJ
-----

.. image:: img/bitcoinj.png
   :width: 200px
   :align: right
   :target: https://github.com/HashEngineering/dashj 

https://github.com/HashEngineering/dashj 

dashj is a library for working with the Dash protocol. It can maintain
a wallet, send/receive transactions without needing a local copy of
Dash Core and has many other advanced features. It's implemented in
Java but can be used from any JVM compatible language: examples in
Python and JavaScript are included.

- Platform: Java
- Documentation: https://bitcoinj.github.io/getting-started 


NBitcoin
--------

.. image:: img/dash.png
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

   a. Web Socket: https://github.com/dashpay/insight-api-dash#web-socket-api
   b. Transaction API: https://github.com/dashpay/insight-api-dash#instantsend-transactions 

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
