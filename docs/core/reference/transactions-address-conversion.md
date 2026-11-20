```{eval-rst}
.. meta::
  :title: Address Conversion
  :description: The hashes used in P2PKH and P2SH outputs are commonly encoded as Dash addresses. This is the procedure to encode those hashes and decode the addresses.
```

# Address Conversion

The hashes used in P2PKH and [P2SH outputs](../resources/glossary.md#p2sh-output) are commonly encoded as Dash [addresses](../resources/glossary.md#address).  This is the procedure to encode those hashes and decode the addresses.

## Conversion Process

First, get your hash.  For P2PKH, you RIPEMD-160(SHA256()) hash a ECDSA [public key](../resources/glossary.md#public-key) derived from your 256-bit ECDSA [private key](../resources/glossary.md#private-key) (random data). For P2SH, you RIPEMD-160(SHA256()) hash a [redeem script](../resources/glossary.md#redeem-script) serialized in the format used in [raw transactions](../resources/glossary.md#raw-transaction) (described in a [following sub-section](../reference/transactions-raw-transaction-format.md)).  Taking the resulting hash:

1. Add an [address](../resources/glossary.md#address) version byte in front of the hash.  The version bytes commonly used by Dash are:

    * 0x4c for [P2PKH addresses](../resources/glossary.md#p2pkh-address) on the main Dash network ([mainnet](../resources/glossary.md#mainnet))

    * 0x8c for [P2PKH addresses](../resources/glossary.md#p2pkh-address) on the Dash testing network ([testnet](../resources/glossary.md#testnet))

    * 0x10 for [P2SH addresses](../resources/glossary.md#p2sh-address) on [mainnet](../resources/glossary.md#mainnet)

    * 0x13 for [P2SH addresses](../resources/glossary.md#p2sh-address) on [testnet](../resources/glossary.md#testnet)

2. Create a copy of the version and hash; then hash that twice with SHA256: `SHA256(SHA256(version . hash))`

3. Extract the first four bytes from the double-hashed copy. These are used as a checksum to ensure the base hash gets transmitted correctly.

4. Append the checksum to the version and hash, and encode it as a [base58](../resources/glossary.md#base58) string: `BASE58(version . hash . checksum)`

## Example Code

Dash's base58 encoding, called [Base58Check](../resources/glossary.md#base58check) may not match other implementations. Tier Nolan provided the following example encoding algorithm to the Bitcoin Wiki [Base58Check encoding](https://en.bitcoin.it/wiki/Base58Check_encoding) page under the [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/):

``` c
code_string = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
x = convert_bytes_to_big_integer(hash_result)

output_string = ""

while(x > 0)
   {
       (x, remainder) = divide(x, 58)
       output_string.append(code_string[remainder])
   }

repeat(number_of_leading_zero_bytes_in_hash)
   {
   output_string.append(code_string[0]);
   }

output_string.reverse();
```

Dash's own code can be traced using the [base58 header file](https://github.com/dashpay/dash/blob/master/src/base58.h).

To convert addresses back into hashes, reverse the base58 encoding, extract the checksum, repeat the steps to create the checksum and compare it against the extracted checksum, and then remove the version byte.

## Dash Platform Addresses

Dash Core also encodes and decodes Dash Platform addresses, which [DIP18](https://github.com/dashpay/dips/blob/master/dip-0018.md) defines. A Platform address uses the same P2PKH or P2SH hash, but encodes it with [bech32m](https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki) instead of Base58Check:

1. Add a type byte in front of the 20-byte hash to create a 21-byte payload. The type bytes are:

    * 0xb0 for P2PKH addresses

    * 0x80 for P2SH addresses

2. Encode the payload as a bech32m string using the human-readable part (HRP) for the network:

    * `dash` on [mainnet](../resources/glossary.md#mainnet)

    * `tdash` on [testnet](../resources/glossary.md#testnet), devnets, and [regtest](../resources/glossary.md#regression-test-mode)

Because of the type bytes, P2PKH Platform addresses start with `dash1k` (`tdash1k`) and P2SH Platform addresses start with `dash1s` (`tdash1s`). For example, the P2PKH hash `f7da0a2b5cbd4ff6bb2c4d89b67d2f3ffeec0525` encodes as `dash1krma5z3ttj75la4m93xcndna9ullamq9y5e9n5rs` on mainnet and `tdash1krma5z3ttj75la4m93xcndna9ullamq9y5fzq2j7` on testnet. Decoding rejects an address with a bech32 (not bech32m) checksum, the wrong HRP for the network, a payload that isn't 21 bytes, or an unknown type byte.

The [`validateaddress` RPC](../api/remote-procedure-calls-util.md#validateaddress) and [`getaddressinfo` RPC](../api/remote-procedure-calls-wallet.md#getaddressinfo) accept Platform addresses. The [`sendtoaddress` RPC](../api/remote-procedure-calls-wallet.md#sendtoaddress) and [`sendmany` RPC](../api/remote-procedure-calls-wallet.md#sendmany) also accept them once the `v24` hard fork activates. Paying a Platform address creates an [asset lock transaction](../reference/transactions-special-transactions.md#assetlocktx) with a version 2 payload, whose credit output pays the standard P2PKH or P2SH script for the address's hash. Version 2 asset locks are currently non-standard, so the wallet only sends to Platform addresses on a node started with `-acceptnonstdtxn=1`, which is only available on testnet, devnets and regtest.
