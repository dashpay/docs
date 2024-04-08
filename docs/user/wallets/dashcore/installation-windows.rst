.. meta::
   :description: How to download, install and encrypt the Dash Core wallet in Windows
   :keywords: dash, core, wallet, windows, installation

.. _dashcore-installation-windows:

Windows Installation Guide
==========================

This guide describes how to download, install and encrypt the Dash Core
wallet for Windows. The guide is written for Windows 10, but the steps
should be similar for other versions of Windows.

Downloading the Dash Core wallet
--------------------------------

Visit https://www.dash.org/downloads/ to download the latest Dash Core
wallet. In most cases, the website will properly detect which version
you need. Click **Download Installer** to download the installer
directly.

.. figure:: img/windows/download.png
   :height: 250px

   The website properly detects the wallet appropriate for your system

If detection does not work, you will need to manually choose your operating
system. Once you know which version you need, download the Dash Core Installer
to your computer from https://www.dash.org/downloads/ and save the file you
downloaded to your Downloads folder.

.. note::
   Dash Core 0.17 was the last release to provide downloads for 32-bit Windows installations.
   As of Windows 11, Microsoft only provides 64-bit Windows. 

   If you are unsure whether your version of Windows is 32-bit or 64-bit, you can
   check by following the instructions `here
   <https://www.lifewire.com/am-i-running-a-32-bit-or-64-bit-version-of-windows-2624475>`__.

Verifying Dash Core
-------------------

This step is optional, but recommended to verify the authenticity of the
file you downloaded. This is done by checking its detached signature
against the public key published by the Dash Core development team. To
download the detached signature, click the **Installer Signature**
button on the wallet download page and save it to the same folder as the
downloaded binary.

All releases of Dash since 0.16.0 are signed using GPG with the following key:

- Pasta (pasta) with the key ``5252 7BED ABE8 7984``, `verifiable on Keybase
  <https://keybase.io/pasta>`__ (`download <https://keybase.io/pasta/pgp_keys.asc>`__)

Download the key file above. Install `Gpg4win <https://gpg4win.org/>`__
if it is not already available on your computer. Once it is installed,
open the **Kleopatra** certificate manager and click **File -> Import**.
Import the key file and verify the Key-ID matches the ID above. 

.. figure:: img/windows/setup-windows-kleopatra-import.png
   :height: 250px

   Importing Pasta's GPG public key

Skip any requests to certify the certificate with your own key. Next,
click **Decrypt/Verify...** and select the detached signature file named
``dashcore-20.1.1-win64-setup.exe.asc`` in the same folder as the
downloaded installer.

.. figure:: img/windows/setup-windows-kleopatra-verify.png
   :height: 250px

   Selecting the signature file for verification

If you see the first line of the message reads ``Verified
dashcore-20.1.1-win64-setup.exe with
dashcore-20.1.1-win64-setup.exe.asc`` then you have an authentic copy
of Dash Core for Windows.

.. figure:: img/windows/setup-windows-kleopatra-verified.png
   :height: 250px

   Example of successful binary installer verification

The following video demonstrates the steps to install Gpg4win and then verify
the Dash Core installation file signature.

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 1em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube-nocookie.com/embed/kBVF2PNpU3A?modestbranding=1&rel=0" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>

Running the Dash Core installer
-------------------------------

Double-click the file to start installing Dash Core.

.. figure:: img/windows/106328792.png
   :height: 250px

   The Dash Core installer in the Downloads folder

At this point, you may see a warning from Windows SmartScreen that the
app is unrecognized. You can safely skip past this warning by clicking
**More info**, then **Run anyway**.

.. figure:: img/windows/106328818.png
   :width: 354px

.. figure:: img/windows/106328813.png
   :width: 354px

   Bypassing Windows SmartScreen to run the app. This warning is known 
   as a “false positive”.

The installer will then guide you through the installation process.

.. figure:: img/windows/106328844.png
   :height: 250px

   The Dash Core installer welcome screen

Click through the following screens. All settings can be left at their
default values unless you have a specific reason to change something.

