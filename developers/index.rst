

.. _developers:

==========
Developers
==========

This section includes documentation useful to developers and technical
writers interested in Dash.

.. toctree::
   :maxdepth: 1
   :hidden:

   translating.rst
   compiling.rst
   testnet.rst


Version History
===============

Full release notes and the version history of Dash are available here:

- https://github.com/dashpay/dash/blob/master/doc/release-notes.md


.. _understanding-sporks:

Sporks
======

A multi-phased fork, colloquially known as a "spork", is a mechanism
unique to Dash used to safely deploy new features to the network through
network-level variables to avoid the risk of unintended network forking
during upgrades. It can also be used to disable certain features if a
security vulnerability is discovered - see :ref:`here <sporks>` for a
brief introduction to sporks. This documentation describes the meaning
of each spork currently existing on the network, and how to check their
respective statuses.

Spork functions
---------------

Sporks are set using integer values. Many sporks may be set to a
particular epoch datetime (number of seconds that have elapsed since
January 1, 1970) to specify the time at which they will active. Enabled
sporks are set to 0 (seconds until activation). This function is often
used to set a spork enable date so far in the future that it is
effectively disabled until changed. The following sporks currently exist
on the network and serve functions as described below:

SPORK_2_INSTANTSEND_ENABLED
  Governs the ability of Dash clients to use InstandSend functionality.

SPORK_3_INSTANTSEND_BLOCK_FILTERING
  If enabled, masternodes will reject blocks containing transactions in
  conflict with locked but unconfirmed InstandSend transactions.

SPORK_5_INSTANTSEND_MAX_VALUE
  Enforces the maximum value in Dash that can be included in an
  InstantSend transaction.

SPORK_8_MASTERNODE_PAYMENT_ENFORCEMENT
  If enabled, miners must pay 50% of the block reward to a masternode
  currently pending selection or the block will be considered invalid.

SPORK_9_SUPERBLOCKS_ENABLED
  If enabled, superblocks are verified and issued to pay proposal
  winners.

SPORK_10_MASTERNODE_PAY_UPDATED_NODES
  Controls whether masternodes running an older protocol version are
  considered eligible for payment. This can be used as an incentive to
  encourage masternodes to update.

SPORK_12_RECONSIDER_BLOCKS
  Forces reindex of a specified number of blocks to recover from
  unintentional network forks.

SPORK_13_OLD_SUPERBLOCK_FLAG
  Deprecated. No network function since block 614820.

SPORK_14_REQUIRE_SENTINEL_FLAG
  Toggles whether masternodes with status are eligible for payment if
  status is WATCHDOG_EXPIRED, i.e. Sentinel is not running properly.

Viewing spork status
--------------------

The ``spork show`` and ``spork active`` commands issued in the debug
window (or from ``dash-cli`` on a masternode) allow you to interact with
sporks. You can open the debug window by selecting **Tools > Debug
console**.

.. figure:: img/dashcore-sporks.png
   :width: 300px

   spork show and spork active output in the Dash Core debug console
