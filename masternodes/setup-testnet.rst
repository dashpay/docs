.. meta::
   :description: This guide describes how to set up a Dash masternode with evo services.
   :keywords: dash, guide, masternodes, trezor, dip3, setup, bls

.. _testnet-masternode-setup:

=============
Testnet Setup
=============

Setting up a masternode with support for evo services requires a basic
understanding of Linux and blockchain technology, as well as an ability
to follow instructions closely. It also requires regular maintenance and
careful security, particularly if you are not storing your Dash on a
hardware wallet. There are some decisions to be made along the way, and
optional extra steps to take for increased security.

Commercial :ref:`masternode hosting services <masternode-hosting>` are
available if you prefer to delegate day-to-day operation of your
masternode to a professional operator. When using these hosting
services, you retain full control of the 1000 DASH collateral and pay an
agreed percentage of your reward to the operator. It is also possible to
delegate your voting keys to a representative, see the 
:ref:`governance documentation <delegating-votes>` for more
information.


Before you begin
================

This guide assumes you are setting up a single testnet masternode for
the first time. If you are updating a masternode, see  :ref:`here
<masternode-update>` instead. You will need:

- 1000 Dash
- A wallet to store your Dash, preferably a hardware wallet, although 
  Dash Core wallet is also supported
- A Linux server, preferably a Virtual Private Server (VPS)

Dash 0.13.0 and later implement DIP003, which introduces several changes
to how a Dash masternode is set up and operated. While this network
upgrade was completed in early 2019, a list of available documentation
appears below:

- `DIP003 Deterministic Masternode Lists <https://github.com/dashpay/dips/blob/master/dip-0003.md>`__
- :ref:`dip3-changes`
- `Dash 0.13 Upgrade Procedure for Masternodes (legacy documentation) <https://docs.dash.org/en/0.13.0/masternodes/dip3-upgrade.html>`__
- :ref:`Full masternode setup guide <masternode-setup>` (you are here)
- :ref:`Information for users of hosted masternodes <hosted-setup>`
- :ref:`Information for operators of hosted masternodes <operator-transactions>`

This documentation describes the commands as if they were entered in the Dash
Core GUI by opening the console from **Window > Console**, but the same result
can be achieved on a masternode by entering the same commands and adding the
prefix ``~/.dashcore/dash-cli`` to each command.


.. _testnet-vps-setup:

Set up your VPS
===============

A VPS, more commonly known as a cloud server, is fully functional
installation of an operating system (usually Linux) operating within a
virtual machine. The virtual machine allows the VPS provider to run
multiple systems on one physical server, making it more efficient and
much cheaper than having a single operating system running on the "bare
metal" of each server. A VPS is ideal for hosting a Dash masternode
because they typically offer guaranteed uptime, redundancy in the case
of hardware failure and a static IP address that is required to ensure
you remain in the masternode payment queue. While running a masternode
from home on a desktop computer is technically possible, it will most
likely not work reliably because most ISPs allocate dynamic IP addresses
to home users.

We will use `Vultr <https://www.vultr.com/>`_ hosting as an example of a
VPS, although `DigitalOcean <https://www.digitalocean.com/>`_, `Amazon
EC2 <https://aws.amazon.com/ec2/>`_, `Google Cloud
<https://cloud.google.com/compute/>`_, `Choopa
<https://www.choopa.com/>`_ and `OVH <https://www.ovh.com.au/>`_ are
also popular choices. First create an account and add credit. Then go to
the **Servers** menu item on the left and click **+** to add a new
server. Select a location for your new server on the following screen:

.. figure:: img/setup-server-location.png
   :width: 400px

   Vultr server location selection screen

Select Ubuntu 22.04 x64 as the server type. We use this LTS release of
Ubuntu instead of the latest version because LTS releases are supported
with security updates for 5 years, instead of the usual 9 months.

.. figure:: img/setup-server-type.png
   :width: 400px

   Vultr server type selection screen

Select a server size offering at least 2GB of memory.

.. figure:: img/setup-server-size.png
   :width: 400px

   Vultr server size selection screen

Enter a hostname and label for your server. In this example we will use
``dashmn1`` as the hostname.

.. figure:: img/setup-server-hostname.png
   :width: 400px

   Vultr server hostname & label selection screen

Vultr will now install your server. This process may take a few minutes.

.. figure:: img/setup-server-installing.png
   :width: 400px

   Vultr server installation screen

Click **Manage** when installation is complete and take note of the IP
address, username and password.

.. figure:: img/setup-server-manage.png
   :width: 276px

   Vultr server management screen


Set up your operating system
============================

We will begin by connecting to your newly provisioned server. On
Windows, we will first download an app called PuTTY to connect to the
server. Go to the `PuTTY download page <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>`_
and select the appropriate MSI installer for your system.
On Mac or Linux you can ssh directly from
the terminal - simply type ``ssh root@<server_ip>`` and enter your
password when prompted.

.. figure:: img/setup-putty-download.png
   :width: 400px

   PuTTY download page

Double-click the downloaded file to install PuTTY, then run the app from
your Start menu. Enter the IP address of the server in the **Host Name**
field and click **Open**. You may see a certificate warning, since this
is the first time you are connecting to this server. You can safely
click **Yes** to trust this server in the future.

.. figure:: img/setup-putty-alert.png
   :width: 320px

   PuTTY security alert when connecting to a new server

You are now connected to your server and should see a terminal
window. Begin by logging in to your server with the user ``root`` and
password supplied by your hosting provider.

.. figure:: img/setup-putty-connect.png
   :width: 400px

   Password challenge when connecting to your VPS for the first time

