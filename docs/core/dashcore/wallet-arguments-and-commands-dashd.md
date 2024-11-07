```{eval-rst}
.. _dashcore-arguments-and-commands-dashd:
.. meta::
  :title: dashd Arguments and Commands
  :description: The following section shows all available options for dashd including debug options that are not normally displayed.
```

# dashd

## Usage

**Start Dash Core Daemon**

```bash
dashd [options]
```

:::{attention}
The following sections show all available options including debug options that are not normally displayed. To see only regular options, run `dashd --help`.
:::

### Options

```text
  -?
       Print this help message and exit

  -alertnotify=<cmd>
       Execute command when an alert is raised (%s in cmd is replaced by
       message)

  -assumevalid=<hex>
       If this block is in the chain assume that it and its ancestors are valid
       and potentially skip their script verification (0 to verify all,
       default:
       000000000000001889bd33ef019065e250d32bd46911f4003d3fdd8128b5358d,
       testnet:
       00000034bfeb926662ba547c0b8dd4ba8cbb6e0c581f4e7d1bddce8f9ca3a608)

  -blockfilterindex=<type>
       Maintain an index of compact filters by block (default: 0, values:
       basic). If <type> is not supplied or if <type> = 1, indexes for
       all known types are enabled.

  -blocknotify=<cmd>
       Execute command when the best block changes (%s in cmd is replaced by
       block hash)

  -blockreconstructionextratxn=<n>
       Extra transactions to keep in memory for compact block reconstructions
       (default: 100)

  -blocksdir=<dir>
       Specify directory to hold blocks subdirectory for *.dat files (default:
       <datadir>)

  -blocksonly
       Whether to reject transactions from network peers. Automatic broadcast
       and rebroadcast of any transactions from inbound peers is
       disabled, unless the peer has the 'forcerelay' permission. RPC
       transactions are not affected. (default: 0)

  -chainlocknotify=<cmd>
       Execute command when the best chainlock changes (%s in cmd is replaced
       by chainlocked block hash)

  -coinstatsindex
       Maintain coinstats index used by the gettxoutsetinfo RPC (default: 0)

  -conf=<file>
       Specify path to read-only configuration file. Relative paths will be
       prefixed by datadir location. (default: dash.conf)

  -daemon
       Run in the background as a daemon and accept commands (default: 0)

  -daemonwait
       Wait for initialization to be finished before exiting. This implies
       -daemon (default: 0)

  -datadir=<dir>
       Specify data directory

  -dbbatchsize
       Maximum database write batch size in bytes (default: 16777216)

  -dbcache=<n>
       Maximum database cache size <n> MiB (4 to 16384, default: 300). In
       addition, unused mempool memory is shared for this cache (see
       -maxmempool).

  -debuglogfile=<file>
       Specify location of debug log file. Relative paths will be prefixed by a
       net-specific datadir location. (-nodebuglogfile to disable;
       default: debug.log)

  -includeconf=<file>
       Specify additional configuration file, relative to the -datadir path
       (only useable from configuration file, not command line)

  -loadblock=<file>
       Imports blocks from external file on startup

  -maxmempool=<n>
       Keep the transaction memory pool below <n> megabytes (default: 300)

  -maxorphantxsize=<n>
       Maximum total size of all orphan transactions in megabytes (default: 10)

  -maxrecsigsage=<n>
       Number of seconds to keep LLMQ recovery sigs (default: 604800)

  -mempoolexpiry=<n>
       Do not keep transactions in the mempool longer than <n> hours (default:
       336)

  -minimumchainwork=<hex>
       Minimum work assumed to exist on a valid chain in hex (default:
       00000000000000000000000000000000000000000000988117deadb0db9cd5b8,
       testnet:
       000000000000000000000000000000000000000000000000031779704a0f54b4)

  -par=<n>
       Set the number of script verification threads (-16 to 15, 0 = auto, <0 =
       leave that many cores free, default: 0)

  -persistmempool
       Whether to save the mempool on shutdown and load on restart (default: 1)

  -pid=<file>
       Specify pid file. Relative paths will be prefixed by a net-specific
       datadir location. (default: dashd.pid)

  -prune=<n>
       Reduce storage requirements by enabling pruning (deleting) of old
       blocks. This allows the pruneblockchain RPC to be called to
       delete specific blocks, and enables automatic pruning of old
       blocks if a target size in MiB is provided. This mode is
       incompatible with -txindex, -coinstatsindex, -rescan and
       -disablegovernance=false. Warning: Reverting this setting
       requires re-downloading the entire blockchain. (default: 0 =
       disable pruning blocks, 1 = allow manual pruning via RPC, >945 =
       automatically prune block files to stay under the specified
       target size in MiB)

  -settings=<file>
       Specify path to dynamic settings data file. Can be disabled with
       -nosettings. File is written at runtime and not meant to be
       edited by users (use dash.conf instead for custom settings).
       Relative paths will be prefixed by datadir location. (default:
       settings.json)

  -startupnotify=<cmd>
       Execute command on startup.

  -syncmempool
       Sync mempool from other nodes on start (default: 1)

  -sysperms
       Create new files with system default permissions, instead of umask 077
       (only effective with disabled wallet functionality)

  -version
       Print version and exit
```

