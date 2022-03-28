# Setup masternode with P2SH collateral output stored on multisig wallet

To store a collateral amount on a multisig P2SH wallet the collateral amount
must be created as an output of a ProRegTx transaction. Any other existing 
collateral amount of 1000 Dash stored on a multisig is not suited for the ProRegTx.


There are two methods:

1. Create a ProRegTx transaction on a standard P2PKH wallet and set 1000 Dash
   output of the ProRegTx to a P2SH multisig address of another wallet.

2. Create a ProRegTx transaction on a multisig P2SH wallet and set the Owner/Voting
   addresses to another standard wallet P2PKH adresses (the addresses must
   be of the P2PKH type).

## Method 1. Create from a standard wallet, store collateral on a multisig wallet.

Create a DIP3 masternode on a standard P2PKH wallet with the wizard.

<p><image src="dip3_p2sh/protx_p1.png" width="800" /></p>

Then select collateral as ProRegTx Output.

<p><image src="dip3_p2sh/protx_p2.png" width="800" /></p>

Select service params and Owner/Voting/Payout addresses, save BLS priv key,
finish the wizard.

<p><image src="dip3_p2sh/protx_p3.png" width="800" />
   <image src="dip3_p2sh/protx_p4.png" width="800" />
   <image src="dip3_p2sh/protx_p5.png" width="800" /></p>

Send "Pay to" address of the ProRegTx to a P2SH address of your multisig wallet,
set "Amount" to 1000 Dash value of collateral.

<p><image src="dip3_p2sh/protx_p6.png" width="800" /></p>

## Method 2. Create from a multisig wallet.

Create a DIP3 masternode on a multisig P2SH wallet with the wizard.

<p><image src="dip3_p2sh/protx_p1.png" width="800" /></p>

Then select collateral as the ProRegTx Output.

<p><image src="dip3_p2sh/protx_p2.png" width="800" /></p>

Select service params.

<p><image src="dip3_p2sh/protx_p3.png" width="800" /></p>

Select Owner/Voting addresses from your standard P2PKH wallet.
Payout addresses can be on a P2SH or a P2PKH wallet.

<p><image src="dip3_p2sh/protx_p4_p2sh.png" width="800" /></p>

Save BLS priv key, finish the wizard.

<p><image src="dip3_p2sh/protx_p5.png" width="800" /></p>

Send "Pay to" address of the ProRegTx to a P2SH address of your multisig wallet,
set "Amount" to 1000 Dash value of collateral.

<p><image src="dip3_p2sh/protx_p6.png" width="800" /></p>
