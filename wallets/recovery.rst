.. _wallet-recovery:

===============
Wallet Recovery
===============

Long-time users of cryptocurrency sometimes find old wallet files on USB
drives or cloud storage that they have forgotten about. Others may have
a backup, but can't remember the software they used to create it and
need to regain access to their funds. Other users may have an old
version of Dash Core that no longer works because the network has
upgraded. This guide is intended to help these users restore access to
their funds.

Determining the backup format
=============================

The first step is to determine the format of your backup. In most cases,
this will either be a file, probably named *wallet.dat*, or a phrase of
words. In some cases, you may have stored the private key for a Dash
address directly. The following list shows the possibilities and methods
to restore your wallet in order of probability.

- Backup is stored in an older version of Dash Core that no longer works
  - Follow instructions for restoring wallet files using Dash Core
- Backup is a file
  - If file name is similar to wallet.dat, try to restore using Dash Core
  - If file name is similar to dash-wallet-backup or includes the word 'mobile', try to restore using Dash Wallet for Android
- Backup is a phrase of words
  - If 12 words long, try to restore using Dash Electrum, Jaxx or Dash wallet for Android/iOS, depending what you used to create the backup
  - If 13 words long, try to restore using Dash Electrum wallet
  - If 12, 18 or 24 or 25 words long, try to restore with the hardware wallet you used to create the recovery phrase
- Backup is a long string of random characters or a QR code
  - If 34 characters long and starting with X, this is a public address and cannot be used to restore access to lost funds. You need the private key.
- If 51 characters long and starting with 7, this is a private key in WIF, import using Dash Core
- If 58 characters long and starting with 6P, this is a BIP38 encrypted private key, decrypt using paper wallet then import using Dash Core

Once you have determined your backup format, follow the links to view
the restore guide for that format.


Dash Core
---------

