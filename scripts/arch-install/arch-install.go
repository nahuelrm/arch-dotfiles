package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"os/exec"
	"strings"
)

var user, userPassword, rootPassword, bootloaderid, hostname, diskName, swapSize, auxStr string
var removable bool

func main() {
	var command string

	// Initial validations
	_, err := net.Dial("tcp", "www.google.com:80")
	if err != nil {
		fmt.Println("You need internet connection to run this script.")
		os.Exit(0)
	}

	if _, err := os.Stat("/sys/firmware/efi/efivars"); os.IsNotExist(err) {
		fmt.Printf("You need efi support to run this script. You are currently in BIOS mode.")
		os.Exit(0)
	}

	optionsSetup()

	// Partitions
	command = "(echo 'g'; sleep 0.3; echo 'n'; sleep 0.3; echo ''; sleep 0.3; echo ''; sleep 0.3; echo '+550M'; sleep 0.3; echo 'n'; sleep 0.3; echo ''; sleep 0.3; echo''; sleep 0.3; echo '+" + swapSize + "'; sleep 0.3; echo 'n'; sleep 0.3; echo ''; sleep 0.3; echo ''; sleep 0.3; echo ''; sleep 0.3; echo 't'; sleep 0.3; echo '1'; sleep 0.3; echo '1'; sleep 0.3; echo 't'; sleep 0.3; echo '2'; sleep 0.3; echo '19'; sleep 0.3; echo 'w') | fdisk -W always " + diskName
	runCommand(command)

	command = "mkfs.ext4 " + diskName + "3"
	runCommand(command)

	command = "mkswap " + diskName + "2"
	runCommand(command)

	command = "swapon " + diskName + "2"
	runCommand(command)

	command = "mkfs.vfat -F32 " + diskName + "1"
	runCommand(command)

	command = "mount " + diskName + "3 /mnt"
	runCommand(command)

	command = "mkdir /mnt/boot"
	runCommand(command)

	command = "mount " + diskName + "1 /mnt/boot"
	runCommand(command)

	// Pacman keys validity setup
	command = "pacman-key --init"
	runCommand(command)

	command = "pacman-key --populate archlinux"
	runCommand(command)

	command = "yes '' | pacman -Sy archlinux-keyring"
	runCommand(command)

	// Linux kernel
	command = "yes '' | pacstrap -K /mnt base linux linux-firmware"
	runCommand(command)

	command = "genfstab -U /mnt > /mnt/etc/fstab"
	runCommand(command)

	// arch-chroot commands

	archChroot := "arch-chroot /mnt bash -c \""

	command = "yes '' | pacman -S neovim sudo grub efibootmgr dosfstools mtools os-prober base-devel wpa_supplicant networkmanager git"
	runCommand(archChroot + command + "\"")

	// Timezone & locale
	command = "ln -sf /usr/share/zoneinfo/America/Buenos_Aires" //TODO: do it well
	runCommand(archChroot + command + "\"")

	command = "hwclock --systohc"
	runCommand(archChroot + command + "\"")

	command = "sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen" //TODO: do it well
	runCommand(archChroot + command + "\"")

	command = "locale-gen"
	runCommand(archChroot + command + "\"")

	command = "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
	runCommand(archChroot + command + "\"")

	// Hostname and hosts files
	command = "echo '" + hostname + "' > /etc/hostname"
	runCommand(archChroot + command + "\"")

	command = "echo -ne \"127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.0.1\t" + hostname + ".localhost " + hostname + "\" >> hosts"
	runCommand(archChroot + command + "\"")

	// Users and passwords
	command = "(echo " + rootPassword + "; echo " + rootPassword + ") | passwd"
	runCommand(archChroot + command + "\"")

	command = "useradd -m " + user
	runCommand(archChroot + command + "\"")

	command = "(echo " + userPassword + "; echo " + userPassword + ") | passwd " + user
	runCommand(archChroot + command + "\"")

	command = "usermod -aG wheel,audio,video,optical,storage " + user
	runCommand(archChroot + command + "\"")

	command = "sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers"
	runCommand(archChroot + command + "\"")

	// Grub installation
	if removable {
		command = "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=" + bootloaderid + " --removable --recheck"
		runCommand(archChroot + command + "\"")
	} else {
		command = "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=" + bootloaderid + " --recheck"
		runCommand(archChroot + command + "\"")
	}

	command = "grub-mkconfig -o /boot/grub/grub.cfg"
	runCommand(archChroot + command + "\"")

	command = "systemctl enable NetworkManager"
	runCommand(archChroot + command + "\"")

	command = "systemctl enable wpa_supplicant"
	runCommand(archChroot + command + "\"")
}

func runCommand(command string) {
	cmd := exec.Command("bash", "-c", command)
	stdout, _ := cmd.StdoutPipe()
	cmd.Start()
	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
	cmd.Wait()
}

func optionsSetup() {
	var command string

	command = "clear"
	runCommand(command)
	for len(diskName) == 0 {
		fmt.Print("Enter the disk name (example: /dev/sda): ")
		fmt.Scanln(&diskName)
		diskName = strings.TrimSpace(diskName)
	}

	command = "clear"
	runCommand(command)
	for len(swapSize) == 0 {
		fmt.Print("Enter the swap size (example: 4G): ")
		fmt.Scanln(&swapSize)
		swapSize = strings.TrimSpace(swapSize)
	}

	command = "clear"
	runCommand(command)
	for len(user) == 0 {
		fmt.Print("Enter your username: ")
		fmt.Scanln(&user)
		user = strings.TrimSpace(user)
	}

	userPassword = "asd"
	auxStr = ""
	command = "clear"
	runCommand(command)
	for userPassword != auxStr {
		fmt.Print("Enter " + user + "'s password: ")
		fmt.Scanln(&userPassword)

		fmt.Print("Enter again the password: ")
		fmt.Scanln(&auxStr)

		if userPassword == auxStr {
			fmt.Println("Password entered successfully!")
		} else {
			fmt.Println("[!] Error, passwords entered differ.")
		}
	}

	rootPassword = "asd"
	auxStr = ""
	command = "clear"
	runCommand(command)
	for userPassword != auxStr {
		fmt.Print("Enter root's password: ")
		fmt.Scanln(&userPassword)

		fmt.Print("Enter again the password: ")
		fmt.Scanln(&auxStr)

		if userPassword == auxStr {
			fmt.Println("Password entered successfully!")
		} else {
			fmt.Println("[!] Error, passwords entered differ.")
		}
	}

	command = "clear"
	runCommand(command)
	for len(bootloaderid) == 0 {
		fmt.Print("Enter your bootloader-id (example: archlinux): ")
		fmt.Scanln(&bootloaderid)
		bootloaderid = strings.TrimSpace(bootloaderid)
	}

	command = "clear"
	runCommand(command)
	for len(hostname) == 0 {
		fmt.Print("Enter the hostname: ")
		fmt.Scanln(&hostname)
		hostname = strings.TrimSpace(hostname)
	}

	auxStr = ""
	command = "clear"
	runCommand(command)
	fmt.Print("Are you installing archlinux in a pendrive? [Y/n]: ")
	fmt.Scanln(&auxStr)
	if auxStr == "" || strings.ToLower(auxStr) == "y" {
		removable = true
	} else {
		removable = false
	}
}
