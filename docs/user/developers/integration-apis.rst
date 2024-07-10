.. meta::
   :description: API resources for using Dash.
   :keywords: dash, merchants, payment processor, API, SDK, insight, blockcypher, instantsend, python, .NET, java, javascript, nodejs, php, objective-c


.. _api-services:

API Services
============

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
   :target: https://github.com/dashpay/insight-api

https://github.com/dashpay/insight-api

The open-source Insight REST API provides you with a convenient,
powerful and simple way to read data from the Dash network and build
your own services with it. A practical guide to getting started with the
Insight API and Insight UI block explorer is available :ref:`here
<insight-api>`.

- Features: Transaction Broadcast, WebSocket Notifications.
- Pricing Model: Free / Open Source
- Documentation: https://github.com/dashpay/insight-api


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
  (https://accounts.blockcypher.com)
- Documentation: https://www.blockcypher.com/dev/bitcoin/


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
- Documentation: https://app.bitgo.com/docs/

Blockmove
---------

.. image:: img/blockmove.png
   :width: 200px
   :align: right
   :target: https://blockmove.io

https://blockmove.io

Cryptocurrency wallet, merchant & API provider. Blockmove is a simple
and easy way to start accepting payments in cryptocurrency.

- Features: Non-custodial wallet, HD Wallet, High anonymity, Low fees. 
  Private keys are not stored and are available only to the user. 
- Pricing Model: API - 0.3% for withdrawal transactions. Merchant - 1 
  year free, then $49/month 
- Documentation: https://docs.blockmove.io


NOWNodes
--------

.. image:: img/nownodes.png
   :width: 200px
   :align: right
   :target: https://nownodes.io

https://nownodes.io/

NOWNodes provides simple, fast, and secure RPC access to Dash-based full
nodes. The low latency and high performance is of great use to
researchers and businesses such as crypto miners or hardware wallet
providers.

- Features: All Dash RPC commands
- Pricing Model: Free up to 20k requests, Pricing tiers
- Documentation: https://nownodes.io/documentation

Tokenview
---------

.. image:: img/tokenview.png
   :width: 200px
   :align: right
   :target: https://services.tokenview.io

https://services.tokenview.io

Tokenview provides a Dash API, making it easy for developers to create
cryptocurrency payment applications and develop Dash dApps. Monitoring
and alerts features are available to notify applications of balance changes
in real time.

- Features: Fully access Dash historical and real-time on-chain data for 
  non-custodial wallet, HD wallet. High performance and high availability.
- Pricing Model: Free up to 1 million requests, pricing tiers.
- Documentation: https://services.tokenview.io/docs?type=api


CoinPayments
------------

.. image:: img/coinpayments.png
   :width: 200px
   :align: right
   :target: https://www.coinpayments.net

https://www.coinpayments.net

CoinPayments is an integrated payment gateway for cryptocurrencies
such as Dash. Shopping cart plugins are available for all popular
webcarts used today. CoinPayments can help you set up a new checkout
or integrate with your pre-existing checkout.

- Features: Invoicing, Exchange Rates, WebHook Callbacks. CoinPayments
  holds Private Keys on their server allowing merchants to withdraw
  funds in Cryptocurrency or convert to fiat.
- Integrations: aMember Pro, Arastta, Blesta, BoxBilling, Drupal,
  Ecwid, Hikashop, Magento, OpenCart, OSCommerce, PrestaShop, Tomato
  Cart, WooCommerce, Ubercart, XCart, ZenCart
- Pricing Model: 0.5% Processing Fee
  (https://www.coinpayments.net/help-fees)
- Documentation: https://www.coinpayments.net/apidoc


Price Tickers
=============

You can add a simple price ticker widget to your website using the
simple `code snippet generator from CoinGecko
<https://www.coingecko.com/en/widgets/coin_ticker_widget>`_.

.. raw:: html

    <div style="position: relative; margin-bottom: 1em; overflow: hidden; max-width: 70%; height: auto;">
        <iframe id='widget-ticker-preview' src='//www.coingecko.com/en/widget_component/ticker/dash/usd?id=dash' style='border:none; height:125px; width: 275px;' scrolling='no' frameborder='0' allowTransparency='true'></iframe>
    </div>

Similar widgets with different designs are available from `CoinLib
<https://coinlib.io/widgets>`_ and `WorldCoinIndex
<https://www.worldcoinindex.com/Widget>`_, while an API providing similar
information is available from `DashCentral
<https://www.dashcentral.org/about/api>`_.


QR Codes
========

Many wallets can generate QR codes that are scannable to
simplify entry of the Dash address. Printing these codes or posting the
on your website makes it easy to receive payment and tips in Dash, both
online and offline.

- In Dash Core, go to the **Receive** tab, generate an address if
  necessary, and double-click it to display a QR code. Right-click on
  the QR code and select **Save Image** to save a PNG file.
- In Dash for Android, tap **Request Coins** and then tap the QR code to
  display a larger image. You can screenshot this to save an image.
- In Dash for iOS, swipe to the left to display the **Receive Dash**
  screen. A QR code and address will appear. You can screenshot this to
  save an image.
- To generate a QR code from any Dash address, visit `QRCode Monkey
  <https://www.qrcode-monkey.com/#bitcoin>`_, paste your Dash address,
  and select the Dash cryptocurrency type to generate an image.
