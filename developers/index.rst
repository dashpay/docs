.. _developers:

==========
Developers
==========

Dash Core has published an extensive `Developer Guide <https://dash-
docs.github.io/en/>`_ to help new developers get started with the Dash
code base, and as a reference for experienced developers. This guide can
be leveraged to quickly and efficiently integrate external applications
with the Dash ecosystem. Anyone can contribute to the guide by
submitting an issue or pull request on GitHub. The documentation is
available at: https://dash-docs.github.io/en/

The Dash Core Team also maintains the `Dash Roadmap
<https://github.com/dashpay/dash-roadmap>`_, which sets out delivery
milestones for future releases of Dash and includes specific technical
details describing how the development team plans to realise each
challenge. The Dash Roadmap is complemented by the `Dash Improvement
Proposals <https://github.com/dashpay/dips>`_, which contain detailed
technical explanations of proposed changes to the Dash protocol itself.

The remaining sections available below describe practical steps to
carry out common development tasks in Dash.

.. toctree::
   :maxdepth: 1

   translating.rst
   compiling.rst
   testnet.rst

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


Version History
===============

Full release notes and the version history of Dash are available here:

- https://github.com/dashpay/dash/blob/master/doc/release-notes.md