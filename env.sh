#!/bin/bash

# Clean screen
clear

# Source vars.conf to get all the stored variables
source $sdir/vars.conf

logo

# Download & Install all the required packages and execute the next script
if [ "$buildenv" == "y" ]
	then
		echo -e "\e[1;32m ***Downloading and Installing Packages..***\e[0m"
		apt-get update
		apt-get upgrade -y
		apt-get install git bc ccache automake lzop bison gperf build-essential zip curl zlib1g-dev g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 sudo libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng libssl-dev -y
		echo -e "\e[1;32m Done !!!\e[0m";
		echo " "
		. "$sdir"/ccache.sh

# Execute next script without doing anything
elif [ "$buildenv" == "n" ]
		then
			echo " "
			. "$sdir"/ccache.sh
else
	echo "Please enter y or n only."
	. "$sdir"/env.sh
fi
