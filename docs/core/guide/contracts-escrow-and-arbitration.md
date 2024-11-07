```{eval-rst}
.. meta::
  :title: Escrow and Arbitration
  :description: A transaction in which a spender and receiver place funds in an m-of-n multisig output so that neither can spend the funds until they’re both satisfied with some external outcome.
```

# Escrow and Arbitration

Charlie-the-customer wants to buy a product from Bob-the-businessman, but neither of them trusts the other person, so they use a contract to help ensure Charlie gets his merchandise and Bob gets his payment.

A simple contract could say that Charlie will spend [duffs](../resources/glossary.md#duffs) to an [output](../resources/glossary.md#output) which can only be spent if Charlie and Bob both sign the [input](../resources/glossary.md#input) spending it. That means Bob won't get paid unless Charlie gets his merchandise, but Charlie can't get the merchandise and keep his payment.

This simple contract isn't much help if there's a dispute, so Bob and Charlie enlist the help of Alice-the-arbitrator to create an [escrow contract](../resources/glossary.md#escrow-contract). Charlie spends his duffs to an output which can only be spent if two of the three people sign the input. Now Charlie can pay Bob if everything is ok, Bob can refund Charlie's money if there's a problem, or Alice can arbitrate and decide who should get the duffs if there's a dispute.

To create a multiple-signature ([multisig](../resources/glossary.md#multisig)) output, they each give the others a [public key](../resources/glossary.md#public-key). Then Bob creates the following [P2SH multisig](../resources/glossary.md#p2sh-multisig) [redeem script](../resources/glossary.md#redeem-script):

```
OP_2 [A's pubkey] [B's pubkey] [C's pubkey] OP_3 OP_CHECKMULTISIG
```

(Opcodes to push the public keys onto the stack are not shown.)

`OP_2` and `OP_3` push the actual numbers 2 and 3 onto the stack. `OP_2` specifies that 2 signatures are required to sign; `OP_3` specifies that 3 public keys (unhashed) are being provided. This is a 2-of-3 multisig pubkey script, more generically called a m-of-n pubkey script (where *m* is the *minimum* matching signatures required and *n* in the *number* of public keys provided).

Bob gives the redeem script to Charlie, who checks to make sure his public key and Alice's public key are included. Then he hashes the redeem script to create a [P2SH](../resources/glossary.md#pay-to-script-hash) redeem script and pays the duffs to it. Bob sees the payment get added to the [block chain](../resources/glossary.md#block-chain) and ships the merchandise.

Unfortunately, the merchandise gets slightly damaged in transit. Charlie wants a full refund, but Bob thinks a 10% refund is sufficient. They turn to Alice to resolve the issue. Alice asks for photo evidence from Charlie along with a copy of the redeem script Bob created and Charlie checked.

After looking at the evidence, Alice thinks a 40% refund is sufficient, so she creates and signs a transaction with two outputs, one that spends 60% of the duffs to Bob's public key and one that spends the remaining 40% to Charlie's public key.

In the [signature script](../resources/glossary.md#signature-script) Alice puts her signature and a copy of the unhashed serialized redeem script that Bob created.  She gives a copy of the incomplete transaction to both Bob and Charlie.  Either one of them can complete it by adding his signature to create the following signature script:

```
OP_0 [A's signature] [B's or C's signature] [serialized redeem script]
```

(Opcodes to push the signatures and redeem script onto the stack are not shown. `OP_0` is a workaround for an off-by-one error in the original implementation which must be preserved for compatibility.  Note that the signature script must provide signatures in the same order as the corresponding public keys appear in the redeem script.  See the description in [`OP_CHECKMULTISIG`](../reference/transactions-opcodes.md) for details.)

When the transaction is broadcast to the [network](../resources/glossary.md#network), each [peer](../resources/glossary.md#peer) checks the signature script against the P2SH output Charlie previously paid, ensuring that the redeem script matches the redeem script hash previously provided. Then the redeem script is evaluated, with the two signatures being used as input data. Assuming the redeem script validates, the two transaction outputs show up in Bob's and Charlie's wallets as spendable balances.

However, if Alice created and signed a transaction neither of them would agree to, such as spending all the duffs to herself, Bob and Charlie can find a new arbitrator and sign a transaction spending the duffs to another 2-of-3 multisig redeem script hash, this one including a public key from that second arbitrator. This means that Bob and Charlie never need to worry about their arbitrator stealing their money.
