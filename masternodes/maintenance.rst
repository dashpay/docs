.. meta::
   :description: Maintaining a Dash masternode involves staying up to date with the latest version, voting and handling payments
   :keywords: dash, cryptocurrency, masternode, maintenance, maintain, payments, withdrawal, voting, monitoring, dip3, upgrade, deterministic

.. _masternode-maintenance:

===========
Maintenance
===========

Masternodes require regular maintenance to ensure you do not drop off
the payment queue. This includes promptly installing updates to Dash, as
well as maintaining the security and performance of the server. In
addition, masternodes should vote on proposals and perform other tasks
in the interest of the network and the value of the Dash they hold.


.. _update-dip3-config:

Updating Masternode Information
===============================

Periodically, it may be necessary to update masternode information if
any information relating to the owner or operator changes. Examples may
include a change in IP address, change in owner/operator payout address,
or change in percentage of the reward allocated to an operator. It is
also possible to revoke a masternode's registered status (in the event
of a security breach, for example) to force both owner and operator to
update their details.

ProUpServTx
-----------

A Provider Update Service Transaction (ProUpServTx) is used to update
information relating to the operator. An operator can update the IP
address and port fields of a masternode entry. If a non-zero
operatorReward was set in the initial ProRegTx, the operator may also
set the scriptOperatorPayout field in the ProUpServTx. If
scriptOperatorPayout is not set and operatorReward is non-zero, the
owner gets the full masternode reward. The ProUpServTx takes the following syntax::

  protx update_service proTxHash ipAndPort operatorKey (operatorPayoutAddress)

Where:

- ``proTxHash``: The hash of the initial ProRegTx
- ``ipAndPort``: IP and port in the form "ip:port"
- ``operatorKey``: The operator BLS private key associated with the
  registered operator public key
- ``operatorPayoutAddress`` (optional): The address used for operator 
  reward payments. Only allowed when the ProRegTx had a non-zero 
  ``operatorReward`` value.

Example::

  protx update_service d6ec9a03e1251ac8c34178f47b6d763dc4ea6d96fd6eddb3c7aae2359e0f474a 140.82.59.51:10002 4308daa8de099d3d5f81694f6b618381e04311b9e0345b4f8b025392c33b0696 yf6Cj6VcCfDxU5yweAT3NKKvm278rVbkhu

  fad61c5f21cf3c0832f782c1444d3d2e2a8dbff39c5925c38033730e64ecc598

The masternode is now removed from the PoSe-banned list, and the IP:port
and operator reward addresses are updated.

ProUpRegTx
----------

A Provider Update Registrar Transaction (ProUpRegTx) is used to update
information relating to the owner. An owner can update the operator's
BLS public key (e.g. to nominate a new operator), the voting address and
their own payout address. The ProUpRegTx takes the following syntax::

  protx update_registrar proTxHash operatorKeyAddr votingKeyAddr payoutAddress
  protx update_registrar proTxHash operatorKeyAddr votingKeyAddr payoutAddress (feeSourceAddress)

Where:

- ``proTxHash``: The transaction id of the initial ProRegTx
- ``operatorKeyAddr``: An updated BLS public key, or 0 to use the last 
  on-chain operator key
- ``votingKeyAddr``: An updated voting key address, or 0 to use the last 
  on-chain operator key
- ``payoutAddress``: An updated Dash address for owner payments, or 0 to 
  use the last on-chain operator key
- ``feeSourceAddress``: An (optional) address used to fund ProTx fee. 
  ``payoutAddress`` will be used if not specified.

Example to update payout address::

  protx update_registrar cedce432ebabc9366f5eb1e3abc219558de9fbd2530a13589b698e4bf917b8ae 0 0 yi5kVoPQQ8xaVoriytJFzpvKomAQxg6zea


ProUpRevTx
----------

A Provider Update Revocation Transaction (ProUpRevTx) is used by the
operator to terminate service or signal the owner that a new BLS key is
required. It will immediately put the masternode in the PoSe-banned
state. The owner must then issue a ProUpRegTx to set a new operator key.
After the ProUpRegTx is mined to a block, the new operator must issue a
ProUpServTx to update the service-related metadata and clear the PoSe-
banned state (revive the masternode). The ProUpRevTx takes the following
syntax::

  protx revoke proTxHash operatorKey reason

Where:

- ``proTxHash``: The transaction id of the initial ProRegTx
- ``operatorKey``: The operator BLS private key associated with the
  registered operator public key
- ``reason`` (optional): Integer value indicating the revocation `reason <https://github.com/dashpay/dips/blob/master/dip-0003.md#appendix-a-reasons-for-self-revocation-of-operators>`__

Example::

  protx revoke 9f5ec7540baeefc4b7581d88d236792851f26b4b754684a31ee35d09bdfb7fb6 565950700d7bdc6a9dbc9963920bc756551b02de6e4711eff9ba6d4af59c0101


