.. meta::
   :description: Compile Dash Core for Linux, macOS, Windows and Guix deterministic builds
   :keywords: dash, build, compile, linux, macOS, windows, binary, guix, developers

.. _compiling-dash:

===================
Compiling Dash Core 
===================

While Dash offers stable binary builds on the `website
<https://www.dash.org/downloads/>`_ and on `GitHub
<https://github.com/dashpay/dash/releases>`__, and development builds using
`GitLab CI <https://gitlab.com/dashpay/dash/pipelines>`_,  many users will also
be interested in building Dash binaries for themselves. Users who do not
required deterministic builds can typically follow the `generic build notes
<https://github.com/dashpay/dash/tree/develop/doc#building>`__ available
on GitHub to compile or cross-compile Dash for any platform.


.. _guix-build:

Guix
====

`Guix <https://guix.gnu.org/>`__ is the deterministic build process that is used to
build the Dash Core executables. It provides a way to be reasonably sure that
the executables are really built from the source on GitHub. It also makes sure
that the same, tested dependencies are used and statically built into the
executable. Multiple developers build the source code by following a specific
descriptor ("recipe"), cryptographically sign the result, and upload the
resulting signature. These results are compared and only if they match, the
build is accepted and uploaded to dash.org.

The instructions to build Dash Core 19.0 or older versions using gitian are
available in a `previous version of this page
<https://docs.dash.org/en/19.0.0/docs/user/developers/compiling.html#gitian>`__.

Build process
=============

.. note::
  This setup has been tested using a clean install of Ubuntu 22.04. For maximum
  compatibility, please use that version.

Start by logging in as the "root" user.

Install prerequisites
---------------------

While still logged in as root, update the system from the Ubuntu package
repository::

  apt update
  apt upgrade -y

Install the required build tools::

  apt-get install build-essential

Clone the Dash repository::

  git clone https://github.com/dashpay/dash

Download the macOS SDK which is required to create macOS builds::

  mkdir -p ~/guix-dash/macOS-SDKs
  wget -N -P ~/guix-dash https://bitcoincore.org/depends-sources/sdks/Xcode-12.2-12B45b-extracted-SDK-with-libcxx-headers.tar.gz
  tar -xvzf ~/guix-dash/Xcode-12.2-12B45b-extracted-SDK-with-libcxx-headers.tar.gz --directory ~/guix-dash/macOS-SDKs/

Prepare guix
------------

It is only necessary to run this step during the initial setup of your machine.
Run the guix install routine to prepare your environment::

  cd /tmp
  wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh
  chmod +x guix-install.sh
  ./guix-install.sh

Build Dash Core
---------------

Checkout the tag associated with the Dash Core version you plan to build::

  # <version> = Dash Core tag to build
  # Example: git checkout v20.0.3
  cd ~/dash
  git checkout v20.0.3

Run guix-build to create binaries for Linux, Mac, and Windows::

  # Example: Build binaries for all OSes
  SDK_PATH="$HOME/guix-dash/macOS-SDKs" ./contrib/guix/guix-build

When the build completes, it will put the binaries in the
``guix-build-<version>/output/`` directory.

Create signatures for binaries
==============================

Mac and Windows binaries are signed by Dash Core Group using the relevant Apple
and Microsoft processes. In this step, that information will be validated and
signed by your machine. 

Clone the signature-related repositories if you haven't done so previously::

  cd ~
  git clone https://github.com/dashpay/guix.sigs
  git clone https://github.com/dashpay/dash-detached-sigs


Prepare the `detached sigs repository <https://github.com/dashpay/dash-detached-sigs>`__::

  cd ~/dash-detached-sigs/
  git checkout master
  git pull
  # Checkout the branch for the version being built
  # Example: git checkout v20.0.3
  git checkout v<version>

Unsigned binaries
-----------------

To create signatures for the unsigned binaries, run guix-attest::

  # <signer> = The name associated with your PGP key
  # Example: env GUIX_SIGS_REPO=../guix.sigs SIGNER=alice ./contrib/guix/guix-attest
  cd ~/dash
  env GUIX_SIGS_REPO=../guix.sigs SIGNER=<signer> ./contrib/guix/guix-attest

.. note::
  The ``signer`` parameter should be set to the value provided for "Real name"
  when generating a key with GPG. See the `GnuPrivacyGuard Howto
  <https://help.ubuntu.com/community/GnuPrivacyGuardHowto#Generating_an_OpenPGP_Key>`_
  for details on how to generate a key if you don't already have one.

Signed binaries
---------------

