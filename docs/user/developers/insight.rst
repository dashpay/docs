.. meta::
   :description: The open-source Dash Insight REST API provides you with a convenient, powerful and simple way to read data from the Dash network and build your own services with it.
   :keywords: dash, insight, API, REST, blockchain, explorer, JSON, HTTP, blocks, index, transactions

.. _insight-api:

========================
Insight API Installation
========================

The open-source Dash Insight REST API provides you with a convenient,
powerful and simple way to read data from the Dash network and build
your own services with it. Simple HTTP endpoints exist for all common
operations on the Dash blockchain familiar from the Bitcore Insight API,
as well as Dash-specific features such as InstantSend transactions,
budget proposals, sporks and the masternode list. This documentation
describes how to set up the 
`Dash Insight API <https://github.com/dashpay/insight-api>`__ server and
(optionally) the 
`Dash Insight UI <https://github.com/dashpay/insight-ui>`__ block 
explorer.

A standard installation of Ubuntu Linux 20.04 LTS will be used as an
environment for the server. We assume you are running as a user with
sudo permissions. First update all packages and install some tools and
dependencies::

  sudo apt update
  sudo apt upgrade
  sudo apt install npm build-essential libzmq3-dev

Download and extract the latest version of Dash Core::

  cd ~
  wget https://github.com/dashpay/dash/releases/download/v20.1.1/dashcore-20.1.1-x86_64-linux-gnu.tar.gz
  tar -xvzf dashcore-20.1.1-x86_64-linux-gnu.tar.gz
  rm dashcore-20.1.1-x86_64-linux-gnu.tar.gz

Install `Dashcore Node <https://github.com/dashpay/dashcore-node>`_ and
create your configuration::

  git clone https://github.com/dashpay/dashcore-node
  cd dashcore-node
  npm install
  ./bin/dashcore-node create mynode

Install the Insight API service and (optionally) Insight UI::

  cd mynode
  ../bin/dashcore-node install @dashevo/insight-api
  ../bin/dashcore-node install @dashevo/insight-ui

Change paths in the configuration file as follows::

  nano dashcore-node.json

- Change the value of ``datadir`` to ``../../.dashcore``
- Change the value of ``exec`` to ``../../dashcore-20.1.1/bin/dashd``
- **Optionally** change the value of ``network`` to ``testnet`` if you 
  want to run Insight on testnet

Run it::

  ../bin/dashcore-node start

Your Insight API node will start up and begin to sync. Progress will be
displayed on stdout. Once sync is complete, the `API endpoints listed in
the documentation <https://github.com/dashpay/insight-api#api-http-endpoints>`_ 
will be available at::

  https://<ip-address>:3001/insight-api/<endpoint>/

The Insight UI block explorer will be available at::

  http://<ip-address>:3001/insight/
