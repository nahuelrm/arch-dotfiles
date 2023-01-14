package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"os/exec"
)

func main() {
	var command string

	if os.Geteuid() == 0 {
		fmt.Println("[!] You can't run this script as root.")
		os.Exit(0)
	}

	user := os.Getenv("USER")

	_, err := net.Dial("tcp", "www.google.com:80")
	if err != nil {
		fmt.Println("You need internet connection to run this script.")
		os.Exit(0)
	}
	// setup time

	command = "sudo timedatectl set-ntp true"
	runCommand(command)

	// packages installation

	packages := "bspwm sxhkd firefox firejail nitrogen picom npm gdm xorg xorg-server pavucontrol pulseaudio ranger rofi flameshot kitty git xclip wget p7zip zip unzip pacman-contrib neofetch htop gcc nautilus udisks2 discord obs-studio libreoffice vlc code zsh linux-headers v4l2loopback-dkms locate lsd bat mdcat jdk11-openjdk jq tree arch-install-scripts htmlq ntfs-3g net-tools"
	command = "yes '' | sudo pacman -S " + packages
	runCommand(command)

	command = "sudo systemctl enable gdm"
	runCommand(command)

	// go installation

	command = "rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz"
	runCommand(command)

	// TODO: install video drivers

	// install yay and more packages

	command = "mkdir -p ~/Desktop/" + user + "/repos/yay"
	runCommand(command)

	command = "git clone https://aur.archlinux.org/yay-git.git ~/Desktop/" + user + "/repos/yay"
	runCommand(command)

	command = "main_path=$(pwd); cd ~/Desktop/" + user + "/repos/yay; yes '' | makepkg -si; cd $main_path"
	runCommand(command)

	command = "yes '' | yay -S polybar scrub clipit"
	runCommand(command)

	// fonts

	command = "yes '' | yay -S polybar nerd-fonts-jetbrains-mono ttf-iosevka"
	runCommand(command)

	command = "yes '' | sudo pacman -S ttf-hack-nerd"
	runCommand(command)

	// zsh

	command = "yes '' | yay -S zsh-syntax-highlighting zsh-autosuggestions zsh-sudo-git"
	runCommand(command)

	command = "mkdir -p \"$HOME/.zsh\""
	runCommand(command)

	command = "git clone https://github.com/sindresorhus/pure.git \"$HOME/.zsh/pure\""
	runCommand(command)

	command = "sudo mkdir -p \"/root/.zsh\""
	runCommand(command)

	command = "sudo git clone https://github.com/sindresorhus/pure.git /root/.zsh/pure"
	runCommand(command)

	command = "sudo usermod --shell /usr/bin/zsh " + user
	runCommand(command)

	command = "sudo usermod --shell /usr/bin/zsh root"
	runCommand(command)

	command = "sudo ln -sf /home/" + user + "/.zshrc /root/.zshrc"
	runCommand(command)

	command = "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
	runCommand(command)

	command = "yes '' | ~/.fzf/install"
	runCommand(command)

	command = "sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf"
	runCommand(command)

	command = "yes '' | sudo /root/.fzf/install"
	runCommand(command)

	// dofiles

	command = "git clone https://github.com/nahuelrm/entorno /home/" + user + "/Desktop/" + user + "/repos/entorno"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/nvim ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/picom ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/ranger ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/sxhkd ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/bspwm ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/polybar ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/kitty ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/clipit ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/neofetch ~/.config"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/dotfiles/.zshrc ~/.zshrc"
	runCommand(command)

	command = "cp -r ~/Desktop/" + user + "/repos/entorno/wallpapers ~/Desktop"
	runCommand(command)

	command = "sudo cp ~/Desktop/" + user + "/repos/entorno/dotfiles/custom.conf /etc/gdm/custom.conf"
	runCommand(command)

	command = "sudo chmod 755 ~/.config/bspwm/bspwmrc"
	runCommand(command)

	command = "sudo chmod 644 ~/.config/sxhkd/sxhkdrc"
	runCommand(command)

	command = "sudo chmod +x ~/.config/kitty/kitty.conf"
	runCommand(command)

	command = "sudo mkdir /root/.config"
	runCommand(command)

	command = "sudo ln -sf /home/" + user + "/.config/nvim /root/.config/nvim"
	runCommand(command)

	command = "sudo ln -sf /home/" + user + "/.config/ranger /root/.config/ranger"
	runCommand(command)

	command = "mkdir -p /home/" + user + "/Downloads/firefox /home/" + user + "/Documentos /home/" + user + "/tests 2>/dev/null"
	runCommand(command)

	command = "sudo cp /home/" + user + "/Desktop/" + user + "/repos/entorno/dotfiles/gdm /var/lib/AccountsService/users/" + user
	runCommand(command)

	command = "sudo chown root:root /var/lib/AccountsService/users/" + user + ""
	runCommand(command)

	command = "sudo chmod 600 /var/lib/AccountsService/users/" + user + ""
	runCommand(command)

	// wordlists
	// TODO: clone my wordlists

	// hacking setup
	
	command = "mkdir ~/Desktop/"+user+"/repos/blackarch"
	runCommand(command)

	command = "curl https://blackarch.org/strap.sh > ~/Desktop/"+user+"/repos/blackarch/strap.sh"
	runCommand(command)

	command = "chmod +x ~/Desktop/"+user+"/repos/blackarch/strap.sh"
	runCommand(command)

	command = "yes '' | sudo ~/Desktop/"+user+"/repos/blackarch/strap.sh"
	runCommand(command)

	command = "yes '' | sudo pacman -S openvpn netcat nmap socat dnsutils aircrack-ng nikto gobuster wpscan hashcat john hydra smtp-user-enum nfs-utils smbclient enum4linux hexedit xxd nfs-utils whatweb ffuf whois traceroute inetutils php binwalk xf86-video-vmware steghide smbmap sqlmap arp-scan"
	runCommand(command)

	// TODO: install searchsploit tool
	command = "sudo pacman -S amass anew httprobe gospider nuclei"
	runCommand(command)

	command = "sudo updatedb"
	runCommand(command)
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
