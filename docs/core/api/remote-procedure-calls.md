```{eval-rst}
.. _api-rpc:
.. meta::
  :title: Remote Procedure Calls (RPCs)
  :description: Dash Core provides an RPC interface for administrative tasks, wallet operations, and network/blockchain queries, with client libraries available in multiple languages and a built-in dash-cli program for command-line and RPC interaction. 
```

# Remote Procedure Calls (RPCs)

## Overview

Dash Core provides a remote procedure call (RPC) interface for various administrative tasks, [wallet](../resources/glossary.md#wallet) operations, and queries about [network](../resources/glossary.md#network) and [block chain](../resources/glossary.md#block-chain) data.

Open-source client libraries for the RPC interface are readily available in most modern programming languages, so you probably don't need to write your own from scratch. Dash Core also ships with its own compiled C++ RPC client, `dash-cli`, located in the `bin` directory alongside `dashd` and `dash-qt`. The `dash-cli` program can be used as a command-line interface (CLI) to Dash Core or for making RPC calls from applications written in languages lacking a suitable native client. The remainder of this section describes the Dash Core RPC protocol in detail.

:::{note}
The following subsections reference setting configuration values. See the [Examples Page](../examples/introduction.md) for more information about setting Dash Core configuration values.
:::

### Enabling RPC

If you start Dash Core using `dash-qt`, the RPC interface is disabled by default. To enable it, set `server=1` in `dash.conf` or supply the `-server` argument when invoking the program. If you start Dash Core using `dashd`, the RPC interface is enabled by default.

### Basic Security

The interface requires the user to provide a password for authenticating RPC requests. This password can be set either using the `rpcpassword` property in `dash.conf` or by supplying the `-rpcpassword` program argument. Optionally a username can be set using the `rpcuser` configuration value.

### RPC-Auth Security

Alternatively, the authentication details can be provided using the `rpcauth` property. This removes the need to include a plaintext password in the dash.conf file by instead including a salt and hash of the password along with a username in the format:
`<USERNAME>:<SALT>$<HASH>`

``` shell
# Example dash.conf rpcauth entry
rpcauth=myuser:933fff1aaefa1fc5b3e981fd3ceacf03$f799757c0d36be8f1faa1dd3a01562b17ada82f2ff6c968c959103afda9e7c6f
```

:::{note}
The `rpcauth` option can be specified multiple times if multiple users are required.
:::

A canonical python script is included in Dash Core's repository under [share/rpcuser](https://github.com/dashpay/dash/tree/master/share/rpcauth) to generate the information required for the dash.conf file as well as the password required by clients using the rpcauth name.

``` text
String to be appended to dash.conf:
rpcauth=myuser:b87393f6957f80448f8a0aba5eb8cc00$f67a3321106b13acc2a8881c9eb64e7bbc6eeb4681261b2918cc54da8915be6e
Your password:
2-Cl0O92-MT-XavyEIkkV_hxqdC_7fag8w7EF7t3UVg=
```

### RPC Whitelist

The RPC whitelist system can limit certain RPC users to only have access to some RPC calls. The system is configured by specifying the following two parameters in the `dash.conf` file or by setting them as program arguments on the command line:

* `rpcwhitelist`: set a whitelist to filter incoming RPC calls for a specific user. The field <whitelist> comes in the format: `<USERNAME>:<rpc 1>,<rpc 2>,...,<rpc n>`. If multiple whitelists are set for a given user, they are set-intersected. Default whitelist behavior is defined by `rpcwhitelistdefault`.
* `rpcwhitelistdefault`: sets default behavior for RPC whitelisting. Unless `rpcwhitelistdefault` is set to `0`, if any `rpcwhitelist` is set, the RPC server acts as if all RPC users are subject to empty-unless-otherwise-specified whitelists. If `rpcwhitelistdefault` is set to `1` and no `rpcwhitelist` is set, the RPC server acts as if all RPC users are subject to empty whitelists.

Example configuration

```text
rpcauth=user1:4cc74397d6e9972e5ee7671fd241$11849357f26a5be7809c68a032bc2b16ab5dcf6348ef3ed1cf30dae47b8bcc71
rpcauth=user2:181b4a25317bff60f3749adee7d6bca0$d9c331474f1322975fa170a2ffbcb176ba11644211746b27c1d317f265dd4ada
rpcauth=user3:a6c8a511b53b1edcf69c36984985e$13cfba0e626db19061c9d61fa58e712d0319c11db97ad845fa84517f454f6675
rpcwhitelist=user1:getnetworkinfo
rpcwhitelist=user2:getnetworkinfo,getwalletinfo, getbestblockhash

# Allow users to access any RPC unless they are listed in an `rpcwhitelist` entry
rpcwhitelistdefault=0
```

In this example, user1 can only call `getnetworkinfo`, user2 can only call `getnetworkinfo` or `getwalletinfo`, while user3 can still call all RPCs.

### Restricted Access Users

:::{note}
This feature is only available on masternodes
:::

As of Dash Core 0.17.0, an option is provided to add an RPC user that is restricted to a small subset of RPCs that will be used by Dash Platform. The `platform-user` configuration value sets the name of the RPC user to be restricted.

The `platform-user` configuration value must be set to a previously configured [rpcauth user](#rpc-auth-security).

Only the following RPCs are accessible to the restricted user:

* [`getbestblockhash`](../api/remote-procedure-calls-blockchain.md#getbestblockhash)
* [`getblockhash`](../api/remote-procedure-calls-blockchain.md#getblockhash)
* [`getblockcount`](../api/remote-procedure-calls-blockchain.md#getblockcount)
* [`getbestchainlock`](../api/remote-procedure-calls-blockchain.md#getbestchainlock)
* [`quorum sign 4`](../api/remote-procedure-calls-evo.md#quorum-sign) - The restricted user can only request quorum signatures from the Platform quorum (LLMQ type 4)
* [`quorum verify`](../api/remote-procedure-calls-evo.md#quorum-verify)
* [`verifyislock`](../api/remote-procedure-calls-evo.md#verifyislock)

### Default Connection Info

The Dash Core RPC service listens for HTTP `POST` requests on port 9998 in [mainnet](../resources/glossary.md#mainnet) mode, 19998 in [testnet](../resources/glossary.md#testnet), or 19898 in [regression test mode](../resources/glossary.md#regression-test-mode). The port number can be changed by setting `rpcport` in `dash.conf`. By default the RPC service binds to your server's [localhost](https://en.wikipedia.org/wiki/Localhost) loopback network interface so it's not accessible from other servers. Authentication is implemented using [HTTP basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication). RPC HTTP requests must include a `Content-Type` header set to `text/plain` and a `Content-Length` header set to the size of the request body.

## Data Formats

The format of the request body and response data is based on [version 1.0 of the JSON-RPC specification](http://json-rpc.org/wiki/specification).

### Request Format

Specifically, the HTTP `POST` data of a request must be a JSON object with the following format:

| Name                 | Type            | Presence                    | Description
|----------------------|-----------------|-----------------------------|----------------
| Request              | object          | Required<br>(exactly 1)     | The JSON-RPC request object
| → <br>`jsonrpc`      | number (real)   | Optional<br>(0 or 1)        | Version indicator for the JSON-RPC request. Currently ignored by Dash Core.
| → <br>`id`           | string          | Optional<br>(0 or 1)        | An arbitrary string that will be returned with the response.  May be omitted or set to an empty string ("")
| → <br>`method`       | string          | Required<br>(exactly 1)     | The RPC method name (e.g. `getblock`).  See the RPC section for a list of available methods.
| → <br>`params`       | array           | Optional<br>(0 or 1)        | An array containing positional parameter values for the RPC.  May be an empty array or omitted for RPC calls that don't have any required parameters.
| → <br>`params`       | object           | Optional<br>(0 or 1)        | Starting from Dash Core 0.12.3 / Bitcoin Core 0.14.0 (replaces the params array above) An object containing named parameter values for the RPC. May be an empty object or omitted for RPC calls that don’t have any required parameters.
| → → <br>Parameter    | *any*           | Optional<br>(0 or more)       | A parameter.  May be any JSON type allowed by the particular RPC method

In the table above and in other tables describing RPC input and output, we use the following conventions

* "→" indicates an argument that is the child of a JSON array or JSON object. For example, "→ → Parameter" above means Parameter is the child of the `params` array which itself is a child of the Request object.

* Plain-text names like "Request" are unnamed in the actual JSON object

* Code-style names like `params` are literal strings that appear in the JSON object.

* "Type" is the JSON data type and the specific Dash Core type.

* "Presence" indicates whether or not a field must be present within its containing array or object. Note that an optional object may still have required children.

### Response Format

The HTTP response data for a RPC request is a JSON object with the following format:

| Name                 | Type            | Presence                    | Description
|----------------------|-----------------|-----------------------------|----------------
| Response             | object          | Required<br>(exactly 1)     | The JSON-RPC response object.
| → <br>`result`       | *any*           | Required<br>(exactly 1)     | The RPC output whose type varies by call.  Has value `null` if an error occurred.
| → <br>`error`        | null/object     | Required<br>(exactly 1)     | An object describing the error if one occurred, otherwise `null`.
| → → <br>`code`        | number (int)    | Required<br>(exactly 1)     | The error code returned by the RPC function call. See [rpcprotocol.h](https://github.com/dashpay/dash/blob/v0.15.x/src/rpc/protocol.h) for a full list of error codes and their meanings.
| → → <br>`message`     | string          | Required<br>(exactly 1)     | A text description of the error.  May be an empty string ("").
| → <br>`id`           | string          | Required<br>(exactly 1)     | The value of `id` provided with the request. Has value `null` if the `id` field was omitted in the request.

## Example

As an example, here is the JSON-RPC request object for the hash of the [genesis block](../resources/glossary.md#genesis-block):

```json
{
    "method": "getblockhash",
    "params": [0],
    "id": "foo"
}
```

The command to send this request using `dash-cli` is:

```shell Shell
dash-cli getblockhash 0
```

The command to send this request using `dash-cli` with named parameters is:

```shell Shell
dash-cli -named getblockhash height=0
```

Alternatively, we could `POST` this request using the cURL command-line program as follows:

```shell Shell
curl --user 'my_username:my_secret_password' --data-binary '''
  {
      "method": "getblockhash",
      "params": [0],
      "id": "foo"
  }''' \
  --header 'Content-Type: text/plain;' localhost:9998
```

The HTTP response data for this request would be:

```json
{
    "result": "00000bafbc94add76cb75e2ec92894837288a481e5c005f6563d91623bf8bc2c",
    "error": null,
    "id": "foo"
}
```

:::{note}
To minimize its size, the raw JSON response from Dash Core does not include any extraneous whitespace characters.
:::

Here whitespace has been added to make the object more readable. `dash-cli` also transforms the raw response to make it more human-readable. It:

* Adds whitespace indentation to JSON objects
* Expands escaped newline characters ("\n") into actual newlines
* Returns only the value of the `result` field if there's no error
* Strips the outer double-quotes around `result`s of type string
* Returns only the `error` field if there's an error

Continuing with the example above, the output from the `dash-cli` command would be simply:

```text
00000bafbc94add76cb75e2ec92894837288a481e5c005f6563d91623bf8bc2c
```

```{eval-rst}
.. _api-rpc-multi-wallet-support:
```

### Multi-wallet Support

Since Dash Core 18.0 introduced the ability to have multiple wallets loaded at
the same time, wallet-related RPCs require providing the wallet name when more
than one wallet file is loaded. This is to ensure the RPC command is executed
using the correct wallet.

**Dash-cli Example**

Use the dash-cli `-rpcwallet` option to specify the path of the wallet file to
access, for example:

```shell
dash-cli -rpcwallet=<wallet-filename> <command>
```

To use the default wallet, use `""` for the wallet filename as shown in the
example below:

```shell
dash-cli -rpcwallet="" getwalletinfo
```

**JSON-RPC Example**

Specify which wallet file to access by setting the HTTP endpoint in the JSON-RPC
request using the format `<RPC IP address>:<RPC port>/wallet/<wallet name>`, for
example:

```shell
curl --user 'my_username:my_secret_password' --data-binary '''
  {
    "method": "getwalletinfo",
    "params": [],
    "id":"foo"
  }'''\
  --header 'content-type: text/plain;' localhost:19998/wallet/testnet-wallet
```

Access the default wallet using the format `<RPC IP address>:<RPC port>/wallet/`
(the final "`/`" must be included):

```shell
curl --user 'my_username:my_secret_password' --data-binary '''
  {
    "method": "getwalletinfo",
    "params": [],
    "id":"foo"
  }'''\
  --header 'content-type: text/plain;' localhost:19998/wallet/
```

### RPCs with sub-commands

Dash Core has a number of RPC requests that use sub-commands to group access to related data under one RPC method name. Examples of this include the [`gobject`](../api/remote-procedure-calls-dash.md#gobject), [`masternode`](../api/remote-procedure-calls-dash.md#masternode), [`protx`](../api/remote-procedure-calls-evo.md#protx), and [`quorum`](../api/remote-procedure-calls-evo.md#quorum) RPCs. If using cURL, the sub-commands should be included in the requests `params` field as shown here:

```shell
curl --user 'my_username:my_secret_password' --data-binary '''
  {
      "method": "gobject",
      "params": ["list", "valid", "proposals"],
      "id": "foo"
  }''' \
  --header 'Content-Type: text/plain;' localhost:9998
```

### Error Handling

If there's an error processing a request, Dash Core sets the `result` field to `null` and provides information about the error in the  `error` field. For example, a request for the block hash at block height -1 would be met with the following response (again, whitespace added for clarity):

```json
{
    "result": null,
    "error": {
        "code": -8,
        "message": "Block height out of range"
    },
    "id": "foo"
}
```

If `dash-cli` encounters an error, it exits with a non-zero status code and outputs the `error` field as text to the process's standard error stream:

```text
error code: -8
error message:
Block height out of range
```

### Batch Requests

The RPC interface supports request batching as described in [version 2.0 of the JSON-RPC specification](http://www.jsonrpc.org/specification#batch). To initiate multiple RPC requests within a single HTTP request, a client can `POST` a JSON array filled with Request objects. The HTTP response data is then a JSON array filled with the corresponding Response objects. Depending on your usage pattern, request batching may provide significant performance gains. The `dash-cli` RPC client does not support batch requests.

```shell
curl --user 'my_username:my_secret_password' --data-binary '''
  [
    {
      "method": "getblockhash",
      "params": [0],
      "id": "foo"
    },
    {
      "method": "getblockhash",
      "params": [1],
      "id": "foo2"
    }
  ]''' \
  --header 'Content-Type: text/plain;' localhost:9998
```

To keep this documentation compact and readable, the examples for each of the available RPC calls will be given as `dash-cli` commands:

```shell
dash-cli [options] <method name> <param1> <param2> ...
```

This translates into an JSON-RPC Request object of the form:

```json
{
    "method": "<method name>",
    "params": [ "<param1>", "<param2>", "..." ],
    "id": "foo"
}
```

:::{warning}
If you write programs using the JSON-RPC interface, you must ensure they handle high-precision real numbers correctly.  See the [Proper Money Handling](https://en.bitcoin.it/wiki/Proper_Money_Handling_%28JSON-RPC%29) Bitcoin Wiki article for details and example code.
:::

```{toctree}
:maxdepth: 3
:titlesonly:

remote-procedure-call-quick-reference
remote-procedure-calls-address-index
remote-procedure-calls-blockchain
remote-procedure-calls-control
remote-procedure-calls-dash
remote-procedure-calls-evo
remote-procedure-calls-generating
remote-procedure-calls-mining
remote-procedure-calls-network
remote-procedure-calls-raw-transactions
remote-procedure-calls-util
remote-procedure-calls-wallet
remote-procedure-calls-wallet-deprecated
remote-procedure-calls-removed
remote-procedure-calls-zmq
```
