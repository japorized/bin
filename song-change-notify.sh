#!/bin/bash

# Script intended to be executed from ncmpcpp (execute_on_song_change
# preference), using libnotify to show song info on change

# Credits to Vyacheslav Levit for original script for grabbing
# location of the album art
# Licensed under The MIT License: http://opensource.org/licenses/MIT

MUSIC_DIR=$HOME/Music

{
  current="$(mpc current)"
  album="$(mpc --format %album% current)"
  file="$(mpc --format %file% current)"
  album_dir="${file%/*}"
  [[ -z "$album_dir" ]] && exit 1
  album_dir="$MUSIC_DIR/$album_dir"

  covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
  src="$(echo -n "$covers" | head -n1)"
  if [[ -n "$src" ]] ; then
      if [[ -f "$src" ]] ; then
        notify-send --icon="$src" "Now Playing ♫" "$album\n$current"
      else
        notify-send "Now Playing ♫" "$album\n$current"
      fi
  else
    notify-send "Now Playing ♫" "$album\n$current"
  fi
} &
