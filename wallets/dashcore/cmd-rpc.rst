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

These commands are accurate as of Dash Core version 0.13.0.0.

- `dashd`_
- `dash-qt`_
- `dash-cli`_
- `dash-tx`_


dashd
-----

Dash Core Daemon


Usage
^^^^^

dashd [options]
  Start Dash Core Daemon


Options
^^^^^^^

--help                                 Print this help message and exit
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
--blockreconstructionextratxn=<n>      Extra transactions to keep in memory for compact block reconstructions (default: 100)
--par=<n>                              Set the number of script verification threads (-1 to 16, 0 = auto, <0 = leave that many cores free, default: 0)
--pid=<file>                           Specify pid file (default: dashd.pid)
--prune=<n>                            Reduce storage requirements by enabling pruning (deleting) of old blocks. This allows the pruneblockchain RPC to be called to delete specific blocks, and enables automatic pruning of old blocks if a target size in MiB is provided. This mode is incompatible with -txindex and -rescan. Warning: Reverting this setting requires re-downloading the entire blockchain. (default: 0 = disable pruning blocks, 1 = allow manual pruning via RPC, >945 = automatically prune block files to stay under the specified target size in MiB)
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
--allowprivatenet                      Allow RFC1918 addresses to be relayed and connected to (default: 0)
--banscore=<n>                         Threshold for disconnecting misbehaving peers (default: 100)
--bantime=<n>                          Number of seconds to keep misbehaving peers from reconnecting (default: 86400)
--bind=<addr>                          Bind to given address and always listen on it. Use [host]:port notation for IPv6
--connect=<ip>                         Connect only to the specified node(s); -noconnect or -connect=0 alone to disable automatic connections
--discover                             Discover own IP addresses (default: 1 when listening and no -externalip or -proxy)
--dns                                  Allow DNS lookups for -addnode, -seednode and -connect (default: 1)
--dnsseed                              Query for peer addresses via DNS lookup, if low on addresses (default: 1 unless -connect/-noconnect)
--externalip=<ip>                      Specify your own public address
--forcednsseed                         Always query for peer addresses via DNS lookup (default: 0)
--listen                               Accept connections from outside (default: 1 if no -proxy or -connect)
--listenonion                          Automatically create Tor hidden service (default: 1)
--maxconnections=<n>                   Maintain at most <n> connections to peers (temporary service connections excluded) (default: 125)
--maxreceivebuffer=<n>                 Maximum per-connection receive buffer, <n>*1000 bytes (default: 5000)
--maxsendbuffer=<n>                    Maximum per-connection send buffer, <n>*1000 bytes (default: 1000)
--maxtimeadjustment                    Maximum allowed median peer time offset adjustment. Local perspective of time may be influenced by peers forward or backward by this amount. (default: 4200 seconds)
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
--whitelist=<IP address or network>    Whitelist peers connecting from the given IP address (e.g. 1.2.3.4) or CIDR notated network (e.g. 1.2.3.0/24). Can be specified multiple times.
--whitelistrelay                       Accept relayed transactions received from whitelisted peers even when not relaying transactions (default: 1)
--whitelistforcerelay                  Force relay of transactions from whitelisted peers even if they violate local relay policy (default: 1)
--maxuploadtarget=<n>                  Tries to keep outbound traffic under the given target (in MiB per 24h), 0 = no limit (default: 0)


Wallet options
^^^^^^^^^^^^^^

--disablewallet                        Do not load the wallet and disable wallet RPC calls
--keypool=<n>                          Set key pool size to <n> (default: 1000)
--fallbackfee=<amt>                    A fee rate (in DASH/kB) that will be used when fee estimation has insufficient data (default: 0.00001)
--mintxfee=<amt>                       Fees (in DASH/kB) smaller than this are considered zero fee for transaction creation (default: 0.00001)
--paytxfee=<amt>                       Fee (in DASH/kB) to add to transactions you send (default: 0.00)
--rescan                               Rescan the block chain for missing wallet transactions on startup
--salvagewallet                        Attempt to recover private keys from a corrupt wallet on startup
--spendzeroconfchange                  Spend unconfirmed change when sending transactions (default: 1)
--txconfirmtarget=<n>                  If paytxfee is not set, include enough fee so transactions begin confirmation on average within n blocks (default: 6)
--usehd                                Use hierarchical deterministic key generation (HD) after BIP39/BIP44. Only has effect during wallet creation/first start (default: 0)
--mnemonic                             User defined mnemonic for HD wallet (BIP39). Only has effect during wallet creation/first start (default: randomly generated)
--mnemonicpassphrase                   User defined mnemonic passphrase for HD wallet (BIP39). Only has effect during wallet creation/first start (default: empty string)
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

