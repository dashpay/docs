.. meta::
   :description: Description of dashmate and its many properties.
   :keywords: dash, wallet, core, platform, HPMN, masternodes, dashmate

.. _dashmate:

========
Dashmate
========

Dashmate is a universal tool designed to help you set up and run Dash
masternodes in a containerized environment. It is also an ideal tool to quickly
and easily set up and run a development network on your local system.

.. image:: img/dashmate.gif
   :align: center

Install dependencies
====================

Install and configure Docker::
   
   curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh
   sudo usermod -aG docker $USER
   newgrp docker

.. _dashmate-install:

Install Dashmate
================

There are several methods available for installing Dashmate.

.. _dashmate-install-deb:

Debian package
--------------

Download the Dashmate installation package::

   wget https://github.com/dashpay/platform/releases/download/v0.24.0-dev.17/dashmate_0.24.0.12b0c20-1_amd64.deb

Install Dashmate using apt::

   sudo apt update
   sudo apt install ./dashmate_0.24.0.12b0c20-1_amd64.deb

Node package
------------

To install the NodeJS package, it is necessary to install NodeJS first. We recommend
installing it using `nvm <https://github.com/nvm-sh/nvm#readme>`__::

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  source ~/.bashrc
  nvm install 16

Once NodeJS has been installed, use npm to install Dashmate::

   npm install -g dashmate