### Connection options

```text
  -addnode=<ip>
       Add a node to connect to and attempt to keep the connection open (see
       the addnode RPC help for more info). This option can be specified
       multiple times to add multiple nodes; connections are limited to
       8 at a time and are counted separately from the -maxconnections
       limit.

  -allowprivatenet
       Allow RFC1918 addresses to be relayed and connected to (default: 0)

  -asmap=<file>
       Specify asn mapping used for bucketing of the peers (default:
       ip_asn.map). Relative paths will be prefixed by the net-specific
       datadir location.

  -bantime=<n>
       Default duration (in seconds) of manually configured bans (default:
       86400)

  -bind=<addr>[:<port>][=onion]
       Bind to given address and always listen on it (default: 0.0.0.0). Use
       [host]:port notation for IPv6. Append =onion to tag any incoming
       connections to that address and port as incoming Tor connections
       (default: 127.0.0.1:9996=onion, testnet: 127.0.0.1:19996=onion,
       regtest: 127.0.0.1:19896=onion)

  -cjdnsreachable
       If set, then this host is configured for CJDNS (connecting to fc00::/8
       addresses would lead us to the CJDNS network, see doc/cjdns.md)
       (default: 0)

  -connect=<ip>
       Connect only to the specified node; -noconnect disables automatic
       connections (the rules for this peer are the same as for
       -addnode). This option can be specified multiple times to connect
       to multiple nodes.

  -discover
       Discover own IP addresses (default: 1 when listening and no -externalip
       or -proxy)

  -dns
       Allow DNS lookups for -addnode, -seednode and -connect (default: 1)

  -dnsseed
       Query for peer addresses via DNS lookup, if low on addresses (default: 1
       unless -connect used)

  -externalip=<ip>
       Specify your own public address

  -fixedseeds
       Allow fixed seeds if DNS seeds don't provide peers (default: 1)

  -forcednsseed
       Always query for peer addresses via DNS lookup (default: 0)

  -i2pacceptincoming
       Whether to accept inbound I2P connections (default: 1). Ignored if
       -i2psam is not set. Listening for inbound I2P connections is done
       through the SAM proxy, not by binding to a local address and
       port.

  -i2psam=<ip:port>
       I2P SAM proxy to reach I2P peers and accept I2P connections (default:
       none)

  -listen
       Accept connections from outside (default: 1 if no -proxy or -connect)

  -listenonion
       Automatically create Tor onion service (default: 1)

  -maxconnections=<n>
       Maintain at most <n> connections to peers (temporary service connections
       excluded) (default: 125). This limit does not apply to
       connections manually added via -addnode or the addnode RPC, which
       have a separate limit of 8.

  -maxreceivebuffer=<n>
       Maximum per-connection receive buffer, <n>*1000 bytes (default: 5000)

  -maxsendbuffer=<n>
       Maximum per-connection send buffer, <n>*1000 bytes (default: 1000)

  -maxtimeadjustment
       Maximum allowed median peer time offset adjustment. Local perspective of
       time may be influenced by peers forward or backward by this
       amount. (default: 4200 seconds)

  -maxuploadtarget=<n>
       Tries to keep outbound traffic under the given target (in MiB per 24h).
       Limit does not apply to peers with 'download' permission. 0 = no
       limit (default: 0)

  -natpmp
       Use NAT-PMP to map the listening port (default: 0)

  -networkactive
       Enable all P2P network activity (default: 1). Can be changed by the
       setnetworkactive RPC command

  -onion=<ip:port>
       Use separate SOCKS5 proxy to reach peers via Tor onion services, set
       -noonion to disable (default: -proxy)

  -onlynet=<net>
       Make automatic outbound connections only to network <net> (ipv4, ipv6,
       onion, i2p, cjdns). Inbound and manual connections are not
       affected by this option. It can be specified multiple times to
       allow multiple networks.

  -peerblockfilters
       Serve compact block filters to peers per BIP 157 (default: 0)

  -peerbloomfilters
       Support filtering of blocks and transaction with bloom filters (default:
       1)

  -peertimeout=<n>
       Specify a p2p connection timeout delay in seconds. After connecting to a
       peer, wait this amount of time before considering disconnection
       based on inactivity (minimum: 1, default: 60)

  -permitbaremultisig
       Relay non-P2SH multisig (default: 1)

  -port=<port>
       Listen for connections on <port>. Nodes not using the default ports
       (default: 9999, testnet: 19999, regtest: 19899) are unlikely to
       get incoming connections. Not relevant for I2P (see doc/i2p.md).

  -proxy=<ip:port>
       Connect through SOCKS5 proxy, set -noproxy to disable (default:
       disabled)

  -proxyrandomize
       Randomize credentials for every proxy connection. This enables Tor
       stream isolation (default: 1)

  -seednode=<ip>
       Connect to a node to retrieve peer addresses, and disconnect. This
       option can be specified multiple times to connect to multiple
       nodes.

  -socketevents=<mode>
       Socket events mode, which must be one of 'select', 'poll', 'epoll' or
       'kqueue', depending on your system (default: Linux - 'epoll',
       FreeBSD/Apple - 'kqueue', Windows - 'select')

  -timeout=<n>
       Specify socket connection timeout in milliseconds. If an initial attempt
       to connect is unsuccessful after this amount of time, drop it
       (minimum: 1, default: 5000)

  -torcontrol=<ip>:<port>
       Tor control port to use if onion listening enabled (default:
       127.0.0.1:9051)

  -torpassword=<pass>
       Tor control port password (default: empty)

  -upnp
       Use UPnP to map the listening port (default: 1 when listening and no
       -proxy)

  -whitebind=<[permissions@]addr>
       Bind to the given address and add permission flags to the peers
       connecting to it. Use [host]:port notation for IPv6. Allowed
       permissions: bloomfilter (allow requesting BIP37 filtered blocks
       and transactions), noban (do not ban for misbehavior; implies
       download), forcerelay (relay transactions that are already in the
       mempool; implies relay), relay (relay even in -blocksonly mode),
       mempool (allow requesting BIP35 mempool contents), download
       (allow getheaders during IBD, no disconnect after maxuploadtarget
       limit), addr (responses to GETADDR avoid hitting the cache and
       contain random records with the most up-to-date info). Specify
       multiple permissions separated by commas (default:
       download,noban,mempool,relay). Can be specified multiple times.

  -whitelist=<[permissions@]IP address or network>
       Add permission flags to the peers connecting from the given IP address
       (e.g. 1.2.3.4) or CIDR-notated network (e.g. 1.2.3.0/24). Uses
       the same permissions as -whitebind. Can be specified multiple
       times.
```

