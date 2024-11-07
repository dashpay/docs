```{eval-rst}
.. meta::
  :title: Dash Future Proposals
  :description: Future plans like UTXO commitments aim to balance security and storage needs for clients, impacting decisions about operational modes based on various constraints and Dash value.
```

# Future Proposals

There are future proposals such as Unspent Transaction Output (UTXO) commitments in the block chain to find a more satisfactory middle-ground for clients between needing a complete copy of the block chain, or trusting that a majority of your connected peers are not lying. UTXO commitments would enable a very secure client using a finite amount of storage using a data structure that is authenticated in the block chain. These type of proposals are, however, in very early stages, and will require soft forks in the network.

Until these types of operating modes are implemented, modes should be chosen based on the likely threat model, computing and bandwidth constraints, and liability in Dash value.

**Resources:** [Original Thread on UTXO Commitments](https://bitcointalk.org/index.php?topic=88208.0)
