#!/bin/bash

# Clean screen
clear

# Source vars.conf to get all the stored variables
source $sdir/vars.conf
logo
KERNEL_DIR=`pwd`
cd $KERNEL_DIR
echo -e "\e[1;32m ***Building Kernel..***\e[0m"

# Start the build with clang
if [ "$use_clang" == y ]
then
export KBUILD_BUILD_USER="$kbuild_u"
export KBUILD_BUILD_HOST="kbuild_h"
export ARCH="$archf"
export SUBARCH="$sarchf"
export CFLAGS="-w"
export CXXFLAGS="-w"
export CROSS_COMPILE=$KERNEL_DIR/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$KERNEL_DIR/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
PATH=$KERNEL_DIR/clang-llvm/bin/:$KERNEL_DIR/aarch64-linux-android-4.9/bin/:$PATH
export PATH
#-----------------------------------------#
function check {
   if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/Image.gz-dtb ]
       then
         upload
       else
         echo "Build failed"
        fi 
}
#------------------------------------------#
function upload {
mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image.gz-dtb
cd AnyKernel3
zip -r9 $ZIPNAME * -x .git README.md
echo "Build Completed Succesfully"
echo "Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)"
}
#-------------------------------------------#
make clean && make mrproper O=out
BUILD_START=$(date +"%s")
make  O=out $defconfig_name
make -j$(nproc --all) O=out \
CROSS_COMPILE=aarch64-linux-android- 2>&1 | tee error.log \
CROSS_COMPILE_ARM32=arm-linux-androideabi- \
CC=clang \
CLANG_TRIPLE=aarch64-linux-gnu- 2>&1| tee error.log
#------#
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
check
return 1

# Start the build without clang
elif [ "$use_clang" == n ]
then
export KBUILD_BUILD_USER="$kbuild_u"
export KBUILD_BUILD_HOST="kbuild_h"
export ARCH="$archf"
export SUBARCH="$sarchf"
export CFLAGS="-w"
export CXXFLAGS="-w"
export CROSS_COMPILE=$KERNEL_DIR/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$KERNEL_DIR/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
#-----------------------------------------#
function check {
   if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/Image.gz-dtb ]
       then
         upload
       else
         echo "Build failed"
        fi
}
#------------------------------------------#
function upload {
mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image.gz-dtb
cd AnyKernel3
zip -r9 $ZIPNAME * -x .git README.md
echo "Build Completed Succesfully"
echo "Build Completed Succesfully"
echo "Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)"
}
#-------------------------------------------#
make clean && make mrproper O=out
BUILD_START=$(date +"%s")
make  O=out $defconfig_name
make -j$(nproc --all) O=out \
#------#
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
check
return 1

else
	return 1
fi
