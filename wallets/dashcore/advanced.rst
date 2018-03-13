.. _dashcore_advanced:

=========================
Advanced Functions
=========================

Command Line Arguments
======================

These commands are accurate as of Dash Core version 0.12.2.1.

- `dashd`_
- `dash-qt`_
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


Wallet options
^^^^^^^^^^^^^^

--disablewallet                        Do not load the wallet and disable wallet RPC calls
--keypool=<n>                          Set key pool size to <n> (default: 1000)
--fallbackfee=<amt>                    A fee rate (in DASH/kB) that will be used when fee estimation has insufficient data (default: 0.0002)
--mintxfee=<amt>                       Fees (in DASH/kB) smaller than this are considered zero fee for transaction creation (default: 0.0001)
--paytxfee=<amt>                       Fee (in DASH/kB) to add to transactions you send (default: 0.00)
--rescan                               Rescan the block chain for missing wallet transactions on startup
--salvagewallet                        Attempt to recover private keys from a corrupt wallet.dat on startup
--sendfreetransactions                 Send transactions as zero-fee transactions if possible (default: 0)
--spendzeroconfchange                  Spend unconfirmed change when sending transactions (default: 1)
--txconfirmtarget=<n>                  If paytxfee is not set, include enough fee so transactions begin confirmation on average within n blocks (default: 2)
--maxtxfee=<amt>                       Maximum total fees (in DASH) to use in a single wallet transaction; setting this too low may abort large transactions (default: 0.20)
--usehd                                Use hierarchical deterministic key generation (HD) after bip39/bip44. Only has effect during wallet creation/first start (default: 0)
--mnemonic                             User defined mnemonic for HD wallet (bip39). Only has effect during wallet creation/first start (default: randomly generated)
--mnemonicpassphrase                   User defined mnemonic passphrase for HD wallet (bip39). Only has effect during wallet creation/first start (default: empty string)
--hdseed                               User defined seed for HD wallet (should be in hex). Only has effect during wallet creation/first start (default: randomly generated)
--upgradewallet                        Upgrade wallet to latest format on startup
--wallet=<file>                        Specify wallet file (within data directory) (default: wallet.dat)
--walletbroadcast                      Make the wallet broadcast transactions (default: 1)
--walletnotify=<cmd>                   Execute command when a wallet transaction changes (%s in cmd is replaced by TxID)
--zapwallettxes=<mode>                 Delete all wallet transactions and only recover those parts of the blockchain through -rescan on startup (1 = keep tx meta data e.g. account owner and payment request information, 2 = drop tx meta data)
--createwalletbackups=<n>              Number of automatic wallet backups (default: 10)
--walletbackupsdir=<dir>               Specify full path to directory for automatic wallet backups (must exist)
--keepass                              Use KeePass 2 integration using KeePassHttp plugin (default: 0)
--keepassport=<port>                   Connect to KeePassHttp on port <port> (default: 19455)
--keepasskey=<key>                     KeePassHttp key for AES encrypted communication with KeePass
--keepassid=<name>                     KeePassHttp id for the established association
--keepassname=<name>                   Name to construct url for KeePass entry that stores the wallet passphrase


ZeroMQ notification options
^^^^^^^^^^^^^^^^^^^^^^^^^^^

--zmqpubhashblock=<address>            Enable publish hash block in <address>
--zmqpubhashtx=<address>               Enable publish hash transaction in <address>
--zmqpubhashtxlock=<address>           Enable publish hash transaction (locked via InstantSend) in <address>
--zmqpubrawblock=<address>             Enable publish raw block in <address>
--zmqpubrawtx=<address>                Enable publish raw transaction in <address>
--zmqpubrawtxlock=<address>            Enable publish raw transaction (locked via InstantSend) in <address>


Debugging/Testing options
^^^^^^^^^^^^^^^^^^^^^^^^^

--uacomment=<cmt>                      Append comment to the user agent string
--debug=<category>                     Output debugging information (default: 0, supplying <category> is optional). If <category> is not supplied or if <category> = 1, output all debugging information.<category> can be: addrman, alert, bench, coindb, db, http, libevent, lock, mempool, mempoolrej, net, proxy, prune, rand, reindex, rpc, selectcoins, tor, zmq, dash (or specifically: gobject, instantsend, keepass, masternode, mnpayments, mnsync, privatesend, spork).
--gen                                  Generate coins (default: 0)
--genproclimit=<n>                     Set the number of threads for coin generation if enabled (-1 = all cores, default: 1)
--help-debug                           Show all debugging options (usage: --help -help-debug)
--logips                               Include IP addresses in debug output (default: 0)
--logtimestamps                        Prepend debug output with timestamp (default: 1)
--minrelaytxfee=<amt>                  Fees (in DASH/kB) smaller than this are considered zero fee for relaying, mining and transaction creation (default: 0.0001)
--printtoconsole                       Send trace/debug info to console instead of debug.log file
--printtodebuglog                      Send trace/debug info to debug.log file (default: 1)
--shrinkdebugfile                      Shrink debug.log file on client startup (default: 1 when no -debug)


Chain selection options
^^^^^^^^^^^^^^^^^^^^^^^

