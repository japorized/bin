#!/usr/bin/env bash

baseurl="https://cheat.sh"
cheatStore=$HOME/.cheat

download() {
  cmd=$1
  opts=$2
  if [ -n "$cmd" ]; then
    curl "${baseurl}/${cmd}?T${opts}" > $cheatStore/${cmd}
  else
    echo "Please provide cmd"
  fi
}

remoteusage() {
  curl "${baseurl}/:help" | less
}

if [ "$@" != "help" ]; then
  download "$@"
else
  remoteusage
fi
