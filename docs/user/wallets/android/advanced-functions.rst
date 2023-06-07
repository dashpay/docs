.. meta::
   :description: Set up address book, exchange rates, sweep paper wallets and change settings in the Dash Android wallet.
   :keywords: dash, mobile, wallet, android, address book, paper, exchange rates

.. _dash-android-advanced-functions:

Advanced functions
==================

Address book
------------

Your Android wallet allows you to manage frequently used addresses by
adding a label to help you identify the owner. You can also label your
own addresses in the wallet in order to keep track of regular incoming
payments. You can access the address book by tapping the **Menu
button**, then **Address book**. This will display a screen where you
can swipe left and right between your own addresses and the addresses to
which you frequently send Dash, such as family members for example. Tap
the **More options** button to **Paste from clipboard** or to **Scan
address** from a QR code, or tap an existing address to **Send Dash** or
**Edit** the label.


.. image:: img/menu-address.png
   :width: 160 px
.. image:: img/address-menu.png
   :width: 160 px
.. image:: img/address-add.png
   :width: 160 px
.. image:: img/address-tap-menu.png
   :width: 160 px

*Accessing the address book and adding an address*

You can also add labels directly from the main transaction history
screen by tapping the **More options** button for the transaction (three
vertical dots) and selecting either **Add label to your address**,
**Edit label of your address**, **Add sending address** or **Edit label
of sending address**.

.. image:: img/address-tx-add-own.png
   :width: 160 px
.. image:: img/address-tx-add-sending.png
   :width: 160 px
.. image:: img/address-tx-edit.png
   :width: 160 px

*Adding and editing address labels in transaction view*


Exchange rates
--------------

Dash Wallet for Android allows you to display the equivalent value of
your Dash balance and in transactions by selecting a default fiat
currency. To select a default currency, tap the **Menu button**, then
**Exchange rates**. Find your preferred fiat currency, then tap the
**More options** button for that currency and select **Set as default**.
The exchange rate for this currency will appear when sending Dash, and
you can also tap in the fiat currency field to enter the value in the
fiat currency directly, instead of in Dash.

.. image:: img/menu-exchange.png
   :width: 160 px
.. image:: img/exchange-rates.png
   :width: 160 px
.. image:: img/exchange-default.png
   :width: 160 px
.. image:: img/exchange-fiat-entry.png
   :width: 160 px

*Selecting a fiat exchange rate and creating a transaction denominated
in USD*

Masternode keys
---------------

Certain masternode keys may be generated and stored in Dash Wallet. To access
these keys, tap the **Menu button** and select **Tools**. Tap **Masternode
Keys** and enter your PIN to open the Masternode Keys screen. From here, tap on
any of the listed key types to view existing keys or generate new ones. The
screen will show all used keys and the first unused one. To generate additional
keys, tap the **+** button.

.. image:: img/menu.jpg
   :width: 160 px
.. image:: img/menu-tools.jpg
   :width: 160 px
.. image:: img/tools-mn-keys.jpg
   :width: 160 px
.. image:: img/tools-mn-keys-owner-key.jpg
   :width: 160 px

*Viewing and generating masternode keys*

Sweep paper wallet
------------------

Sweeping a paper wallet is a method of transferring the value stored on
an address you may have received as a paper wallet or from an ATM into
your own wallet. You must have access to the private key for an address
to use this function. In this process, all Dash stored on the address
will be sent to a new address that has been deterministically generated
from your wallet seed. The private keys you sweep do not become a part
of your wallet.

To sweep a paper wallet, tap the **Menu button** and select **Sweep
paper wallet**. Tap the **Scan** button and scan the QR code from your
paper wallet. Once the private key has been identified, tap **Sweep** to
create the transaction moving the Dash into your own wallet. Once this
transaction is confirmed, the paper is worthless and should be
destroyed.

.. image:: img/menu-sweep.png
   :width: 160 px
.. image:: img/sweep-start.png
   :width: 160 px
.. image:: img/sweep-scan.png
   :width: 160 px
.. image:: img/sweep-done.png
   :width: 160 px

*Sweeping a paper wallet with 0.10 DASH into the Android Wallet*


Network monitor
---------------

The Dash Android Wallet is a light wallet and functions in SPV mode,
meaning it does not download a full copy of the blockchain. The network
monitor allows you to view details about the full nodes to which you are
connected. You can also swipe left to view blocks as they are created on
the blockchain.

.. image:: img/menu-network.png
   :width: 160 px
.. image:: img/network-peers.png
   :width: 160 px
.. image:: img/network-blocks.png
   :width: 160 px

*Viewing peers and blocks to monitor network activity*


Settings
--------

.. image:: img/menu-settings.png
   :width: 160 px
.. image:: img/settings.png
   :width: 160 px

*The Settings menu in Dash Android Wallet*

The settings menu contains a range of options to control the behavior of
the Dash Android Wallet. To access the settings, tap the **Menu
button**, then **Settings**. You can then choose between **Settings**,
**Diagnostics** and **About**, which displays wallet version, copyright,
license and source code information.

Settings
^^^^^^^^

Denomination and precision
  Select the number of decimal places to show for DASH denominations, or
  switch to mDASH or µDASH denominations

Own name
  Enter a short name to be included in your QR codes when displaying to
  other users for scanning. The short name will then appear as a label
  in their wallet to verify the recipient and simplify address
  management.

Auto-close send coins dialog
  Specify whether or not to close the send dialog once a payment is 
  complete.

Connectivity indicator
  Enables display of an indicator in the Android notification area to be
  able to quickly verify connectivity.

Trusted peer
  Enter the IP address or hostname of a single peer to connect to.

Skip regular peer discovery
  Enabling this option prevents automatic peer discovery and forces 
  connection to the one specified trusted peer only.

Block explorer
  Allows you to select which block explorer you want to use for
  functions linking to a block explorer.

Data usage
  Links to the Android **Data usage** function to view and/or restrict
  data usage for the app.

Balance reminder
  Enables an Android system notification to remind you of any unspent
  Dash if you don't open the app in that time.

Enable InstantSend
  Enables functionality to use InstantSend to send and receive Dash.

Enable Lite Mode
  Enabling lite mode reduces bandwidth usage.

Show disclaimer
  Enables or disables various disclaimers and warning messages in the
  app.

BIP70 for scan-to-pay
  Enables use of the `BIP70 payment protocol
  <https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki>`_ to
  add further verification and security features when scanning QR codes.

Look up wallet names
  Enables use of `DNSSEC <https://en.wikipedia.org/wiki/Domain_Name_Syst
  em_Security_Extensions>`_ to attempt to identify a wallet name when
  creating transactions.

Diagnostics
^^^^^^^^^^^

Report issue
  Allows you to gather a range of information related to your wallet in
  order to send a bug report to developers for troubleshooting.

Show xpub
  Displays the extended public key for the seed used to generate
  addresses in your wallet. Providing your xpub to a third party will
  allow them to view your entire transaction history, but not make new
  transactions.

Reset block chain
  Resets data stored on your device relating to the blockchain. This
  data will need to be collected again from full nodes, similar to when
  setting up a new wallet. This process may take some time.
