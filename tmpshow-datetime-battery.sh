#!/usr/bin/env sh

$XDG_CONFIG_HOME/lemonbar/datetime.sh &
$XDG_CONFIG_HOME/lemonbar/battery.sh &
sleep 5
kill 0
exit 0
