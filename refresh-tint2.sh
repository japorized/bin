#!/usr/bin/env dash

killall tint2
sleep 0.2
tint2 &
tint2 -c $XDG_CONFIG_HOME/tint2/lollypop-controls &
sleep 1
xdo above -t $(xdo id -n root) $(xdotool search --name lollypop-controls)
