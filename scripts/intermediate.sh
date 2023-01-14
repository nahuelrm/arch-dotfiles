#!/bin/bash

function replace_text(){
	# $1 full path to file
	# $2 string to replace
	# $3 new text
	
	sed -i -e "s/$2/$3/g" $1
}

user=$1

# git clone on arch-install.sh

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak
cp /mnt/home/$user/.bashrc /mnt/home/$user/.bashrc.bak
cp /mnt/usr/lib/systemd/system/getty@.service /mnt/root/getty@.service.bak

replace_text /mnt/etc/sudoers "%wheel ALL=(ALL:ALL) ALL" "# %wheel ALL=(ALL:ALL) ALL"
replace_text /mnt/etc/sudoers "# %wheel ALL=(ALL:ALL) NOPASSWD: ALL" "%wheel ALL=(ALL:ALL) NOPASSWD: ALL"

replace="ExecStart=-/sbin/agetty -o '-p -f -- \\\u' --noclear --autologin $user %I \$TERM"
sed -i "s|.*ExecStart.*|$replace|" "/mnt/usr/lib/systemd/system/getty@.service"

echo "/home/$user/entorno/scripts/post-install.sh 1 1" >> /mnt/home/$user/.bashrc