You should immediately change the root password and store it in a safe
place for security. You can copy and paste any of the following commands
by selecting them in your browser, pressing **Ctrl + C**, then switching
to the PuTTY window and right-clicking in the window. The text will
paste at the current cursor location::

  passwd root

Enter and confirm a new password (preferably long and randomly
generated). Next we will create a new user with the following command,
replacing ``<username>`` with a username of your choice::

  adduser <username>

You will be prompted for a password. Enter and confirm using a new
password (different to your root password) and store it in a safe place.
You will also see prompts for user information, but this can be left
blank. Once the user has been created, we will add them to the sudo
group so they can perform commands as root::

  usermod -aG sudo <username>

Now, while still as root, we will update the system from the Ubuntu
package repository::

  apt update
  apt upgrade

The system will show a list of upgradable packages. Press **Y** and
**Enter** to install the packages. We will now install a firewall, add
swap memory and reboot the server to apply any necessary kernel updates,
and then login to our newly secured environment as the new user::

  ufw allow ssh/tcp
  ufw limit ssh/tcp
  ufw allow 19999/tcp
  ufw allow 26656/tcp
  ufw allow 3000/tcp
  ufw allow 3010/tcp
  ufw logging on
  ufw enable

(press **Y** and **Enter** to confirm)

::

  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  nano /etc/fstab

Add the following line at the end of the file (press tab to separate
each word/number), then press **Ctrl + X** to close the editor, then
**Y** and **Enter** save the file.

::

  /swapfile none swap sw 0 0

Finally, in order to prevent brute force password hacking attacks, we
will install fail2ban and disable root login over ssh. These steps are
optional, but highly recommended. Start with fail2ban::

  apt install fail2ban

Create a new configuration file::

  nano /etc/fail2ban/jail.local

And paste in the following configuration::

  [sshd]
  enabled = true
  port = 22
  filter = sshd
  logpath = /var/log/auth.log
  maxretry = 3

Then press **Ctrl + X** to close the editor, then **Y** and **Enter**
save the file. Retart and enable the fail2ban service::

  systemctl restart fail2ban
  systemctl enable fail2ban

Next, open the SSH configuration file to disable root login over SSH::

  nano /etc/ssh/sshd_config

Locate the line that reads ``PermitRootLogin yes`` and set it to
``PermitRootLogin no``. Directly below this, add a line which reads
``AllowUsers <username>``, replacing ``<username>`` with the username
you selected above. Then press **Ctrl + X** to close the editor, then
**Y** and **Enter** save the file.

Then reboot the server::

  reboot now

PuTTY will disconnect when the server reboots.

While this setup includes basic steps to protect your server against
attacks, much more can be done. In particular, `authenticating with a public key <https://help.ubuntu.com/community/SSH/OpenSSH/Keys>`_
instead of a username/password combination and `enabling automatic security updates <https://help.ubuntu.com/community/AutomaticSecurityUpdates>`_ 
is advisable. More tips are available `here <https://www.cyberciti.biz/tips/linux-security.html>`__. 
However, since the masternode does not actually store the keys to any
Dash, these steps are considered beyond the scope of this guide.


Send the collateral
===================

A Dash address with a single unspent transaction output (UTXO) of
exactly 1000 DASH is required to operate a masternode. Once it has been
sent, various keys regarding the transaction must be extracted for later
entry in a configuration file and registration transaction as proof to
write the configuration to the blockchain so the masternode can be
included in the deterministic list. A masternode can be registered from
a hardware wallet or the official Dash Core wallet, although a hardware
wallet is highly recommended to enhance security and protect yourself
against hacking. This guide will describe the steps for both hardware
wallets and Dash Core.

Option 1: Holding collateral in a hardware wallet
-------------------------------------------------

Set up your Trezor using the Trezor wallet at https://wallet.trezor.io/
and send a test transaction to verify that it is working properly. For
help on this, see :ref:`this guide <hardware-trezor>` - you may also
choose to (carefully!) `add a passphrase <https://blog.trezor.io/passphrase-the-ultimate-protection-for-your-accounts-3a311990925b>`_
to your Trezor to further protect your collateral. Create a new account
in your Trezor wallet by clicking **Add account**. Then click the
**Receive** tab and send exactly 1000 DASH to the address displayed. If
you are setting up multiple masternodes, send 1000 DASH to consecutive
addresses within the same new account. You should see the transaction as
soon as the first confirmation arrives, usually within a few minutes.

.. figure:: img/setup-collateral-trezor.png
   :width: 400px

   Trezor Wallet Receive tab showing successfully received collateral of
   1000 DASH

Once the transaction appears, click the QR code on the right to view the
transaction on the blockchain. Keep this window open as we complete the
following steps, since we will soon need to confirm that 15
confirmations exist, as shown in the following screenshot.

.. figure:: img/setup-collateral-blocks.png
   :width: 400px

   Trezor blockchain explorer showing 15 confirmations for collateral
   transfer

While we are waiting for 15 confirmations, download the latest version
of the Dash Masternode Tool (DMT) from the GitHub releases page `here
<https://github.com/Bertrand256/dash-masternode-tool/releases>`__. Unzip
and run the file. The following window appears.

.. figure:: img/setup-collateral-dmt-start.png
   :width: 400px

   Dash Masternode Tool startup screen

Click the third button from the left **Check Dash Network Connection**
in the top left corner of the main window to verify that the connection
is working. Then connect your Trezor device and click the next button
**Test Hardware Wallet Connection** to verify the Trezor connection is
working.

.. image:: img/setup-collateral-connection.png
   :width: 100px

.. figure:: img/setup-collateral-hardware.png
   :width: 180px

   Dash Masternode Tool successful connection confirmations

We will now use DMT to enter some basic information about the masternode
and extract the transaction ID. Carry out the following sequence of
steps as shown in this screenshot:

