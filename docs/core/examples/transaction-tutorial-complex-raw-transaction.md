```{eval-rst}
.. meta::
  :title: Complex Raw Transaction
  :description: The example here demonstrates the creation of a transaction with two inputs and two outputs, where each input is signed separately.
```

# Complex Raw Transaction

In this example, we'll create a [transaction](../resources/glossary.md#transaction) with two [inputs](../resources/glossary.md#input) and two [outputs](../resources/glossary.md#output).  We'll sign each of the inputs separately, as might happen if the two inputs belonged to different people who agreed to create a transaction together (such as a CoinJoin transaction).

## 1. List unspent outputs

```shell
> dash-cli -regtest listunspent
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
    "confirmations": 2,
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
    "confirmations": 2,
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
    "txid": "b9ac624b328011e0f0aeacd10d829ebb3e554cac7ce3ef3400a4d58952e291de",
    "vout": 0,
    "address": "yM5cqJZfUStpqia5AtR2sKU2freV7V2tL2",
    "label": "",
    "scriptPubKey": "76a914085aa30f61bfb687797c53fa3f74f2fffd7a0e5788ac",
    "amount": 499.99990000,
    "confirmations": 1,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/0/3]0345caa704995a682ea218ce0a9f7f5885d5\
             51a86a4aaef3a8129176a623530d01)#sh9jyyan",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  },
  {
    "txid": "98802e900642cbfe57964dbfde077024c4c61255a64e3a68f29ea45c04617870",
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

## 2. Select UTXOs

For our two inputs, we select two UTXOs by placing the txid and output index numbers (vouts) in shell variables.  We also save the addresses corresponding to the public keys (hashed or unhashed) used in those transactions. We need the addresses so we can get the corresponding private keys from our wallet.

``` bash
> UTXO1_TXID=98802e900642cbfe57964dbfde077024c4c61255a64e3a68f29ea45c04617870
> UTXO1_VOUT=0
> UTXO1_ADDRESS=yLgzqH8HvvCxeRfYowgA7LkEyhhkFitSLa

> UTXO2_TXID=e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b
> UTXO2_VOUT=0
> UTXO2_ADDRESS=yRjpWkBcjoBY6L9GDRsYYFMJ4aXQTHMQTu
```

## 3. Get private keys

:::{attention}
Users should never manually manage private keys on mainnet. As dangerous as raw transactions are (see warnings above), making a mistake with a private key can be much worse---as in the case of a HD wallet [cross-generational key compromise](../guide/wallets-wallet-files.md#hardened-keys).
**These examples are to help you learn, not for you to emulate on mainnet.**
:::

Use the [`dumpprivkey` RPC](../api/remote-procedure-calls-wallet.md#dumpprivkey) to get the [private keys](../resources/glossary.md#private-key) corresponding to the [public keys](../resources/glossary.md#public-key) used in the two UTXOs our inputs we will be spending.  We need the private keys so we can sign each of the inputs separately.

:::{note}
The `dumpprivkey` RPC only works with legacy wallets. See the [tutorial setup](../examples/transaction-tutorial.md#setup) to create one.
:::

``` bash
> dash-cli -regtest dumpprivkey $UTXO1_ADDRESS
cNKWXVsXySq1zNBmLBgYGM6X7f2tcsesTsVeXRF4VJ3n7nw3r5v4

> dash-cli -regtest dumpprivkey $UTXO2_ADDRESS
cS9sTckDJu9iQPnNnZquwNBeb3Uh84xDwub5x6USBp3pyfkNodP2

> UTXO1_PRIVATE_KEY=cNKWXVsXySq1zNBmLBgYGM6X7f2tcsesTsVeXRF4VJ3n7nw3r5v4

> UTXO2_PRIVATE_KEY=cS9sTckDJu9iQPnNnZquwNBeb3Uh84xDwub5x6USBp3pyfkNodP2
```

## 4. Get new addresses

For our two outputs, get two new [addresses](../resources/glossary.md#address).

``` bash
> dash-cli -regtest getnewaddress
yfi5MkKmkWJi4xA64SPndcrTEN3932pZb6
> dash-cli -regtest getnewaddress
yeUDgzDdtckNTViCXY4N4gWr4XUN2Hq1Gj

> NEW_ADDRESS1=yfi5MkKmkWJi4xA64SPndcrTEN3932pZb6
> NEW_ADDRESS2=yeUDgzDdtckNTViCXY4N4gWr4XUN2Hq1Gj
```

## 5. Create raw transaction

Create the [raw transaction](../resources/glossary.md#raw-transaction) using the [`createrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#createrawtransaction) much the same as before, except now we have two inputs and two outputs.

