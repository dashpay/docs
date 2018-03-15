.. _electrum_advanced_functions:

==================
Advanced Functions
==================

.. _electrum_cold_storage:

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

This section will show you how to sign a transaction with an offline
Dash Electrum wallet using the command line.

Create an unsigned transaction
------------------------------

With your online (watching-only) wallet, create an unsigned transaction::

  electrum payto Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq 0.1 --unsigned > unsigned.txn

The unsigned transaction is stored in a file named ‘unsigned.txn’. Note
that the –unsigned option is not needed if you use a watching-only
wallet.

You may view it using::

  cat unsigned.txn | electrum deserialize -

Sign the transaction
--------------------

The serialization format of Electrum contains the master public key
needed and key derivation used by the offline wallet to sign the
transaction. Thus we only need to pass the serialized transaction to the
offline wallet::

  cat unsigned.txn | electrum signtransaction - > signed.txn

The command will ask for your password, and save the signed transaction in ‘signed.txn’.

Broadcast the transaction
-------------------------

Send your transaction to the Dash network, using broadcast::

  cat signed.txn | electrum broadcast -

If successful, the command will return the ID of the transaction.

How to accept Dash on a website using Electrum
==============================================

This tutorial will show you how to accept dash on a website with SSL
signed payment requests. It is updated for Electrum 2.6.

Requirements
------------

- A webserver serving static HTML
- A SSL certificate (signed by a CA)
- Electrum version >= 2.6

Create a wallet
---------------

Create a wallet on your web server::

  electrum create

You can also use a watching only wallet (restored from xpub), if you
want to keep private keys off the server. Once your wallet is created,
start Electrum as a daemon::

  electrum daemon start

Add your SSL certificate to your configuration
----------------------------------------------

You should have a private key and a public certificate for your domain.
Create a file that contains only the private key::

  -----BEGIN PRIVATE KEY-----
  your private key
  -----BEGIN END KEY-----

Set the path to your the private key file with setconfig::

  electrum setconfig ssl_privkey /path/to/ssl.key

Create another file that contains your certificate and the list of
certificates it depends on, up to the root CA. Your certificate must be
at the top of the list, and the root CA at the end::

  -----BEGIN CERTIFICATE-----
  your cert
  -----END CERTIFICATE-----
  -----BEGIN CERTIFICATE-----
  intermediate cert
  -----END CERTIFICATE-----
  -----BEGIN CERTIFICATE-----
  root cert
  -----END CERTIFICATE-----

Set the `ssl_chain` path with setconfig::

  electrum setconfig ssl_chain /path/to/ssl.chain

Configure a requests directory
------------------------------

This directory must be served by your webserver (eg Apache)::

  electrum setconfig requests_dir /var/www/r/

By default, electrum will display local URLs, starting with ‘file://‘ In
order to display public URLs, we need to set another configuration
variable, `url_rewrite`. For example::

  electrum setconfig url_rewrite "['file:///var/www/','https://electrum.org/']"

Create a signed payment request
-------------------------------

::

  electrum addrequest 3.14 -m "this is a test"
  {
     "URI": "dash:Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq?amount=3.14&r=https://electrum.org/r/7c2888541a",
     "address": "Xtdw4fezqbSpC341vcr8u9HboiJMFa9gBq",
     "amount": 314000000,
     "amount (DASH)": "3.14",
     "exp": 3600,
     "id": "7c2888541a",
     "index_url": "https://electrum.org/r/index.html?id=7c2888541a",
     "memo": "this is a test",
     "request_url": "https://electrum.org/r/7c2888541a",
     "status": "Pending",
     "time": 1450175741
  }

This command returns a json object with two URLs:

- `request_url` is the URL of the signed BIP70 request.
- `index_url` is the URL of a webpage displaying the request.

Note that request_url and index_url use the domain name we defined in
`url_rewrite`. You can view the current list of requests using the
`listrequests` command.

Open the payment request page in your browser
---------------------------------------------

Let us open `index_url` in a web browser.

