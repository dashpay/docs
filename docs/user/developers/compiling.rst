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

Setup environment
=================

.. note::
  This setup has been tested using a clean install of Ubuntu 22.04. For maximum
  compatibility, please use that version.

Start by logging in as the "root" user. Create a new user with the following
command, replacing ``<username>`` with a username of your choice::

  adduser <username>

You will be prompted for a password. Enter and confirm using a new password
(different to your root password) and store it in a safe place. You will also
see prompts for user information, but this can be left blank. Alternatively, an
existing user can be used on systems that are already in use (e.g. your existing
development system).

Add the user to the sudo and docker groups so they can perform commands as
root and run docker commands::

  usermod -aG sudo <username>

Install prerequisites
---------------------

While still logged in as root, update the system from the Ubuntu package
repository::

  apt update
  apt upgrade -y

Install the required build tools::

  apt-get install build-essential

Prepare guix
------------

It is only necessary to run this step during the initial setup of your machine.
Run the guix install routine to prepare your environment and answer "Y" for all
prompts::

  cd /tmp
  wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh
  chmod +x guix-install.sh
  ./guix-install.sh

Clone repositories
------------------

After installing the prerequisites and preparing guix, reboot the system, login
as ``<username>``, and clone required repositories::

  git clone https://github.com/dashpay/dash
  git clone https://github.com/dashpay/guix.sigs
  git clone https://github.com/dashpay/dash-detached-sigs

Download the macOS SDK which is required to create macOS builds::

  mkdir -p ~/guix-dash/macOS-SDKs
  wget -N -P ~/guix-dash https://bitcoincore.org/depends-sources/sdks/Xcode-12.2-12B45b-extracted-SDK-with-libcxx-headers.tar.gz
  tar -xvzf ~/guix-dash/Xcode-12.2-12B45b-extracted-SDK-with-libcxx-headers.tar.gz --directory ~/guix-dash/macOS-SDKs/

Build Dash Core
===============

Checkout the tag associated with the Dash Core version you plan to build::

  # <version> = Dash Core tag to build
  # Example: git checkout v20.0.3
  cd ~/dash
  git checkout v20.0.3

Run ``guix-build`` to create binaries for Linux, Mac, and Windows::

  # Example: Build binaries for all OSes
  env SDK_PATH="$HOME/guix-dash/macOS-SDKs" ./contrib/guix/guix-build

When the build completes, it will put the binaries in the
``guix-build-<version>/output/`` directory.

Create signatures for binaries
==============================

Mac and Windows binaries are signed by Dash Core Group using the relevant Apple
and Microsoft processes. In this step, that information will be validated and
signed by your machine. 

Prepare the `detached sigs repository <https://github.com/dashpay/dash-detached-sigs>`__::

  cd ~/dash-detached-sigs/
  git checkout master
  git pull
  # Checkout the branch for the version being built
  # Example: git checkout v20.0.3
  git checkout v<version>

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

Unsigned binaries
-----------------

To create signatures for the unsigned binaries, run ``guix-attest``::

  # <signer> = The name associated with your PGP key
  # Example: env GUIX_SIGS_REPO=~/guix.sigs SIGNER=alice ./contrib/guix/guix-attest
  cd ~/dash
  env GUIX_SIGS_REPO=~/guix.sigs SIGNER=<signer> ./contrib/guix/guix-attest

.. note::
  The ``signer`` parameter should be set to the value provided for "Real name"
  when generating a key with GPG. See the `GnuPrivacyGuard Howto
  <https://help.ubuntu.com/community/GnuPrivacyGuardHowto#Generating_an_OpenPGP_Key>`_
  for details on how to generate a key if you don't already have one.

Signed binaries
---------------

To create signatures for the signed binaries, run ``guix-codesign`` followed by
guix-attest::

  env DETACHED_SIGS_REPO=~/dash-detached-sigs ./contrib/guix/guix-codesign

::

  # <signer> = The name associated with your PGP key
  # Example: env GUIX_SIGS_REPO=~/guix.sigs SIGNER=alice ./contrib/guix/guix-attest
  env GUIX_SIGS_REPO=~/guix.sigs SIGNER=<signer> ./contrib/guix/guix-attest
  
Upload signatures
=================

After successfully building the binaries, signing them, and verifying the
signatures, you can optionally contribute them to the `guix.sigs repository
<https://github.com/dashpay/guix.sigs/>`_ via a pull request on GitHub.

Initial setup
-------------

Since the official guix.sigs repository has restricted write access, create a
fork of it via GitHub and add your fork as a remote repository::

  cd ~/guix.sigs
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

Verify signatures
=================

