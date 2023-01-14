#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Launch polybar

# First monitor
polybar bar -c ~/.config/polybar/config.ini &
polybar right -c ~/.config/polybar/config.ini &
polybar vpn -c ~/.config/polybar/config.ini &
# polybar target -c ~/.config/polybar/config.ini &
polybar icon -c ~/.config/polybar/config.ini &

# Second monitor
polybar bar2 -c ~/.config/polybar/config.ini &
polybar right2 -c ~/.config/polybar/config.ini &
polybar icon2 -c ~/.config/polybar/config.ini &