.. figure:: img/setup-collateral-dmt-steps.png
   :width: 400px

   Dash Masternode Tool configuration steps

#. Click the **New** button.
#. Enter a name for your masternode. The host name you specified 
   for your VPS above is a good choice.
#. Enter the IP address of your masternode. This was given to you
   by the VPS provider when you set up the server. Then enter the TCP 
   port number. This should be 19999.
#. Click **Locate collateral** to view unused collateral funding 
   transactions available on the connected hardware wallet. Select the 
   address to which you sent 1000 Dash and click **Apply**. The 
   **Collateral address**, **path**, **Collateral TX hash** and
   **index** fields should be filled automatically.

.. figure:: img/setup-collateral-dmt-ready.png
   :width: 400px

   Dash Masternode Tool with masternode configuration

Leave DMT open and continue with the next step: :ref:`installing Dash
Core on your VPS <testnet-masternode-setup-install>`.

Option 2: Holding collateral in Dash Core wallet
------------------------------------------------

Open Dash Core wallet and wait for it to synchronize with the network.
It should look like this when ready:

.. figure:: img/setup-collateral-dashcore.png
   :width: 400px

   Fully synchronized Dash Core wallet

Click **Window > Console** to open the console. Type the following
command into the console to generate a new Dash address for the
collateral::

  getnewaddress
  yiFfzbwiN9oneftd7cEfr3kQLRwQ4kp7ue

Take note of the collateral address, since we will need it later.  The
next step is to secure your wallet (if you have not already done so).
First, encrypt the wallet by selecting **Settings > Encrypt wallet**.
You should use a strong, new password that you have never used somewhere
else. Take note of your password and store it somewhere safe or you will
be permanently locked out of your wallet and lose access to your funds.
Next, back up your wallet file by selecting **File > Backup Wallet**.
Save the file to a secure location physically separate to your computer,
since this will be the only way you can access our funds if anything
happens to your computer. For more details on these steps, see
:ref:`here <dashcore-backup>`.

Now send exactly 1000 DASH in a single transaction to the new address
you generated in the previous step. This may be sent from another
wallet, or from funds already held in your current wallet. Once the
transaction is complete, view the transaction in a `blockchain explorer
<https://testnet-insight.dash.org/insight/>`_ by searching for the
address. You will need 15 confirmations before you can register the
masternode, but you can continue with the next step at this point
already: generating your masternode operator key.

.. figure:: img/setup-collateral-blocks.png
   :width: 400px

   Trezor blockchain explorer showing 15 confirmations for collateral
   transfer


.. _testnet-masternode-setup-install:

Masternode Installation
=======================

The following tools are available for installing a Dash masternode:

- :ref:`dashmate installation <testnet-masternode-setup-install-dashmate>`
- :ref:`Manual installation <testnet-masternode-setup-install-manual>`
- `Dash Masternode Zeus <https://github.com/kxcd/Masternode-Zeus>`__ (does not yet support platform services)


.. _testnet-masternode-setup-install-dashmate:

dashmate installation
---------------------

``dashmate`` replaces the `dashman
<https://github.com/moocowmoo/dashman/>`__ masternode installer by
moocowmoo. dashmate is based on Docker technology and
features an interactive setup command and the ability to manage multiple
node configs and multiple networks. It handles the installation of Dash
Core and Tenderdash, as well as all dependencies and supporting
services. Full dashmate documentation is available `here
<https://github.com/dashevo/platform/tree/master/packages/dashmate#readme>`__.

Open PuTTY or a console again and connect using the username and
password you just created for your new, non-root user. Begin by
installing dashmate dependencies::

  curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh
  sudo usermod -aG docker $USER
  newgrp docker
  sudo apt install python3-pip
  sudo pip3 install docker-compose
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  source ~/.bashrc
  nvm install 16

Install dashmate::

  npm install -g dashmate

Run the interactive setup wizard::

  dashmate setup

You will be prompted to select a network, node type, IP address and BLS
private key. Enter this information or accept the detected/generated
defaults. Start your node as follows::

  dashmate start

You can manage your masternode status, configuration, and running state
entirely from within dashmate. See the documentation `here
<https://github.com/dashevo/dashmate#readme>`__ or use the built-in help
system to learn more:

- ``dashmate --help``
- ``dashmate <command> --help``

.. figure:: img/dashmate-status.png
   :width: 280px

   dashmate displaying a range of status output

You can check the status of your masternode using the various ``dashmate
status`` commands as follows::

- dashmate status
- dashmate status core
- dashmate status host
- dashmate status masternode
- dashmate status platform
- dashmate status services

Continue with the :ref:`Registration step <testnet-register-masternode>` to
setup the collateral, keys and construct the ProTx transaction required
to enable your masternode.

.. _testnet-masternode-update:

Masternode Update
-----------------

You can use ``dashmate`` to update minor versions of the software on
your masternode as follows::

  dashmate stop
  dashmate update
  dashmate start

Adding the following ``git`` and ``npm`` commands optionally also
ensures you are using the latest stable version of dashmate::

  dashmate stop
  npm update -g dashmate
  dashmate update
  dashmate start

Adding the following command will drop all data from Dash Platform
(necessary if Platform has been wiped) and restart with the latest
version::

  dashmate stop
  npm update -g dashmate
  dashmate reset --platform-only
  dashmate update
  dashmate start

.. _testnet-register-masternode:

Masternode registration
=======================

DIP003 introduced several changes to how a masternode is set up and
operated. These changes and the three keys required for the different
masternode roles are described briefly under :ref:`dip3-changes` in this
documentation.

Option 1: Registering from a hardware wallet
--------------------------------------------

Go back to DMT and ensure that all fields from the previous step are
still filled out correctly.  Click **Generate new** for the three
private keys required for a DIP003 deterministic masternode:

