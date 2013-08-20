#!/bin/bash

# Stupid shell script to compile kernel, nothing fancy

VERSION=`cat .version`
NEWVERSION=$(expr $VERSION + 1)

# Exports all the needed things Arch, SubArch and Cross Compile
export ARCH=arm
echo 'exporting Arch'
export SUBARCH=arm
echo 'exporting SubArch'
#export CROSS_COMPILE=/home/prbassplayer/WIP4.3/prebuilt/linux-x86/toolchain/linaro/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=/media/dev/android-ndk-r9/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
#export CROSS_COMPILE=/home/prbassplayer/WIP/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-
echo 'exporting Cross Compile'

# Make sure build is clean!
echo "Removing old zImage"
rm -f arch/arm/boot/zImage
echo 'Cleaning build'
make clean

# Generates a new .config and exists
if [ "$1" = "config" ] ; then
echo 'Making defconfig for Mako'
make slim_mako_defconfig
exit
fi

# Exports kernel local version? Not sure yet.
#echo 'Exporting kernel version'
#export LOCALVERSION='SlimTest_1.0'

# Lets go!
echo 'Lets start!'
#make -j$1
make -j$1 V=99 2>&1 |tee build-r$NEWVERSION.log