DashCentral voting, verification and monitoring
===============================================

DashCentral is a community-supported website managed by community member
Rango. It has become a *de facto* site for discussion of budget
proposals and to facilitate voting from a graphical user interface, but
also offers functions to monitor masternodes.

Adding your masternode to DashCentral
-------------------------------------

`Dashcentral <https://www.dashcentral.org/>`_ allows you to vote on
proposals from the comfort of your browser. After completing
`registration <https://www.dashcentral.org/register>`_, go to the
`masternodes <https://www.dashcentral.org/masternodes>`_ page and click
the **Add masternode now** button. Enter your collateral address on the
following screen:

.. figure:: img/maintenance-dc-add-masternode.png
   :width: 400px

   Adding a masternode to DashCentral

Click **Add masternode**. Your masternode has now been added to
DashCentral.

Enabling voting from DashCentral
--------------------------------

Click **Edit** under **Voting privkeys** to enter your masternode
private key to enable voting through the DashCentral web interface.
Enter a voting passphrase (not the same as your login password, but
equally important to remember!) and enter the private key (the same key
you used in the dash.conf file on your masternode) on the following
screen:

.. figure:: img/maintenance-dc-add-privkey.png
   :width: 400px

   Adding voting privkeys to DashCentral

It is important to note that the private key to start your masternode is
unrelated to the private keys to the collateral address storing your
1000 DASH. These keys can be used to issue commands on behalf of the
masternode, such as voting, but cannot be used to access the collateral.
The keys are encrypted on your device and never stored as plain text on
DashCentral servers. Once you have entered the key, click **Store
encrypted voting privkeys on server**. You can now vote on proposals
from the DashCentral web interface.

Verifying ownership
-------------------

You can also issue a message from your address to verify ownership of
your masternode to DashCentral. Click **Unverified** under **Ownership**
and the following screen will appear:

.. figure:: img/maintenance-dc-verify.png
   :width: 400px

   Verifying ownership of your masternode to DashCentral

Instructions on how to sign your collateral address using a software
wallet appear. If you are using a hardware wallet other than Trezor, you
will need to use the DMT app to sign the address. If you are using the
Trezor hardware wallet, go to your `Trezor wallet
<https://wallet.trezor.io/>`_, copy the collateral address and click
**Sign & Verify**. The following screen will appear, where you can enter
the message provided by DashCentral and the address you wish to sign:

.. figure:: img/maintenance-dc-sign.png
   :width: 400px

   Signing a message from the Trezor Wallet

Click **Sign**, confirm on your Trezor device and enter your PIN to sign
the message. A message signature will appear in the **Signature** box.
Copy this signature and paste it into the box on DashCentral and click
**Verify ownership**. Verification is now complete.

.. figure:: img/maintenance-dc-verified.png
   :width: 400px

   Masternode ownership has been successfully verified

Installing the DashCentral monitoring script
--------------------------------------------

DashCentral offers a service to monitor your masternode, automatically
restart dashd in the event of a crash and send email in the event of an
error. Go to the `Account settings
<https://www.dashcentral.org/account/edit>`_ page and generate a new API
key, adding a PIN to your account if necessary. Scroll to the following
screen:

.. figure:: img/maintenance-dc-monitoring.png
   :width: 400px

   Setting up the DashCentral monitoring script

Copy the link to the current version of the dashcentral script by right-
click and selecting **Copy link address**. Open PuTTY and connect to
your masternode, then type::

  wget https://www.dashcentral.org/downloads/dashcentral-updater-v6.tgz

Replace the link with the current version of dashcentral-updater as
necessary. Decompress the archive using the following command::

  tar xvzf dashcentral-updater-v6.tgz

View your masternode configuration details by typing::

  cat .dashcore/dash.conf

Copy the values for ``rpcuser`` and ``rpcpassword``. Then edit the
dashcentral configuration by typing::

  nano dashcentral-updater/dashcentral.conf

Replace the values for ``api_key``, your masternode collateral address,
``rpc_user``, ``rpc_password``, ``daemon_binary`` and ``daemon_datadir``
according to your system. A common configuration, where ``lwhite`` is
the name of the Linux user, may look like this:

.. figure:: img/maintenance-dc-update-config.png
   :width: 400px

   DashCentral updater configuration file

::

  ################
  # dashcentral-updater configuration
  ################

  our %settings = (
      # Enter your DashCentral api key here
      'api_key' => 'api_key_from_dashcentral'
  );

  our %masternodes = (
      'masternode_collateral_address' => {
          'rpc_host'           => 'localhost',
          'rpc_port'           => 9998,
          'rpc_user'           => 'rpc_user_from_dash.conf',
          'rpc_password'       => 'rpc_password_from_dash.conf',
          'daemon_autorestart' => 'enabled',
          'daemon_binary'      => '/home/<username>/.dashcore/dashd',
          'daemon_datadir'     => '/home/<username>/.dashcore'
      }
  );

