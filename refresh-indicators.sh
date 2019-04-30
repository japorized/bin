#!/usr/bin/env dash

sh -c "$HOME/.bin/cleandesktop.sh"
sh -c "$HOME/.config/bspwm/indicators ${@} &"
