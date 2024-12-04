```{eval-rst}
.. meta::
  :title: Control RPCs
  :description: A list of all the Control RPCs in Dash.
```

# Control RPCs

## Debug

The [`debug` RPC](../api/remote-procedure-calls-control.md#debug) changes the debug category from the console.

*Parameter #1---debug category*

Name | Type | Presence | Description
--- | --- | --- | ---
Debug category | string | Required<br>(1 or more) | The debug category to activate. Use a `+` to specify multiple categories. Categories are shown in the [table below](#debug-logging-categories).<br><br>Note: No error will be thrown even if the specified category doesn't match any of the above

### Debug logging categories

| Type | Category |
| - | - |
| Special | • `0` or `none` - Disables all categories <br>• `1` or `all` - Enables all categories <br>• `dash` - Enables/disables all Dash categories |
| Standard | `addrman`, `bench`, `cmpctblock`, `coindb`, `estimatefee`, `http`, `i2p`, `ipc`, `leveldb`, `libevent`, `lock`, `mempool`, `mempoolrej`, `net`, `netconn`, `proxy`, `prune`, `qt`, `rand`, `reindex`, `rpc`, `selectcoins`, `tor`, `validation`, `walletdb`, `zmq`|
| Dash | `chainlocks`, `coinjoin`, `creditpool`, `ehf`, `gobject`, `instantsend`, `llmq`, `llmq-dkg`, `llmq-sigs`, `mnpayments`, `mnsync`, `spork` |

Note: `libevent` logging is configured on startup and cannot be modified by this RPC during runtime.

*Example from Dash Core 20.0.1*

```bash
dash-cli -testnet debug "net+mempool"
```

Result:

```text
Debug mode: net+mempool
```

*See also*

* [Logging](../api/remote-procedure-calls-control.md#logging): gets and sets the logging configuration

## GetMemoryInfo

*Added in Dash Core 0.12.3 / Bitcoin Core 0.14.0*

The [`getmemoryinfo` RPC](../api/remote-procedure-calls-control.md#getmemoryinfo) returns information about memory usage.

*Parameter #1---mode*

Name | Type | Presence | Description
--- | --- | --- | ---
mode| string | Optional<br>Default: `stats` | *Added in Dash Core 0.15.0*<br><br>Determines what kind of information is returned.<br>- `stats` returns general statistics about memory usage in the daemon.<br>- `mallocinfo` returns an XML string describing low-level heap state (only available if compiled with glibc 2.10+).

*Result---information about memory usage*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | An object containing information about memory usage
→<br>`locked` | string : object | Required<br>(exactly 1) | An object containing information about locked memory manager
→→<br>`used` | number (int) | Required<br>(exactly 1) | Number of bytes used
→→<br>`free` | number (int) | Required<br>(exactly 1) | Number of bytes available in current arenas
→→<br>`total` | number (int) | Required<br>(exactly 1) | Total number of bytes managed
→→<br>`locked` | number (int) | Required<br>(exactly 1) | Amount of bytes that succeeded locking
→→<br>`chunks_used` | number (int) | Required<br>(exactly 1) | Number allocated chunks
→→<br>`chunks_free` | number (int) | Required<br>(exactly 1) | Number unused chunks

*Example from Dash Core 0.12.3*

```bash
dash-cli getmemoryinfo
```

Result:

```json
{
  "locked": {
    "used": 1146240,
    "free": 426624,
    "total": 1572864,
    "locked": 1572864,
    "chunks_used": 16368,
    "chunks_free": 7
  }
}
```

*See also*

* [GetMemPoolInfo](../api/remote-procedure-calls-blockchain.md#getmempoolinfo): returns information about the node's current transaction memory pool.

## GetRPCInfo

*Added in Dash Core 18.0.0*

The [`getrpcinfo` RPC](#getrpcinfo) returns details about the RPC server.

*Parameters: none*

*Result---information about the RPC server*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | An object containing information about the RPC server
→<br>`active_commands` | array of objects | Required<br>(exactly 1) | An object containing information about active RPC commands
→→<br>Active command | object | Optional<br>(0 or more) | Information about a currently active command
→→→<br>`method` | number (int) | Required<br>(exactly 1) | Name of the command
→→→<br>`duration` | number (int) | Required<br>(exactly 1) | Number of microseconds the command has been active

*Example from Dash Core 18.0.0*

```bash
dash-cli getrpcinfo
```

Result:

```json
{
  "active_commands": [
    {
      "method": "generate",
      "duration": 5226138
    },
    {
      "method": "getrpcinfo",
      "duration": 5
    }
  ]
}

```

*See also: none*

## Help

The [`help` RPC](../api/remote-procedure-calls-control.md#help) lists all available public RPC commands, or gets help for the specified RPC.  Commands which are unavailable will not be listed, such as wallet RPCs if wallet support is disabled.

*Parameter #1---the name of the RPC to get help for*

Name | Type | Presence | Description
--- | --- | --- | ---
RPC | string | Optional<br>(0 or 1) | The name of the RPC to get help for.  If omitted, Dash Core 0.10x will display an alphabetical list of commands; Dash Core 0.11.0 will display a categorized list of commands

*Parameter #2---the name of the subcommand to get help for*

Name | Type | Presence | Description
--- | --- | --- | ---
Sub-command | string | Optional<br>(0 or 1) | The subcommand to get help on. Please note that not all subcommands support this at the moment

*Result---a list of RPCs or detailed help for a specific RPC*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string | Required<br>(exactly 1) | The help text for the specified RPC or the list of commands.  The `dash-cli` command will parse this text and format it as human-readable text

*Example from Dash Core 0.17.0*

Command to get help about the [`help` RPC](../api/remote-procedure-calls-control.md#help):

```bash
dash-cli -testnet help help
```

Result:

```text
help ( "command" "subcommand" )

List all commands, or get help for a specified command.

Arguments:
1. "command"     (string, optional) The command to get help on
2. "subcommand"  (string, optional) The subcommand to get help on. Please note that not all subcommands support this at the moment

Result:
"text"     (string) The help text
```

*See also*

* The [RPC Quick Reference](../api/remote-procedure-call-quick-reference.md)

## Logging

The [`logging` RPC](../api/remote-procedure-calls-control.md#logging) gets and sets the logging configuration. When called without an argument, returns the list of categories with status that are currently being debug logged or not. When called with arguments, adds or removes categories from debug logging and return the lists above. The arguments are evaluated in order "include", "exclude". If an item is both included and excluded, it will thus end up being excluded.

*Parameter #1---include categories*

Name | Type | Presence | Description
--- | --- | --- | ---
`include` | array of strings | Optional<br>(0 or 1) | Enable debugging for these categories

*Parameter #2---exclude categories*

Name | Type | Presence | Description
--- | --- | --- | ---
`exclude` | array of strings | Optional<br>(0 or 1) | Enable debugging for these categories

The categories are:

| Type | Category |
| - | - |
| Special | • `0` or `none` - Disables all categories <br>• `1` or `all` - Enables all categories <br>• `dash` - Enables/disables all Dash categories |
| Standard | `addrman`, `bench`, `cmpctblock`, `coindb`, `estimatefee`, `http`, `i2p`, `ipc`, `leveldb`, `libevent`, `lock`, `mempool`, `mempoolrej`, `net`, `netconn`, `proxy`, `prune`, `qt`, `rand`, `reindex`, `rpc`, `selectcoins`, `tor`, `validation`, `walletdb`, `zmq`|
| Dash | `chainlocks`, `coinjoin`, `creditpool`, `ehf`, `gobject`, `instantsend`, `llmq`, `llmq-dkg`, `llmq-sigs`, `mnpayments`, `mnsync`, `spork` |

*Result---a list of the logging categories that are active*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A JSON object show a list of the logging categories that are active

*Example from Dash Core 21.1.0*

Include a category in logging

```bash
dash-cli -testnet logging '["llmq", "chainlocks"]'
```

Result:

```json
{
  "addrman": false,
  "bench": false,
  "chainlocks": true,
  "cmpctblock": false,
  "coindb": false,
  "coinjoin": false,
  "creditpool": false,
  "ehf": false,
  "estimatefee": false,
  "gobject": false,
  "http": false,
  "i2p": false,
  "instantsend": false,
  "leveldb": false,
  "libevent": false,
  "llmq": true,
  "llmq-dkg": false,
  "llmq-sigs": false,
  "lock": false,
  "mempool": false,
  "mempoolrej": false,
  "mnpayments": false,
  "mnsync": false,
  "net": false,
  "netconn": false,
  "proxy": false,
  "prune": false,
  "qt": false,
  "rand": false,
  "reindex": false,
  "rpc": false,
  "selectcoins": false,
  "spork": false,
  "tor": false,
  "validation": false,
  "walletdb": false,
  "zmq": false
}
```

Excluding a previously included category (without including any new ones):

```bash
dash-cli -testnet logging '[]' '["chainlocks"]'
```

Result:

```json
{
  "addrman": false,
  "bench": false,
  "chainlocks": false,
  "cmpctblock": false,
  "coindb": false,
  "coinjoin": false,
  "creditpool": false,
  "ehf": false,
  "estimatefee": false,
  "gobject": false,
  "http": false,
  "i2p": false,
  "instantsend": false,
  "leveldb": false,
  "libevent": false,
  "llmq": true,
  "llmq-dkg": false,
  "llmq-sigs": false,
  "lock": false,
  "mempool": false,
  "mempoolrej": false,
  "mnpayments": false,
  "mnsync": false,
  "net": false,
  "netconn": false,
  "proxy": false,
  "prune": false,
  "qt": false,
  "rand": false,
  "reindex": false,
  "rpc": false,
  "selectcoins": false,
  "spork": false,
  "tor": false,
  "validation": false,
  "walletdb": false,
  "zmq": false
}
```

*See also*

* [Debug](../api/remote-procedure-calls-control.md#debug): changes the debug category from the console.

## Stop

The [`stop` RPC](../api/remote-procedure-calls-control.md#stop) safely shuts down the Dash Core server.

*Parameters: none*

*Result---the server is safely shut down*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | string | Required<br>(exactly 1) | The string \Dash Core server stopping\""

*Example from Dash Core 0.12.2*

```bash
dash-cli -testnet stop
```

Result:

```text
Dash Core server stopping
```

*See also: none*

## Uptime

The [`uptime` RPC](../api/remote-procedure-calls-control.md#uptime) returns the total uptime of the server.

*Parameters: none*

*Result*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | number (int) | Required<br>(exactly 1) | The number of seconds that the server has been running

*Example from Dash Core 0.15.0*

```bash
dash-cli -testnet uptime
```

Result:

```text
5500
```

*See also: none*