``` bash
## Outputs - inputs = transaction fee, so always double-check your math!
> dash-cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO1_TXID'",
        "vout": '$UTXO1_VOUT'
      },
      {
        "txid": "'$UTXO2_TXID'",
        "vout": '$UTXO2_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS1'": 499.9999,
      "'$NEW_ADDRESS2'": 10
    }'''
0200000002707861045ca49ef2683a4ea65512c6c4247007debf4d9657fecb42\
06902e80980000000000ffffffff0bf9d56cc19de7fe0ab29f7a41a6f582b4cc\
c29a686512dee78c7369ea7cd4e30000000000ffffffff02f04c3ba40b000000\
1976a914d4b2047e9631219a2f08af6f34d58407d98985de88ac00ca9a3b0000\
00001976a914c71b05f54f89c6c3c6be23973be4c2695b80266f88ac00000000

> RAW_TX=0200000002707861045ca49ef2683a4ea65512c6c4247007debf4d9[...]
```

## 6. Sign raw transaction

Signing the raw transaction with [`signrawtransactionwithkey`](../api/remote-procedure-calls-raw-transactions.md#signrawtransactionwithkey) gets more complicated as we now have two arguments:

1. The unsigned raw transaction.

2. The private key we want to use to sign one of the inputs.

### 6a. First input

The result is a raw transaction with only one input signed; the fact that the transaction isn't fully signed is indicated by value of the `complete` JSON field.  We save the incomplete, partly-signed raw transaction hex to a shell variable.

``` bash
> dash-cli -regtest signrawtransactionwithkey $RAW_TX '''
    [
      "'$UTXO1_PRIVATE_KEY'"
    ]'''
```

``` json
{
  "hex": "0200000002707861045ca49ef2683a4ea65512c6c4247007debf4d9657fecb42069\
          02e8098000000006a47304402201fdc7c17bc71a4e3c2e6f871841cda450a22306d\
          c6188180cf387af4e73e396c0220196a6d659b58c41ff204b8087cd459cd365cdc7\
          f2564ed826b30da2a1d185c1a012103c756577227d8a9e4759ac018065139155b09\
          55aebc1d2f2712f0d33153e6500affffffff0bf9d56cc19de7fe0ab29f7a41a6f58\
          2b4ccc29a686512dee78c7369ea7cd4e30000000000ffffffff02f04c3ba40b0000\
          001976a914d4b2047e9631219a2f08af6f34d58407d98985de88ac00ca9a3b00000\
          0001976a914c71b05f54f89c6c3c6be23973be4c2695b80266f88ac00000000",
  "complete": false,
  "errors": [
    {
      "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
      "vout": 0,
      "scriptSig": "",
      "sequence": 4294967295,
      "error": "Unable to sign input, invalid stack size (possibly missing key)"
    }
  ]
}
```

``` bash

> PARTLY_SIGNED_RAW_TX=0200000002707861045ca49ef2683a4ea65512c6c[...]
```

### 6b. Second input

To sign the second input, we repeat the process we used to sign the first input using the second private key. Now that both inputs are signed, the `complete` result is *true*.

``` bash
> dash-cli -regtest signrawtransactionwithkey $PARTLY_SIGNED_RAW_TX '''
    [
      "'$UTXO2_PRIVATE_KEY'"
    ]'''
```

``` json
{
  "hex": "0200000002707861045ca49ef2683a4ea65512c6c4247007debf4d9657fecb42069\
          02e8098000000006a47304402201fdc7c17bc71a4e3c2e6f871841cda450a22306d\
          c6188180cf387af4e73e396c0220196a6d659b58c41ff204b8087cd459cd365cdc7\
          f2564ed826b30da2a1d185c1a012103c756577227d8a9e4759ac018065139155b09\
          55aebc1d2f2712f0d33153e6500affffffff0bf9d56cc19de7fe0ab29f7a41a6f58\
          2b4ccc29a686512dee78c7369ea7cd4e3000000006a47304402207559b898160ba1\
          3ae9a86004193acdfb5913c46a89fc040cf64b81612bfd4bc20220135ba08acb7e5\
          4b2981f5a74fcc91c20818a743dd1ea92ae234bd6c4eff97aae012103c57deb98b5\
          5a6cc22112d93159862b1a25abe79fb6ab325e724d4f9ac4fbe677ffffffff02f04\
          c3ba40b0000001976a914d4b2047e9631219a2f08af6f34d58407d98985de88ac00\
          ca9a3b000000001976a914c71b05f54f89c6c3c6be23973be4c2695b80266f88ac0\
          0000000",
  "complete": true
}
```

Clean up the shell variables used. Unlike previous subsections, we're not going to send this transaction to the connected node with `sendrawtransaction`. This will allow us to illustrate in the [Offline Signing subsection](../examples/transaction-tutorial-offline-signing.md) below how to spend a transaction which is not yet in the block chain or memory pool.

``` bash
> unset PARTLY_SIGNED_RAW_TX RAW_TX NEW_ADDRESS1 [...]
```
