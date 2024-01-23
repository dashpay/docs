.. meta::
   :description: Technical guides for developers integrating Dash.
   :keywords: dash, merchants, API, SDK, instantsend, python, .NET, java, javascript, nodejs, php, objective-c

.. _integration:

====================
Integration Overview
====================

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Dash_IntegrationOverview.pdf>`__.

`Dash Core <https://github.com/dashpay/dash/releases>`__ is a fork of `Bitcoin
Core <https://github.com/bitcoin/bitcoin>`__ and shares many common
functionalities. Key differences are found in existing JSON-RPC commands which
have been customized to support unique functionalities such as InstantSend.

The Basics
==========

Dash is a Proof of Work network, and similar to Bitcoin, Dash has a mining
network but uses a different block hashing algorithm. Dash serves as an
improvement of Bitcoin's shortcomings by offering a robust solution for instant
transactions, enhancing user privacy, and offering a self-sustainable
decentralized governance model.

Notably, Dash InstantSend provides a mechanism for zero-confirmation
transactions to be safely accepted and re-spent. InstantSend also provides
enhanced security compared to the conventional practice of waiting for multiple
block confirmations. Therefore, :ref:`implementing InstantSend
<integration-instantsend>` is the recommended best practice for all Dash
integrations.

- Block time: ~2.6 minutes per block
- Github source: https://github.com/dashpay/dash
- Latest release: https://github.com/dashpay/dash/releases/latest

JSON-RPC Interface
------------------

The majority of commands are unchanged from Bitcoin making integration into
existing systems relatively straightforward. For a complete listing of RPC
commands please refer to the :ref:`​Dash Developer Guide
<core:guide-index>`.

Note that the following commands have been modified to support InstantSend:

   - :ref:`getrawmempool <core:api-rpc-blockchain-getrawmempool>`
   - :ref:`getmempoolancestors <core:api-rpc-blockchain-getmempoolancestors>`
   - :ref:`getmempooldescendants <core:api-rpc-blockchain-getmempooldescendants>`
   - :ref:`getmempoolentry <core:api-rpc-blockchain-getmempoolentry>`
   - :ref:`getrawtransaction <core:api-rpc-raw-transactions-getrawtransaction>`
   - :ref:`gettransaction <core:api-rpc-wallet-gettransaction>`
   - :ref:`listtransactions <core:api-rpc-wallet-listtransactions>`
   - :ref:`listsinceblock <core:api-rpc-wallet-listsinceblock>`

Special Transactions
--------------------

Dash Core v0.13.0 introduced the concept of “Special Transactions” as specified
in `DIP002 <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__. Special
Transactions provide a more native way to implement additional features which do
not fit into the original concept of transactions. Please see the :ref:`Special
Transactions <integration-special-transactions>` section below for more
information.

Block Hashing Algorithm
-----------------------

Dash uses the X11 algorithm in place of SHA256 used in Bitcoin. It’s important
to note, however, that this only affects the hashing of the block itself. All
other internals utilize SHA256 hashes (transactions, merkle root, etc.), which
allows for most existing libraries to work in the Dash ecosystem. 


.. _integration-special-transactions:

Special Transactions
====================

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-Transaction-Types.pdf>`__.

Dash 0.13.0 and higher implement `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__, 
which form a basis for new transaction types that provide on-chain
metadata to assist various consensus mechanisms. The following special
transaction types exist:

+---------+------+----------------+---------------------------------------------------------------+
| Version | Type | Payload Size   | Transaction Purpose / Example                                 |
+=========+======+================+===============================================================+
| 3       | 0    | n/a            | Standard Transaction                                          |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 1    | variable       | :ref:`Masternode Registration <core:ref-txs-proregtx>`        |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 2    | variable       | :ref:`Update Masternode Service <core:ref-txs-proupservtx>`   |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 3    | variable       | :ref:`Update Masternode Operator <core:ref-txs-proupregtx>`   |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 4    | variable       | :ref:`Masternode Revocation <core:ref-txs-prouprevtx>`        |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 5    | variable       | :ref:`Masternode List Merkle Proof <core:ref-txs-cbtx>`       |
+---------+------+----------------+---------------------------------------------------------------+
| 3       | 6    | variable       | :ref:`Quorum Commitment <core:ref-txs-qctx>`                  |
+---------+------+----------------+---------------------------------------------------------------+

Integration notes:

1. `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__ 
   introduced a new Transaction Version and related “Payload” to the network.

