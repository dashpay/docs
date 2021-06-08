.. meta::
   :description: Compile Dash Core for Linux, macOS, Windows and Gitian deterministic builds
   :keywords: dash, build, compile, linux, macOS, windows, binary, Gitian, developers

.. _compiling-dash:

===================
Compiling Dash Core 
===================

While Dash offers stable binary builds on the `website
<https://www.dash.org/downloads/>`_ and on `GitHub
<https://github.com/dashpay/dash/releases>`_, and development builds
using `GitLab CI <https://gitlab.com/dashpay/dash/pipelines>`_,  many
users will also be interested in building Dash binaries for themselves.
This process has been greatly simplified with the release of Dash Core
0.13.0, and users who do not required deterministic builds can typically
follow the `generic build notes <https://github.com/dashpay/dash/blob/develop/doc/build-generic.md>`__
available on GitHub to compile or cross-compile Dash for any platform.

The instructions to build Dash Core 0.12.3 or older are available `here
<https://docs.dash.org/en/0.12.3/developers/compiling.html>`__ on a
previous version of this page.

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

This setup has been tested using a clean install of Ubuntu 20.04. Start by
logging in as the "root" user. Create a new user with the following command, replacing ``<username>`` with a
username of your choice::

  adduser <username>

You will be prompted for a password. Enter and confirm using a new password
(different to your root password) and store it in a safe place. You will also
see prompts for user information, but this can be left blank. Once the user has
been created, we will add them to the sudo group so they can perform commands as
root::

  usermod -aG sudo <username>

Install prerequisites
---------------------

While still logged in as root, update the system from the Ubuntu package
repository::

  apt update
  apt upgrade

The system will show a list of upgradable packages. Press **Y** and
**Enter** to install the packages.

Install apt-cacher-ng::

  apt install -y apt-cacher-ng

.. note::
  Select ``No`` when asked ``Allow HTTP tunnels through Apt-Cacher NG?`` during installation.

After installing these updates, reboot the system::

  reboot

Login as <username> and clone required repositories::

  git clone https://github.com/dashpay/dash
  git clone https://github.com/devrandom/gitian-builder
  git clone https://github.com/dashpay/dash-detached-sigs
  git clone https://github.com/dashpay/gitian.sigs

Download the Mac OSX SDK::

  mkdir gitian-builder/inputs
  wget -q -O gitian-builder/inputs/MacOSX10.11.sdk.tar.gz https://bitcoincore.org/depends-sources/sdks/MacOSX10.11.sdk.tar.gz

Prepare gitian
--------------
  
It is only necessary to run this step during the initial setup of your machine::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build
  ./dash/contrib/gitian-build.py --setup <signer> <version>

This will install Docker, but then fail as ``<username>`` will not be part of
the ``docker`` group. Add the user to the docker group and refresh the
environment::

  sudo usermod -aG docker $USER
  newgrp docker

Run the setup a second time to complete setup::

  ./dash/contrib/gitian-build.py --setup <signer> <version>

Build Dash Core
---------------

Run gitian build to create binaries for Linux, Mac, and Windows::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build
  ./dash/contrib/gitian-build.py -b -n -j $(nproc) -m <MB of RAM to use> <signer> <version>

When the build completes, it will put the binaries in a ``dashcore-binaries``
folder. The ``.assert`` files and their signatures will be placed in
``gitian.sigs/<version>/<signer>/...``.

Create signatures for signed binaries
-------------------------------------

Mac and Windows binaries are signed by Dash Core Group using the relevant
Apple/Microsoft processes. In this step, that information will be validated and
signed by your machine. The associated ``.assert`` files and their signatures
will be placed in ``gitian.sigs/<version>/<signer>/...`` along with the
previously created signatures.

::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build
  ./dash/contrib/gitian-build.py -s -n -j $(nproc) -m <MB of RAM to use> -o mw <signer> <version> 

Verify signatures
-----------------

The `gitian.sigs repository <https://github.com/dashpay/gitian.sigs/>`_ contains
deterministic build results signed by multiple Core developers for each release.
Run the following command to verify that your build matches the official
release::

  ./dash/contrib/gitian-build.py -v <signer> <version>

You should get a result similar to the following for Linux, Windows, MacOS,
Signed Windows, and Signed MacOS. Assuming the previous steps completed
successfully, you will also see your own signatures with an ``OK`` status also.

::

  Verifying v0.17.0.2 Linux

  gpg: Signature made Tue 18 May 2021 10:59:02 PM EDT
  gpg:                using RSA key 29590362EC878A81FD3C202B52527BEDABE87984
  gpg: Good signature from "Pasta <pasta@dashboost.org>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 2959 0362 EC87 8A81 FD3C  202B 5252 7BED ABE8 7984
  pasta: OK

  gpg: Signature made Tue 18 May 2021 10:23:19 PM EDT
  gpg:                using RSA key CF9A554A36B7950BB648A15DA0078C72B1777616
  gpg:                issuer "xdustinfacex@gmail.com"
  gpg: Good signature from "Dustinface <xdustinfacex@gmail.com>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: CF9A 554A 36B7 950B B648  A15D A007 8C72 B177 7616
  dustinface: OK

  gpg: Signature made Wed 19 May 2021 06:48:36 AM EDT
  gpg:                using RSA key 3F5D48C9F00293CD365A3A9883592BD1400D58D9
  gpg: Good signature from "UdjinM6 <UdjinM6@dash.org>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@dashpay.io>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@gmail.com>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 3F5D 48C9 F002 93CD 365A  3A98 8359 2BD1 400D 58D9
  UdjinM6: OK