--testnet                              Use the test chain
--litemode=<n>                         Disable all Dash specific functionality (Masternodes, PrivateSend, InstantSend, Governance) (0-1, default: 0)


Masternode options
^^^^^^^^^^^^^^^^^^

--masternode=<n>                       Enable the client to act as a masternode (0-1, default: 0)
--mnconf=<file>                        Specify masternode configuration file (default: masternode.conf)
--mnconflock=<n>                       Lock masternodes from masternode configuration file (default: 1)
--masternodeprivkey=<n>                Set the masternode private key


PrivateSend options
^^^^^^^^^^^^^^^^^^^

--enableprivatesend=<n>                Enable use of automated PrivateSend for funds stored in this wallet (0-1, default: 0)
--privatesendmultisession=<n>          Enable multiple PrivateSend mixing sessions per block, experimental (0-1, default: 0)
--privatesendrounds=<n>                Use N separate masternodes for each denominated input to mix funds (2-16, default: 2)
--privatesendamount=<n>                Keep N DASH anonymized (default: 1000)
--liquidityprovider=<n>                Provide liquidity to PrivateSend by infrequently mixing coins on a continual basis (0-100, default: 0, 1=very frequent, high fees, 100=very infrequent, low fees)


InstantSend options
^^^^^^^^^^^^^^^^^^^

--enableinstantsend=<n>                Enable InstantSend, show confirmations for locked transactions (0-1, default: 1)
--instantsenddepth=<n>                 Show N confirmations for a successfully locked transaction (0-9999, default: 5)
--instantsendnotify=<cmd>              Execute command when a wallet InstantSend transaction is successfully locked (%s in cmd is replaced by TxID)


Node relay options
^^^^^^^^^^^^^^^^^^

--bytespersigop                        Minimum bytes per sigop in transactions we relay and mine (default: 20)
--datacarrier                          Relay and mine data carrier transactions (default: 1)
--datacarriersize                      Maximum size of data in data carrier transactions we relay and mine (default: 83)
--mempoolreplacement                   Enable transaction replacement in the memory pool (default: 0)


Block creation options
^^^^^^^^^^^^^^^^^^^^^^

--blockminsize=<n>                     Set minimum block size in bytes (default: 0)
--blockmaxsize=<n>                     Set maximum block size in bytes (default: 750000)
--blockprioritysize=<n>                Set maximum size of high-priority/low-fee transactions in bytes (default: 10000)


RPC server options
^^^^^^^^^^^^^^^^^^

--server                               Accept command line and JSON-RPC commands
--rest                                 Accept public REST requests (default: 0)
--rpcbind=<addr>                       Bind to given address to listen for JSON-RPC connections. Use [host]:port notation for IPv6. This option can be specified multiple times (default: bind to all interfaces)
--rpccookiefile=<loc>                  Location of the auth cookie (default: data dir)
--rpcuser=<user>                       Username for JSON-RPC connections
--rpcpassword=<pw>                     Password for JSON-RPC connections
--rpcauth=<userpw>                     Username and hashed password for JSON-RPC connections. The field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>. A canonical python script is included in share/rpcuser. This option can be specified multiple times
--rpcport=<port>                       Listen for JSON-RPC connections on <port> (default: 9998 or testnet: 19998)
--rpcallowip=<ip>                      Allow JSON-RPC connections from specified source. Valid for <ip> are a single IP (e.g. 1.2.3.4), a network/netmask (e.g. 1.2.3.4/255.255.255.0) or a network/CIDR (e.g. 1.2.3.4/24). This option can be specified multiple times
--rpcthreads=<n>                       Set the number of threads to service RPC calls (default: 4)


dash-qt
-------

Dash Core QT GUI, use same command line options as dashd with additional
options for UI as described below.


Usage
^^^^^

dash-qt [command-line options]
  Start Dash Core QT GUI


Wallet options
^^^^^^^^^^^^^^

--windowtitle=<name>                   Wallet window title
 
Debugging/Testing options
^^^^^^^^^^^^^^^^^^^^^^^^^

--debug=<category>                     Output debugging information (default: 0, supplying <category> is optional). If <category> is not supplied or if <category> = 1, output all debugging information.<category> can be: addrman, alert, bench, coindb, db, http, libevent, lock, mempool, mempoolrej, net, proxy, prune, rand, reindex, rpc, selectcoins, tor, zmq, dash (or specifically: gobject, instantsend, keepass, masternode, mnpayments, mnsync, privatesend, spork), qt. 

 
UI options
^^^^^^^^^^

--choosedatadir                        Choose data directory on startup (default: 0) 
--lang=<lang>                          Set language, for example "de_DE" (default: system locale) 
--min                                  Start minimized 
--rootcertificates=<file>              Set SSL root certificates for payment request (default: -system-) 
--splash                               Show splash screen on startup (default: 1) 
--resetguisettings                     Reset all settings changed in the GUI


dash-cli
--------

Dash Core RPC client


Usage
^^^^^

dash-cli [options] <command> [params]  
  Send command to Dash Core
dash-cli [options] help                
  List commands
dash-cli [options] help <command>      
  Get help for a command


RPC Commands
======================
