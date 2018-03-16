.. _dash_paper_wallet:

===========================
Dash Paper Wallet Generator
===========================

A paper wallet is a method of storing a private key to access funds
stored on a single address. It can be generated on a computer that has
never been connected to the internet, and printed out for air-gapped
offline storage. As such, they are suitable for storing large amounts of
Dash, but care must be taken not to lose the private key, since there is
no way of recovering funds if it is ever lost. To use the key, it must
be imported or "swept" into an online wallet and should not be used
again. Paper wallets are extremely secure but somewhat inconvenient for
everyday use compared to hardware wallets, which also offer a high
degree of security.


Introduction
============

Paper wallets use random user and machine input to create a set of
keys/addresses which you then print. You can never regenerate a paper
wallet once you turn off the machine. What you print is all you get. For
this reason, paper wallets are somewhat vulnerable and require special
care because they can get damaged, lost, destroyed or stolen. Even if
you encrypt them with BIP38 (which you should), a sufficiently motivated
adversary (e.g. robbery/home invasion) could bypass this encryption
using the proverbial "$5 wrench attack".

.. figure:: https://imgs.xkcd.com/comics/security.png
   :width: 448px

   The $5 wrench attack. Credit: xkcd.com

Nevertheless, together with appropriate planning, paper wallets are a
highly convenient and user-friendly way to store Dash long term.

Security
--------

While you can create a paper wallet using a machine that is connected to
the internet, wallets that will be used to store significant funds
should be generated using an offline computer running a single-use
operating system to ensure that all generated data will be permanently
wiped from memory once the process is complete.

A simple method of doing this is to burn a live Linux CD. `Ubuntu
Desktop <https://www.ubuntu.com/download/desktop>`_ is recommended
because it will have the most drivers and is simple to use, while `Tails
<https://tails.boum.org/>`_ and `Kali Linux
<https://www.kali.org/downloads/>`_ are popular choices for extremely
strong security. Booting from an actual CD is most secure since it is
mounted read-only, but a USB stick is generally fine as well. Both
laptops and desktops can be used if you can ensure that all networking
hardware is disabled when you get to the stage of actually generating
your keys.

Boot from the CD and download/install your tools (or download them ahead
of time to a USB drive). Disconnect from the internet, generate your
keys/addresses/printouts, and power off the machine. You are now the
only person with access to these addresses.

Death plan
----------

Whichever type of cold storage you choose, make a plan to pass on the
necessary data to regenerate the keys to your loved ones in the event of
an accident - it will happen to us all eventually. Write down your paper
wallet BIP38 decryption password or brain wallet passphrase. Then write
down instructions on how to use it, and keep them separate with a clear
procedure on how they can be accessed when necessary.

Generating paper wallets
========================

A Dash paper wallet can be generated in several ways.

- Using the generator at https://paper.dash.org/
- Using the generator at https://walletgenerator.net/?currency=Dash
- Offline using the Dash Paper Wallet source code from Github at 
  https://github.com/dashpay/paper.dash.org/releases/latest
- Offline using the same code which powers both sites, by viewing the
  Github project or downloading directly

Since the source code for all three options is largely similar, this
guide will use https://paper.dash.org/ as an example. The websites
listed here run entirely in your web browser without sending any of the
data generated to an external server, but the most secure option is to
download the wallet generator and run it on a computer with a freshly
installed operating system that is not connected to the internet.

This guide is based on the guide available from
https://walletgenerator.net/. Please donate if you find this project
useful!

