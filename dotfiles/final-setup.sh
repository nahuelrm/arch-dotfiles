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

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${redColor}[!] Exiting...\n${endColor}"

	exit 1;
}

if [[ $EUID -eq 0 ]]; then
	echo -e "\n${redColor}[!] You can't run this script as root\n${endColor}"
	exit 1
fi

user="$(whoami)"
sudo updatedb

# BurpSuite Professional
clear; echo -e "${yellowColor}Would you like to install BurpSuite Professional? [Y/n]${endColor}"; read response
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] Installing BurpSuite Professional...\n${endColor}"

	cd ~/Desktop/$user/repos/entorno/burpsuite-pro
	wget 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=&type=jar' -O Burp_Suite_Pro.jar --quiet --show-progress
	(java -jar keygen.jar) &

	sudo echo "java --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/Burp_Suite_Pro.jar &" > /bin/burpsuite
	sudo chmod +x /bin/burpsuite
	/bin/burpsuite & disown
fi

# Firefox extensions
clear; echo -e "${yellowColor}Would you like to install some useful firefox extensions? [Y/n]${endColor}"; read response
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	firefox https://addons.mozilla.org/firefox/downloads/file/4021899/darkreader-4.9.60.xpi
	firefox https://addons.mozilla.org/firefox/downloads/file/4011167/traduzir_paginas_web-9.6.1.xpi
	firefox https://addons.mozilla.org/firefox/downloads/file/3616824/foxyproxy_standard-7.5.1.xpi
	firefox https://addons.mozilla.org/firefox/downloads/file/4003969/ublock_origin-1.44.4.xpi
	firefox https://addons.mozilla.org/firefox/downloads/file/4013204/wappalyzer-6.10.41.xpi
	firefox about:preferences
fi

# Burpsuite Settings
clear; echo -e "${yellowColor}Would you like to add recommended settings to burpsuite? [Y/n]${endColor}"; read response
if [[ $response =~ [yY] ]] || [ -z $response ]; then
	clear; echo -e "${greenColor}[*] BurpSuite recommended settings:\n${endColor}"
	echo -e "${purpleColor}- ${yellowColor}Dark theme${purpleColor}: User Options ${yellowColor}>${purpleColor} Display ${yellowColor}>${purpleColor} theme: ${turquoiseColor}Dark${endColor}"
	echo -e "${purpleColor}- Extender ${yellowColor}>${purpleColor} BApp Store ${yellowColor}>${purpleColor} Install: ${turquoiseColor}Notes${endColor}"
	echo -e "${purpleColor}- Extender ${yellowColor}>${purpleColor} BApp Store ${yellowColor}>${purpleColor} Install: ${turquoiseColor}Hackvertor${endColor}"
	echo -e "${purpleColor}- Browser addons:${endColor}"
	echo -e "${purpleColor}\t+ ${turquoiseColor}Dark Reader${endColor}"
	echo -e "${purpleColor}\t+ ${turquoiseColor}Wappalyzer${endColor}"
fi

echo -e "${greenColor}[*] Final setup finished successfully!\n\n${yellowColor}Press ${redColor}d${yellowColor} key to remove this script.${redColor}"; read delete
if [[ $delete =~ [dD] ]]; then 
	rm /home/$user/final-setup.sh
fi