--zmqpubhashblock=<address>                   Enable publish hash block in <address>
--zmqpubhashtx=<address>                      Enable publish hash transaction in <address>
--zmqpubhashtxlock=<address>                  Enable publish hash transaction (locked via InstantSend) in <address>
--zmqpubhashgovernancevote=<address>          Enable publish hash of governance votes in <address>
--zmqpubhashgovernanceobject=<address>        Enable publish hash of governance objects (like proposals) in <address>
--zmqpubhashinstantsenddoublespend=<address>  Enable publish transaction hashes of attempted InstantSend double spend in <address>
--zmqpubrawblock=<address>                    Enable publish raw block in <address>
--zmqpubrawtx=<address>                       Enable publish raw transaction in <address>
--zmqpubrawtxlock=<address>                   Enable publish raw transaction (locked via InstantSend) in <address>
--zmqpubrawinstantsenddoublespend=<address>   Enable publish raw transactions of attempted InstantSend double spend in <address>


Debugging/Testing options
^^^^^^^^^^^^^^^^^^^^^^^^^

--uacomment=<cmt>                      Append comment to the user agent string
--debug=<category>                     Output debugging information (default: 0, supplying <category> is optional). If <category> is not supplied or if <category> = 1, output all debugging information.<category> can be: addrman, alert, bench, cmpctblock, coindb, db, http, leveldb, libevent, lock, mempool, mempoolrej, net, proxy, prune, rand, reindex, rpc, selectcoins, tor, zmq, dash (or specifically: gobject, instantsend, keepass, masternode, mnpayments, mnsync, privatesend, spork).
--help-debug                           Show all debugging options (usage: --help -help-debug)
--logips                               Include IP addresses in debug output (default: 0)
--logtimestamps                        Prepend debug output with timestamp (default: 1)
--minrelaytxfee=<amt>                  Fees (in DASH/kB) smaller than this are considered zero fee for relaying, mining and transaction creation (default: 0.00001)
--maxtxfee=<amt>                       Maximum total fees (in DASH) to use in a single wallet transaction or raw transaction; setting this too low may abort large transactions (default: 0.10)
--printtoconsole                       Send trace/debug info to console instead of debug.log file
--printtodebuglog                      Send trace/debug info to debug.log file (default: 1)
--shrinkdebugfile                      Shrink debug.log file on client startup (default: 1 when no -debug)


Chain selection options
^^^^^^^^^^^^^^^^^^^^^^^

--testnet                              Use the test chain
--devnet=<name>                        Use devnet chain with provided name
--litemode=<n>                         Disable all Dash specific functionality (Masternodes, PrivateSend, InstantSend, Governance) (0-1, default: 0)
--sporkaddr=<hex>                      Override spork address. Only useful for regtest and devnet. Using this on mainnet or testnet will ban you.
--minsporkkeys=<n>                     Overrides minimum spork signers to change spork value. Only useful for regtest and devnet. Using this on mainnet or testnet will ban you.


Masternode options
^^^^^^^^^^^^^^^^^^

--masternode=<n>                       Enable the client to act as a masternode (0-1, default: 0)
--mnconf=<file>                        Specify masternode configuration file (default: masternode.conf)
--mnconflock=<n>                       Lock masternodes from masternode configuration file (default: 1)
--masternodeprivkey=<n>                Set the masternode private key
--masternodeblsprivkey=<hex>           Set the masternode BLS private key


PrivateSend options
^^^^^^^^^^^^^^^^^^^

--enableprivatesend=<n>                Enable use of automated PrivateSend for funds stored in this wallet (0-1, default: 0)
--privatesendmultisession=<n>          Enable multiple PrivateSend mixing sessions per block, experimental (0-1, default: 0)
--privatesendsessions=<n>              Use N separate masternodes in parallel to mix funds (1-10, default: 4)
--privatesendrounds=<n>                Use N separate masternodes for each denominated input to mix funds (2-16, default: 4)
--privatesendamount=<n>                Keep N DASH mixed (2-21000000, default: 1000)
--liquidityprovider=<n>                Provide liquidity to PrivateSend by infrequently mixing coins on a continual basis (0-100, default: 0, 1=very frequent, high fees, 100=very infrequent, low fees)


