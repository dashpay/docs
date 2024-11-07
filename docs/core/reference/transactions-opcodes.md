```{eval-rst}
.. meta::
  :title: Opcodes
  :description: Base Opcodes are used in the pubkey scripts of standard transactions.  DIP 20 also reintroduced a number of these opcodes based on work done by Bitcoin Cash developers.
```

# Opcodes

## Base Opcodes

The [opcodes](../resources/glossary.md#opcode) used in the pubkey scripts of standard [transactions](../resources/glossary.md#transaction) are:

* Various data pushing opcodes from 0x00 to 0x4e (1--78). These aren't typically shown in examples, but they must be used to push [signatures](../resources/glossary.md#signature) and [public keys](../resources/glossary.md#public-key) onto the stack. See the link below this list for a description.

* `OP_TRUE`/`OP_1` (0x51) and `OP_2` through `OP_16` (0x52--0x60), which push the values 1 through 16 to the stack.

* `OP_VERIFY` (0x69) consumes the topmost item on the stack. If that item is zero (false) it terminates the script in failure.

* `OP_RETURN` (0x6a) terminates the script in failure when executed.

* `OP_DUP` (0x76) pushes a copy of the topmost stack item on to the stack.

* `OP_EQUAL` (0x87) consumes the top two items on the stack, compares them, and pushes true onto the stack if they are the same, false if not.

* `OP_EQUALVERIFY` (0x88) runs `OP_EQUAL` and then `OP_VERIFY` in sequence.

* `OP_HASH160` (0xa9) consumes the topmost item on the stack, computes the RIPEMD160(SHA256()) hash of that item, and pushes that hash onto the stack.

**<span id="op_checksig"></span>**

* `OP_CHECKSIG` (0xac) consumes a signature and a full public key, and pushes true onto the stack if the transaction data specified by the [SIGHASH flag](../resources/glossary.md#sighash-flag) was converted into the signature using the same [ECDSA private key](../resources/glossary.md#ecdsa-private-key) that generated the public key. Otherwise, it pushes false onto the stack.

* `OP_CHECKMULTISIG` (0xae) consumes the value (n) at the top of the stack, consumes that many of the next stack levels (public keys), consumes the value (m) now at the top of the stack, and consumes that many of the next values (signatures) plus one extra value.

    The "one extra value" it consumes is the result of an off-by-one error in the Bitcoin Core implementation. This value is not used, so signature scripts prefix the list of [secp256k1 signatures](../resources/glossary.md#secp256k1-signatures) with a single OP_0 (0x00).

    `OP_CHECKMULTISIG` compares the first signature against each public key until it finds an [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm) match. Starting with the subsequent public key, it compares the second signature against each remaining public key until it finds an ECDSA match. The process is repeated until all signatures have been checked or not enough public keys remain to produce a successful result.

    Because public keys are not checked again if they fail any signature comparison, signatures must be placed in the signature script using the same order as their corresponding public keys were placed in the [pubkey script](../resources/glossary.md#pubkey-script) or [redeem script](../resources/glossary.md#redeem-script). See the `OP_CHECKMULTISIG` warning below for more details.

A complete list of Bitcoin opcodes can be found on the Bitcoin Wiki [Script Page](https://en.bitcoin.it/wiki/Script), with an authoritative list in the `opcodetype` enum of the Dash Core [script header file](https://github.com/dashpay/dash/blob/master/src/script/script.h).

## Expanded Opcodes

Several opcodes were disabled in the Bitcoin scripting system due to the discovery of a series of bugs in the early days of Bitcoin. [Dash Improvement Proposal 20](https://github.com/dashpay/dips/blob/master/dip-0020.md) reintroduced a number of these opcodes based on work done by Bitcoin Cash developers. Many of the disabled opcodes have been enabled and several of them re-designed to replace the original ones. The following opcodes were added/reactivated in Dash Core 0.17.0 as described in [DIP 20](https://github.com/dashpay/dips/blob/master/dip-0020.md).

* `OP_CAT` (0x7e) concatenates two byte arrays.

* `OP_SPLIT` (0x7f) Split byte array `x` at position `n`. *This opcode was disabled and named `OP_SUBSTR` prior to Dash Core 0.17.0*.

* `OP_NUM2BIN` (0x80) Convert numeric `a` into byte array of length `b`. *This opcode was disabled and named `OP_LEFT` prior to Dash Core 0.17.0*.

* `OP_BIN2NUM` (0x81) Convert byte array `x` into numeric. *This opcode was disabled and named `OP_RIGHT` prior to Dash Core 0.17.0*.

* `OP_AND` (0x84) Boolean *AND* between each bit in the operands.

* `OP_OR` (0x85) Boolean *OR* between each bit in the operands.

* `OP_XOR` (0x86) Boolean *EXCLUSIVE OR* between each bit in the operands.

* `OP_DIV` (0x96) Return the integer quotient of `a` and `b`. If the result would be a non-integer it is rounded towards zero. `a` and `b` are interpreted as numeric values.

* `OP_MOD` (0x97) Returns the remainder after dividing `a` by `b`. The output will be represented using the least number of bytes required. `a` and `b` are interpreted as numeric values.

* `OP_CHECKDATASIG` (0xba) Checks whether a signature is valid with respect to a message and a public key. It allows Script to validate arbitrary messages from outside the blockchain.

* `OP_CHECKDATASIGVERIFY` (0xbb) `OP_CHECKDATASIGVERIFY` is equivalent to `OP_CHECKDATASIG` followed by `OP_VERIFY`. It leaves nothing on the stack and will cause the script to fail immediately if the signature check does not pass.

## Signature Scripts

### Signature Script Modification

![Warning icon](../../img/icons/icon_warning.svg) **<span id="signature_script_modification_warning">Signature script modification warning</span>:** [Signature scripts](../resources/glossary.md#signature-script) are not signed, so anyone can modify them. This means signature scripts should only contain data and [data-pushing opcode](../resources/glossary.md#data-pushing-opcode) which can't be modified without causing the pubkey script to fail. Placing non-data-pushing opcodes in the signature script currently makes a transaction non-standard, and future consensus rules may forbid such transactions altogether. (Non-data-pushing opcodes are already forbidden in signature scripts when spending a [P2SH pubkey script](../resources/glossary.md#p2sh-pubkey-script).)

### Multisig Signature Order

![Warning icon](../../img/icons/icon_warning.svg) **`OP_CHECKMULTISIG` warning:** The [multisig](../resources/glossary.md#multisig) verification process described above requires that signatures in the signature script be provided in the same order as their corresponding public keys in the pubkey script or redeem script. For example, the following combined signature and pubkey script will produce the stack and comparisons shown:

``` text
OP_0 <A sig> <B sig> OP_2 <A pubkey> <B pubkey> <C pubkey> OP_3

Sig Stack       Pubkey Stack  (Actually a single stack)
---------       ------------
B sig           C pubkey
A sig           B pubkey
OP_0            A pubkey

1. B sig compared to C pubkey (no match)
2. B sig compared to B pubkey (match #1)
3. A sig compared to A pubkey (match #2)

Success: two matches found
```

But reversing the order of the signatures with everything else the same will fail, as shown below:

``` text
OP_0 <B sig> <A sig> OP_2 <A pubkey> <B pubkey> <C pubkey> OP_3

Sig Stack       Pubkey Stack  (Actually a single stack)
---------       ------------
A sig           C pubkey
B sig           B pubkey
OP_0            A pubkey

1. A sig compared to C pubkey (no match)
2. A sig compared to B pubkey (no match)

Failure, aborted: two signature matches required but none found so
                  far, and there's only one pubkey remaining
```
