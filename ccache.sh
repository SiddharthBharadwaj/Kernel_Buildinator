#!/bin/bash

# Clean screen
clear

# Source vars.conf to get all the stored variables
source "$sdir"/vars.conf

logo

# Setup CCACHE & Execute the next script
if [ "$set_ccache" == "y" ]
	then
		echo -e "\e[1;32m ***Setting Up CCACHE***\e[0m"
		export CCACHE_DIR="$HOME/.ccache"
		export CC="ccache gcc"
		export CXX="ccache g++"
		export PATH="/usr/lib/ccache:$PATH"
		ccache -M 5G
		echo -e "\e[1;32m Done !!!\e[0m"
		echo " "
		. "$sdir"/clone.sh

# Execute next script without setting up CCACHE
elif [ "$set_ccache" == "n" ]
		then
			echo " "
			. "$sdir"/clone.sh
fi
