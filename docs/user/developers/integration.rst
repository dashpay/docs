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

- Block time: ~2.6 minutes per block
- Github source: https://github.com/dashpay/dash
- Latest release: https://github.com/dashpay/dash/releases/latest

JSON-RPC Interface
------------------

The majority of commands are unchanged from Bitcoin making integration into
existing systems relatively straightforward. For a complete listing of RPC
commands please refer to the `​Dash Developer Guide
<https://dashcore.readme.io/docs/core-guide-introduction>`_.

Note that the following commands have been modified to support InstantSend:

   - `getrawmempool <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getrawmempool>`__
   - `getmempoolancestors <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempoolancestors>`__
   - `getmempooldescendants <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempooldescendants>`__
   - `getmempoolentry <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempoolentry>`__
   - `getrawtransaction <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-raw-transactions#getrawtransaction>`__
   - `gettransaction <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#gettransaction>`__
   - `listtransactions <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#listtransactions>`__
   - `listsinceblock <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#listsinceblock>`__

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

+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| Release | Version | Type | Payload Size   | Payload | Payload JSON | Transaction Purpose                                                                                                               |
+=========+=========+======+================+=========+==============+===================================================================================================================================+
| v0.13.0 | 3       | 0    | n/a            | n/a     | n/a          | Standard Transaction                                                                                                              |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 1    | <variable int> | <hex>   | proRegTx     | `Masternode Registration <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-pro-reg-tx>`__       |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 2    | <variable int> | <hex>   | proUpServTx  | `Update Masternode Service <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-pro-up-serv-tx>`__ |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 3    | <variable int> | <hex>   | proUpRegTx   | `Update Masternode Operator <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-pro-up-reg-tx>`__ |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 4    | <variable int> | <hex>   | proUpRevTx   | `Masternode Revocation <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-pro-up-rev-tx>`__      |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 5    | <variable int> | <hex>   | cbTx         | `Masternode List Merkle Proof <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-cb-tx>`__       |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+
| v0.13.0 | 3       | 6    | <variable int> | <hex>   | qcTx         | `Quorum Commitment <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions#section-qc-tx>`__                  |
+---------+---------+------+----------------+---------+--------------+-----------------------------------------------------------------------------------------------------------------------------------+

Integration notes:

1. `DIP002 Special Transactions <https://github.com/dashpay/dips/blob/master/dip-0002.md>`__ 
   introduced a new Transaction Version and related “Payload” to the network.

2. Integrated Systems must be able to `serialize and deserialize <https://github.com/dashpay/dips/blob/master/dip-0002.md#serialization-hashing-and-signing>`__ 
   these new Transaction Types to accurately encode and decode
   Raw Transaction data.

3. From a `backwards compatibility <https://github.com/dashpay/dips/blob/master/dip-0002.md#compatibility>`__ 
   perspective, the 4 byte (32-bit) ``version`` field included in Classical
   Transactions was been split into two fields: ``version`` and ``type``
   (each consisting of 2 bytes).

4. Refer to the `Special Transactions <https://dashcore.readme.io/docs/core-ref-transactions-special-transactions>`__ 
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

InstantSend Status is typically determined through direct connection
with the dash daemon, `ZMQ notification <https://github.com/dashpay/dash/blob/master/doc/instantsend.md#zmq>`__,
or through the usage of an external wallet notification script.

Direct Connection
^^^^^^^^^^^^^^^^^

InstantSend Status can be identified through direct connection with the Dash
daemon using JSON-RPC protocol. The ``instantlock`` attribute of the JSON
response reflects the status of the transaction and is included in the following
commands:

- `getrawmempool <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getrawmempool>`__
- `getmempoolancestors <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempoolancestors>`__
- `getmempooldescendants <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempooldescendants>`__
- `getmempoolentry <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-blockchain#getmempoolentry>`__
- `getrawtransaction <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-raw-transactions#getrawtransaction>`__
- `gettransaction <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#gettransaction>`__
- `listtransactions <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#listtransactions>`__
- `listsinceblock <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-calls-wallet#listsinceblock>`__

ZMQ Notification
^^^^^^^^^^^^^^^^

Whenever a transaction enters the mempool and whenever a transaction is locked
in the mempool, ZMQ notifications can be broadcast by the node. A list of
possible ZMQ notifications can be found `here
<https://github.com/dashpay/dash/blob/master/doc/zmq.md#usage>`__. 

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
`watch-only <https://dashcore.readme.io/docs/core-additional-resources-glossary#section-watch-only-address>`__ 
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
- `InstantSend Developer Documentation <https://dashcore.readme.io/docs/core-guide-dash-features-instantsend>`__
- `DIP0010: LLMQ InstantSend <https://github.com/dashpay/dips/blob/master/dip-0010.md>`__
- `Product Brief: Dash Core v0.14 Release <https://blog.dash.org/product-brief-dash-core-release-v0-14-0-now-on-testnet-8f5f4ad45c96>`__