InstantSend options
^^^^^^^^^^^^^^^^^^^

--enableinstantsend=<n>                Enable InstantSend, show confirmations for locked transactions (0-1, default: 1)
--instantsendnotify=<cmd>              Execute command when a wallet InstantSend transaction is successfully locked (%s in cmd is replaced by TxID)


Node relay options
^^^^^^^^^^^^^^^^^^

--bytespersigop                        Minimum bytes per sigop in transactions we relay and mine (default: 20)
--datacarrier                          Relay and mine data carrier transactions (default: 1)
--datacarriersize                      Maximum size of data in data carrier transactions we relay and mine (default: 83)


Block creation options
^^^^^^^^^^^^^^^^^^^^^^

--blockmaxsize=<n>                     Set maximum block size in bytes (default: 2000000)
--blockprioritysize=<n>                Set maximum size of high-priority/low-fee transactions in bytes (default: 10000)
--blockmintxfee=<amt>                  Set lowest fee rate (in DASH/kB) for transactions to be included in block creation. (default: 0.00001)


RPC server options
^^^^^^^^^^^^^^^^^^

--server                               Accept command line and JSON-RPC commands
--rest                                 Accept public REST requests (default: 0)
--rpcbind=<addr>                       Bind to given address to listen for JSON-RPC connections. Use [host]:port notation for IPv6. This option can be specified multiple times (default: bind to all interfaces)
--rpccookiefile=<loc>                  Location of the auth cookie (default: data dir)
--rpcuser=<user>                       Username for JSON-RPC connections
--rpcpassword=<pw>                     Password for JSON-RPC connections
--rpcauth=<userpw>                     Username and hashed password for JSON-RPC connections. The field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>. A canonical python script is included in share/rpcuser. The client then connects normally using the rpcuser=<USERNAME>/rpcpassword=<PASSWORD> pair of arguments. This option can be specified multiple times
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

--debug=<category>                     Output debugging information (default: 0, supplying <category> is optional). If <category> is not supplied or if <category> = 1, output all debugging information.<category> can be: addrman, alert, bench, cmpctblock, coindb, db, http, leveldb, libevent, lock, mempool, mempoolrej, net, proxy, prune, rand, reindex, rpc, selectcoins, tor, zmq, dash (or specifically: gobject, instantsend, keepass, masternode, mnpayments, mnsync, privatesend, spork), qt.

 
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


Options
^^^^^^^

--help                                 This help message
--conf=<file>                          Specify configuration file (default: dash.conf)
--datadir=<dir>                        Specify data directory


Chain selection options
^^^^^^^^^^^^^^^^^^^^^^^

--testnet                              Use the test chain
--devnet=<name>                        Use devnet chain with provided name
--regtest                              Enter regression test mode, which uses a special chain in which blocks can be solved instantly. This is intended for regression testing tools and app development.
--named                                Pass named instead of positional arguments (default: false)
--rpcconnect=<ip>                      Send commands to node running on <ip> (default: 127.0.0.1)
--rpcport=<port>                       Connect to JSON-RPC on <port> (default: 9998 or testnet: 19998)
--rpcwait                              Wait for RPC server to start
--rpcuser=<user>                       Username for JSON-RPC connections
--rpcpassword=<pw>                     Password for JSON-RPC connections
--rpcclienttimeout=<n>                 Timeout during HTTP requests (default: 900)
--stdin                                Read extra arguments from standard input, one per line until EOF/Ctrl-D (recommended for sensitive information such as passphrases)


dash-tx
-------

Dash Core dash-tx utility


Usage
^^^^^

dash-tx [options] <hex-tx> [commands]
  Update hex-encoded dash transaction
dash-tx [options] -create [commands]
  Create hex-encoded dash transaction


Options
^^^^^^^

--help                                 This help message
--create                               Create new, empty TX.
--json                                 Select JSON output
--txid                                 Output only the hex-encoded transaction id of the resultant transaction.


