.. _dashcore-advanced:

===============
Advanced topics
===============

.. _compiling-dash:

Compiling Dash Core
===================

While Dash offers stable binary builds on the `website
<https://www.dash.org/wallets>`_, on `Github
<https://github.com/dashpay/dash/releases>`_ and through development
builds using `Bamboo <https://bamboo.dash.org>`_, many users will also
be interested in building Dash binaries for themselves. The following
guides are available:

- Eclipse (coming soon)
- :ref:`Building on Linux <linux-build>`
- :ref:`Gitian deterministic builds <gitian-build>`

.. _linux-build:

Linux
-----

This guide describes how to build Dash Core wallet without the GUI from
source under Ubuntu Linux. It is intended to serve as a simple guide for
general compilation of non-deterministic binary files from the stable
source code. A standard installation of Ubuntu Linux 16.04 LTS running
on a VPS will be used as an environment for the build. We assume you are
running as root. First add the necessary extra repository and update all
packages::

	add-apt-repository ppa:bitcoin/bitcoin
	apt update
	apt upgrade

Now install the dependencies as described in the installation
documentation::

	apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git libdb4.8-dev libdb4.8++-dev
	apt install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

Download the stable Dash repository::

  git clone https://github.com/dashpay/dash.git

And build::

	cd dash
	./autogen.sh
	./configure
	make
	make install

``/usr/local/bin`` now contains the compiled Dash binaries.

.. _gitian-build:

Gitian
------

Gitian is the deterministic build process that is used to build the Dash
Core executables. It provides a way to be reasonably sure that the
executables are really built from the source on GitHub. It also makes
sure that the same, tested dependencies are used and statically built
into the executable. Multiple developers build the source code by
following a specific descriptor ("recipe"), cryptographically sign the
result, and upload the resulting signature. These results are compared
and only if they match, the build is accepted and uploaded to dash.org.

More independent Gitian builders are needed, which is why this guide
exists. It is preferred you follow these steps yourself instead of using
someone else's VM image to avoid 'contaminating' the build.

Setup the host environment
^^^^^^^^^^^^^^^^^^^^^^^^^^

Gitian builds are known to be working on Debian 8.x. If your machine is
already running this sytem, you can perform Gitian builds on the actual
hardware. Alternatively, you can install it in a virtual machine. Follow
the guide for :ref:`setting up a VPS for masternodes <vps-setup>`,
selecting a Debian 8.x image during the installation process and naming
your non-root user ``gitianuser``. Selecting a VPS with two processors
will also greatly speed up the build process. If you cannot login to
your VPS over SSH as root, access the terminal and issue the following
command::

	sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
	/etc/init.d/ssh restart

Log in to your new environment by SSH as root. Set up the dependencies
first by pasting the following in the terminal::

	apt-get install git ruby sudo apt-cacher-ng qemu-utils debootstrap lxc python-cheetah parted kpartx bridge-utils make ubuntu-archive-keyring curl
	adduser gitianuser sudo

Then set up LXC and the rest with the following, which is a complex
jumble of settings and workarounds::

	# the version of lxc-start in Debian needs to run as root, so make sure
	# that the build script can execute it without providing a password
	echo "%sudo ALL=NOPASSWD: /usr/bin/lxc-start" > /etc/sudoers.d/gitian-lxc
	echo "%sudo ALL=NOPASSWD: /usr/bin/lxc-execute" >> /etc/sudoers.d/gitian-lxc
	# make /etc/rc.local script that sets up bridge between guest and host
	echo '#!/bin/sh -e' > /etc/rc.local
	echo 'brctl addbr br0' >> /etc/rc.local
	echo 'ifconfig br0 10.0.3.2/24 up' >> /etc/rc.local
	echo 'iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE' >> /etc/rc.local
	echo 'echo 1 > /proc/sys/net/ipv4/ip_forward' >> /etc/rc.local
	echo 'exit 0' >> /etc/rc.local
	# make sure that USE_LXC is always set when logging in as gitianuser,
	# and configure LXC IP addresses
	echo 'export USE_LXC=1' >> /home/gitianuser/.profile
	echo 'export GITIAN_HOST_IP=10.0.3.2' >> /home/gitianuser/.profile
	echo 'export LXC_GUEST_IP=10.0.3.5' >> /home/gitianuser/.profile
	reboot

At the end Debian is rebooted to make sure that the changes take effect.
Re-login as the user gitianuser that was created during installation.
The rest of the steps in this guide will be performed as that user.

There is no ``python-vm-builder`` package in Debian, so we need to
install it from source ourselves::

	wget http://archive.ubuntu.com/ubuntu/pool/universe/v/vm-builder/vm-builder_0.12.4+bzr494.orig.tar.gz
	echo "76cbf8c52c391160b2641e7120dbade5afded713afaa6032f733a261f13e6a8e  vm-builder_0.12.4+bzr494.orig.tar.gz" | sha256sum -c
	# (verification -- must return OK)
	tar -zxvf vm-builder_0.12.4+bzr494.orig.tar.gz
	cd vm-builder-0.12.4+bzr494
	sudo python setup.py install
	cd ..

Set up the environment and compile
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Clone the Dash Core repository to your home directory::

  git clone https://github.com/dashpay/dash.git

Then create the script file::

  nano dash/contrib/gitian-build.sh

And paste the following script in place (this will be automatic if/when
the script is pulled into Dash Core)::

  https://github.com/strophy/dash/blob/master/contrib/gitian-build.sh

Save the file and set it executable::

  sudo chmod +x dash/contrib/gitian-build.sh

Set up the environment, replacing the name and version with your name
and target version::

  dash/contrib/gitian-build.sh --setup strophy 0.12.1.5

Run the compilation script::

  dash/contrib/gitian-build.sh --build strophy 0.12.1.5

Your system will build all dependencies and Dash Core from scratch for
Windows and Linux platforms (macOS if the dependencies were installed
according to these instructions). This can take some time. When
complete, you will see the SHA256 checksums, which you can compare
against the hashes available on the Dash website `here
<https://www.dash.org/wallets>`_. In this way, you can be sure that you
are running original and untampered builds of the code as it exists on
Github.
