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
can click the **Toggle lock state** button to invert the locked/unlocked
state of all UTXOs. When you are ready to continue, click **OK**. You
can now safely create transactions with your remaining funds without
affecting the locked UTXOs.

.. image:: img/coin-selection-lock.png
   :width: 220px

.. figure:: img/coin-selection-locked.png
   :width: 180px

   Locking UTXOs in Dash Core wallet


.. _dashcore-hd:

HD Wallets
==========

Upgrade to HD
-------------

.. warning::

  A new backup must be created after upgrading to an HD wallet.

Since version 0.17.0.2, Dash Core has included the ability upgrade a
non-hierarchical deterministic (HD) wallet to an HD wallet via the
``upgradetohd`` command. The command can be run by either opening the console
from **Tools > Console** or issuing the following RPC command from
``dash-cli``::

  upgradetohd "" "" <walletpassphrase>

If your wallet is already encrypted you must enter the passphrase as the third
parameter to the command. If your wallet is not already encrypted, specifying a
wallet passphrase will trigger wallet encryption.

To see full details for the command, run the following from either the console
or ``dash-cli``::

  help upgradetohd

Create HD Wallet
----------------

Since version 0.12.2.0, Dash Core has included an implementation of
BIP39/BIP44 compatible hierarchical deterministic (HD) key generation.
This functionality is only available from the command line by specifying
the ``usehd`` option when starting Dash Core for the first time. Use
this function with care, since the mnemonic seed and keys will be stored
in plain text until you specify a wallet passphrase. Note that the
wallet passphrase is different to the mnemonic passphrase, which is
often also referred to as the "25th word" or "extension word". The
wallet passphrase encrypts the wallet file itself, while the mnemonic
passphrase is used to specify different derivation branches from the
same mnemonic seed.

We will use the Windows GUI wallet in this example, but the commands are
similar if using ``dash-qt`` or ``dashd`` on other operating systems.
Enter the following command to get started with a randomly generated HD
wallet seed and no mnemonic passphrase::

  dash-qt.exe --usehd=1

A new HD wallet will be generated and Dash Core will display a warning
informing you that you must encrypt your wallet after verifying it works
correctly. Open the console from **Tools > Console** or issue the
following RPC command from ``dash-cli`` to view the mnemonic seed::

  dumphdinfo

Dash Core will display the HD seed in both hexadecimal and as a BIP39
mnemonic. To restore an existing HD wallet, or define your own
separately generated mnemonic and/or passphrase, ensure no
``wallet.dat`` file exists in the ``datadir`` and enter the following
command::

  dash-qt.exe --usehd=1 --mnemonic="enter mnemonic" --mnemonicpassphrase="optional mnemonic passphrase"

The HD wallet will be restored and your balance will appear once sync is
complete.


.. _dashcore-multisig:

Multisignature
==============

This section presents a worked example to demonstrate multisig
functionality in Dash Core. While the transactions are no longer visible
on the current testnet blockchain and some address formats or RPC
responses may differ slightly from the version shown here, the principle
and commands are the same. The example demonstrates how to set up a
2-of-3 multisig address and create a transaction. The example parties
involved are a buyer, a seller and an arbiter. This example is based on:

- https://gist.github.com/jashmenn/9811198
- https://gist.github.com/gavinandresen/3966071
- https://bitcoin.org/en/developer-examples#p2sh-multisig

Step 1: Create three addresses
------------------------------

Seller::

  seller@testnet03:~$ ./dash-cli getnewaddress
  n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk
  seller@testnet03:~$ ./dash-cli validateaddress n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk
  {
      "isvalid" : true,
      "address" : "n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk",
      "ismine" : true,
      "isscript" : false,
      "pubkey" : "02a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e",
      "iscompressed" : true,
      "account" : ""
  }
  seller@testnet03:~$ ./dash-cli dumpprivkey n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk
  cVQVgBr8sW4FTPYz16BSCo1PcAfDhpJArgMPdLxKZQWcVFwMXRXx

