```{eval-rst}
.. meta::
  :title: Offline Signing
  :description: The example in this section demonstrates offline signing of a transaction, including spending an unconfirmed output, without sending it to the local node.
```

% Example output on this page comes from scripts/core-regtest-examples/run-transaction-tutorials.sh.
% Use the output of a single run for all tutorial pages so values stay consistent between them.

# Offline Signing

We will now spend the [transaction](../resources/glossary.md#transaction) created in the [Complex Raw Transaction subsection](../examples/transaction-tutorial-complex-raw-transaction.md) without sending it to the local [node](../resources/glossary.md#node) first. This is the same basic process used by [wallet](../resources/glossary.md#wallet) programs for offline signing---which generally means signing a transaction without access to the current UTXO set.

Offline signing is safe. However, in this example we will also be spending an [output](../resources/glossary.md#output) which is not part of the [block chain](../resources/glossary.md#block-chain) because the transaction containing it has never been broadcast. That can be unsafe:

:::{warning}
Transactions which spend outputs from unconfirmed transactions are vulnerable to transaction
malleability. Be sure to read about transaction malleability and adopt good practices before
spending unconfirmed transactions on mainnet.
:::

Put the previously signed (but not sent) transaction into a shell variable.

``` shell
OLD_SIGNED_RAW_TX=0200000002707861045ca49ef2683a4ea65512c6c4247007debf4d\
9657fecb4206902e8098000000006a47304402201fdc7c17bc71a4e3c2e6f871841cda45\
0a22306dc6188180cf387af4e73e396c0220196a6d659b58c41ff204b8087cd459cd365c\
dc7f2564ed826b30da2a1d185c1a012103c756577227d8a9e4759ac018065139155b0955\
aebc1d2f2712f0d33153e6500affffffff0bf9d56cc19de7fe0ab29f7a41a6f582b4ccc2\
9a686512dee78c7369ea7cd4e3000000006a47304402207559b898160ba13ae9a8600419\
3acdfb5913c46a89fc040cf64b81612bfd4bc20220135ba08acb7e54b2981f5a74fcc91c\
20818a743dd1ea92ae234bd6c4eff97aae012103c57deb98b55a6cc22112d93159862b1a\
25abe79fb6ab325e724d4f9ac4fbe677ffffffff02f04c3ba40b0000001976a914d4b204\
7e9631219a2f08af6f34d58407d98985de88ac00ca9a3b000000001976a914c71b05f54f\
89c6c3c6be23973be4c2695b80266f88ac00000000
```

## 1. Decode signed transaction

Decode the signed [raw transaction](../resources/glossary.md#raw-transaction) so we can get its [TXID](../resources/glossary.md#transaction-identifiers). Also, choose a specific one of its UTXOs to spend and save that UTXO's [output index](../resources/glossary.md#output-index) number (vout) and hex [pubkey script](../resources/glossary.md#pubkey-script) (scriptPubKey) into shell variables.

``` shell
dash-cli -regtest decoderawtransaction $OLD_SIGNED_RAW_TX
```

``` json
{
  "txid": "f17450bda1e7a7ef6d157157633754e8feb2372859c3683345963612ba3fce69",
  "version": 2,
  "type": 0,
  "size": 372,
  "locktime": 0,
  "vin": [
    {
      "txid": "98802e900642cbfe57964dbfde077024c4c61255a64e3a68f29ea45c04617870",
      "vout": 0,
      "scriptSig": {
        "asm": "304402201fdc7c17bc71a4e3c2e6f871841cda450a22306dc6188180cf387\
                af4e73e396c0220196a6d659b58c41ff204b8087cd459cd365cdc7f2564ed\
                826b30da2a1d185c1a[ALL]\
                03c756577227d8a9e4759ac018065139155b0955aebc1d2f2712f0d33153e\
                6500a",
        "hex": "47304402201fdc7c17bc71a4e3c2e6f871841cda450a22306dc6188180cf3\
                87af4e73e396c0220196a6d659b58c41ff204b8087cd459cd365cdc7f2564\
                ed826b30da2a1d185c1a012103c756577227d8a9e4759ac018065139155b0\
                955aebc1d2f2712f0d33153e6500a"
      },
      "sequence": 4294967295
    },
    {
      "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
      "vout": 0,
      "scriptSig": {
        "asm": "304402207559b898160ba13ae9a86004193acdfb5913c46a89fc040cf64b8\
                1612bfd4bc20220135ba08acb7e54b2981f5a74fcc91c20818a743dd1ea92\
                ae234bd6c4eff97aae[ALL]\
                03c57deb98b55a6cc22112d93159862b1a25abe79fb6ab325e724d4f9ac4f\
                be677",
        "hex": "47304402207559b898160ba13ae9a86004193acdfb5913c46a89fc040cf64\
                b81612bfd4bc20220135ba08acb7e54b2981f5a74fcc91c20818a743dd1ea\
                92ae234bd6c4eff97aae012103c57deb98b55a6cc22112d93159862b1a25a\
                be79fb6ab325e724d4f9ac4fbe677"
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
        "asm": "OP_DUP OP_HASH160 d4b2047e9631219a2f08af6f34d58407d98985de\
                OP_EQUALVERIFY OP_CHECKSIG",
        "desc": "addr(yfi5MkKmkWJi4xA64SPndcrTEN3932pZb6)#sf5x9h6j",
        "hex": "76a914d4b2047e9631219a2f08af6f34d58407d98985de88ac",
        "address": "yfi5MkKmkWJi4xA64SPndcrTEN3932pZb6",
        "type": "pubkeyhash"
      }
    },
    {
      "value": 10.00000000,
      "valueSat": 1000000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 c71b05f54f89c6c3c6be23973be4c2695b80266f\
                OP_EQUALVERIFY OP_CHECKSIG",
        "desc": "addr(yeUDgzDdtckNTViCXY4N4gWr4XUN2Hq1Gj)#r76tj695",
        "hex": "76a914c71b05f54f89c6c3c6be23973be4c2695b80266f88ac",
        "address": "yeUDgzDdtckNTViCXY4N4gWr4XUN2Hq1Gj",
        "type": "pubkeyhash"
      }
    }
  ]
}
```

``` bash

> UTXO_TXID=f17450bda1e7a7ef6d157157633754e8feb2372859c3683345963612ba3fce69
> UTXO_VOUT=1
> UTXO_OUTPUT_SCRIPT=76a914c71b05f54f89c6c3c6be23973be4c2695b80266f88ac
```

## 2. Get new address

Get a new [address](../resources/glossary.md#address) to spend the [duffs](../resources/glossary.md#duffs) to.

``` bash
> dash-cli -regtest getnewaddress
yRPtRCJCyY7j6Wy3DnBGU41GS4D997crxi

> NEW_ADDRESS=yRPtRCJCyY7j6Wy3DnBGU41GS4D997crxi
```

## 3. Create raw transaction

Create the raw transaction the same way we've done in the previous subsections.

``` bash
## Outputs - inputs = transaction fee, so always double-check your math!
> dash-cli -regtest createrawtransaction '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT'
      }
    ]
    ''' '''
    {
      "'$NEW_ADDRESS'": 9.9999
    }'''
020000000169ce3fba123696453368c3592837b2fee85437635771156defa7e7\
a1bd5074f10100000000ffffffff01f0a29a3b000000001976a91437afa2f556\
dee315f44ff88cf95afd8b7ffbc67988ac00000000

> RAW_TX=020000000169ce3fba123696453368c3592837b2fee854376357711[...]
```

## 4. Sign raw transaction

Attempt to sign the [raw transaction](../resources/glossary.md#raw-transaction) without any special arguments, the way we successfully signed the the raw transaction in the [Simple Raw Transaction subsection](../examples/transaction-tutorial-simple-raw-transaction.md). If you've read the [Transaction section](../guide/transactions.md) of the guide, you may know why the call fails and leaves the raw transaction hex unchanged.

![Old Transaction Data Required To Be Signed](../../img/dev/en-signing-output-to-spend.svg)

As illustrated above, the data that gets signed includes the [TXID](../resources/glossary.md#transaction-identifiers) and vout from the previous transaction.  That information is included in the `createrawtransaction` raw transaction.  But the data that gets signed also includes the [pubkey script](../resources/glossary.md#pubkey-script) from the previous transaction, even though it doesn't appear in either the unsigned or signed transaction.

In the other raw transaction subsections above, the previous [output](../resources/glossary.md#output) was part of the UTXO set known to the wallet, so the wallet was able to use the TXID and [output index](../resources/glossary.md#output-index) number to find the previous [pubkey script](../resources/glossary.md#pubkey-script) and insert it automatically.

### 4a. Without Pubkey Script

:::{note}
This step demonstrates the error returned when an unknown output is referenced.
:::

In this case, you're spending an [output](../resources/glossary.md#output) which is unknown to the wallet, so it can't automatically insert the previous pubkey script.

``` bash
> dash-cli -regtest signrawtransactionwithwallet $RAW_TX
```

``` json
{
  "hex": "020000000169ce3fba123696453368c3592837b2fee85437635771156defa7e7a1b\
          d5074f10100000000ffffffff01f0a29a3b000000001976a91437afa2f556dee315\
          f44ff88cf95afd8b7ffbc67988ac00000000",
  "complete": false,
  "errors": [
    {
      "txid": "f17450bda1e7a7ef6d157157633754e8feb2372859c3683345963612ba3fce69",
      "vout": 1,
      "scriptSig": "",
      "sequence": 4294967295,
      "error": "Input not found or already spent"
    }
  ]
}
```

### 4b. With Pubkey Script

Successfully sign the transaction by providing the previous pubkey script and other required input data.

This specific operation is typically what offline signing wallets do. The online wallet creates the raw transaction and gets the previous pubkey scripts for all the inputs. The user brings this information to the offline wallet. After displaying the transaction details to the user, the offline wallet signs the transaction as we did above. The user takes the signed transaction back to the online wallet, which broadcasts it.

``` bash
> dash-cli -regtest signrawtransactionwithwallet $RAW_TX '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'"
      }
    ]'''
```

``` json
{
  "hex": "020000000169ce3fba123696453368c3592837b2fee85437635771156defa7e7a1b\
          d5074f1010000006a4730440220295f56fb809dcfdd7655169424b53b1068b7965e\
          09daa7ed3a36b02b3136e9770220742d8cbea94af4adff067a19315a02d59f35eec\
          443e8b13a21b78b407b53e267012103aafdab90962d40bd9e4c19a6c7b7ee698948\
          fedf81a708ce738539bc24ed65d4ffffffff01f0a29a3b000000001976a91437afa\
          2f556dee315f44ff88cf95afd8b7ffbc67988ac00000000",
  "complete": true
}
```

``` bash

> SIGNED_RAW_TX=020000000169ce3fba123696453368c3592837b2fee85437[...]
```

## 5. Send raw transaction

### 5a. Second transaction

Attempt to broadcast the second transaction before we've broadcast the first transaction.  The [node](../resources/glossary.md#node) rejects this attempt because the second transaction spends an [output](../resources/glossary.md#output) which is not a UTXO the node knows about.

``` bash
> dash-cli -regtest sendrawtransaction $SIGNED_RAW_TX
```

``` bash
error code: -25
error message:
bad-txns-inputs-missingorspent
```

### 5b. First transaction

Broadcast the first transaction, which succeeds, and then broadcast the second transaction---which also now succeeds because the node now sees the UTXO.

``` bash
> dash-cli -regtest sendrawtransaction $OLD_SIGNED_RAW_TX
f17450bda1e7a7ef6d157157633754e8feb2372859c3683345963612ba3fce69
> dash-cli -regtest sendrawtransaction $SIGNED_RAW_TX
73a824eb7a950e793127598f325d97345622270608bf2875f5da4bef80b532d3
```

## 6. Check mempool

We have once again not generated an additional block, so the transactions above have not yet become part of the regtest block chain.  However, they are part of the local node's memory pool.

``` bash
> dash-cli -regtest getrawmempool
```

``` json
[
  "f17450bda1e7a7ef6d157157633754e8feb2372859c3683345963612ba3fce69",
  "73a824eb7a950e793127598f325d97345622270608bf2875f5da4bef80b532d3"
]
```

Remove old shell variables.

``` bash
> unset OLD_SIGNED_RAW_TX SIGNED_RAW_TX RAW_TX [...]
```
