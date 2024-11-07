```{eval-rst}
.. meta::
  :title: Generating RPCs
  :description: A list of all mining-related remote procedure calls in Dash Core.
```

# Generating RPCs

## GenerateBlock

:::{attention}
This RPC is not available in the official Windows/Mac binaries. The Linux binary and binaries self-compiled (with the appropriate options) support this feature.
:::

*Added in Dash Core 18.1.0*

The [`generateblock` RPC](../api/remote-procedure-calls-generating.md#generateblock) mines a block with a set of ordered transactions immediately to a specified address or [descriptor](https://github.com/dashpay/dash/blob/master/doc/descriptors.md) (before the RPC call returns).

*Parameter #1---an address or descriptor*

Name | Type | Presence | Description
--- | --- | --- | ---
Address/Descriptor | string | Required<br>(exactly 1) | The address or [descriptor](https://github.com/dashpay/dash/blob/master/doc/descriptors.md) that will receive the newly generated Dash.

*Parameter #2---transaction(s)*

Name | Type | Presence | Description
--- | --- | --- | ---
Transactions | array | Required<br>(exactly 1) | An array of hex strings which are either txids or raw transactions. TXIDs must reference transactions currently in the mempool. All transactions must be valid and in valid order, otherwise the block will be rejected. Array can be empty.
→<br>Raw Transaction / TXID | string | Optional<br>(0 or more) | A raw transaction or transaction ID.

*Result---the generated block hash*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | object | Required<br>(exactly 1) | A JSON object containing the block header hash of the generated block
→<br>`hash` | string (hex) | Required<br>(exactly 1) | The hash of the header of the block generated, as hex in RPC byte order

*Example from Dash Core 18.1.0*

```bash
dash-cli  generateblock "yacJKd6tRz2JSn8Wfp9GKgCbuowAEBivrA" '[]'
```

Result:

```json
{
  "hash": "000000e219a3d47463fdfed6da30c999f02d7add2defb2f375549b357d3840af"
}
```

*See also*

* [GenerateToAddress](#generatetoaddress): mines blocks to a specified address.
* [GenerateToDescriptor](#generatetodescriptor): mines blocks to a specified descriptor.
* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.

## GenerateToAddress

:::{attention}
This RPC is not available in the official Windows/Mac binaries. The Linux binary and binaries self-compiled (with the appropriate options) continue to support this feature. See [PR #2778](https://github.com/dashpay/dash/pull/2778) for additional details.
:::

*Added in Dash Core 0.12.3 / Bitcoin Core 0.13.0*

The [`generatetoaddress` RPC](../api/remote-procedure-calls-generating.md#generatetoaddress) mines blocks immediately to a specified address.

*Parameter #1---the number of blocks to generate*

Name | Type | Presence | Description
--- | --- | --- | ---
Blocks | number (int) | Required<br>(exactly 1) | The number of blocks to generate.  The RPC call will not return until all blocks have been generated or the maximum number of iterations has been reached

*Parameter #2---a transaction identifier (TXID)*

Name | Type | Presence | Description
--- | --- | --- | ---
Address | string (base58) | Required<br>(exactly 1) | The address that will receive the newly generated Dash

*Parameter #3---the maximum number of iterations to try*

Name | Type | Presence | Description
--- | --- | --- | ---
Maxtries | number (int) | Optional<br>(0 or 1) | The maximum number of iterations that are tried to create the requested number of blocks.  Default is `1000000`

*Result---the generated block header hashes*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array containing the block header hashes of the generated blocks (may be empty if used with `generate 0`)
→<br>Header Hashes | string (hex) | Required<br>(1 or more) | The hashes of the headers of the blocks generated, as hex in RPC byte order

*Example from Dash Core 0.12.3*

Using regtest mode, generate 2 blocks with maximal 500000 iterations:

```bash
dash-cli -regtest generatetoaddress 2 "yaQzdWrDVYGncLKSKG4bHQ\
ML9UdAe726QN" 500000
```

Result:

```json
[
  "34726c518d1688a9c56b3399e892089d3a639b43de194517c07da2b168a3a89c",
  "1f030abe2bb323b8895542e3a85ed8386bd92c67af9d19fe9c163a4c5f5ef149"
]
```

*See also*

* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.
* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software.

## GenerateToDescriptor

:::{attention}
This RPC is not available in the official Windows/Mac binaries. The Linux binary and binaries self-compiled (with the appropriate options) support this feature.
:::

*Added in Dash Core 18.1.0*

The [`generatetodescriptor` RPC](#generatetodescriptor) mines blocks immediately to a specified [descriptor](https://github.com/dashpay/dash/blob/master/doc/descriptors.md).

*Parameter #1---the number of blocks to generate*

Name | Type | Presence | Description
--- | --- | --- | ---
Blocks | number (int) | Required<br>(exactly 1) | The number of blocks to generate.  The RPC call will not return until all blocks have been generated or the maximum number of iterations has been reached

*Parameter #2---a descriptor*

Name | Type | Presence | Description
--- | --- | --- | ---
Descriptor | string | Required<br>(exactly 1) | The [descriptor](https://github.com/dashpay/dash/blob/master/doc/descriptors.md) that will receive the newly generated Dash

*Parameter #3---the maximum number of iterations to try*

Name | Type | Presence | Description
--- | --- | --- | ---
Maxtries | number (int) | Optional<br>(0 or 1) | The maximum number of iterations that are tried to create the requested number of blocks.  Default is `1000000`

*Result---the generated block header hashes*

Name | Type | Presence | Description
--- | --- | --- | ---
`result` | array | Required<br>(exactly 1) | An array containing the block header hashes of the generated blocks (may be empty if used with `generate 0`)
→<br>Header Hashes | string (hex) | Required<br>(1 or more) | The hashes of the headers of the blocks generated, as hex in RPC byte order

*Example from Dash Core 18.1.0*

Generate 1 block with maximal 500000 iterations:

```bash
dash-cli -regtest generatetodescriptor 1 "pkh([d34db33f/84h/0h/0h]0279be667ef9dcbbac55a06295Ce870b07029Bfcdb2dce28d959f2815b16f81798)" 500000
```

Result:

```json
[
  "0000007c599cc625ff4196ca55d73b6584ba89ccdd9836f969bf67b26b4a6376"
]
```

*See also*

* [GenerateBlock](#generateblock): mines a block with a set of ordered transactions immediately to a specified address or descriptor.
* [GenerateToAddress](#generatetoaddress): mines blocks immediately to a specified address.
* [GetMiningInfo](../api/remote-procedure-calls-mining.md#getmininginfo): returns various mining-related information.
* [GetBlockTemplate](../api/remote-procedure-calls-mining.md#getblocktemplate): gets a block template or proposal for use with mining software.
