#!/usr/bin/env dash

param1=""
param2=""

if [ $# != 0 ]
then
  param1=$1
  param2=$2
fi

for l in $(cat ~/.cache/lemon.pid) ; do kill -s TERM $l ; done && killall lemonbar
sh -c "$HOME/.config/bspwm/indicators $param1 $param2 &"

sleep 0.5
sh -c "$HOME/.bin/move-lemonbar-to-back.sh"
