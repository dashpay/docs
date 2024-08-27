.. meta::
   :description: This guide describes how to set up a Dash evolution masternode.

.. _evonode-upgrade-from-dashmate-v1:

========================
Upgrade from dashmate v1
========================

Check your current dashmate version to make sure you are on the right path::

  dashmate --version


Install the new dashmate version
--------------------------------

1. Stop dashmate::
   
     dashmate stop

2. Download and install the `latest dashmate version
   <https://github.com/dashpay/platform/releases/latest>`__. For more details, refer to the
   :ref:`install instructions <evonode-setup-install-dashmate>`.

3. Reset previous services to ensure compatibility with the new version::
   
     dashmate reset

4. Update services::
   
     dashmate update

Start dashmate node
-------------------

1. Start the node::

    dashmate start

2. Make sure the node works properly by running the following status commands::

    dashmate status
    dashmate status core
    dashmate status platform