- Owner private key
- Operator private key (generate new or use private key generated by dashmate)
- Voting private key

.. figure:: img/setup-dmt-full.png
   :width: 220px

   Dash Masternode Tool ready to register a new masternode

Then click **Register masternode**. Optionally specify a different
**Payout address** and/or **Operator reward**, then click **Continue**.
Select **Remote Dash RPC Node (automatic method)**. (See `here <https://github.com/Bertrand256/dash-masternode-tool/blob/master/doc/config-connection-direct.md>`__ 
for documentation on using your own local RPC node.) and confirm the
following two messages:

.. image:: img/setup-dmt-send.png
   :width: 220px

.. figure:: img/setup-dmt-sent.png
   :width: 220px

   Dash Masternode Tool confirmation dialogs to register a masternode

The public key will be used in following steps. The private key must be
entered in the configuration on the masternode. This allows the
masternode to watch the blockchain for relevant Pro*Tx transactions, and
will cause it to start serving as a masternode when the signed ProRegTx
is broadcast by the owner (final step below). If you are using the BLS
key generated by ``dashmate setup``, this information is already configured
for your masternode. If you generated your own BLS key pair, edit the
dashmate configuration as follows::

  dashmate config set core.masternode.operator.privateKey <bls_private_key>
  dashmate restart

At this point you can go back to your terminal window and monitor your
masternode by entering ``dashmate status`` or using the **Get status**
function in DMT.

You can now safely log out of your server by typing ``exit``.
Congratulations! Your masternode is now running.

.. _testnet-dashcore-protx:

Option 2: Registering from Dash Core wallet
-------------------------------------------

Identify the funding transaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you used an address in Dash Core wallet for your collateral
transaction, you now need to find the txid of the transaction. Click
**Window > Console** and enter the following command::

  masternode outputs

This should return a string of characters similar to the following::

  {
  "16347a28f4e5edf39f4dceac60e2327931a25fdee1fb4b94b63eeacf0d5879e3" : "1",
  }

The first long string is your ``collateralHash``, while the last number
is the ``collateralIndex``. 


.. _testnet-bls-generation:

Generate a BLS key pair
^^^^^^^^^^^^^^^^^^^^^^^

A public/private BLS key pair is required to operate a masternode. The
private key is specified on the masternode itself, and allows it to be
included in the deterministic masternode list once a provider
registration transaction with the corresponding public key has been
created.

If you are using a hosting service, they may provide you with their
public key, and you can skip this step. If you are hosting your own
masternode or have agreed to provide your host with the BLS private key,
you can use the BLS key generated by the ``dashmate setup`` command.
Alternatively, you can generate a BLS public/private keypair in Dash
Core by clicking **Window > Console** and entering the following
command::

  bls generate

  {
    "secret": "395555d67d884364f9e37e7e1b29536519b74af2e5ff7b62122e62c2fffab35e",
    "public": "99f20ed1538e28259ff80044982372519a2e6e4cdedb01c96f8f22e755b2b3124fbeebdf6de3587189cf44b3c6e7670e"
  }

**These keys are NOT stored by the wallet or dashmate and must be kept
secure, similar to the value provided in the past by the** ``masternode
genkey`` **command.**

Add the private key to your masternode configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The public key will be used in following steps. The private key must be
entered in the ``dash.conf`` file on the masternode. This allows the
masternode to watch the blockchain for relevant Pro*Tx transactions, and
will cause it to start serving as a masternode when the signed ProRegTx
is broadcast by the owner (final step below). If you are using the BLS
key generated by ``dashmate setup``, this information is already
configured for your masternode. If you generated your own BLS key pair,
edit the dashmate configuration as follows::

  dashmate config set core.masternode.operator.privateKey <bls_private_key>
  dashmate restart

We will now prepare the transaction used to register the masternode on
the network.

Prepare a ProRegTx transaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A pair of BLS keys for the operator were already generated above, and
the private key was entered on the masternode. The public key is used in
this transaction as the ``operatorPubKey``.

First, we need to get a new, unused address from the wallet to serve as
the **owner key address** (``ownerKeyAddr``). This is not the same as
the collateral address holding 1000 Dash. Generate a new address as
follows::

  getnewaddress

  yfgxFhqrdDG15ZWKJAN6dQvn6dZdgBPAip

This address can also be used as the **voting key address**
(``votingKeyAddr``). Alternatively, you can specify an address provided
to you by your chosen voting delegate, or simply generate a new voting
key address as follows::

  getnewaddress

  yfRaZN8c3Erpqj9iKnmQ9QDBeUuRhWV3Mg

Then either generate or choose an existing address to receive the
**owner's masternode payouts** (``payoutAddress``). It is also possible
to use an address external to the wallet::

  getnewaddress

  yjZVt49WsQd6XSrPVAUGXtJccxviH9ZQpN

You can also optionally generate and fund another address as the
**transaction fee source** (``feeSourceAddress``). If you selected an
external payout address, you must specify a fee source address. 

Either the payout address or fee source address must have enough balance
to pay the transaction fee, or the ``register_prepare`` transaction will
fail.

The private keys to the owner and fee source addresses must exist in the
wallet submitting the transaction to the network. If your wallet is
protected by a password, it must now be unlocked to perform the
following commands. Unlock your wallet for 5 minutes::

  walletpassphrase yourSecretPassword 300

We will now prepare an unsigned ProRegTx special transaction using the
``protx register_prepare`` command. This command has the following
syntax::

  protx register_prepare collateralHash collateralIndex ipAndPort ownerKeyAddr 
    operatorPubKey votingKeyAddr operatorReward payoutAddress (feeSourceAddress)

Open a text editor such as notepad to prepare this command. Replace each
argument to the command as follows:

