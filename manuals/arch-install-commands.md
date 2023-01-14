# **Arch linux installation**

If you want an **encrypted** installation, you must follow the instructions signaled with **[For encrypted intallation]** marks, instead if you want an **unencrypted**installation, follow the **[For unencrypted intallation]** marks.

<br>

## Check efivars

```
# ls /sys/firmware/efi/efivars
```

_if the directory doesn't exist you don't have efi setted up properly, so you must solve it_

<br>

## Connect to internet

If you use wifi you can connect as follows...

To get an interactive prompt do: 
```
# iwctl
```
First, if you do not know your wireless device name, list all Wi-Fi devices: 
```
[iwd]# device list
```
Then, to initiate a scan for networks (note that this command will not output anything): 
```
[iwd]# station device scan
```
You can then list all available networks: 
```
[iwd]# station device get-networks
```
Finally, to connect to a network: 
```
[iwd]# station device connect SSID
```
<br>
<br>

Alternatively, you can supply it as a command line argument:

```
$ iwctl --passphrase passphrase station device connect SSID
```

<br>
<br>

After the installation you can connect to internet with the following command:
```
# nmcli dev wifi connect "BSSID" password PASS
```

<br>

## Make disks partitions

<br>

To view disks and partitions:

```
# fdisk -l
```

We are going to create 3 partitions

```
fdisk /dev/DISK
```

```
Command (m for help): g     //Create a new GPT partition table:

Command (m for help): n 	// Create new partition
Command (m for help): 1
Command (m for help): <press any key>
Command (m for help): +550M 

Command (m for help): n 	// Create new partition
Command (m for help): 2
Command (m for help): <press any key>
Command (m for help): +4G	// You can give the swap partition the size
							you preffer as it is an optional partition

Command (m for help): n 	// Create new partition
Command (m for help): 3
Command (m for help): <press any key>
Command (m for help): <press any key> 	// Press any key to give 
										all the rest of disk space
```

now we are going to set up the partitions types
```
Command (m for help): t
Command (m for help): 1
Command (m for help): 1		// EFI system type

Command (m for help): t
Command (m for help): 2
Command (m for help): 19	// swap partition type
```

Finally, to write changes:

```
Command (m for help): w
```

<br>

## Format partitions

<br>

**[For encrypted intallation]**

```
# cryptsetup -y -v luksFormat /dev/<root-partition>
# cryptsetup open /dev/<root-partition> <cryptName, e.g. cryptroot> 
# mkfs.ext4 /dev/<root-partition>
```

**[For unencrypted intallation]**
```
# mkfs.ext4 /dev/<root-partition>
```

<br>

**Continuation for both installations...**

```
# mkfs.fat -F 32 /dev/<efi-partition>
```

```
# mkswap /dev/<swap-partition>
# swapon /dev/<swap-partition>
```

<br>

## Mount the file system

<br>

```
(for encrypted) 	# mount /dev/mapper/<cryptName> /mnt
(for unencrypted) 	# mount /dev/<root-partition> /mnt

# mkdir /mnt/boot
# mount /dev/<efi-partition> /mnt/boot
```

<br>

## Install linux kernel

<br>

```
# pacstrap -K /mnt base linux linux-firmware
```

<br>

## Create fstab

<br>

```
# genfstab -U /mnt > /mnt/etc/fstab
```

After that, you can check results in /mnt/etc/fstab and edit the file in case of errors

```
# cat /mnt/etc/fstab
```

<br>

## Continue configuration

<br>

```
# arch-chroot /mnt
```

```
# ln -sf /usr/share/zoneinfo/<Region>/<City> /etc/localtime

# hwclock --systohc

# pacman -S neovim

# nvim /etc/locale.gen   //uncomment the locale you use, 
						in my case en_US.UTF-8 UTF-8

# locale-gen			// generate locale

# nvim /etc/locale.conf
	// add this, with your exact locale, in my case "en_US.UTF-8"
	LANG=en_US.UTF-8 
```

<br>

## Network configuration

<br>

```
# nvim /etc/hostname
	// just add a word as a hostname

# nvim /etc/hosts
	//add this below:

	127.0.0.1	localhost
	::1			localhost
	127.0.1.1	<hostname>.localhost	<hostname>
```

<br>

## Set up passwords and users

<br>

```
# passwd   // password for root user

# useradd -m <new-username>

# passwd <username>

# usermod -aG wheel,audio,video,optical,storage <username>
```

## Install and configure sudo permissions

```
# pacman -S sudo

# EDITOR=nvim visudo
	// uncomment the line below this comment: 
	
	## Uncomment to allow members of group wheel to execute any command
	%wheel ALL=(ALL) ALL
```

if you use spanish keyboard execute de following command

```
# loadkeys es 	

# nvim /etc/vconsole.conf
	// add this line
	KEYMAP=es   
```

<br>

## Install and configure grub

<br>

```
# pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager wpa_supplicant base-devel
```

**[For encrypted intallation]**
```
# nvim /etc/mkinitcpio.conf 
	// edit this line as it is below
			HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)

# mkinitcpio -p linux

# blkid or lsblk -f   // to view UUID of the encrypted partition

# nvim /etc/default/grub
	// edit this line as it is below 		
	GRUB_CMDLINE_LINUX="cryptdevice=UUID=<uuid>:<cryptName> root=/dev/mapper/<cryptName>"
```

**Continuation for both installations...**

```
# grub-install --target=x86_64-efi --efi-directory=<efi-directory-path> --bootloader-id=<any name you like> --recheck
	// in this case our --efi-directory=/boot

	// if we are installing arch linux in a pendrive we add the --removable flag before --recheck flag

# grub-mkconfig -o /boot/grub/grub.cfg
```

<br>

## Final settings 

<br>

Enable network services:

```
# systemctl enable NetworkManager
# systemctl enable wpa_supplicant.service
```

Enable synchronize time:

```
# timedatectl set-ntp true
```

Finish installation...

```
# exit

# umount -R /mnt

# shutdown now
```
