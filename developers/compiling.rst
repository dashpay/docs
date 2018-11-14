.. meta::
   :description: Compile Dash Core for Linux, macOS, Windows and Gitian deterministic builds
   :keywords: dash, build, compile, linux, Jenkins, macOS, windows, binary, Gitian, developers

.. _compiling-dash:

===================
Compiling Dash Core 
===================

While Dash offers stable binary builds on the `website
<https://www.dash.org/wallets>`_ and on `GitHub
<https://github.com/dashpay/dash/releases>`_, and development builds
using `Jenkins <https://jenkins.dash.org/blue/organizations/jenkins/dashpay-dash-gitian-nightly/activity/>`_,
many users will also be interested in building Dash binaries for
themselves. The following guides are available:

- :ref:`Building on Linux <linux-build>`
- :ref:`Building on macOS <macos-build>`
- :ref:`Building on Windows <windows-build>`
- :ref:`Gitian deterministic builds <gitian-build>`

These guides describe how to build the current stable version. To build
the latest version from the develop branch, replace the normal ``git
clone`` command with the following command when pulling from GitHub::

  git clone https://github.com/dashpay/dash.git -b develop

.. _linux-build:

Linux
=====

This guide describes how to build Dash Core wallet without the GUI from
source under Ubuntu Linux. For a more detailed guide, see the `Unix
Build Notes <https://github.com/dashpay/dash/blob/master/doc/build-unix.md>`__. 
The content on this page is intended to serve as a simple guide for
general compilation of non-deterministic binary files from the stable
source code. A standard installation of Ubuntu Linux 18.04 LTS will be
used as an environment for the build. We assume you are running as a
user with sudo permissions. First add the necessary extra repository and
update all packages::

  sudo add-apt-repository ppa:bitcoin/bitcoin
  sudo apt update
  sudo apt upgrade

Now install the dependencies as described in the installation
documentation::

  sudo apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git libdb4.8-dev libdb4.8++-dev curl
  sudo apt install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libzmq3-dev

Optionally install the Qt dependencies if you want to build the Dash 
GUI::

  sudo apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

Download the stable Dash repository::

  git clone https://github.com/dashpay/dash.git

And build::

  cd dash
  ./autogen.sh
  ./configure
  make
  make install

``/usr/local/bin`` now contains the compiled Dash binaries.

.. _macos-build:

macOS
=====

Dash can be built for macOS either using a
cross-compiler under Linux or natively under macOS.

Linux cross-compile
-------------------

This guide describes how to build Dash Core wallet from source under
Ubuntu Linux. It is intended to serve as a simple guide for general
compilation of non-deterministic binary files from the stable source
code. For a more detailed guide, see the `macOS Build Notes
<https://github.com/dashpay/dash/blob/master/doc/build-osx.md>`__. A
standard installation of Ubuntu Linux 18.04 LTS will be used as an
environment for the build. We assume you are running as a user with sudo
permissions. First add the necessary extra repository and update all
packages::

  sudo add-apt-repository ppa:bitcoin/bitcoin
  sudo apt update
  sudo apt upgrade

Now install the dependencies as described in the installation
documentation::

  sudo apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git libdb4.8-dev libdb4.8++-dev curl
  sudo apt install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libzmq3-dev
  sudo apt install ca-certificates curl g++ git-core pkg-config autoconf librsvg2-bin libtiff-tools libtool automake faketime bsdmainutils cmake imagemagick libcap-dev libz-dev libbz2-dev python python-dev python-setuptools fonts-tuffy p7zip-full sleuthkit

Optionally install the Qt dependencies if you want to build the Dash 
GUI::

  sudo apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

Download the stable Dash repository::

  git clone https://github.com/dashpay/dash.git
  cd dash

A copy of the macOS SDK is required during the build process. To
download this, use a Google Chrome in a desktop environment to go to
https://appleid.apple.com and create or sign in to your Apple account.
Then go to https://developer.apple.com and open the Chrome Developer
Tools from the **Menu -> More tools -> Developer tools**. Click on the
**Network** tab, then go back to your main browser window and copy in
the following URL::

  https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg

