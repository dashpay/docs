.. meta::
   :description: Dash Core wallet startup arguments and RPC command reference
   :keywords: dash, core, wallet, arguments, commands, RPC

.. _dashcore-rpc:

======================
Arguments and commands
======================

All command-line options (except for ``-datadir`` and ``-conf``) may be
specified in a configuration file, and all configuration file options
may also be specified on the command line. Command-line options override
values set in the configuration file. The configuration file is a list
of ``setting=value`` pairs, one per line, with optional comments
starting with the ``#`` character.

The configuration file is not automatically created; you can create it
using your favorite plain-text editor. By default, dash-qt (or dashd)
will look for a file named ``dash.conf`` in the dash data directory, but
both the data directory and the configuration file path may be changed
using the -datadir and -conf command-line arguments.

+----------+--------------------------------+-----------------------------------------------------------------------------------------------+
| Platform | Path to data folder            | Typical path to configuration file                                                            |
+==========+================================+===============================================================================================+
| Linux    | ~/                             | /home/username/.dashcore/dash.conf                                                            |
+----------+--------------------------------+-----------------------------------------------------------------------------------------------+
| macOS    | ~/Library/Application Support/ | /Users/username/Library/Application Support/DashCore/dash.conf                                |
+----------+--------------------------------+-----------------------------------------------------------------------------------------------+
| Windows  | %APPDATA%                      | (Vista-10) C:\\Users\\username\\AppData\\Roaming\\DashCore\\dash.conf                         |
|          |                                |                                                                                               |
|          |                                | (2000-XP) C:\\Documents and Settings\\username\\Application Data\\DashCore\\dash.conf         |
+----------+--------------------------------+-----------------------------------------------------------------------------------------------+

Note: if running Dash in testnet mode, the sub-folder ``testnet3`` will
be appended to the data directory automatically.

Command line arguments
======================

Detailed information for all command line arguments can be found at the
following links to the `Dash Core developer documentation site <https://dashcore.readme.io/docs/dash-core-wallet-arguments-and-commands>`_:

- `dashd <https://dashcore.readme.io/docs/dash-core-wallet-arguments-and-commands-dashd>`_
- `dash-qt <https://dashcore.readme.io/docs/dash-core-wallet-arguments-and-commands-dash-qt>`_
- `dash-cli <https://dashcore.readme.io/docs/dash-core-wallet-arguments-and-commands-dash-cli>`_
- `dash-tx <https://dashcore.readme.io/docs/dash-core-wallet-arguments-and-commands-dash-tx>`_


RPC commands
============

Detailed documentation for all available RPC commands is accessible via
the `Dash Core developer documentation RPC page <https://dashcore.readme.io/docs/core-api-ref-remote-procedure-call-quick-reference>`_.
For full documentation of arguments, results and examples, type 
``help ( "command" )`` to view full details at the console. You can enter
commands either from **Tools > Console** in the QT wallet, or using
*dash-cli* for headless wallets and *dashd*.
