```{eval-rst}
.. meta::
  :title: Bloom Filter Script
  :description: Code which demonstrates the bloom filter script. 
```

# Bloom Filter Script

Complete Python script demonstrating the [Creating](../examples/p2p-network-creating-a-bloom-filter.md)/[Evaluating](../examples/p2p-network-evaluating-a-bloom-filter.md) bloom filter ([view as a GitHub Gist](https://gist.github.com/dash-docs/5d63f095352a717f90d41a5e7fbbdac1#file-bloom_filter_example-py)):

``` python
#!/usr/bin/env python
from math import log
from bitarray import bitarray  # from pypi.python.org/pypi/bitarray
import pyhash  # from https://github.com/flier/pyfasthash

# Based on BIP-37
# https://github.com/QuantumExplorer/bips/blob/master/bip-0037.mediawiki

# Defined in bloom.h
# https://github.com/dashpay/dash/blob/master/src/bloom.h#L19-#L20
MAX_BLOOM_FILTER_SIZE = 36000
MAX_HASH_FUNCS = 50

# Set of flags that control how matched items are added to the filter (per BIP-37)
# https://github.com/dashpay/dash/blob/master/src/bloom.h#L26
nFlags = 0

nElements = 1 # Number of elements
nFPRate = 0.0001 # False positive rate

nFilterBytes = int(min((-1 / log(2)**2 * nElements * log(nFPRate)) / 8, MAX_BLOOM_FILTER_SIZE))

# Calculate the number of hash functions to use in the filter
# Limit the maximum number to 50 per BIP-37
nHashFuncs = int(min(nFilterBytes * 8 / nElements * log(2), MAX_HASH_FUNCS))

murmur3 = pyhash.murmur3_32()

TEST_TXID = "019f5b01d4195ecbc9398fbf3c3b1fa9bb3183301d7a1fb3bd174fcfa40a2b65"

def bloom_hash(nHashNum, data):
    seed = (nHashNum * 0xfba4c795 + nTweak) & 0xffffffff
    return( murmur3(data, seed=seed) % (nFilterBytes * 8) )


# Bloom Filter creation
def create_filter(nTweak):
    print('Creating bloom filter')
    vData = nFilterBytes * 8 * bitarray('0', endian="little")

    data_to_hash = TEST_TXID
    data_to_hash = data_to_hash.decode("hex")

    print('Filter bytes: {}; Hash functions: {}'.format(nFilterBytes, nHashFuncs))

    print("                             Filter (As Bits)")
    print("nHashNum   nIndex   Filter   0123456789abcdef")
    print("~~~~~~~~   ~~~~~~   ~~~~~~   ~~~~~~~~~~~~~~~~")
    for nHashNum in range(nHashFuncs):
        nIndex = bloom_hash(nHashNum, data_to_hash)

        ## Set the bit at nIndex to 1
        vData[nIndex] = True

        ## Debug: print current state
        print('      {0:2}      {1:2}     {2}   {3}'.format(
            nHashNum,
            hex(int(nIndex)),
            vData.tobytes().encode("hex"),
            vData.to01()
        ))

    print('Bloom filter: {}\n'.format(vData.tobytes().encode("hex")))


# Bloom Filter evaluation
def evaluate_filter():
    print('Evaluating bloom filter')
    vData = bitarray(endian='little')
    vData.frombytes("b50f".decode("hex"))
    nHashFuncs = 11
    nTweak = 0
    nFlags = 0

    def contains(nHashFuncs, data_to_hash):
        for nHashNum in range(nHashFuncs):
            ## bloom_hash as defined in previous section
            nIndex = bloom_hash(nHashNum, data_to_hash)

            if vData[nIndex] != True:
                print("MATCH FAILURE: Index {0} not set in {1}\n".format(
                    hex(int(nIndex)),
                    vData.to01()
                ))
                return False
        print("MATCH SUCCESS\n")

    ## Test 1: Same TXID as previously added to filter
    data_to_hash = TEST_TXID
    print('\nChecking: {}'.format(data_to_hash))
    data_to_hash = data_to_hash.decode("hex")
    contains(nHashFuncs, data_to_hash)

    ## Test 2: Arbitrary string
    data_to_hash = "1/10,000 chance this ASCII string will match"
    print('Checking: {}'.format(data_to_hash))
    contains(nHashFuncs, data_to_hash)


# Tweak is a random value added to the seed value in the hash function
# used by the bloom filter
nTweak = 0

create_filter(nTweak)
evaluate_filter()
```