.. figure:: img/payrequest.png
   :width: 200px

   Payment request page in a web browser

The page shows the payment request. You can open the dash: URI with a
wallet, or scan the QR code. The bottom line displays the time remaining
until the request expires.

.. figure:: img/payreq_window.png
   :width: 400px

   Wallet awaiting payment

This page can already be used to receive payments. However, it will not
detect that a request has been paid; for that we need to configure
websockets.

Add web sockets support
-----------------------

Get SimpleWebSocketServer from here::

  git clone https://github.com/ecdsa/simple-websocket-server.git

Set `websocket_server` and `websocket_port` in your config::

  electrum setconfig websocket_server <FQDN of your server>
  electrum setconfig websocket_port 9999

And restart the daemon::

  electrum daemon stop
  electrum daemon start

Now, the page is fully interactive: it will update itself when the
payment is received. Please notice that higher ports might be blocked on
some client’s firewalls, so it is more safe for example to reverse proxy
websockets transmission using standard 443 port on an additional
subdomain.

JSONRPC interface
-----------------

Commands to the Electrum daemon can be sent using JSONRPC. This is
useful if you want to use electrum in a PHP script.

Note that the daemon uses a random port number by default. In order to
use a stable port number, you need to set the `rpcport` configuration
variable (and to restart the daemon)::

  electrum setconfig rpcport 7777

With this setting, we can perform queries using curl or PHP. Example::

  curl --data-binary '{"id":"curltext","method":"getbalance","params":[]}' http://127.0.0.1:7777

Query with named parameters::

  curl --data-binary '{"id":"curltext","method":"listaddresses","params":{"funded":true}}' http://127.0.0.1:7777

Create a payment request::

  curl --data-binary '{"id":"curltext","method":"addrequest","params":{"amount":"3.14","memo":"test"}}' http://127.0.0.1:7777

The Python Console
==================

Most Electrum commands are available not only using the command-line,
but also in the GUI Python console. The results are Python objects, even
though they are sometimes rendered as JSON for clarity. Let us call
`listunspent()`, to see the list of unspent outputs in the wallet::

  >> listunspent()
  [
   {
       "address": "12cmY5RHRgx8KkUKASDcDYRotget9FNso3",
       "index": 0,
       "raw_output_script": "76a91411bbdc6e3a27c44644d83f783ca7df3bdc2778e688ac",
       "tx_hash": "e7029df9ac8735b04e8e957d0ce73987b5c9c5e920ec4a445130cdeca654f096",
       "value": 0.01
   },
   {
       "address": "1GavSCND6TB7HuCnJSTEbHEmCctNGeJwXF",
       "index": 0,
       "raw_output_script": "76a914aaf437e25805f288141bfcdc27887ee5492bd13188ac",
       "tx_hash": "b30edf57ca2a31560b5b6e8dfe567734eb9f7d3259bb334653276efe520735df",
       "value": 9.04735316
   }
  ]

Note that the result is rendered as JSON. However, if we save it to a
Python variable, it is rendered as a Python object::

  >> u = listunspent()
  >> u
  [{'tx_hash': u'e7029df9ac8735b04e8e957d0ce73987b5c9c5e920ec4a445130cdeca654f096', 'index': 0, 'raw_output_script': '76a91411bbdc6e3a27c44644d83f783ca7df3bdc2778e688ac', 'value': 0.01, 'address': '12cmY5RHRgx8KkUKASDcDYRotget9FNso3'}, {'tx_hash': u'b30edf57ca2a31560b5b6e8dfe567734eb9f7d3259bb334653276efe520735df', 'index': 0, 'raw_output_script': '76a914aaf437e25805f288141bfcdc27887ee5492bd13188ac', 'value': 9.04735316, 'address': '1GavSCND6TB7HuCnJSTEbHEmCctNGeJwXF'}]

This makes it possible to combine Electrum commands with Python. For example, let us pick only the addresses in the previous result::

  >> map(lambda x:x.get('address'), listunspent())
  [
   "12cmY5RHRgx8KkUKASDcDYRotget9FNso3",
   "1GavSCND6TB7HuCnJSTEbHEmCctNGeJwXF"
  ]

