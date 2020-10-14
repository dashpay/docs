.. meta::
   :description: Compile Dash Core for Linux, macOS, Windows and Gitian deterministic builds
   :keywords: dash, build, compile, linux, macOS, windows, binary, Gitian, developers

.. _compiling-dash:

===================
Compiling Dash Core 
===================

While Dash offers stable binary builds on the `website
<https://www.dash.org/downloads/>`_ and on `GitHub
<https://github.com/dashpay/dash/releases>`_, and development builds
using `GitLab CI <https://gitlab.com/dashpay/dash/pipelines>`_,  many
users will also be interested in building Dash binaries for themselves.
This process has been greatly simplified with the release of Dash Core
0.13.0, and users who do not required deterministic builds can typically
follow the `generic build notes <https://github.com/dashpay/dash/blob/develop/doc/build-generic.md>`__
available on GitHub to compile or cross-compile Dash for any platform.

The instructions to build Dash Core 0.12.3 or older are available `here
<https://docs.dash.org/en/0.12.3/developers/compiling.html>`__ on a
previous version of this page.

.. _gitian-build:

Gitian
======

Gitian is the deterministic build process that is used to build the Dash
Core executables. It provides a way to be reasonably sure that the
executables are really built from the source on GitHub. It also makes
sure that the same, tested dependencies are used and statically built
into the executable. Multiple developers build the source code by
following a specific descriptor ("recipe"), cryptographically sign the
result, and upload the resulting signature. These results are compared
and only if they match, the build is accepted and uploaded to dash.org.

Instructions on how to build Dash Core 0.13.0 will appear here once the
Docker build system for Gitian is available. Instructions to create
deterministic builds of Dash Core 0.12.3 or older are available `here
<https://docs.dash.org/en/0.12.3/developers/compiling.html#gitian-build>`__ 
on a previous version of this page.