- ``collateralHash``: The txid of the 1000 Dash collateral funding 
  transaction
- ``collateralIndex``: The output index of the 1000 Dash funding 
  transaction
- ``ipAndPort``: Masternode IP address and port, in the format 
  ``x.x.x.x:yyyy``
- ``ownerKeyAddr``: The new Dash address generated above for the 
  owner/voting address
- ``operatorPubKey``: The BLS public key generated above (or provided 
  by your hosting service)
- ``votingKeyAddr``: The new Dash address generated above, or the 
  address of a delegate, used for proposal voting
- ``operatorReward``: The percentage of the block reward allocated to 
  the operator as payment
- ``payoutAddress``: A new or existing Dash address to receive the 
  owner's masternode rewards
- ``feeSourceAddress``: An (optional) address used to fund ProTx fee. 
  ``payoutAddress`` will be used if not specified.

Note that the operator is responsible for :ref:`specifying their own
reward <dip3-update-service>` address in a separate ``update_service``
transaction if you specify a non-zero ``operatorReward``. The owner of
the masternode collateral does not specify the operator's payout
address.

Example (remove line breaks if copying)::

  protx register_prepare 
    16347a28f4e5edf39f4dceac60e2327931a25fdee1fb4b94b63eeacf0d5879e3 
    1 
    45.76.230.239:19999 
    yfgxFhqrdDG15ZWKJAN6dQvn6dZdgBPAip 
    99f20ed1538e28259ff80044982372519a2e6e4cdedb01c96f8f22e755b2b3124fbeebdf6de3587189cf44b3c6e7670e 
    yfRaZN8c3Erpqj9iKnmQ9QDBeUuRhWV3Mg 
    0 
    yjZVt49WsQd6XSrPVAUGXtJccxviH9ZQpN 
    yR83WsikBaBaNusTnHZf28kAcL8oVmp1TE

Output::

  {
    "tx": "030001000175c9d23c2710798ef0788e6a4d609460586a20e91a15f2097f56fc6e007c4f8e0000000000feffffff01a1949800000000001976a91434b09363474b14d02739a327fe76e6ea12deecad88ac00000000d1010000000000e379580dcfea3eb6944bfbe1de5fa2317932e260acce4d9ff3ede5f4287a34160100000000000000000000000000ffff2d4ce6ef4e1fd47babdb9092489c82426623299dde76b9c72d9799f20ed1538e28259ff80044982372519a2e6e4cdedb01c96f8f22e755b2b3124fbeebdf6de3587189cf44b3c6e7670ed1935246865dce1accce6c8691c8466bd67ebf1200001976a914fef33f56f709ba6b08d073932f925afedaa3700488acfdb281e134504145b5f8c7bd7b47fd241f3b7ea1f97ebf382249f601a0187f5300",
    "collateralAddress": "yjSPYvgUiAQ9AFj5tKFA8thFLoLBUxQERb",
    "signMessage": "yjZVt49WsQd6XSrPVAUGXtJccxviH9ZQpN|0|yfgxFhqrdDG15ZWKJAN6dQvn6dZdgBPAip|yfRaZN8c3Erpqj9iKnmQ9QDBeUuRhWV3Mg|ad5f82257bd00a5a1cb5da1a44a6eb8899cf096d3748d68b8ea6d6b10046a28e"
  }

Next we will use the ``collateralAddress`` and ``signMessage`` fields to
sign the transaction, and the output of the ``tx`` field to submit the
transaction.

Sign the ProRegTx transaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We will now sign the content of the ``signMessage`` field using the
private key for the collateral address as specified in
``collateralAddress``. Note that no internet connection is required for
this step, meaning that the wallet can remain disconnected from the
internet in cold storage to sign the message. In this example we will
again use Dash Core, but it is equally possible to use the signing
function of a hardware wallet. The command takes the following syntax::

  signmessage collateralAddress signMessage

Example::

  signmessage yjSPYvgUiAQ9AFj5tKFA8thFLoLBUxQERb yjZVt49WsQd6XSrPVAUGXtJccxviH9ZQpN|0|yfgxFhqrdDG15ZWKJAN6dQvn6dZdgBPAip|yfRaZN8c3Erpqj9iKnmQ9QDBeUuRhWV3Mg|ad5f82257bd00a5a1cb5da1a44a6eb8899cf096d3748d68b8ea6d6b10046a28e

Output::

  II8JvEBMj6I3Ws8wqxh0bXVds6Ny+7h5HAQhqmd5r/0lWBCpsxMJHJT3KBcZ23oUZtsa6gjgISf+a8GzJg1BfEg=


Submit the signed message
^^^^^^^^^^^^^^^^^^^^^^^^^

We will now submit the ProRegTx special transaction to the blockchain to
register the masternode. This command must be sent from a Dash Core
wallet holding a balance on either the ``feeSourceAddress`` or
``payoutAddress``, since a standard transaction fee is involved. The
command takes the following syntax::

  protx register_submit tx sig

Where: 

- ``tx``: The serialized transaction previously returned in the ``tx`` 
  output field from the ``protx register_prepare`` command
- ``sig``: The message signed with the collateral key from the 
  ``signmessage`` command