Here we combine two commands, listunspent and dumpprivkeys, in order to
dump the private keys of all adresses that have unspent outputs::

  >> dumpprivkeys( map(lambda x:x.get('address'), listunspent()) )
  {
   "12cmY5RHRgx8KkUKASDcDYRotget9FNso3": "***************************************************",
   "1GavSCND6TB7HuCnJSTEbHEmCctNGeJwXF": "***************************************************"
  }

Note that dumpprivkey will ask for your password if your wallet is
encrypted. The GUI methods can be accessed through the gui variable. For
example, you can display a QR code from a string using
`gui.show_qrcode`. Example::

  gui.show_qrcode(dumpprivkey(listunspent()[0]['address']))

Simple Payment Verification
===========================

Simple Payment Verification (SPV) is a technique described in Satoshi
Nakamoto’s paper. SPV allows a lightweight client to verify that a
transaction is included in the Bitcoin blockchain, without downloading
the entire blockchain. The SPV client only needs download the block
headers, which are much smaller than the full blocks. To verify that a
transaction is in a block, a SPV client requests a proof of inclusion,
in the form of a Merkle branch.

SPV clients offer more security than web wallets, because they do not
need to trust the servers with the information they send.

Reference: `Bitcoin: A peer-to-peer Electronic Cash System
<http://bitcoin.org/bitcoin.pdf>`_

Electrum protocol specification
===============================

Stratum is a universal Dash communication protocol used
mainly by Dash client Electrum and miners.

Format
------

Stratum protocol is based on `JSON-RPC 2.0`_ (although it doesn't
include "jsonrpc" information in every message). Each
message has to end with a line end character (\n).

.. _JSON-RPC 2.0: http://www.jsonrpc.org/specification

Request
^^^^^^^

Typical request looks like this::

   { "id": 0, "method":"some.stratum.method", "params": [] }

- id begins at 0 and every message has its unique id number
- list and description of possible methods is below
- params is an array, e.g.: [ "1myfirstaddress", "1mysecondaddress", "1andonemoreaddress" ]

Response
^^^^^^^^

Responses are similar::

   { "id": 0, "result": "616be06545e5dd7daec52338858b6674d29ee6234ff1d50120f060f79630543c"}

- id is copied from the request message (this way client can pair each
  response to one of his requests)
- result can be:

  - null
  - a string (as shown above)
  - a hash, e.g.::

    { "nonce": 1122273605, "timestamp": 1407651121, "version": 2, "bits": 406305378 }

  - an array of hashes, e.g.:

    [ 
      { 
        "tx_hash:
        "b87bc42725143f37558a0b41a664786d9e991ba89d43a53844ed7b3752545d4f",
        "height": 314847 }, { "tx_hash":
        "616be06545e5dd7daec52338858b6674d29ee6234ff1d50120f060f79630543c",
        "height": 314853 
      }
    ]

Methods
-------

server.version
^^^^^^^^^^^^^^

This is usually the first client's message, plus it's sent every minute
as a keep-alive message. Client sends its own version and version of the
protocol it supports. Server responds with its supported version of the
protocol (higher number at server-side is usually compatible).

The version of the protocol being explained in this documentation is:
0.10.

*request::*

  { "id": 0, "method": "server.version", "params": [ "1.9.5", "0.6" ] }

*response::*

  { "id": 0, "result": "0.8" }

server.banner
^^^^^^^^^^^^^

*request::*

  { "id": 1, "method": "server.banner", "params": [] }

server.donation_address
^^^^^^^^^^^^^^^^^^^^^^^

server.peers.subscribe
^^^^^^^^^^^^^^^^^^^^^^

