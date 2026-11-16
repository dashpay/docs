```{eval-rst}
.. meta::
  :title: P2SH Multisig
  :description: In this subsection, we will create a P2SH multisig address, spend duffs to it, and then spend those duffs from it to another address.
```

% Example output on this page comes from scripts/core-regtest-examples/run-transaction-tutorials.sh.
% Use the output of a single run for all tutorial pages so values stay consistent between them.

# P2SH Multisig

In this subsection, we will create a [P2SH multisig](../resources/glossary.md#p2sh-multisig) address, spend [duffs](../resources/glossary.md#duffs) to it, and then spend those duffs from it to another [address](../resources/glossary.md#address).

Creating a [multisig](../resources/glossary.md#multisig) address is easy. Multisig [outputs](../resources/glossary.md#output) have two parameters, the *minimum* number of signatures required (*m*) and the *number* of [public keys](../resources/glossary.md#public-key) to use to validate those signatures. This is called m-of-n, and in this case we'll be using 2-of-3.

## 1. Get new addresses

Generate three new P2PKH addresses. A [P2PKH address](../resources/glossary.md#p2pkh-address) cannot be used with the multisig redeem script created below. (Hashing each public key is unnecessary anyway---all the public keys are protected by a hash when the [redeem script](../resources/glossary.md#redeem-script) is hashed.) However, Dash Core uses addresses as a way to reference the underlying full (unhashed) public keys it knows about, so we get the three new addresses above in order to use their public keys.

Recall from the Guide that the hashed public keys used in addresses obfuscate the full public key, so you cannot give an address to another person or device as part of creating a typical multisig output or P2SH multisig redeem script. You must give them a full public key.

``` bash
    > dash-cli -regtest getnewaddress
    yU22rE8oEUVYgsPMwNUgGWceVvKVCTMgvf
    > dash-cli -regtest getnewaddress
    yfnfDrJCPhs3WMNz3tQhAQYUbY912MnW2n
    > dash-cli -regtest getnewaddress
    yS6zsGiF1CNzuGsXn3qRrnuHvh3Hopqrpd

    > NEW_ADDRESS1=yU22rE8oEUVYgsPMwNUgGWceVvKVCTMgvf
    > NEW_ADDRESS2=yfnfDrJCPhs3WMNz3tQhAQYUbY912MnW2n
    > NEW_ADDRESS3=yS6zsGiF1CNzuGsXn3qRrnuHvh3Hopqrpd
```

## 2. Get public key

Use the [`getaddressinfo` RPC](../api/remote-procedure-calls-wallet.md#getaddressinfo) to display the full (unhashed) public key for the addresses.  This is the information which will actually be included in the multisig redeem script.  This is also the information you would give another person or device as part of creating a multisig output or P2SH multisig redeem script.

We save the address returned to a shell variable.

``` bash
> dash-cli -regtest getaddressinfo $NEW_ADDRESS3
```

``` json
{
  "address": "yS6zsGiF1CNzuGsXn3qRrnuHvh3Hopqrpd",
  "scriptPubKey": "76a9143f76132859fde08a490213d02a4760b898fcce8a88ac",
  "ismine": true,
  "solvable": true,
  "desc": "pkh([6ef61e0b/44h/1h/0h/0/10]035a8135bb28040114988a819343420f3a859\
           f188b738851e10774209077da3dd7)#ct7gtdex",
  "iswatchonly": false,
  "isscript": false,
  "pubkey": "035a8135bb28040114988a819343420f3a859f188b738851e10774209077da3dd7",
  "iscompressed": true,
  "ischange": false,
  "timestamp": 1794849414,
  "hdchainid": "9afcce9229fdba00c43f320be67543f7d435dc229b3edde300dd8436fbdbbb98",
  "hdkeypath": "m/44'/1'/0'/0/10",
  "hdmasterfingerprint": "6ef61e0b",
  "labels": [
    ""
  ]
}

```

``` bash

> NEW_ADDRESS3_PUBLIC_KEY=035a8135bb28040114988a819343420f3a859f[...]
```

## 3. Create multisig address

Use the [`createmultisig` RPC](../api/remote-procedure-calls-util.md#createmultisig) with two arguments, the number (*n*) of signatures required and a list of public keys. The P2SH address is returned along with the redeem script which must be provided when we spend duffs sent to the P2SH address.

:::{attention}
You must not lose the redeem script, especially if you don't have a record of which public keys you used to create the P2SH multisig address. You need the redeem script to spend any dash sent to the P2SH address.

If you lose the redeem script, you can recreate it by running the same command above, with the public keys listed in the same order. **However, if you lose both the redeem script and even one of the public keys, you will never be able to spend duffs sent to that P2SH address.**
:::

Neither the address nor the redeem script are stored in the wallet when you use `createmultisig`. To store them in the wallet, use the [`addmultisigaddress` RPC](../api/remote-procedure-calls-wallet.md#addmultisigaddress) instead (legacy wallets only).  If you add an address to the wallet, you should also make a new backup.

``` bash
> dash-cli -regtest createmultisig 2 '''
    [
      "'$NEW_ADDRESS1_PUBLIC_KEY'",
      "'$NEW_ADDRESS2_PUBLIC_KEY'",
      "'$NEW_ADDRESS3_PUBLIC_KEY'"
    ]'''
```

``` json
{
  "address": "8p2Rx8VUP4XJATHcm29VpqAkeFyyf2kHYG",
  "redeemScript": "522103fb039547a8655522aee01d6b2e4bd9c8f29ddf10862c4ac9d29d\
                   209212e74b4a21022f44ad116f6b73ca45b62b16964a44037399ca18a2\
                   54abadbe32abe1ddcfaf7921035a8135bb28040114988a819343420f3a\
                   859f188b738851e10774209077da3dd753ae",
  "descriptor": "sh(multi(2,03fb039547a8655522aee01d6b2e4bd9c8f29ddf10862c4ac\
                 9d29d209212e74b4a,022f44ad116f6b73ca45b62b16964a44037399ca18\
                 a254abadbe32abe1ddcfaf79,035a8135bb28040114988a819343420f3a8\
                 59f188b738851e10774209077da3dd7))#3wjr4a3w"
}
```

``` bash

> P2SH_ADDRESS=8p2Rx8VUP4XJATHcm29VpqAkeFyyf2kHYG
> P2SH_REDEEM_SCRIPT=522103fb039547a8655522aee01d6b2e4bd9c8f29[...]
```

## 4. Fund multisig address

Paying the P2SH multisig address with Dash Core is as simple as paying a more common P2PKH address. Here we use the same command (but different variable) we used in the [Simple Spending subsection](../examples/transaction-tutorial-simple-spending.md). As before, this command automatically selects an UTXO, creates a [change output](../resources/glossary.md#change-output) to a new one of our P2PKH addresses if necessary, and pays a [transaction fee](../resources/glossary.md#transaction-fee) if necessary.

We save that [TXID](../resources/glossary.md#transaction-identifiers) to a shell variable as the TXID of the UTXO we plan to spend next.

``` bash
> dash-cli -regtest sendtoaddress $P2SH_ADDRESS 10.00
b5da10d99d994600a2a3d86a8065be8151d77605a644c157b4551945b21e2b81

> UTXO_TXID=b5da10d99d994600a2a3d86a8065be8151d77605a644c157b455[...]
```

## 5. Get decoded transaction

We use the [`getrawtransaction` RPC](../api/remote-procedure-calls-raw-transactions.md#getrawtransaction) with the optional second argument (*true*) to get the decoded transaction we just created with `sendtoaddress`. We choose one of the [outputs](../resources/glossary.md#output) (the multisig address one) to be our UTXO and get its [output index](../resources/glossary.md#output-index) number (vout) and [pubkey script](../resources/glossary.md#pubkey-script) (scriptPubKey).

``` bash
> dash-cli -regtest getrawtransaction $UTXO_TXID 1
```

``` json
{
  "txid": "b5da10d99d994600a2a3d86a8065be8151d77605a644c157b4551945b21e2b81",
  "version": 2,
  "type": 0,
  "size": 223,
  "locktime": 103,
  "vin": [
    {
      "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
      "vout": 1,
      "scriptSig": {
        "asm": "30440220284202dced1c634241d4a8443336122c59feb8d79ece4a9e85034\
                924c850428c0220028dd652b1dde3527d1b5368e26509e70c6296df1aa023\
                5e4fe20c159c5745ef[ALL]\
                025a561f14893e47dc233bdd10ee71baf40aa41cc0016d40eb7c2ce533c72\
                1dc85",
        "hex": "4730440220284202dced1c634241d4a8443336122c59feb8d79ece4a9e850\
                34924c850428c0220028dd652b1dde3527d1b5368e26509e70c6296df1aa0\
                235e4fe20c159c5745ef0121025a561f14893e47dc233bdd10ee71baf40aa\
                41cc0016d40eb7c2ce533c721dc85"
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 10.00000000,
      "valueSat": 1000000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 69563940b81d56670418ddb0d83c2245c07c19e2 OP_EQUAL",
        "desc": "addr(8p2Rx8VUP4XJATHcm29VpqAkeFyyf2kHYG)#wdpwlup7",
        "hex": "a91469563940b81d56670418ddb0d83c2245c07c19e287",
        "address": "8p2Rx8VUP4XJATHcm29VpqAkeFyyf2kHYG",
        "type": "scripthash"
      }
    },
    {
      "value": 479.99999552,
      "valueSat": 47999999552,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 091621776dd32076999341a3d80ca20a4d19c80d\
                OP_EQUALVERIFY OP_CHECKSIG",
        "desc": "addr(yM9VSbj1EqXARjavbPTq2Nt2JNN7RkRDNx)#mhpmvzp2",
        "hex": "76a914091621776dd32076999341a3d80ca20a4d19c80d88ac",
        "address": "yM9VSbj1EqXARjavbPTq2Nt2JNN7RkRDNx",
        "type": "pubkeyhash"
      }
    }
  ],
  "hex": "02000000010bf9d56cc19de7fe0ab29f7a41a6f582b4ccc29a686512dee78c7369e\
          a7cd4e3010000006a4730440220284202dced1c634241d4a8443336122c59feb8d7\
          9ece4a9e85034924c850428c0220028dd652b1dde3527d1b5368e26509e70c6296d\
          f1aa0235e4fe20c159c5745ef0121025a561f14893e47dc233bdd10ee71baf40aa4\
          1cc0016d40eb7c2ce533c721dc85feffffff0200ca9a3b0000000017a9146956394\
          0b81d56670418ddb0d83c2245c07c19e28740de052d0b0000001976a91409162177\
          6dd32076999341a3d80ca20a4d19c80d88ac67000000",
  "instantlock": false,
  "instantlock_internal": false,
  "chainlock": false
}
```

``` bash

> UTXO_VOUT=0
> UTXO_OUTPUT_SCRIPT=a91469563940b81d56670418ddb0d83c2245c07c19e287
```

## 6. Get new address

We generate a new P2PKH address to use in the output we're about to create.

``` bash
> dash-cli -regtest getnewaddress
yVAck79kZPLKcAigYMgZ4kwKpWWXCCtRpG

> NEW_ADDRESS4=yVAck79kZPLKcAigYMgZ4kwKpWWXCCtRpG
```

## 7. Create raw transaction

We generate the [raw transaction](../resources/glossary.md#raw-transaction) the same way we did in the [Simple Raw Transaction subsection](../examples/transaction-tutorial-simple-raw-transaction.md).

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
     "'$NEW_ADDRESS4'": 9.998
   }'''
0200000001812b1eb2451955b457c144a60576d75181be65806ad8a3a2004699\
9dd910dab50000000000ffffffff01c0bc973b000000001976a914610da5f2fb\
0015ccd58160ffdf13742b2f06fb5388ac00000000

> RAW_TX=0200000001812b1eb2451955b457c144a60576d75181be65806ad8a[...]
```

## 8. Get private key

We get the [private keys](../resources/glossary.md#private-key) for two of the [public keys](../resources/glossary.md#public-key) we used to create the transaction, the same way we got private keys in the [Complex Raw Transaction subsection](../examples/transaction-tutorial-complex-raw-transaction.md). Recall that we created a 2-of-3 multisig pubkey script, so signatures from two private keys are needed.

:::{attention}
Users should never manually manage private keys on mainnet. See the warning in the [complex raw transaction section](../examples/transaction-tutorial-complex-raw-transaction.md).
:::

:::{note}
The `dumpprivkey` RPC only works with legacy wallets. See the [tutorial setup](../examples/transaction-tutorial.md#setup) to create one.
:::

``` bash
> dash-cli -regtest dumpprivkey $NEW_ADDRESS1
cThkdLpDvXmGkHnAYAV9wyeF4DwzbPSVNkZiX3PPYGVvfxGGDorQ
> dash-cli -regtest dumpprivkey $NEW_ADDRESS3
cTQKdUistYTdzjmwVywWMNEcfsgpupU1Dk7dnCTaBdL95HSAULWM

> NEW_ADDRESS1_PRIVATE_KEY=cThkdLpDvXmGkHnAYAV9wyeF4DwzbPSVNkZiX[...]
> NEW_ADDRESS3_PRIVATE_KEY=cTQKdUistYTdzjmwVywWMNEcfsgpupU1Dk7dn[...]
```

## 9. Sign raw transaction

### 9a. Private Key 1

We make the first [signature](../resources/glossary.md#signature). The input argument (JSON object) takes the additional [redeem script](../resources/glossary.md#redeem-script) parameter so that it can append the redeem script to the [signature script](../resources/glossary.md#signature-script) after the two signatures.

``` bash
> dash-cli -regtest signrawtransactionwithkey $RAW_TX '''
    [
      "'$NEW_ADDRESS1_PRIVATE_KEY'"
    ]''' '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'",
        "redeemScript": "'$P2SH_REDEEM_SCRIPT'"
      }
    ]
    '''
```

``` json
{
  "hex": "0200000001812b1eb2451955b457c144a60576d75181be65806ad8a3a20046999dd\
          910dab500000000b500473044022015c04240ce607fcdddd81f2a77ed8950fa7b51\
          02f70219e1412c0f4e924addf202201022ee2a35b0c19cbce07b848779c36d47db3\
          db066a18467cc039db0dd69baf001004c69522103fb039547a8655522aee01d6b2e\
          4bd9c8f29ddf10862c4ac9d29d209212e74b4a21022f44ad116f6b73ca45b62b169\
          64a44037399ca18a254abadbe32abe1ddcfaf7921035a8135bb28040114988a8193\
          43420f3a859f188b738851e10774209077da3dd753aeffffffff01c0bc973b00000\
          0001976a914610da5f2fb0015ccd58160ffdf13742b2f06fb5388ac00000000",
  "complete": false,
  "errors": [
    {
      "txid": "b5da10d99d994600a2a3d86a8065be8151d77605a644c157b4551945b21e2b81",
      "vout": 0,
      "scriptSig": "00473044022015c04240ce607fcdddd81f2a77ed8950fa7b5102f7021\
                    9e1412c0f4e924addf202201022ee2a35b0c19cbce07b848779c36d47\
                    db3db066a18467cc039db0dd69baf001004c69522103fb039547a8655\
                    522aee01d6b2e4bd9c8f29ddf10862c4ac9d29d209212e74b4a21022f\
                    44ad116f6b73ca45b62b16964a44037399ca18a254abadbe32abe1ddc\
                    faf7921035a8135bb28040114988a819343420f3a859f188b738851e1\
                    0774209077da3dd753ae",
      "sequence": 4294967295,
      "error": "CHECK(MULTI)SIG failing with non-zero signature (possibly\
                need more signatures)"
    }
  ]
}
```

``` bash

> PARTLY_SIGNED_RAW_TX=0200000001812b1eb2451955b457c144a60576d75[...]
```

### 9b. Private Key 3

The [`signrawtransactionwithkey`](../api/remote-procedure-calls-raw-transactions.md#signrawtransactionwithkey) call used here is nearly identical to the one used above.  The only difference is the private key used.  Now that the two required signatures have been provided, the transaction is marked as complete.

``` bash
> dash-cli -regtest signrawtransactionwithkey $PARTLY_SIGNED_RAW_TX '''
    [
      "'$NEW_ADDRESS3_PRIVATE_KEY'"
    ]''' '''
    [
      {
        "txid": "'$UTXO_TXID'",
        "vout": '$UTXO_VOUT',
        "scriptPubKey": "'$UTXO_OUTPUT_SCRIPT'",
        "redeemScript": "'$P2SH_REDEEM_SCRIPT'"
      }
    ]
    '''
```

``` json
{
  "hex": "0200000001812b1eb2451955b457c144a60576d75181be65806ad8a3a20046999dd\
          910dab500000000fc00473044022015c04240ce607fcdddd81f2a77ed8950fa7b51\
          02f70219e1412c0f4e924addf202201022ee2a35b0c19cbce07b848779c36d47db3\
          db066a18467cc039db0dd69baf001473044022068b211eff43d5163c4c2bb588792\
          1a673b958248d13c9f20c921f4c841a02981022046dbd6951369ac6bdb94022b17c\
          e8ae8373e9c2a8922d8fd7b2a7b260d9dea95014c69522103fb039547a8655522ae\
          e01d6b2e4bd9c8f29ddf10862c4ac9d29d209212e74b4a21022f44ad116f6b73ca4\
          5b62b16964a44037399ca18a254abadbe32abe1ddcfaf7921035a8135bb28040114\
          988a819343420f3a859f188b738851e10774209077da3dd753aeffffffff01c0bc9\
          73b000000001976a914610da5f2fb0015ccd58160ffdf13742b2f06fb5388ac0000\
          0000",
  "complete": true
}
```

``` bash

> SIGNED_RAW_TX=0200000001812b1eb2451955b457c144a60576d75181be65[...]
```

## 10. Send raw transaction

We send the transaction spending the P2SH multisig output to the local [node](../resources/glossary.md#node), which accepts it.

``` bash
> dash-cli -regtest sendrawtransaction $SIGNED_RAW_TX
707fd6b1d7114769fc635f0c550f484eee785efe9b9523720805cfd5094bbfdb
```
