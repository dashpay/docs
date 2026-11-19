.. meta::
   :description: Coin control, HD wallets, multisig, multiple wallet files using the Dash Core wallet
   :keywords: dash, core, wallet, backup, restore, wallet.dat, multisig, hd, seed, passphrase, mnemonic, coin control, hierarchical deterministic

.. _dashcore-advanced:

===============
Advanced topics
===============

.. _coin-control:

Coin Control
============

Coin Control allows users of the Dash Core Wallet to specify which
addresses and Unspent Transaction Outputs (UTXOs) should be used as
inputs in transactions. This allows you to keep a specific balance on
certain addresses in your wallet, while spending others freely. In Dash
Core Wallet, click **Settings > Options > Wallet > Enable coin control
features**. Now, when you go to the Send tab in your wallet, a new
button labelled **Inputs…** will appear. Click this button to select
which UTXOs can be used as input for any transactions you create. The
following window appears:

.. figure:: img/coin-selection.png
   :width: 400px

   Coin Selection window in Dash Core wallet, showing two masternodes
   (testnet)

Right click on the transaction(s) you do not want to spend, then select
**Lock unspent**. A small lock will appear next to the transaction. You
can click the **(un)lock all** button to lock all listed UTXOs. If any
listed UTXOs are already locked, the button unlocks them instead. The
button works in both tree mode and list mode. When you are ready to
continue, click **OK**. You
can now safely create transactions with your remaining funds without
affecting the locked UTXOs.

.. figure:: img/coin-selection-lock.png
   :width: 220px

.. figure:: img/coin-selection-locked.png
   :width: 180px

   Locking UTXOs in Dash Core wallet


.. _dashcore-testnet:

Running Dash Testnet
====================

It is recommended to run Dash Core on testnet for your experimentations. 
To start on testnet via the command line, do the following:

For Linux::

  ./dash-qt -testnet

For Mac (run from Applications/Dash-Qt.app/Contents/MacOS)::

  Dash-Qt -testnet

Note: You may need to allow an app from an unknown developer before running this. 
Cmd+Click on the application and click **Open**.

Now, open Mac Terminal and run::

  cd /Applications/Dash-Qt.app/Contents/MacOS
  ./Dash-Qt -testnet

You may top up your testnet wallet by `accessing the faucet <http://faucet.testnet.networks.dash.org/>`_.

.. _dashcore-hd:

HD Wallets
==========

.. versionadded:: v20.1.0
   
   HD wallets are now created by default.

Dash Core includes an implementation of BIP39/BIP44 compatible hierarchical
deterministic (HD) key generation.

.. _dashcore-hd-upgrade:

Upgrade to HD
-------------

.. warning::

  A new :ref:`backup <dashcore-backup>` must be created after upgrading to an HD
  wallet.

Dash Core includes the ability upgrade a legacy non-hierarchical deterministic
(HD) wallet to an HD wallet via the ``upgradetohd`` command. The command can be
run by either opening the console from **Window > Console** or issuing the
following RPC command from ``dash-cli``::

  upgradetohd "" "" <walletpassphrase>

If your wallet is already encrypted you must enter the passphrase as the third
parameter to the command. If your wallet is not already encrypted, specifying a
wallet passphrase will trigger wallet encryption.

To see full details for the command, run the following from either the console
or ``dash-cli``::

  help upgradetohd

View HD wallet information
--------------------------

To view the recovery phrase (BIP39 mnemonic) of the active wallet, click
**Settings > Show Recovery Phrase…**. If the wallet is encrypted, you will be
asked to enter your wallet passphrase first.

You can also open the console from **Window > Console** or issue the following
RPC command from ``dash-cli`` to view the mnemonic seed. If the wallet is
encrypted, unlock it with ``walletpassphrase`` first::

  listdescriptors true

Dash Core will display the BIP39 mnemonic in the ``mnemonic`` field of the
wallet's descriptors. It will also display the mnemonic passphrase in the
``mnemonicpassphrase`` field if one was used when creating the wallet. For a
legacy wallet, use ``dumphdinfo`` instead, which displays the HD seed in both
hexadecimal and BIP39 mnemonic formats.

.. _dashcore-hd-restore:

Restore HD wallet
-----------------

To restore an existing HD wallet, or define your own separately generated
mnemonic and/or passphrase, create a new blank wallet with following command::

  createwallet "enter wallet name" false true "optional wallet password"

Add the HD wallet details to the newly created wallet by running::

  upgradetohd "enter mnemonic" "optional mnemonic passphrase" "optional wallet passphrase"

The HD wallet will be restored and your balance will appear once sync is
complete.

Note that the wallet passphrase is different to the mnemonic passphrase, which
is often also referred to as the "25th word" or "extension word". The wallet
passphrase encrypts the wallet file itself, while the mnemonic passphrase is
used to specify different derivation branches from the same mnemonic seed.

