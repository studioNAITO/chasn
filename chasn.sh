#!/bin/bash
dldir=$(pwd)
echo $dldir

echo "chasn v1.0\n"
if [ "$1" = "install" ]
then
  echo "Welcome to (Ch)rome OS (A)ndroid (S)DK/(N)DK\n\
----------------------------------------------------------\n"
  echo "Dependencies: crew, jdk8 (via crew)\n";

  # directory
  if [ ! -d /usr/local/chasn ]
  then
    mkdir -p /usr/local/chasn;

    cp $dldir/chasn.sh $dldir/51-android.rules adb-setup.sh /usr/local/chasn;

    echo "INSTALLED: directory";
    cd /usr/local/chasn;
  else
    echo "Please uninstall first"
    exit 1;
  fi

  if [ -z "$2" ]
  then
    echo "chasn install [dl/'directory path']"
    exit 1;
  fi


  # bashrc
  echo 'export chasn=/usr/local/chasn #chasn' >> ~/.bashrc

  echo 'export ANDROID_HOME=$chasn #chasn' >> ~/.bashrc
  echo 'export ANDROID_SWT=$chasn/tools/lib/arm #chasn' >> ~/.bashrc
  echo 'export NDK_KNOWN_ABIS="armeabi-v7a armeabi-v7a-hard armeabi" #chasn' >> ~/.bashrc
  echo 'export NDK_KNOWN_ARCHS="arm x86" #chasn' >> ~/.bashrc
  echo 'export HOST_ARCH="arm" #chasn' >> ~/.bashrc

  echo "alias chasn='sh $chasn/chasn.sh'" >> ~/.bashrc
  echo "alias sdkmanager='$chasn/tools/bin/sdkmanager --sdk_root=$chasn' #chasn" >> ~/.bashrc
  echo "alias android='$chasn/tools/android' #chasn" >> ~/.bashrc

  # binaries
  if [ "$2" = "dl" ]
  then
    ggURL='https://drive.google.com/uc?export=download'  
    getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"  

    echo "DOWNLOADING: ant"
    ggID='0B3WqEY74PP5AS0ducmFxMlBNSUk' # ant
    curl -Lb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "ant.bzip2"

    echo "DOWNLOADING: arm-tools"
    ggID='0B3WqEY74PP5AZ3E5ekR4cTZCNFE' # arm-tools
    curl -Lb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "arm-tools.bzip2"

    echo "DOWNLOADING: ndk"
    ggID='0B3WqEY74PP5AZ3ZjVjRjVWZObVE' # ndk
    curl -Lb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "ndk.bzip2"
  else
    tar -xjf $2/ant.bzip2
    echo "EXTRACTED: ant"
    tar -xjf $2/arm-tools.bzip2 && mv arm-build-tools tools;
    echo "EXTRACTED: arm-tools"
    tar -xjf $2/ndk.bzip2
    echo "EXTRACTED: ndk"
  fi

  echo "\nINSTALLED: binaries\n"


  #current shell
  export chasn=/usr/local/chasn

  export ANDROID_HOME=$chasn
  export ANDROID_SWT=$chasn/tools/lib/arm
  export NDK_KNOWN_ABIS="armeabi-v7a armeabi-v7a-hard armeabi"
  export NDK_KNOWN_ARCHS="arm x86"
  export HOST_ARCH="arm"

  alias chasn='sh $chasn/chasn.sh'
  alias sdkmanager='$chasn/tools/bin/sdkmanager --sdk_root=$chasn/'
  alias android='$chasn/tools/android'

  export PATH=$PATH:$chasn/ant/bin

  echo "INSTALLED: bashrc\n"

  echo "SETUP: platform-tools\n"
  sdkmanager "platform-tools";
  echo "SETUP: complete\n"

  exit 0;
fi

if [ "$1" = "remove" ]
then
  rm -r /usr/local/chasn
  echo "removed.\n"
  exit 0;
fi

if [ "$1" = "adb" ]
then
  if [ -d /usr/local/chasn ]
  then
    sh $chasn/adb-setup.sh
  else
    echo "Please install chasn first."
  fi
fi

echo "Please run with an option: chasn.sh [install/remove/adb]\n";
exit 1;
