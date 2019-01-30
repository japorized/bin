#!/usr/bin/env bash

if [ "$1" = "w" ]; then
  echo $(xwininfo -id $(xdotool getwindowfocus) | grep Width | cut -d : -f2 | tr -d " \n\t\r\f")
elif [ "$1" = "h" ]; then
  echo $(xwininfo -id $(xdotool getwindowfocus) | grep Height | cut -d : -f2 | tr -d " \n\t\r\f")
elif [ "$1" = "x" ]; then
  echo $(xwininfo -id $(xdotool getwindowfocus) | grep "Absolute upper-left X" | cut -d : -f2 | tr -d " \n\t\r\f")
elif [ "$1" = "y" ]; then
  echo $(xwininfo -id $(xdotool getwindowfocus) | grep "Absolute upper-left Y" | cut -d : -f2 | tr -d " \n\t\r\f")
fi