Chain selection options
^^^^^^^^^^^^^^^^^^^^^^^

--testnet                              Use the test chain
--devnet=<name>                        Use devnet chain with provided name
--regtest                              Enter regression test mode, which uses a special chain in which blocks can be solved instantly. This is intended for regression testing tools and app development.


Commands
^^^^^^^^

delin=N
  Delete input N from TX
delout=N
  Delete output N from TX
in=TXID:VOUT
  Add input to TX
locktime=N
  Set TX lock time to N
nversion=N
  Set TX version to N
outaddr=VALUE:ADDRESS
  Add address-based output to TX
outpubkey=VALUE:PUBKEY[:FLAGS]
  Add pay-to-pubkey output to TX. Optionally add the "S" flag to wrap the output in a pay-to-script-hash.
outdata=[VALUE:]DATA
  Add data-based output to TX
outscript=VALUE:SCRIPT[:FLAGS]
  Add raw script output to TX. Optionally add the "S" flag to wrap the output in a pay-to-script-hash.
outmultisig=VALUE:REQUIRED:PUBKEYS:PUBKEY1:PUBKEY2:....[:FLAGS]
  Add Pay To n-of-m Multi-sig output to TX. n = REQUIRED, m = PUBKEYS. Optionally add the "S" flag to wrap the output in a pay-to-script-hash.
sign=SIGHASH-FLAGS
  Add zero or more signatures to transaction. This command requires JSON registers:prevtxs=JSON object, privatekeys=JSON object. See signrawtransaction docs for format of sighash flags, JSON objects.


Register Commands
^^^^^^^^^^^^^^^^^

load=NAME:FILENAME
  Load JSON file FILENAME into register NAME
set=NAME:JSON-STRING
  Set register NAME to given JSON-STRING


RPC commands
============

This documentation lists all available RPC commands as of Dash version
0.13.0.0, and limited documentation on what each command does. For full
documentation of arguments, results and examples, type help ( "command"
) to view full details at the console. You can enter commands either
from **Tools > Debug** console in the QT wallet, or using *dash-cli* for
headless wallets and *dashd*.


Addressindex
------------

getaddressbalance
  Returns the balance for an address(es) (requires addressindex to be enabled).
getaddressdeltas
  Returns all changes for an address (requires addressindex to be enabled).
getaddressmempool
  Returns all mempool deltas for an address (requires addressindex to be enabled).
getaddresstxids
  Returns the txids for an address(es) (requires addressindex to be enabled).
getaddressutxos
  Returns all unspent outputs for an address (requires addressindex to be enabled).


Blockchain
----------

getbestblockhash
  Returns the hash of the best (tip) block in the longest blockchain.
getblock "blockhash" ( verbosity )
  If verbosity is 0, returns a string that is serialized, hex-encoded data for block 'hash'. If verbosity is 1, returns an Object with information about block <hash>. If verbosity is 2, returns an Object with information about block <hash> and information about each transaction.
getblockchaininfo
  Returns an object containing various state info regarding blockchain processing.
getblockcount
  Returns the number of blocks in the longest blockchain.
getblockhash height
  Returns hash of block in best-block-chain at height provided.
getblockhashes timestamp
  Returns array of hashes of blocks within the timestamp range provided.
getblockheader "hash" ( verbose )
  If verbose is false, returns a string that is serialized, hex-encoded data for blockheader 'hash'. If verbose is true, returns an Object with information about blockheader <hash>.
getblockheaders "hash" ( count verbose )
  Returns an array of items with information about <count> blockheaders starting from <hash>. If verbose is false, each item is a string that is serialized, hex-encoded data for a single blockheader. If verbose is true, each item is an Object with information about a single blockheader.
getchaintips ( count branchlen )
  Return information about all known tips in the block tree, including the main chain as well as orphaned branches.
getdifficulty
  Returns the proof-of-work difficulty as a multiple of the minimum difficulty.
getmempoolancestors txid (verbose)
  If txid is in the mempool, returns all in-mempool ancestors.
getmempooldescendants txid (verbose)
  If txid is in the mempool, returns all in-mempool descendants.
getmempoolentry txid
  Returns mempool data for given transaction.
getmempoolinfo
  Returns details on the active state of the TX memory pool.
getrawmempool ( verbose )
  Returns all transaction ids in memory pool as a json array of string transaction ids.