Example::

  protx register_submit 030001000175c9d23c2710798ef0788e6a4d609460586a20e91a15f2097f56fc6e007c4f8e0000000000feffffff01a1949800000000001976a91434b09363474b14d02739a327fe76e6ea12deecad88ac00000000d1010000000000e379580dcfea3eb6944bfbe1de5fa2317932e260acce4d9ff3ede5f4287a34160100000000000000000000000000ffff2d4ce6ef4e1fd47babdb9092489c82426623299dde76b9c72d9799f20ed1538e28259ff80044982372519a2e6e4cdedb01c96f8f22e755b2b3124fbeebdf6de3587189cf44b3c6e7670ed1935246865dce1accce6c8691c8466bd67ebf1200001976a914fef33f56f709ba6b08d073932f925afedaa3700488acfdb281e134504145b5f8c7bd7b47fd241f3b7ea1f97ebf382249f601a0187f5300 II8JvEBMj6I3Ws8wqxh0bXVds6Ny+7h5HAQhqmd5r/0lWBCpsxMJHJT3KBcZ23oUZtsa6gjgISf+a8GzJg1BfEg=

Output::

  aba8c22f8992d78fd4ff0c94cb19a5c30e62e7587ee43d5285296a4e6e5af062

Your masternode is now registered and will appear on the Deterministic
Masternode List after the transaction is mined to a block. You can view
this list on the **Masternodes -> DIP3 Masternodes** tab of the Dash
Core wallet, or in the console using the command ``protx list valid``,
where the txid of the final ``protx register_submit`` transaction
identifies your masternode.

At this point you can go back to your terminal window and monitor your
masternode by entering ``dashmate status`` or using the **Get status**
function in DMT. 


.. _testnet-masternode-setup-install-manual:

Manual installation
===================

**The manual installation guide is currently a work in progress.**

This guide describes how to manually download and install the components
of your Dash masternode under Ubuntu Linux 22.04 LTS "Jammy Jellyfish"
assuming you have a non-root user named ``dash``. You will need to
manually adjust apt commands if using a different distro.

Core services
-------------

Prepare your environment for installing keys through GPG::

  sudo mkdir -m 600 /root/.gnupg

Dash Core
^^^^^^^^^

Dash Core is a fork of Bitcoin Core and is responsible for all consensus
and communication relating to the base blockchain. Download Dash Core as
follows::

  cd /tmp
  wget https://github.com/dashpay/dash/releases/download/v18.0.0-rc4/dashcore-18.0.0-rc4-$(uname -m)-linux-gnu.tar.gz

Verify the authenticity of your download by checking its detached
signature against the public key published by the Dash Core development
team. All releases of Dash are signed using GPG with one of the
following keys:

- Alexander Block (codablock) with the key ``63A9 6B40 6102 E091``,
  `verifiable here on Keybase <https://keybase.io/codablock>`__
- Pasta (pasta) with the key ``5252 7BED ABE8 7984``, `verifiable here
  on Keybase <https://keybase.io/pasta>`__

::

  curl https://keybase.io/codablock/pgp_keys.asc | gpg --import
  curl https://keybase.io/pasta/pgp_keys.asc | gpg --import
  wget https://github.com/dashpay/dash/releases/download/v18.0.0-rc4/dashcore-18.0.0-rc4-$(uname -m)-linux-gnu.tar.gz.asc
  gpg --verify dashcore-18.0.0-rc4-$(uname -m)-linux-gnu.tar.gz.asc