The mnemonic passphrase can be at most 248 bytes long. To restore a wallet
that was created with a longer mnemonic passphrase (up to 256 bytes), start
Dash Core with the ``-allow-deprecated-long-mnemonics`` option. This only
works for wallets created by Dash Core 19.2.0 or later.

.. _dashcore-hd-default:

Enable HD Wallet Creation By Default
------------------------------------

.. versionadded:: v20.1.0
   
  HD wallets are now created by default without requiring the steps listed below.

Prior to Dash Core v20.1.0, it was necessary to complete theses steps to make HD
wallet the default. We will use the Windows GUI wallet in this example, but the
commands are similar if using ``dash-qt`` or ``dashd`` on other operating
systems. Enter the following command to configure Dash Core to generate HD
wallets by default::

  dash-qt.exe -usehd

To make this configuration persist between restarts, add ``usehd=1`` to the
``dash.conf`` file.

.. _dashcore-multisig:

Multisignature
==============

This section presents a worked example to demonstrate multisig
functionality in Dash Core. Some address formats or RPC responses may
differ slightly from the version shown here, but the principle and
commands are the same. The example demonstrates how to set up a 2-of-3
multisig address and spend from it using a partially signed transaction
(PSBT), so that each party only shares public keys and signs with their
own wallet. The example parties involved are a buyer, a seller and an
arbiter. This example is based on:

- https://gist.github.com/jashmenn/9811198
- https://gist.github.com/gavinandresen/3966071

.. The example output in this section comes from
   scripts/core-regtest-examples/capture-multisig-example.sh, which produces
   the same output on every run. Don't hand-edit it; rerun the script instead.

Step 1: Create three addresses
------------------------------

Seller::

  seller@dash:~$ ./dash-cli getnewaddress seller
  yYCL8XUL91NSmMnrnnsmZBzZAhdLy98Css
  
  seller@dash:~$ ./dash-cli getaddressinfo yYCL8XUL91NSmMnrnnsmZBzZAhdLy98Css
  {
    "address": "yYCL8XUL91NSmMnrnnsmZBzZAhdLy98Css",
    "scriptPubKey": "76a9148248fd427b579eccad53c7e30b2aa5f9a2578d3188ac",
    "ismine": true,
    "solvable": true,
    "desc": "pkh([964e4980/44h/1h/0h/0/0]02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c)#64q3l8vc",
    "parent_desc": "pkh([964e4980/44h/1h/0h]tpubDCxpcJGdpZTHm7VeAzmagaWyRQGgbWmR1YH1gGsXomYmm6iP9mEsqi5MTuNfrqATzQwD24RYx2t3JAHpgdVztnrGSJkrt8Ca7aiB69AhzfM/0/*)#06pz7kzv",
    "iswatchonly": false,
    "isscript": false,
    "pubkey": "02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c",
    "iscompressed": true,
    "ischange": false,
    "timestamp": 1767225600,
    "hdkeypath": "m/44h/1h/0h/0/0",
    "hdmasterfingerprint": "964e4980",
    "labels": [
      "seller"
    ]
  }

Buyer::

  buyer@dash:~$ ./dash-cli getnewaddress buyer
  yceWp1Kk1NWJ4p4C9LLeRsCay51gfGcZzf
  
  buyer@dash:~$ ./dash-cli getaddressinfo yceWp1Kk1NWJ4p4C9LLeRsCay51gfGcZzf
  {
    "address": "yceWp1Kk1NWJ4p4C9LLeRsCay51gfGcZzf",
    "scriptPubKey": "76a914b31d3925aab4586c0186e16364ccf1da0ddb0be488ac",
    "ismine": true,
    "solvable": true,
    "desc": "pkh([c5f97bbc/44h/1h/0h/0/0]03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2)#5mfwqhx6",
    "parent_desc": "pkh([c5f97bbc/44h/1h/0h]tpubDCEt4PYU28Qfa3D5S9aE2psf9pu3bxyGvB2xrU8kUcYTHAAVX6kZiovhq4vs52anKUXEw288G9KYotghGncEVwVLKaxHa6fdhnHCqznGg1w/0/*)#sudmvufr",
    "iswatchonly": false,
    "isscript": false,
    "pubkey": "03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2",
    "iscompressed": true,
    "ischange": false,
    "timestamp": 1767225600,
    "hdkeypath": "m/44h/1h/0h/0/0",
    "hdmasterfingerprint": "c5f97bbc",
    "labels": [
      "buyer"
    ]
  }