getspentinfo
  Returns the txid and index where an output is spent.
gettxout "txid" n ( include_mempool )
  Returns details about an unspent transaction output.
gettxoutproof ["txid",...] ( blockhash )
  Returns a hex-encoded proof that "txid" was included in a block.
gettxoutsetinfo
  Returns statistics about the unspent transaction output set. Note this call may take some time.
preciousblock "blockhash"
  Treats a block as if it were received before others with the same work. A later preciousblock call can override the effect of an earlier one. The effects of preciousblock are not retained across restarts.
pruneblockchain
  Prune blockchain up to specified height or unix timestamp.
verifychain ( checklevel nblocks )
  Verifies blockchain database.
verifytxoutproof "proof"
  Verifies that a proof points to a transaction in a block, returning the transaction it commits to and throwing an RPC error if the block is not in our best chain.


Control
-------

debug ( 0 | 1 | addrman | alert | bench | coindb | db | lock | rand | rpc | selectcoins | mempool | mempoolrej | net | proxy | prune | http | libevent | tor | zmq | dash | privatesend | instantsend | masternode | spork | keepass | mnpayments | gobject )
  Change debug category on the fly. Specify single category or use '+' to specify many.
getinfo
  DEPRECATED. Returns an object containing various state info.
getmemoryinfo
  Returns an object containing information about memory usage
help ( "command" ) ("subCommand")
  List all commands, or get help for a specified comm
stop
  Stop Dash Core server.


Dash
----

getgovernanceinfo
  Returns an object containing governance parameters.
getpoolinfo
  Returns an object containing mixing pool related information.
getsuperblockbudget index
  Returns the absolute maximum sum of superblock payments allowed.
gobject "command"...
  Manage governance objects. Available commands:

    check 
      Validate governance object data (proposal only)
    prepare
      Prepare governance object by signing and creating tx
    submit
      Submit governance object to network
    deserialize
      Deserialize governance object from hex string to JSON
    count
      Count governance objects and votes (additional param: 'json' or 'all', default: 'json')
    get
      Get governance object by hash
    getvotes
      Get all votes for a governance object hash (including old votes)
    getcurrentvotes
      Get only current (tallying) votes for a governance object hash (does not include old votes)
    list
      List governance objects (can be filtered by signal and/or object type)
    diff
      List differences since last diff
    vote-alias
      Vote on a governance object by masternode alias (using masternode.conf setup)
    vote-conf
      Vote on a governance object by masternode configured in dash.conf
    vote-many
      Vote on a governance object by all masternodes (using masternode.conf setup)
masternode "command"...
  Set of commands to execute masternode related actions. Available commands:

    check
      Force check all masternodes and remove invalid ones
    count
      Get information about number of masternodes (DEPRECATED options: 'total', 'ps', 'enabled', 'qualify', 'all')
    current
      Print info on current masternode winner to be paid the next block (calculated locally)
    genkey
      Generate new masternodeprivkey, optional param: 'compressed' (boolean, optional, default=false) generate compressed privkey
    outputs
      Print masternode compatible outputs
    start-alias
      Start single remote masternode by assigned alias configured in masternode.conf
    start-<mode>
      Start remote masternodes configured in masternode.conf (<mode>: 'all', 'missing', 'disabled')
    status
      Print masternode status information
    list
      Print list of all known masternodes (see masternodelist for more info)
    list-conf
      Print masternode.conf in JSON format
    winner
      Print info on next masternode winner to vote for
    winners
      Print list of masternode winners
masternodebroadcast "command"...
  Set of commands to create and relay masternode broadcast messages. Available commands:

    create-alias
      Create single remote masternode broadcast message by assigned alias configured in masternode.conf
    create-all
      Create remote masternode broadcast messages for all masternodes configured in masternode.conf
    decode
      Decode masternode broadcast message
    relay
      Relay masternode broadcast message to the network
masternode list ( "mode" "filter" )
  Get a list of masternodes in different modes. This call is identical to masternodelist call.
mnsync [status | next | reset]
  Returns the sync status, updates to the next step or resets it entirely.
privatesend "command"
  Available commands:

    start
      Start mixing
    stop
      Stop mixing
    reset
      Reset mixing
sentinelping version
  Sentinel ping.
