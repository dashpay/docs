```{eval-rst}
.. meta::
  :title: Simple Raw Transaction
  :description: This example demonstrates using raw transaction RPCs to manually construct and send a simple transaction with a single output.
```

# Simple Raw Transaction

The [raw transaction RPCs](../api/remote-procedure-calls-raw-transactions.md) allow users to create custom [transactions](../resources/glossary.md#transaction) and delay broadcasting those transactions. However, mistakes made in [raw transactions](../resources/glossary.md#raw-transaction) may not be detected by Dash Core, and a number of raw transaction users have permanently lost large numbers of [duffs](../resources/glossary.md#duffs), so please be careful using raw transactions on [mainnet](../resources/glossary.md#mainnet).

This subsection covers one of the simplest possible raw transactions.

:::{note}
The following steps pick up where the [Simple Spending Tutorial](../examples/transaction-tutorial-simple-spending.md) left off.
:::

## 1. List unspent outputs

Re-rerun `listunspent`. We now have three UTXOs: the two transactions we created before plus the [coinbase transaction](../resources/glossary.md#coinbase-transaction) from block #2. We save the [TXID](../resources/glossary.md#transaction-identifiers) and [output index](../resources/glossary.md#output-index) number (vout) of that [coinbase](../resources/glossary.md#coinbase) UTXO to shell variables.

```shell
dash-cli -regtest listunspent
```

``` json
[
  {
    "txid": "f84ca4ad33ec7889d3c6ac670152137a3ee1603c4096230a10562976f700d130",
    "vout": 0,
    "address": "yRdk89fwSW1mUBxQo5fCmEfTva7b4wh2H5",
    "account": "",
    "scriptPubKey": "76a9143a4e8960f26c1fa82d937046959b656e4dd7966688ac",
    "amount": 10.00000000,
    "confirmations": 1,
    "ps_rounds": -2,
    "spendable": true,
    "solvable": true
  },
  {
    "txid": "f84ca4ad33ec7889d3c6ac670152137a3ee1603c4096230a10562976f700d130",
    "vout": 1,
    "address": "yavnyFMebbfX4F2VC25P18FW6LS66h2wqJ",
    "scriptPubKey": "76a914a0411dbed3eab4341d5c41496d61b4fa1b22037e88ac",
    "amount": 490.00000000,
    "confirmations": 1,
    "ps_rounds": -2,
    "spendable": true,
    "solvable": true
  },
  {
    "txid": "9036265a8f577421e556cd4f729752d73469953deea759de11efa9ba354936a8",
    "vout": 0,
    "address": "yWtgzKSckhedxtJ8NXhShWGjfBivkvBGgG",
    "scriptPubKey": "21023fff9c9dc9088c0aeba90d75413705091111311d761054de23ac\
                      dd217450869aac",
    "amount": 500.00000000,
    "confirmations": 101,
    "ps_rounds": -2,
    "spendable": true,
    "solvable": true
  }
]
```

``` bash

> UTXO_TXID=9036265a8f577421e556cd4f729752d73469953deea759de11ef[...]
> UTXO_VOUT=0
```

## 2. Get new address

```shell
dash-cli -regtest getnewaddress
```

``` bash
yfV9Wirf5RkYHgNDttjpBz8Wdi8BavLHcP

> NEW_ADDRESS=yfV9Wirf5RkYHgNDttjpBz8Wdi8BavLHcP
```

## 3. Create raw transaction

Using two arguments to the [`createrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction), we create a new raw format transaction. The first argument (a JSON array) references the txid of the coinbase transaction from block #2 and the [index](../resources/glossary.md#index) number (0) of the [output](../resources/glossary.md#output) from that transaction we want to spend. The second argument (a JSON object) creates the output with the address ( [public key](../resources/glossary.md#public-key) hash) and number of DASH we want to transfer. We save the resulting raw format transaction to a shell variable.

:::{attention}
`createrawtransaction` does not automatically create change outputs, so you can easily accidentally pay a large transaction fee.
:::

In this example, our input had 500.0000 DASH and our output (`$NEW_ADDRESS`) is being paid 499.9999 DASH, so the transaction will include a fee of 0.0001 DASH. If we had paid `$NEW_ADDRESS` only 100 DASH with no other changes to this transaction, the [transaction fee](../resources/glossary.md#transaction-fee) would be a whopping 400 DASH. See the [Complex Raw Transaction subsection](../examples/transaction-tutorial-complex-raw-transaction.md) below for how to create a transaction with multiple outputs so you can send the change back to yourself.

```shell
## Outputs - inputs = transaction fee, so always double-check your math!
dash-cli -regtest createrawtransaction ''' \
    [ \
      { \
        "txid": "'$UTXO_TXID'", \
        "vout": '$UTXO_VOUT' \
      } \
    ] \
    ''' ''' \
    { \
      "'$NEW_ADDRESS'": 499.9999 \
    }'''
```

``` bash
0100000001a8364935baa9ef11de59a7ee3d956934d75297724fcd56e5217457\
8f5a2636900000000000ffffffff01f04c3ba40b0000001976a914d240140859\
744755d73e5967081c3bedceffc5db88ac00000000

> RAW_TX=0100000001a8364935baa9ef11de59a7ee3d956934d75297724fcd5[...]
```

## 4. Decode raw transaction

Use the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction) to see exactly what the transaction we just created does.

```shell
dash-cli -regtest decoderawtransaction $RAW_TX
```

``` json
{
  "txid": "7cbd2245ee5d824c00fc08b3bf2f694ad9a215d38d897fcf2df64a43c59bb97b",
  "size": 85,
  "version": 1,
  "locktime": 0,
  "vin": [
    {
      "txid": "9036265a8f577421e556cd4f729752d73469953deea759de11efa9ba354936a8",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 499.99990000,
      "valueSat": 49999990000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 d240140859744755d73e5967081c3bedceffc5db\
                  OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914d240140859744755d73e5967081c3bedceffc5db88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "yfV9Wirf5RkYHgNDttjpBz8Wdi8BavLHcP"
        ]
      }
    }
  ]
}
```

## 5. Sign transaction

Use the [`signrawtransactionwithwallet` RPC](../api/remote-procedure-calls-wallet.md#signrawtransactionwithwallet) to sign the transaction created by `createrawtransaction` and save the returned "hex" raw format signed transaction to a shell variable.

```shell
dash-cli -regtest signrawtransactionwithwallet $RAW_TX
```

``` json
{
  "hex": "0100000001a8364935baa9ef11de59a7ee3d956934d75297724fcd\
          56e52174578f5a2636900000000049483045022100b4e5e9224afa\
          de8686bb22a957d1ec1587a66ee84943761b2d9061d5f751cd7602\
          203c88d4064641a413ce3d0824264d6d87908960487afe9a3a133e\
          7d67a22fd05101ffffffff01f04c3ba40b0000001976a914d24014\
          0859744755d73e5967081c3bedceffc5db88ac00000000",
  "complete": true
}
```

``` bash

> SIGNED_RAW_TX=0100000001a8364935baa9ef11de59a7ee3d956934d75297[...]
```

Even though the transaction is now complete, the Dash Core [node](../resources/glossary.md#node) we're connected to doesn't know anything about the transaction, nor does any other part of the [network](../resources/glossary.md#network). We've created a spend, but we haven't actually spent anything because we could simply unset the `$SIGNED_RAW_TX` variable to eliminate the transaction.

## 6. Send raw transaction

Send the signed transaction to the connected node using the [`sendrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction). After accepting the transaction, the node would usually then broadcast it to other [peers](../resources/glossary.md#peer), but we're not currently connected to other peers because we started in [regression test mode](../resources/glossary.md#regression-test-mode).

```shell
dash-cli -regtest sendrawtransaction $SIGNED_RAW_TX
```

``` bash
fa0f4105b0a2b2706d65581c5e6411d3970253c7f231944fa2f978b4a3d9010d
```

## 7. Mine a block

Generate a block to confirm the transaction and then clear our shell variables.

```shell
dash-cli -regtest generate 1

unset UTXO_TXID UTXO_VOUT NEW_ADDRESS RAW_TX SIGNED_RAW_TX
```
