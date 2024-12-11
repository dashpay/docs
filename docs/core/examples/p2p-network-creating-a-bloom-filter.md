```{eval-rst}
.. meta::
  :title: Creating a Bloom Filter
  :description: Demonstrates how to create a bloom filter using Python and represent it in a filterload message.
```

# Creating a Bloom Filter

In this section, we'll use variable names that correspond to the field names in the [`filterload` message documentation](../reference/p2p-network-control-messages.md#filterload). Each code block precedes the paragraph describing it.

``` python
#!/usr/bin/env python

BYTES_MAX = 36000
FUNCS_MAX = 50

nFlags = 0
```

We start by setting some maximum values defined in [BIP37](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki): the maximum number of bytes allowed in a filter and the maximum number of hash functions used to hash each piece of data.  We also set nFlags to zero, indicating we don't want the remote node to update the filter for us. (We won't use nFlags again in the sample program, but real programs will need to use it.)

``` python
n = 1
p = 0.0001
```

We define the number (n) of elements we plan to insert into the filter and the false positive rate (p) we want to help protect our privacy. For this example, we will set *n* to one element and *p* to a rate of 1-in-10,000 to produce a small and precise filter for illustration purposes. In actual use, your filters will probably be much larger.

``` python
from math import log
nFilterBytes = int(min((-1 / log(2)**2 * n * log(p)) / 8, BYTES_MAX))
nHashFuncs = int(min(nFilterBytes * 8 / n * log(2), FUNCS_MAX))

from bitarray import bitarray  # from pypi.python.org/pypi/bitarray
vData = nFilterBytes * 8 * bitarray('0', endian="little")
```

Using the formula described in [BIP37](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki), we calculate the ideal size of the filter (in bytes) and the ideal number of hash functions to use. Both are truncated down to the nearest whole number and both are also constrained to the maximum values we defined earlier. The results of this particular fixed computation are 2 filter bytes and 11 hash functions. We then use *nFilterBytes* to create a little-endian bit array of the appropriate size.

``` python
nTweak = 0
```

We also should choose a value for *nTweak*.  In this case, we'll simply use zero.

``` python
import pyhash  # from https://github.com/flier/pyfasthash
murmur3 = pyhash.murmur3_32()

def bloom_hash(nHashNum, data):
    seed = (nHashNum * 0xfba4c795 + nTweak) & 0xffffffff
    return( murmur3(data, seed=seed) % (nFilterBytes * 8) )
```

We setup our hash function template using the formula and 0xfba4c795 constant set in [BIP37](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki). Note that we limit the size of the seed to four bytes and that we're returning the result of the hash modulo the size of the filter in bits.

``` python
data_to_hash = "019f5b01d4195ecbc9398fbf3c3b1fa9" \
               + "bb3183301d7a1fb3bd174fcfa40a2b65"
data_to_hash = data_to_hash.decode("hex")
```

For the data to add to the filter, we're adding a [TXID](../resources/glossary.md#transaction-identifiers). Note that the TXID is in [internal byte order](../resources/glossary.md#internal-byte-order).

``` python
print "                             Filter (As Bits)"
print "nHashNum   nIndex   Filter   0123456789abcdef"
print "~~~~~~~~   ~~~~~~   ~~~~~~   ~~~~~~~~~~~~~~~~"
for nHashNum in range(nHashFuncs):
    nIndex = bloom_hash(nHashNum, data_to_hash)

    ## Set the bit at nIndex to 1
    vData[nIndex] = True

    ## Debug: print current state
    print '      {0:2}      {1:2}     {2}   {3}'.format(
        nHashNum,
        hex(int(nIndex)),
        vData.tobytes().encode("hex"),
        vData.to01()
    )

print
print "Bloom filter:", vData.tobytes().encode("hex")
```

Now we use the hash function template to run a slightly different hash function for *nHashFuncs* times. The result of each function being run on the transaction is used as an index number: the bit at that index is set to 1. We can see this in the printed debugging output:

``` text
                             Filter (As Bits)
nHashNum   nIndex   Filter   0123456789abcdef
~~~~~~~~   ~~~~~~   ~~~~~~   ~~~~~~~~~~~~~~~~
       0      0x7     8000   0000000100000000
       1      0x9     8002   0000000101000000
       2      0xa     8006   0000000101100000
       3      0x2     8406   0010000101100000
       4      0xb     840e   0010000101110000
       5      0x5     a40e   0010010101110000
       6      0x0     a50e   1010010101110000
       7      0x8     a50f   1010010111110000
       8      0x5     a50f   1010010111110000
       9      0x8     a50f   1010010111110000
      10      0x4     b50f   1010110111110000

Bloom filter: b50f
```

Notice that in iterations 8 and 9, the filter did not change because the corresponding bit was already set in a previous iteration (5 and 7, respectively).  This is a normal part of [bloom filter](../resources/glossary.md#bloom-filter) operation.

We only added one element to the filter above, but we could repeat the process with additional elements and continue to add them to the same filter. (To maintain the same false-positive rate, you would need a larger filter size as computed earlier.)

Note: for a more optimized Python implementation with fewer external dependencies, see [python-bitcoinlib's](https://github.com/petertodd/python-bitcoinlib) bloom filter module which is based directly on Bitcoin Core's C++ implementation.

Using the [`filterload` message](../reference/p2p-network-control-messages.md#filterload) format, the complete filter created above would be the binary form of the annotated hexdump shown below:

``` text
02 ......... Filter bytes: 2
b50f ....... Filter: 1010 1101 1111 0000
0b000000 ... nHashFuncs: 11
00000000 ... nTweak: 0/none
00 ......... nFlags: BLOOM_UPDATE_NONE
```
