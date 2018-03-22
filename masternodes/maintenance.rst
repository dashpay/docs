.. _masternode_maintenance:

===========
Maintenance
===========

Masternodes require regular maintenance to ensure you do not drop off
the payment queue. This includes promptly installing updates to Dash, as
well as maintaining the security and performance of the server. In
addition, masternodes should vote on proposals and perform other tasks
in the interest of the network and their own investment. This section
covers the following topics:

Payment withdrawals
===================

Once your masternode has been accepted by the network, it will enter the
masternode payment queue and slowly begin moving up. A masternode within
the top 10% of the list is selected and receives a payment each time a
new Dash block is mined. For more details on this process, see here.
These payments are sent to the same address you used to start your
masternode, which means you need to be careful when withdrawing the
payments. The original 1000 DASH payment you used to start your
masternode must remain untouched in a single unspent transaction output
(utxo) or your masternode will drop off the payment list - you may have
seen this ID when preparing to send the start masternode command.
Payments appear in separate UTXOs, so we need a method of only spending
those UTXOs and not the one containing the 1000 DASH. Note that
masternode payouts can only be spent after 100 confirmations.

Option 1: Withdrawals using a hardware wallet
---------------------------------------------

If you used a hardware wallet such as Trezor to start your masternode,
you must also use this process to make payout withdrawals. Once again,
we will be using Bertrand256's Dash Masternode Tool (DMT) to select the
correct outputs. With DMT, we can select specific UTXOs to withdraw the
payments without touching the original collateral transaction. This is
not possible using the Trezor web wallet alone.

Open DMT and verify the RPC and HW connections are working. From the
**Tools** menu, select **Transfer funds from current masternode's
address** or **Transfer funds from all masternode's addresses**, if you
use DMT to control multiple masternodes.

.. figure:: img/maintenance-dmt-tools.png
   :width: 400px

   Selecting the transfer funds function in DMT

DMT will load for a moment, then display a window showing the available
UTXOs you can use in your withdrawal. By default, all UTXOs not used as
masternode collateral are checked. The masternode collateral UTXOs are
not only unchecked but also hidden in order to avoid unintentionally
sending funds associated with collateral and stopping your masternode.
You can show these hidden entries by unchecking the **Hide collateral
utxos** option. Enter your destination address for the transaction. The
window should appear as follows:

.. figure:: img/maintenance-dmt-utxos.png
   :width: 400px

   Selecting the UTXOs to use an inputs in the withdrawal transaction

Verify the transaction fee and click **Send**. Your Trezor will prompt
to enter your PIN and confirm the transaction on the device. Once this
is done, confirm one more time to DMT that you want to broadcast the
transaction to the network by clicking Yes. A confirmation with the
transaction ID will appear.

.. image:: img/maintenance-dmt-broadcast.png
   :width: 220px

.. figure:: img/maintenance-dmt-sent.png
   :width: 180px

   Confirming broadcast of the transaction to the network

Option 2: Withdrawals from Dash Core wallet
-------------------------------------------

Similar to DMT as described above, we need a method in Dash Core wallet
to restrict which UTXOs are spent when making withdrawals from a
masternode address to ensure that the collateral UTXO is not touched. In
Dash Core wallet, this feature is known as Coin Control, and it must be
enabled before you can use it. Click **Settings > Options > Wallet >
Enable coin control features**. Now, when you go to the **Send** tab in
your wallet, a new button labelled **Inputs...** will appear. Click this
button to select which UTXOs can be used as input for any transactions
you create. The following window appears:

.. figure:: img/maintenance-dashcore-coin-selection.png
   :width: 400px

   Coin Selection window in Dash Core wallet, showing two masternodes
   (testnet)

Right click on the transaction(s) showing an amount of 1000 DASH, then
select **Lock unspent**. A small lock will appear next to the
transaction. Then click **OK**. You can now safely create transactions
with your remaining funds without affecting the original collateral
UTXOs.

.. image:: img/maintenance-dashcore-lock-unspent.png
   :width: 220px

.. figure:: img/maintenance-dashcore-locked.png
   :width: 180px

   Locking UTXOs in Dash Core wallet