Press **Ctrl + X** to exit, confirm you want save with **Y** and press
**Enter**. Test your configuration by running the dashcentral script,
then check the website. If it was successful, you will see that an
update has been sent::

  dashcentral-updater/dcupdater

.. figure:: img/maintenance-dc-update.png
   :width: 400px

   Manually testing the DashCentral updater

.. figure:: img/maintenance-dc-success.png
   :width: 400px

   DashCentral updater has successfully sent data to the DashCentral
   site

Once you have verified your configuration is working, we can edit the
crontab on your system to schedule the dcupdater script to run every 2
minutes. This allows the system to give you early warning in the event
of a fault and will even restart the dashd daemon if it hangs or
crashes. This is an effective way to make sure you do not drop off the
payment queue. Type the following command::

  crontab -e

Select an editor if necessary and add the following line to your crontab
after the line for sentinel, replacing lwhite with your username on your
system::

  */2 * * * * /home/lwhite/dashcentral-updater/dcupdater

.. figure:: img/maintenance-dc-crontab.png
   :width: 400px

   Editing crontab to run the DashCentral updater automatically

Press **Ctrl + X** to exit, confirm you want save with **Y** and press
**Enter**. The dcupdater script will now run every two minutes, restart
dashd whenever necessary and email you in the event of an error.

Masternode monitoring tools
===========================

Several sites operated by community members are available to monitor key
information and statistics relating to the masternode network.

Block Explorers
---------------

Since Dash is a public blockchain, it is possible to use block explorers
to view the balances of any Dash public address, as well as examine the
transactions entered in any given block. Each unique transaction is also
searchable by its txid. A number of block explorers are available for
the Dash network.

- `CryptoID <https://chainz.cryptoid.info/>`__ offers a `Dash blockchain
  explorer <https://chainz.cryptoid.info/dash/>`__ and a `function
  <https://chainz.cryptoid.info/dash/masternodes.dws>`__ to view and map
  Dash masternodes.
- `BitInfoCharts <https://bitinfocharts.com>`_ offers a `page
  <https://bitinfocharts.com/dash/>`_ of price statistics and
  information and a `blockchain explorer
  <https://bitinfocharts.com/dash/explorer/>`__.
- `CoinCheckup <https://coincheckup.com/coins/dash/charts>`__ offers a
  range of statistics and data on most blockchains, including Dash.
- `CoinPayments <https://www.coinpayments.net/>`__ offers a simple `Dash
  blockchain explorer
  <http://explorer.coinpayments.net/index.php?chain=7>`__.
- `Dash.org <https://www.dash.org/>`__ includes two blockchain explorers
  at `explorer.dash.org <http://explorer.dash.org/>`__ and
  `insight.dash.org <http://insight.dash.org/>`__.
- `Trezor <https://trezor.io/>`__ operates a `blockchain explorer <https
  ://dash-bitcore1.trezor.io/>`__ powered by a `Dash fork
  <https://github.com/dashpay/insight-ui-dash>`__ of `insight
  <https://insight.is/>`__, an advanced blockchain API tool

Dash Masternode Tool
--------------------

https://github.com/Bertrand256/dash-masternode-tool

Written and maintained by community member Bertrand256, Dash Masternode
Tool (DMT) allows you to start a masternode from all major hardware
wallets such as Trezor, Ledger and KeepKey. It also supports functions
to vote on proposals and withdraw masternode payments without affecting
the collateral transaction.

DASH Ninja
----------

https://www.dashninja.pl

DASH Ninja, operated by forum member and Dash Core developer elbereth,
offers key statistics on the adoption of different versions of Dash
across the masternode network. Several features to monitor governance of
the Dash, the masternode payment schedule and the geographic
distribution of masternodes are also available, as well as a simple
blockchain explorer.

DashCentral
-----------

https://www.dashcentral.org

DashCentral, operated by forum member rango, offers an advanced service
to monitor masternodes and vote on budget proposals through an advanced
web interface. An `Android app <https://play.google.com/store/apps/detai
ls?id=net.paregov.android.dashcentral>`_ is also available.

Masternode.me
-------------

https://stats.masternode.me

Masternode.me, operated by forum member and Dash Core developer
moocowmoo, offers sequential reports on the price, generation rate,
blockchain information and some information on masternodes.

Dash Masternode Information
---------------------------

http://178.254.23.111/~pub/Dash/Dash_Info.html

This site, operated by forum member and Dash Core developer crowning,
offers a visual representation of many key statistics of the Dash
masternode network, including graphs of the total masternode count over
time, price information and network distribution.