2. Integrated Systems must be able to `serialize and deserialize <https://github.com/dashpay/dips/blob/master/dip-0002.md#serialization-hashing-and-signing>`__ 
   these new Transaction Types to accurately encode and decode
   Raw Transaction data.

3. From a `backwards compatibility <https://github.com/dashpay/dips/blob/master/dip-0002.md#compatibility>`__ 
   perspective, the 4 byte (32-bit) ``version`` field included in Classical
   Transactions was split into two fields: ``version`` and ``type``
   (each consisting of 2 bytes).

4. Refer to the :ref:`Special Transactions <core:ref-txs-special-txs>` 
   section of the Dash developer reference for additional detail on
   these data types, e.g. <variable int>.

5. :ref:`InstantSend <integration-instantsend>` status and Payload JSON
   (e.g. ``proRegTx``) is included in the JSON-RPC response, please note
   that this data is not part of the calculated hash and is provided for
   convenience.

See the `transaction types integration documentation (PDF) <https://github.com/dashpay/docs/raw/master/binary/integration/Integration-Resources-Transaction-Types.pdf>`__
for worked examples of each transaction type.


.. _integration-instantsend:

InstantSend
===========

This documentation is also available as a `PDF <https://github.com/dashpay/docs/raw/master/binary/integration/Dash_v0.14_LLMQ_InstantSend.pdf>`__.

InstantSend is a feature provided by the Dash network that allows for
zero-confirmation transactions to be safely accepted and re-spent. The
network attempts to lock the inputs of every valid transaction when it
is broadcast to the network. Every secured transaction is included in a
following block in accordance with standard blockchain principles.
Transactions are typically locked by InstantSend within 3 seconds of
being propagated to the network.

InstantSend is enabled by the Masternode Network which comprises
several thousand masternode servers. These nodes are differentiated
from standard nodes by having proven ownership of 1,000 Dash, making the
network `highly resistant to Sybil attacks <https://en.wikipedia.org/wiki/Sybil_attack>`__. 
Masternodes form `Long-Living Masternode Quorums (LLMQs) <https://github.com/dashpay/dips/blob/master/dip-0006.md>`__, 
which are responsible for providing near-instant certainty to the transaction
participants that the transaction inputs cannot be re-spent, and that the
transaction will be included in a following block instead of a conflicting
transaction. 

This concept works as an extension to Nakamoto Consensus to provide additional
security. InstantSend enables transacted funds to be immediately and securely
re-spent by the recipient, even before the transaction is included in a block.


Receiving InstantSend Transactions
----------------------------------

.. note::

   An "InstantSend Transaction" is simply a standard transaction
   that has been provided additional assurances by the masternode
   network. As a result, and from an integration perspective, the
   only technical difference is the InstantSend status.

Receiving an InstantSend Transaction introduces two requirements:

1. The ability to determine the “InstantSend Status” of a given 
   transaction.

2. The ability to adjust “Confirmation Status” independently of block 
   confirmation.

InstantSend Status is provided by the dash daemon, typically through a direct
connection (e.g. RPC), :ref:`ZMQ notification
<core:examples-receiving-zmq-notifications>`, or through the usage of an
external wallet notification script.

Direct Connection
^^^^^^^^^^^^^^^^^

InstantSend Status can be identified through direct connection with the Dash
daemon using JSON-RPC protocol. The ``instantlock`` attribute of the JSON
response reflects the status of the transaction and is included in the following
commands:

