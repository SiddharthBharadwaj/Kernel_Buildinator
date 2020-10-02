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
export KBUILD_BUILD_HOST="$kbuild_h"
export ARCH="$archf"
export SUBARCH="$sarchf"
export CROSS_COMPILE=$sdir/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$sdir/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
PATH=$sdir/clang-llvm/bin/:$sdir/aarch64-linux-android-4.9/bin/:$PATH
export PATH
#-----------------------------------------#
function check {
   if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/zImage ]
       then
        echo -e "\e[1;32m Build Completed Succesfully\e[0m"
	       echo -e "\e[1;32m Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)\e[0m"
   else
       echo -e "\e[0;31m Build failed\e[0m"
   fi
}
#-----------------------------------------#
function ak3 {
   if [ "$ak" == "y" ] && [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/zImage ]
       then
	check
  . $sdir/anykernel.sh
   else
        check
   fi
}
#------------------------------------------#

make clean && make mrproper O=out
BUILD_START=$(date +"%s")
make  O=out $defconfig_name
make -j$(nproc --all) CC=$sdir/clang-llvm/bin/clang CLANG_TRIPLE=aarch64-linux-gnu- O=out
#------#
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
ak3
return 1

# Start the build without clang
elif [ "$use_clang" == n ]
then
export KBUILD_BUILD_USER="$kbuild_u"
export KBUILD_BUILD_HOST="kbuild_h"
export ARCH="$archf"
export SUBARCH="$sarchf"
export CROSS_COMPILE=$sdir/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$sdir/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
#-----------------------------------------#
function check {
   if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/zImage ]
       then
         echo -e "\e[1;32m Build Completed Succesfully\e[0m"
	       echo -e "\e[1;32m Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)\e[0m"
       else
         echo -e "\e[0;31m Build failed\e[0m"
        fi
}
#-----------------------------------------#
function ak3 {
   if [ "$ak" == "y" ] && [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ] || [ -f $KERNEL_DIR/out/arch/arm/boot/zImage ]
       then
        check
        . $sdir/anykernel.sh
   else
        check
   fi
}
#------------------------------------------#
make clean && make mrproper O=out
BUILD_START=$(date +"%s")
make  O=out $defconfig_name
make -j$(nproc --all) O=out \
#------#
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
ak3
return 1

else
	return 1
fi
