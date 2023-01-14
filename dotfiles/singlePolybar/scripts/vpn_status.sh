#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':') 
if [ "$IFACE" = "tun0" ]; then
	echo "%{F#a3be8c} %{F#E5E9F0}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{u-}"
else
	echo "%{F#a3be8c}%{u-} Disconnected"
fi
