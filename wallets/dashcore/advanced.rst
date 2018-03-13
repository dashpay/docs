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

-alerts
  Receive and display P2P network alerts (default: 1)

``-alertnotify=<cmd>``
  Execute command when a relevant alert is received or we see a really
  long fork (%s in cmd is replaced by message)

-blocknotify=<cmd>
  Execute command when the best block changes (%s in cmd is replaced by block hash)

-assumevalid=<hex>
  If this block is in the chain assume that it and its ancestors are
  valid and potentially skip their script verification (0 to verify all,
  default:
  00000000000000b4181bbbdddbae464ce11fede5d0292fb63fdede1e7c8ab21c,
  testnet:
  00000ce22113f3eb8636e225d6a1691e132fdd587aed993e1bc9b07a0235eea4)
  
-conf=<file>
  Specify configuration file (default: dash.conf)

``-daemon``
  Run in the background as a daemon and accept commands

``-datadir=<dir>``
  Specify data directory

RPC Commands
======================