- :ref:`getrawmempool <core:api-rpc-blockchain-getrawmempool>`
- :ref:`getmempoolancestors <core:api-rpc-blockchain-getmempoolancestors>`
- :ref:`getmempooldescendants <core:api-rpc-blockchain-getmempooldescendants>`
- :ref:`getmempoolentry <core:api-rpc-blockchain-getmempoolentry>`
- :ref:`getrawtransaction <core:api-rpc-raw-transactions-getrawtransaction>`
- :ref:`gettransaction <core:api-rpc-wallet-gettransaction>`
- :ref:`listtransactions <core:api-rpc-wallet-listtransactions>`
- :ref:`listsinceblock <core:api-rpc-wallet-listsinceblock>`

ZMQ Notification
^^^^^^^^^^^^^^^^

Whenever a transaction enters the mempool and whenever a transaction is locked
in the mempool, ZMQ notifications can be broadcast by the node. Refer to `the
list of possible ZMQ notifications
<https://github.com/dashpay/dash/blob/master/doc/zmq.md#usage>`__ for more
details.

The following notifications are relevant for recognizing transactions
and their corresponding instantlocks:

- zmqpubhashtx
- zmqpubhashtxlock
- zmqpubrawtx
- zmqpubrawtxlock

Wallet Notification
^^^^^^^^^^^^^^^^^^^

The Dash Core Daemon can be configured to execute an external script whenever an
InstantSend transaction relating to that wallet is observed. This is configured
by adding the following line to the dash.conf file::

  instantsendnotify=/path/to/concurrent/safe/handler %s

This is typically used with a wallet that has been populated with 
`watch-only <https://docs.dash.org/projects/core/en/stable/docs/resources/glossary.html#watch-only-address>`__ 
addresses.

.. _is-broadcast:

Broadcasting InstantSend Transactions
-------------------------------------

.. tip::
   
   Because all transactions on the Dash network are automatically InstantSend,
   no procedural changes are required to broadcast transactions as InstantSend.

Since Dash v0.14.0 established LLMQs on the Dash network, quorums will
now attempt to lock every valid transaction by default without any
additional fee or action by the sending wallet or user. A transaction is
eligible for InstantSend when each of its inputs is considered
confirmed. This is the case when at least one of the following
circumstances is true: 

- the previous transaction referred to by the input is confirmed with 6 
  blocks
- the previous transaction is confirmed through an older InstantSend 
  lock
- the block containing the previous transaction is `ChainLocked <https://github.com/dashpay/dips/blob/master/dip-0008.md>`__

When checking the previous transaction for an InstantSend lock, it is
important to do this on mempool (non-mined) transactions. This
allows chained InstantSend locking.

Additional Resources
--------------------

The following resources provide additional information about InstantSend
and are intended to help provide a more complete understanding of the
underlying technologies.

- `InstantSend Technical Information <https://github.com/dashpay/dash/blob/master/doc/instantsend.md#zmq>`__
- :ref:`InstantSend Developer Documentation <core:guide-features-instantsend>`
- :ref:`Receiving ZMQ notifications <core:examples-receiving-zmq-notifications>`
- `DIP0010: LLMQ InstantSend <https://github.com/dashpay/dips/blob/master/dip-0010.md>`__
- `Product Brief: Dash Core v0.14 Release <https://blog.dash.org/product-brief-dash-core-release-v0-14-0-now-on-testnet-8f5f4ad45c96>`__

.. _integration-chainlocks:

ChainLocks
==========

ChainLocks are a feature provided by the Dash Network which provides certainty
when accepting payments. This technology, particularly when used in parallel
with :ref:`InstantSend <instantsend>`, creates an environment in which payments
can be accepted immediately and without the risk of “Blockchain Reorganization
Events”.

The risk of blockchain reorganization is typically addressed by requiring
multiple :term:`confirmations` before a transaction can be safely accepted as
payment. This type of indirect security is effective, but at a cost of time and
user experience. ChainLocks are a solution for this problem.

