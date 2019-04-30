#!/usr/bin/env bash

cachefile=$HOME/.cache/lastscrot.png

if [ -z "${SCROT_DIR}" ]; then
  enddir="$HOME/Pictures/Screenshots"
else
  enddir="${SCROT_DIR}"
fi

if [ -z $1 ]; then
  echo "Please pass argument: e (simple), se (selection), ue (window), de (delayed, window)"
  exit 1
fi

datetime=$(date "+%Y-%m-%d-%H%M%S")

case $1 in
  "e")
    scrot $datetime.png -e "mv \$f $enddir"
    ;;
  "se")
    scrot $datetime.png -se "mv \$f $enddir"
    ;;
  "ue")
    scrot $datetime.png -ue "mv \$f $enddir"
    ;;
  "de")
    delay=$2
    scrot $datetime.png -d ${delay} -e "mv \$f $enddir"
    ;;
esac

ffplay -vn -autoexit -nodisp $HOME/.data/sounds/camera-shutter-click-03.mp3 &
sleep 0.5
resolution="$(xrandr --nograb --current | awk '/\*/ {printf $1; exit}')"
monitor_width="${resolution/x*}"
monitor_height="${resolution#*x}"
preview_width="$((monitor_width  / 5))"
preview_height="$((monitor_height  / 5))"
offset_x="$((monitor_width - preview_width))"
/usr/bin/convert $enddir/$datetime.png -resize "${preview_width}x${preview_height}" $cachefile

# Display scrot for preview
~/.bin/n30f -bi $cachefile -c "$HOME/.bin/rofi-scrot-action $enddir $datetime.png" &
scrotpid=$!

~/.config/lemonbar/scrot-notification.sh

sleep 5
kill $scrotpid
exit 0
