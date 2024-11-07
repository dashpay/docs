```{eval-rst}
.. meta::
  :title: Standard Transactions
  :description: Standard transactions in Dash are those that pass the IsStandard() test, meaning they adhere to certain safety and good network behavior rules.
```

# Standard Transactions

After the discovery of several dangerous bugs in early versions of Bitcoin, a test was added which only accepted [transactions](../resources/glossary.md#transaction) from the [network](../resources/glossary.md#network) if their pubkey scripts and signature scripts matched a small set of believed-to-be-safe templates, and if the rest of the transaction didn't violate another small set of rules enforcing good network behavior. This is the `IsStandard()` test, and transactions which pass it are called standard transactions.

Non-standard transactions---those that fail the test---may be accepted by [nodes](../resources/glossary.md#node) not using the default Dash Core settings. If they are included in blocks, they will also avoid the IsStandard test and be processed.

Besides making it more difficult for someone to attack Dash for free by broadcasting harmful transactions, the standard transaction test also helps prevent users from creating transactions today that would make adding new transaction features in the future more difficult. For example, as described above, each transaction includes a version number---if users started arbitrarily changing the version number, it would become useless as a tool for introducing backwards-incompatible features.

As of Dash Core 0.12.2, the standard pubkey script types are:

## Pay To Public Key Hash (P2PKH)

[P2PKH](../resources/glossary.md#pay-to-pubkey-hash) is the most common form of pubkey script used to send a transaction to one or multiple Dash [addresses](../resources/glossary.md#address).

```
Pubkey script: OP_DUP OP_HASH160 <PubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Signature script: <sig> <pubkey>
```

## Pay To Script Hash (P2SH)

[P2SH](../resources/glossary.md#pay-to-script-hash) is used to send a transaction to a script hash. Each of the standard pubkey scripts can be used as a P2SH redeem script, but in practice only the multisig pubkey script makes sense until more transaction types are made standard.

```
Pubkey script: OP_HASH160 <Hash160(redeemScript)> OP_EQUAL
Signature script: <sig> [sig] [sig...] <redeemScript>
```

## Multisig

Although P2SH multisig is now generally used for multisig transactions, this base script can be used to require multiple signatures before a UTXO can be spent.

In multisig pubkey scripts, called m-of-n, *m* is the *minimum* number of signatures which must match a public key; *n* is the *number* of public keys being provided. Both *m* and *n* should be opcodes `OP_1` through `OP_16`, corresponding to the number desired.

Because of an off-by-one error in the original Bitcoin implementation which must be preserved for compatibility, `OP_CHECKMULTISIG` consumes one more value from the stack than indicated by *m*, so the list of secp256k1 signatures in the signature script must be prefaced with an extra value (`OP_0`) which will be consumed but not used.

The signature script must provide signatures in the same order as the corresponding public keys appear in the pubkey script or redeem script. See the description in [`OP_CHECKMULTISIG`](../reference/transactions-opcodes.md) for details.

```
Pubkey script: <m> <A pubkey> [B pubkey] [C pubkey...] <n> OP_CHECKMULTISIG
Signature script: OP_0 <A sig> [B sig] [C sig...]
```

Although it’s not a separate transaction type, this is a P2SH multisig with 2-of-3:

```
Pubkey script: OP_HASH160 <Hash160(redeemScript)> OP_EQUAL
Redeem script: <OP_2> <A pubkey> <B pubkey> <C pubkey> <OP_3> OP_CHECKMULTISIG
Signature script: OP_0 <A sig> <C sig> <redeemScript>
```

## Pubkey

Pubkey [outputs](../resources/glossary.md#output) are a simplified form of the P2PKH pubkey script, but they aren’t as secure as P2PKH, so they generally aren’t used in new transactions anymore.

```
Pubkey script: <pubkey> OP_CHECKSIG
Signature script: <sig>
```

## Null Data

Null data transactions (relayed and mined by default in Bitcoin Core 0.9.0 and later) add arbitrary data to a provably unspendable pubkey script that full [nodes](../resources/glossary.md#node) don't have to store in their UTXO database. It is preferable to use null data transactions over transactions that bloat the UTXO database because they cannot be automatically pruned; however, it is usually even more preferable to store data outside transactions if possible.

Consensus rules allow null data outputs up to the maximum allowed pubkey script size of 10,000 bytes provided they follow all other consensus rules, such as not having any data pushes larger than 520 bytes.

Dash Core 0.11.x, by default, relayed and mined null data transactions with up to 40 bytes in a single data push and only one null data output that pays exactly 0 duffs:

```
Pubkey Script: OP_RETURN <0 to 40 bytes of data>
(Null data scripts cannot be spent, so there's no signature script.)
```

Dash Core 0.12.1+ defaults to relaying and mining null data outputs with up to 83 bytes with any number of data pushes, provided the total byte limit is not exceeded. There must still only be a single null data output and it must still pay exactly 0 duffs.

:::{note}
Since the null data output must include opcodes, the limit for data is less than 83 bytes. A typical `OP_RETURN` is limited to 80 bytes due to the following 3 required bytes:

* `OP_RETURN` (0x6a)
* `OP_PUSHDATA1` (0x4c)
* Data Size (e.g. 0x50 for 80 bytes)
:::

The following annotated hexdump shows an example `OP_RETURN` output:

``` bash
6a ......................................... OP_RETURN Opcode
4c ......................................... OP_PUSHDATA1 Opcode
50 ......................................... Bytes to push: 80

48656c6c6f2066726f6d207468657068657a203
a2d29205468697320697320746865206d617869
6d756d2074657874206c656e67746820616c6c6
f77656420666f7220616e204f505f5245545552
4e2e ....................................... Data
```

The `-datacarriersize` Dash Core configuration option allows you to set the maximum number of bytes in null data outputs that you will relay or mine.
