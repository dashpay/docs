.. meta::
   :description: How to install the Dash wallet on your Android device
   :keywords: dash, mobile, wallet, android, installation, compile

.. _dash-android-installation:

Installation
============

Google Play
-----------

The easiest way to install the Dash Wallet for Android is from the
Google Play Store. 

.. image:: img/google-play-badge.png
    :width: 250 px
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
   link <https://github.com/HashEngineering/dash-wallet/releases/latest>`_.
#. If you cannot use your phone to go online, download the APK using
   your PC instead and copy it to your phone using a cable or Bluetooth.
   You may need a file browser to find the copied file.

You can also install an APK file directly from your computer using the
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
#. Connect your phone to the PC, open a terminal/command prompt window
   and type::

     adb install <<path to .apk file>>


From source
-----------

The source code for the Dash Android wallet is available on `GitHub
<https://github.com/HashEngineering/dash-wallet>`__. The following
instructions describe how to compile an APK from source under an up-to-
date installation of Ubuntu 18.04 LTS with a single non-root user. Note
that NDK version 12b is required, instead of installing the latest
version using ``sdkmanager``. Begin by installing dependencies and
downloading the latest Android SDK Tools::

  sudo apt install openjdk-8-jdk-headless unzip make
  mkdir android-sdk-linux
  cd android-sdk-linux
  wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
  wget https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip
  unzip sdk-tools-linux-3859397.zip
  unzip android-ndk-r12b-linux-x86_64.zip

Next, update the SDK Tools and download the necessary SDK platform
bundles and dependencies, then add and load the appropriate environment
variables::

  ./tools/bin/sdkmanager --update
  ./tools/bin/sdkmanager "platforms;android-15" "platforms;android-25" "build-tools;25.0.2"
  echo 'export ANDROID_HOME=$HOME/android-sdk-linux' >> ~/.bashrc
  echo 'export ANDROID_NDK_HOME=$ANDROID_HOME/android-ndk-r12b' >> ~/.bashrc
  source ~/.bashrc
  cd ~

Now that the build environment is ready, download and build the Dash
Android Wallet source::

  git clone https://github.com/HashEngineering/dash-wallet.git
  cd dash-wallet
  ./gradlew clean build -x test

The built APK files are now available in the
``~/dash-wallet/wallet/build/outputs/apk`` folder.
