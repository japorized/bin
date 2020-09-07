#!/usr/bin/env bash

# Exit if no argument
if [ -z "$1" ]; then
  exit 0
fi

arg=$1
app=$(xprop WM_CLASS -id $(xdotool getactivewindow) \
  | cut -d',' -f2 \
  | tr -d \" \
  | tr '[:upper:]' '[:lower:]' \
  | tr -d ' ')

case "${app}" in
  "firefox"|"chromium"|"firefoxdeveloperedition")
    case "${arg}" in
      "swipe-leftup-3") xdotool key alt+Right ;;
      "swipe-rightup-3") xdotool key alt+Left ;;
      "swipe-left-3") xdotool key Ctrl+Next ;;
      "swipe-right-3") xdotool key Ctrl+Prior ;;
      "pinch-in") xdotool key ctrl+minus ;;
      "pinch-out") xdotool key ctrl+plus ;;
    esac
    ;;
  "tabbed")
    case "${arg}" in
      "swipe-left-3") xdotool key alt+l ;;
      "swipe-right-3") xdotool key alt+h ;;
      "pinch-in") xdotool key 2+z+o ;;
      "pinch-out") xdotool key 2+z+i ;;
    esac
    ;;
esac
