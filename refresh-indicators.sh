#!/usr/bin/env dash

while getopts "hn" flag; do
  case "${flag}" in
    h)
      sh -c "$HOME/.config/bspwm/indicators -h"
      exit 0
      ;;
    n)
      sh -c "$HOME/.bin/cleandesktop.sh"
      sh -c "$HOME/.config/bspwm/indicators -n &"
      ;;
    *)
      sh -c "$HOME/.config/bspwm/indicators -h &"
      exit 1
      ;;
  esac
done

sh -c "$HOME/.bin/cleandesktop.sh"
sh -c "$HOME/.config/bspwm/indicators ${@} &"
