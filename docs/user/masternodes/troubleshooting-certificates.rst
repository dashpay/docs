.. meta::
   :description: How to diagnose and fix TLS certificate renewal problems on a Dash evonode, including inbound port 80 requirements for Let's Encrypt and ZeroSSL
   :keywords: dash, cryptocurrency, masternode, evonode, certificate, ssl, tls, port 80, lets encrypt, zerossl, acme, renewal, troubleshooting

.. _evonode-cert-troubleshooting:

===================================
Certificate renewal troubleshooting
===================================

Your evonode serves Dash Platform over TLS, so it needs a valid certificate at all times. Dashmate
obtains that certificate for you and renews it automatically, but renewal can stop working long
after setup succeeded. If renewal fails without you noticing it, your node will stop accepting
clients once the certificate expires.

Serving expired certificates is one of the most common connection issues on mainnet evonodes. Use
the info on this page to find and fix certificate renewal failures on your evonode.

.. _evonode-cert-port-80:

Inbound port 80 is a permanent requirement
==========================================

This cause is common and often misunderstood. When dashmate obtains a certificate for you using
Let's Encrypt or ZeroSSL, the authority proves you control your IP address by connecting to your
node on port 80 and reading a file dashmate temporarily serves there. This happens on every issuance
and every renewal, not only during setup. It does not apply if you upload a certificate yourself.

Let's Encrypt certificates for IP addresses are :ref:`short-lived <evonode-ssl-cert>` — about 160
hours — and dashmate renews them a couple of days before they expire. So a non-permanent firewall
rule can result in your node having an expired certificate within a week.

.. warning::

   Inbound port 80 must stay open permanently. Dashmate does not warn you when it stops being
   reachable. The certificate you are serving just becomes invalid when it expires.

.. _evonode-cert-port-80-scan:

Why you cannot test port 80 with a port scanner
-----------------------------------------------

Since nothing continuously listens to port 80 on a normal evonode, an external port check will
report it closed even on healthy nodes. Dashmate starts a listener only for the few seconds a
renewal takes, and shuts it down again immediately. A scanner that checks at any other time will
find nothing.

.. note::

   A "port 80 closed" result from an online port checker tells you nothing about whether certificate
   renewal works. Do not rewrite firewall rules based on it.

The reliable way to find out is to ask your node what actually happened the last time it tried.

.. _evonode-cert-diagnose:

Find out what is actually wrong
===============================

Run the doctor::

   dashmate doctor

Dashmate records the outcome of every scheduled renewal, so the doctor reports the reason the
certificate authority gave rather than guessing. If the doctor reports no problem with your
certificate, renewal is working and there is nothing to do here.

.. _evonode-cert-causes:

Causes and what to do about each
================================

The certificate authority could not reach this node on port 80
--------------------------------------------------------------

Nothing usable answered. Which of two things happened is worth knowing, and ``dashmate doctor``
shows the authority's own words:

- **Timed out**. The connection went nowhere and nothing replied because a firewall dropped it
  silently. Work through the three layers below.
- **Refused**. Something reachable actively rejected the connection, so the packets arrive but
  nothing is listening when they do. Check that port 80 is forwarded to the evonode, then look
  at what dashmate reported: ``dashmate logs <config> dashmate_helper``.

For a timeout, check all three layers. Connections could be blocked at any or all layers:

#. The machine's own firewall. On Ubuntu with ``ufw``::

      sudo ufw allow 80/tcp
      sudo ufw status

#. Your hosting provider's firewall. Many providers (AWS security groups, Hetzner Cloud
   firewalls, OVH, Vultr, DigitalOcean) apply a second firewall outside the machine, configured in
   their web console. Port 80 must be allowed there too.

#. Your router, if the node is behind NAT. Forward inbound port 80 to the node's internal
   address.

Once the port is open, wait for the next automatic attempt at the time indicated by the doctor. You
do not need to run any command.

Something answered on port 80, but not this node's certificate check
--------------------------------------------------------------------

The certificate authority reached your address and got the wrong response. Something else is
answering: another web server on the machine, a reverse proxy in front of it, or a router forwarding
port 80 somewhere other than your node.

Check the machine first::

   sudo ss -lntp 'sport = :80'

If that lists a process (e.g., nginx, Apache, Caddy, another container), stop it or move it to a
different port. Dashmate needs port 80 free to answer the challenge.

If it lists nothing, then something upstream is answering instead of your node. Check your router's
port forwarding and your hosting provider's configuration.

Something on this machine is already using port 80
---------------------------------------------------

Dashmate could not start its own listener because the port is taken. Note this is the opposite
problem to an unreachable port: the port is reachable, it is occupied. Find and stop the occupant
with the ``ss`` command above.

The free ZeroSSL account has used all three of its certificates
----------------------------------------------------------------

Dashmate obtains ZeroSSL certificates through ZeroSSL's own API, and :ref:`a free account allows
3 certificates <evonode-ssl-cert>` — or 3 renewals of one certificate — in total. Renewals stop
permanently after that. It is not something you can wait out or repair; ZeroSSL will not issue
another one on that plan.

Switch to Let's Encrypt, which is free and does not cap certificates this way::

   dashmate ssl obtain --config mainnet --provider letsencrypt

This still needs inbound port 80 open to the internet, permanently. If you cannot open port 80,
there is no other way to automatically obtain a certificate for an IP address. See :ref:`SSL
certificates <evonode-ssl-cert>` for the manual upload option.

The certificate authority has temporarily refused this address
---------------------------------------------------------------

Let's Encrypt applies two separate limits, and they are easy to confuse:

- Five failed validations per hour, counted per ACME account and address. This is the one you
  hit by retrying after a failure, and dashmate's own automatic renewal draws on the same budget.
- Five certificates per week for the same address. This one is spent by *successful* issuance,
  which is why a certificate that was issued but never saved still counts.

.. important::

   Do not keep running the obtain command. Each attempt spends part of this budget and makes the
   situation last longer. Fix the underlying cause first, then let the automatic retry run.

A certificate was issued but dashmate could not save it
--------------------------------------------------------

The certificate authority issued a certificate that never reached disk. It counts against the
five-per-week limit above whether or not it arrived, so requesting another one immediately spends a
second one to fix a problem that is local to your machine.

Check free disk space and the permissions on your dashmate directory first, then obtain again.

.. _evonode-cert-avoid:

Avoid making it worse
=====================

- Do not repeatedly run ``dashmate ssl obtain``. Failed attempts are rate-limited by the
  certificate authority and shared with automatic renewal, so retrying without changing anything
  makes recovery slower.
- Do not switch provider hoping it helps. If port 80 is unreachable, every provider will fail in the
  same way since they all validate the same route.
- Do not rely on an external port check. See :ref:`above <evonode-cert-port-80-scan>`.

Getting help
============

If the doctor cannot determine the cause, or the fix does not work, collect a report and send it to
the support team::

   dashmate doctor report

The report includes the recorded renewal outcome along with service logs and system information.
Review it before sharing: it contains your node's IP address and configuration.

.. seealso::

   - :ref:`SSL certificates <evonode-ssl-cert>` — choosing and configuring a certificate provider
   - :ref:`Server configuration <server-config>` — firewall setup
