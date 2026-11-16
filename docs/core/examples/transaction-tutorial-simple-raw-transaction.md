```{eval-rst}
.. meta::
  :title: Simple Raw Transaction
  :description: This example demonstrates using raw transaction RPCs to manually construct and send a simple transaction with a single output.
```

% Example output on this page comes from scripts/core-regtest-examples/run-transaction-tutorials.sh.
% Use the output of a single run for all tutorial pages so values stay consistent between them.

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
    "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
    "vout": 0,
    "address": "yRjpWkBcjoBY6L9GDRsYYFMJ4aXQTHMQTu",
    "label": "",
    "scriptPubKey": "76a9143b74b256a0c92f4067cb90981a685ddc171287ff88ac",
    "amount": 10.00000000,
    "confirmations": 1,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/0/1]03c57deb98b55a6cc22112d93159862b1a25\
             abe79fb6ab325e724d4f9ac4fbe677)#slt9lygj",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  },
  {
    "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
    "vout": 1,
    "address": "ycMSBzw2NMP22qU5nhdz3XbAsBfc5P9H1R",
    "scriptPubKey": "76a914afe24b6c9a80114f63baeabed947bd12e6d6eebd88ac",
    "amount": 489.99999775,
    "confirmations": 1,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/1/0]025a561f14893e47dc233bdd10ee71baf40a\
             a41cc0016d40eb7c2ce533c721dc85)#tkfjlxrl",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  },
  {
    "txid": "ceb86b5198a0750bddc0c1e8f8a9e1d64fa6e8ae59f4b92bd8723494b8854874",
    "vout": 0,
    "address": "yLgzqH8HvvCxeRfYowgA7LkEyhhkFitSLa",
    "label": "",
    "scriptPubKey": "76a91404136f24814f9b811672d7425679cda1251e43c188ac",
    "amount": 500.00000000,
    "confirmations": 101,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/0/0]03c756577227d8a9e4759ac018065139155b\
             0955aebc1d2f2712f0d33153e6500a)#sl4kxe3l",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  }
]
```

``` bash

> UTXO_TXID=ceb86b5198a0750bddc0c1e8f8a9e1d64fa6e8ae59f4b92bd872[...]
> UTXO_VOUT=0
```

## 2. Get new address

```shell
dash-cli -regtest getnewaddress
```

``` bash
yM5cqJZfUStpqia5AtR2sKU2freV7V2tL2

> NEW_ADDRESS=yM5cqJZfUStpqia5AtR2sKU2freV7V2tL2
```

## 3. Create raw transaction

Using two arguments to the [`createrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction), we create a new raw format transaction. The first argument (a JSON array) references the txid of the coinbase transaction from block #2 and the [index](../resources/glossary.md#index) number (0) of the [output](../resources/glossary.md#output) from that transaction we want to spend. The second argument (a JSON object) creates the output with the address ( [public key](../resources/glossary.md#public-key) hash) and number of DASH we want to transfer. We save the resulting raw format transaction to a shell variable.

:::{attention}
`createrawtransaction` does not automatically create change outputs, so you can easily accidentally pay a large transaction fee.
:::

In this example, our input had 500.0000 DASH and our output (`$NEW_ADDRESS`) is being paid 499.9999 DASH, so the transaction will include a fee of 0.0001 DASH. If we had paid `$NEW_ADDRESS` only 100 DASH with no other changes to this transaction, the [transaction fee](../resources/glossary.md#transaction-fee) would be a whopping 400 DASH. See the [Complex Raw Transaction subsection](../examples/transaction-tutorial-complex-raw-transaction.md) below for how to create a transaction with multiple outputs so you can send the change back to yourself.

```shell
## Outputs - inputs = transaction fee, so always double-check your math!
dash-cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS'": 499.9999
    }'''
```

``` bash
0200000001744885b8943472d82bb9f459aee8a64fd6e1a9f8e8c1c0dd0b75a0\
98516bb8ce0000000000ffffffff01f04c3ba40b0000001976a914085aa30f61\
bfb687797c53fa3f74f2fffd7a0e5788ac00000000

> RAW_TX=0200000001744885b8943472d82bb9f459aee8a64fd6e1a9f8e8c1c[...]
```

## 4. Decode raw transaction

Use the [`decoderawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#decoderawtransaction) to see exactly what the transaction we just created does.

```shell
dash-cli -regtest decoderawtransaction $RAW_TX
```

``` json
{
  "txid": "496465afb721213ecf535ca5fff0f9f54315e19679c03fc84f88ef24aee8c1be",
  "version": 2,
  "type": 0,
  "size": 85,
  "locktime": 0,
  "vin": [
    {
      "txid": "ceb86b5198a0750bddc0c1e8f8a9e1d64fa6e8ae59f4b92bd8723494b8854874",
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
        "asm": "OP_DUP OP_HASH160 085aa30f61bfb687797c53fa3f74f2fffd7a0e57\
                OP_EQUALVERIFY OP_CHECKSIG",
        "desc": "addr(yM5cqJZfUStpqia5AtR2sKU2freV7V2tL2)#jtxrmka0",
        "hex": "76a914085aa30f61bfb687797c53fa3f74f2fffd7a0e5788ac",
        "address": "yM5cqJZfUStpqia5AtR2sKU2freV7V2tL2",
        "type": "pubkeyhash"
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
  "hex": "0200000001744885b8943472d82bb9f459aee8a64fd6e1a9f8e8c1c0dd0b75a0985\
          16bb8ce000000006a4730440220614a134314045dbd412224847179da21cf8a25cc\
          e8e4b44cca58a784ac401b3d0220349e562cc1142a52ad991b8a3dce2b737025286\
          f74c6710cde4d41cf66f43c17012103c756577227d8a9e4759ac018065139155b09\
          55aebc1d2f2712f0d33153e6500affffffff01f04c3ba40b0000001976a914085aa\
          30f61bfb687797c53fa3f74f2fffd7a0e5788ac00000000",
  "complete": true
}
```

``` bash

> SIGNED_RAW_TX=0200000001744885b8943472d82bb9f459aee8a64fd6e1a9[...]
```

Even though the transaction is now complete, the Dash Core [node](../resources/glossary.md#node) we're connected to doesn't know anything about the transaction, nor does any other part of the [network](../resources/glossary.md#network). We've created a spend, but we haven't actually spent anything because we could simply unset the `$SIGNED_RAW_TX` variable to eliminate the transaction.

## 6. Send raw transaction

Send the signed transaction to the connected node using the [`sendrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#sendrawtransaction). After accepting the transaction, the node would usually then broadcast it to other [peers](../resources/glossary.md#peer), but we're not currently connected to other peers because we started in [regression test mode](../resources/glossary.md#regression-test-mode).

```shell
dash-cli -regtest sendrawtransaction $SIGNED_RAW_TX
```

``` bash
b9ac624b328011e0f0aeacd10d829ebb3e554cac7ce3ef3400a4d58952e291de
```

## 7. Mine a block

Generate a block to confirm the transaction and then clear our shell variables.

```shell
dash-cli -regtest -generate 1

unset UTXO_TXID UTXO_VOUT NEW_ADDRESS RAW_TX SIGNED_RAW_TX
```
