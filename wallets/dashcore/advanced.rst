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

-?                                    This help message


-version                              Print version and exit
-alerts                               Receive and display P2P network alerts (default: 1)
-alertnotify=<cmd>                    Execute command when a relevant alert is received or we see a really long fork (%s in cmd is replaced by message)
-blocknotify=<cmd>                    Execute command when the best block changes (%s in cmd is replaced by block hash)
-assumevalid=<hex>                    If this block is in the chain assume that it and its ancestors are valid and potentially skip their script verification (0 to verify all, default: 00000000000000b4181bbbdddbae464ce11fede5d0292fb63fdede1e7c8ab21c, testnet: 00000ce22113f3eb8636e225d6a1691e132fdd587aed993e1bc9b07a0235eea4)
-conf=<file>                          Specify configuration file (default: dash.conf)
-daemon                               Run in the background as a daemon and accept commands
-datadir=<dir>                        Specify data directory
-dbcache=<n>                          Set database cache size in megabytes (4 to 16384, default: 100)
-loadblock=<file>                     Imports blocks from external blk000??.dat file on startup
-maxorphantx=<n>                      Keep at most <n> unconnectable transactions in memory (default: 100)
-maxmempool=<n>                       Keep the transaction memory pool below <n> megabytes (default: 300)
-mempoolexpiry=<n>                    Do not keep transactions in the mempool longer than <n> hours (default: 72)
-par=<n>                              Set the number of script verification threads (-1 to 16, 0 = auto, <0 = leave that many cores free, default: 0)
-pid=<file>                           Specify pid file (default: dashd.pid)
-prune=<n>                            Reduce storage requirements by pruning (deleting) old blocks. This mode is incompatible with -txindex and -rescan. Warning: Reverting this setting requires re-downloading the entire blockchain. (default: 0 = disable pruning blocks, >945 = target size in MiB to use for block files)
-reindex-chainstate                   Rebuild chain state from the currently indexed blocks
-reindex                              Rebuild chain state and block index from the blk*.dat files on disk
-sysperms                             Create new files with system default permissions, instead of umask 077 (only effective with disabled wallet functionality)
-txindex                              Maintain a full transaction index, used by the getrawtransaction rpc call (default: 1)
-addressindex                         Maintain a full address index, used to query for the balance, txids and unspent outputs for addresses (default: 0)
-timestampindex                       Maintain a timestamp index for block hashes, used to query blocks hashes by a range of timestamps (default: 0)
-spentindex                           Maintain a full spent index, used to query the spending txid and input index for an outpoint (default: 0)



RPC Commands
======================
