.. meta::
   :description: The Dash governance system is funded by 20% of the block reward
   :keywords: dash, dgbb, governance, funding, voting, blockchain, development, block reward

.. _governance:

==========
Governance
==========

Governance in a decentralized project is difficult, because by 
definition there are no central authorities to make decisions for 
the project. In Dash, such decisions are made by a Decentralized 
Autonomous Organization (or DAO) consisting of the masternodes. 
The DAO allows each masternode to vote once (yes/no/abstain) for 
each proposal. If a proposal passes, it can then be implemented (or not) 
by Dash's developers. A key example is early in 2016, when Dash's Core Team 
submitted a proposal to the network asking whether the blocksize should be 
increased to 2 MB. Within 24 hours, consensus had been reached to approve this 
change. Compare this to Bitcoin, where debate on the blocksize has been raging 
for nearly three years and has resulted in serious splits within the community 
and even forks to the Bitcoin blockchain.

The DAO also provides a means for Dash to fund its own development. While other 
projects have to depend on donations or premined endowments, Dash uses 20% of 
the block subsidy to fund its own development. Every time a block is mined, 80% 
of the subsidy is split between the miner and a masternode per the distribution 
found :ref:`here <block-reward-reallocation>`, while the remaining 20% is not 
created until the end of the month. During the month, anybody can make a budget 
proposal to the network. If that proposal earns the net approval of at least 10% 
of the masternode network, then at the end of the month the requested amount will 
be paid out in a "superblock". At that time, the block subsidies that were not paid 
out (20% of each block) will be used to fund approved proposals. The network thus 
funds itself by reserving 20% of the block subsidy for budget projects.


.. raw:: html

    <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 1em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube-nocookie.com/embed/jHsVU1LBuAY?modestbranding=1&rel=0" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>

 

You can learn more about Dash Governance in the following sections:

.. toctree::
   :maxdepth: 1

   understanding.rst
   using.rst
   eight-steps.rst
