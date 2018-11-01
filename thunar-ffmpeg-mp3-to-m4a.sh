#!/usr/bin/env sh

DIR=$1

if [ "$2" = "-s" ];
then
  for f in "$DIR"/*.mp3; do
    /usr/bin/ffmpeg -i "$f" -map 0:0 -c:a aac -b:a 128k -map_metadata 0 "${f%mp3}m4a"
  done
else
  for f in "$DIR"/*.mp3; do
    /usr/bin/ffmpeg -i "$f" -map 0:0 -c:a aac -b:a 128k -map_metadata 0 "${f%mp3}m4a" 2>&1 \
     | /usr/bin/zenity --width=800 --height=350 --text-info --title "Converting $f" --auto-scroll --timeout=15
  done
fi