Receiving ChainLocks
--------------------

.. note::

   Once a ChainLock is observed for a block, each transaction in that block and
   all previous blocks can be considered irreversibly and fully confirmed.

Receiving a ChainLock introduces two requirements:

1. The ability to determine the “ChainLock Status” of a given block or
   transaction.

2. The ability to adjust “Confirmation Status” independently of block
   confirmation.

ChainLock status is provided by the dash daemon, typically through a direct
connection (e.g. RPC) or by a :ref:`ZMQ notification
<core:examples-receiving-zmq-notifications>`.

Direct Connection
^^^^^^^^^^^^^^^^^

ChainLock status can be identified through direct connection with the Dash
daemon using JSON-RPC protocol. The boolean ``chainlock`` attribute of the JSON
response reflects the ChainLock status of the block or transaction and is
included in the following commands:

- :ref:`getblock <core:api-rpc-blockchain-getblock>`
- :ref:`getblockheader <core:api-rpc-blockchain-getblockheader>`
- :ref:`getblockheaders <core:api-rpc-blockchain-getblockheaders>`
- :ref:`getrawtransaction <core:api-rpc-raw-transactions-getrawtransaction>`
- :ref:`gettransaction <core:api-rpc-wallet-gettransaction>`
- :ref:`listtransactions <core:api-rpc-wallet-listtransactions>`
- :ref:`listsinceblock <core:api-rpc-wallet-listsinceblock>`

ZMQ Notification
^^^^^^^^^^^^^^^^

ChainLock signatures are created shortly after the related block has been mined.
As a result it is recommended that integrated clients use :ref:`ZMQ (ZeroMQ)
notifications <core:examples-receiving-zmq-notifications>` in order to ensure
that this information is received as promptly as possible. Refer to `the
list of possible ZMQ notifications
<https://github.com/dashpay/dash/blob/master/doc/zmq.md#usage>`__ for more
details.

The following notifications are relevant for recognizing blocks and their
corresponding ChainLocks:

- zmqpubhashblock
- zmqpubhashchainlock
- zmqpubrawblock
- zmqpubrawchainlock
- zmqpubrawchainlocksig

This sample code uses the `js-dashd-zmq library
<https://github.com/dashpay/js-dashd-zmq>`__ to listen for ChainLock ZMQ
notifications and return the hash of blocks that receive a ChainLock. 

.. code-block:: javascript
   :caption: Subscribe to ChainLock hash ZMQ notifications

   const { ChainLock } = require('@dashevo/dashcore-lib');
   const ZMQClient = require('@dashevo/dashd-zmq');
   const client = new ZMQClient({
      protocol: 'tcp',
      host: '0.0.0.0',
      port: '20009',
   });

   (async () => {
      await client.connect();
      client.subscribe(ZMQClient.TOPICS.hashchainlock);
      client.on(ZMQClient.TOPICS.hashchainlock, async (hashChainLockMessage) => {
         console.log(`ChainLock received for block ${hashChainLockMessage}`)
      });
   })();

Wallet Notification
^^^^^^^^^^^^^^^^^^^

The Dash Core daemon can be configured to execute an external script whenever a
ChainLock is received. This is configured by adding the following line to the
dash.conf file::

  chainlocknotify=/path/to/concurrent/safe/handler %s

Additional Resources
--------------------

The following resources provide additional information about InstantSend and are
intended to help provide a more complete understanding of the underlying
technologies.

- :ref:`ChainLock Developer Documentation <core:guide-features-chainlocks>`
- :ref:`Receiving ZMQ notifications <core:examples-receiving-zmq-notifications>`
- `DIP0008: ChainLocks <https://github.com/dashpay/dips/blob/master/dip-0008.md>`__
- `Product Brief: Dash Core v0.14 Release <https://blog.dash.org/product-brief-dash-core-release-v0-14-0-now-on-testnet-8f5f4ad45c96>`__
