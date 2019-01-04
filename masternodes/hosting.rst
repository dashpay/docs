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
- Cost: 15% of masternode payments
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
- Cost: 0.1 Dash/month
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
- Cost: $5/month (free during beta)
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
- 0.34 Dash/month (variable, discounts available)
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
- Cost: 10% of masternode payments
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
- Cost: €18/month
- `Site <https://masternodehosting.com>`__
- `Email <holger@masternodehosting.com>`__
- `Forum <https://www.dash.org/forum/threads/service-masternode-hosting-service.2648/>`__


.. _hosted-setup:

Registering a hosted masternode
===============================

Dash 0.13.0 implements DIP003, which introduces several changes to how a
Dash masternode is set up and operated. A list of available
documentation appears below:

- `DIP003 Deterministic Masternode Lists <https://github.com/dashpay/dips/blob/master/dip-0003.md>`__
- :ref:`dip3-changes`
- :ref:`dip3-upgrade`
- :ref:`Full masternode setup guide <masternode-setup>`
- :ref:`Information for users of hosted masternodes <hosted-setup>` (you are here)
- :ref:`Information for operators of hosted masternodes <operator-transactions>`

It is highly recommended to first read at least the list of changes
before continuing in order to familiarize yourself with the new concepts
in DIP003.

Registering a hosted masternode is done in several steps:

#. Send 1000 DASH to an address you control in a single transaction and
   wait for 15 confirmations
#. Correspond with your hosting provider to determine who will generate
   the operator BLS keys, whether their fee will be paid by an operator
   reward percentage or according to a separate contract, and whether
   the masternode will be set up before or after the registration
   transaction
#. Prepare, sign and broadcast the registration transaction using Dash 
   Core or DMT

It is **highly recommended** to store the keys to your masternode
collateral on a :ref:`hardware wallet <dash-hardware-wallet>` for added
security against hackers. Since the hardware wallet is only used to sign
a transaction, there is no need to ever connect this wallet to the
internet. However, a Dash Core wallet with balance (for the transaction
fee) is required to submit the registration transaction. The masternode
registration process closely follows the :ref:`setup guide 
<masternode-setup>`, beginning from the :ref:`registration step 
<register-masternode>`.


.. _operator-transactions:

Operator transactions
=====================

This documentation is intended for operators managing nodes on behalf of
owners. If you provide an IP address and port of a synchronized full
node with your ``masternodeblsprivkey`` entered in the ``dash.conf``
file as descibed :ref:`here <bls-generation>` to the masternode owner,
it will appear in the DIP003 valid set immediately after they submit the
``protx register_submit`` command as described above. If the full node
is not running, or if the owner submits ``0`` for the ``ipAndPort``,
then the node will be registered in a PoSe-banned state. In this case,
the operator will need to issue a :ref:`ProUpServTx transaction 
<update-dip3-config>` to update the service features and register the
masternode.

The ProRegTx submitted by the owner also specifies the percentage reward
for the operator. It does not specify the operator's reward address, so
a ProUpServTx is also required to claim this reward by specifying a Dash
address. If the reward is not claimed, it will be paid to the owner in
full.
