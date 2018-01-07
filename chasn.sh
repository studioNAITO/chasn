#!/bin/bash
dldir=$(pwd)

echo "chasn v1.0\n"



if [ "$1" = "fetch" ]
then
  # directory
  if [ ! -d /usr/local/chasn ]
  then
    mkdir -p /usr/local/chasn;
    mkdir /usr/local/chasn/build-tools;

    cp $dldir/chasn.sh $dldir/51-android.rules adb-setup.sh /usr/local/chasn;

    echo "INSTALLED: directory";
    cd /usr/local/chasn;
  #else
    #echo "Please uninstall first"
    #exit 1;
  fi

  chasn=/usr/local/chasn
  touch $chasn/gcokie

  # binaries
  ggURL='https://drive.google.com/uc?export=download'  

  echo "DOWNLOADING: ant"
  ggID='0B3WqEY74PP5AS0ducmFxMlBNSUk' # ant
  filename="$(curl -sc $chasn/gcokie "${ggURL}&id=${ggID}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')"
  getcode="$(awk '/_warning_/ {print $NF}' $chasn/gcokie)"  
  curl -Lb $chasn/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "ant.bzip2"

  echo "DOWNLOADING: arm-tools"
  ggID='0B3WqEY74PP5AZ3E5ekR4cTZCNFE' # arm-tools
  filename="$(curl -sc $chasn/gcokie "${ggURL}&id=${ggID}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')"
  getcode="$(awk '/_warning_/ {print $NF}' $chasn/gcokie)"  
  curl -Lb $chasn/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "arm-tools.bzip2"

  echo "DOWNLOADING: ndk"
  ggID='0B3WqEY74PP5AZ3ZjVjRjVWZObVE' # ndk
  filename="$(curl -sc $chasn/gcokie "${ggURL}&id=${ggID}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')"
  getcode="$(awk '/_warning_/ {print $NF}' $chasn/gcokie)"  
  curl -Lb $chasn/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -o "ndk.bzip2"

  echo "DOWNLOADED: binaries"

  rm $chasn/gcokie
fi

if [ "$1" = "install" ]
then
  echo "Welcome to (Ch)rome OS (A)ndroid (S)DK/(N)DK\n\
----------------------------------------------------------\n"
  echo "Dependencies: crew, jdk8 (via crew)\n";


  # bashrc
  echo 'export chasn=/usr/local/chasn #chasn' >> ~/.bashrc

  echo "export ANDROID_HOME=$chasn #chasn" >> ~/.bashrc
  echo "export ANDROID_SWT=$chasn/tools/lib/arm #chasn" >> ~/.bashrc
  echo 'export NDK_KNOWN_ABIS="armeabi-v7a armeabi-v7a-hard armeabi" #chasn' >> ~/.bashrc
  echo 'export NDK_KNOWN_ARCHS="arm x86" #chasn' >> ~/.bashrc
  echo 'export HOST_ARCH="arm" #chasn' >> ~/.bashrc

  echo "alias chasn='sh $chasn/chasn.sh' #chasn" >> ~/.bashrc
  echo "alias sdkmanager='$chasn/tools/bin/sdkmanager --sdk_root=$chasn' #chasn" >> ~/.bashrc
  echo "alias android='$chasn/tools/android' #chasn" >> ~/.bashrc
  echo "alias ant='$chasn/ant/bin/ant' #chasn" >> ~/.bashrc

  #current shell
  export chasn=/usr/local/chasn

  export ANDROID_HOME=$chasn
  export ANDROID_SWT=$chasn/tools/lib/arm
  export NDK_KNOWN_ABIS="armeabi-v7a armeabi-v7a-hard armeabi"
  export NDK_KNOWN_ARCHS="arm x86"
  export HOST_ARCH="arm"

  alias chasn="sh $chasn/chasn.sh"
  alias sdkmanager="$chasn/tools/bin/sdkmanager --sdk_root=$chasn/"
  alias android="$chasn/tools/android"
  alias ant="$chasn/ant/bin/ant" #chasn

  export PATH=$PATH:$chasn/ant/bin

  echo "INSTALLED: bashrc\n"
  
  echo "EXTRACTING: ant"
  tar -xjf $chasn/ant.bzip2
  echo "EXTRACTED: ant"
  echo "EXTRACTING: arm-tools"
  tar -xjf $chasn/arm-tools.bzip2 && mv arm-build-tools tools;
  echo "EXTRACTED: arm-tools"
  echo "EXTRACTING: ndk"
  tar -xjf $chasn/ndk.bzip2
  echo "EXTRACTED: ndk"

  ln -s $chasn/tools $chasn/build-tools/25.0.2

  #echo "SETUP: platform-tools\n"
  #sdkmanager "platform-tools";
  #echo "SETUP: complete\n"

  exit 0;
fi

if [ "$1" = "remove" ]
then
  rm -r /usr/local/chasn
  cp ~/.bashrc ~/.bashrc_backup
  sed '/#chasn/,/^/d' < ~/.bashrc > ~/.bashrc
  echo "removed.\n"
  exit 0;
fi

if [ "$1" = "adb" ]
then
  if [ -d /usr/local/chasn ]
  then
    sh $chasn/adb-setup.sh
    echo "ADB is ready for use."
    exit 0;
  fi
fi

echo "Please run with an option: chasn.sh [fetch/install/remove/adb]\n";
exit 1;