### Indexing options

```text
  -addressindex
       Maintain a full address index, used to query for the balance, txids and
       unspent outputs for addresses (default: 0)

  -reindex
       Rebuild chain state and block index from the blk*.dat files on disk

  -reindex-chainstate
       Rebuild chain state from the currently indexed blocks. When in pruning
       mode or if blocks on disk might be corrupted, use full -reindex
       instead.

  -spentindex
       Maintain a full spent index, used to query the spending txid and input
       index for an outpoint (default: 0)

  -timestampindex
       Maintain a timestamp index for block hashes, used to query blocks hashes
       by a range of timestamps (default: 0)

  -txindex
       Maintain a full transaction index, used by the getrawtransaction rpc
       call (default: 1)
```

### Wallet options

:::{attention}
Dash Core 18.1.0 removed the `-zapwallettxes` startup option and its functionality. This option was originally intended to allow for the fee bumping of transactions that did not signal RBF. This functionality has been superseded with the [abandon transaction capability](../api/remote-procedure-calls-wallet.md#abandontransaction) available via RPC/console or when right-clicking on unconfirmed transactions in Dash-Qt.
:::

```text
  -avoidpartialspends
       Group outputs by address, selecting many (possibly all) or none, instead
       of selecting on a per-output basis. Privacy is improved as
       addresses are mostly swept with fewer transactions and outputs
       are aggregated in clean change addresses. It may result in higher
       fees due to less optimal coin selection caused by this added
       limitation and possibly a larger-than-necessary number of inputs
       being used. Always enabled for wallets with "avoid_reuse"
       enabled, otherwise default: 0.

  -createwalletbackups=<n>
       Number of automatic wallet backups (default: 10)

  -disablewallet
       Do not load the wallet and disable wallet RPC calls

  -instantsendnotify=<cmd>
       Execute command when a wallet InstantSend transaction is successfully
       locked. %s in cmd is replaced by TxID and %w is replaced by
       wallet name. %w is not currently implemented on Windows. On
       systems where %w is supported, it should NOT be quoted because
       this would break shell escaping used to invoke the command.

  -keypool=<n>
       Set key pool size to <n> (default: 1000). Warning: Smaller sizes may
       increase the risk of losing funds when restoring from an old
       backup, if none of the addresses in the original keypool have
       been used.

  -maxapsfee=<n>
       Spend up to this amount in additional (absolute) fees (in DASH) if it
       allows the use of partial spend avoidance (default: 0.00)

  -rescan=<mode>
       Rescan the block chain for missing wallet transactions on startup (1 =
       start from wallet creation time, 2 = start from genesis block)

  -spendzeroconfchange
       Spend unconfirmed change when sending transactions (default: 1)

  -wallet=<path>
       Specify wallet path to load at startup. Can be used multiple times to
       load multiple wallets. Path is to a directory containing wallet
       data and log files. If the path is not absolute, it is
       interpreted relative to <walletdir>. This only loads existing
       wallets and does not create new ones. For backwards compatibility
       this also accepts names of existing top-level data files in
       <walletdir>.

  -walletbackupsdir=<dir>
       Specify full path to directory for automatic wallet backups (must exist)

  -walletbroadcast
       Make the wallet broadcast transactions (default: 1)

  -walletdir=<dir>
       Specify directory to hold wallets (default: <datadir>/wallets if it
       exists, otherwise <datadir>)

  -walletnotify=<cmd>
       Execute command when a wallet transaction changes. %s in cmd is replaced
       by TxID and %w is replaced by wallet name. %w is not currently
       implemented on windows. On systems where %w is supported, it
       should NOT be quoted because this would break shell escaping used
       to invoke the command.
```

### Wallet fee options

```text
  -discardfee=<amt>
       The fee rate (in DASH/kB) that indicates your tolerance for discarding
       change by adding it to the fee (default: 0.0001). Note: An output
       is discarded if it is dust at this rate, but we will always
       discard up to the dust relay fee and a discard fee above that is
       limited by the fee estimate for the longest target

  -fallbackfee=<amt>
       A fee rate (in DASH/kB) that will be used when fee estimation has
       insufficient data. 0 to entirely disable the fallbackfee feature.
       (default: 0.00001)

  -mintxfee=<amt>
       Fee rates (in DASH/kB) smaller than this are considered zero fee for
       transaction creation (default: 0.00001)

  -paytxfee=<amt>
       Fee rate (in DASH/kB) to add to transactions you send (default: 0.00)

  -txconfirmtarget=<n>
       If paytxfee is not set, include enough fee so transactions begin
       confirmation on average within n blocks (default: 6)
```

### HD wallet options

```text
  -hdseed=<hex>
       User defined seed for HD wallet (should be in hex). Only has effect
       during wallet creation/first start (default: randomly generated)

  -mnemonic=<text>
       User defined mnemonic for HD wallet (bip39). Only has effect during
       wallet creation/first start (default: randomly generated)

  -mnemonicbits=<n>
       User defined mnemonic security for HD wallet in bits (BIP39). Only has
       effect during wallet creation/first start (allowed values: 128,
       160, 192, 224, 256; default: 128)

  -mnemonicpassphrase=<text>
       User defined mnemonic passphrase for HD wallet (BIP39). Only has effect
       during wallet creation/first start (default: empty string)

  -usehd
       Use hierarchical deterministic key generation (HD) after BIP39/BIP44.
       Only has effect during wallet creation/first start (default: 1)
```

### CoinJoin options

```text
  -coinjoinamount=<n>
       Target CoinJoin balance (2-21000000, default: 1000)

  -coinjoinautostart
       Start CoinJoin automatically (0-1, default: 0)

  -coinjoindenomsgoal=<n>
       Try to create at least N inputs of each denominated amount (10-100000,
       default: 50)

  -coinjoindenomshardcap=<n>
       Create up to N inputs of each denominated amount (10-100000, default:
       300)

  -coinjoinmultisession
       Enable multiple CoinJoin mixing sessions per block, experimental (0-1,
       default: 0)

  -coinjoinrounds=<n>
       Use N separate masternodes for each denominated input to mix funds
       (2-16, default: 4)

  -coinjoinsessions=<n>
       Use N separate masternodes in parallel to mix funds (1-10, default: 4)

  -enablecoinjoin
       Enable use of CoinJoin for funds stored in this wallet (0-1, default: 0)
```

### ZeroMQ notification options

```text
  -zmqpubhashblock=<address>
       Enable publish hash block in <address>

  -zmqpubhashblockhwm=<n>
       Set publish hash block outbound message high water mark (default: 1000)

  -zmqpubhashchainlock=<address>
       Enable publish hash block (locked via ChainLocks) in <address>

  -zmqpubhashchainlockhwm=<n>
       Set publish hash chain lock outbound message high water mark (default:
       1000)

  -zmqpubhashgovernanceobject=<address>
       Enable publish hash of governance objects (like proposals) in <address>

  -zmqpubhashgovernanceobjecthwm=<n>
       Set publish hash governance object outbound message high water mark
       (default: 1000)

  -zmqpubhashgovernancevote=<address>
       Enable publish hash of governance votes in <address>

  -zmqpubhashgovernancevotehwm=<n>
       Set publish hash governance vote outbound message high water mark
       (default: 1000)

  -zmqpubhashinstantsenddoublespend=<address>
       Enable publish transaction hashes of attempted InstantSend double spend
       in <address>

  -zmqpubhashinstantsenddoublespendhwm=<n>
       Set publish hash InstantSend double spend outbound message high water
       mark (default: 1000)

  -zmqpubhashrecoveredsig=<address>
       Enable publish message hash of recovered signatures (recovered by LLMQs)
       in <address>

  -zmqpubhashrecoveredsighwm=<n>
       Set publish hash recovered signature outbound message high water mark
       (default: 1000)

  -zmqpubhashtx=<address>
       Enable publish hash transaction in <address>

  -zmqpubhashtxhwm=<n>
       Set publish hash transaction outbound message high water mark (default:
       1000)

  -zmqpubhashtxlock=<address>
       Enable publish hash transaction (locked via InstantSend) in <address>

  -zmqpubhashtxlockhwm=<n>
       Set publish hash transaction lock outbound message high water mark
       (default: 1000)

  -zmqpubrawblock=<address>
       Enable publish raw block in <address>

  -zmqpubrawblockhwm=<n>
       Set publish raw block outbound message high water mark (default: 1000)

  -zmqpubrawchainlock=<address>
       Enable publish raw block (locked via ChainLocks) in <address>

  -zmqpubrawchainlockhwm=<n>
       Set publish raw chain lock outbound message high water mark (default:
       1000)

  -zmqpubrawchainlocksig=<address>
       Enable publish raw block (locked via ChainLocks) and CLSIG message in
       <address>

  -zmqpubrawchainlocksighwm=<n>
       Set publish raw chain lock signature outbound message high water mark
       (default: 1000)

  -zmqpubrawgovernanceobject=<address>
       Enable publish raw governance votes in <address>

  -zmqpubrawgovernanceobjecthwm=<n>
       Set publish raw governance object outbound message high water mark
       (default: 1000)

  -zmqpubrawgovernancevote=<address>
       Enable publish raw governance objects (like proposals) in <address>

  -zmqpubrawgovernancevotehwm=<n>
       Set publish raw governance vote outbound message high water mark
       (default: 1000)

  -zmqpubrawinstantsenddoublespend=<address>
       Enable publish raw transactions of attempted InstantSend double spend in
       <address>

  -zmqpubrawinstantsenddoublespendhwm=<n>
       Set publish raw InstantSend double spend outbound message high water
       mark (default: 1000)

  -zmqpubrawrecoveredsig=<address>
       Enable publish raw recovered signatures (recovered by LLMQs) in
       <address>

  -zmqpubrawrecoveredsighwm=<n>
       Set publish raw recovered signature outbound message high water mark
       (default: 1000)

  -zmqpubrawtx=<address>
       Enable publish raw transaction in <address>

  -zmqpubrawtxhwm=<n>
       Set publish raw transaction outbound message high water mark (default:
       1000)

  -zmqpubrawtxlock=<address>
       Enable publish raw transaction (locked via InstantSend) in <address>

  -zmqpubrawtxlockhwm=<n>
       Set publish raw transaction lock outbound message high water mark
       (default: 1000)

  -zmqpubrawtxlocksig=<address>
       Enable publish raw transaction (locked via InstantSend) and ISLOCK in
       <address>

  -zmqpubrawtxlocksighwm=<n>
       Set publish raw transaction lock signature outbound message high water
       mark (default: 1000)
```

### Debugging/Testing options

```text
  -addrmantest
       Allows to test address relay on localhost

  -capturemessages
       Capture all P2P messages to disk

  -checkaddrman=<n>
       Run addrman consistency checks every <n> operations. Use 0 to disable.
       (default: 0)

  -checkblockindex
       Do a consistency check for the block tree, and  occasionally. (default:
       0, regtest: 1)

  -checkblocks=<n>
       How many blocks to check at startup (default: 6, 0 = all)

  -checklevel=<n>
       How thorough the block verification of -checkblocks is: level 0 reads
       the blocks from disk, level 1 verifies block validity, level 2
       verifies undo data, level 3 checks disconnection of tip blocks,
       level 4 tries to reconnect the blocks, each level includes the
       checks of the previous levels (0-4, default: 3)

  -checkmempool=<n>
       Run mempool consistency checks every <n> transactions. Use 0 to disable.
       (default: 0, regtest: 1)

  -checkpoints
       Enable rejection of any forks from the known historical chain until
       block 2109672 (default: 1)

  -debug=<category>
       Output debugging information (default: -nodebug, supplying <category> is
       optional). If <category> is not supplied or if <category> = 1,
       output all debugging information. <category> can be: addrman,
       bench, chainlocks, cmpctblock, coindb, coinjoin, creditpool, ehf,
       estimatefee, gobject, http, i2p, instantsend, leveldb, libevent,
       llmq, llmq-dkg, llmq-sigs, lock, mempool, mempoolrej, mnpayments,
       mnsync, net, netconn, proxy, prune, qt, rand, reindex, rpc,
       selectcoins, spork, tor, validation, walletdb, zmq. This option
       can be specified multiple times to output multiple categories.

  -debugexclude=<category>
       Exclude debugging information for a category. Can be used in conjunction
       with -debug=1 to output debug logs for all categories except the
       specified category. This option can be specified multiple times
       to exclude multiple categories.

  -deprecatedrpc=<method>
       Allows deprecated RPC method(s) to be used

  -disablegovernance
       Disable governance validation (0-1, default: 0)

  -fastprune
       Use smaller block files and lower minimum prune height for testing
       purposes

  -help-debug
       Print help message with debugging options and exit

  -limitancestorcount=<n>
       Do not accept transactions if number of in-mempool ancestors is <n> or
       more (default: 25)

  -limitancestorsize=<n>
       Do not accept transactions whose size with all in-mempool ancestors
       exceeds <n> kilobytes (default: 101)

  -limitdescendantcount=<n>
       Do not accept transactions if any ancestor would have <n> or more
       in-mempool descendants (default: 25)

  -limitdescendantsize=<n>
       Do not accept transactions if any ancestor would have more than <n>
       kilobytes of in-mempool descendants (default: 101).

  -logips
       Include IP addresses in debug output (default: 0)

  -logsourcelocations
       Prepend debug output with name of the originating source location
       (source file, line number and function name) (default: 0)

  -logthreadnames
       Prepend debug output with name of the originating thread (only available
       on platforms supporting thread_local) (default: 0)

  -logtimemicros
       Add microsecond precision to debug timestamps (default: 0)

  -maxsigcachesize=<n>
       Limit sum of signature cache and script execution cache sizes to <n> MiB
       (default: 32)

  -maxtipage=<n>
       Maximum tip age in seconds to consider node in initial block download
       (default: 21600)

  -maxtxfee=<amt>
       Maximum total fees (in DASH) to use in a single wallet transaction;
       setting this too low may abort large transactions (default: 0.10)

  -minsporkkeys=<n>
       Overrides minimum spork signers to change spork value. Only useful for
       regtest and devnet. Using this on mainnet or testnet will ban
       you.

  -mocktime=<n>
       Replace actual time with UNIX epoch time(default: 0)

  -printpriority
       Log transaction fee per kB when mining blocks (default: 0)

  -printtoconsole
       Send trace/debug info to console (default: 1 when no -daemon. To disable
       logging to file, set -nodebuglogfile)

  -pushversion
       Protocol version to report to other nodes

  -shrinkdebugfile
       Shrink debug.log file on client startup (default: 1 when no -debug)

  -sporkaddr=<dashaddress>
       Override spork address. Only useful for regtest and devnet. Using this
       on mainnet or testnet will ban you.

  -sporkkey=<privatekey>
       Set the private key to be used for signing spork messages.

  -stopafterblockimport
       Stop running after importing blocks from disk (default: 0)

  -stopatheight
       Stop running after reaching the given height in the main chain (default:
       0)

  -uacomment=<cmt>
       Append comment to the user agent string

  -watchquorums=<n>
       Watch and validate quorum communication (default: 0)
```

### Chain selection options

```text
  -bip147height=<activation>
       Override BIP147 activation height (regtest-only)

  -budgetparams=<masternode>:<budget>:<superblock>
       Override masternode, budget and superblock start heights (regtest-only)

  -chain=<chain>
       Use the chain <chain> (default: main). Allowed values: main, test,
       regtest

  -devnet=<name>
       Use devnet chain with provided name

  -dip3params=<activation>:<enforcement>
       Override DIP3 activation and enforcement heights (regtest-only)

  -dip8params=<activation>
       Override DIP8 activation height (regtest-only)

  -highsubsidyblocks=<n>
       The number of blocks with a higher than normal subsidy to mine at the
       start of a chain. Block after that height will have fixed subsidy
       base. (default: 0, devnet-only)

  -highsubsidyfactor=<n>
       The factor to multiply the normal block subsidy by while in the
       highsubsidyblocks window of a chain (default: 1, devnet-only)

  -llmqchainlocks=<quorum name>
       Override the default LLMQ type used for ChainLocks. Allows using
       ChainLocks with smaller LLMQs. (default: llmq_devnet,
       devnet-only)

  -llmqdevnetparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_DEVNET quorum (devnet-only)

  -llmqinstantsenddip0024=<quorum name>
       Override the default LLMQ type used for InstantSendDIP0024. (default:
       llmq_devnet_dip0024, devnet-only)

  -llmqmnhf=<quorum name>
       Override the default LLMQ type used for EHF. (default: llmq_devnet,
       devnet-only)

  -llmqplatform=<quorum name>
       Override the default LLMQ type used for Platform. (default:
       llmq_devnet_platform, devnet-only)

  -llmqtestinstantsenddip0024=<quorum name>
       Override the default LLMQ type used for InstantSendDIP0024. Used mainly
       to test Platform. (default: llmq_test_dip0024, regtest-only)

  -llmqtestinstantsendparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_TEST_INSTANTSEND quorums
       (default: 3:2, regtest-only)

  -llmqtestparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_TEST quorum (default: 3:2,
       regtest-only)

  -minimumdifficultyblocks=<n>
       The number of blocks that can be mined with the minimum difficulty at
       the start of a chain (default: 0, devnet-only)

  -powtargetspacing=<n>
       Override the default PowTargetSpacing value in seconds (default: 2.5
       minutes, devnet-only)

  -regtest
       Enter regression test mode, which uses a special chain in which blocks
       can be solved instantly. This is intended for regression testing
       tools and app development. Equivalent to -chain=regtest

  -testnet
       Use the test chain. Equivalent to -chain=test

  -vbparams=<deployment>:<start>:<end>(:min_activation_height(:<window>:<threshold/thresholdstart>(:<thresholdmin>:<falloffcoeff>:<mnactivation>)))
       Use given start/end times and min_activation_height for specified
       version bits deployment (regtest-only). Specifying window,
       threshold/thresholdstart, thresholdmin, falloffcoeff and
       mnactivation is optional.
```

### Masternode options

```text
  -llmq-data-recovery=<n>
       Enable automated quorum data recovery (default: 1)

  -llmq-qvvec-sync=<quorum_name>:<mode>
       Defines from which LLMQ type the masternode should sync quorum
       verification vectors. Can be used multiple times with different
       LLMQ types. <mode>: 0 (sync always from all quorums of the type
       defined by <quorum_name>), 1 (sync from all quorums of the type
       defined by <quorum_name> if a member of any of the quorums)

  -masternodeblsprivkey=<hex>
       Set the masternode BLS private key and enable the client to act as a
       masternode

  -platform-user=<user>
       Set the username for the "platform user", a restricted user intended to
       be used by Dash Platform, to the specified username.
```

### Node relay options

```text
  -acceptnonstdtxn
       Relay and mine "non-standard" transactions (testnet/regtest only;
       default: 1)

  -bytespersigop
       Equivalent bytes per sigop in transactions for relay and mining
       (default: 20)

  -datacarrier
       Relay and mine data carrier transactions (default: 1)

  -datacarriersize
       Maximum size of data in data carrier transactions we relay and mine
       (default: 83)

  -dustrelayfee=<amt>
       Fee rate (in DASH/kB) used to define dust, the value of an output such
       that it will cost more than its value in fees at this fee rate to
       spend it. (default: 0.00003)

  -incrementalrelayfee=<amt>
       Fee rate (in DASH/kB) used to define cost of relay, used for mempool
       limiting and BIP 125 replacement. (default: 0.00001)

  -minrelaytxfee=<amt>
       Fees (in DASH/kB) smaller than this are considered zero fee for
       relaying, mining and transaction creation (default: 0.00001)

  -whitelistforcerelay
       Add 'forcerelay' permission to whitelisted inbound peers with default
       permissions. This will relay transactions even if the
       transactions were already in the mempool. (default: 0)

  -whitelistrelay
       Add 'relay' permission to whitelisted inbound peers with default
       permissions. This will accept relayed transactions even when not
       relaying transactions (default: 1)
```

### Block creation options

```text
  -blockmaxsize=<n>
       Set maximum block size in bytes (default: 2000000)

  -blockmintxfee=<amt>
       Set lowest fee rate (in DASH/kB) for transactions to be included in
       block creation. (default: 0.00001)

  -blockversion=<n>
       Override block version to test forking scenarios
```

### RPC server options

```text
  -rest
       Accept public REST requests (default: 0)

  -rpcallowip=<ip>
       Allow JSON-RPC connections from specified source. Valid for <ip> are a
       single IP (e.g. 1.2.3.4), a network/netmask (e.g.
       1.2.3.4/255.255.255.0) or a network/CIDR (e.g. 1.2.3.4/24). This
       option can be specified multiple times

  -rpcauth=<userpw>
       Username and HMAC-SHA-256 hashed password for JSON-RPC connections. The
       field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>. A
       canonical python script is included in share/rpcuser. The client
       then connects normally using the
       rpcuser=<USERNAME>/rpcpassword=<PASSWORD> pair of arguments. This
       option can be specified multiple times

  -rpcbind=<addr>[:port]
       Bind to given address to listen for JSON-RPC connections. Do not expose
       the RPC server to untrusted networks such as the public internet!
       This option is ignored unless -rpcallowip is also passed. Port is
       optional and overrides -rpcport. Use [host]:port notation for
       IPv6. This option can be specified multiple times (default:
       127.0.0.1 and ::1 i.e., localhost, or if -rpcallowip has been
       specified, 0.0.0.0 and :: i.e., all addresses)

  -rpccookiefile=<loc>
       Location of the auth cookie. Relative paths will be prefixed by a
       net-specific datadir location. (default: data dir)

  -rpcexternaluser=<users>
       List of comma-separated usernames for JSON-RPC external connections

  -rpcexternalworkqueue=<n>
       Set the depth of the work queue to service external RPC calls (default:
       16)

  -rpcpassword=<pw>
       Password for JSON-RPC connections

  -rpcport=<port>
       Listen for JSON-RPC connections on <port> (default: 9998, testnet:
       19998, regtest: 19898)

  -rpcservertimeout=<n>
       Timeout during HTTP requests (default: 30)

  -rpcthreads=<n>
       Set the number of threads to service RPC calls (default: 4)

  -rpcuser=<user>
       Username for JSON-RPC connections

  -rpcwhitelist=<whitelist>
       Set a whitelist to filter incoming RPC calls for a specific user. The
       field <whitelist> comes in the format: <USERNAME>:<rpc 1>,<rpc
       2>,...,<rpc n>. If multiple whitelists are set for a given user,
       they are set-intersected. See -rpcwhitelistdefault documentation
       for information on default whitelist behavior.

  -rpcwhitelistdefault
       Sets default behavior for rpc whitelisting. Unless rpcwhitelistdefault
       is set to 0, if any -rpcwhitelist is set, the rpc server acts as
       if all rpc users are subject to empty-unless-otherwise-specified
       whitelists. If rpcwhitelistdefault is set to 1 and no
       -rpcwhitelist is set, rpc server acts as if all rpc users are
       subject to empty whitelists.

  -rpcworkqueue=<n>
       Set the depth of the work queue to service RPC calls (default: 16)

  -server
       Accept command line and JSON-RPC commands
```

### Statsd options

```text
  -statsenabled
       Publish internal stats to statsd (default: 0)

  -statshost=<ip>
       Specify statsd host (default: 127.0.0.1)

  -statshostname=<ip>
       Specify statsd host name (default: )

  -statsns=<ns>
       Specify additional namespace prefix (default: )

  -statsperiod=<seconds>
       Specify the number of seconds between periodic measurements (default:
       60)

  -statsport=<port>
       Specify statsd port (default: 8125)
```

### Wallet debugging/testing options

:::{attention}
These options are normally hidden and will only be shown if using the help debug option: `dashd --held -help-debug`
:::

```text
  -dblogsize=<n>
       Flush wallet database activity from memory to disk log every <n>
       megabytes (default: 100)

  -flushwallet
       Run a thread to flush wallet periodically (default: 1)

  -privdb
       Sets the DB_PRIVATE flag in the wallet db environment (default: 1)

  -unsafesqlitesync
       Set SQLite synchronous=OFF to disable waiting for the database to sync
       to disk. This is unsafe and can cause data loss and corruption.
       This option is only used by tests to improve their performance
       (default: false)

  -walletrejectlongchains
       Wallet will not create transactions that violate mempool chain limits
       (default: 0)
```

## Network Dependent Options

The following options can only be used for specific network types. These options are provided support development (devnet) and regression test (regtest) networks.

### Devnet Options

```text
  -highsubsidyblocks=<n>
       The number of blocks with a higher than normal subsidy to mine at the
       start of a chain. Block after that height will have fixed subsidy
       base. (default: 0, devnet-only)

  -highsubsidyfactor=<n>
       The factor to multiply the normal block subsidy by while in the
       highsubsidyblocks window of a chain (default: 1, devnet-only)

  -llmqchainlocks=<quorum name>
       Override the default LLMQ type used for ChainLocks. Allows using
       ChainLocks with smaller LLMQs. (default: llmq_devnet,
       devnet-only)

  -llmqdevnetparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_DEVNET quorum (default: 3:2,
       devnet-only)

  -llmqinstantsenddip0024=<quorum name>
       Override the default LLMQ type used for InstantSendDIP0024. (default:
       llmq_devnet_dip0024, devnet-only)

  -llmqmnhf=<quorum name>
       Override the default LLMQ type used for EHF. (default: llmq_devnet,
       devnet-only)

  -llmqplatform=<quorum name>
       Override the default LLMQ type used for Platform. (default:
       llmq_devnet_platform, devnet-only)

  -minimumdifficultyblocks=<n>
       The number of blocks that can be mined with the minimum difficulty at
       the start of a chain (default: 0, devnet-only)

  -powtargetspacing=<n>
       Override the default PowTargetSpacing value in seconds (default: 2.5
       minutes, devnet-only)
```

The quorum names used in these options are:

| LLMQ Type | LLMQ Name             |
| :-------: | --------------------- |
|     1     | llmq50_60             |
|     2     | llmq400_60            |
|     3     | llmq400_85            |
|     4     | llmq100_67            |
|     5     | llmq60_75             |
|     6     | llmq25_67             |
|    100    | llmq_test             |
|    101    | llmq_devnet           |
|    102    | llmq_test_v17         |
|    103    | llmq_test_dip0024     |
|    104    | llqm_test_instantsend |
|    105    | llmq_devnet_dip0024   |
|    106    | llmq_test_platform    |
|    107    | llmq_devnet_platform  |

Refer to [this table in DIP-6 - LLMQs](https://github.com/dashpay/dips/blob/master/dip-0006/llmq-types.md) for details on each quorum type.

### Regtest Options

```text
  -budgetparams=<masternode>:<budget>:<superblock>
       Override masternode, budget and superblock start heights (regtest-only)

  -llmqtestinstantsenddip0024=<quorum name>
       Override the default LLMQ type used for InstantSendDIP0024. Used mainly
       to test Platform. (default: llmq_test_dip0024, regtest-only)

  -llmqtestinstantsendparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_TEST_INSTANTSEND quorums
       (default: 3:2, regtest-only)

  -llmqtestparams=<size>:<threshold>
       Override the default LLMQ size for the LLMQ_TEST quorum (default: 3:2,
       regtest-only)

  -vbparams=<deployment>:<start>:<end>(:<window>:<threshold/thresholdstart>(:<thresholdmin>:<falloffcoeff>:<mnactivation>))
       Use given start/end times for specified version bits deployment
       (regtest-only). Specifying window, threshold/thresholdstart,
       thresholdmin, falloffcoeff and mnactivation is optional.
```
