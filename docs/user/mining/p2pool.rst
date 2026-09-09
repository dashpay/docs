.. meta::
   :description: Information on Dash P2Pool, its maintenance status and community forks
   :keywords: dash, mining, X11, p2pool, node, pool, software, ASIC, mining pool

.. _p2pool:

=================
P2Pool Node Setup
=================

.. warning::
   The `dashpay/p2pool-dash
   <https://github.com/dashpay/p2pool-dash>`_ repository is no longer
   maintained. Its last update was in May 2023, during the Dash Core
   v18 release cycle, and its installation procedure depends on Python
   2, which is not available on current Ubuntu and Debian releases.

   The step-by-step setup instructions that previously appeared on this
   page have been removed because they can no longer be completed
   successfully. See :ref:`p2pool-forks` below for projects that
   continue development.

This page describes what P2Pool is and what to consider before running
a node. Unlike centralized mining pools, P2Pool is based on the same
peer-2-peer (P2P) model as Dash, making the pool as a whole highly
resistant to malicious attacks, and preserving and protecting the
decentralized nature of Dash. When you launch a P2Pool node, it seeks
out, connects with, and shares data with a decentralized network of
other P2Pool nodes (also known as peers). P2Pool nodes share a
cryptographic chain of data representing value, similar to Dash's
blockchain. The P2Pool version is called the sharechain. The
decentralized and fair nature of this mining model means mining with
P2Pool is strongly encouraged. P2Pool for Dash uses the p2pool-dash
software, which is a fork of p2pool for Bitcoin. For more information,
see `here <https://en.bitcoin.it/wiki/P2Pool>`__.

Because of the way P2Pool manages difficulty adjustments on the
sharechain, it is important to maintain low latency between the miners
and the P2Pool node to avoid miners submitting shares too late to enter
the sharechain. When setting up your node, you need to consider its
physical and network location relative to the miners you intend to
connect to the node. If you operate a mining farm, your P2Pool node
should probably be a physical machine on the same local network as your
miners. If you plan to operate a public node, it may be best to set up
your P2Pool node as a virtual machine in a data center with a high speed
connection so geographically close miners can mine to your pool with
relatively low latency.

.. _p2pool-forks:

Community forks
===============

Development of p2pool-dash continues in forks maintained by individual
community members. One example is `frstrtr/p2pool-dash
<https://github.com/frstrtr/p2pool-dash>`_, which supports current Dash
Core releases and provides its own installation guide. A separate
from-scratch C++ reimplementation, `c2pool
<https://github.com/frstrtr/c2pool>`_, is also under development.

These forks are not maintained, reviewed or endorsed by the Dash
project, and this documentation does not describe how to install or
operate them. Refer to each project's own documentation for setup
instructions.

Note that P2Pool software takes a payout address and requires RPC
credentials for a synchronized Dash Core node on the same host.
Evaluate any fork carefully before running it, as you would with any
other third-party software that handles mining rewards.
