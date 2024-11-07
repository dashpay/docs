```{eval-rst}
.. meta::
  :title: Avoiding Key Reuse
  :description: Avoiding key reuse in Dash is the practice of using each public key only twice (to receive and spend a payment) to enhance financial privacy and security.
```

# Avoiding Key Reuse

In a [transaction](../resources/glossary.md#transaction), the spender and receiver each reveal to each other all [public keys](../resources/glossary.md#public-key) or [addresses](../resources/glossary.md#address) used in the transaction. This allows either person to use the public [block chain](../resources/glossary.md#block-chain) to track past and future transactions involving the other person's same public keys or addresses.

If the same public key is reused often, as happens when people use Dash addresses (hashed public keys) as static payment addresses, other people can easily track the receiving and spending habits of that person, including how many [duffs](../resources/glossary.md#duffs) they control in known addresses.

It doesn't have to be that way. If each public key is used exactly twice---once to receive a payment and once to spend that payment---the user can gain a significant amount of financial privacy.

Even better, using new public keys or [unique addresses](../resources/glossary.md#unique-addresses) when accepting payments or creating change outputs can be combined with other techniques discussed later, such as CoinJoin or merge avoidance, to make it extremely difficult to use the block chain by itself to reliably track how users receive and spend their duffs.

Avoiding key reuse can also provide security against attacks which might allow reconstruction of [private keys](../resources/glossary.md#private-key) from public keys (hypothesized) or from signature comparisons (possible today under certain circumstances described below, with more general attacks hypothesized).

1. Unique (non-reused) [P2PKH](../resources/glossary.md#pay-to-pubkey-hash) and [P2SH](../resources/glossary.md#pay-to-script-hash) addresses protect against the first type of attack by keeping ECDSA public keys hidden (hashed) until the first time duffs sent to those addresses are spent, so attacks are effectively useless unless they can reconstruct private keys in less than the hour or two it takes for a transaction to be well protected by the block chain.

2. Unique (non-reused) private keys protect against the second type of attack by only generating one signature per private key, so attackers never get a subsequent signature to use in comparison-based attacks. Existing comparison-based attacks are only practical today when insufficient entropy is used in signing or when the entropy used is exposed by some means, such as a [side-channel attack](https://en.wikipedia.org/wiki/Side_channel_attack).

So, for both privacy and security, we encourage you to build your applications to avoid public key reuse and, when possible, to discourage users from reusing addresses. If your application needs to provide a fixed URI to which payments should be sent, please use `dash:` URIs as defined by [BIP21](https://github.com/dashevo/bips/blob/master/bip-0021.mediawiki#general-format).
