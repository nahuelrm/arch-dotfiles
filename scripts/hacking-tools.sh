#!/bin/bash

packages="httprobe amass findomain sublist3r subfinder nuclei gospider gowitness jq htmlq assetfinder feroxbuster ffuf massscan gau waybackurls"

sudo pacman -S $packages

# Other tools 

sudo git clone https://github.com/nahuelrm/wordlists /usr/share/wordlists/wordlists

git clone https://github.com/nahuelrm/vpn ~/Desktop/stderr/repos/vpn; sudo cp ~/Desktop/stderr/repos/vpn/vpn /bin/vpn; sudo vpn --install

git clone https://github.com/nahuelrm/crtsh ~/Desktop/stderr/repos/crtsh; cd ~/Desktop/stderr/repos/crtsh; ./install.sh; cd 

git clone https://github.com/nahuelrm/BugBountyNotes ~/Documentos/BugBountyNotes

git clone https://github.com/nahuelrm/recon ~/Documentos/recon

git clone https://github.com/nahuelrm/recon-tools ~/tests/recon-tools

git clone https://github.com/nahuelrm/hacking-toolsrc ~/tests/hacking-toolsrc

sudo pacman -S python-setuptools
git clone https://github.com/xnl-h4ck3r/xnLinkFinder.git ~/Desktop/stderr/repos/xnLinkFinder; cd ~/Desktop/stderr/repos/xnLinkFinder; sudo python setup.py install; cd

alias xnlinkfinder='python3 /home/stderr/Desktop/stderr/repos/xnLinkFinder/xnLinkFinder.py' >> ~/.zshrc

sudo wget https://raw.githubusercontent.com/nahuelrm/web-screenshot/main/web-screenshot.sh -O /bin/web-screenshot && sudo chmod +x /bin/web-screenshot

# More tools:
# waymore

go install github.com/nahuelrm/goxy@latest

go install github.com/nahuelrm/slice@latest

go install github.com/tomnomnom/unfurl@latest

mkdir ~/.gf 2>/dev/null
git clone https://github.com/tomnomnom/gf /tmp/gf
mv /tmp/gf/examples/* ~/.gf
rm -fr /tmp/gf
sudo ln -sf ~/.gf /root/.gf

go install github.com/tomnomnom/gf@latest

go install github.com/tomnomnom/anew@latest

go install github.com/ameenmaali/wordlistgen@latest


