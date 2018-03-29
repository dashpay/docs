.. _masternode-hosting:

================
Hosting Services
================

Several Dash community members offer masternode hosting services. This
service can be realized securely without the customer ever giving up
control of the 1000 DASH required for collateral. For security reasons,
it is highly recommended to keep the collateral on a hardware wallet
when taking advantage of a hosting service. A list of currently
available masternode hosting services is available below.

List of hosting services
========================

**Disclaimer**: Dash Core may be affiliated with these community
members, but is not involved in the provision of any of these services.

Masternode.me
-------------

.. image:: img/moocowmoo.png
   :width: 200px
   :align: right
   :target: https://masternode.me

https://masternode.me

- Operated by: moocowmoo (Dash Core team member)
- Services: Hosting
- `Site <https://masternode.me>`__
- `Email <moocowmoo@masternode.me>`__
- `Forum <https://www.dash.org/forum/threads/moocowmoos-magic-masternode-maker.3305/>`__
- `Review <https://www.dashforcenews.com/masternode-trusted-masternode-shares-review/>`__

Splawik's Hosting Service
-------------------------

.. image:: img/splawik.png
   :width: 200px
   :align: right
   :target: http://dashmasternode.io

http://dashmasternode.io

- Operated by: splawik21 (Dash Foundation member)
- Services: Hosting
- `Site <http://dashmasternode.io>`__
- `Email <splawik21@protonmail.com>`__
- `Forum <https://www.dash.org/forum/threads/splawik-s-supershares-hosting-service.3195/>`__
- `Review <https://www.dashforcenews.com/meet-the-inventor-of-trusted-masternode-shares/>`__

Node40
------

.. image:: img/node40.png
   :width: 200px
   :align: right
   :target: https://node40.com

https://node40.com

- Operated by: Perry Woodin
- Services: Hosting, Voting, Tax Compliance
- `Site <https://node40.com>`__
- `Email <info@node40.com>`__
- `Forum <https://www.dash.org/forum/threads/node40-masternode-management-services.4447/>`__
- `Review <https://www.dashforcenews.com/interview-perry-woodin-node40-dash-compliance/>`__

Masternodehosting
-----------------

https://masternodehosting.com/

- Operated by: flare (Dash Core team member)
- Services: Hosting
- `Site <https://masternodehosting.com>`__
- `Email <holger@masternodehosting.com>`__
- `Forum <https://www.dash.org/forum/threads/service-masternode-hosting-service.2648/>`__

Starting a hosted masternode
============================

Starting a hosted masternode is done in just a few easy steps:

#. Send 1000 DASH to an address you control in a single transaction and
   wait for 15 confirmations
#. Communicate the address to your hosting provider, who will provide
   you with a masternode IP address and private key
#. Enter this information in your wallet and start the masternode

It is **highly recommended** to store the keys to your masternode
collateral on a :ref:`hardware wallet <dash-hardware-wallet>` for added
security against hackers. This documentation will use a Trezor as an
example, but KeepKey and Ledger are also supported. For instructions on
using Dash Core wallet to start the masternode (no longer recommended),
contact your hosting provider.

Send the collateral
-------------------

Set up your Trezor using the Trezor wallet at https://wallet.trezor.io,
update the firmware if necessary and send a test transaction to verify
that it is working properly. For help on this, see :ref:`this guide
<hardware-trezor>`. Create a new account in your Trezor wallet by
clicking **Add account**. Then click the **Receive** tab and send
exactly 1000 DASH to the address displayed. You should see the
transaction as soon as the first confirmation arrives, usually within a
few minutes.

.. figure:: img/setup-collateral-trezor.png
   :width: 400px

   Trezor Wallet Receive tab showing successfully received collateral of
   1000 DASH

Once the transaction appears, click the QR code on the right to view the
transaction on the blockchain. Keep this window open as we complete the
following steps, since we will soon need to confirm that 15
confirmations exist, as shown in the following screenshot.

.. figure:: img/setup-collateral-blocks.png
   :width: 400px

   Trezor blockchain explorer showing 15 confirmations for collateral
   transfer

Correspond with your hosting provider
-------------------------------------

Once 15 confirmations exist, send the address holding the 1000 DASH to
your hosting provider. Payment for operating the masternode will
generally also be requested at this point - if paying in Dash, be
careful not to pay from the address holding the collateral. You will
receive a reply with the following data:

- A server IP address
- A masternode private key
- The collateral transaction ID (optional)

Start the masternode
--------------------

The Dash Masternode Tool (DMT) is required to combine all of this data
and issue the command to the network to start the masternode. Download
the appropriate version of DMT for your computer from the Github
releases page `here <https://github.com/Bertrand256/dash-masternode-
tool/releases>`_. Unzip the file and run the executable. The following
window appears.

.. figure:: img/setup-collateral-dmt-start.png
   :width: 400px

   Dash Masternode Tool startup screen

We will now do the final preparation in Dash DMT. Carry out the
following sequence of steps as shown in this screenshot from DMT
developer Bertrand256:

.. figure:: img/setup-collateral-dmt-steps.png
   :width: 400px

   Dash Masternode Tool configuration steps

#. Enter the name of your masternode here.
#. Enter the IP address of your masternode, as provided by your host.
#. Enter the TCP port number. This should be 9999.
#. Instead of clicking **Generate new**, simply enter the masternode 
   private key provided by your host.
#. Copy the collateral address where you sent the 1000 DASH collateral
   from your Trezor Wallet and paste it in this field.
#. Click the **arrow** → to derive the BIP32 path from your collateral
   address. You can verify this against the BIP32 path shown on the
   receive tab in your Trezor Wallet for the transaction.
#. Click **Lookup** to find the collateral TX ID for the transaction 
   which transferred the collateral to the address. You can verify this
   against the TXID shown on the confirmation page of the blockchain
   explorer for your collateral address.

.. figure:: img/setup-collateral-dmt-ready.png
   :width: 400px

   Dash Masternode Tool with configuration ready to start masternode

Click **Start Masternode using Hardware Wallet**. Enter your PIN and
confirm on your hardware wallet that you want to transmit this command.
The following messages will appear, confirm each one:

.. image:: img/setup-dmt-send.png
   :width: 220px

.. figure:: img/setup-dmt-sent.png
   :width: 220px

   Dash Masternode Tool confirmation dialogs to start a masternode

That's it! Your masternode is now running, and you should receive
regular payments to your masternode address. You can monitor your
masternode's acceptance by the network by entering the collateral
address to search the masternode list at https://www.dashninja.pl. For
information on how to withdraw masternode payments without affecting
operation of the masternode, see :ref:`here <masternode-withdrawals>`.