Arbiter::

  arbiter@dash:~$ ./dash-cli getnewaddress arbiter
  yjD3FEgVHSBBiGtMTzsnmwrUM7u2NGeBrZ
  
  arbiter@dash:~$ ./dash-cli getaddressinfo yjD3FEgVHSBBiGtMTzsnmwrUM7u2NGeBrZ
  {
    "address": "yjD3FEgVHSBBiGtMTzsnmwrUM7u2NGeBrZ",
    "scriptPubKey": "76a914fb14b1cf980df8022ffcedbb0bfb96eb74e7a66588ac",
    "ismine": true,
    "solvable": true,
    "desc": "pkh([06c6ea99/44h/1h/0h/0/0]03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5)#e6ygfwx6",
    "parent_desc": "pkh([06c6ea99/44h/1h/0h]tpubDCcCpBTPfmiQf1DbixLtch3D7pAe5Ws9UWiky1AddBJ8tckFsRD2BLntnc2n3BhBKkA7RZopATAeubf2jqSXUnuEueJ5S4KgawxrSc8zhcG/0/*)#y0m67cz6",
    "iswatchonly": false,
    "isscript": false,
    "pubkey": "03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5",
    "iscompressed": true,
    "ischange": false,
    "timestamp": 1767225600,
    "hdkeypath": "m/44h/1h/0h/0/0",
    "hdmasterfingerprint": "06c6ea99",
    "labels": [
      "arbiter"
    ]
  }

This results in three public keys::

  seller:    02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c
  buyer:     03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2
  arbiter:   03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5

Step 2: Create multisig address 
-------------------------------

The ``createmultisig`` command takes as variables the number n
signatures of m keys (supplied as json array) required. In this example,
2 of 3 keys are required to sign the transaction.

Note: The address can be created by anyone, as long as the public keys
and their sequence are known (resulting address and redeemScript are
identical, see below).

Seller::

  seller@dash:~$ ./dash-cli createmultisig 2 '["02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c","03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2","03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5"]'
  {
    "address": "8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF",
    "redeemScript": "522102aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c2103e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b22103f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e553ae",
    "descriptor": "sh(multi(2,02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c,03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2,03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5))#9cn7nu82"
  }

Buyer::

  buyer@dash:~$ ./dash-cli createmultisig 2 '["02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c","03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2","03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5"]'
  {
    "address": "8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF",
    "redeemScript": "522102aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c2103e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b22103f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e553ae",
    "descriptor": "sh(multi(2,02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c,03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2,03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5))#9cn7nu82"
  }

Arbiter::

  arbiter@dash:~$ ./dash-cli createmultisig 2 '["02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c","03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2","03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5"]'
  {
    "address": "8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF",
    "redeemScript": "522102aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c2103e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b22103f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e553ae",
    "descriptor": "sh(multi(2,02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c,03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2,03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5))#9cn7nu82"
  }

Step 3: Buyer funds the multisig address
----------------------------------------

This works the same as a usual transaction.

Buyer::

  buyer@dash:~$ ./dash-cli sendtoaddress 8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF 0.25
  1eddc72cac99d1964ea98e3f0fc82439f2bb1f0d33b744cd92f721f74f0ee2e6

The seller/arbiter can trace the transaction by its txid in the block
explorer. Or from the console as follows.

Seller::

  seller@dash:~$ ./dash-cli getrawtransaction 1eddc72cac99d1964ea98e3f0fc82439f2bb1f0d33b744cd92f721f74f0ee2e6 1
  {
    "txid": "1eddc72cac99d1964ea98e3f0fc82439f2bb1f0d33b744cd92f721f74f0ee2e6",
    "version": 2,
    "type": 0,
    "size": 189,
    "locktime": 0,
    [...]
    "vout": [
      {
        "value": 0.25000000,
        "valueSat": 25000000,
        "n": 0,
        "scriptPubKey": {
          "asm": "OP_HASH160 86e0e72bb5fe2b7b3ce71275e665ae1c4a9f50c6 OP_EQUAL",
          "desc": "addr(8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF)#cv0kwqjd",
          "hex": "a91486e0e72bb5fe2b7b3ce71275e665ae1c4a9f50c687",
          "address": "8ridgJcDxFBSWNp4spps1AFaXu3o6qZvqF",
          "type": "scripthash"
        }
      }
    ],
    [...]
    "blockhash": "2d7dbdbb4bdee94a8eab36cf2573070df1eacfefb38f9ddce1fb803817a349f4",
    "height": 103,
    "confirmations": 1,
    "time": 1767273450,
    "blocktime": 1767273450,
    "instantlock": false,
    "instantlock_internal": false,
    "chainlock": false
  }

Step 4: Spending the multisig
-----------------------------

Now we assume the deal is complete, the buyer got the goods and everyone
is happy. Now the seller wants to get his Dash. As a 2-of-3 multisig was
used, the transaction must be signed by 2 parties (seller + buyer or
arbiter). The seller creates a PSBT that spends the multisig output to
the seller's address from above.

