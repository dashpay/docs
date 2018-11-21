.. meta::
   :description: Masternode hosting services can help you set up and maintain a Dash masternode
   :keywords: dash, cryptocurrency, hosting, server, linux, masternode, contact, trezor, setup, operator, owner, dip3, reward

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

CrowdNode
---------

.. image:: img/crowdnode.png
   :width: 200px
   :align: right
   :target: https://crowdnode.io

https://crowdnode.io

- Operated by: CrowdNode ApS
- Services: Hosting, Shares
- `Site <https://crowdnode.io>`__
- `Email <hello@crowdnode.io>`__

Splawik's Hosting Service
-------------------------

.. image:: img/splawik.png
   :width: 200px
   :align: right
   :target: http://dashmasternode.io

http://dashmasternode.io

- Operated by: splawik21 (Dash Core team member)
- Services: Hosting
- `Site <http://dashmasternode.io>`__
- `Email <splawik21@protonmail.com>`__
- `Forum <https://www.dash.org/forum/threads/splawik-s-supershares-hosting-service.3195/>`__

AllNodes
--------

.. image:: img/allnodes.png
   :width: 200px
   :align: right
   :target: https://www.allnodes.com

https://www.allnodes.com

- Operated by: Sephiroth
- Services: Hosting
- `Site <https://www.allnodes.com>`__
- `Email <info@allnodes.com>`__
- `Twitter <https://twitter.com/allnodes>`__
- `Telegram <https://t.me/allnodes>`__
- `Discord <https://discord.allnodes.com>`__

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

币舫 (Bifun)
-----------------

.. image:: img/bifun.png
   :width: 200px
   :align: right
   :target: https://bifun.com

https://bifun.com

- Operated by: BiFun (Hainan) Network Technology Co, Ltd.
- Services: Hosting, Shares
- `Site <https://bifun.com>`__
- `Email <business@bifun.com>`__

Masternodehosting
-----------------

https://masternodehosting.com

- Operated by: flare (Dash Core team member)
- Services: Hosting
- `Site <https://masternodehosting.com>`__
- `Email <holger@masternodehosting.com>`__
- `Forum <https://www.dash.org/forum/threads/service-masternode-hosting-service.2648/>`__

.. _hosted-setup:

Registering a hosted masternode
===============================

Dash 0.13.0 implements DIP3, which introduces several changes to how a
Dash masternode is set up and operated. A list of available
documentation appears below:

- `DIP3 Deterministic Masternode Lists <https://github.com/dashpay/dips/blob/master/dip-0003.md>`__
- :ref:`dip3-changes`
- :ref:`dip3-upgrade`
- :ref:`Full masternode setup guide <masternode-setup>`
- :ref:`Information for users of hosted masternodes <hosted-setup>` (you are here)
- :ref:`Information for operators of hosted masternodes <operator-transactions>`

It is highly recommended to first read at least the list of changes
before continuing in order to familiarize yourself with the new concepts
in DIP3.

Registering a hosted masternode is done in several steps:

#. Send 1000 DASH to an address you control in a single transaction and
   wait for 15 confirmations
#. Request a BLS public key from your hosting provider and wait for them
   to set up your masternode
#. Enter this information in your wallet and broadcast the registration
   transaction

It is **highly recommended** to store the keys to your masternode
collateral on a :ref:`hardware wallet <dash-hardware-wallet>` for added
security against hackers. Since the hardware wallet is only used to sign
a transaction, there is no need to ever connect this wallet to the
internet. However, a Dash Core wallet with balance (for the transaction
fee) is required to submit the registration transaction. This
documentation will use a Trezor as an example, but KeepKey and Ledger
are also supported.

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

Once 15 confirmations exist, ask your hosting provider to provide you
with the BLS public key from the masternode they will operate on your
behalf. They may also optionally provide you with the IP address and
port of the server.

Register the masternode
-----------------------