To create signatures for the signed binaries, run guix-codesign followed by
guix-attest::

  env DETACHED_SIGS_REPO=../dash-detached-sigs ./contrib/guix/guix-codesign

::

  # <signer> = The name associated with your PGP key
  # Example: env GUIX_SIGS_REPO=../guix.sigs SIGNER=alice ./contrib/guix/guix-attest
  env GUIX_SIGS_REPO=../guix.sigs SIGNER=<signer> ./contrib/guix/guix-attest
  
Upload signatures
=================

After successfully building the binaries, signing them, and verifying the
signatures, you can optionally contribute them to the `guix.sigs repository
<https://github.com/dashpay/guix.sigs/>`_ via a pull request on GitHub.

Initial setup
-------------

Since the official guix.sigs repository has restricted write access, create a
fork of it via GitHub and add your fork as a remote repository::

  git remote add me https://github.com/<your GitHub username>/guix.sigs

The first time you contribute signatures, also put a copy of your public key in
the ``builder-keys`` folder of the repository so others can easily verify your
signature. Your public key can be exported to a file using the following
command::

  # <signer> = The name associated with your PGP key
  # Example: gpg --output alice.pgp --armor --export alice
  gpg --output <signer>.pgp --armor --export <signer>


Adding your signatures
----------------------

Prepare the `guix.sigs repository <https://github.com/dashpay/guix.sigs>`__ by
pulling the latest changes::

  cd ~/guix.sigs/
  git checkout master
  git pull

Create a new branch for the version that was built::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build (exclude the leading "v")
  # Example: git checkout -b 20.0.3-alice
  git checkout -b <version>-<signer>

Add and commit the ``*.SHA256SUMS`` and ``*.SHA256SUMS.asc`` files created by the build
process::
  
  # Example: git add 20.0.3
  git add <version>

::

  # Example: git commit -m "chore: add guix signatures for alice for 20.0.3"
  git commit -m "chore: add guix signatures for <signer> for <version>"

Push to your fork of the guix.sigs repository on GitHub::

  # "me" references the name of the remote repository added during initial setup
  git push me

Go to `GitHub <https://github.com/dashpay/gitian.sigs/pulls>`__ and open a pull
request to the ``master`` branch of the upstream repository. The pull request
will be reviewed by Dash Core developers and merged if everything checks out.
Thanks for contributing!

.. _gitian-build:

Gitian
======

.. warning::
  Gitian builds were deprecated in favor of Guix builds with the release of
  Dash Core v20.0. The documentation below has been retained for historical
  reference only.

Gitian is the deterministic build process that is used to build the Dash Core
executables. It provides a way to be reasonably sure that the executables are
really built from the source on GitHub. It also makes sure that the same, tested
dependencies are used and statically built into the executable. Multiple
developers build the source code by following a specific descriptor ("recipe"),
cryptographically sign the result, and upload the resulting signature. These
results are compared and only if they match, the build is accepted and uploaded
to dash.org.

Build process
=============

.. note::
  This setup has been tested using a clean install of Ubuntu 20.04. For maximum
  compatibility, please use that version.

Start by logging in as the "root" user. Create a new user with the following
command, replacing ``<username>`` with a username of your choice::

  adduser <username>

You will be prompted for a password. Enter and confirm using a new password
(different to your root password) and store it in a safe place. You will also
see prompts for user information, but this can be left blank. Alternatively, an
existing user can be used on systems that are already in use (e.g. your existing
development system).

Create a ``docker`` group on the system. This group will be used by Docker
processes and also will enable non-root users to run the Docker commands used by
the build process::

  groupadd docker

Add the user to the sudo and docker groups so they can perform commands as
root and run docker commands::

  usermod -aG sudo,docker <username>

Install prerequisites
---------------------

While still logged in as root, update the system from the Ubuntu package
repository::

  apt update
  apt upgrade -y

Install apt-cacher-ng::

  apt install -y apt-cacher-ng

.. note::
  Select ``No`` when asked ``Allow HTTP tunnels through Apt-Cacher NG?`` during
  installation.

  Note: you may also need to open port 3142 if you have a firewall enabled on
  your system (e.g. ``ufw allow 3142/tcp``).

After installing these updates, reboot the system, login as ``<username>``, and
clone required repositories::

  git clone https://github.com/dashpay/dash
  git clone https://github.com/devrandom/gitian-builder
  git clone https://github.com/dashpay/dash-detached-sigs
  git clone https://github.com/dashpay/gitian.sigs

