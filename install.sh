#!/bin/bash
BG="/boot/grub/tux_background.jpg"

# check if command update-grub exists
command -v update-grub &>/dev/null || { echo "update-grub is not installed. Aborting."; exit 1; }

if [[ "$EUID" -ne 0 ]]; then
	echo "This script must be run as root (i.e: 'sudo $0')"
	exit 1
fi

installation=true
# uninstall the background
if [[ $1 == "--uninstall" ]]; then
	installation=false
	echo "Uninstalling the background..."
	echo "Bye bye Tux :'("
	rm "$BG"
	if [[ -f /etc/default/grub ]]; then
		sed -i "/$GRUB_BACKGROUND/d" /etc/default/grub
	fi
# install the background
else
	echo "Setting background..."
	cp ./images/tux.jpg $BG

	if [[ -f /etc/default/grub ]]; then
		echo "GRUB_BACKGROUND=$BG" | tee -a /etc/default/grub >/dev/null
	else
		echo "configuration file /etc/default/grub does not exist"
		exit 1
	fi
fi

update-grub

if [ $installation -eq 1 ]; then
	echo "Tux is now set as your grub background :)"
else
	printf "\033[31mTux is gone\033[0m\n"
fi
