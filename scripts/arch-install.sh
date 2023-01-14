#!/bin/bash

#Colors
green="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
cyan="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"


# Functions

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${red}[!] Exiting...\n${endColor}"

	exit 1;
}

function replace_text(){
	# $1 full path to file
	# $2 string to replace
	# $3 new text
	
	sed -i -e "s/$2/$3/g" $1
}


#
# Arch Linux Installation
#

# Create Partitions

fdisk -l
clear; echo -e "${gray}Enter disk name (example: /dev/sda):${endColor}"; read disk_name
efi_size="550M"
clear; echo -e "${yellow}Remember that efi partition size is assigned automatically, and root partition will occupy the rest of the disk.\n${gray}Enter swap partition size. Example ('4G'):${endColor}"; read swap_size

clear; echo -e "${gray}Enter hostname:${endColor}"; read hostname
clear; echo -e "${gray}Enter username:${endColor}"; read user
clear; echo -e "${gray}Enter ${cyan}$user${gray} password:${endColor}"; read user_password
clear; echo -e "${gray}Enter ${cyan}root${gray} password:${endColor}"; read root_password


(echo "g"; sleep 1; echo "n"; sleep 1; echo ""; sleep 1; echo ""; sleep 1; echo "+$efi_size"; sleep 1; echo "n"; sleep 1; echo ""; sleep 1; echo""; sleep 1; echo "+$swap_size"; sleep 1; echo "n"; sleep 1; echo ""; sleep 1; echo ""; sleep 1; echo ""; sleep 1; echo "t"; sleep 1; echo "1"; sleep 1; echo "1"; sleep 1; echo "t"; sleep 1; echo "2"; sleep 1; echo "19"; sleep 1; echo "w") | fdisk -W always $disk_name


# Format partitions

mkfs.ext4 $(echo "$disk_name""3")
mkfs.fat -F 32 $(echo "$disk_name""1")
mkswap $(echo "$disk_name""2")
swapon $(echo "$disk_name""2")


# Mount partitions

mount $(echo "$disk_name""3") /mnt
mkdir /mnt/boot
mount $(echo "$disk_name""1") /mnt/boot


# Install kernel and start setup

pacman-key --init
pacman-key --populate archlinux
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt > /mnt/etc/fstab

# Variables
time_zone="America/Buenos_Aires"
locale="#en_US.UTF-8 UTF-8"
locale2="en_US.UTF-8 UTF-8"
locale3="en_US.UTF-8"
bootloader_id="blackarch"

# TODO: simplificar los pacman

cat <<EOF > /mnt/root/install.sh
#!/bin/bash

ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime
hwclock --systohc
yes '' | pacman -S neovim

sed -i -e "s/$locale/$locale2/g" /etc/locale.gen

locale-gen

echo "LANG=$locale3" > /etc/locale.conf

echo $hostname > /etc/hostname

echo -en "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.0.1\t$hostname.localhost $hostname" >> /etc/hosts

(echo $root_password; echo $root_password) | passwd
useradd -m $user
(echo $user_password; echo $user_password) | passwd $user
usermod -aG wheel,audio,video,optical,storage $user

yes '' | pacman -S sudo

sed -i -e "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g" /etc/sudoers

yes '' | pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager wpa_supplicant base-devel git

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$bootloader_id --recheck

grub-mkconfig -o /boot/grub/grub.cfg

if [ $1 == true ]; then
	git clone https://github.com/nahuelrm/entorno /home/$user/entorno
fi

systemctl enable NetworkManager
systemctl enable wpa_supplicant.service

EOF

chmod +x /mnt/root/install.sh 

arch-chroot /mnt /root/install.sh

rm /mnt/root/install.sh

if [ "$1" == true ]; then
	/tmp/intermediate.sh $user
fi

umount -R /mnt

echo -e "${green}Installation finished successfully! The system will reboot...${endColor}"
sleep 2

reboot
