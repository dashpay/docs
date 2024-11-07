```{eval-rst}
.. meta::
  :title: Masternode Messages
  :description: The following network messages enable the masternode features built in to Dash.
```

# Masternode Messages

The following network messages enable the [masternode](../resources/glossary.md#masternode) features built in to Dash.

![Overview Of P2P Protocol Masternode Request And Reply Messages](../../img/dev/en-p2p-masternode-messages.svg)

For additional details, refer to the Developer Guide [Masternode Sync](../guide/dash-features-masternode-sync.md) and [Masternode Payment](../guide/dash-features-masternode-payment.md) sections.

## ssc

The [`ssc` message](../reference/p2p-network-masternode-messages.md#ssc) is used to track the sync status of masternode objects. This message is sent in response to sync requests for the list of governance objects (`govsync` message), and governance object votes (`govsync` message).

| Bytes | Name | Data type | Required | Description |
| ---------- | ----------- | --------- | -------- | -------- |
| 4 | nItemID | int | Required | Masternode Sync Item ID
| 4 | nCount | int | Required | Number of items to sync

Sync Item IDs

| ID | Description | Response To
|------|--------------|---------------
| 10 | MASTERNODE_SYNC_GOVOBJ | [`govsync` message](../reference/p2p-network-governance-messages.md#govsync)
| 11 | MASTERNODE_SYNC_GOVOBJ_VOTE | [`govsync` message](../reference/p2p-network-governance-messages.md#govsync) with non-zero hash

The following annotated hexdump shows a [`ssc` message](../reference/p2p-network-masternode-messages.md#ssc). (The message header has been omitted.)

``` text
02000000 ................................... Item ID: MASTERNODE_SYNC_LIST (2)
bf110000 ................................... Count: 4543
```

## mnauth

*Added in protocol version 70214*

The [`mnauth` message](../reference/p2p-network-masternode-messages.md#mnauth) is sent by a [masternode](../resources/glossary.md#masternode) immediately after sending a [`verack` message](../reference/p2p-network-control-messages.md#verack) to authenticate that the sender is a masternode. It is only sent when the sender is actually a masternode.

The [`mnauth` message](../reference/p2p-network-masternode-messages.md#mnauth) signs a challenge that was previously sent via a [`version` message](../reference/p2p-network-control-messages.md#version). The challenge is signed differently depending on if the connection is inbound or outbound.

:::{note}
As of protocol version 70218, when communicating with masternodes that have reported a version => `MIN_MASTERNODE_PROTO_VERSION`, the mnauth signature is created by signing a message incorporating both the `mnauth_challenge` and protocol `version` (from the [`version` message](../reference/p2p-network-control-messages.md#version)). Further details may be found in [Dash Core PR 3631](https://github.com/dashpay/dash/pull/3631).
:::

This is primarily used as a DoS protection mechanism to allow persistent connections between masternodes to remain open even if inbound connection limits are reached.

| Bytes | Name | Data type | Description |
| --- | --- | --- | --- |
| 32 | proRegTxHash | uint256 | The hash of the ProRegTx that identifies the masternode
| 96 | sig | byte[] | BLS signature of the [`version` message's](../reference/p2p-network-control-messages.md#version) `mnauth_challenge`. Signed with the operator key of the masternode.<br>**Note**: serialized using the basic BLS scheme after Dash 19.0 activation

The following annotated hexdump shows a [`mnauth` message](../reference/p2p-network-masternode-messages.md#mnauth). (The message header has been omitted.)

``` text
63cd3bf06404d78f80163afeb4b13e18
7dc1c1d04997ef04f1a2ecb3166dd004 ........... ProRegTx Hash

12f2706bc75e9cb14a9ebf1d93d177d5
f266ad2eddc49ad463810cb976a3e4bb
abffc96819c5030fd5a7601af9c8ee50
0feb066b38a48af1a31b7242bd814bab
91e2a887f963904f33af851ddc9167d5
66d6d3bd6c07e99091edd8867d0dd56e ........... Masternode BLS Signature (96 bytes)
```
