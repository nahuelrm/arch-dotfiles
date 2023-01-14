#!/bin/bash
 
ip_address=$(cat /home/stderr/.config/polybar/scripts/target | awk '{print $1}')
machine_name=$(cat /home/stderr/.config/polybar/scripts/target | awk '{print $2}')
 
if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#BF616A}什 %{u-}%{F#E5E9F0} $ip_address%{u-} - $machine_name"
else
    echo "%{F#BF616A}什 %{u-}%{F#E5E9F0} No target"
fi