spork "command"
  Shows information about current state of sporks. Available commands:

    show
      Show all current spork values
    active
      Show which sporks are active
voteraw <masternode-tx-hash> <masternode-tx-index> <governance-hash> <vote-signal> [yes | no | abstain] <time> <vote-sig>
  Compile and relay a governance vote with provided external signature instead of signing vote internally

Evo
---

bls "command" ...
  Set of commands to execute BLS related actions. Available commands:
  
    generate
      Create a BLS secret/public key pair
protx "command" ...
  Set of commands to execute ProTx related actions. Available commands:
  
    register
      Create and send ProTx to network
    register_fund
      Fund, create and send ProTx to network
    register_prepare
      Create an unsigned ProTx
    register_submit
      Sign and submit a ProTx
    list
      List ProTxs
    info
      Return information about a ProTx
    update_service
      Create and send ProUpServTx to network
    update_registrar
      Create and send ProUpRegTx to network
    revoke
      Create and send ProUpRevTx to network
    diff
      Calculate a diff and a proof between two masternode lists


Generating
----------

generate nblocks ( maxtries )
  Mine up to nblocks blocks immediately (before the RPC call returns)
generatetoaddress nblocks address (maxtries)
  Mine blocks immediately to a specified address (before the RPC call returns)

Mining
------

getblocktemplate ( TemplateRequest )
  If the request parameters include a 'mode' key, that is used to explicitly select between the default 'template' request or a 'proposal'. It returns data needed to construct a block to work on.
getmininginfo
  Returns a json object containing mining-related information.
getnetworkhashps ( nblocks height )
  Returns the estimated network hashes per second based on the last n blocks. Pass in [blocks] to override # of blocks, -1 specifies since last difficulty change. Pass in [height] to estimate the network speed at the time when a certain block was found.
prioritisetransaction <txid> <priority delta> <fee delta>
  Accepts the transaction into mined blocks at a higher (or lower) priority
submitblock "hexdata" ( "jsonparametersobject" )
  Attempts to submit new block to network. The 'jsonparametersobject' parameter is currently ignored. See https://en.bitcoin.it/wiki/BIP_0022 for full specification.


Network
-------

addnode "node" "add | remove | onetry"
  Attempts add or remove a node from the addnode list. Or try a connection to a node once.
clearbanned
  Clear all banned IPs.
disconnectnode "address"
  Immediately disconnects from the specified node.
getaddednodeinfo ( "node" )
  Returns information about the given added node, or all added nodes (note that onetry addnodes are not listed here)
getconnectioncount
  Returns the number of connections to other nodes.
getnettotals
  Returns information about network traffic, including bytes in, bytes out, and current time.
getnetworkinfo
  Returns an object containing various state info regarding P2P networking.
getpeerinfo
  Returns data about each connected network node as a json array of objects.
listbanned
  List all banned IPs/Subnets.
ping
  Requests that a ping be sent to all other nodes, to measure ping time. Results provided in getpeerinfo, pingtime and pingwait fields are decimal seconds. Ping command is handled in queue with all other commands, so it measures processing backlog, not just network ping.
setban "subnet" "add | remove" (bantime) (absolute)
  Attempts add or remove a IP/Subnet from the banned list.
setnetworkactive true | false
  Disable/enable all p2p network activity.


Rawtransactions
---------------

createrawtransaction [{"txid":"id","vout":n},...] {"address":amount,"data":"hex",...} ( locktime )
  Create a transaction spending the given inputs and creating new outputs. Outputs can be addresses or data. Returns hex-encoded raw transaction. Note that the transaction's inputs are not signed, and it is not stored in the wallet or transmitted to the network.
decoderawtransaction "hexstring"
  Return a JSON object representing the serialized, hex-encoded transaction.
decodescript "hexstring"
  Decode a hex-encoded script.
fundrawtransaction "hexstring" ( options )
  Add inputs to a transaction until it has enough in value to meet its out value. This will not modify existing inputs, and will add at most one change output to the outputs.
getrawtransaction "txid" ( verbose )
  Return the raw transaction data. If verbose is 'true', returns an Object with information about 'txid'. If verbose is 'false' or omitted, returns a string that is serialized, hex-encoded data for 'txid'.
sendrawtransaction "hexstring" ( allowhighfees instantsend bypasslimits)
  Submits raw transaction (serialized, hex-encoded) to local node and network. Also see createrawtransaction and signrawtransaction calls.
