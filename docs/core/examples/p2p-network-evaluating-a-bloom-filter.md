```{eval-rst}
.. meta::
  :title: Evaluating a Bloom Filter
  :description: Demonstrates how to check if a bloom filter finds any data matching the relevant criteria.
```

# Evaluating a Bloom Filter

Using a [bloom filter](../resources/glossary.md#bloom-filter) to find matching data is nearly identical to constructing a bloom filter---except that at each step we check to see if the calculated index bit is set in the existing filter.

``` python
vData = bitarray(endian='little')
vData.frombytes("b50f".decode("hex"))
nHashFuncs = 11
nTweak = 0
nFlags = 0
```

Using the bloom filter created above, we import its various parameters. Note, as indicated in the section above, we won't actually use *nFlags* to update the filter.

``` python
def contains(nHashFuncs, data_to_hash):
    for nHashNum in range(nHashFuncs):
        ## bloom_hash as defined in previous section
        nIndex = bloom_hash(nHashNum, data_to_hash)

        if vData[nIndex] != True:
            print "MATCH FAILURE: Index {0} not set in {1}".format(
                hex(int(nIndex)),
                vData.to01()
            )
            return False
```

We define a function to check an element against the provided filter. When checking whether the filter might contain an element, we test to see whether a particular bit in the filter is already set to 1 (if it isn't, the match fails).

``` python
## Test 1: Same TXID as previously added to filter
data_to_hash = "019f5b01d4195ecbc9398fbf3c3b1fa9" \
               + "bb3183301d7a1fb3bd174fcfa40a2b65"
data_to_hash = data_to_hash.decode("hex")
contains(nHashFuncs, data_to_hash)
```

Testing the filter against the data element we previously added, we get no output (indicating a possible match).  Recall that bloom filters have a zero false negative rate---so they should always match the inserted elements.

``` python
## Test 2: Arbitrary string
data_to_hash = "1/10,000 chance this ASCII string will match"
contains(nHashFuncs, data_to_hash)
```

Testing the filter against an arbitrary element, we get the failure output below.  Note: we created the filter with a 1-in-10,000 false positive rate (which was rounded up somewhat when we truncated), so it was possible this arbitrary string would've matched the filter anyway. It is not possible to set a bloom filter to a false positive rate of zero, so your program will always have to deal with false positives. The output below shows us that one of the hash functions returned an index number of 0x06, but that bit wasn't set in the filter, causing the match failure:

``` text
MATCH FAILURE: Index 0x6 not set in 1010110111110000
```
