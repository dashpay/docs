```{eval-rst}
.. meta::
  :title: Simple Spending
  :description: Dash Core provides several RPCs which handle all the details of spending, including creating a change output and paying an appropriate transaction fee. 
```

# Simple Spending

Dash Core provides several RPCs which handle all the details of spending, including creating a [change output](../resources/glossary.md#change-output) and paying an appropriate [transaction fee](../resources/glossary.md#transaction-fee). Even advanced users should use these RPCs whenever possible to decrease the chance that [duffs](../resources/glossary.md#duffs) will be lost by mistake.

## 1. Get new address

Get a new Dash [address](../resources/glossary.md#address) and save it in the shell variable `$NEW_ADDRESS`.

``` bash
> dash-cli -regtest getnewaddress
yLp6ZJueuigiF4s9E1Pv8tEunDPEsjyQfd

> NEW_ADDRESS=yLp6ZJueuigiF4s9E1Pv8tEunDPEsjyQfd
```

## 2. Send to address

Send 10 dash to the address using the [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress).  The returned hex string is the transaction identifier ([TXID](../resources/glossary.md#transaction-identifiers)).

The [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress) automatically selects an [unspent transaction output](../resources/glossary.md#unspent-transaction-output) (UTXO) from which to spend the duffs. In this case, it withdrew the duffs from our only available UTXO, the [coinbase transaction](../resources/glossary.md#coinbase-transaction) for [block](../resources/glossary.md#block) #1 which matured with the creation of block #101.

``` bash
> dash-cli -regtest sendtoaddress $NEW_ADDRESS 10.00
c7e5ae1240fdd83bb94c94a93816ed2ab7bcb56ec3ff8a9725c5c1e0482684ea
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

Re-running the [`listunspent` RPC](../api/remote-procedure-calls-wallet.md#listunspent) with the argument "0" to also display each [unconfirmed transaction](../resources/glossary.md#unconfirmed-transaction) shows that we have two UTXOs, both with the same [TXID](../resources/glossary.md#transaction-identifiers). The first UTXO shown is a change output that `sendtoaddress` created using a new address from the key pool. The second UTXO shown is the spend to the address we provided. If we had spent those duffs to someone else, that second transaction would not be displayed in our list of UTXOs.

``` bash
> dash-cli -regtest listunspent 0
```

``` json
[  
   {  
      "txid":"c7e5ae1240fdd83bb94c94a93816ed2ab7bcb56ec3ff8a9725c5c1e0482684ea",
      "vout":0,
      "address":"yLp6ZJueuigiF4s9E1Pv8tEunDPEsjyQfd",
      "account":"",
      "scriptPubKey":"76a914056b1fe57914236149feb21dcbc6b86f4bdd9f4988ac",
      "amount":10.00000000,
      "confirmations":0,
      "ps_rounds":-2,
      "spendable":true,
      "solvable":true
   },
   {  
      "txid":"c7e5ae1240fdd83bb94c94a93816ed2ab7bcb56ec3ff8a9725c5c1e0482684ea",
      "vout":1,
      "address":"yeP6Tw2uW4nWAFWRytw8TyshErTq59dUkN",
      "scriptPubKey":"76a914c622e98a6ccf34d02620612f58f20a50061cf4b188ac",
      "amount":490.00000000,
      "confirmations":0,
      "ps_rounds":-2,
      "spendable":true,
      "solvable":true
   }
]
```

## 4. Mine block

Create a new block to confirm the transaction above (takes less than a second) and clear the shell variable.

``` bash
> dash-cli -regtest generate 1

> unset NEW_ADDRESS
```

## Simple Spending Script

Shell script to run the previous example ([view as a GitHub Gist](https://gist.github.com/dash-docs/f40bddfc0844ec0d66d196720dc936f8#file-regtest_transaction_simple_spending_example-sh)):

``` shell
#!/bin/bash

# Set RPCUSER and RPCPWD to the username and password configure in dash.conf
RPCUSER="user"
RPCPWD="pass"
REGTEST_CMD="dash-cli -regtest -rpcuser=$RPCUSER -rpcpassword=$RPCPWD"

# SIMPLE SPENDING EXAMPLE
# -----------------------

BLOCKTOGEN=101
printf "\nGenerating %s block(s)...\n" $BLOCKTOGEN
COMMAND="$REGTEST_CMD generate $BLOCKTOGEN"
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
COMMAND="$REGTEST_CMD generate $BLOCKTOGEN"
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
