#!/bin/sh

# Burpsuite

sudo wget 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=2022.8.2&type=jar' -O /bin/Burp_Suite_Pro.jar --quiet --show-progress
(java -jar keygen.jar) &

sudo echo "java --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:$(pwd)/loader.jar -noverify -jar /bin/Burp_Suite_Pro.jar &" > /bin/burpsuite
sudo chmod +x /bin/burpsuite
/bin/burpsuite & disown
