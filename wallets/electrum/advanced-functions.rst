.. _electrum_advanced_functions:

==================
Advanced Functions
==================

Cold Storage
============

This section shows how to create an offline wallet that holds your Dash
and a watching-only online wallet that is used to view its history and
to create transactions that have to be signed with the offline wallet
before being broadcast on the online one.

Create an offline wallet
------------------------

Create a wallet on an offline machine, as per the usual process (**File
> New**). After creating the wallet, go to **Wallet -> Master Public Keys**.

.. figure:: img/faq-cold-xpub.png
   :width: 400px

   Master Public Key of a new offline wallet

The Master Public Key of your wallet is the string shown in this popup
window. Transfer that key to your online machine somehow.

Create a watching-only version of your wallet
---------------------------------------------

On your online machine, open Dash Electrum and select **File >
New/Restore**. Enter a name for the wallet and select **Use public or
private keys**. Paste your master public key in the box. Click **Next**
to complete the creation of your wallet. When you’re done, you should
see a popup informing you that you are opening a watching-only wallet.

.. figure:: img/faq-cold-watching.png
   :width: 300px

   Master Public Key of a new offline wallet

The transaction history of your cold wallet should then appear.

Create an unsigned transaction
------------------------------

Go to the **Send** tab on your online watching-only wallet, input the
transaction data and click **Send**. A window will appear to inform you
that a transaction fee will be added. Continue. In the window that
appears up, click **Save** and save the transaction file somewhere on
your computer. Close the window and transfer the transaction file to
your offline machine (e.g. with a USB stick).

Sign your transaction
---------------------

On your offline wallet, select **Tools > Load transaction -> From file**
in the menu and select the transaction file created in the previous
step.

Click **Sign**. Once the transaction is signed, the Transaction ID
appears in its designated field.

Click **Save**, store the file somewhere on your computer, and transfer
it back to your online machine.

Broadcast your transaction
--------------------------

On your online machine, select **Tools -> Load transaction -> From
file** from the menu. Select the signed transaction file. In the window
that opens up, click **Broadcast**. The transaction will be broadcast
over the Dash network.

Multisig Wallets
================

This tutorial shows how to create a 2 of 2 multisig wallet. A 2 of 2
multisig consists of 2 separate wallets (usually on separate machines
and potentially controlled by separate people) that have to be used in
conjunction in order to access the funds. Both wallets have the same set
of addresses.

- A common use-case for this is if you want to collaboratively control
  funds: maybe you and your friend run a company together and certain
  funds should only be spendable if you both agree.

- Another one is security: one of the wallets can be on your main
  machine, while the other one is on a offline machine. That way you
  make it very hard for an attacker or malware to steal your coins.

Create a pair of 2-of-2 wallets
-------------------------------

Each cosigner needs to do this: In the menu select **File > New**, then
select **Multi-signature wallet**. On the next screen, select 2 of 2.

.. figure:: img/faq-multisig-create.png
   :width: 400px

   Selecting x of y signatures for a multi-signature wallet

After generating and confirming your recovery seed, you will be shown the xpub address for this wallet. 

.. figure:: img/faq-multisig-xpub.png
   :width: 400px

   xpub key of the first wallet

After generating a seed (keep it safely!) you will need to provide the
master public key of the other wallet. Of course when you create
the other wallet, you put the master public key of the first wallet.

.. figure:: img/faq-multisig-share-xpub.png
   :width: 400px

   Entering xpub from the second wallet in the first wallet

You will need to do this in parallel for the two wallets. Note that you
can press cancel during this step, and reopen the file later.

Receiving
---------

Check that both wallets generate the same set of Addresses. You can now
send to these **Addresses** (note they start with a “7”) with any wallet
that can send to P2SH Addresses.

Sending
--------

To spend coins from a 2-of-2 wallet, two cosigners need to sign a
transaction collaboratively. To accomplish this, create a transaction
using one of the wallets (by filling out the form on the **Send** tab).
After signing, a window is shown with the transaction details.

.. figure:: img/faq-multisig-partially-signed.png
   :width: 400px

   Partially signed 2-of-2 multisig transaction in Dash Electrum

The transaction now has to be sent to the second wallet. Several options
are available for this:

