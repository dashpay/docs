.. meta::
   :description: This guide describes how to set up a Dash evolution masternode.

.. _evonode-upgrade-new-host:

======================
Dashmate on a new host
======================

Setup a new node
----------------

1. :ref:`Set up a new server <server-config>`
2. Download and install the `latest dashmate version
   <https://github.com/dashpay/platform/releases/latest>`__. For more details, refer to the
   :ref:`install instructions <evonode-setup-install-dashmate>`.

Sync a full node
----------------

To minimize downtime, sync the Core blockchain without interrupting the existing node. The easiest
way to do this is by syncing a full node and then converting it to an evonode.

1. Set up a dashmate full node to sync Core first::
     
     dashmate setup

2. Select the network type and then ``fullnode`` for the node type
3. Enable the indexes required by Platform and then start dashmate to sync::
     
     dashmate config set core.indexes '["tx"]'
     dashmate start

4. Make sure Core is syncing::
     
     dashmate status core

Set up an evonode
-----------------

1. Once Core has finished syncing, reset the configuration and services. Use ``--keep-data`` so the
   synced data is retained::
     
     dashmate stop
     dashmate reset --keep-data --hard

2. Transfer the IP address to the new node. Alternatively, you can use the :ref:`protx
   update_service_evo command <dip3-update-service-evonode>` to set a new IP address for your
   dashmate-based evonode.
3. Set up an evonode::
     
     dashmate setup

   1. Select the network type
   2. Select ``evolution masternode`` when asked for node type
   3. Select ``Yes`` when asked if your masternode is already registered
   4. Select ``No`` when asked about importing existing data (the data is already present from the "Sync
      a full node" steps above)
   5. Import your existing masternode's keys
   6. Obtain an SSL certificate. See the :ref:`SSL certificates <evonode-ssl-cert>` section for
      details.

Shutdown existing masternode
----------------------------

1. Shut down your existing server or dashd process
2. If you keep the existing server running, ensure you do not have any startup schedulers configured
   (systemd, cron, etc.)

Start dashmate node
-------------------

1. Start the node::

    dashmate start

2. Make sure the node works properly by running the following status commands::

    dashmate status
    dashmate status core
    dashmate status platform
