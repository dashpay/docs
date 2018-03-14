.. _electrum_faq:

Frequently Asked Questions
==========================

How does Electrum work?
-----------------------

Electrum’s focus is speed, low resource usage and providing a simple
user experience for Dash. Startup times are instant because it operates
in conjunction with high- performance servers that handle the most
complicated parts of the Dash system.

Does Electrum trust servers?
----------------------------

Not really; the Dash Electrum client never sends private keys to the
servers. In addition, it verifies the information reported by
servers, using a technique called `Simple Payment Verification
<http://docs.electrum.org/en/latest/spv.html#spv>`_.

What is the Seed?
-----------------

The seed is a random phrase that is used to generate your private keys.
Example:

``constant forest adore false green weave stop guy fur freeze giggle
clock``

Your wallet can be entirely recovered from its seed. To do this, select
the **I already have a seed** option during startup.

How secure is the seed?
-----------------------

The seed created by Electrum has 128 bits of entropy. This means that
it provides the same level of security as a Dash private key (of
length 256 bits). Indeed, an elliptic curve key of length n provides
n/2 bits of security.

How can I send the maximum available in my wallet?
--------------------------------------------------

Type an exclamation mark (!) in the **Amount** field. The fee will be
automatically adjusted for that amount.

How can I send Dash without paying a transaction fee?
-----------------------------------------------------

You can create a zero fee transaction in the GUI by following these
steps:

-  Enable the **Edit fees manually** option
-  Enter 0 in the fee field
-  Enter the amount in the amount field

Note that transactions without fees might not be relayed by the Dash
Electrum server, or by the Dash network.

What does it mean to “Freeze” an address in Electrum?
-----------------------------------------------------

When you freeze an address, the funds in that address will not be used
for sending Dash. You can not send Dash if you don’t have enough funds
in your non-frozen addresses.

What encryption is used for wallets?
------------------------------------

Electrum uses AES-256-CBC to encrypt the seed and private keys in the
wallet.

I have forgotten my password but still have my seed. Is there any way I can recover my password?
------------------------------------------------------------------------------------------------

No, you cannot recover your password. However, you can still recover
your money: restore your wallet from its seed, and choose a new
password.

Why can I open the wallet without entering my password?
-------------------------------------------------------

Only the seed and private keys are encrypted, and not the entire wallet
file. The private keys are decrypted only briefly when you need to sign
a transaction; for this you need to enter your password. This is done in
order to minimize the amount of time during which sensitive information
is unencrypted in your computer’s memory.

Does Electrum support cold wallets?
-----------------------------------

Yes. see \ `Cold Storage
<http://docs.electrum.org/en/latest/coldstorage.html#coldstorage>`_.

Can I import private keys from other Dash clients?
--------------------------------------------------

In Dash Electrum 2.0, you cannot import private keys in a wallet that
has a seed. You should sweep them instead.

If you want to import private keys and not sweep them you need to create
a special wallet that does not have a seed. For this, create a new
wallet, select **Use public or private keys**, and instead of typing
your seed, type a list of private keys, or a list of addresses if you
want to create a watching-only wallet. A master public (xpub) or private
(xprv) will also work to import a hierarchical deterministic series of
keys.

