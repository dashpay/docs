.. meta::
   :description: Description of dash evo tool features and usage
   :keywords: dash, platform, evonode, masternodes, dash evo tool

.. _evo-tool:

=============
Dash Evo Tool
=============

Dash Evo Tool is an application designed to help you vote on usernames, withdraw evonode credits,
and complete an expanding list of Platform actions. This guide describes how to download, install,
and use the Dash Evo Tool.

.. _evo-tool-install:

Installation
============

.. note::

  The Dash Evo Tool requires a Dash Core full node configured to allow RPC access.

Linux, MacOS, or Windows packages are available on the `GitHub releases page
<https://github.com/dashpay/dash-evo-tool/releases/latest>`__. Download the zip file for your
Operating System, then unzip the downloaded file:

* `Windows <https://github.com/dashpay/dash-evo-tool/releases/download/v0.1.2/DashEvoTool-windows-x86_64.zip>`_
* `Mac (ARM m1-m4) <https://github.com/dashpay/dash-evo-tool/releases/download/v0.1.1/DashEvoTool-aarch64-mac.zip>`_
* `Mac (x86) <https://github.com/dashpay/dash-evo-tool/releases/download/v0.1.1/DashEvoTool-x86_64-mac.zip>`_
* `Linux (x86) <https://github.com/dashpay/dash-evo-tool/releases/download/v0.1.3/DashEvoTool-linux-x86_64.zip>`_
* `Linux (ARM) <https://github.com/dashpay/dash-evo-tool/releases/download/v0.1.3/DashEvoTool-linux-aarch64.zip>`_ 

.. _evo-tool-configure:

Configuration
=============

1. Open the directory where the download was unzipped.
2. Open the ``.env`` file (you may need to show hidden files to see it). For the network you plan to
   connect to, make the following changes. Replace the ``*`` with the network name (MAINNET or
   TESTNET):

   * Update ``*_CORE_RPC_USER`` to match the ``rpcuser`` value from your Dash Core dash.conf file.
   * Update ``*_CORE_RPC_PASSWORD`` to match the ``rpcpassword`` value from your Dash Core dash.conf
     file configured in your Dash Core ``dash.conf`` file.
   * If your dash.conf includes ``rpcallowip``, update ``*_CORE_HOST`` with that IP address.
   * If your dash.conf includes ``rpcport``, update ``*_CORE_RPC_PORT`` with that port.

.. tip::

  The default location of the ``dash.conf`` file can be found in the :ref:`Dash Core documentation
  <dashcore-rpc>`. At a minimum, the following values must be defined for RPC access to be enabled:

  .. code-block:: ini

    server=1
    rpcuser=<some_user_name>
    rpcpassword=<some_password>

.. _evo-tool-run:

Running the application
=======================

Once the ``.env`` file is configured, launch the Dash Evo Tool by double-clicking the file named
``dash-evo-tool-<your platform>`` (e.g., ``dash-evo-tool-aarch64-mac``).

Alternatively, you can launch the application directly from your terminal. For example, on an x86
Linux, run::

  ./dash-evo-tool-x86_64-linux

.. _evo-tool-select-network:

Network selection
=================

The Dash Evo Tool supports both testnet and mainnet. To choose a network, navigate to the Network
Selection screen and click the checkbox in the Select column for the desired network. Then click the
**Start** button on that row to launch Dash Core.

.. note::

  You can also launch Dash Core manually without using the Dash Evo Tool. This may be necessary if
  Dash Core is installed in a non-standard location.

.. figure:: img/network-selection.png
   :align: center
   :width: 90%

   Network selection screen with testnet selected

.. _evo-tool-identity:

Identity operations
===================

.. _evo-tool-identity-load:

Load an identity
----------------

On the main identity screen, click the **Load Identity** button on the upper right side of the
screen.

.. figure:: img/identity/main-empty.png
   :align: center
   :width: 90%

   Identity screen with no loaded identities

Some identity types require different information. Use the **Identity Type** dropdown menu to select
the type you want to add. In this example, an evonode identity is being added.

.. figure:: img/identity/add-identity-evonode.png
   :align: center
   :width: 90%

   Identity load screen for evonode

Add the Identity ID and Owner Private Key. You may also want to add the Voting Private Key, but
adding the Payout Address Private Key is **not** recommended. For a masternode or evonode, use the
protx hash as the Identity ID.

Click **Load Identity** once you have entered the required information.

.. figure:: img/identity/add-identity-id-and-key.png
   :align: center
   :width: 90%

   Identity load screen with evonode info filled out

Once the identity is loaded, you can view its balance and details about its keys. For evonodes, you
can also initiate :ref:`withdrawals <evo-tool-identity-evo-withdraw>`.

.. figure:: img/identity/main-evonode.png
   :align: center
   :width: 90%

   Identity screen with an evonode identity loaded

.. _evo-tool-identity-evo-withdraw:

Evonode withdrawals
-------------------

.. attention::

  Withdrawal requests enter a queue that is currently processed more slowly than intended. Depending
  on the timing of the withdrawal request, it may take up to 18 hours to complete. 
  
  For security, there is also a limit on how much can be withdrawn from Platform daily. If
  withdrawal requests hit the daily limit, they will remain in the queue longer. For details, see
  this `DCG development update
  <https://www.youtube.com/live/rc_avHHqG6E?si=ETv0yX-1b3odCU8F&t=599>`_.

From the identity main screen, click the **Withdraw** button for an identity.

.. figure:: img/identity/withdraw.png
   :align: center
   :width: 90%

   Identity screen with an evonode identity loaded

On the withdrawal screen, select the key to sign the withdrawal. Selecting the owner key is
recommended since this will direct the withdrawal to the payout address. Next, set the amount to
withdraw.

.. note::

  The **Max** button currently has a bug and sets the withdrawal amount in credits instead of DASH,
  so you will need to manually adjust the amount if you use that button.

Click **Withdraw** after entering the information.

.. figure:: img/identity/withdraw-key-amount.png
   :align: center
   :width: 90%

   Withdraw screen with key and amount selected

When the withdrawal confirmation screen opens, confirm that the amount and destination address are
correct. Click **Confirm** to request the withdrawal.

.. figure:: img/identity/withdrawal-confirm.png
   :align: center
   :width: 90%

   Withdrawal confirmation screen