.. figure:: img/windows/106328866.png
   :height: 250px

   Select the installation location

.. figure:: img/windows/106328871.png
   :height: 250px

   Select the Start menu folder

.. figure:: img/windows/106328876.png
   :height: 250px

   Dash Core is being installed

.. figure:: img/windows/106328881.png
   :height: 250px

   Installation is complete

Running Dash Core for the first time
------------------------------------

Once installation is complete, Dash Core will start up immediately. If
it does not, click **Start > Dash Core > Dash Core** to start the
application. The first time the program is launched, you will be offered
a choice of where you want to store your blockchain and wallet data.
Choose a location with enough free space, as the blockchain can reach
45GB+ in size. It is recommended to use the default data folder
if possible.

.. figure:: img/windows/106328945.png
   :height: 250px

   Choosing the Dash Core data folder

Dash Core will then start up. This will take a little longer than usual
the first time you run it, since Dash Core needs to generate
cryptographic data to secure your wallet.

.. figure:: img/windows/106328960.png
   :height: 250px

   Starting Dash Core

Synchronizing Dash Core to the Dash network
-------------------------------------------

Once Dash Core is successfully installed and started, you will see the
wallet overview screen. You will notice that the wallet is “out of
sync”, and the status bar at the bottom of the window will show the
synchronization progress.

.. figure:: img/windows/dashcore-syncing.png
   :height: 250px

   Dash Core begins synchronizing with the Dash network

During this process, Dash Core will download a full copy of the Dash
blockchain from other nodes to your device. Depending on your internet
connection, this may take a long time. If you see the message “No block
source available”, check your internet connection. When synchronization
is complete, you will see a small green tick in the lower right
corner.

.. figure:: img/windows/dashcore-synced-and-encrypted.png
   :height: 250px

   Dash Core synchronization is complete

You can now create a wallet to send and receive funds.

Creating your Dash Wallet
-------------------------

.. versionadded:: v20.1.0
   
   HD wallets are now created by default.

If no wallet files are loaded, you will get this prompt in the Overview tab. To
create a wallet, click the **Create a new wallet** button or click **File** ->
**Create Wallet**. HD wallets are created by default. See the
:hoverxref:`advanced topics section <dashcore-hd>` for information about HD
wallets.

.. figure:: img/windows/dash-create-wallet-prompt.png
   :height: 350px

You will be prompted to create a new wallet with a custom wallet name. By
default, your wallet will be encrypted. You may choose to uncheck the box and
encrypt the wallet later. We have included instructions on how to encrypt your
wallet in the following section.

.. figure:: img/windows/dash-name-wallet.png
   :width: 300px

If you do choose to encrypt now, you will be asked to enter and verify a password.

.. figure:: img/windows/dash-encrypt-wallet.png
   :height: 175px

   Enter a password

Following that, you will get a standard warning.

.. figure:: img/windows/dash-encrypt-wallet-confirmation.png
   :width: 350px

   Confirm you want to encrypt your wallet

The following section will detail the steps you need to follow if you 
choose to encrypt your Dash wallet later.

Encrypting your Dash wallet
---------------------------

To encrypt your wallet, click **Settings > Encrypt Wallet**.

.. figure:: img/windows/dashcore-settings-encrypt.png
   :height: 250px

   Encrypting the Dash wallet with a password

You will be asked to enter and verify a password.

.. figure:: img/windows/dash-encrypt-wallet.png
   :height: 175px

   Enter a password

.. figure:: img/windows/dash-encrypt-wallet-confirmation.png
   :width: 350px

   Confirm you want to encrypt your wallet

When the encryption process is complete, you will see a warning that
past backups of your wallet will no longer be usable, and be asked to
shut down Dash Core. When you restart Dash Core, you will see a small
green lock in the lower right corner.

.. figure:: img/windows/dashcore-synced-and-encrypted.png
   :height: 250px

   Fully encrypted and synchronized Dash Core wallet

You can now begin to use your wallet to safely send and receive funds.