Seller::

  seller@dash:~$ ./dash-cli createpsbt '[{"txid":"1eddc72cac99d1964ea98e3f0fc82439f2bb1f0d33b744cd92f721f74f0ee2e6","vout":0}]' '{"yYCL8XUL91NSmMnrnnsmZBzZAhdLy98Css":0.249}'
  cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAAA

The seller passes the multisig descriptor from step 2 to
``utxoupdatepsbt``. This adds the funding transaction and the
redeemScript to the PSBT, which the signers' wallets need to sign it.

Seller::

  seller@dash:~$ ./dash-cli utxoupdatepsbt cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAAA '["sh(multi(2,02aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c,03e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b2,03f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e5))#9cn7nu82"]'
  cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAEAvQIAAAABAKjNpHUAS5vcu1L5k5lfBLww7iYHDj6rDs0k35PGvScAAAAAakcwRAIgKDmwDepLg5LtZUT8VV5GUCCoM+AChToDPKm1f7KnUlcCIGeNwH3o4lZ/0iXwDOYYioypFxnxFh4okFDi/4wy7QhUASECmBkbErj+s/WEPKa/dIx6eTcF/e9A3t1rqNaNwP9E4NT+////AUB4fQEAAAAAF6kUhuDnK7X+K3s85xJ15mWuHEqfUMaHAAAAAAEEaVIhAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8IQPoJpH8yca9MQt4tND7BKBfKB8GpKZF9lTAV37GE+gUsiED8SD9d3lR+2IDKbZ/bHPLM59FrinjrpHe+tTvguoUhOVTriIGAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8BIJI/UIiBgPoJpH8yca9MQt4tND7BKBfKB8GpKZF9lTAV37GE+gUsgSzHTklIgYD8SD9d3lR+2IDKbZ/bHPLM59FrinjrpHe+tTvguoUhOUE+xSxzwAA

The seller then partially signs the PSBT with their own wallet.

Seller::

  seller@dash:~$ ./dash-cli walletprocesspsbt cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAEAvQIAAAABAKjNpHUAS5vcu1L5k5lfBLww7iYHDj6rDs0k35PGvScAAAAAakcwRAIgKDmwDepLg5LtZUT8VV5GUCCoM+AChToDPKm1f7KnUlcCIGeNwH3o4lZ/0iXwDOYYioypFxnxFh4okFDi/4wy7QhUASECmBkbErj+s/WEPKa/dIx6eTcF/e9A3t1rqNaNwP9E4NT+////AUB4fQEAAAAAF6kUhuDnK7X+K3s85xJ15mWuHEqfUMaHAAAAAAEEaVIhAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8IQPoJpH8yca9MQt4tND7BKBfKB8GpKZF9lTAV37GE+gUsiED8SD9d3lR+2IDKbZ/bHPLM59FrinjrpHe+tTvguoUhOVTriIGAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8BIJI/UIiBgPoJpH8yca9MQt4tND7BKBfKB8GpKZF9lTAV37GE+gUsgSzHTklIgYD8SD9d3lR+2IDKbZ/bHPLM59FrinjrpHe+tTvguoUhOUE+xSxzwAA
  {
    "psbt": "cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAEAvQIAAAABAKjNpHUAS5vcu1L5k5lfBLww7iYHDj6rDs0k35PGvScAAAAAakcwRAIgKDmwDepLg5LtZUT8VV5GUCCoM+AChToDPKm1f7KnUlcCIGeNwH3o4lZ/0iXwDOYYioypFxnxFh4okFDi/4wy7QhUASECmBkbErj+s/WEPKa/dIx6eTcF/e9A3t1rqNaNwP9E4NT+////AUB4fQEAAAAAF6kUhuDnK7X+K3s85xJ15mWuHEqfUMaHAAAAACICAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8RzBEAiBF76aXL/4txadkY/fxOLJjLCMuzYx+77bWopxCBgrPiwIgabdOgjH0XpP9aHkKFRWCAkbA+bMGF+fFJYZj6Bhdl+YBAQRpUiECqqEGF8Zxt77p58pc+r/Sas3s9DWfMI9gnOuIKzI0EjwhA+gmkfzJxr0xC3i00PsEoF8oHwakpkX2VMBXfsYT6BSyIQPxIP13eVH7YgMptn9sc8szn0WuKeOukd761O+C6hSE5VOuIgYCqqEGF8Zxt77p58pc+r/Sas3s9DWfMI9gnOuIKzI0EjwEgkj9QiIGA+gmkfzJxr0xC3i00PsEoF8oHwakpkX2VMBXfsYT6BSyBLMdOSUiBgPxIP13eVH7YgMptn9sc8szn0WuKeOukd761O+C6hSE5QT7FLHPACICAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8GJZOSYAsAACAAQAAgAAAAIAAAAAAAAAAAAA=",
    "complete": false
  }

