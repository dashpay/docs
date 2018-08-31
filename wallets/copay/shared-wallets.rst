.. meta::
   :description: Setting up shared multi-signature wallets using Dash Copay
   :keywords: dash, mobile, wallet, copay, multisig, ios, android, shared wallet

.. _dash-copay:

==============
Shared Wallets
==============

Normal transactions in Dash only need to be approved by the person
sending the funds. The Dash Copay wallet supports multisig, short for
multisignature, meaning that it is possible to require more than one key
to approve a transaction. This can be used like a joint checking
account, or in situations where majority approval from a board is
required to create a transaction. This documentation describes how to
set up and use shared wallets.

Before you create a shared wallet, think about how many people should
have access to it, and how many of those people will be required to
authorise a transaction. Is it just one or two? Or a majority, or even
everyone? Shared wallets allow you to specify a total number of copayers
and a required number of signatures to create a transaction. These are
often referred to as M-of-N transactions, where for example 2-of-3
signatures are required to transact. In practice, this is used to share
responsibility for the funds between several people. It is not possible
require a certain person, such as the manager, to be one of the copayers
(although adding a password only the manager knows can have the same
effect). Shared wallets are inherently risky because if more than the
minimum required number of people involved lose access to their keys,
the funds will be inaccessible forever. Make sure everyone understands
the risks and responsibilities of shared wallets before committing
significant funds.

Creating a shared wallet
========================

Funds and addresses in shared wallets are managed separately from your
personal wallets, so you will need to create a new wallet and then add
copayers before you can begin creating transactions. From the **Home**
screen, click the + button at the top right to add a new wallet. Select
**Create shared wallet** and enter a name for the wallet, your own name,
the total number of copayers and the required number of signatures for a
transaction. Tap the **Create m-of-n wallet** button to create the
wallet. The wallet will appear with your other wallets, listed as
**Incomplete** until the copayers have joined.

|image0| |image1|
|image2| |image3|

.. |image0| image:: img/shared-add.png
   :width: 200px
.. |image1| image:: img/shared-create.png
   :width: 200px
.. |image2| image:: img/shared-settings.png
   :width: 200px
.. |image3| image:: img/shared-incomplete.png
   :width: 200px

*Creating a 2-of-3 shared wallet in Dash Copay*

Tap the incomplete shared wallet when you are ready to add users. A QR
code will be displayed. Have your copayers scan the code or share it to
them by email or instant message by tapping the **Share invitation**
button. Once everyone has scanned the code and entered their name, the
wallet is ready for use. Simply tap the wallet to display addresses for
receiving funds, but note that the addresses begin with 7 instead of X
to indicated they are multisig addresses. It is possible to receive Dash
to a shared wallet in exactly the same way as a normal wallet. Only
sending Dash requires participation from the copayers.

|image4| |image5| |image6|

.. |image4| image:: img/shared-qr.png
   :width: 200px
.. |image5| image:: img/shared-join.png
   :width: 200px
.. |image6| image:: img/shared-join.png
   :width: 200px

*Adding copayers to a 2-of-3 shared wallet in Dash Copay*
