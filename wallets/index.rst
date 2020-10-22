.. meta::
   :description: Description of different wallets available to use and spend Dash cryptocurrency
   :keywords: dash, wallet, core, electrum, android, ios, paper, hardware, trezor, ledger, web, recovery, text, sms

.. _wallets:

=======
Wallets
=======

Whenever you are storing objects with a market value, security is
necessary. This applies to barter systems as well as economies using
currency as a medium of exchange. While banks store balances on a
private ledger, cryptocurrencies store balances under unique addresses
on a distributed public ledger. The cryptographic private keys to access
the balance stored on each public address are therefore the object of
value in this system. This section of the documentation discusses
different practical methods of keeping these keys safe in wallets, while
still remaining useful for day-to-day needs.

For safety, it is not recommended to store significant funds on
exchanges or software wallets. If you are holding cryptocurrency worth
more than the device you use to store it, you should purchase a
:ref:`hardware wallet <hardware-wallets>`.


.. _dash-core-wallet:

Dash Core Wallet
================

Dash Core Wallet is the full official release of Dash, and supports all
Dash features as they are released, including InstantSend and
PrivateSend, as well as an RPC console and governance features. Dash
Core Wallet (sometimes known as the QT wallet, due to the QT software
framework used in development) is a professional or heavy wallet which
downloads the full blockchain (several GB in size) and can operate as
both a full node or masternode on the network. Because of the
requirement to hold a full copy of the blockchain, some time is required
for synchronisation when starting the wallet. Once this is done, the
correct balances will be displayed and the functions in the wallet can
be used. Dash Core Wallet is available for macOS, Linux, Raspberry Pi
and Windows.

Features:

-  PrivateSend
-  InstantSend
-  Wallet encryption
-  Coin control and fee control
-  QR code generation and address book
-  Masternode commands and voting
-  Automated backup
-  Debug console

Available documentation:

.. toctree::
   :maxdepth: 1

   dashcore/installation.rst
   dashcore/interface.rst
   dashcore/send-receive.rst
   dashcore/privatesend-instantsend.rst
   dashcore/backup.rst
   dashcore/cmd-rpc.rst
   dashcore/advanced.rst

.. figure:: dashcore/img/windows/106329009.png
   :width: 400 px

   Dash Core Wallet

.. _dash-electrum-wallet:

Dash Electrum Wallet
====================

Dash Electrum is a light wallet which uses powerful external servers to
index the blockchain, while still securing the keys on your personal
computer. Transactions are verified on the Dash blockchain using a
technique called Secure Payment Verification (SPV), which only requires
the block headers and not the full block. This means that wallet startup
is almost instant, while still keeping your funds secure and mobile.
Dash Electrum also supports advanced InstantSend, PrivateSend and
masternode features.

Dash Electrum is a fork of the Electrum wallet for Bitcoin. While this
documentation focuses on using Dash Electrum, full documentation of all
Bitcoin Electrum features (mostly identical in Dash Electrum) is
available at the `official documentation site
<https://docs.electrum.org>`_.

.. toctree::
   :includehidden:
   :maxdepth: 1

   electrum/installation.rst
   electrum/send-receive.rst
   electrum/security.rst
   electrum/faq.rst
   electrum/advanced.rst

.. figure:: electrum/img/electrum.png
   :width: 400 px

   Dash Electrum Wallet

.. _dash-android-wallet:

Dash Android Wallet
===================

Dash offers a standalone wallet for Android, with development supported 
by the Dash budget. The Dash Android Wallet supports advanced Dash 
features, including contact management and InstantSend. You can scan and 
display QR codes for quick transfers, backup and restore your wallet, 
keep an address book of frequently used addresses, pay with NFC, sweep 
paper wallets and more.

.. toctree::
   :includehidden:
   :maxdepth: 1

   android/installation.rst
   android/getting-started.rst
   android/advanced-functions.rst

.. image:: android/img/android1.png
    :width: 160 px
.. image:: android/img/android2.png
    :width: 160 px

*Dash Android Wallet*


.. _dash-ios-wallet:

Dash iOS Wallet
===============

Dash offers a standalone wallet for iOS, with development supported by
the Dash budget. The official Dash Wallet supports advanced Dash
features such as InstantSend sending and receiving. You can also scan
and display QR codes for quick transfers and backup your wallet using a
secure recovery phrase.

.. toctree::
   :includehidden:
   :maxdepth: 1

   ios/installation.rst
   ios/getting-started.rst
   ios/advanced-functions.rst

.. image:: ios/img/ios1.png
    :width: 160 px
.. image:: ios/img/ios2.png
    :width: 160 px

*Dash iOS Wallet*


.. _paper-wallets:

Dash Paper Wallet
=================

The `Dash Paper Wallet generator <https://paper.dash.org>`_ allows you
to generate, encrypt and secure the keys to a single Dash address on a
clean computer without ever connecting to the internet. Perfect for long
term secure storage.

.. toctree::
   :maxdepth: 1

   paper.rst

.. figure:: img/paper-addresses.png
   :width: 400 px

   Dash Paper Wallet


.. _hardware-wallets:

Hardware Wallets
================

A hardware wallet is a type of device which stores private keys for a
blockchain in a secure hardware device, instead of in a database file
such as wallet.dat used with common software wallets. This offers major
security advantages over software wallets, as well as practical benefits
over paper wallets. To date, there is no verifiable evidence of hardware
wallets being compromised by viruses, and they are also immune to
keylogger attacks that could be used to steal passwords to unlock the
private keys used with software wallets.

Hardware wallets function by storing your private keys in a protected
area of a microcontroller. It is impossible for the private key to leave
the device in plain text - only the signed output of the cryptographic
hash is ever transmitted to the device interacting with the blockchain,
such as your computer or smartphone. Most hardware wallets feature a
screen which allows you to independently confirm the address you are
sending to is correct.

This section lists the most common commercial hardware wallets supporting
Dash, although some other enthusiast projects may also be available.

.. toctree::
   :maxdepth: 1

   hardware.rst

.. figure:: img/trezor-balance.png
   :width: 400 px

   Trezor Web Wallet

.. _third-party-wallets:

Third Party Wallets
===================

These wallets have been developed by external developers to support
Dash. Many third party wallets support multiple different
cryptocurrencies at the same time, or integrate instant cryptocurrency
exchanges.

.. toctree::
   :maxdepth: 1

   third-party.rst

.. figure:: img/edge-wallet.png
   :width: 400 px

   Edge Wallet


.. _web-wallets:

Web Wallets
===========

Web wallets are services which keep a Dash balance for you, while
maintaining control of the private keys on your behalf. Any Dash stored
on :ref:`exchanges <exchanges>` falls under this category, but there are
also some services able to store Dash for you through simple
Google/Facebook login systems. Be extremely careful with web storage, as
your Dash is only as secure as the reputation of the company storing it
for you. A particular exception is MyDashWallet.org, which provides a
secure web interface to the Dash blockchain while leaving you with full
control of your private keys.

.. toctree::
   :maxdepth: 1

   web.rst

.. figure:: img/mydashwallet-opened.png
   :width: 400 px

   My Dash Wallet


Text Wallets
============

Text wallets (or SMS wallets) allow users without smartphones or
internet access to transact in Dash using text messages on simple
feature phones. Innovative shortcodes, usually in collaboration with
national mobile service providers, make it relatively simple to create
transactions to both send and receive Dash.

.. toctree::
   :maxdepth: 1

   text.rst


Wallet Guides
=============

Documentation in this section describes common tasks and questions
relating to all wallets.

.. toctree::
   :maxdepth: 1

   recovery.rst
   signing.rst
