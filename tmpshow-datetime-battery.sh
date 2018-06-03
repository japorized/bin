#!/usr/bin/env bash

$CONFIG/lemonbar/datetime.sh &
$CONFIG/lemonbar/battery.sh &
sleep 5
kill 0
exit 0
