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
        echo -e "\e[1;32m Build Completed Succesfully\e[0m"
	echo -e "\e[1;32m Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)\e[0m"
   else
       echo -e "\e[0;31m Build failed\e[0m"
   fi
}
#------------------------------------------#
function upload {
sed -i "s/^kernel.string=.*/kernel.string=$kstring/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^device.name1=.*/device.name1=$dname/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^block.*/block=$block;/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^supported.versions=.*/supported.versions=/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^supported.patchlevels=.*/supported.patchlevels=/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i '/# begin ramdisk changes/,/# end ramdisk changes/d' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/toro//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/plus//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/tuna//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image.gz-dtb
cd AnyKernel3
zip -r9 $ZIPNAME * -x .git README.md
echo -e "\e[1;32m Made Flashable ZIP Succesfully\e[0m"
}
#-------------------------------------------#
#-----------------------------------------#
function ak3 {
   if [ "$ak" == "y" ]
       then
	check && upload
   else
        check
   fi
}
#------------------------------------------#

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
ak3
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
         echo -e "\e[1;32m Build Completed Succesfully\e[0m"
	echo -e "\e[1;32m Build took : $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)\e[0m"
       else
         echo -e "\e[0;31m Build failed\e[0m"
        fi
}
#------------------------------------------#
function upload {
sed -i "s/^kernel.string=.*/kernel.string=$kstring/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^device.name1=.*/device.name1=$dname/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^block=.*/block=$block/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^supported.versions=.*/supported.versions=/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s/^supported.patchlevels=.*/supported.patchlevels=/g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i '/# begin ramdisk changes/,/# end ramdisk changes/d' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/toro//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/plus//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/tuna//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image.gz-dtb
cd AnyKernel3
zip -r9 $ZIPNAME * -x .git README.md
echo -e "\e[1;32m Made Flashable ZIP Succesfully\e[0m"
}
#-------------------------------------------#
#-----------------------------------------#
function ak3 {
   if [ "$ak" == "y" ]
       then
        check && upload
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
