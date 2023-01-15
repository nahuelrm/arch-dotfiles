#!/bin/bash

#Colors

greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

# Functions

trap ctrl_c INT

# $1 == 1 -> automatic mode predefined
# $2 == 1 -> came from intermediate script

function ctrl_c(){
	echo -e "\n${redColor}[!] Exiting...\n${endColor}"
	if [ $2 == 1 ]; then restore_all; fi
	exit 1;
}

function replace_text(){
	# $1 full path to file
	# $2 string to replace
	# $3 new text
	
	sed -i -e "s/$2/$3/g" $1
}

function restore_all(){
	user=$1
	sudo mv /home/$user/.bashrc.bak /home/$user/.bashrc
	sudo mv /root/getty@.service.bak /usr/lib/systemd/system/getty@.service
	yes '' | sudo rm -fr /home/$user/arch-dotfiles
	sudo mv /etc/sudoers.bak /etc/sudoers
}

#
# Arch Linux Post Install
#

# Checkouts / Validations

if [[ $EUID -eq 0 ]]; then
	echo -e "\n${redColor}[!] You can't run this script as root\n${endColor}"
	exit 1
fi

# Start

user="$(whoami)"

# Time 

sudo timedatectl set-ntp true

if [ $1 == 1 ]; then 
	automatic=true; echo -e "${yellowColor}Setting up some things befor starting...${endColor}"; sleep 15; 
else
	clear; echo -e "Select installation mode:\n1. Automatic\n2. Manual"; read choice
	if [[ -z $choice ]]; then exit 0; fi
	case $choice in
		1) automatic=true ;;
		2) automatic=false ;;
		*) exit 0 ;;
	esac
fi

# Network services

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to enable Network Services? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Enabling Network Services...${endColor}"
	sudo systemctl enable NetworkManager
	sudo systemctl enable wpa_supplicant.service
	sleep 1
fi

# Packages installation

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to install more packages? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Installing more packages...${endColor}"
	yes '' | sudo pacman -S xorg xorg-server xorg-xinit firefox pavucontrol pulseaudio ranger bspwm sxhkd rofi flameshot feh picom kitty git xclip wget p7zip zip unzip pacman-contrib neofetch htop gcc nautilus udisks2 firejail discord obs-studio libreoffice vlc code gdm zsh linux-headers v4l2loopback-dkms locate lsd bat mdcat jdk11-openjdk jq tree arch-install-scripts net-tools npm
	sudo systemctl enable gdm

	curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz -o /tmp/go1.19.5.linux-amd64.tar.gz

	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.19.5.linux-amd64.tar.gz
	sleep 1
fi

# Yay installation

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to install yay? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Installing yay...${endColor}"
	user="$(whoami)"
	mkdir -p ~/Desktop/$user/repos
	git clone https://aur.archlinux.org/yay-git.git
	mv yay-git ~/Desktop/$user/repos
	cd ~/Desktop/$user/repos/yay-git
	yes '' | makepkg -si
	sleep 1
fi


# Fonts & Dependencies

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to install fonts and dependencies? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Installing fonts and dependencies...${endColor}"
	yes '' | pacman -S ttf-hack-nerd
	
	yes '' | yay -S polybar scrub clipit betterlockscreen nerd-fonts-jetbrains-mono ttf-iosevka

	sleep 1
fi