Buyer::

  buyer@testnet03:~$ ./dash-cli getnewaddress
  mp5orHuaFaHCXFSCeYvUPL7H16JU8fKG6u
  buyer@testnet03:~$ ./dash-cli validateaddress mp5orHuaFaHCXFSCeYvUPL7H16JU8fKG6u
  {
      "isvalid" : true,
      "address" : "mp5orHuaFaHCXFSCeYvUPL7H16JU8fKG6u",
      "ismine" : true,
      "isscript" : false,
      "pubkey" : "0315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c",
      "iscompressed" : true,
      "account" : ""
  }
  buyer@testnet03:~$ ./dash-cli dumpprivkey mp5orHuaFaHCXFSCeYvUPL7H16JU8fKG6u
  cP9DFmEDb11waWbQ8eG1YUoZCGe59BBxJF3kk95PTMXuG9HzcxnU

Arbiter::

  arbiter@testnet03:~$ ./dash-cli getnewaddress
  n1cZSyQXhach5rrj2tm5wg6JC7uZ3qPNiN
  arbiter@testnet03:~$ ./dash-cli validateaddress n1cZSyQXhach5rrj2tm5wg6JC7uZ3qPNiN
  {
      "isvalid" : true,
      "address" : "n1cZSyQXhach5rrj2tm5wg6JC7uZ3qPNiN",
      "ismine" : true,
      "isscript" : false,
      "pubkey" : "0287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce",
      "iscompressed" : true,
      "account" : ""
  }
  arbiter@testnet03:~$ ./dash-cli dumpprivkey n1cZSyQXhach5rrj2tm5wg6JC7uZ3qPNiN
  cUbDFL81a2w6urAGZf7ecGbdzM82pdHLeCaPXdDp71s96SzDV49M

This results in three keypairs (public/private)::

  seller:    02a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e / cVQVgBr8sW4FTPYz16BSCo1PcAfDhpJArgMPdLxKZQWcVFwMXRXx
  buyer:     0315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c / cP9DFmEDb11waWbQ8eG1YUoZCGe59BBxJF3kk95PTMXuG9HzcxnU
  arbiter:   0287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce / cUbDFL81a2w6urAGZf7ecGbdzM82pdHLeCaPXdDp71s96SzDV49M

Step 2: Create multisig address 
-------------------------------

The ``createmultisig`` command takes as variables the number n
signatures of m keys (supplied as json array) required. In this example,
2 of 3 keys are required to sign the transaction.

Note: The address can be created by anyone, as long as the public keys
and their sequence are known (resulting address and redeemScript are
identical, see below).

Seller::

  seller@testnet03:~$ ./dash-cli createmultisig 2 '["02a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e","0315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c","0287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce"]'
  {
      "address" : "2MuEQCZh7VB8pNrT4bj1CFZQh2oK7XZYLQf",
      "redeemScript" : "522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53ae"
  }

Buyer::

  buyer@testnet03:~$ ./dash-cli createmultisig 2 '["02a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e","0315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c","0287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce"]'
  {
      "address" : "2MuEQCZh7VB8pNrT4bj1CFZQh2oK7XZYLQf",
      "redeemScript" : "522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53ae"
  }

Arbiter::

  arbiter@testnet03:~$ ./dash-cli createmultisig 2 '["02a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e","0315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c","0287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce"]'
  {
      "address" : "2MuEQCZh7VB8pNrT4bj1CFZQh2oK7XZYLQf",
      "redeemScript" : "522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53ae"
  }

Step 3: Buyer funds the multisig address
----------------------------------------

This works the same as a usual transaction.

Buyer::

  buyer@testnet03:~$ ./dash-cli sendtoaddress 2MuEQCZh7VB8pNrT4bj1CFZQh2oK7XZYLQf 777.77
  a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951

The seller/arbiter can trace the transaction by its txid in the block
explorer. Or from the console as follows.

