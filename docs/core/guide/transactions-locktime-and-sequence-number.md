```{eval-rst}
.. meta::
  :title: Locktime and Sequence Number
  :description: Locktime specifies the earliest a transaction can be added to the blockchain, while Sequence Number can enable or disable this locktime.
```

# Locktime and Sequence Number

One thing all signature hash types sign is the transaction's [locktime](../resources/glossary.md#locktime). (Called nLockTime in the Dash Core source code.) The locktime indicates the earliest time a [transaction](../resources/glossary.md#transaction) can be added to the [block chain](../resources/glossary.md#block-chain).

Locktime allows signers to create time-locked transactions which will only become valid in the future, giving the signers a chance to change their minds.

If any of the signers change their mind, they can create a new non-locktime transaction. The new transaction will use, as one of its [inputs](../resources/glossary.md#input), one of the same [outputs](../resources/glossary.md#output) which was used as an input to the locktime transaction. This makes the locktime transaction invalid if the new transaction is added to the block chain before the time lock expires.

Care must be taken near the expiry time of a time lock. The peer-to-peer [network](../resources/glossary.md#network) allows block time to be up to two hours ahead of real time, so a locktime transaction can be added to the block chain up to two hours before its time lock officially expires. Also, blocks are not created at guaranteed intervals, so any attempt to cancel a valuable transaction should be made a few hours before the time lock expires.

Previous versions of Dash Core provided a feature which prevented transaction signers from using the method described above to cancel a time-locked transaction, but a necessary part of this feature was disabled to prevent denial of service attacks. A legacy of this system is a four-byte [sequence number](../resources/glossary.md#sequence-number) in every input. Sequence numbers were meant to allow multiple signers to agree to update a transaction; when they finished updating the transaction, they could agree to set every input's sequence number to the four-byte unsigned maximum (0xffffffff), allowing the transaction to be added to a block even if its time lock had not expired.

Even today, setting all sequence numbers to 0xffffffff (the default in Dash Core) can still disable the time lock, so if you want to use locktime, at least one input must have a sequence number below the maximum. Since sequence numbers are not used by the network for any other purpose, setting any sequence number to zero is sufficient to enable locktime.

## Locktime Parsing Rules

<span id="locktime_parsing_rules">Locktime itself is an unsigned 4-byte integer which can be parsed two ways:</span>

* If less than 500 million, locktime is parsed as a [block height](../resources/glossary.md#block-height). The transaction can be added to any block which has this height or higher.

* If greater than or equal to 500 million, locktime is parsed using the Unix epoch time format (the number of seconds elapsed since 1970-01-01T00:00 UTC---currently over 1.395 billion). The transaction can be added to any block whose block time is greater than the locktime.
