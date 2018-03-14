.. _electrum_advanced_functions:

Advanced Functions
==================

Change Password
---------------

To change the wallet's password, select the **Wallet > Password** option
from the main menu, or click on the lock icon in the lower right of the
main window. Enter and confirm a new secure password. Should you forget
your wallets' password, all is not lost. Your wallet can be restored in
its entirety using the backup procedure described here.

Backup Wallet
-------------

In Electrum, a seed is a complete backup of all addresses and
transactions. Access your wallet's seed through the seed icon in the
lower right of the main screen, or the **Wallet > Seed** main menu
option. When prompted, enter the secure password you chose when setting
up the Electrum wallet.

.. figure:: img/backup-seed.png
   :width: 400px

   Selecting the server and naming your first wallet

Hand-copy the twelve words found in the box to a piece of paper and
store it in a safe location. Remember, anyone who finds your seed can
spend all of the funds in your wallet.

.. figure:: img/backup-view.png
   :width: 300px

   Selecting the server and naming your first wallet

Alternatively, a backup file can be saved using the **File > Save Copy**
main menu option. This file stores the wallet's encrypted seed along
with any imported addresses. Restoring this backup will require the
wallet password.

Restore Wallet
--------------

The only thing needed to recover an Electrum wallet on another computer
is its seed. You can test wallet recovery with your current installation
of Dash Electrum by removing the wallet data from the application data
folder. This optional procedure is described below. Before continuing,
verify that your seed is written down clearly and correctly on paper.

To get Electrum to generate a new wallet, the old wallet data needs to
be deleted. Begin by closing Electrum. Next, locate the application data
folder according to your operating system:

- **Linux**
  1. Open Files, select **Go > Go to folder**, copy the path 
  ``~/.electrum`` and paste it into the dialog box
  2. Delete all files in the folder

- **macOS:**
  1. Open Finder, select **Go > Go to Folder**, copy the path
     ``~/.electrum`` and paste it into the dialog box
  2. Delete all files in the folder

- **Windows:**
  1. Open Explorer, copy the path ``%APPDATA%\Electrum-DASH`` and paste
     it in to the address bar
  2. Delete all files in the folder