Buyer::

  seller@testnet03:~$ ./dash-cli getrawtransaction a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951 1
  {
      "hex" : "010000001a2e514dd90f666e3de4cddd22682ae1ca7225988656369d98228c742482fee16b010000006b48304502200ea8dddd404aac644fd382d3089480f2c9a6ce753a3c4fc0b12ac81afe8ffa3b022100d88f698a0d9fefbbf76240790530fe7e23bf6b354a1feedb4effa99813405b00012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff3181c52614be8742c36665b6a287a2d6c7970494b0a341ff9595c1c9a8f23aa2010000006b483045022041ee176da4df13adc782c9ff2afdb24c4e1b61b450895486388431bf1a88b81f02210082be1b3bd20d3f121c971fb745cba52523f6b8093ec93df5987c9beb302c19ac012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff332356f7d5e4264302ca4cc0f38d2a75a9b4c1df4bc4f94044f8a8fab81b7e1b010000006b483045022100dc322074961ae5e2e8cb11828301b1e083eff9ed6078aa064c52ed70d52737410220776b99c8552bbc2e644c7450ef8502d3497c3de7196b176f1c49cca18d1ff09f012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff388b56a8a74338ce10e931dc198ed25fa4cb7213e0ea9905d32a3e902366661f010000006b48304502206d2cdfe9af498e9e46f88d0bd881746bf2dae182664d03f7a635ff599bdee84b022100bf3a7b88ed80b30d8915a2ae34d546defbc9a660ebf941afb4aa29461e0b4c95012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff44578d7579bef2a204359f8c878993480b306193d954ee735c53f8b3e076c3ea010000006c4930460221008a67da5764934392437fa9e05483e4b29204fd5d78dea01f744d4a23c403881b022100c77e58307f58953b578de568138659b4efd2fadaec51917c2270fab0bd4a57a6012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff4a3b7b666ce8f249ef4f253b7f718fb5cc2f21f899608d319bcc04c75ec47353010000006b48304502203ca5a0559647ee0d1790714296396ca0bca27a3ef3e68f76706c63da9cd3684f0221008c9529f7a54d89440f8dca89c1c47725821012670d05a70681b57f182b069a74012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff4ab5d98908e4424929bfdba3d6402e6b45db60a622b4df8c73da1b37bdb949a4010000006b48304502210094da4e007ba94cdb47a8c4805dab4b93dc475a44340a9b6f6d7956d49749e3d3022077b94861995ffe3f59429bf5b873914d3c1157f23f018697650bc3bd2dc2de1f012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff4cd58c1ad5b0ffd8556deff402854d94a79222799916be8e0f88d0cca3c38c85010000006b483045022030e72eec0386c83489efff8f3c71aed8eec0265565cddeb1492aab6644cc63220221008d6df06656dae12dae573b860d65045f088e4df5e2127902231d8edd4196ef1d012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff501ff2345fc47b9b7749afcc32e790fdbe5d22fd96b2c5d0522d4cad0cd5566f010000006a47304402204e9bc23796974fdf323c49399ca7db76e2238630add4c617631549f4595af4a80220658038b14884c1a0d730de79c7e2769d4d28135ed7896e7aff01ca94c8edf7bb012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff5020fe72d4c1038213cc3e1b99f5b313c4b2d57f1e0d9abba90860dc5c38630a010000006a473044022071b7cca6a7d72fef4b46ad425c23c37f28c72501e5e61821f00e022c4c8ef49502200d8ba406fe336d64a8ae909cad20d0ffe302cd977900013ea72b37c488550625012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff59f32023d4225cc193182e81444f00f6d95652a9458daa08f4324ab4bdac7bed010000006b4830450221009e0f701840c01c2c37e2baec0ea2c43d517126107ef874c3d68f32dfa2e4f05f02206d1306dee274267598d5ab8d7c4c26346d25d8118b30a6921b9b238307916d6e012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff05b5b8ecaf7bcbd5fdfc64fd7dbd6ebfee18dcaf57e00b6711ba0abe4329eb23010000006a47304402200515822e6d9641c72f1af7968ba63d47463caffeca03733750b0866ef123fe00022071fd40bac12aa1d36244fc5391162b70ec306a5ed2dffef3a3d4995524317a10012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff09cc372e4409bcbacd85adb17918ca5b20427dc280b44bd4f234fb698ac07fc6010000006b483045022051e5c430110e8b0d85693c421031f14abf89bee1a14702e6655a1eaa2663927c0221009a54781fddd4093032507f12fe8a97ce926a743851a1a56c2ca70026ce98b7e6012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff0963f2cc80666835ae8c5939ac3011d2962ae88e872cdc13257cfb0188f83c7a010000006b483045022032fd819b1cdb8f506e27f26b3e46330c498b965386c3e96c34dceeff2a517cf7022100a4c34d77ed25116dc05ca7d783bd6cb91c1e38db0541878dac72f2d63d4b7c11012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff14cff38ccbdd840ffc491614e9b5167edb6ad6b9eeaf8e3dc30feaeefa39d820010000006c493046022100f4d6dfce7778acee6bdcf9f2ec39dbf902b6ca977b8622c886eadddefa01bf5502210089b3c2d23b5fc5b03d2d6ea4bf28f04b98342b02dd7d2020a6466bddd85c3d50012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff63750bbce93657a59fe3472fce714eafa09791fcf7f687f30a923162f2ba5196010000006c493046022100bbbf84829fcc2ec70bc6d77cfc69f512c1a14359958eee46243001908dc2a0ab0221008f1fbda61fcfccb78fe6d4e6385e8f508035676ef82654425bb704727f1e59b4012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff6466da482404f4a719f7eb16798d05878af2c36ad7174e2b68964693f39e954b010000006a47304402204d57344da5a1a29ea800215d19ada89787b1026f7e47c2f2f1ea0ef82bec5b6d02203039bd98546843a99d9e6749819875a4d996a682c57a192d9e5cef9b694a028b012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff8b0b4a84522fded19446eef3fdd94cc0f7449c71b6e0080837d5f240c78ce03b010000006c493046022100c152177ec49bb572d70976b53c10d0c4be55584975d657c43e87fbaac8c081ec0221009dd150697257cf769c3e90afbde88fbbe5f95c17c561883546537644ed628f6f012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff8d7078622b75fc2c3ea1094d07099b0e460a7f7a4c53cf225d066f919f17daf6010000006b483045022100e440d404867748cfba792119faae12d286b265a185cec86215fe2737ec1e7ca402207770447154f81564f7022b375943c2b7eaf3d05a3281c6f5c70328b098423d7d012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff98c23cc59412943bfedba3b4a48bb2f97f58c119946e5c492031c43a36dd576e010000006c493046022100910cf6fb057269e5e02fa44fc2ba03925d9e0e3232d3d5a66aac440db9627f9f022100b656d982dec47000de616f21a331b1fb5e19d1ab312c5845f5f1538dac4dd301012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff9d4851f00e3c2fa22816adc55703fcb539ae0fe218f369f23af079964a6225fc020000006c4930460221009918ee137e4aead4760c79dbe940556ae1ecb7935a653543b486f4198f16cc6a022100f82e04cd970f2c5fd8dd48813e38f87c10ed8fa7b45eec1854562948f9d43a1b012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffffa13c3221f0e08289657208bccf7b466ea5795c591751065a20b16f00892bd598010000006b483045022073d9fed13def14a655fd423f5c4fa63e46eeea76668cdf8bb89d96630890760d022100f70edce3513c9cbc671f92dc0b4d97c5edc0d9d26f4e726bb2d66776a3b9e411012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffffcac4f229bd19c47cd15ee9355af8383531a960ba0e0f3e8e4fa0a607ab2000d9010000006b483045022100967624e60a7670e849eb7500cf185620fd65de10d1e5f7cef9131d3c6403cb5f022005182af16fba1b7dbdd27a8935205b439c6034d566c6f14950aba6bb328cbf79012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffffcbf8cb94ee2bcda1c9ceb54feaf6815441f722b70c4f7569525cc9dee7cbbdc2010000006b4830450221008cfcfdc62f0a398e2419ebd56cf067e2abadf8116936250939b9fa763dd428680220052c6d316189d5f7164d2423aae99e97d05165f3e5c7d138e2858f0adab4ebba012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffffdbad6da5900987f77e5bcf714c935889fbea2d3ff388586a331fe42e0a82efe0010000006c493046022100e80d73130bcd25faa73764f4ff6c05e1b401f3960b7ef30b4244daaf5fce953a022100b99a55caaaa312df54c7d743791052c3e8392725becf91d2aa886d2e8259af10012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689fffffffffdc2d56fd131ae16837fc86e3015c9e78077dd36b6a2591cf1d500c584bbcc6a010000006b483045022100d13e5a55a4a71e039603bd2d3d76a757c63b1d199bcf340e3f2eeb5bed10897c022046a43ecc6cd8295981bde38c34c29708e402db59fc93e657196fc3032858d967012103954bfa8b6b1b0f1f5624ea2925b18cd1477fde2087eada1a51323a6617172689ffffffff0240d6de1b1200000017a91415c85c2472f5941b60a49462a2cfd0d17ab49d1c87c02fdf67000000001976a914b8d899f7193a7b3278be037b006c8f08998ebef388ac00000000",
      "txid" : "a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951",
      "version" : 1,
      "locktime" : 0,
  [...]
      "vout" : [
          {
              "value" : 777.77000000,
              "n" : 0,
              "scriptPubKey" : {
                  "asm" : "OP_HASH160 15c85c2472f5941b60a49462a2cfd0d17ab49d1c OP_EQUAL",
                  "hex" : "a91415c85c2472f5941b60a49462a2cfd0d17ab49d1c87",
                  "reqSigs" : 1,
                  "type" : "scripthash",
                  "addresses" : [
                      "2MuEQCZh7VB8pNrT4bj1CFZQh2oK7XZYLQf"
                  ]
              }
          },
  [...]
      ],
      "blockhash" : "000000034def806f348cadf6a80660aed1cfc30ccbd1492a8ea87062800ea94d",
      "confirmations" : 3,
      "time" : 1409224896,
      "blocktime" : 1409224896
  }