# Dotfiles

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to set up the dotfiles? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Setting up dotfiles...${endColor}"
	git clone https://github.com/nahuelrm/arch-dotfiles ~/Desktop/$user/repos/arch-dotfiles

	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/nvim ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/picom ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/ranger ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/sxhkd ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/bspwm ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/polybar ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/kitty ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/clipit ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/neofetch ~/.config

	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.zshrc ~/.zshrc
	cp -r ~/Desktop/$user/repos/arch-dotfiles/wallpapers ~/Desktop/
	sudo cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/custom.conf /etc/gdm/custom.conf

	sudo chmod 755 ~/.config/bspwm/bspwmrc
	sudo chmod 644 ~/.config/sxhkd/sxhkdrc
	sudo chmod +x ~/.config/kitty/kitty.conf

	sudo mkdir /root/.config
	sudo ln -sf /home/$user/.config/nvim /root/.config/nvim
	sudo ln -sf /home/$user/.config/ranger /root/.config/ranger

	yes '' | nvim --headless +PlugInstall +qall 2>/dev/null
	yes '' | sudo nvim --headless +PlugInstall +qall 2>/dev/null

	mkdir -p /home/$user/Downloads/firefox /home/$user/Documentos /home/$user/tests 2>/dev/null

	sudo cp "/home/$user/Desktop/$user/repos/arch-dotfiles/dotfiles/gdm" "/var/lib/AccountsService/users/$user"
	sudo chown root:root "/var/lib/AccountsService/users/$user"
	sudo chmod 600 "/var/lib/AccountsService/users/$user"

	sudo replace_text "/var/lib/AccountsService/users/$user" stderr $user
	replace_text "/home/$user/.zshrc" stderr $user
	replace_text "/home/$user/.config/polybar/scripts/target.sh" stderr $user

	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/final-setup.sh ~/final-setup.sh
	chmod +x ~/final-setup.sh
	sleep 1
fi


# Wordlists

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to add some useful wordlists? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Cloning wordlists...${endColor}"
	sudo mkdir /usr/share/wordlists
	sudo git clone https://github.com/danielmiessler/SecLists /usr/share/wordlists/SecLists
	sudo mkdir /usr/share/wordlists/dirbuster
	sudo cp /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt /usr/share/wordlists/dirbuster
	sudo cp /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt /usr/share/wordlists/dirbuster
	sudo cp /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-big.txt /usr/share/wordlists/dirbuster
	sudo tar -xvzf /usr/share/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/wordlists
	sleep 1
fi


# Blackarch

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to install blackarch repositories? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Installing blackarch repositories...${endColor}"
	mkdir ~/Desktop/$user/repos/blackarch
	curl https://blackarch.org/strap.sh > ~/Desktop/$user/repos/blackarch/strap.sh
	chmod +x ~/Desktop/$user/repos/blackarch/strap.sh
	yes '' | sudo ~/Desktop/$user/repos/blackarch/./strap.sh

	yes '' | sudo pacman -S openvpn netcat nmap socat dnsutils aircrack-ng nikto gobuster wpscan hashcat john hydra smtp-user-enum nfs-utils smbclient enum4linux hexedit xxd nfs-utils whatweb ffuf whois traceroute inetutils php binwalk xf86-video-vmware steghide smbmap sqlmap arp-scan

	# TODO: Install searchsploit
	sleep 1


fi


# Bupsuite pro

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to prepare BurpSuite Professional for a later installation? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Preparing BurpSuite Professional...${endColor}"
	git clone https://github.com/SNGWN/Burp-Suite ~/Desktop/$user/repos/burpsuite-pro
	sleep 1
fi

# Zsh

if [ "$automatic" != true ]; then 
	clear; echo -e "${yellowColor}Would you like to set up zsh and some extra features? [Y/n]${endColor}"; read response
fi
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Setting up zsh...${endColor}"
	sudo usermod --shell /usr/bin/zsh $user
	yes '' | yay -S zsh-syntax-highlighting zsh-autosuggestions zsh-sudo-git

	# powerLevel10k
	
	echo -e "${greenColor}[*] Setting up some extra features...${endColor}"

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.p10k.zsh ~/.p10k.zsh

	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
	sudo cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.root-p10k.zsh /root/.p10k.zsh  

	sudo usermod --shell /usr/bin/zsh root

	sudo ln -sf /home/$user/.zshrc /root/.zshrc

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 
	yes '' | ~/.fzf/./install

	sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf  
	yes '' | sudo /root/.fzf/./install 

	sleep 1
fi

# Exit 0 now if not in automatic mode
if [ $automatic != true ]; then exit 0; fi

sudo updatedb
restore_all $user

clear; echo -e "${greenColor}[*] Post Install finished successfully!\nAfter reboot, run ${yellowColor}./final-setup.sh ${greenColor}script, located under ${turquoiseColor}/home/$user${greenColor} directory\n\n${yellowColor}Press ${redColor}r${yellowColor} to reboot${endColor}"; read reboot
if [[ $reboot =~ [rR] ]]; then
	sudo reboot
fi


