.. _dash-android-installation:

Installation
============

Google Play
-----------

The easiest way to install the Dash Wallet for Android is from the
Google Play Store. 

.. image:: img/google-play-badge.png
    :width: 300 px
    :target: https://play.google.com/store/apps/details?id=hashengineering.darkcoin.wallet

From APK
--------

Some Android phone do not have access to the Google Play Store because
the phone software, network provider or country may not allow it. You
can install the app manually by first enabling installation of external
sources (if you have not already done so) and then downloading and
installing an APK file. Follow these instructions:

#. Ensure your Android version is at least 4.0.3 by going to **Settings
   → About phone** and checking the version number.
#. Enable Unknown sources by going to **Settings → Security → Unknown
   sources**. Read and accept the warning.
#. Using your phone, download the latest version of the APK from `this
   link <https://github.com/HashEngineering/dash-
   wallet/releases/latest>`_.  At the time of writing, this was 5.17.5.
#. If you cannot use your phone to go online, download the APK using
   your PC instead and copy it to your phone using a cable or Bluetooth.
   You may need a file browser to find the copied file. `ES File
   Explorer <http://www.estrongs.com/>`_ is recommended for this.

You can also install an apk file directly from your computer using the
Android Debug Bridge (ADB). Follow these instructions:

#. Ensure your Android version is at least 4.0.3 by going to **Settings
   → About phone** and checking the version number.
#. Ensure you have a copy of ADB on your PC. This is included in the
   Android `SDK Platform Tools
   <https://developer.android.com/studio/releases/platform-tools.html>`_
   for Mac, Windows or Linux.
#. Enable Unknown sources by going to **Settings → Security → Unknown
   sources**. Read and accept the warning.
#. Enable USB debugging by going to **Settings → Developer options → USB
   debugging**. If **Developer options** is not available, go to **About
   phone** instead, scroll down, and tap on the **Build number** seven
   times.
#. Using your PC, download the latest version of the APK from `this link
   <https://github.com/HashEngineering/dash-wallet/releases/latest>`_.
   At the time of writing, this was 5.17.5.
#. Connect your phone to the PC, open a terminal/command prompt window
   and type::

     adb install <<path to .apk file>>

From source
-----------

Compiling from source
---------------------

The source code for the wallet is available `here
<https://github.com/HashEngineering/dash-wallet>`_. Details on how to
compile the wallet from source will be posted here when available.
