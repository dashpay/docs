```{eval-rst}
.. meta::
  :title: Dash Core Constants and Defaults
  :description: Details Dash network constants and defaults, including port configuration and start strings for Dash network messages.
```

# Constants and Defaults

The following constants and defaults are taken from Dash Core's [chainparams.cpp](https://github.com/dashpay/dash/blob/master/src/chainparams.cpp) source code file.

| Network | Default Port | Magic Value | [Start String](../resources/glossary.md#start-string) | Max nBits
|---------|--------------|-----------------------------------------------|---------------|-|
| Mainnet | 9999         | 0xBD6B0CBF  | 0xBF0C6BBD                      | 0x1e0ffff0
| Testnet | 19999        | 0xFFCAE2CE  | 0xCEE2CAFF                      | 0x1e0ffff0
| Regtest | 19899        | 0xDCB7C1FC  | 0xFCC1B7DC                      | 0x207fffff
| Devnet  | User-defined (default 19799) | 0xCEFFCAE2  | 0xE2CAFFCE                      | 0x207fffff

Note: the testnet start string and nBits above are for testnet3.

Command line parameters can change what port a [node](../resources/glossary.md#node) listens on (see `-help`). Start strings are hardcoded constants that appear at the start of all messages sent on the Dash [network](../resources/glossary.md#network); they may also appear in data files such as Dash Core's block database. The Magic Value and [nBits](../resources/glossary.md#nbits) displayed above are in big-endian order; they're sent over the network in little-endian order. The [Start String](../resources/glossary.md#start-string) is simply the endian reversed Magic Value.

Dash Core's [chainparams.cpp](https://github.com/dashpay/dash/blob/master/src/chainparams.cpp) also includes other constants useful to programs, such as the hash of the [genesis block](../resources/glossary.md#genesis-block) blocks for the different networks.
