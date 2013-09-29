#!/bin/bash

# Stupid shell script to compile kernel, nothing fancy

((!$#)) && echo -e "No arugments supplied!\nTry 'config', 'menuconfig' or value of '1-9'" && exit 1


VERSION=`cat .version`
NEWVERSION=$(expr $VERSION + 1)

# Exports all the needed things Arch, SubArch and Cross Compile
export ARCH=arm
echo 'exporting Arch'
export SUBARCH=arm
echo 'exporting SubArch'

##GCC 4.8
#export CROSS_COMPILE=/media/dev/android-ndk-r9/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-

##Linaro 4.7 2013.04
export CROSS_COMPILE=/home/ubu/dev/kernel/toolchains/gcc-linaro-4.7-2013.04/bin/arm-linux-gnueabihf-

##Linaro 4.8
#export CROSS_COMPILE=/home/ubu/dev/kernel/toolchains/gcc-linaro-4.8-2013.08/bin/arm-linux-gnueabihf-

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

# Generates a new .config and exists
if [ "$1" = "menuconfig" ] ; then
	echo 'Making defconfig for Mako and launching menuconfig'
	make slim_mako_defconfig
	make menuconfig
	cp .config arch/arm/configs/slim_mako_defconfig
	exit
fi

# Exports kernel local version? Not sure yet.
#echo 'Exporting kernel version'
#export LOCALVERSION='SlimTest_1.0'

#Let's check if $1 is a number
re='^[0-9]+$'
if [[ $1 =~ $re ]] ; then
	# Lets go!
	echo 'Lets start!'
	#make -j$1
	make -j$1 V=99 2>&1 |tee build-r$NEWVERSION.log
else
	echo "Insert proper argument!"
fi
