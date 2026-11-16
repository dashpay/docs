```{eval-rst}
.. meta::
  :title: Configuration File
  :description: The DashCore configuration file, dash.conf, stores settings for Dash programs, including the RPC password used by dashd and dash-cli.
```

# Configuration File

All three programs get settings from `dash.conf` in the `DashCore` application directory:

* Windows: `%APPDATA%\DashCore\`

* OSX: `$HOME/Library/Application Support/DashCore/`

* Linux: `$HOME/.dashcore/`

Dash Core doesn't create `dash.conf`, so create the file if it doesn't exist. (`dash-qt` creates an empty file when you select **Open wallet configuration file** from its **File** menu.)

`dashd` and `dash-cli` don't need an RPC password when they run on the same system as the same user and use the same data directory. If no `rpcpassword` is set, `dashd` writes a random cookie to a `.cookie` file in its data directory (in the network subdirectory, such as `testnet3/` or `regtest/`, on test networks), and `dash-cli` reads that file to authenticate (see the `-rpccookiefile` option). To use a fixed password instead, add it to your `dash.conf` file. Both programs will read from the same file if both run on the same system as the same user, so any long random password will work:

``` text
rpcpassword=change_this_to_a_long_random_password
```

You should also make the `dash.conf` file only readable to its owner.  On Linux, Mac OSX, and other Unix-like systems, this can be accomplished by running the following command in the Dash Core application directory:

``` text
chmod 0600 dash.conf
```

If Dash Core uses a different configuration file (for example, one set with `-conf`, or one whose `datadir=` option points to another directory), a `dash.conf` file in the data directory is ignored. Dash Core then refuses to start and reports the ignored file. Remove or rename that file, or set `allowignoredconf=1` to report it as a warning instead.

For development, it's safer and cheaper to use Dash's test network ([testnet](../resources/glossary.md#testnet)), [regression test mode](../resources/glossary.md#regression-test-mode) (regtest), or a developer network  ([devnet](../resources/glossary.md#devnet)) described below.

Questions about Dash use are best sent to the [Dash forum](https://www.dash.org/forum/categories/dash-support.61/) and [Discord channels](http://www.dashchat.org).

In the following documentation, some strings have been shortened or wrapped: "[...]" indicates extra data was removed, and lines ending in a single backslash "\\" are continued below. If you hover over a cross-reference link, a brief definition of the term will be displayed.