Extract the compressed archive and copy the necessary files to the
directory::

  tar xfv dashcore-18.0.0-rc4-$(uname -m)-linux-gnu.tar.gz
  sudo install -t /usr/local/bin dashcore-e66d539fa5d1/bin/*

Create a working directory for Dash Core::

  mkdir ~/.dashcore

Configure Dash Core::

  cat<<EOF>~/.dashcore/dash.conf
  #----
  rpcuser=dashrpc
  rpcpassword=password
  rpcallowip=127.0.0.1
  #----
  listen=1
  server=1
  daemon=1
  #----
  txindex=1
  addressindex=1
  timestampindex=1
  spentindex=1
  #----
  zmqpubrawtx=tcp://0.0.0.0:29998
  zmqpubrawtxlock=tcp://0.0.0.0:29998
  zmqpubhashblock=tcp://0.0.0.0:29998
  zmqpubrawchainlock=tcp://0.0.0.0:29998
  #----
  #masternodeblsprivkey=
  externalip=$(curl ifconfig.co)
  proxy=127.0.0.1:9050
  torcontrol=127.0.0.1:9051
  #----
  testnet=1
  
  [test]
  port=19999
  rpcport=19998
  bind=0.0.0.0
  rpcbind=0.0.0.0
  EOF

Optionally replace the ``rpcuser`` and ``rpcpassword`` fields with your
own values. Leave the ``masternodeblsprivkey`` field commented out for
now. Configure Dash Core to start as a service::

  cat << EOF | sudo tee /etc/systemd/system/dashd.service
  [Unit]
  Description=Dash Core
  After=syslog.target network-online.target
  
  [Service]
  Type=forking
  User=dash
  Group=dash
  ExecStart=/usr/local/bin/dashd
  TimeoutStartSec=10m
  ExecStop=/usr/local/bin/dash-cli stop
  SyslogIdentifier=dashd
  TimeoutStopSec=120
  RestartSec=120
  
  [Install]
  WantedBy=multi-user.target
  EOF

Start Dash Core::

  sudo systemctl daemon-reload
  sudo systemctl enable dashd
  sudo systemctl start dashd

Verify Dash Core is running::

  sudo systemctl status dashd

Sentinel
^^^^^^^^

Sentinel is a watchdog and works to communicate to the network that your
node is working properly. Install Sentinel as follows::

  cd
  sudo add-apt-repository ppa:deadsnakes/ppa -y
  sudo apt install -y software-properties-common python3.9 python3.9-venv
  git clone -b master https://github.com/dashpay/sentinel.git
  cd sentinel
  python3.9 -m venv . sentinel
  bin/pip install -r requirements.txt
  bin/python bin/sentinel.py

You will see a message reading **dashd not synced with network! Awaiting
full sync before running Sentinel.** Use the following command to
monitor sync status::

  dash-cli mnsync status

When synchronisation is complete, you should see the following
response::

  {
    "AssetID": 999,
    "AssetName": "MASTERNODE_SYNC_FINISHED",
    "AssetStartTime": 1558596597,
    "Attempt": 0,
    "IsBlockchainSynced": true,
    "IsSynced": true,
    "IsFailed": false
  }

Tor
^^^

Tor is an internet relay system designed to preserve anonymity on the
internet. Install Tor as follows::

  sudo gpg --no-default-keyring --keyring /usr/share/keyrings/tor-archive-keyring.gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
  echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/tor.list
  sudo apt update
  sudo apt install -y tor deb.torproject.org-keyring
  
Platform services
-----------------

Next, we will install the Dash Platform services. Start with some common
dependencies::

  cd
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  source ~/.bashrc
  nvm install 16
  sudo apt install -y libzmq3-dev build-essential cmake libgmp-dev gcc-10 g++-10 apt-transport-https gnupg2 curl lsb-release
  export CC=gcc-10 && export CXX=g++-10
  npm install pm2 -g

Drive
^^^^^

Drive is a replicated state machine for Dash Platform. Download Drive as
follows::

  git clone -b master https://github.com/dashevo/platform/
  cd platform
  corepack enable
  yarn workspaces focus --production @dashevo/drive
  cp packages/js-drive/.env.example packages/js-drive/.env

Configure Drive::

  sed -i 's/^CORE_JSON_RPC_PORT.*/CORE_JSON_RPC_PORT=19998/' packages/js-drive/.env
  sed -i 's/^INITIAL_CORE_CHAINLOCKED_HEIGHT.*/INITIAL_CORE_CHAINLOCKED_HEIGHT=415765/' packages/js-drive/.env
  sed -i 's/^CORE_JSON_RPC_USERNAME.*/CORE_JSON_RPC_USERNAME=dashrpc/' packages/js-drive/.env
  sed -i 's/^CORE_JSON_RPC_PASSWORD.*/CORE_JSON_RPC_PASSWORD=password/' packages/js-drive/.env
  sed -i 's/^DPNS_MASTER_PUBLIC_KEY=.*/DPNS_MASTER_PUBLIC_KEY=022a5ffc9f92e005a02401c375f575b3aed5606fb24ddef5b3a05d55c66ba2a2f6/' packages/js-drive/.env
  sed -i 's/^DASHPAY_MASTER_PUBLIC_KEY=.*/DASHPAY_MASTER_PUBLIC_KEY=02c6bf10f8cc078866ed5466a0b5ea3a4e8db2a764ea5aa9cb75f22658664eb149/' packages/js-drive/.env
  sed -i 's/^FEATURE_FLAGS_MASTER_PUBLIC_KEY=.*/FEATURE_FLAGS_MASTER_PUBLIC_KEY=033d57d03ba602acecfb6fd4ad66c5fdb9a739e163faefa901926bdf28063f9251/' packages/js-drive/.env
  sed -i 's/^MASTERNODE_REWARD_SHARES_MASTER_PUBLIC_KEY=.*/MASTERNODE_REWARD_SHARES_MASTER_PUBLIC_KEY=02182c19827a5e3151feb965b2c6e6bbe57bb1f2fe7579595d76b672966da4e8e6/' packages/js-drive/.env

Start Drive::

  pm2 start yarn --name "drive" -- workspace @dashevo/drive abci

Verify Drive is running by checking for a time value under ``uptime``::

  pm2 list

Tenderdash
^^^^^^^^^^

Tenderdash is a fork of Tendermint and is the blockchain implementation
used by Dash Platform. As binaries are not yet published, you will need
to build from source. Install Go as follows::

  cd /tmp
  wget https://go.dev/dl/go1.18.2.linux-$(dpkg --print-architecture).tar.gz
  sudo tar -C /usr/local -xzf go1.18.2.linux-$(dpkg --print-architecture).tar.gz
  export PATH=$PATH:/usr/local/go/bin

Build and install Tenderdash as follows::

  cd
  git clone -b v0.7.1 https://github.com/dashevo/tenderdash
  cd tenderdash
  make install-bls
  make build-linux
  sudo install -t /usr/local/bin build/*

Initialize Tenderdash::

  tenderdash init

Several files will be generated in the ``~/.tenderdash`` directory.
Modify the configuration with the following commands::

  sed -i 's/\(^moniker.*\)/#\1/' ~/.tenderdash/config/config.toml
  sed -i 's/^timeout_commit.*/timeout_commit = "500ms"/' ~/.tenderdash/config/config.toml
  sed -i 's/^create_empty_blocks_interval.*/create_empty_blocks_interval = "3m"/' ~/.tenderdash/config/config.toml
  sed -i 's/^namespace.*/namespace = "drive_tendermint"/' ~/.tenderdash/config/config.toml
  sed -i 's/^seeds.*/seeds = "74907790a03b51ac062c8a1453dafd72a08668a3@54.189.200.56:26656,2006632eb20e670923d13d4f53abc24468eaad4d@52.43.162.96:26656"/' ~/.tenderdash/config/config.toml
  curl https://gist.githubusercontent.com/strophy/9a564bbc423198a2fdf4e807b7b40bb4/raw/21ad1cdd6112b33a73c032727a096d1563ed0b07/genesis.json > ~/.tenderdash/config/genesis.json

Configure Tenderdash to start as a service::

  cat << EOF | sudo tee /etc/systemd/system/tenderdash.service
  [Unit]
  Description=Tenderdash
  After=syslog.target network-online.target
   
  [Service]
  User=dash
  Group=dash
  TimeoutStartSec=10m
  TimeoutStopSec=120
  RestartSec=120
  ExecStart=/usr/local/bin/tenderdash node
  SyslogIdentifier=tenderdash
   
  [Install]
  WantedBy=multi-user.target
  EOF

