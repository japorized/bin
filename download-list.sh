#!/usr/bin/env bash

if [ ! -f "$1" ]; then
  echo "Please provide download list"
  exit 1
fi

IFS=$'\n'
list=($(cat "$1"))
unset IFS

echo ${list[@]} | xargs -n 1 -P 8 wget --progress=bar
notify-send "Download completed"
