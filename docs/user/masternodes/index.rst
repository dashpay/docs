.. meta::
   :description: Introduction to documentation on how to set up and operate a masternode for the Dash cryptocurrency.
   :keywords: dash, masternodes, hosting, linux, payment, setup

.. _masternodes:

===========
Masternodes
===========

Dash is best known as the first cryptocurrency with a focus on
user-friendly payments and transaction speed. What many people do not
know is that these features are implemented on top of a network of
dedicated servers known as masternodes, which gives rise to many
exciting features not available on conventional blockchains. These
features include instant and private transactions, as well as
governance of the development of the Dash network through a monthly
budget and voting. This in itself is a first in the crypto world, and
the masternodes are necessary to achieve the privacy and speed that Dash
offers.

This documentation focuses on understanding the services masternodes
provide to the network, but also includes guides on how to run a
masternode, using either a hosting provider or by setting up and
maintaining your own hosting solution. The primary requirement to run a
masternode on the Dash network is 1000 DASH. This is known as the
collateral, and cannot be spent without interrupting operation of the
masternode. The second requirement is the actual server running the Dash
masternode software.

**Option 1: Hosted masternode**

Since operating your own server requires a certain level knowledge of
blockchains and Linux server operating systems, several community
members offer dedicated hosting solutions for a fee. Taking advantage of
these services means the user only needs to provide the masternode
collateral and pay the hosting fee in order to receive payment from the
block reward. See :ref:`these pages <masternode-hosting>` for
information on how to set up a hosted masternode.

**Option 2: Self-operated masternode**

Users with a deeper understanding (or curiosity) about the inner
workings of the Dash network may choose to operate their own masternode
on their own host server. Several steps are required, and the user must
assume responsibility for setting up, securing and maintaining both the
server and collateral. See these pages for information on how to set up
a self-operated masternode.

.. toctree::
   :maxdepth: 1

   understanding.rst
   hosting.rst
   server-config
   setup.rst
   setup-evonode
   setup-testnet.rst
   maintenance.rst
