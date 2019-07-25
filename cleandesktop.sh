#!/usr/bin/env sh

for l in $(cat ~/.cache/lemon.pid)
do
  pkill -P $l
  kill -s TERM $l
done && killall lemonbar

echo "" > $HOME/.cache/lemon.pid
