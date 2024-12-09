```{eval-rst}
.. meta::
  :title: Dash Core Configuration Files
  :description: Details about the configuration files needed to run dashd and dash-cli, including dash.conf and settings.json.
```

# Configuration Files

## dash.conf

To use `dashd` and `dash-cli`, you will need to add a RPC password to your `dash.conf` file. Both programs will read from the same file if both run on the same system as the same user, so any long random password will work:

``` text
rpcpassword=change_this_to_a_long_random_password
```

You should also make the `dash.conf` file only readable to its owner.  On Linux, Mac OSX, and other Unix-like systems, this can be accomplished by running the following command in the Dash Core application directory:

``` text
chmod 0600 dash.conf
```

For development, it's safer and cheaper to use Dash's test network ([testnet](../resources/glossary.md#testnet)), [regression test mode](../resources/glossary.md#regression-test-mode) (regtest), or a developer network  ([devnet](../resources/glossary.md#devnet)) described below.

Questions about Dash use are best sent to the [Dash forum](https://www.dash.org/forum/categories/dash-support.61/) and [Discord channels](http://www.dashchat.org).

### Example Testnet Config

```text
testnet=1

# RPC Settings
rpcuser=user
rpcpassword=pass
rpcallowip=127.0.0.1
#----
listen=1
server=1

# Index Settings
txindex=1
addressindex=1
timestampindex=1
spentindex=1

[test]
rpcport=19998
```

### Configuration sections for different networks

Since Dash Core 0.16 it is possible for a single configuration file to set different options for different networks. This is done by using sections or by prefixing the option with the network as shown below:

:::{attention}
Please note that the only valid section names are **`[main]`**, **`[test]`**, **`[regtest]`**, and **`[devnet]`**.
:::

``` text Example dash.conf
# Enable RPC server for all networks
server=1

[main]
# Set custom mainnet ports
port=9989
rpcport=9988
# Set custom mainnet RPC auth
rpcuser=mainnetuser
rpcpassword=mainnetpass

[test]
# Set custom testnet RPC auth
rpcuser=testnetuser
rpcpassword=testnetpass

# Enabling indexing
txindex=1
addressindex=1
timestampindex=1
spentindex=1

[regtest]
mempoolsize=20

[devnet]
port=21999
rpcport=21998
```

With this configuration file, dashd, dash-qt, or dash-cli can be run with the `-conf=<configuration file>` along with the `-testnet`,  `-regtest`, or `-devnet=<devnet name>` parameter to select the correct settings.

:::{attention}
The following options will only apply to mainnet **_unless they are in a section_** (e.g., `[test]`): `addnode=`, `connect=`, `port=`, `bind=`, `rpcport=`, `rpcbind=` and `wallet=`.
The options to choose a network (`regtest=` and `testnet=`) must be specified outside of sections.
:::

## settings.json

Since Dash Core 18.1, wallets created or loaded in the GUI will now be automatically loaded on startup so they don't need to be manually reloaded the next time Dash is started. The list of wallets to load on startup is stored in `\<datadir\>/settings.json`. Additionally, any wallets specified in `-wallet=` settings on the command line or in the `dash.conf` file are also loaded. Wallets that are unloaded in the GUI are also removed from the settings list so they won't automatically load on the next startup.

The `createwallet`, `loadwallet`, and `unloadwallet` RPCs now accept `load_on_startup` options to modify the settings list. Unless these options are explicitly set to true or false, the list is not modified, so the RPC methods remain backwards compatible.
