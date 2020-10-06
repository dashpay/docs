.. meta::
   :description: The upgrade to Dash 0.16.0 involves the introduction of the Block Reward Reallocation. This documentation highlights the upgrade steps and progress.
   :keywords: dash, cryptocurrency, masternode, miners, pools, exchanges, wallets, maintenance, upgrade

.. include:: <isopub.txt>

.. _v016-dev-upgrade:

=============================
Dash 0.16 Upgrade Information
=============================

**Official binaries are available at** https://github.com/dashpay/dash/releases/tag/v0.16.0.1

Dash Core v0.16.0 introduces the multi-year shift in the allocation of 
block rewards between masternodes and miners. Please see the `Dash
Core v0.16.0 Product Brief <https://blog.dash.org/updated-product-brief-dash-core-release-v0-16-0-d3debdb6242e>`__
for an overview of new features. The upgrade will take place in phases, as
shown in the following diagram:

.. image:: img/016-upgrade-procedure.png


Installation notes
==================

Dash Core v0.16.0.1 will automatically activate the Block Reward Reallocation
once a threshold percentage of the network has upgraded. Mining pools must
mine an upgraded block to successfully signal the upgrade in a block, and
the threshold percentage of blocks in a window must signal in order to lock
in the upgrade. 

The threshold percentage for this activation is dynamic and will decrease
every 4032 blocks from 80% to 60%, over approximately 10 weeks. The first
window will begin at block 1350720 (on 2020-10-07). Information
regarding the activation threshold and progress can be obtained via Dash
Core's debug console or the command line by using the `getblockchaininfo`
command.

- Activation status can be tracked in the image below or at `this site
  <http://178.254.23.111/~pub/Dash/Dash_Info.html>`__.

.. figure:: http://178.254.23.111/~pub/16_adoption.png

   Dash v0.16.0.0 adoption by miners

- Masternode upgrade status can be tracked at `Dash Ninja <https://www.dashninja.pl/deterministic-masternodes.html>`__

- If you are updating to Dash Core v0.16.0.1 from version 0.13.x+ you
  should be able to simply shut down the daemon and replace it with
  the updated binary. Versions <= 0.14.0.3 will run a migration
  process on startup that may take a few minutes.

- If you are updating to Dash Core v0.16.0.1 from version < 0.13 please
  note that you will also need to re-index the chainstate using the
  “-reindex-chainstate” command.

Dependencies
============

- Contact the `Support Desk <https://support.dash.org/en/support/home>`__
  with any compatibility questions or for help upgrading.

Please see the official `Release Notes <https://github.com/dashpay/dash/blob/v0.16.0.1/doc/release-notes.md#rpc-changes>`__
for a complete listing of RPC improvements.