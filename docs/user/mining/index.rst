.. meta::
   :description: Information and guides on how to mine the Dash cryptocurrency
   :keywords: dash, mining, X11, masternode, CPU, GPU, ASIC, software, hardware, pool, mining pools

.. _mining:

======
Mining
======

Mining in the context of cryptocurrency such as Dash refers to the
process of searching for solutions to cryptographically difficult
problems as a method of securing blocks on the blockchain. The process
of mining creates new currency tokens as a reward to the miner. Mining
is possible on a range of hardware. Dash implements an algorithm known
as :ref:`X11 <x11-hash-algorithm>`, which the miner must solve in order
to earn rewards. A number of X11 ASICs are available on the market,
which help make Dash secure against brute force attacks on the blockchain.

The profitability of mining is determined by the hashrate of your mining
device, the current network difficulty and the costs of your hardware
and electricity. The following links provide up to date information:

- `Hashrate <https://bitinfocharts.com/comparison/dash-hashrate.html>`_
- `Mining difficulty <https://bitinfocharts.com/comparison/dash-difficulty.html>`_
- `Profitability calculation tool <https://www.coinwarz.com/mining/dash/calculator>`_

Masternodes vs. Mining
======================

Dash, like Bitcoin and most other cryptocurrencies, is based on a
decentralized ledger of all transactions, known as a blockchain. This
blockchain is secured through a consensus mechanism; in the case of both
Dash and Bitcoin, the consensus mechanism is Proof of Work (PoW). Miners
attempt to solve difficult problems with specialized computers, and when
they solve the problem, they receive the right to add a new block to the
blockchain. If all the other people running the software agree that the
problem was solved correctly, the block is added to the blockchain and
the miner is rewarded.

Dash works a little differently from Bitcoin, however, because it has a
two-tier network. The second tier is powered by :ref:`masternodes
<masternodes>` (Full Nodes), which enable financial privacy
(CoinJoin), instant transactions (InstantSend), and the decentralized
governance and budget system. Because this second tier is so important,
masternodes are also rewarded when miners discover new blocks. The
breakdown is as follows: 80% of the block subsidy is split between the
miner and a masternode per the distribution found :ref:`here <block-reward-reallocation>`,
while 20% is reserved for the budget system (created by superblocks
every month).

The masternode system is referred to as Proof of Service (PoSe), since
the masternodes provide crucial services to the network. In fact, the
entire network is overseen by the masternodes, which have the power to
reject improperly formed blocks from miners. If a miner tried to take
the entire block reward for themselves or tried to run an old version of
the Dash software, the masternode network would orphan that block, and
it would not be added to the blockchain.

In short, miners power the first tier, which is the basic sending and
receiving of funds and prevention of doublespending. Masternodes power
the second tier, which provide the added features that make Dash
different from other cryptocurrencies. Masternodes do not mine, and
mining computers cannot serve as masternodes. Additionally, each
masternode is “secured” by 1000 DASH. Those DASH remain under the sole
control of their owner at all times, and can still be freely spent. The
funds are not locked in any way. However, if the funds are moved or
spent, the associated masternode will go offline and stop receiving
rewards.

Mining Pools
============

Mining Dash in pools is more likely to generate rewards than solo mining
directly on the blockchain. Mining dash using P2Pool is strongly
encouraged, since it is a good way to distribute, rather than
centralize, the hashing power. The following site lists Dash P2Pool
mining pools near you, simply choose a pool with favourable fees and
ping time and enter your Dash payment address as username and anything
as password.

- http://www.p2poolmining.us/p2poolnodes/

If you would like to set up your own P2Pool, documentation of the
process is available :ref:`here <p2pool>` and the code for p2pool-dash
is available on `GitHub <https://github.com/dashpay/p2pool-dash>`_.
Other mining pools are listed below and may be advantageous for
different reasons such as ping latency, uptime, fee, users, etc. A guide
to using a typical mining pool can be found :ref:`here <mining-pools>`.


- https://coinfoundry.org
- https://mining.luxor.tech
- https://www.nicehash.com
- https://dash.miningpoolhub.com
- https://www.multipool.us
- https://www.f2pool.com
- https://www.antpool.com
- https://www.viabtc.com
- https://zpool.ca

DISCLAIMER: This list is provided for informational purposes only.
Services listed here have not been evaluated or endorsed by the Dash
developers and no guarantees are made as to the accuracy of this
information. Please exercise discretion when using third-party services.
If you’d like to be added to this list please reach out to
leon.white@dash.org

In addition to joining a pool, you will also need to create a Dash
address to receive your payout. To do this in Dash Core wallet, see
:ref:`here <dashcore-send-receive>`.

.. toctree::
   :hidden:
   :includehidden:
   :maxdepth: 1

   pools.rst
   p2pool.rst


.. _asic-mining:

ASIC Mining
===========

ASIC stands for *Application-Specific Integrated Circuit* and describes
a type of processor that is designed for one purpose only. ASICs are a
popular choice for mining cryptocurrency because they can offer a higher
efficiency than CPU or GPU miners, resulting in higher profit.

