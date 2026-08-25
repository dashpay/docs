.. meta::
   :description: How to diagnose and fix TLS certificate renewal problems on a Dash evonode, including inbound port 80 requirements for Let's Encrypt and ZeroSSL
   :keywords: dash, cryptocurrency, masternode, evonode, certificate, ssl, tls, port 80, lets encrypt, zerossl, acme, renewal, troubleshooting

.. _evonode-cert-troubleshooting:

===================================
Certificate renewal troubleshooting
===================================

Your evonode serves Dash Platform over TLS, so it needs a valid certificate at all times. Dashmate
obtains that certificate for you and renews it automatically, but renewal can stop working long
after setup succeeded — and when it does, nothing warns you until the certificate expires and your
node stops accepting clients.

Serving an expired certificate is one of the most common faults on mainnet evonodes, and almost all
of it comes down to the causes below.

This page explains why renewal fails, how to find out which cause applies to your node, and what to
do about each one.

.. _evonode-cert-port-80:

Inbound port 80 is a permanent requirement
==========================================

This is the single most common cause, and the most commonly misunderstood.

Both Let's Encrypt and ZeroSSL prove that you control your IP address by connecting **to** your node
on port 80 and reading a file dashmate serves there for a few seconds. This happens on **every
issuance and every renewal**, not only during setup.

Let's Encrypt certificates for IP addresses are :ref:`short-lived <evonode-ssl-cert>` — about 160
hours — and dashmate renews them a couple of days before they expire. So a firewall rule that was
opened once for setup and closed afterwards, or one that does not survive a reboot, takes your node
dark within a week.

.. warning::

   Inbound port 80 must stay open permanently. Nothing warns you when it stops being reachable, and
   the certificate you are currently serving keeps working until it expires.

Why you cannot test port 80 with a port scanner
-----------------------------------------------

An external port check on port 80 will report it **closed on a perfectly healthy node**, and this
confuses almost everyone who tries it.

Nothing listens on port 80 on a normal evonode. Dashmate starts a listener only for the few seconds
a renewal takes, and shuts it down again immediately. So a scanner that happens to check at any
other moment finds nothing — which is exactly what a healthy node looks like.

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
certificate authority gave rather than guessing. Work from what it tells you.

If the doctor reports no problem with your certificate, renewal is working and there is nothing to
do here.

.. _evonode-cert-causes:

Causes and what to do about each
================================

The certificate authority could not reach this node on port 80
--------------------------------------------------------------

Nothing answered. The connection was dropped or refused before it arrived, which means a firewall
somewhere between the internet and your node.

Check all three layers — a rule on one does not help if another blocks it:

#. **The machine's own firewall.** On Ubuntu with ``ufw``::

      ufw allow 80/tcp
      ufw status

#. **Your hosting provider's firewall.** Many providers (AWS security groups, Hetzner Cloud
   firewalls, OVH, Vultr, DigitalOcean) apply a second firewall outside the machine, configured in
   their web console. Port 80 must be allowed there too.

#. **Your router**, if the node is behind NAT. Forward inbound port 80 to the node's internal
   address.

Once the port is open, wait for the next automatic attempt — the doctor tells you when that is. You
do not need to run any command.

Something answered on port 80, but not this node's certificate check
--------------------------------------------------------------------

The certificate authority reached your address and got the wrong response. Something else is
answering: another web server on the machine, a reverse proxy in front of it, or a router forwarding
port 80 somewhere other than your node.

Check the machine first::

   sudo ss -lntp 'sport = :80'

If that lists a process (nginx, Apache, Caddy, another container), stop it or move it to a different
port. Dashmate needs port 80 free to answer the challenge.

If it lists **nothing**, then something upstream is answering instead of your node — check your
router's port forwarding and your hosting provider's configuration.

Something on this machine is already using port 80
---------------------------------------------------

Dashmate could not start its own listener because the port is taken. Note this is the opposite
problem to an unreachable port: the port is reachable, it is occupied. Find and stop the occupant
with the ``ss`` command above.

The free ZeroSSL account has used all three of its certificates
----------------------------------------------------------------

A free ZeroSSL account allows three certificates in total, so renewals stop permanently after about
270 days. This is not something you can wait out or repair — ZeroSSL will not issue another one.

Switch to Let's Encrypt, which is free and does not cap certificates this way::

   dashmate ssl obtain --config mainnet --provider letsencrypt

This still needs inbound port 80 open to the internet, permanently. If you cannot open port 80,
there is no other way to obtain a certificate for an IP address automatically — see
:ref:`SSL certificates <evonode-ssl-cert>` for the manual upload option.

The certificate authority has temporarily refused this address
---------------------------------------------------------------

Let's Encrypt limits how often a single address may fail validation — five failed attempts per hour,
and that budget is shared with dashmate's own automatic renewal.

.. important::

   Do not keep running the obtain command. Each attempt spends part of this budget and makes the
   situation last longer. Fix the underlying cause first, then let the automatic retry run.

A certificate was issued but dashmate could not save it
--------------------------------------------------------

The certificate authority issued a certificate that never reached disk. That issuance is spent
against your weekly limit whether or not it arrived, so requesting another one immediately spends a
second one to fix a problem that is local to your machine.

Check free disk space and the permissions on your dashmate directory first, then obtain again.

.. _evonode-cert-avoid:

Avoid making it worse
=====================

- **Do not repeatedly run** ``dashmate ssl obtain``. Failed attempts are rate-limited by the
  certificate authority and shared with automatic renewal, so retrying without changing anything
  makes recovery slower.
- **Do not switch provider hoping it helps.** If port 80 is unreachable, every provider fails the
  same way — they all validate the same route.
- **Do not rely on an external port check.** See :ref:`above <evonode-cert-port-80>`.

Getting help
============

If the doctor cannot determine the cause, or the remedy does not work, collect a report and send it
to the support team::

   dashmate doctor report

The report includes the recorded renewal outcome along with service logs and system information.
Review it before sharing: it contains your node's IP address and configuration.

.. seealso::

   - :ref:`SSL certificates <evonode-ssl-cert>` — choosing and configuring a certificate provider
   - :ref:`Server configuration <server-config>` — firewall setup
