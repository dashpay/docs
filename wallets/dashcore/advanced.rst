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

--help                                 This help message
--version                              Print version and exit
--alerts                               Receive and display P2P network alerts (default: 1)
--alertnotify=<cmd>                    Execute command when a relevant alert is received or we see a really long fork (%s in cmd is replaced by message)
--blocknotify=<cmd>                    Execute command when the best block changes (%s in cmd is replaced by block hash)
--assumevalid=<hex>                    If this block is in the chain assume that it and its ancestors are valid and potentially skip their script verification (0 to verify all, default: 00000000000000b4181bbbdddbae464ce11fede5d0292fb63fdede1e7c8ab21c, testnet: 00000ce22113f3eb8636e225d6a1691e132fdd587aed993e1bc9b07a0235eea4)
--conf=<file>                          Specify configuration file (default: dash.conf)
--daemon                               Run in the background as a daemon and accept commands
--datadir=<dir>                        Specify data directory
--dbcache=<n>                          Set database cache size in megabytes (4 to 16384, default: 100)
--loadblock=<file>                     Imports blocks from external blk000??.dat file on startup
--maxorphantx=<n>                      Keep at most <n> unconnectable transactions in memory (default: 100)
--maxmempool=<n>                       Keep the transaction memory pool below <n> megabytes (default: 300)
--mempoolexpiry=<n>                    Do not keep transactions in the mempool longer than <n> hours (default: 72)
--par=<n>                              Set the number of script verification threads (-1 to 16, 0 = auto, <0 = leave that many cores free, default: 0)
--pid=<file>                           Specify pid file (default: dashd.pid)
--prune=<n>                            Reduce storage requirements by pruning (deleting) old blocks. This mode is incompatible with -txindex and -rescan. Warning: Reverting this setting requires re-downloading the entire blockchain. (default: 0 = disable pruning blocks, >945 = target size in MiB to use for block files)
--reindex-chainstate                   Rebuild chain state from the currently indexed blocks
--reindex                              Rebuild chain state and block index from the blk*.dat files on disk
--sysperms                             Create new files with system default permissions, instead of umask 077 (only effective with disabled wallet functionality)
--txindex                              Maintain a full transaction index, used by the getrawtransaction rpc call (default: 1)
--addressindex                         Maintain a full address index, used to query for the balance, txids and unspent outputs for addresses (default: 0)
--timestampindex                       Maintain a timestamp index for block hashes, used to query blocks hashes by a range of timestamps (default: 0)
--spentindex                           Maintain a full spent index, used to query the spending txid and input index for an outpoint (default: 0)


Connection options
^^^^^^^^^^^^^^^^^^

--addnode=<ip>                         Add a node to connect to and attempt to keep the connection open
--banscore=<n>                         Threshold for disconnecting misbehaving peers (default: 100)
--bantime=<n>                          Number of seconds to keep misbehaving peers from reconnecting (default: 86400)
--bind=<addr>                          Bind to given address and always listen on it. Use [host]:port notation for IPv6
--connect=<ip>                         Connect only to the specified node(s)
--discover                             Discover own IP addresses (default: 1 when listening and no -externalip or -proxy)
--dns                                  Allow DNS lookups for -addnode, -seednode and -connect (default: 1)
--dnsseed                              Query for peer addresses via DNS lookup, if low on addresses (default: 1 unless -connect)
--externalip=<ip>                      Specify your own public address
--forcednsseed                         Always query for peer addresses via DNS lookup (default: 0)
--listen                               Accept connections from outside (default: 1 if no -proxy or -connect)
--listenonion                          Automatically create Tor hidden service (default: 1)
--maxconnections=<n>                   Maintain at most <n> connections to peers (temporary service connections excluded) (default: 125)
--maxreceivebuffer=<n>                 Maximum per-connection receive buffer, <n>*1000 bytes (default: 5000)
--maxsendbuffer=<n>                    Maximum per-connection send buffer, <n>*1000 bytes (default: 1000)
--onion=<ip:port>                      Use separate SOCKS5 proxy to reach peers via Tor hidden services (default: -proxy)
--onlynet=<net>                        Only connect to nodes in network <net> (ipv4, ipv6 or onion)
--permitbaremultisig                   Relay non-P2SH multisig (default: 1)
--peerbloomfilters                     Support filtering of blocks and transaction with bloom filters (default: 1)
--port=<port>                          Listen for connections on <port> (default: 9999 or testnet: 19999)
--proxy=<ip:port>                      Connect through SOCKS5 proxy
--proxyrandomize                       Randomize credentials for every proxy connection. This enables Tor stream isolation (default: 1)
--seednode=<ip>                        Connect to a node to retrieve peer addresses, and disconnect
--timeout=<n>                          Specify connection timeout in milliseconds (minimum: 1, default: 5000)
--torcontrol=<ip:port>                 Tor control port to use if onion listening enabled (default: 127.0.0.1:9051)
--torpassword=<pass>                   Tor control port password (default: empty)
--upnp                                 Use UPnP to map the listening port (default: 0)
--whitebind=<addr>                     Bind to given address and whitelist peers connecting to it. Use [host]:port notation for IPv6
--whitelist=<netmask>                  Whitelist peers connecting from the given netmask or IP address. Can be specified multiple times. Whitelisted peers cannot be DoS banned and their transactions are always relayed, even if they are already in the mempool, useful e.g. for a gateway
--whitelistrelay                       Accept relayed transactions received from whitelisted peers even when not relaying transactions (default: 1)
--whitelistforcerelay                  Force relay of transactions from whitelisted peers even they violate local relay policy (default: 1)
--maxuploadtarget=<n>                  Tries to keep outbound traffic under the given target (in MiB per 24h), 0 = no limit (default: 0)

dashd
-----

Dash Core Daemon
dashd [options]
  Start Dash Core Daemon


RPC Commands
======================