- You can transfer the file on a USB stick

  You can save the partially signed transaction to a file (using the
  **Save** button), transfer that to the machine where the second wallet
  is running (via USB stick, for example) and load it there (using
  **Tools > Load transaction > From file**)

- You can use QR codes

  A button showing a QR code icon is also available. Clicking this
  button will display a QR code containing the transaction, which can be
  scanned into the second wallet (**Tools > Load Transaction > From QR
  Code**)

With both of the above methods, you can now add the seconds signature
the the transaction (using the **Sign** button). It will then be
broadcast to the network.

.. figure:: img/faq-multisig-fully-signed.png
   :width: 400px

   Fully signed 2-of-2 multisig transaction in Dash Electrum

Command Line
============

Electrum has a powerful command line available when running under Linux
or macOS. This section will show you a few basic principles.

Using the inline help
---------------------

To see the list of Dash Electrum commands, type::

  electrum help

To see the documentation for a command, type::

  electrum help <command>

Magic Words
-----------

The arguments passed to commands may be one of the following magic words: `! ? : -`.

The exclamation mark `!` is a shortcut that means ‘the maximum amount
available’. Note that the transaction fee will be computed and deducted
from the amount. Example::

  electrum payto Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq !

A question mark `?` means that you want the parameter to be prompted.
Example::

  electrum signmessage Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq ?

Use a colon `:` if you want the prompted parameter to be hidden (not
echoed in your terminal). Note that you will be prompted twice in this
example, first for the private key, then for your wallet password::

  electrum importprivkey :

A parameter replaced by a dash `-` will be read from standard input (in
a pipe)::

  cat LICENCE | electrum signmessage Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq -

Aliases
-------

You can use DNS aliases in place of bitcoin addresses, in most commands::

  electrum payto ecdsa.net !

Formatting outputs using jq
---------------------------

Command outputs are either simple strings or json structured data. A
very useful utility is the ‘jq’ program. Install it with::

  sudo apt-get install jq

The following examples use it.

Sign and verify message
^^^^^^^^^^^^^^^^^^^^^^^

We may use a variable to store the signature, and verify it::

  sig=$(cat LICENCE| electrum signmessage Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq -)

And::

  cat LICENCE | electrum verifymessage Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq $sig -

Show the values of your unspents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `listunspent` command returns a list of dict objects, with various
fields. Suppose we want to extract the `value` field of each record.
This can be achieved with the jq command::

  electrum listunspent | jq 'map(.value)'

Select only incoming transactions from history
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Incoming transactions have a positive ‘value’ field::

  electrum history | jq '.[] | select(.value>0)'

Filter transactions by date
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command selects transactions that were timestamped after a
given date::

  after=$(date -d '07/01/2015' +"%s")
  electrum history | jq --arg after $after '.[] | select(.timestamp>($after|tonumber))'

Similarly, we may export transactions for a given time period::

  before=$(date -d '08/01/2015' +"%s")
  after=$(date -d '07/01/2015' +"%s")
  electrum history | jq --arg before $before --arg after $after '.[] | select(.timestamp&gt;($after|tonumber) and .timestamp&lt;($before|tonumber))'

Encrypt and decrypt messages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First we need the public key of a wallet address::

  pk=$(electrum getpubkeys Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq| jq -r '.[0]')

Encrypt::

  cat | electrum encrypt $pk -

Decrypt::

  electrum decrypt $pk ?

Note: this command will prompt for the encrypted message, then for the
wallet password.

Export private keys and sweep coins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command will export the private keys of all wallet
addresses that hold some Dash::

  electrum listaddresses --funded | electrum getprivatekeys -

This will return a list of lists of private keys. In most cases, you
want to get a simple list. This can be done by adding a jq filer, as
follows::

  electrum listaddresses --funded | electrum getprivatekeys - | jq 'map(.[0])'

Finally, let us use this list of private keys as input to the sweep command::

  electrum listaddresses --funded | electrum getprivatekeys - | jq 'map(.[0])' | electrum sweep - [destination address]

Using cold storage with the command line
========================================



Electrum Wallet on Tor
======================

Masternodes in Electrum
=======================

Seeds and Change Addresses
==========================

Sweep a Paper Wallet
====================
