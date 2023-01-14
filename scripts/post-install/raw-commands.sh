#!/bin/bash

sudo timedatectl set-ntp true

user=$(whoami)

#
# Packages installation
#

packages="bspwm sxhkd firefox firejail nitrogen picom npm gdm xorg xorg-server pavucontrol pulseaudio ranger rofi flameshot kitty git xclip wget p7zip zip unzip pacman-contrib neofetch htop gcc nautilus udisks2 discord obs-studio libreoffice vlc code zsh linux-headers v4l2loopback-dkms locate lsd bat mdcat jdk11-openjdk jq tree arch-install-scripts htmlq ntfs-3g net-tools"

yes '' | sudo pacman -S $packages
sudo systemctl enable gdm

#
# go installation
#

rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz

## TODO: install video drivers

#
# Install yay & packages 
#

mkdir -p ~/Desktop/$user/repos/yay
git clone https://aur.archlinux.org/yay-git.git ~/Desktop/$user/repos/yay
main_path=$(pwd)
cd ~/Desktop/$user/repos/yay
yes '' | makepkg -si
cd $main_path

yes '' | yay -S polybar scrub clipit

#
# Fonts
#

yes '' | yay -S polybar nerd-fonts-jetbrains-mono ttf-iosevka
yes '' | sudo pacman -S ttf-hack-nerd

#
# zsh
#

yes '' | yay -S zsh-syntax-highlighting zsh-autosuggestions zsh-sudo-git

# pure installation
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

sudo mkdir -p /root/.zsh
sudo git clone https://github.com/sindresorhus/pure.git /root/.zsh/pure

sudo usermod --shell /usr/bin/zsh $user
sudo usermod --shell /usr/bin/zsh root

sudo ln -sf /home/$user/.zshrc /root/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 
yes '' | ~/.fzf/install

sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf  
yes '' | sudo /root/.fzf/install 


#
# dotfiles
#

git clone https://github.com/nahuelrm/entorno /home/$user/Desktop/$user/repos/entorno
cp -r ~/Desktop/$user/repos/entorno/dotfiles/nvim ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/picom ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/ranger ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/sxhkd ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/bspwm ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/polybar ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/kitty ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/clipit ~/.config
cp -r ~/Desktop/$user/repos/entorno/dotfiles/neofetch ~/.config

cp -r ~/Desktop/$user/repos/entorno/dotfiles/.zshrc ~/.zshrc

cp -r ~/Desktop/$user/repos/entorno/wallpapers ~/Desktop

sudo cp ~/Desktop/$user/repos/entorno/dotfiles/custom.conf /etc/gdm/custom.conf

sudo chmod 755 ~/.config/bspwm/bspwmrc
sudo chmod 644 ~/.config/sxhkd/sxhkdrc
sudo chmod +x ~/.config/kitty/kitty.conf

sudo mkdir /root/.config
sudo ln -sf /home/$user/.config/nvim /root/.config/nvim
sudo ln -sf /home/$user/.config/ranger /root/.config/ranger

mkdir -p /home/$user/Downloads/firefox /home/$user/Documentos /home/$user/tests

sudo cp /home/$user/Desktop/$user/repos/entorno/dotfiles/gdm /var/lib/AccountsService/users/$user
sudo chown root:root /var/lib/AccountsService/users/$user
sudo chmod 600 /var/lib/AccountsService/users/$user

#
# Wordlists
#

# mkdir /usr/share/wordlists
# git clone https://github.com/nahuelrm/wordlists /usr/share/wordlists

#
# Hacking tools
#

mkdir ~/Desktop/$user/repos/blackarch
curl https://blackarch.org/strap.sh > ~/Desktop/$user/repos/blackarch/strap.sh
chmod +x ~/Desktop/$user/repos/blackarch/strap.sh
yes '' | sudo ~/Desktop/$user/repos/blackarch/strap.sh

yes '' | sudo pacman -S openvpn netcat nmap socat dnsutils aircrack-ng nikto gobuster wpscan hashcat john hydra smtp-user-enum nfs-utils smbclient enum4linux hexedit xxd nfs-utils whatweb ffuf whois traceroute inetutils php binwalk xf86-video-vmware steghide smbmap sqlmap arp-scan
yes '' | yay -S exploit-db-git

#
# github tools
#

yes '' | sudo pacman -S amass anew httprobe gospider nuclei 

sudo updatedb