signrawtransaction "hexstring" ( [{"txid":"id","vout":n,"scriptPubKey":"hex","redeemScript":"hex"},...] ["privatekey1",...] sighashtype )
  Sign inputs for raw transaction (serialized, hex-encoded). The second optional argument (may be null) is an array of previous transaction outputs that this transaction depends on but may not yet be in the block chain. The third optional argument (may be null) is an array of base58-encoded private keys that, if given, will be the only keys used to sign the transaction.


Util
----

createmultisig nrequired ["key",...]
  Creates a multi-signature address with n signature of m keys required. It returns a json object with the address and redeemScript.
estimatefee nblocks
  Estimates the approximate fee per kilobyte needed for a transaction to begin confirmation within nblocks blocks.
estimatepriority nblocks
  DEPRECATED. Estimates the approximate priority a zero-fee transaction needs to begin confirmation within nblocks blocks.
estimatesmartfee nblocks
  WARNING: This interface is unstable and may disappear or change! Estimates the approximate fee per kilobyte needed for a transaction to begin confirmation within nblocks blocks if possible and return the number of blocks for which the estimate is valid.
estimatesmartpriority nblocks
  DEPRECATED. WARNING: This interface is unstable and may disappear or change! Estimates the approximate priority a zero-fee transaction needs to begin confirmation within nblocks blocks if possible and return the number of blocks for which the estimate is valid.
signmessagewithprivkey "privkey" "message"
  Sign a message with the private key of an address
validateaddress "address"
  Return information about the given dash address.
verifymessage "address" "signature" "message"
  Verify a signed message


Wallet
------

abandontransaction "txid"
  Mark in-wallet transaction <txid> as abandoned. This will mark this transaction and all its in-wallet descendants as abandoned which will allow for their inputs to be respent.
addmultisigaddress nrequired ["key",...] ( "account" )
  Add a nrequired-to-sign multisignature address to the wallet. Each key is a Dash address or hex-encoded public key. If 'account' is specified (DEPRECATED), assign address to that account.
backupwallet "destination"
  Safely copies current wallet file to destination, which can be a directory or a path with filename.
dumphdinfo
  Returns an object containing sensitive private info about this HD wallet.
dumpprivkey "address"
  Reveals the private key corresponding to 'address'. Then the importprivkey can be used with this output
dumpwallet "filename"
  Dumps all wallet keys in a human-readable format.
getaccount "address"
  DEPRECATED. Returns the account associated with the given address.
getaccountaddress "account"
  DEPRECATED. Returns the current Dash address for receiving payments to this account.
getaddressesbyaccount "account"
  DEPRECATED. Returns the list of addresses for the given account.
getbalance ( "account" minconf addlocked include_watchonly )
  If account is not specified, returns the server's total available balance. If account is specified (DEPRECATED), returns the balance in the account. Note that the account "" is not the same as leaving the parameter out. The server total may be different to the balance in the default "" account.
getnewaddress ( "account" )
  Returns a new Dash address for receiving payments. If 'account' is specified (DEPRECATED), it is added to the address book  so payments received with the address will be credited to 'account'.
getrawchangeaddress
  Returns a new Dash address, for receiving change. This is for use with raw transactions, NOT normal use.
getreceivedbyaccount "account" ( minconf addlocked )
  DEPRECATED. Returns the total amount received by addresses with <account> in transactions with specified minimum number of confirmations.
getreceivedbyaddress "address" ( minconf addlocked )
  Returns the total amount received by the given address in transactions with at least minconf confirmations.
getspecialtxes "blockhash" ( type count skip verbosity ) 
  Returns an array of special transactions found in the specified block
gettransaction "txid" ( include_watchonly )
  Get detailed information about in-wallet transaction <txid>
getunconfirmedbalance
  Returns the server's total unconfirmed balance
getwalletinfo
  Returns an object containing various wallet state info.
importaddress "address" ( "label" rescan p2sh )
  Adds a script (in hex) or address that can be watched as if it were in your wallet but cannot be used to spend.
importelectrumwallet "filename" index
  Imports keys from an Electrum wallet export file (.csv or .json)
importmulti "requests" "options"
  Import addresses/scripts (with private or public keys, redeem script (P2SH)), rescanning all addresses in one-shot-only (rescan can be disabled via options).