Client can this way ask for a list of other active servers. Servers are
connected to an IRC channel (#electrum at freenode.net) where they can
see each other. Each server announces its version, history pruning limit
of every address ("p100", "p10000" etc.–the number means how many
transactions the server may keep for every single address) and supported
protocols ("t" = tcp@50001, "h" = http@8081, "s" = tcp/tls@50002, "g" =
https@8082; non-standard port would be announced this way: "t3300" for
tcp on port 3300).


**Note:** At the time of writing there isn't a true subscription
implementation of this method, but servers only send one-time response.
They don't send notifications yet.

*request::*

  { "id": 3, "method": "server.peers.subscribe", "params": [] }

*response::*

  { "id": 3, "result": [ [ "83.212.111.114",
  "electrum.stepkrav.pw", [ "v0.9", "p100", "t", "h", "s",
  "g" ] ], [ "23.94.27.149", "ultra-feather.net", [ "v0.9",
  "p10000", "t", "h", "s", "g" ] ], [ "88.198.241.196",
  "electrum.be", [ "v0.9", "p10000", "t", "h", "s", "g" ] ] ]
  }

blockchain.numblocks.subscribe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A request to send to the client notifications about new blocks height.
Responds with the current block height.

*request::*

  { "id": 5, "method": "blockchain.numblocks.subscribe", "params": [] }

*response::*

  { "id": 5, "result": 316024 }

*message::*

  { "id": null, "method": "blockchain.numblocks.subscribe", "params": 316024 }

blockchain.headers.subscribe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A request to send to the client notifications about new blocks in form
of parsed blockheaders.

*request::*

   { "id": 5, "method": "blockchain.headers.subscribe", "params": [] }

*response::*

  { "id": 5, "result": { "nonce":
  3355909169, "prev_block_hash":
  "00000000000000002b3ef284c2c754ab6e6abc40a0e31a974f966d8a2b4d5206",
  "timestamp": 1408252887, "merkle_root":
  "6d979a3d8d0f8757ed96adcd4781b9707cc192824e398679833abcb2afdf8d73",
  "block_height": 316023, "utxo_root":
  "4220a1a3ed99d2621c397c742e81c95be054c81078d7eeb34736e2cdd7506a03",
  "version": 2, "bits": 406305378 } }

*message::*

  { "id": null, "method":
  "blockchain.headers.subscribe", "params": [ { "nonce":
  881881510, "prev_block_hash":
  "00000000000000001ba892b1717690900ae476857120a78fb50825f8b67a42d4",
  "timestamp": 1408255430, "merkle_root":
  "8e92bdbf1c5c581b5942fc290c6c52c586f091b279ea79d4e21460e138023839",
  "block_height": 316024, "utxo_root":
  "060f780c0dd07c4289aaaa2ef24723f73380095b31d60795e1308170ec742ffb",
  "version": 2, "bits": 406305378 } ] }

blockchain.address.subscribe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A request to send to the client notifications when status (i.e.,
transaction history) of the given address changes. Status is a hash of
the transaction history. If there isn't any transaction for the address
yet, the status is null.

*request::*

   { "id": 6, "method":"blockchain.address.subscribe", "params": ["1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"] }

*response::*

   { "id": 6, "result":"b87bc42725143f37558a0b41a664786d9e991ba89d43a53844ed7b3752545d4f" }

*message::*

   { "id": null, "method":"blockchain.address.subscribe", "params": ["1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L","690ce08a148447f482eb3a74d714f30a6d4fe06a918a0893d823fd4aca4df580"]}

blockchain.address.get_history
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For a given address a list of transactions and their heights (and fees
in newer versions) is returned.

*request::*

   {"id": 1, "method": "blockchain.address.get_history", "params": ["1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"] }

*response::*

  {"id": 1, "result": [{"tx_hash": "ac9cd2f02ac3423b022e86708b66aa456a7c863b9730f7ce5bc24066031fdced", "height": 340235}, {"tx_hash": "c4a86b1324f0a1217c80829e9209900bc1862beb23e618f1be4404145baa5ef3", "height": 340237}]}
  {"jsonrpc": "2.0", "id": 1, "result": [{"tx_hash": "16c2976eccd2b6fc937d24a3a9f3477b88a18b2c0cdbe58c40ee774b5291a0fe", "height": 0, "fee": 225}]}


blockchain.address.get_mempool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

blockchain.address.get_balance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*request::*

  { "id": 1, "method":"blockchain.address.get_balance", "params":["1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"] }

*response::*

  {"id": 1, "result": {"confirmed": 533506535, "unconfirmed": 27060000}}


blockchain.address.get_proof
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

blockchain.address.listunspent
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*request::*

  { "id": 1, "method": "blockchain.address.listunspent", "params": ["1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"] }

*response::*

  {"id": 1, "result": [{"tx_hash":
  "561534ec392fa8eebf5779b233232f7f7df5fd5179c3c640d84378ee6274686b",
  "tx_pos": 0, "value": 24990000, "height": 340242},
  {"tx_hash":"620238ab90af02713f3aef314f68c1d695bbc2e9652b38c31c025d58ec3ba968",
  "tx_pos": 1, "value": 19890000, "height": 340242}]}

blockchain.utxo.get_address
^^^^^^^^^^^^^^^^^^^^^^^^^^^

blockchain.block.get_header
^^^^^^^^^^^^^^^^^^^^^^^^^^^

blockchain.block.get_chunk
^^^^^^^^^^^^^^^^^^^^^^^^^^

blockchain.transaction.broadcast
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Submits raw transaction (serialized, hex-encoded) to the network.
Returns transaction id, or an error if the transaction is invalid for
any reason.

*request::*

  { "id": 1, "method":
  "blockchain.transaction.broadcast", "params":
  "0100000002f327e86da3e66bd20e1129b1fb36d07056f0b9a117199e759396526b8f3a20780000000000fffffffff0ede03d75050f20801d50358829ae02c058e8677d2cc74df51f738285013c260000000000ffffffff02f028d6dc010000001976a914ffb035781c3c69e076d48b60c3d38592e7ce06a788ac00ca9a3b000000001976a914fa5139067622fd7e1e722a05c17c2bb7d5fd6df088ac00000000" }<br/>

*response::*

  {"id": 1, "result": "561534ec392fa8eebf5779b233232f7f7df5fd5179c3c640d84378ee6274686b"}

blockchain.transaction.get_merkle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  blockchain.transaction.get_merkle [$txid, $txHeight]

blockchain.transaction.get
^^^^^^^^^^^^^^^^^^^^^^^^^^

Method for obtaining raw transaction (hex-encoded) for given txid. If
the transaction doesn't exist, an error is returned.

*request::*

  { "id": 17, "method":"blockchain.transaction.get", "params": [
  "0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098"
  ] }

*response::*

  { "id": 17, "result":"01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0704ffff001d0104ffffffff0100f2052a0100000043410496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da7589379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858eeac00000000"}

*error::*

  { "id": 17, "error": "{ u'message': u'No information available about transaction', u'code': -5 }" }


blockchain.estimatefee
^^^^^^^^^^^^^^^^^^^^^^

Estimates the transaction fee per kilobyte that needs to be paid for a
transaction to be included within a certain number of blocks. If the
node doesn’t have enough information to make an estimate, the value -1
will be returned.

Parameter: How many blocks the transaction may wait before being
included.

*request::*

  { "id": 17, "method": "blockchain.estimatefee", "params": [ 6 ] }

*response::*

  { "id": 17, "result": 0.00026809 }
  { "id": 17, "result": 1.169e-05 }

*error::*

  { "id": 17, "result": -1 }


External links
--------------

- https://docs.google.com/a/palatinus.cz/document/d/17zHy1SUlhgtCMbypO8cHgpWH73V5iUQKk_0rWvMqSNs/edit?hl=en_US" original Slush's specification of Stratum protocol
- http://mining.bitcoin.cz/stratum-mining specification of Stratum mining extension

Electrum Wallet on Tor
======================

Masternodes in Electrum
=======================

Seeds and Change Addresses
==========================

Sweep a Paper Wallet
====================
