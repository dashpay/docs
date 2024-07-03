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


Allnodes
--------

.. image:: img/allnodes.png
   :width: 200px
   :align: right
   :target: https://www.allnodes.com/?utm_source=dashdocs&utm_medium=setup-guide

`https://www.allnodes.com <https://www.allnodes.com/?utm_source=dashdocs&utm_medium=setup-guide>`__

- Operated by: Sephiroth
- Services: Monitoring, Hosting
- Cost: from $4.50/month
- `Site <https://www.allnodes.com/?utm_source=dashdocs&utm_medium=setup-guide>`__
- `Email <info@allnodes.com>`__
- `Twitter <https://twitter.com/allnodes>`__
- `Telegram <https://t.me/allnodes>`__
- `Discord <https://discord.allnodes.com>`__


SID Hosting Service
-------------------

.. image:: img/splawik.png
   :width: 200px
   :align: right
   :target: https://dashmasternode.io

https://dashmasternode.io

- Operated by: splawik21 (Dash Core team member)
- Services: Hosting
- Cost: €25/month, paid in Dash
- `Site <https://dashmasternode.io>`__
- `Email <sidhosting@protonmail.com>`__


Pool of Stake
-------------

.. image:: img/pool-of-stake.svg
   :width: 200px
   :align: right
   :target: https://www.poolofstake.io

https://www.poolofstake.io

- Operated by: Pool of Stake OÜ
- Services: Hosting, Shares
- 15% of masternode payments (5% with tokens)
- `Site <https://www.poolofstake.io>`__
- `Email <mail@poolofstake.io>`__
- `Twitter <https://twitter.com/poolofstake>`__
- `Telegram <https://telegram.me/poolofstake>`__


Staked
------

.. image:: img/staked.png
   :width: 200px
   :align: right
   :target: https://staked.us

https://staked.us

- Operated by: Staked
- Services: Hosting, Reporting
- Cost: 10% of rewards
- `Site <https://staked.us>`__
- `Email <sales@staked.us>`__


NodeHub.io
----------

.. image:: img/nodehub.png
   :width: 200px
   :align: right
   :target: https://nodehub.io?utm_source=dashpay-docs&utm_medium=hosting-services

https://nodehub.io

- Operated by: NodeHub LLC
- Services: Hosting, Governance, Stats, Monitoring
- Cost: $3.90/month (charged daily at $0.13)
- `Site <https://nodehub.io?utm_source=dashpay-docs&utm_medium=hosting-services>`__
- `Email <hello@nodehub.io>`__
- `Twitter <https://twitter.com/nodehubio>`__
- `Telegram <https://t.me/nodehub>`__
- `Discord <https://discord.nodehub.io>`__


Gentarium
---------

.. image:: img/gentarium.svg
   :width: 200px
   :align: right
   :target: https://mn.gtmcoin.io

https://mn.gtmcoin.io

- Operated by: Gentarium International OÜ
- Services: Hosting, Shares
- Cost: $3.99/month (charged daily at $0.15)
- `Site <https://mn.gtmcoin.io>`__
- `Email <info@gtmcoin.io>`__
- `Twitter <https://twitter.com/GTM_Gentarium>`__
- `Discord <https://discord.com/invite/vErwUSC>`__


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

A list of available documentation appears below:

- :ref:`Full masternode setup guide <masternode-setup>`
- :ref:`Information for users of hosted masternodes <hosted-setup>` (you are here)
- :ref:`Information for operators of hosted masternodes <operator-transactions>`

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
it will appear in the valid masternode set immediately after they submit the
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