Step 4: Spending the multisig
-----------------------------

Now we assume the deal is complete, the buyer got the goods and everyone
is happy. Now the seller wants to get his Dash. As a 2-of-3 multisig was
used, the transaction must be signed by 2 parties (seller + buyer or
arbiter). The seller creates a transaction (we will reuse his public
address from above).

Seller::

  seller@testnet03:~$ ./dash-cli createrawtransaction '[{"txid":"a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951","vout":0}]' '{"n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk":777.77}'
  010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a80000000000ffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000

And partially signs it, using the redeemScript, scriptPubKey and his
private key

Seller::

  seller@testnet03:~$ ./dash-cli signrawtransaction '010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a80000000000ffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000' '[{"txid":"a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951","vout":0,"scriptPubKey":"a91415c85c2472f5941b60a49462a2cfd0d17ab49d1c87","redeemScript":"522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53ae"}]' '["cVQVgBr8sW4FTPYz16BSCo1PcAfDhpJArgMPdLxKZQWcVFwMXRXx"]'
  {
      "hex" : "010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a800000000b500483045022051a7f0e95a5066859ce37fe64a6e7ab6e30bfe9a68d9d3f1453064052eab5625022100c0067a33d2ee02478d89fc1a71f3a93c883db022e970886181c50ca9afc3dfa4014c69522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53aeffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000",
      "complete" : false
  }

