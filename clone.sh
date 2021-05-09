#!/bin/bash

# Clean screen
clear

# Source vars.conf to get all the stored variables
source $sdir/vars.conf
cd $sdir
logo

# Clone kernel source, toolcahins and anykernel3 and execute the next script
if [ "$clone" == "y" ]
	then
		echo -e "\e[1;32m ***Cloning Kernel***\e[0m"
		git clone --progress "$kernelurl" -b "$kernelbranch" kernel
		echo -e "\e[1;32m Done !!!\e[0m"
		echo " "
		if [ ! -d "$sdir/kernel" ]
then
	echo "Kernel Source Doesn't Exist. Please Check URL"
	return 1;
fi
clear
logo
		echo -e "\e[1;32m ***Cloning Toolchains***\e[0m"
		cd kernel
		KERNEL_DIR=`pwd`
		git clone --progress -j$(nproc --all) --depth 5 --no-single-branch https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9.git
		git clone --progress -j$(nproc --all) --depth 5 --no-single-branch https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9
		git clone -j$(nproc --all) --depth 1  https://github.com/osm0sis/AnyKernel3
		if [ "$use_clang" == "y" ]
        	then
	        git clone -j$(nproc --all) --depth 1 https://github.com/Panchajanya1999/clang-llvm.git -b 8.0
        	elif [ "$use_clang" == "n" ]
	        then
                echo "Not cloning clang as it was not selected"
		fi
		cd $KERNEL_DIR
		echo -e "\e[1;32m Done !!!\e[0m"
		echo " "
		. "$sdir"/build.sh
	elif [ "$clone" == "n" ]
	then
		if [ -d "$sdir/kernel" ]
		then
		echo -e "\e[1;32m ***Cloning Toolchains***\e[0m"
                cd kernel
                KERNEL_DIR=`pwd`
                git clone --progress -j$(nproc --all) --depth 5 --no-single-branch https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9.git
		git clone --progress -j$(nproc --all) --depth 5 --no-single-branch https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9
                git clone --depth 1 -j$(nproc --all) https://github.com/osm0sis/AnyKernel3
                if [ "$use_clang" == "y" ]
                then
                git clone -j$(nproc --all) --depth 1 https://github.com/Panchajanya1999/clang-llvm.git -b 8.0
                elif [ "$use_clang" == "n" ]
                then
                echo "Not cloning clang as it was not selected"
                fi
                cd aarch64-linux-android-4.9
                git reset --hard 22f053ccdfd0d73aafcceff3419a5fe3c01e878b
                cd $KERNEL_DIR/arm-linux-androideabi-4.9
                git reset --hard 42e5864a7d23921858ca8541d52028ff88acb2b6
                cd $KERNEL_DIR
                echo -e "\e[1;32m Done !!!\e[0m"
                echo " "
                . "$sdir"/build.sh
		else
		echo "Error: kernel directory does not exist. Aborting ....."
		return 1
		fi
fi