Cancel the download as soon as it begins and go back to your the
**Network** tab in the developer tools. Right click on the network
request at the bottom of the list labeled **Xcode_7.3.1.dmg** and select
**Copy -> Copy as cURL (bash)**. Paste this long string of text into
your Linux terminal, append ``-o Xcode_7.3.1.dmg`` at the end and then
press enter to begin the download. Once it is complete, extract the
required files from the disc image as follows::

  contrib/macdeploy/extract-osx-sdk.sh
  rm -rf 5.hfs MacOSX10.11.sdk
  mkdir depends/SDKs
  mv MacOSX10.11.sdk/ depends/SDKs/

And build::

  make -C depends HOST=x86_64-apple-darwin11
  ./autogen.sh
  ./configure --prefix=`pwd`/depends/x86_64-apple-darwin11
  make

``~/dash/src`` now contains the compiled Dash binaries, and
``~/dash/src/qt`` contains the Dash GUI wallet.


macOS Native
------------

This guide describes how to build Dash Core wallet from source under
macOS. It is intended to serve as a simple guide for general compilation
of non-deterministic binary files from the stable source code. For a
more detailed guide, see the `macOS Build Notes
<https://github.com/dashpay/dash/blob/master/doc/build-osx.md>`__. A
standard installation of macOS 10.13 High Sierra will be used as an
environment for the build. We assume you are running as a user with sudo
permissions. First, open a the **Terminal** app and enter the following
command to install the OS X command line tools::

  xcode-select --install

When the popup appears, click **Install**. Then install `Homebrew
<https://brew.sh>`__::

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install dependencies::

  brew install automake berkeley-db4 libtool boost --c++11 miniupnpc openssl pkg-config protobuf qt libevent librsvg

Clone the Dash Core source code and change to the ``dash`` directory::

  git clone https://github.com/dashpay/dash
  cd dash

Build Dash Core. Configure and build the headless dash binaries as well
as the GUI (if Qt is found). You can disable the GUI build by passing
``--without-gui`` to configure::

  ./autogen.sh
  ./configure
  make

It is recommended to build and run the unit tests::

  make check

You can also create a ``.dmg`` that contains the ``.app`` bundle
(optional)::

  make deploy

Dash Core is now available at ``./src/dashd``.

.. _windows-build:

Windows
=======

This guide describes how to build Dash Core wallet from source for
64-bit Windows. Most developers use cross-compilation from Linux to
build executables for Windows. The content on this page is intended to
serve as a simple guide for general compilation of non-deterministic
binary files from the stable source code. For a more detailed guide, see
the `Windows Build Notes
<https://github.com/dashpay/dash/blob/master/doc/build-windows.md>`__.
A standard installation of Ubuntu Linux 18.04 LTS will be used as an
environment for the build. We assume you are running as a user with sudo
permissions. First add the necessary extra repository and update all
packages::

  sudo add-apt-repository ppa:bitcoin/bitcoin
  sudo apt update
  sudo apt upgrade

Now install the dependencies as described in the installation
documentation::

  sudo apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git libdb4.8-dev libdb4.8++-dev curl
  sudo apt install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libzmq3-dev
  sudo apt-get install g++-mingw-w64-x86-64 mingw-w64-x86-64-dev

Optionally install the Qt dependencies if you want to build the Dash 
GUI::

  sudo apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

Download the stable Dash repository::

  git clone https://github.com/dashpay/dash.git

Build and link the depends system::

  cd dash/depends
  make HOST=x86_64-w64-mingw32
  cd ..
  sudo update-alternatives --set x86_64-w64-mingw32-gcc  /usr/bin/x86_64-w64-mingw32-gcc-posix
  sudo update-alternatives --set x86_64-w64-mingw32-g++  /usr/bin/x86_64-w64-mingw32-g++-posix

And build::

  ./autogen.sh
  CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/
  make

``~/dash/src`` now contains the compiled Dash binaries, and
``~/dash/src/qt`` contains the Dash GUI wallet.

.. _gitian-build:

Gitian
======

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
--------------------------

Gitian builds are known to be working on Debian 8.x. If your machine is
already running this system, you can perform Gitian builds on the actual
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
----------------------------------

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
according to `these instructions <https://github.com/dashpay/dash/blob/master/doc/build-osx.md>`_). This can take some time. When
complete, you will see the SHA256 checksums, which you can compare
against the hashes available on the `Dash website
<https://www.dash.org/wallets>`_. In this way, you can be sure that you
are running original and untampered builds of the code as it exists on
GitHub.
