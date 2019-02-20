#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Please pass argument: e (simple), se (selection), ue (window), de (delayed, window)"
  exit 1
fi

datetime=$(date "+%Y-%m-%d-%H%M%S")

case $1 in
  "e")
    scrot $datetime.png -e 'mv $f ~/Pictures/'
    ;;
  "se")
    scrot $datetime.png -se 'mv $f ~/Pictures/'
    ;;
  "ue")
    scrot $datetime.png -ue 'mv $f ~/Pictures/'
    ;;
  "de")
    delay=$2
    scrot $datetime.png -d ${delay} -e 'mv $f ~/Pictures/'
    ;;
esac

sleep 0.5
resolution="$(xrandr --nograb --current | awk '/\*/ {printf $1; exit}')"
monitor_width="${resolution/x*}"
monitor_height="${resolution#*x}"
preview_width="$((monitor_width  / 5))"
preview_height="$((monitor_height  / 5))"
offset_x="$((monitor_width - preview_width))"
offset_y="$((monitor_height - preview_height))"
/usr/bin/convert $HOME/Pictures/$datetime.png -resize "${preview_width}x${preview_height}" $HOME/tmp/lastscrot.png

# Display scrot for preview
~/.bin/n30f -bi -x $offset_x $HOME/tmp/lastscrot.png -c "/usr/bin/gimp $HOME/Pictures/$datetime.png" &
scrotpid=$!

~/.config/lemonbar/scrot-notification.sh

sleep 5
kill $scrotpid
exit 0
