```{eval-rst}
.. _examples-receiving-zmq-notifications:
.. meta::
  :title: Receiving ZMQ Notifications
  :description: Shows how to configure Dash Core's ZeroMQ support and subscribe to ZMQ notifications for block, transaction, and governance messages for efficient notification handling.
```

# Receiving ZMQ Notifications

## Overview

Receiving notifications from Dash Core is important for a variety of use-cases. Although polling [RPCs](../api/remote-procedure-calls.md) can be useful, in some scenarios it may be more desirable to have publish-subscribe functionality. Dash Core's built-in ZeroMQ (ZMQ) support provides the ability to subscribe to block, transaction, and governance related messages.

Further information regarding ZMQ support may be found in the [ZMQ API Reference](../api/zmq.md).

## Enabling Dash Core ZMQ Notifications

:::{note}
This requires a Dash Core full node or masternode
:::

In the [`dash.conf` configuration file](../examples/configuration-file.md), add the following [ZMQ notifications](../api/zmq.md#available-notifications) and assign the address that Dash Core should listen on. The notifications selected here relate to InstantSend and ChainLocks.

```
# ZMQ
zmqpubhashchainlock=tcp://0.0.0.0:20009
zmqpubhashtx=tcp://0.0.0.0:20009
zmqpubhashtxlock=tcp://0.0.0.0:20009
zmqpubrawchainlock=tcp://0.0.0.0:20009
zmqpubrawtxlock=tcp://0.0.0.0:20009
```

Restart the Dash Core node once the configuration file has been updated.

## JavaScript Example

Requires an installation of [NodeJS](https://nodejs.org/en/download/)

### 1. Install ZeroMq

The JavaScript zeromq package is available from [npmjs.com](https://www.npmjs.com/package/zeromq) and can be installed from the command line by running:

```shell
npm install zeromq@5
```

:::{attention}
Version 5 of the zeromq package should be used for compatibility reasons.
:::

### 2. Subscribe to ZeroMQ Messages

Create a file with the following contents. Then run it by typing `node <your-filename.js>` from the command line:

::::{tab-set-code}

```{code-block} javascript
const zmq = require('zeromq');
const sock = zmq.socket('sub');
const zmqPort = 20009;

sock.connect('tcp://127.0.0.1:' + zmqPort);

// Subscribe to transaction notifications
sock.subscribe('hashtx'); // Note: this will subscribe to hashtxlock also

// Subscribe to InstantSend/ChainLock notifications
sock.subscribe('hashchainlock');
sock.subscribe('hashtxlock');
sock.subscribe('rawchainlock'); // Note: this will subscribe to rawchainlocksig also
sock.subscribe('rawtxlock'); // Note: this will subscribe to rawtxlocksig also

console.log('Subscriber connected to port %d', zmqPort);

sock.on('message', function(topic, message) {
  console.log(
    'Received',
    topic.toString().toUpperCase(),
    'containing:\n',
    message.toString('hex'),
    '\n'
  );
});
```

```{code-block} python
import binascii
import asyncio
import zmq
import zmq.asyncio
import signal

port = 20009

class ZMQHandler():
    def __init__(self):
        self.loop = asyncio.get_event_loop()
        self.zmqContext = zmq.asyncio.Context()

        self.zmqSubSocket = self.zmqContext.socket(zmq.SUB)
        self.zmqSubSocket.connect("tcp://127.0.0.1:%i" % port)

        # Subscribe to transaction notifications
        self.zmqSubSocket.setsockopt_string(zmq.SUBSCRIBE, "hashtx")

        # Subscribe to InstantSend/ChainLock notifications
        self.zmqSubSocket.setsockopt_string(zmq.SUBSCRIBE, "hashtxlock")
        self.zmqSubSocket.setsockopt_string(zmq.SUBSCRIBE, "hashchainlock")
        self.zmqSubSocket.setsockopt_string(zmq.SUBSCRIBE, "rawchainlock")
        self.zmqSubSocket.setsockopt_string(zmq.SUBSCRIBE, "rawtxlock")

        print('Subscriber connected to port {}'.format(port))

    @asyncio.coroutine
    def handle(self) :
        msg = yield from self.zmqSubSocket.recv_multipart()
        topic = msg[0]
        body = msg[1]
        sequence = "Unknown"

        print('Received {} containing:\n{}\n'.format(
            topic.decode("utf-8"), 
            binascii.hexlify(body).decode("utf-8")))

        # schedule ourselves to receive the next message
        asyncio.ensure_future(self.handle())

    def start(self):
        self.loop.add_signal_handler(signal.SIGINT, self.stop)
        self.loop.create_task(self.handle())
        self.loop.run_forever()

    def stop(self):
        self.loop.stop()
        self.zmqContext.destroy()

daemon = ZMQHandler()
daemon.start()
```

::::

## Example Response

The following response demonstrates the notification provided by Dash Core when it receives a transaction and then receives the associated InstantSend lock. The four notifications represent:

  1. The TXID of the transaction is received (`HASHTX`) - at this point the transaction is not locked
  2. The TXID of a locked transaction is received (`HASHTXLOCK`). Since this is the same value as the `HASHTX` already received, we know that the transaction has now received an InstantSend lock.
  3. The raw transaction (`RAWTXLOCK`) (this could be decoded using the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction) for example)
  4. A combination of the raw transaction and the InstantSend [lock signature](../reference/p2p-network-instantsend-messages.md#isdlock) (`RAWTXLOCKSIG`)

```
Received HASHTX containing:
 b2e128661e3679c3d00cd081e32fdc9a12f44e486e083e6eab998bdfd6f64a9b

Received HASHTXLOCK containing:
 b2e128661e3679c3d00cd081e32fdc9a12f44e486e083e6eab998bdfd6f64a9b

Received RAWTXLOCK containing:
 02000000025a4d18da609107e9ea3dc6 ... 5a32ea917a30147d6c9788ac6ea90400

Received RAWTXLOCKSIG containing:
 02000000025a4d18da609107e9ea3dc6 ... 9e889cee7ba48981ca002e6962a20236
```