The Dash Masternode Tool (DMT) can be used to combine all of this data
and issue the ProRegTx command to the network to register the
masternode. Download the appropriate version of DMT for your computer
from the GitHub releases page `here <https://github.com/Bertrand256
/dash-masternode- tool/releases>`_. Further documentation will be
available once the tool is updated.

It is also possible to create the registration transaction yourself
using Dash Core wallet. The documentation below describes this process.

Prepare a ProRegTx transaction
------------------------------

First, we need to get a new, unused address from the wallet to serve as
the owner address. This is different to the collateral address. It must
also be used as the voting address if Spork 15 is not yet active.
Generate a new address as follows::

  getnewaddress

  yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz

Then either generate or choose an existing second address to receive the
owner's masternode payouts::

  getnewaddress

  ycBFJGv7V95aSs6XvMewFyp1AMngeRHBwy

Next, we will prepare an unsigned ProRegTx special transaction using the
``protx register_prepare`` command. This command has the following
syntax::

  protx register_prepare collateralHash collateralIndex ipAndPort ownerKeyAddr 
    operatorKeyAddr votingKeyAddr operatorReward payoutAddress

Open a text editor such as notepad to prepare this command. Replace each
argument to the command as follows:

- ``collateralHash``: The txid of the 1000 Dash collateral funding 
  transaction
- ``collateralIndex``: The output index of the 1000 Dash funding 
  transaction
- ``ipAndPort``: Masternode IP address and port, in the format ``x.x.x.x:yyyy``
- ``ownerKeyAddr``: The new Dash address generated above for the 
  owner/voting address
- ``operatorKeyAddr``: The BLS public key provided by your hosting 
  service
- ``votingKeyAddr``: The new Dash address generated above, or the 
  address of a delegate, used for proposal voting
- ``operatorReward``: The percentage of the block reward allocated to 
  the operator as payment
- ``payoutAddress``: A new or existing Dash address to receive the 
  owner's masternode rewards

Note that the operator is responsible for specifying their own reward
address in a separate ``update_service`` transaction if you specify a
non-zero ``operatorReward``. The owner of the masternode collateral does
not specify the operator's payout address.

Example (remove line breaks if copying)::

  protx register_prepare
    2c499e3862e5aa5f220278f42f9dfac32566d50f1e70ae0585dd13290227fdc7
    1
    140.82.59.51:19999
    yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz
    01d2c43f022eeceaaf09532d84350feb49d7e72c183e56737c816076d0e803d4f86036bd4151160f5732ab4a461bd127
    yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz
    0
    ycBFJGv7V95aSs6XvMewFyp1AMngeRHBwy

Output::

  {
    "tx": "030001000191def1f8bb265861f92e9984ac25c5142ebeda44901334e304c447dad5adf6070000000000feffffff0121dff505000000001976a9149e2deda2452b57e999685cb7dabdd6f4c3937f0788ac00000000d1010000000000c7fd27022913dd8505ae701e0fd56625c3fa9d2ff47802225faae562389e492c0100000000000000000000000000ffff8c523b334e1fad8e6259e14db7d05431ef4333d94b70df1391c601d2c43f022eeceaaf09532d84350feb49d7e72c183e56737c816076d0e803d4f86036bd4151160f5732ab4a461bd127ad8e6259e14db7d05431ef4333d94b70df1391c600001976a914adf50b01774202a184a2c7150593442b89c212e788acf8d42b331ae7a29076b464e61fdbcfc0b13f611d3d7f88bbe066e6ebabdfab7700",
    "collateralAddress": "yPd75LrstM268Sr4hD7RfQe5SHtn9UMSEG",
    "signMessage": "ycBFJGv7V95aSs6XvMewFyp1AMngeRHBwy|0|yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz|yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz|54e34b8b996839c32f91e28a9e5806ec5ba5a1dadcffe47719f5b808219acf84"
  }

We will use the ``collateralAddress`` and ``signMessage`` fields in Step
4, and the output of the ``tx`` field in Step 5.

Sign the ProRegTx transaction
-----------------------------