Please note that the information on this page may become obsolete very
quickly due to the rapidly changing market and difficulty of mining
Dash. You are responsible for carrying out your own research and any
listing on this page should not be considered an endorsement of any
particular product. A good place to begin your research is the `mining
section of the Dash Forums <https://www.dash.org/forum/topic/hardware-discussions-asic-gpu-cpu.101/>`_.

The following X11 ASIC miners are available on the market today, click
the product name to visit the manufacturer's website:

+----------------------------------------------------------------------------------------------------------+---------------+---------+---------+-----------------+---------+
| Name                                                                                                     | Hash rate     | Power   | Weight  | Dimensions (mm) | Price   |
+==========================================================================================================+===============+=========+=========+=================+=========+
| `Bitmain Antminer D5 <https://shop.bitmain.com.cn/product/detail?pid=000201811150956053407f2Bhw2x068D>`_ | 119 GH/s ±5%  | 1566 W  | 7.5 kg  | 486 x 265 x 388 | $1,180  |
+----------------------------------------------------------------------------------------------------------+---------------+---------+---------+-----------------+---------+
| `Spondoolies SPx36 <https://www.spondoolies-tech.com/products/spx36>`_                                   | 540 GH/s ±10% | 4400 W  | 19.5 kg | 640 x 525 x 185 | $7,000  |
+----------------------------------------------------------------------------------------------------------+---------------+---------+---------+-----------------+---------+
| `StrongU STU-U6 <https://strongu.com.cn/Home/Goods/goodsInfo/id/263.html>`_                              | 420 GH/s ±8%  | 2100 W  | 8.5 kg  | 370 x 135 x 208 |         |
+----------------------------------------------------------------------------------------------------------+---------------+---------+---------+-----------------+---------+

ASIC resellers may also have miners available:

- http://kaboomracks.com
- https://brokerage.luxor.tech/dashboard

The following ASIC miners are either no longer easily available or
obsolete due to the increase in difficulty on the network.

+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Name                                                                                                  | Hash rate      | Power  | Weight  | Dimensions (mm) |
+=======================================================================================================+================+========+=========+=================+
| `Baikal BK-X <https://www.baikalminer.com/product09.php>`_                                            | 10 GH/s ±5%    | 800 W  | 3.8 kg  | 312 x 125 x 130 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Baikal Mini <https://www.baikalminer.com/>`_                                                         | 150 MH/s ±10%  | 40 W   | .475 kg | 140 x 100 x 95  |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Baikal Giant+ A2000 <https://www.baikalminer.com/product06.php>`_                                    | 2000 MH/s ±10% | 430 W  | 3 kg    | 300 x 140 x 125 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Baikal Giant A900 <https://www.baikalminer.com/>`_                                                   | 900 MH/s ±5%   | 217 W  | 2.5 kg  | 300 x 123 x 123 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Baikal Quad Cube <https://www.baikalminer.com/>`_                                                    | 1200 MH/s ±10% | 300 W  | 3 kg    | 135 x 135 x 425 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Bitmain Antminer D3 <https://shop.bitmain.com/product/detail?pid=000201810311345082643S60TX7I0609>`_ | 17 GH/s ±5%    | 970 W  | 6.5 kg  | 320 x 130 x 190 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `iBelink DM384M <https://ibelink.co/>`_                                                               | 384 MH/s ±10%  | 715 W  | 21 kg   | 490 x 350 x 180 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `iBelink DM11G <https://www.asicminervalue.com/miners/ibelink/dm11g>`_                                | 11 GH/s ±5%    | 810 W  | 22 kg   | 490 x 350 x 180 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `iBelink DM22G <https://www.asicminervalue.com/miners/ibelink/dm22g>`_                                | 22 GH/s ±5%    | 810 W  | 19 kg   | 490 x 350 x 180 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DR-1                                                                                          | 500 MH/s ±10%  | 320 W  | 4.5 kg  | 290 x 130 x 150 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DR-2                                                                                          | 450 MH/s ±5%   | 335 W  | 4.5 kg  | 200 x 165 x 135 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DR-3                                                                                          | 600 MH/s ±5%   | 345 W  | 4.5 kg  | 200 x 165 x 135 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DU-1                                                                                          | 9 MH/s ±5%     | 7 W    |         | 50 x 50 x 30    |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DRX-Kuznetsov                                                                                 | 900 MH/s ±5%   | 650 W  |         | 280 x 180 x 150 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| Pinidea DRX-Varyag                                                                                    | 1200 MH/s ±5%  | 850 W  |         | 280 x 180 x 150 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `iBelink DM56G <https://ibelink.co/product/ibelink-dm56g-x11-dash-miner-with-56-gh-s-hash-rate/>`_    | 56 GH/s ±5%    | 2100 W | 17 kg   | 490 x 390 x 180 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
| `Innosilicon A5 <https://www.innosilicon.com/html/a5-miner/index.html>`_                              | 32 GH/s ±8%    | 750 W  | 3.1 kg  | 400 x 135 x 158 |
+-------------------------------------------------------------------------------------------------------+----------------+--------+---------+-----------------+