importprivkey "dashprivkey" ( "label" ) ( rescan )
  Adds a private key (as returned by dumpprivkey) to your wallet.
importprunedfunds
  Imports funds without rescan. Corresponding address or script must previously be included in wallet. Aimed towards pruned wallets. The end-user is responsible to import additional transactions that subsequently spend the imported outputs or rescan after the point in the blockchain the transaction is included.
importpubkey "pubkey" ( "label" rescan )
  Adds a public key (in hex) that can be watched as if it were in your wallet but cannot be used to spend.
importwallet "filename"
  Imports keys from a wallet dump file (see dumpwallet).
instantsendtoaddress "address" amount ( "comment" "comment-to" subtractfeefromamount )
  Send an amount to a given address. The amount is a real and is rounded to the nearest 0.00000001
keepass <genkey | init | setpassphrase>
  Keepass settings.
keypoolrefill ( newsize )
  Fills the keypool. Requires wallet passphrase to be set with walletpassphrase call.
listaccounts ( minconf addlocked include_watchonly)
  DEPRECATED. Returns Object that has account names as keys, account balances as values.
listaddressbalances ( minamount )
  Lists addresses of this wallet and their balances
listaddressgroupings
  Lists groups of addresses which have had their common ownership made public by common use as inputs or as the resulting change in past transactions
listlockunspent
  Returns list of temporarily unspendable outputs. See the lockunspent call to lock and unlock transactions for spending.
listreceivedbyaccount ( minconf addlocked include_empty include_watchonly)
  DEPRECATED. List incoming payments grouped by account.
listreceivedbyaddress ( minconf addlocked include_empty include_watchonly)
  List incoming payments grouped by receiving address.
listsinceblock ( "blockhash" target_confirmations include_watchonly)
  Get all transactions in blocks since block [blockhash], or all transactions if omitted
listtransactions ( "account" count skip include_watchonly)
  Returns up to 'count' most recent transactions skipping the first 'from' transactions for account 'account'.
listunspent ( minconf maxconf  ["addresses",...] [include_unsafe] )
  Returns array of unspent transaction outputs with between minconf and maxconf (inclusive) confirmations. Optionally filter to only include txouts paid to specified addresses.
lockunspent unlock ([{"txid":"txid","vout":n},...])
  Updates list of temporarily unspendable outputs. Temporarily lock (unlock=false) or unlock (unlock=true) specified transaction outputs.
move "fromaccount" "toaccount" amount ( minconf "comment" )
  DEPRECATED. Move a specified amount from one account in your wallet to another.
removeprunedfunds "txid"
  Deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds. This will effect wallet balances.
sendfrom "fromaccount" "toaddress" amount ( minconf addlocked "comment" "comment_to" )
  DEPRECATED (use sendtoaddress). Sent an amount from an account to a dash address. Requires wallet passphrase to be set with walletpassphrase call.
sendmany "fromaccount" {"address":amount,...} ( minconf addlocked "comment" ["address",...] subtractfeefromamount use_is use_ps )
  Send multiple times. Amounts are double-precision floating point numbers. Requires wallet passphrase to be set with walletpassphrase call.
sendtoaddress "address" amount ( "comment" "comment_to" subtractfeefromamount use_is use_ps )
  Send an amount to a given address.
setaccount "address" "account"
  DEPRECATED. Sets the account associated with the given address.
setprivatesendamount amount
  Set the goal amount in DASH for PrivateSend mixing.
setprivatesendrounds rounds
  Set the number of rounds for PrivateSend mixing.
settxfee amount
  Set the transaction fee per kB. Overwrites the paytxfee parameter.
signmessage "address" "message"
  Sign a message with the private key of an address Requires wallet passphrase to be set with walletpassphrase call.
walletlock
  Removes the wallet encryption key from memory, locking the wallet. After calling this method, you will need to call walletpassphrase again before being able to call any methods which require the wallet to be unlocked.
walletpassphrase "passphrase" timeout ( mixingonly )
  Stores the wallet decryption key in memory for 'timeout' seconds. This is needed prior to performing transactions related to private keys such as sending dashs
walletpassphrasechange "oldpassphrase" "newpassphrase"
  Changes the wallet passphrase from 'oldpassphrase' to 'newpassphrase'.
