#!/bin/bash
BGDIR="/boot/grub/tux_background.jpg"

# check if command update-grub exists
command -v update-grub &>/dev/null || { echo "update-grub is not installed. Aborting."; exit 1; }

if [[ "$EUID" -ne 0 ]]; then
	echo "This script must be run as root (i.e: 'sudo $0')"
	exit 1
fi

echo "Setting background..."
cp ./images/tux.jpg $BGDIR

if [[ -f /etc/default/grub ]]; then
	echo "GRUB_BACKGROUND=$BGDIR" | tee -a /etc/default/grub >/dev/null
else
	echo "configuration file /etc/default/grub does not exist"
	exit 1
fi

update-grub
echo "Tux is now set as your grub background :)"
