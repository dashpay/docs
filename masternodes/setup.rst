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
