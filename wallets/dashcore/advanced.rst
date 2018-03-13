.. _dashcore_advanced:

=========================
Advanced Functions
=========================

Command Line Arguments
======================

These commands are accurate as of Dash Core version 0.12.2.1.

- dashd
- dash-qt
- dash-cli
- dash-tx

dashd
-----

Dash Core Daemon

Usage
^^^^^

dashd [options]
  Start Dash Core Daemon

Options
^^^^^^^

-?
  This help message

-version
  Print version and exit

``-alerts``
  Receive and display P2P network alerts (default: 1)

``-alertnotify=<cmd>``
  Execute command when a relevant alert is received or we see a really
  long fork (%s in cmd is replaced by message)


RPC Commands
======================
