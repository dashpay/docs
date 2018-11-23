.. meta::
   :description: The open-source Dash Insight REST API provides you with a convenient, powerful and simple way to read data from the Dash network and build your own services with it.
   :keywords: dash, insight, API, REST, blockchain, explorer, JSON, HTTP, blocks, index, transactions

.. _insight-api:

===========
Insight API
===========

The open-source Dash Insight REST API provides you with a convenient,
powerful and simple way to read data from the Dash network and build
your own services with it. Simple HTTP endpoints exist for all common
operations on the Dash blockchain familiar from the Bitcore Insight API,
as well as Dash-specific features such as InstantSend transactions,
budget proposals, sporks and the masternode list. This documentation
describes how to set up an Insight server and (optionally) the Insight
UI block explorer.

A standard installation of Ubuntu Linux 18.04 LTS will be used as an
environment for the server. We assume you are running as a user with
sudo permissions. First update all packages and install some tools and
dependencies::

  sudo apt update
  sudo apt upgrade
  sudo apt install npm build-essential libzmq3-dev

Download and extract the latest version of Dash Core::

  cd ~
  wget https://github.com/dashpay/dash/releases/download/v0.12.3.3/dashcore-0.12.3.3-x86_64-linux-gnu.tar.gz
  tar -xvzf dashcore-0.12.3.3-x86_64-linux-gnu.tar.gz
  rm dashcore-0.12.3.3-x86_64-linux-gnu.tar.gz

Install `Dashcore Node <https://github.com/dashevo/dashcore-node>`_ and create your configuration::

  sudo npm install -g @dashevo/dashcore-node
  dashcore-node create mynode

Install the Insight API service and (optionally) Insight UI::

  cd mynode
  dashcore-node install @dashevo/insight-api
  dashcore-node install @dashevo/insight-ui

Change paths in the configuration file as follows::

  nano dashcore-node.json

- Change the value of ``datadir`` to ``../.dashcore``
- Change the value of ``exec`` to ``../dashcore-0.12.3/bin/dashd``

Run it::

  dashcore-node start

Your Insight API node will start up and begin to sync. Progress will be
displayed on stdout. Once sync is complete, the `API endpoints listed in
the documentation <https://github.com/dashevo/insight-api#api-http-endpoints>`_ 
will be available at::

  https://<ip-address>:3001/insight-api-dash/<endpoint>/

The Insight UI block explorer will be available at::

  http://<ip-address:3001/insight/