Note that the output hex is getting longer, but complete flag is "false"
as the transaction needs another signature. So now either the buyer or
the arbiter can complete the signature of the transaction, using the
output from above and their private key. Let's assume the buyer is
completing the signature.

Buyer::

  buyer@testnet03:~$ ./dash-cli signrawtransaction '010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a800000000b500483045022051a7f0e95a5066859ce37fe64a6e7ab6e30bfe9a68d9d3f1453064052eab5625022100c0067a33d2ee02478d89fc1a71f3a93c883db022e970886181c50ca9afc3dfa4014c69522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53aeffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000' '[{"txid":"a8b3bf5bcace91a8dbbddbf9b7eb027efb9bd001792f043ecf7b558aaa3cb951","vout":0,"scriptPubKey":"a91415c85c2472f5941b60a49462a2cfd0d17ab49d1c87","redeemScript":"522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53ae"}]' '["cP9DFmEDb11waWbQ8eG1YUoZCGe59BBxJF3kk95PTMXuG9HzcxnU"]'
  {
      "hex" : "010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a800000000fdff0000483045022051a7f0e95a5066859ce37fe64a6e7ab6e30bfe9a68d9d3f1453064052eab5625022100c0067a33d2ee02478d89fc1a71f3a93c883db022e970886181c50ca9afc3dfa401493046022100dc3f61fdb7b8ea7ec729682d355646c922f5512054c4985534e6b91040c5bd660221008b48c117ec95814f573d33bca981cb703fdd9fa6e52aa8fe67423e06cad87215014c69522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53aeffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000",
      "complete" : true
  }

