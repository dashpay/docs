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
