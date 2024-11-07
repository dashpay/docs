```{eval-rst}
.. meta::
  :title: Micropayment Channel
  :description: A micropayment channel allows two parties to exchange cryptocurrency off-chain, bypassing blockchain interactions.
```

# Micropayment Channel

Alice also works part-time moderating forum posts for Bob. Every time someone posts to Bob's busy forum, Alice skims the post to make sure it isn't offensive or spam. Alas, Bob often forgets to pay her, so Alice demands to be paid immediately after each post she approves or rejects. Bob says he can't do that because hundreds of small payments will cost him thousands of [duffs](../resources/glossary.md#duffs) in transaction fees, so Alice suggests they use a micropayment channel.

Bob asks Alice for her [public key](../resources/glossary.md#public-key) and then creates two [transactions](../resources/glossary.md#transaction). The first transaction pays 100 millidash to a P2SH output whose 2-of-2 multisig [redeem script](../resources/glossary.md#redeem-script) requires [signatures](../resources/glossary.md#signature) from both Alice and Bob. This is the bond transaction. Broadcasting this transaction would let Alice hold the millidash hostage, so Bob keeps this transaction private for now and creates a second transaction.

The second transaction spends all of the first transaction's millidash (minus a transaction fee) back to Bob after a 24 hour delay enforced by locktime. This is the refund transaction. Bob can't sign the refund transaction by himself, so he gives it to Alice to sign, as shown in the illustration below.

![Micropayment Channel Example](../../img/dev/en-micropayment-channel.svg)

Alice checks that the refund transaction's locktime is 24 hours in the future, signs it, and gives a copy of it back to Bob. She then asks Bob for the bond transaction and checks that the refund transaction spends the output of the bond transaction. She can now broadcast the bond transaction to the network to ensure Bob has to wait for the time lock to expire before further spending his millidash. Bob hasn't actually spent anything so far, except possibly a small [transaction fee](../resources/glossary.md#transaction-fee), and he'll be able to broadcast the refund transaction in 24 hours for a full refund.

Now, when Alice does some work worth 1 millidash, she asks Bob to create and sign a new version of the refund transaction.  Version two of the transaction spends 1 millidash to Alice and the other 99 back to Bob; it does not have a locktime, so Alice can sign it and spend it whenever she wants.  (But she doesn't do that immediately.)

Alice and Bob repeat these work-and-pay steps until Alice finishes for the day, or until the time lock is about to expire.  Alice signs the final version of the refund transaction and broadcasts it, paying herself and refunding any remaining balance to Bob.  The next day, when Alice starts work, they create a new micropayment channel.

If Alice fails to broadcast a version of the refund transaction before its time lock expires, Bob can broadcast the first version and receive a full refund. This is one reason micropayment channels are best suited to small payments---if Alice's Internet service goes out for a few hours near the time lock expiry, she could be cheated out of her payment.

Transaction malleability, discussed in the [Transactions section](../guide/transactions-transaction-malleability.md), is another reason to limit the value of micropayment channels. If someone uses transaction malleability to break the link between the two transactions, Alice could hold Bob's 100 millidash hostage even if she hadn't done any work.

For larger payments, Dash transaction fees are very low as a percentage of the total transaction value, so it makes more sense to protect payments with immediately-broadcast separate transactions.
