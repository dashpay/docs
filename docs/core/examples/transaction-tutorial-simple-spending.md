```{eval-rst}
.. meta::
  :title: Simple Spending
  :description: Dash Core provides several RPCs which handle all the details of spending, including creating a change output and paying an appropriate transaction fee. 
```

% Example output on this page comes from scripts/core-regtest-examples/run-transaction-tutorials.sh.
% Use the output of a single run for all tutorial pages so values stay consistent between them.

# Simple Spending

Dash Core provides several RPCs which handle all the details of spending, including creating a [change output](../resources/glossary.md#change-output) and paying an appropriate [transaction fee](../resources/glossary.md#transaction-fee). Even advanced users should use these RPCs whenever possible to decrease the chance that [duffs](../resources/glossary.md#duffs) will be lost by mistake.

## 1. Get new address

Get a new Dash [address](../resources/glossary.md#address) and save it in the shell variable `$NEW_ADDRESS`.

``` bash
> dash-cli -regtest getnewaddress
yRjpWkBcjoBY6L9GDRsYYFMJ4aXQTHMQTu

> NEW_ADDRESS=yRjpWkBcjoBY6L9GDRsYYFMJ4aXQTHMQTu
```

## 2. Send to address

Send 10 dash to the address using the [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress).  The returned hex string is the transaction identifier ([TXID](../resources/glossary.md#transaction-identifiers)).

The [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress) automatically selects an [unspent transaction output](../resources/glossary.md#unspent-transaction-output) (UTXO) from which to spend the duffs. In this case, it withdrew the duffs from our only available UTXO, the [coinbase transaction](../resources/glossary.md#coinbase-transaction) for [block](../resources/glossary.md#block) #1 which matured with the creation of block #101.

``` bash
> dash-cli -regtest sendtoaddress $NEW_ADDRESS 10.00
e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b
```

## 3. List unspent outputs

### 3a. Confirmed outputs only

Use the [`listunspent` RPC](../api/remote-procedure-calls-wallet.md#listunspent) to display the UTXOs belonging to this [wallet](../resources/glossary.md#wallet). The list is empty because it defaults to only showing confirmed UTXOs and we just spent our only confirmed UTXO.

``` bash
> dash-cli -regtest listunspent
[
]
```

### 3b. All outputs

Re-running the [`listunspent` RPC](../api/remote-procedure-calls-wallet.md#listunspent) with the argument "0" to also display each [unconfirmed transaction](../resources/glossary.md#unconfirmed-transaction) shows that we have two UTXOs, both with the same [TXID](../resources/glossary.md#transaction-identifiers). The first UTXO shown is the spend to the address we provided. The second UTXO shown is a change output that `sendtoaddress` created using a new address from the key pool. If we had spent those duffs to someone else, that first UTXO would not be displayed in our list of UTXOs.

``` bash
> dash-cli -regtest listunspent 0
```

``` json
[
  {
    "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
    "vout": 0,
    "address": "yRjpWkBcjoBY6L9GDRsYYFMJ4aXQTHMQTu",
    "label": "",
    "scriptPubKey": "76a9143b74b256a0c92f4067cb90981a685ddc171287ff88ac",
    "amount": 10.00000000,
    "confirmations": 0,
    "ancestorcount": 1,
    "ancestorsize": 225,
    "ancestorfees": 225,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/0/1]03c57deb98b55a6cc22112d93159862b1a25\
             abe79fb6ab325e724d4f9ac4fbe677)#slt9lygj",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  },
  {
    "txid": "e3d47cea69738ce7de1265689ac2ccb482f5a6417a9fb20afee79dc16cd5f90b",
    "vout": 1,
    "address": "ycMSBzw2NMP22qU5nhdz3XbAsBfc5P9H1R",
    "scriptPubKey": "76a914afe24b6c9a80114f63baeabed947bd12e6d6eebd88ac",
    "amount": 489.99999775,
    "confirmations": 0,
    "ancestorcount": 1,
    "ancestorsize": 225,
    "ancestorfees": 225,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([6ef61e0b/44h/1h/0h/1/0]025a561f14893e47dc233bdd10ee71baf40a\
             a41cc0016d40eb7c2ce533c721dc85)#tkfjlxrl",
    "parent_descs": [
    ],
    "safe": true,
    "coinjoin_rounds": -2
  }
]
```

## 4. Mine block

Create a new block to confirm the transaction above (takes less than a second) and clear the shell variable.

``` bash
> dash-cli -regtest -generate 1

> unset NEW_ADDRESS
```

## Simple Spending Script

Shell script to run the previous example ([view as a GitHub Gist](https://gist.github.com/dash-docs/f40bddfc0844ec0d66d196720dc936f8#file-regtest_transaction_simple_spending_example-sh)):

``` shell
#!/bin/bash

# Uses cookie authentication. If dash.conf sets rpcuser and rpcpassword,
# add -rpcuser=<user> -rpcpassword=<password> to REGTEST_CMD.
REGTEST_CMD="dash-cli -regtest"

# SIMPLE SPENDING EXAMPLE
# -----------------------

BLOCKTOGEN=101
printf "\nGenerating %s block(s)...\n" $BLOCKTOGEN
COMMAND="$REGTEST_CMD -generate $BLOCKTOGEN"
echo $COMMAND
GENERATED=$($COMMAND)
echo "Generated $BLOCKTOGEN block(s)"

printf "\nChecking balance...\n"
COMMAND="$REGTEST_CMD getbalance"
echo $COMMAND
BALANCE=$($COMMAND)
echo "Balance is: " $BALANCE

printf "\nGetting new address...\n"
COMMAND="$REGTEST_CMD getnewaddress"
echo $COMMAND
NEW_ADDRESS=$($COMMAND)
echo "New address is: " $NEW_ADDRESS

printf "\nSending to address...\n"
COMMAND="$REGTEST_CMD sendtoaddress $NEW_ADDRESS 10.00"
echo $COMMAND
TXID=$($COMMAND)
echo "Transaction ID (TXID) is: " $TXID

printf "\nList unspent...\n"
COMMAND="$REGTEST_CMD listunspent"
echo $COMMAND
UNSPENT=$($COMMAND)
echo "Unspent (excluding unconfirmed): " $UNSPENT

printf "\nList unspent (unconfirmed)...\n"
COMMAND="$REGTEST_CMD listunspent 0"
echo $COMMAND
UNSPENT=$($COMMAND)
echo "Unspent (including unconfirmed): " $UNSPENT


BLOCKTOGEN=1
printf "\nGenerating %s block(s) to confirm...\n" $BLOCKTOGEN
COMMAND="$REGTEST_CMD -generate $BLOCKTOGEN"
echo $COMMAND
GENERATED=$($COMMAND)
echo "Generated $BLOCKTOGEN block(s)"

printf "\nList unspent...\n"
COMMAND="$REGTEST_CMD listunspent"
echo $COMMAND
UNSPENT=$($COMMAND)
echo "Unspent (excluding unconfirmed): " $UNSPENT

unset REGTEST_CMD
unset BLOCKTOGEN
unset COMMAND
unset GENERATED
unset BALANCE
unset NEW_ADDRESS
unset TXID
unset UNSPENT
```
