.. meta::
   :description: Description of dashmate features and usage
   :keywords: dash, wallet, core, platform, evonode, masternodes, dashmate

.. _dashmate:

========
Dashmate
========

Dashmate is a universal tool designed to help you set up and run Dash
masternodes in a containerized environment. It is also an ideal tool to quickly
and easily set up and run a development network on your local system.

.. figure:: img/dashmate.gif
   :align: center

   Setting up a testnet evonode using dashmate

.. _dashmate-full-install:

Installation
============

This guide describes how to download, install and use dashmate on for Linux. The guide is written
for Ubuntu 22.04 x64 LTS, but the steps should be similar for other Linux distributions.

.. _dashmate-dep-install:

Install dependencies
--------------------

Install and configure Docker::
   
   curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh
   sudo usermod -aG docker $USER
   newgrp docker

.. _dashmate-install:

Install dashmate
----------------

There are several methods available for installing dashmate. Installing the Linux, MacOS, or Windows
packages from the `GitHub releases page <https://github.com/dashpay/platform/releases/latest>`__ is
recommended for mainnet masternodes.

.. _dashmate-install-deb:

Debian package
^^^^^^^^^^^^^^

Download the newest dashmate installation package for your architecture from the `GitHub releases
page <https://github.com/dashpay/platform/releases/latest>`__::

   wget https://github.com/dashpay/platform/releases/download/v1.1.0/dashmate_1.1.0.483a9c5ba-1_amd64.deb

Install dashmate using apt::

   sudo apt update
   sudo apt install ./dashmate_1.1.0.483a9c5ba-1_amd64.deb

.. note:: At the end of the installation process, ``apt`` may display an error due to installing a downloaded package. You can ignore this error message:
   
   ``N: Download is performed unsandboxed as root as file '/home/ubuntu/dashmate_1.1.0.483a9c5ba-1_amd64.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)``

Node package
^^^^^^^^^^^^

.. warning:: This installation option is not recommended for mainnet masternodes. Please install
            packages from the `GitHub releases page <https://github.com/dashpay/platform/releases/latest>`__.

.. dropdown:: Node.js dashmate install

   To install the NodeJS package, it is necessary to install NodeJS first. We recommend
   installing it using `nvm <https://github.com/nvm-sh/nvm#readme>`__::

     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
     source ~/.bashrc
     nvm install 20

   Once NodeJS has been installed, use npm to install dashmate::

      npm install -g dashmate

.. _dashmate-wizard-walkthrough:

Masternode setup
================

Dashmate is primarily recommended for setting up Evolution masternodes (evonodes). With the
exception of a few minor extra steps for evonodes, the process is identical for evonodes and regular
masternodes. Complete the steps in the sections below to set up your node or follow along with this
step-by-step tutorial.

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 1em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube-nocookie.com/embed/973E4knShBA" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>

To begin masternode setup, run ``dashmate setup`` to start the interactive wizard::

   dashmate setup

Set Network and Node type
-------------------------

.. figure:: img/1-dashmate-setup.png
   :align: center
   :width: 90%

   Select the testnet network preset

.. figure:: img/2-select-node-type.png
   :align: center
   :width: 90%

   Create an Evolution masternode

Select **No** to register a new masternode or **Yes** to import information
about an existing masternode.

.. figure:: img/3-already-registered.png
   :align: center
   :width: 90%

   Set up a new masternode

If registering a new masternode, jump to the :ref:`defining keys and addresses
<dashmate-define-keys-addresses>` section next.

Import existing Core data
-------------------------

.. note:: The following step only applies when migrating an existing masternode into dashmate.

If you chose to import an existing masternode in the previous step, you will be prompted for the
location of your existing installation. 

.. figure:: img/4a-import-existing-data.png
   :align: center
   :width: 90%

   Import existing data

.. figure:: img/4b-import-existing-data-path.png
   :align: center
   :width: 90%

   Enter existing Core data directory

.. figure:: img/4c-import-existing-data-complete.png
   :align: center
   :width: 90%

   Core data import complete

Once the Core data has been imported, jump to the :ref:`configure communication
<dashmate-configure-communication>` section.

.. _dashmate-define-keys-addresses:

Define Keys and Addresses
-------------------------

.. figure:: img/4-wallet-for-keys.png
   :align: center
   :width: 90%

   Store masternode keys in Dash Core

Enter the requested information from your :hoverxref:`collateral funding
transaction <evonode-send-collateral>`. You can find these values using Dash Core's
:hoverxref:`masternode outputs <evonode-mn-outputs>` command.

