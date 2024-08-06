.. meta::
   :description: This guide describes how to set up a Dash evolution masternode.

.. _evonode-upgrade-existing-host:

=========================
Dashmate on existing host
=========================

Set up a dashmate node
----------------------

1. Download and install the `latest dashmate version
   <https://github.com/dashpay/platform/releases/latest>`__. For more details, refer to the
   :ref:`install instructions <evonode-setup-install-dashmate>`.
2. Set up an evonode::
     
     dashmate setup

   1. Select the network type
   2. Select ``evolution masternode`` when asked for node type
   3. Select ``Yes`` when asked if your masternode is already registered
   4. Select ``Yes`` when asked about importing existing data (the data is already present from the "Sync
      a full node" steps above)
   5. Import your existing masternode's keys
   6. Obtain an SSL certificate. See the :ref:`SSL certificates <evonode-ssl-cert>` section for
      details.

Stop existing dashd
-------------------

1. Stop your existing dashd process
2. Make sure you do not have any startup schedulers configured to restart dashd (systemd, cron, etc.)

Start dashmate node
-------------------

1. Start the node::

    dashmate start

2. Make sure the node works properly by running the following status commands::

    dashmate status
    dashmate status core
    dashmate status platform

Cleanup old dashd data
----------------------

Once you have confirmed everything is operating correctly, remove the old dashd data from your
server to free up storage space.