Ensure Dash Core is fully synced and start Tenderdash::

  sudo systemctl daemon-reload
  sudo systemctl enable tenderdash
  sudo systemctl start tenderdash

Verify Tenderdash is running::

  sudo systemctl status tenderdash

DAPI
^^^^

DAPI provides masternode services over the JSON RPC and gRPC protocols.
Start DAPI as follows::

  cd ~/platform
  yarn workspaces focus --production @dashevo/dapi
  cp packages/dapi/.env.example packages/dapi/.env

Modify the configuration with the following commands::

  sed -i 's/^API_JSON_RPC_PORT.*/API_JSON_RPC_PORT=3004/' packages/dapi/.env
  sed -i 's/^API_GRPC_PORT.*/API_GRPC_PORT=3005/' packages/dapi/.env
  sed -i 's/^TX_FILTER_STREAM_GRPC_PORT.*/TX_FILTER_STREAM_GRPC_PORT=3006/' packages/dapi/.env
  sed -i 's/^DASHCORE_RPC_PORT.*/DASHCORE_RPC_PORT=19998/' packages/dapi/.env
  sed -i 's/^DASHCORE_ZMQ_PORT.*/DASHCORE_ZMQ_PORT=29998/' packages/dapi/.env
  sed -i 's/^DASHCORE_P2P_PORT.*/DASHCORE_P2P_PORT=19999/' packages/dapi/.env

Start DAPI::

  pm2 start yarn --name "dapi" -- workspace @dashevo/dapi api

Start the transaction filter stream::

  pm2 start yarn --name "dapi" -- workspace @dashevo/dapi core-streams

Envoy
^^^^^

Envoy is a gRPC service proxy for cloud-native applications. Install
Envoy as follows::

  cd
  curl -sL 'https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key' | sudo gpg --dearmor -o /usr/share/keyrings/getenvoy-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/getenvoy-keyring.gpg] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/getenvoy.list
  sudo apt update
  sudo apt install -y getenvoy-envoy

Configure Envoy as follows::

  sudo mkdir /etc/envoy
  curl https://gist.githubusercontent.com/strophy/a6f4f6e30212e7cadcefb65b179c9bce/raw/c8c879de320fc93f5c56793c7bb89acb3165bab9/grpc.yaml | sudo tee /etc/envoy/config.yaml

Configure Envoy to start as a service::

  cat << EOF | sudo tee -a /etc/systemd/system/envoy.service
  [Unit]
  Description=Envoy
  After=syslog.target network-online.target
  
  [Service]
  ExecStart=bash -c '/usr/bin/envoy --config-path /etc/envoy/config.yaml | tee'
  Restart=always
  RestartSec=5
  KillMode=mixed
  SyslogIdentifier=envoy
  
  [Install]
  WantedBy=multi-user.target
  EOF

Start Envoy::
  
  sudo systemctl daemon-reload
  sudo systemctl enable envoy
  sudo systemctl start envoy

Verify Envoy is running::

  sudo systemctl status envoy

Finishing up
------------

Ensure services managed by ``pm2`` start on reboot::

  cat<<"EOF"|crontab
  * * * * * cd ~/sentinel && ./bin/python bin/sentinel.py 2>&1 >> sentinel-cron.log
  @reboot { sleep 5;cd ~/platform&&pm2 start yarn --name "drive" -- workspace @dashevo/drive abci;}
  @reboot { sleep 6;cd ~/platform&&pm2 start yarn --name "dapi" -- workspace @dashevo/dapi api;}
  @reboot { sleep 7;cd ~/platform&&pm2 start yarn --name "dapi" -- workspace @dashevo/dapi core-streams;}
  EOF

At this point you can safely log out of your server by typing ``exit``.
Congratulations! Your masternode is now running.

.. _testnet-masternode-setup-install-dev:

Developer installation
======================

Developers requiring a local masternode can get started quickly by
starting dashmate and providing a private key containing collateral
directly. Install dependencies if necessary (Docker, NodeJS, NPM, Github
CLI). Windows, macOS and Linux are supported, the following example
shows how to install dependencies under Ubuntu 20.04 LTS.::

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  source ~/.bashrc
  nvm install 16
  curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh
  sudo usermod -aG docker $USER
  newgrp docker

Generate a new Dash address for temporary use using `this script
<https://repl.it/@strophy/Generate-Dash-Address>`__ or the
``getnewaddress`` and ``dumpprivkey`` RPC commands in `Dash Core
<https://www.dash.org/downloads>`__ in testnet mode. Go to
https://testnet-faucet.dash.org/ and request 1000+ tDash to your new
address using the promo code 'masternode'. Then download and initialize
dashmate as follows::

  npm install -g dashmate

If you are using Windows, you will need to change the path for two log files.
Modify the example below with a log path of your choosing::

  dashmate config set platform.drive.abci.log.prettyFile.path C:\Users\strophy\Documents\GitHub\dashmate\testnet-drive-pretty.log
  dashmate config set platform.drive.abci.log.jsonFile.path C:\Users\strophy\Documents\GitHub\dashmate\testnet-drive-json.log

Register your masternode on the network as follows::

  dashmate setup testnet masternode -p <funding-private-key>

Wait until sync and registration are complete. Then start the masternode::

  dashmate start

Your masternode is now providing service on the following local ports::

  Core P2P:     19999
  Core RPC:     19998
  Platform P2P: 26656
  Platform RPC: 26657
  DAPI HTTP:    3000
  DAPI gRPC:    3010

Note that platform sync will take some time after core sync is complete.
You can monitor progress with ``dashmate status platform`` or use ``dashmate
--help`` to view other commands.