Download the Mac OSX SDK::

  mkdir gitian-builder/inputs
  wget -q -O gitian-builder/inputs/MacOSX10.11.sdk.tar.gz https://bitcoincore.org/depends-sources/sdks/MacOSX10.11.sdk.tar.gz

Prepare gitian
--------------

It is only necessary to run this step during the initial setup of your machine.
Checkout the tag associated with the Dash Core version you plan to build::

  # <version> = Dash Core tag to build
  # Example: git checkout v0.17.0.0
  cd dash
  git checkout <version>
  cd ..

Run the gitian-build setup routine to prepare your environment::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build (exclude the leading "v")
  # Example: ./dash/contrib/gitian-build.py --setup alice 0.17.0.3
  ./dash/contrib/gitian-build.py --setup <signer> <version>

.. note::
  The ``signer`` parameter should be set to the value provided for "Real name"
  when generating a key with GPG. See the `GnuPrivacyGuard Howto
  <https://help.ubuntu.com/community/GnuPrivacyGuardHowto#Generating_an_OpenPGP_Key>`_
  for details on how to generate a key if you don't already have one.

Build Dash Core
---------------

Run gitian build to create binaries for Linux, Mac, and Windows::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build (exclude the leading "v")
  # Example: Build binaries for all OSes, use all available cores and 16 GB RAM
  #   ./dash/contrib/gitian-build.py -b -n -j $(nproc) -m 16000 alice 0.17.0.3
  ./dash/contrib/gitian-build.py -b -n -j $(nproc) -m <MB of RAM to use> <signer> <version>

.. warning::
  These instructions assume that a PGP key for <signer> exists on the build
  system. If the expected key is not found, the script will fail at the signing
  step with a message including::

    gpg: skipped "<signer>": No secret key
    gpg: signing failed: No secret key

When the build completes, it will put the binaries in a ``dashcore-binaries``
folder. The ``.assert`` files and their signatures will be placed in
``gitian.sigs/<version>/<signer>/...``.

Create signatures for signed binaries
-------------------------------------

Mac and Windows binaries are signed by Dash Core Group using the relevant
Apple/Microsoft processes. In this step, that information will be validated and
signed by your machine. The associated ``.assert`` files and their signatures
will be placed in ``gitian.sigs/<version>/<signer>/...`` along with the
signatures for unsigned binaries created in the previous step.

::

  # <signer> = The name associated with your PGP key
  # <version> = Dash Core tag to build (exclude the leading "v")
  # Example: ./dash/contrib/gitian-build.py -s -n -j $(nproc) -m 16000 -o mw alice 0.17.0.3
  ./dash/contrib/gitian-build.py -s -n -j $(nproc) -m <MB of RAM to use> -o mw <signer> <version> 

Verify signatures
=================

The `gitian.sigs repository <https://github.com/dashpay/gitian.sigs/>`_ contains
deterministic build results signed by multiple Core developers for each release.
Run the following command to verify that your build matches the official
release::

  # Example: ./dash/contrib/gitian-build.py -v alice 0.17.0.3
  ./dash/contrib/gitian-build.py -v <signer> <version>

You should get a result similar to the following for Linux, Windows, MacOS,
Signed Windows, and Signed MacOS. Assuming the previous steps completed
successfully, you will also see your own signatures with an ``OK`` status also.

::

  Verifying v0.17.0.3 Linux

  gpg: Signature made Sun 06 Jun 2021 12:46:44 PM EDT
  gpg:                using RSA key 29590362EC878A81FD3C202B52527BEDABE87984
  gpg: Good signature from "Pasta <pasta@dashboost.org>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 2959 0362 EC87 8A81 FD3C  202B 5252 7BED ABE8 7984
  pasta: OK

  gpg: Signature made Sun 06 Jun 2021 06:41:11 PM EDT
  gpg:                using RSA key CF9A554A36B7950BB648A15DA0078C72B1777616
  gpg:                issuer "xdustinfacex@gmail.com"
  gpg: Good signature from "Dustinface <xdustinfacex@gmail.com>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: CF9A 554A 36B7 950B B648  A15D A007 8C72 B177 7616
  dustinface: OK

  gpg: Signature made Sun 06 Jun 2021 07:39:14 PM EDT
  gpg:                using RSA key 3F5D48C9F00293CD365A3A9883592BD1400D58D9
  gpg: Good signature from "UdjinM6 <UdjinM6@dash.org>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@dashpay.io>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@gmail.com>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 3F5D 48C9 F002 93CD 365A  3A98 8359 2BD1 400D 58D9
  UdjinM6: OK