Now we will sign the content of the ``signMessage`` field using the
private key for the collateral address as specified in
``collateralAddress``. Note that no internet connection is required for
this step, meaning that the wallet can remain disconnected from the
internet in cold storage to sign the message. In this example we will
again use Dash Core, but it is equally possible to use the signing
function of a hardware wallet. The command takes the following syntax::

  signmessage address message

Example::

  signmessage yPd75LrstM268Sr4hD7RfQe5SHtn9UMSEG ycBFJGv7V95aSs6XvMewFyp1AMngeRHBwy|0|yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz|yc98KR6YQRo1qZVBhp2ZwuiNM7hcrMfGfz|54e34b8b996839c32f91e28a9e5806ec5ba5a1dadcffe47719f5b808219acf84

Output::

  IMf5P6WT60E+QcA5+ixors38umHuhTxx6TNHMsf9gLTIPcpilXkm1jDglMpK+JND0W3k/Z+NzEWUxvRy71NEDns=


Submit the signed message
-------------------------

We will now create the ProRegTx special transaction on the network to
start the masternode. This command must be sent from a Dash Core wallet
holding a balance, since a standard transaction fee is involved. The
command takes the following syntax::

  protx register_submit tx sig

Where: 

- ``tx``: The serialized transaction previously returned in the ``tx`` 
  output field from ``protx register_prepare`` in Step 2
- ``sig``: The message signed with the collateral key from Step 3

Example::

  protx register_submit 030001000191def1f8bb265861f92e9984ac25c5142ebeda44901334e304c447dad5adf6070000000000feffffff0121dff505000000001976a9149e2deda2452b57e999685cb7dabdd6f4c3937f0788ac00000000d1010000000000c7fd27022913dd8505ae701e0fd56625c3fa9d2ff47802225faae562389e492c0100000000000000000000000000ffff8c523b334e1fad8e6259e14db7d05431ef4333d94b70df1391c601d2c43f022eeceaaf09532d84350feb49d7e72c183e56737c816076d0e803d4f86036bd4151160f5732ab4a461bd127ad8e6259e14db7d05431ef4333d94b70df1391c600001976a914adf50b01774202a184a2c7150593442b89c212e788acf8d42b331ae7a29076b464e61fdbcfc0b13f611d3d7f88bbe066e6ebabdfab7700 IMf5P6WT60E+QcA5+ixors38umHuhTxx6TNHMsf9gLTIPcpilXkm1jDglMpK+JND0W3k/Z+NzEWUxvRy71NEDns=

Output::

  9f5ec7540baeefc4b7581d88d236792851f26b4b754684a31ee35d09bdfb7fb6

Your masternode is now upgraded to DIP3 and will appear on the
Deterministic Masternode List. You can view this list on the
**Masternodes -> DIP3 Masternodes** tab of the Dash Core wallet, or in
the console using the command ``protx list valid``, where the txid of
the final ``protx register_submit`` transaction identifies your DIP3
masternode. Note again that all functions related to DIP3 will only take
effect once Spork 15 is enabled on the network. You can view the spork
status using the ``spork active`` command.

.. _operator-transactions:

Operator transactions
=====================

This documentation is intended for operators managing nodes on behalf of
owners. If you provide an IP address and port of a synchronized full
node with your ``masternodeblsprivkey`` entered in the ``dash.conf``
file as descibed :ref:`here <bls-generation>` to the masternode owner,
it will appear in the DIP3 valid set immediately after they submit the
``protx register_submit`` command as described above. If the full node
is not running, or if the owner submits ``0`` for the ``ipAndPort``,
then the node will be registered in a PoSe-banned state. In this case,
the operator will need to issue a :ref:`ProUpServTx transaction <update-
dip3-config>` to update the service features and register the
masternode.

The ProRegTx submitted by the owner also specifies the percentage reward
for the operator. It does not specify the operator's reward address, so
a ProUpServTx is also required to claim this reward by specifying a Dash
address. If the reward is not claimed, it will be paid to the owner in
full.