Note that the complete flag is "false" as the transaction needs another
signature. The seller passes the ``psbt`` value from above to the buyer
or the arbiter, who can complete the signature with their own wallet.
Let's assume the buyer is completing the signature.

Buyer::

  buyer@dash:~$ ./dash-cli walletprocesspsbt cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAEAvQIAAAABAKjNpHUAS5vcu1L5k5lfBLww7iYHDj6rDs0k35PGvScAAAAAakcwRAIgKDmwDepLg5LtZUT8VV5GUCCoM+AChToDPKm1f7KnUlcCIGeNwH3o4lZ/0iXwDOYYioypFxnxFh4okFDi/4wy7QhUASECmBkbErj+s/WEPKa/dIx6eTcF/e9A3t1rqNaNwP9E4NT+////AUB4fQEAAAAAF6kUhuDnK7X+K3s85xJ15mWuHEqfUMaHAAAAACICAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8RzBEAiBF76aXL/4txadkY/fxOLJjLCMuzYx+77bWopxCBgrPiwIgabdOgjH0XpP9aHkKFRWCAkbA+bMGF+fFJYZj6Bhdl+YBAQRpUiECqqEGF8Zxt77p58pc+r/Sas3s9DWfMI9gnOuIKzI0EjwhA+gmkfzJxr0xC3i00PsEoF8oHwakpkX2VMBXfsYT6BSyIQPxIP13eVH7YgMptn9sc8szn0WuKeOukd761O+C6hSE5VOuIgYCqqEGF8Zxt77p58pc+r/Sas3s9DWfMI9gnOuIKzI0EjwEgkj9QiIGA+gmkfzJxr0xC3i00PsEoF8oHwakpkX2VMBXfsYT6BSyBLMdOSUiBgPxIP13eVH7YgMptn9sc8szn0WuKeOukd761O+C6hSE5QT7FLHPACICAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8GJZOSYAsAACAAQAAgAAAAIAAAAAAAAAAAAA=
  {
    "psbt": "cHNidP8BAFUCAAAAAebiDk/3IfeSzUS3Mw0fu/I5JMgPP46pTpbRmawsx90eAAAAAAD/////AaDxewEAAAAAGXapFIJI/UJ7V57MrVPH4wsqpfmiV40xiKwAAAAAAAEAvQIAAAABAKjNpHUAS5vcu1L5k5lfBLww7iYHDj6rDs0k35PGvScAAAAAakcwRAIgKDmwDepLg5LtZUT8VV5GUCCoM+AChToDPKm1f7KnUlcCIGeNwH3o4lZ/0iXwDOYYioypFxnxFh4okFDi/4wy7QhUASECmBkbErj+s/WEPKa/dIx6eTcF/e9A3t1rqNaNwP9E4NT+////AUB4fQEAAAAAF6kUhuDnK7X+K3s85xJ15mWuHEqfUMaHAAAAAAEH/ABHMEQCIEXvppcv/i3Fp2Rj9/E4smMsIy7NjH7vttainEIGCs+LAiBpt06CMfRek/1oeQoVFYICRsD5swYX58UlhmPoGF2X5gFHMEQCIHhZlYUBGe/xzzgqzqs5RCXEpga/DZbgUaHLcSfEMdnmAiAI0zrId8XgCgGxguVJFi99cu4ObXHrqJMY1eezzaknWwFMaVIhAqqhBhfGcbe+6efKXPq/0mrN7PQ1nzCPYJzriCsyNBI8IQPoJpH8yca9MQt4tND7BKBfKB8GpKZF9lTAV37GE+gUsiED8SD9d3lR+2IDKbZ/bHPLM59FrinjrpHe+tTvguoUhOVTrgAiAgKqoQYXxnG3vunnylz6v9Jqzez0NZ8wj2Cc64grMjQSPBiWTkmALAAAgAEAAIAAAACAAAAAAAAAAAAA",
    "complete": true,
    "hex": "0200000001e6e20e4ff721f792cd44b7330d1fbbf23924c80f3f8ea94e96d199ac2cc7dd1e00000000fc00473044022045efa6972ffe2dc5a76463f7f138b2632c232ecd8c7eefb6d6a29c42060acf8b022069b74e8231f45e93fd68790a1515820246c0f9b30617e7c5258663e8185d97e6014730440220785995850119eff1cf382aceab394425c4a606bf0d96e051a1cb7127c431d9e6022008d33ac877c5e00a01b182e549162f7d72ee0e6d71eba89318d5e7b3cda9275b014c69522102aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c2103e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b22103f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e553aeffffffff01a0f17b01000000001976a9148248fd427b579eccad53c7e30b2aa5f9a2578d3188ac00000000"
  }

