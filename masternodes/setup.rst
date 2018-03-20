.. _masternode_setup:

=====
Setup
=====

Setting up a masternode requires a basic understanding of Linux and
blockchain technology, as well as an ability to follow instructions
closely. It also requires regular maintenance and careful security,
particularly if you are not storing your Dash on a hardware wallet.
There are some decisions to be made along the way, and optional extra
steps to take for increased security.

If you prefer to use a masternode hosting service, several community
members provide hosting at `masternode.me <https://masternode.me/>`_,
`node40.com <https://www.node40.com/hosting/>`_, `dashmasternode.io
<http://dashmasternode.io/>`_ or `masternodehosting
<https://masternodehosting.com/>`_. When using these hosting services,
all you have to do is send a single transaction of 1000 DASH to a
specific address and communicate the transaction ID to the hosting
service. Simply follow the steps here.

This guide is heavily based on previous guides written by `Bertrand256
<https://github.com/Bertrand256/dash-masternode-
tool/blob/master/README.md>`_, `moocowmoo
<https://github.com/moocowmoo/dashman/blob/master/README.md>`_, `tao
<https://www.dash.org/forum/threads/taos-masternode-setup-guide-for-
dummies-updated-for-12-1.2680/>`_, `BolehVPN
<https://dashpay.atlassian.net/wiki/spaces/DOC/pages/24019061>`_ and
tungfa. Tao's hugely popular original guide and support thread is
available `here <https://www.dash.org/forum/threads/taos-masternode-
setup-guide-for-dummies-updated-for-12-1.2680/>`_, as well many more
guides for specific cases in this forum.

Before you begin
================

This guide assumes you are setting up a masternode for the first time.
If you are updating a masternode, see :ref:`here <masternode_update>`
instead. You will need:

- 1000 Dash
- A wallet to store your Dash, either a hardware wallet or Dash Core 
  wallet
- A Linux server, preferably a Virtual Private Server (VPS)

This guide also assumes you will be working from a Windows computer.
However, since most of the work is done on your Linux VPS, alternative
steps for using macOS or Linux will be indicated where necessary.

Set up your VPS
===============

A VPS, more commonly known as a cloud server, is fully functional
installation of an operating system (usually Linux) operating within a
virtual machine. The virtual machine allows the VPS provider to run
multiple systems on one physical server, making it more efficient and
much cheaper than having a single operating system running on the "bare
metal " of each server. A VPS is ideal for hosting a Dash masternode
because they typically offer guaranteed uptime, redundancy in the case
of hardware failure and a static IP address that is required to ensure
you remain in the masternode payment queue. While running a masternode
from home on a desktop computer is technically possible, it will most
likely not work reliably because most ISPs allocate dynamic IP addresses
to home users.

We will use `Vultr <https://www.vultr.com/>`_ hosting as an example of a
VPS, although `DigitalOcean <https://www.digitalocean.com/>`_, `Amazon
EC2 <https://aws.amazon.com/ec2>`_, `Google Cloud
<https://cloud.google.com/compute/>`_, `Choopa
<https://www.choopa.com/>`_ and `OVH <https://www.ovh.com/>`_ are also
popular choices. First create an account and add credit. Then go to the
Servers menu item on the left and click + to add a new server. Select a
location for your new server on the following screen:

.. figure:: img/setup-server-location.png
   :width: 400px

   Vultr server location selection screen

Select Ubuntu 16.04 x64 as the server type. We use 16.04 instead of the
latest version because 16.04 is an LTS release of Ubuntu, which will be
supported with security updates for 5 years instead of the usual 9
months.

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
server. Go to the PuTTY download page here and select the appropriate
MSI installer for your system. On Mac or Linux you can ssh directly from
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
window. Begin by logging in to your server with the user ``root`` and
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
group so they can perform commands as root::

  usermod -aG sudo <username>

Now, while still as root, we will update the system from the Ubuntu
package repository::

  apt update
  apt upgrade

The system will show a list of upgradable packages. Press **Y** and
**Enter** to install the packages. We will now install a firewall (and
some other packages we will use later), add swap memory and reboot the
server to apply any necessary kernel updates, and then login to our
newly secured environment as the new user::

  apt install ufw python virtualenv git unzip pv

(press **Y** and **Enter** to confirm)

::

  ufw allow ssh/tcp
  ufw limit ssh/tcp
  ufw allow 9999/tcp
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

Then reboot the server:

::

  reboot now

PuTTY will disconnect when the server reboots.

While this setup includes basic steps to protect your server against
attacks, much more can be done. In particular, `authenticating with a
public key <https://help.ubuntu.com/community/SSH/OpenSSH/Keys>`_
instead of a username/password combination, `installing fail2ban
<https://www.linode.com/docs/security/using-fail2ban-for-security>`_ to
block login brute force attacks, `disabling root login
<https://help.ubuntu.com/lts/serverguide/user-management.html>`_ and
`enabling automatic security updates
<https://help.ubuntu.com/community/AutomaticSecurityUpdates>`_ is
advisable. More tips are available `here <https://www.cyberciti.biz/tips
/linux-security.html>`_. However, since the masternode does not actually
store the keys to any Dash, these steps are considered beyong the scope
of this guide.