.. figure:: img/5b-collateral-info-completed.png
   :align: center
   :width: 90%

   Enter collateral transaction information

Enter the owner, voting, and payout addresses you :hoverxref:`generated using
Dash Core <evonode-get-addresses>` or your selected wallet.

.. figure:: img/6b-mn-addresses-completed.png
   :align: center
   :width: 90%

   Enter masternode addresses

Enter an operator BLS private key. You can enter one you have created (e.g.
:hoverxref:`using Dash Core <evonode-bls-generation>`) or received from a hosting
provider. Optionally, use the one automatically generated by dashmate.

If a portion of the masternode rewards are intended to go to the operator
directly, set the reward share percentage also.

.. figure:: img/7-bls-operator-key.png
   :align: center
   :width: 90%

   Enter operator information

.. note:: The following step only applies to Evolution masternodes. Regular masternodes 
          do not require a Platform node key since they do not host Platform services.

Enter a Platform node key. You can enter one :hoverxref:`you have created
<evonode-generate-platform-node-id>` or received from a hosting provider.
Optionally, use the one automatically generated by dashmate.

.. figure:: img/8-ed25519-platform-key.png
   :align: center
   :width: 90%

   Enter the Platform node key

.. _dashmate-configure-communication:

Configure communication
-----------------------

Dashmate will automatically detect the external IP address and select the
default ports for the network you are setting up. You can modify these values if
necessary for a specific reason, but typically the defaults should be used.

.. figure:: img/9-ip-and-ports.png
   :align: center
   :width: 90%

   Enter connection information

Register the masternode
-----------------------

Copy the provided protx command and run it using dash-cli or the Dash Core
console. Do note that your payout address must have a balance for the
registration process to be successful, so remember to send some DASH
to this address before you begin registration.

Select **Yes** after the command has been run successfully. If you
receive an error, select **No** to go back through the previous steps and review
details.

.. figure:: img/10b-protx-command-successful.png
   :align: center
   :width: 90%

   Run the registration command

.. _dashmate-enable-ssl:

Enable SSL
----------

.. note:: The following step only applies to evonodes. Regular masternodes do not
   require an SSL certificate since they do not host Platform services.

Dash Platform requires SSL for communication. Dashmate provides several options
for obtaining the required SSL certificate.

.. warning:: Self-signed certificates cannot be used on mainnet. When setting
   up a mainnet evonode, **ZeroSSL** and **File on disk** are the only options available.

.. figure:: img/11a-ssl-config-zerossl.png
   :align: center
   :width: 90%

   Configure SSL

Once the configuration is complete, a summary showing the network and type of
node configured is displayed. This summary includes important parameters and
information on how to proceed.

.. warning::

   The BLS operator private key and Platform Node key must be backed up and kept secure.

.. figure:: img/12-configuration-complete.png
   :align: center
   :width: 95%

   Configuration complete! 🎉

Start the node
--------------

Start your node as follows::

   dashmate start

.. note::

   When starting a node for the first time, dashmate will download the
   Docker images required for each service. The time required for this
   one-time download will depend on the available bandwidth but typically
   should complete within a few minutes.

.. _dashmate-node-operation:

Dashmate node operation
=======================

You can manage your masternode status, configuration, and running state entirely
from within dashmate. Use the built-in help system to learn more:

- ``dashmate --help``
- ``dashmate <command> --help``

.. figure:: img/dashmate-help.png
   :width: 90%

   Dashmate displaying top-level help output

Start or restart node
---------------------

To start your dashmate node, run::

   dashmate start

To restart your dashmate node, run::

   dashmate restart

Stop node
---------

To stop your dashmate node, run::

   dashmate stop

Node status
-----------

You can check the status of your masternode using the various ``dashmate
status`` commands as follows::

  dashmate status
  dashmate status core
  dashmate status host
  dashmate status masternode
  dashmate status platform
  dashmate status services

.. figure:: img/dashmate-status.png
   :width: 350px

   Dashmate displaying a range of status output

Node update
-----------

To update dashmate, it is necessary to download and install the new version of dashmate. First, stop
dashmate if it is running::

  dashmate stop

Next, install the new version of dashmate following the instructions in the :ref:`dashmate install
section <dashmate-install>`.

Once the new version is installed, reset the configuration and services using ``--keep-data`` so the
existing data is retained. Then, update the dashmate services::

  dashmate reset --keep-data
  dashmate update

Finally, restart dashmate::
   
  dashmate start

Additional Information
======================

For further documentation see the `dashmate repository
<https://github.com/dashpay/platform/blob/master/packages/dashmate/README.md>`__.