The signature is complete now, and the ``hex`` field contains the signed
transaction. Either of the parties can transmit the transaction to the
network.

Buyer::

  buyer@dash:~$ ./dash-cli sendrawtransaction 0200000001e6e20e4ff721f792cd44b7330d1fbbf23924c80f3f8ea94e96d199ac2cc7dd1e00000000fc00473044022045efa6972ffe2dc5a76463f7f138b2632c232ecd8c7eefb6d6a29c42060acf8b022069b74e8231f45e93fd68790a1515820246c0f9b30617e7c5258663e8185d97e6014730440220785995850119eff1cf382aceab394425c4a606bf0d96e051a1cb7127c431d9e6022008d33ac877c5e00a01b182e549162f7d72ee0e6d71eba89318d5e7b3cda9275b014c69522102aaa10617c671b7bee9e7ca5cfabfd26acdecf4359f308f609ceb882b3234123c2103e82691fcc9c6bd310b78b4d0fb04a05f281f06a4a645f654c0577ec613e814b22103f120fd777951fb620329b67f6c73cb339f45ae29e3ae91defad4ef82ea1484e553aeffffffff01a0f17b01000000001976a9148248fd427b579eccad53c7e30b2aa5f9a2578d3188ac00000000
  7fa6a7319a107a2330a5bce181995555bcb23f4537a8c034e0ae5619e8766903

Again, this transaction can be traced in a block explorer. And the
seller is happy to receive his coins at his public address as follows.

Seller::

  seller@dash:~$ ./dash-cli listtransactions "*" 1
  [
    {
      "address": "yYCL8XUL91NSmMnrnnsmZBzZAhdLy98Css",
      "parent_descs": [
        "pkh(tpubD6NzVbkrYhZ4YA2qLALX5PodFkNBgFfFi4VAtSgkqDbhQFmXAN5NeZEPCQMQ1MeokxEqwKHmDf6tNFDxHbH6thUysbw6kLhARXyH9TT6BAF/44h/1h/0h/0/*)#w7rzhmdr"
      ],
      "category": "receive",
      "amount": 0.24900000,
      "label": "seller",
      "vout": 0,
      "abandoned": false,
      "confirmations": 1,
      "instantlock": false,
      "instantlock_internal": false,
      "chainlock": false,
      "blockhash": "15f820de30e19d2a250f037a69adf606e3646279feac7cd22f5aee4dcabafaf8",
      "blockheight": 104,
      "blockindex": 1,
      "blocktime": 1767273600,
      "txid": "7fa6a7319a107a2330a5bce181995555bcb23f4537a8c034e0ae5619e8766903",
      "walletconflicts": [
      ],
      "time": 1767273450,
      "timereceived": 1767273450
    }
  ]


.. _dashcore-daemon:

Daemon
======

Dash can be run as a background process (or daemon) on Linux systems.
This is particularly useful if you are running Dash as a server instead
of as a GUI node. This guide assumes you have installed Dash Core for
Linux as described in the :ref:`dashcore-installation-linux`.

#. Create a user and group to run the daemon::

     sudo useradd -m dash -s /bin/bash

#. Create a data directory for Dash in the new user's home directory::

     sudo -u dash mkdir -p /home/dash/.dashcore

#. Create a configuration file in the new Dash data directory::

     sudo -u dash nano /home/dash/.dashcore/dash.conf

#. Paste the following basic configuration to your ``dash.conf`` file,
   replacing the password with a long and random password::

     listen=1
     server=1
     daemon=1

#. Register the ``dashd`` daemon as a system service by creating the following file::

     sudo nano /etc/systemd/system/dashd.service

#. Paste the following daemon configuration into the file::

     [Unit]
     Description=Dash Core Daemon
     After=syslog.target network-online.target
  
     [Service]
     Type=forking
     User=dash
     Group=dash
     OOMScoreAdjust=-1000
     ExecStart=/usr/local/bin/dashd -pid=/home/dash/.dashcore/dashd.pid
     TimeoutStartSec=10m
     ExecStop=/usr/local/bin/dash-cli stop
     TimeoutStopSec=120
     Restart=on-failure
     RestartSec=120
     StartLimitInterval=300
     StartLimitBurst=3
  
     [Install]
     WantedBy=multi-user.target

#. Register and start the daemon with systemd::

     sudo systemctl daemon-reload
     sudo systemctl enable dashd
     sudo systemctl start dashd

Dash is now installed as a system daemon. View the status as follows::

  systemctl status dashd

View logs as follows::

  sudo journalctl -u dashd

Tor
===

