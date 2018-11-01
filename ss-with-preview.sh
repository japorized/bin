#!/usr/bin/env dash

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
esac

/usr/bin/convert $HOME/Pictures/$datetime.png -resize x300 $HOME/tmp/lastscrot.png

# Display scrot for preview
~/.bin/n30f -x 2050 -y 1270 $HOME/tmp/lastscrot.png -c "/usr/bin/gimp $HOME/Pictures/$datetime.png" &
scrotpid=$!

~/.config/lemonbar/scrot-notification.sh

sleep 5
kill $scrotpid
exit 0
