.. meta::
  :description: Guide to installing a Dash ElectrumX server
  :keywords: dash, electrum, guide, setup

.. _electrumx:

================
ElectrumX Server
================

ElectrumX is a lightweight Electrum server written in Python that supports a
variety of cryptocurrencies including Dash. It provides the backend services
necessary to support the :ref:`Dash Electrum wallet <dash-electrum-wallet>`.

An ElectrumX server requires running a full node in addition to the ElectrumX
software. The following steps assume a Dash Core full node has already been
installed on the server and is configured with transaction indexing enabled
(``txindex=1`` in ``dash.conf``). 

.. note::
  Please see :ref:`this page (VPS setup)<vps-setup>` and :ref:`this page (OS
  setup)<vps-os-setup>` for details regarding server configuration. **When
  creating the new user, use** ``electrumx`` **for the user name.**

Check Dash Core Configuration
=============================

Before beginning the ElectrumX setup, make sure that your Dash Core node is
configured to allow RPC access and perform transaction indexing.  These settings
can be checked by viewing the ``dash.conf`` configuration file (:ref:`default
location<dashcore-rpc>`).

RPC Access
----------

The ``dash.conf`` file must include values for ``rpcuser``, ``rpcpassword``, and
``rpcallowip`` (it may also include ``rpcport``). They will be used in the *Set
network values* step of  `Install and Configure ElectrumX`_ . If the values are
not present, add them as shown below.

::

  rpcuser=XXXXXXXXXXXXX
  rpcpassword=XXXXXXXXXXXXXXXXXXXXXXXXXXXX
  rpcallowip=127.0.0.1

Replace the fields marked with ``XXXXXXX`` as follows:

- ``rpcuser``: enter any string of numbers or letters, no special
  characters allowed
- ``rpcpassword``: enter any string of numbers or letters, no special
  characters allowed


Transaction Indexing
--------------------

Make sure the following line is present in ``dash.conf``. If it's not present,
add it and restart the node using the ``-reindex`` option. Note that reindexing
can take a long time.

.. code-block:: shell
  
  txindex=1

Install Dependencies
====================

Python 3.7 is required for ElectrumX, ``build-essential`` and ``-dev`` version
of Python are required for ``x11_hash``, and ``daemontools`` is required to
manage the ElectrumX service.

Install Python 3.7 and the required build tools via the package system:

.. code-block:: shell

  sudo add-apt-repository ppa:deadsnakes/ppa # the repo with python3.7
  sudo apt update
  sudo apt install -y software-properties-common build-essential daemontools python3.7-dev python3-pip

Now that Python 3.7 is installed, make it the default version:

.. code-block:: shell

  sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

Since the default version of Python has potentially changed, reinstall
setuptools and then install X11 library:

.. code-block:: shell

  pip3 install --upgrade --force-reinstall setuptools
  pip3 install x11_hash

Generate an SSL key and an associated certificate file for the server:

.. code-block:: shell

  openssl genrsa -out server.key 2048
  openssl req -new -key server.key -out server.csr
  openssl x509 -req -days 1825 -in server.csr -signkey server.key -out server.crt

Install and Configure ElectrumX
===============================

Install ElectrumX
-----------------

Clone ElectrumX from GitHub via git:

.. code-block:: shell

  git clone https://github.com/spesmilo/electrumx.git


Build and install the project:

.. code-block:: shell

  cd electrumx && sudo python3 setup.py install && pip3 install . --upgrade && cd


Configure ElectrumX
-------------------

Create the ElectrumX directories and copy files into them. These directories will be
located in the ``electrumx`` user's home directory:

.. code-block:: shell

  mkdir -p scripts service data/electrumx-server var/log/electrumx
  cp -R /home/electrumx/electrumx/contrib/daemontools scripts/electrumx
 
Set the server banner message and the coin type that the server will host:

.. code-block:: shell

  echo '$SERVER_SUBVERSION running on $DAEMON_SUBVERSION' > /home/electrumx/electrumx/banner
  echo "/home/electrumx/electrumx/banner" > scripts/electrumx/env/BANNER_FILE
  echo "Dash" > scripts/electrumx/env/COIN

Set network values:

ElectrumX requires Dash Core RPC details so it can connect properly. Set
``RPC_USER``, ``RPC_PASS``, ``RPC_IP``, and ``RPC_PORT`` variables to the values
found in your ``dash.conf`` file. These values were previously checked in the
`RPC Access`_ section.

Use the values provided below for the ElectrumX network setting if configuring a
Testnet server. If configuring a Mainnet server, use the alternate values shown
in the comments.

.. code-block:: shell

  # Values from dash.conf 
  RPC_USER=user
  RPC_PASS=pass
  RPC_IP=127.0.0.1
  RPC_PORT=19998  # 9998 for mainnet

  # ElectrumX network settings
  NETWORK=testnet # or "mainnet"
  PORT_01=51001   # or 50001 for mainnet
  PORT_02=51002   # or 50002 for mainnet
  EXTERNAL_IP=$(curl ifconfig.me)

  # Write configuration details to ElectrumX script files
  echo "http://$RPC_USER:$RPC_PASS@$RPC_IP:$RPC_PORT/" > scripts/electrumx/env/DAEMON_URL
  echo "/home/electrumx/data/electrumx-server/" > scripts/electrumx/env/DB_DIRECTORY
  echo "/home/electrumx/electrumx/electrumx_server" > scripts/electrumx/env/ELECTRUMX
  echo "%(asctime)s %(levelname)s:%(name)s:%(message)s" > scripts/electrumx/env/LOG_FORMAT
  echo "128" > scripts/electrumx/env/MAX_SESSIONS # might want less on testnet, something like 32
  echo "$NETWORK" > scripts/electrumx/env/NET
  echo "tcp://$EXTERNAL_IP:$PORT_01,ssl://$EXTERNAL_IP:$PORT_02" > scripts/electrumx/env/REPORT_SERVICES
  echo "tcp://:$PORT_01,ssl://:$PORT_02,rpc://" > scripts/electrumx/env/SERVICES

  # Enable firewall access for ElectrumX ports and reload ufw
  sudo ufw allow $PORT_01 # ElectrumX
  sudo ufw allow $PORT_02 # ElectrumX
  sudo ufw reload
  
Set the SSL values:

.. code-block:: shell

  echo "/home/electrumx/server.crt" > scripts/electrumx/env/SSL_CERTFILE
  echo "/home/electrumx/server.key" > scripts/electrumx/env/SSL_KEYFILE

Set the ElectrumX username to match our current user:

.. code-block:: shell  

  echo "electrumx" > scripts/electrumx/env/USERNAME

Set the ElectrumX log directory:

The log directory path is set in the ``scripts/electrumx/log/run`` file. Replace
the ``/path/to/log/`` line in that file with
``/home/electrumx/var/log/electrumx``:

.. code-block:: shell

  sed -i scripts/electrumx/log/run -e "s/\/path\/to\/log\/dir/\/home\/electrumx\/var\/log\/electrumx/"

Manage ElectrumX as a service
=============================

Add the service
---------------

.. code-block:: shell

  svscan /home/electrumx/service & disown
  ln -s /home/electrumx/scripts/electrumx/ /home/electrumx/service/electrumx


Start the service
-----------------

.. code-block:: shell

  svc -u /home/electrumx/service/electrumx


Stop the service
----------------

.. code-block:: shell

  svc -d /home/electrumx/service/electrumx

View Logs
---------

.. code-block:: shell

  tail -100f ~/var/log/electrumx/current

.. toctree::
  :maxdepth: 1