The signature is complete now, and either of the parties can transmit
the transaction to the network.

Buyer::

  buyer@testnet03:~$ ./dash-cli sendrawtransaction 010000000151b93caa8a557bcf3e042f7901d09bfb7e02ebb7f9dbbddba891ceca5bbfb3a800000000fdff0000483045022051a7f0e95a5066859ce37fe64a6e7ab6e30bfe9a68d9d3f1453064052eab5625022100c0067a33d2ee02478d89fc1a71f3a93c883db022e970886181c50ca9afc3dfa401493046022100dc3f61fdb7b8ea7ec729682d355646c922f5512054c4985534e6b91040c5bd660221008b48c117ec95814f573d33bca981cb703fdd9fa6e52aa8fe67423e06cad87215014c69522102a862b412ff9e3afd01a2873a02622897f6df92e3fc85597788b898309fec882e210315617694c9d93f0ce92769e050a6868ffc74d229077379c0af8bfb193c3d351c210287ce6cf69b85593ce7db801874c9a2fb1b653dbe5dd9ebfa73e98b710af9e9ce53aeffffffff0140d6de1b120000001976a914d728be76cd74b5d148eba2a49246b80dac12f73e88ac00000000
  cf1a75672006a05b38d94acabb783f81976c9e83a8de4da9cbec0de711cf2d71

Again, this transaction can be traced in a block explorer. And the
seller is happy to receive his coins at his public address as follows.

Seller::

  seller@testnet03:~$ dash-cli listtransactions "" 1
  [
      {
          "account" : "",
          "address" : "n18cPEtj4ZfToPZxRszUz2XPts4eGsxiPk",
          "category" : "receive",
          "amount" : 777.77000000,
          "confirmations" : 17,
          "blockhash" : "000000067a13e9bd5c1d5ff48cb4b9f8414a6adcc470656262731bfd013510dd",
          "blockindex" : 9,
          "blocktime" : 1409228449,
          "txid" : "cf1a75672006a05b38d94acabb783f81976c9e83a8de4da9cbec0de711cf2d71",
          "time" : 1409227887,
          "timereceived" : 1409227887
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

It is possible to select between different Dash wallets when starting
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
-------------------------

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
-------------------------

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
  KeePass support was removed in Dash Core 0.18.0. Details can still be
  found in `previous versions of this documentation 
  <https://docs.dash.org/en/0.17.0/wallets/dashcore/advanced.html#keepass>`_.