The `guix.sigs repository <https://github.com/dashpay/guix.sigs/>`_ contains
deterministic build results signed by multiple Core developers for each release.
The repository also contains public keys used for signature verification. Import
the public keys::

  cd ~/guix.sigs
  git pull
  gpg --import builder-keys/*.pgp

Run the following commands to verify that your build matches the official
release::

  cd ~/dash
  git -C ~/guix.sigs pull
  # Example:
  # git checkout 20.0.3
  git checkout <version>
  env GUIX_SIGS_REPO=~/guix.sigs ./contrib/guix/guix-verify

You should get a result similar to the following for Linux, Windows, MacOS,
Signed Windows, and Signed MacOS. Assuming the previous steps completed
successfully, you will also see your own signatures with an ``OK`` status also.

::

  Looking for signature directories in '../guix.sigs/20.0.3'

  --------------------

  gpg: Signature made Tue Dec 26 15:15:29 2023 EST
  gpg:                using RSA key 3F5D48C9F00293CD365A3A9883592BD1400D58D9
  gpg:                issuer "udjinm6@dash.org"
  gpg: Good signature from "UdjinM6 <UdjinM6@dash.org>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@dashpay.io>" [unknown]
  gpg:                 aka "UdjinM6 <UdjinM6@gmail.com>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 3F5D 48C9 F002 93CD 365A  3A98 8359 2BD1 400D 58D9
  Files ../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS and ../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS are identical
  Verified: '../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS'

  gpg: Signature made Wed Dec 27 01:21:08 2023 EST
  gpg:                using RSA key 15191D05B5CF956FE37C95962176C4A5D01EA524
  gpg:                issuer "knstqq@gmail.com"
  gpg: Good signature from "Konstantin Akimov <knstqq@gmail.com>" [unknown]
  gpg:                 aka "Konstantin Akimov <konstantin.akimov@dash.org>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 1519 1D05 B5CF 956F E37C  9596 2176 C4A5 D01E A524
  5c5
  < 40613fc2d13198d7765a9bbcf2feeca93bc43dc57c74f26ee631185437b8e100  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  ---
  > 8035094d94fca4f8ed3abf50eb5707ba60910a345a7072b57b3271d98cb1a92b  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  12c12
  < 90924b90e73f50bf072798c9911e37f6b97b7863b04dd88575161392e661e1c2  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ---
  > 46113d6c4ac419d9df78244ac951d9021f43cef80eb3e4ecee4f37c5d448ddfa  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ERR: The SHA256SUMS attestation in these two directories differ:
      '../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS'
      '../guix.sigs/20.0.3/knst/noncodesigned.SHA256SUMS'

  gpg: Signature made Tue Dec 26 13:13:27 2023 EST
  gpg:                using RSA key 29590362EC878A81FD3C202B52527BEDABE87984
  gpg:                issuer "pasta@dashboost.org"
  gpg: Good signature from "Pasta <pasta@dashboost.org>" [unknown]
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.
  Primary key fingerprint: 2959 0362 EC87 8A81 FD3C  202B 5252 7BED ABE8 7984
  5c5
  < 40613fc2d13198d7765a9bbcf2feeca93bc43dc57c74f26ee631185437b8e100  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  ---
  > bb577ed0a7a577a67fde39ac9c00ddfe11991aa98f44d850eb45c0f18d52709f  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  12c12
  < 90924b90e73f50bf072798c9911e37f6b97b7863b04dd88575161392e661e1c2  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ---
  > 1c650cfe167c4f16dc8329701b94fe507dcb758a9b874c65633667d7fdcfa377  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ERR: The SHA256SUMS attestation in these two directories differ:
      '../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS'
      '../guix.sigs/20.0.3/pasta/noncodesigned.SHA256SUMS'

  gpg: Signature made Tue Dec 26 14:32:19 2023 EST
  gpg:                using RSA key FD4A3062EE42C95FE9B34DBC6317F01E6F491072
  gpg:                issuer "thephez@gmail.com"
  gpg: Good signature from "thephez <thephez@gmail.com>" [full]
  5c5
  < 40613fc2d13198d7765a9bbcf2feeca93bc43dc57c74f26ee631185437b8e100  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  ---
  > cbb3213303c3813c818fdda91671acf60d7c81f8f13800c297fcd66e4058b799  dashcore-20.0.3-arm64-apple-darwin-debug.tar.gz
  12c12
  < 90924b90e73f50bf072798c9911e37f6b97b7863b04dd88575161392e661e1c2  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ---
  > 4b084a5153024de5806f1bc8cd48914d6cf686d52602bcf52cf671023dca602b  dashcore-20.0.3-x86_64-apple-darwin-debug.tar.gz
  ERR: The SHA256SUMS attestation in these two directories differ:
      '../guix.sigs/20.0.3/UdjinM6/noncodesigned.SHA256SUMS'
      '../guix.sigs/20.0.3/thephez/noncodesigned.SHA256SUMS'

  DONE: Checking output signatures for noncodesigned.SHA256SUMS

  --------------------

  WARN: No signature directories with all.SHA256SUMS found

  ====================


.. _gitian-build:

Gitian
======

.. warning::
  Gitian builds were deprecated in favor of Guix builds with the release of
  Dash Core v20.0. Instructions on building Dash Core 19.0 or older versions
  using gitian are available in a `previous version of this page <https://docs.dash.org/en/19.0.0/docs/user/developers/compiling.html#gitian>`__.