`Tor <https://www.torproject.org/>`__ is free and open-source software
for enabling anonymous communication. The name derived from the acronym
for the original software project name "The Onion Router". Tor directs
Internet traffic through a free, worldwide, volunteer overlay network
consisting of more than seven thousand relays to conceal a user's
location and usage from anyone conducting network surveillance or
traffic analysis.

Dash Core GUI
-------------

Dash Core traffic can be directed to pass through Tor by specifying a
running Tor service as a proxy. First install Tor by visiting
https://www.torproject.org/download/ and downloading the appropriate Tor
Browser bundle for your system. Set up the Tor browser by following the
documentation on `Installation
<https://tb-manual.torproject.org/installation/>`__ and `Running Tor
Browser for the First Time
<https://tb-manual.torproject.org/running-tor-browser/>`__. 

Once Tor Browser is running, you have two options to configure Dash Core
to use Tor for network traffic.

1. **Using the GUI:** Start Dash Core and go to **Settings > Options >
   Network** and enable the **Connect through SOCKS5 proxy** setting.
   Specify ``127.0.0.1`` for the **Proxy IP** and ``9150`` for the
   **Port**. Click **OK** and restart Dash Core.

2. **Using dash.conf:** Ensure Dash Core is not running and edit
   your ``dash.conf`` settings file. Add the line
   ``proxy=127.0.0.1:9150``, save the file and start Dash Core.

You are now connected through the Tor network. You will need to remember
to start the Tor Browser each time before you start Dash Core or you will
not be able to sync.

Tor onion service
-----------------

Tor onion services allows other users to connect to your Dash node using
an onion address, providing further anonymity by concealing your IP
address. Follow these steps to set up an onion service under Ubuntu
Linux:

#. Install tor::

     sudo apt install tor

#. Add the following line to the ``torrc`` file::

     sudo bash -c "echo -e 'ControlPort 9051\nCookieAuthentication 1\nCookieAuthFileGroupReadable 1' >> /etc/tor/torrc"

#. Restart Tor::

     sudo systemctl restart tor

#. Determine the group Tor is running under (usually the last entry in
   your groups file)::

     tail /etc/group

   The group is usually ``debian-tor`` under Debian-based Linux
   distributions.

#. Add the user running Dash to the Tor group::

     sudo usermod -aG debian-tor dash

#. Add the following two lines to ``dash.conf``::

     proxy=127.0.0.1:9050
     torcontrol=127.0.0.1:9051

#. Restart Dash and monitor ``debug.log`` for onion informatoin::

     grep -i onion ~/.dashcore/debug.log

   You should see a line similar to the following::

     2020-06-29 03:43:57 tor: Got service ID knup3fvr6fyvypu7, advertising service knup3fvr6fyvypu7.onion:19999

Your onion service is now available at the shown address.


Multiple wallets
================

Since version 18.0.0, Dash Core has included the ability work with multiple
wallets from the **File** menu in addition to the previously available options.

.. warning::
  Wallet-related RPCs require using the ``-rpcwallet`` option when more than
  one wallet file is loaded. This is to ensure the RPC command is executed
  using the correct wallet. See the :ref:`Core developer documentation <api-rpc-multi-wallet-support>`
  for additional information.

Open a wallet
-------------

To open a wallet, click **File -> Open Wallet** and then click the name of
wallet file.

.. figure:: img/wallet-open.png
   :width: 350px

   Open wallet

Select the active wallet
------------------------

When multiple wallets are open, a wallet selection dropbox is shown to the left
of the Dash logo on the tab bar. Click the dropdown box and select a wallet to
set it as the active wallet.

.. figure:: img/wallet-select-dropdown.png
   :width: 350px

   Wallet selection dropdown box

Close a wallet
--------------

To close a wallet, set it as the active wallet using the wallet selection
dropdown box. Next, click **File -> Close Wallet...** and then click **Yes** on the
Close wallet confirmation screen.

.. figure:: img/wallet-close-confirmation.png
   :width: 350px

   Close wallet confirmation


.. note::

  If the only open wallet is closed, wallet-related items on the tab bar will be disabled.

Close all wallets
-----------------

To close all wallets, click **File -> Close All Wallets...** and then click **Yes** on the
Close all wallets confirmation screen.

.. figure:: img/wallet-close-all-confirmation.png
   :width: 350px

   Close wallet confirmation

Once all wallets are closed, wallet-related items on the tab bar will be disabled.

.. _dashcore-migrate-wallet:

Migrate a legacy wallet
-----------------------

.. versionadded:: v24.0.0

   Descriptor wallets are created by default, and legacy wallets can be migrated
   to descriptor wallets from the **File** menu.

To convert a legacy (non-descriptor) wallet to a descriptor wallet, set it as
the active wallet using the wallet selection dropdown box. Next, click **File ->
Migrate Wallet** and then click **Yes** on the Migrate wallet confirmation
screen. This menu item is only enabled when the active wallet is a legacy
wallet. If the wallet is encrypted, enter the wallet passphrase when prompted.

