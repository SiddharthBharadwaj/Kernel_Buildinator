#!/bin/bash
#This file takes  all the user input as  variables and send them to vars.conf

# Clean screen
clear

# Source vars.conf to get LOGO
source $PWD/vars.conf

# Save and export current working DIR to $sdir
sdir=$(pwd)
export sdir

# Check OS type & Distro. Then save it as a variable
distro=$(awk -F= '$1 == "ID" {print $2}' /etc/os-release)

logo

if [[ "$distro" == "arch" ]]; then
       echo "Arch Linux Detected"
fi

# Ask User For Input
echo -e "\e[1;34m Should I download and install required packages (y/n) ?\e[0m"

# Read User Input and Save it into a variable
read -r buildenv
# Send the variable to vars.conf
sed -i -e"s/^buildenv=.*/buildenv=$buildenv/g" "$sdir/vars.conf"
clear
logo
echo -e "\e[1;34m Should I setup CCACHE (y/n) ?\e[0m"
read -r set_ccache
sed -i -e"s/^set_ccache=.*/set_ccache=$set_ccache/g" "$sdir/vars.conf"
clear
logo
echo -e "\e[1;34m Should I Clone Kernel Source (y/n) ?\e[0m"
read -r clone
sed -i -e"s/^clone=.*/clone=$clone/g" "$sdir/vars.conf"
clear
logo
if [ "$clone" == "y" ]
	then
		read -p  "Please Enter The Git URL of Kernel Source: " kernelurl
		sed -i -e"s|^kernelurl=.*|kernelurl=$kernelurl|g" "$sdir/vars.conf"
		read -p "Please Enter The Branch to Clone: " kernelbranch
		sed -i -e"s/^kernelbranch=.*/kernelbranch=$kernelbranch/g" "$sdir/vars.conf"
	elif [ "$clone" == "n" ]
	then
		echo " "
else
	echo "Please enter y or n only."
	return 1
fi
clear
logo
echo -e "\e[1;32m Kernel Variables\e[0m"
read -p "Create AnyKernel3 Flashable Kernel Zip (y/n) ?" ak
sed -i -e"s/^ak=.*/ak=$ak/g" "$sdir/vars.conf"
clear
logo
if [ "$ak" == "y" ]
        then
                read -p "Enter Kernel ZIP name: " ZIPNAME
		sed -i -e"s/^ZIPNAME=.*/ZIPNAME=$ZIPNAME/g" "$sdir/vars.conf"
		read -p "Enter kernel.string (example: KernelName by YourName)" kstring
                sed -i -e"s/^kstring=.*/kstring=$kstring/g" "$sdir/vars.conf"
		read -p "Enter Device Name (For device check)" dname
		sed -i -e"s/^dname=.*/dname=$dname/g" "$sdir/vars.conf"
        elif [ "$ak" == "n" ]
        then
                echo " "
else
        echo "Please enter y or n only."
        return 1
fi
clear
logo
read -p "Enter KBUILD_BUILD_USER name: " kbuild_u
sed -i -e"s/^kbuild_u=.*/kbuild_u=$kbuild_u/g" "$sdir/vars.conf"
clear
logo
read -p "Enter KBUILD_BUILD_HOST name: " kbuild_h
sed -i -e"s/^kbuild_h=.*/kbuild_h=$kbuild_h/g" "$sdir/vars.conf"
clear
logo
echo "Select ARCH" 
echo "1.arm64  2.arm"
read -r arch
clear
logo
if [ "$arch" == 1 ] || [ "$arch" == arm64 ]
	then
	archf=arm64
	sed -i -e"s/^archf=.*/archf=$archf/g" "$sdir/vars.conf"
elif [ "$arch" == 2 ] || [ "$arch" == arm ]
	then
	archf=arm
	sed -i -e"s/^archf=.*/archf=$archf/g" "$sdir/vars.conf"
else 
	echo "Please enter a valid option"
	return 1
fi
clear
logo
echo "Enter SUBARCH" 
echo "1.arm64  2.arm"
read -r sarch
clear
logo
if [ "$sarch" == 1 ] || [ "$sarch" == arm64 ]
	then
	sarchf=arm64
	sed -i -e"s/^sarchf=.*/sarchf=$sarchf/g" "$sdir/vars.conf"
elif [ "$sarch" == 2 ] || [ "$sarch" == arm ]
	then
	sarchf=arm
	sed -i -e"s/^sarchf=.*/sarchf=$sarchf/g" "$sdir/vars.conf"
else 
	echo "Please enter a valid option"
	return 1
fi
clear
logo
read -p "Enter DEFCONFIG name: " defconfig_name
sed -i -e"s/^defconfig_name=.*/defconfig_name=$defconfig_name/g" "$sdir/vars.conf"
clear
logo
read -p "Use Clang for Compilation (y/n) ?" use_clang
if [ "$use_clang" == "y" ]
        then
	sed -i -e"s/^use_clang=.*/use_clang=$use_clang/g" "$sdir/vars.conf"
	# Execute the next script
	. "$sdir"/ccache.sh

        elif [ "$use_clang" == "n" ]
        then
                sed -i -e"s/^use_clang=.*/use_clang=$use_clang/g" "$sdir/vars.conf"
		. "$sdir"/ccache.sh
else
        echo "Please enter y or n only."
        return 1
fi

