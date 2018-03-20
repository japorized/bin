#!/usr/bin/env dash

killall lemonbar
sh -c "$HOME/.config/bspwm/indicators &"

sleep 0.5
sh -c "$HOME/.bin/move-lemonbar-to-back.sh"