.. figure:: img/wallet-migrate-confirmation.png
   :width: 350px

   Migrate wallet confirmation

Before migrating, Dash Core creates a backup of the legacy wallet in the
wallet's directory. The backup file name ends with ``.legacy.bak``. If the
migration fails, Dash Core restores the original wallet. If the migration
completes but the result is not what you expected, use **File -> Restore
Wallet...** to restore the backup.

The migrated wallet keeps the same name as the original wallet. An HD wallet
keeps the same HD seed and mnemonic. If the legacy wallet contains watch-only
scripts, or solvable scripts that it does not watch, Dash Core moves them
into additional wallets whose names end with ``_watchonly`` and ``_solvables``,
respectively. The message shown when migration completes lists any additional
wallets that were created.

.. warning::

  Create a new :ref:`backup <dashcore-backup>` after migrating. Earlier backups
  contain the legacy wallet, not the migrated descriptor wallet.

The ``migratewallet`` RPC provides the same function from the console or
``dash-cli``.

Alternative methods
-------------------

It is also possible to select between different Dash wallets when starting
Dash Core by specifying the ``wallet`` argument, or even run multiple
instances of Dash Core simultaneously by specifying separate data
directories using the ``datadir`` argument.

To begin, install the Dash Core wallet for your system according to the
:ref:`installation instructions <dashcore-installation>`. When you get
to the step **Running Dash Core for the first time**, you can decide
whether you want to maintain separate ``wallet.dat`` files in the
default location (simpler if you do not need to run the wallets
simultaneously), or specify entirely separate data directories such as
e.g. ``C:\Dash1`` (simpler if you do want to run the wallets
simultaneously).


Separate wallet.dat files
~~~~~~~~~~~~~~~~~~~~~~~~~

For this scenario, we will create two shortcuts on the desktop, each
using a different wallet file. Navigate to the binary file used to start
Dash Core (typically locatd at ``C:\Program Files\DashCore\dash-qt.exe``
or similar) and create two shortcuts on the desktop. Then open the
**Properties** window for each of these shortcuts.

.. figure:: img/shortcuts.png
   :height: 250px

   Creating desktop shortcuts using Windows 10

Modify the **Target** property of each shortcut to point to a different
wallet file by specifying the ``wallet`` argument when starting the
wallet. If you do not specify a ``wallet`` argument, ``wallet.dat`` will
be used by default. The specified wallet file will be created if it does
not exist. The following example demonstrates two wallets named
``workwallet.dat`` and ``homewallet.dat``:

- Wallet Target 1: ``"C:\Program Files\DashCore\dash-qt.exe" -wallet=workwallet.dat``
- Wallet Target 2: ``"C:\Program Files\DashCore\dash-qt.exe" -wallet=homewallet.dat``

.. figure:: img/walletfiles.png
   :height: 250px

   Specifying separate wallet files

You can now use the two icons to quickly and easily open different
wallets from your desktop. Note that you cannot open both wallets
simultaneously. To do this, you will need two separate data directories,
as described below.


Separate data directories
~~~~~~~~~~~~~~~~~~~~~~~~~

Start Dash Core and allow it to synchronize with the network, then close
Dash Core again. You can now create two directories at e.g. ``C:\Dash1``
and ``C:\Dash2`` and copy the ``blocks`` and ``chainstate`` directories
from the synchronized data directory into the new directories. Each of
these will serve as a separate data directory, allowing you to run two
instances of Dash Core simultaneously. Create two (or more) shortcuts on
your desktop as described above, then specify arguments for ``datadir``
as shown below:

- Datadir Target 1: ``"C:\Program Files\DashCore\dash-qt.exe" -datadir=C:\Dash1 -listen=0``
- Datadir Target 2: ``"C:\Program Files\DashCore\dash-qt.exe" -datadir=C:\Dash2 -listen=0``

.. figure:: img/datadirs.png
   :height: 250px

   Specifying separate datadirs

You can now use the two icons to quickly and easily open different
wallets simultaneously from your desktop. Both wallets maintain separate
and full copies of the blockchain, which may use a lot of drive space.
For more efficient use of drive space, consider using an SPV or "light"
wallet such as :ref:`Dash Electrum <dash-electrum-wallet>` to maintain
multiple separate wallets without keeping a full copy of the blockchain.

.. figure:: img/2wallets.png
   :height: 250px

   Two instances of Dash Core running simultaneously

KeePass
=======

.. warning::
  KeePass support was removed in Dash Core 18.0.0. Details can still be
  found in `previous versions of this documentation 
  <https://docs.dash.org/en/0.17.0/wallets/dashcore/advanced.html#keepass>`_.
