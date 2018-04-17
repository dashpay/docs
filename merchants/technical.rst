.. _merchants-technical:

=========
Technical
=========

Several API services exist to facilitate quick and easy integration with
the Dash network for services including:

- Transaction broadcasting
- Exchange rates
- Currency conversion
- Invoice generation

API Services
============

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

Insight API
  .. image:: img/insight.png
     :width: 200px
     :align: right
     :target: https://github.com/dashevo/insight-api
  
  https://github.com/dashevo/insight-api

  An open-source Dash blockchain API

  The Insight REST API provides you with a convenient, powerful and
  simple way to read data from the Dash network and build your own
  services with it.

  - Features: Transaction Broadcast, WebSocket Notifications.
  - Pricing Model: Free / Open Source
  - Documentation: https://github.com/dashevo/insight-api

BlockCypher API
---------------

- Features: Transaction Broadcast, HD Wallet / Address Generation,
  WebSocket and WebHook Callbacks as well as Payment Forwarding.
  BlockCypher does not handle Private Keys.
- Pricing Model: Per API Call, 5000 Requests -> $85.00 per month
  (https://accounts.blockcypher.com/plans)
- Documentation: https://www.blockcypher.com/dev/dash/

GoCoin API
----------

- Features: Invoicing, Exchange Rates, WebHook Callbacks. GoCoin holds
  Private Keys on their server allowing the merchant to withdraw funds
  in Cryptocurrency or convert to Fiat.
- Integrations: WooCommerce, Magento, Prestashop, VirtueMart, ZenCart,
  OpenCart, OSCommerce, UberCart, nopCommerce, WHMCS, NATS4, Shopify.
- Pricing Model: 1% Processing Fee (https://gocoin.com/fees)
- Documentation: https://gocoin.com/docs

CoinPayments API
----------------

- Features: Invoicing, Exchange Rates, WebHook Callbacks. CoinPayments
  holds Private Keys on their server allowing merchant to withdraw funds
  in Cryptocurrency or convert to Fiat.
- Integrations: aMember Pro, Arastta, Blesta, BoxBilling, Drupal, Ecwid,
  Hikashop, Magento, OpenCart, OSCommerce, PrestaShop, Tomato Cart,
  WooCommerce, Ubercart, XCart, ZenCart
- Pricing Model: 0.5% Processing Fee (https://www.coinpayments.net/help-
  fees)
- Documentation: https://www.coinpayments.net/apidoc


SDK Resources
=============

SDKs (Software Development Kits) are used to accelerate the design and
development of a product for the Dash Network. These resources can
either be used to interface with an API provider or for the creation of
standalone applications.

Dash Developer Guide
Documentation: https://dash-docs.github.io/en/developer-guide


Bitcore
Platform: NodeJS / Javascript
Documentation: https://bitcore.io/api/lib
Repository: https://github.com/dashevo/bitcore-lib-dash


DashJ
Platform: Java
Documentation: https://bitcoinj.github.io/getting-started 
Link: https://github.com/HashEngineering/dashj 


NBitcoin
Platform: .NET
Documentation: https://programmingblockchain.gitbooks.io/programmingblockchain/content/ 
Repository: https://github.com/MetacoSA/NBitcoin


BlockCypher SDK
Platform: Ruby, Python, Java, PHP, Go, NodeJS
Repositories: https://www.blockcypher.com/dev/dash/#blockcypher-supported-language-sdks 


GoCoin SDK
Platform: JavaScript, PHP, Java, Ruby, .NET, Python
Repositories: https://gocoin.com/docs 