.. meta::
   :description: The Dash governance system is funded by 10% of the block reward
   :keywords: dash, dgbb, governance, funding, voting, blockchain, development, block reward

.. _governance:

==========
Governance
==========

Decentralized Governance by Blockchain, or DGBB, is Dash's attempt to
solve two important problems in cryptocurrency: governance and funding.
Governance in a decentralized project is difficult, because by
definition there are no central authorities to make decisions for the
project. In Dash, such decisions are made by the network, that is, by
the owners of masternodes. The DGBB system allows each masternode to
vote once (yes/no/abstain) for each proposal. If a proposal passes, it
can then be implemented (or not) by Dash's developers. A key example is
early in 2016, when Dash's Core Team submitted a proposal to the network
asking whether the blocksize should be increased to 2 MB. Within 24
hours, consensus had been reached to approve this change. Compare this
to Bitcoin, where debate on the blocksize has been raging for nearly
three years and has resulted in serious splits within the community and
even forks to the Bitcoin blockchain.

The DGBB also provides a means for Dash to fund its own development.
While other projects have to depend on donations or premined endowments,
Dash uses 10% of the block reward to fund its own development. Every
time a block is mined, 45% of the reward goes to the miner, 45% goes to
a masternode, and the remaining 10% is not created until the end of the
month. During the month, anybody can make a budget proposal to the
network. If that proposal earns the net approval of at least 10% of the
masternode network, then at the end of the month the requested amount
will be paid out in a "superblock". At that time, the block rewards that
were not paid out (10% of each block) will be used to fund approved
proposals. The network thus funds itself by reserving 10% of the block
reward for budget projects.

.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 1em; overflow: hidden; max-width: 70%; height: auto;">
        <iframe src="//www.youtube.com/embed/jHsVU1LBuAY" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>

In late 2016, IOHK prepared a detailed report on version 0.12.1 of the
Dash governance system, including formal analysis of weaknesses and
areas for improvement. You can view the report `here
<https://iohk.io/research/papers/#NSJ554WR>`__. An updated overview of
cryptocurrency treasury system in general was published by IOHK in 2019,
available `here <https://iohk.io/en/research/library/papers/a-treasury-system-for-cryptocurrenciesenabling-better-collaborative-intelligence/>`__.

You can learn more about Dash Governance in the following sections:

.. toctree::
   :maxdepth: 1

   understanding.rst
   using.rst
   eight-steps.rst
