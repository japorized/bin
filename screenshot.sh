#!/usr/bin/env bash
# Dependencies:
# maim, imagemagick, n30f, ffplay, imagemagick, getRes (own), xclip

# TODO
# handle cancellation of screenshot

cachefile=$HOME/.cache/last-screenshot.png

usage() {
  echo "  Usage: screenshot.sh [OPTIONS] [ARGUMENT]
  Description:
  A handy wrapper for commonly used screenshot options,
  with, figuratively but somewhat accuratey, bells and whistles.
  
  Options:
  -h                        Show this help
  -c                        Copy to clipboard
  -d                        Screenshot with delay [in seconds] (default: 0)
  -s                        Screenshot with shadow

  Argument:
  f  | fullscreen           Screenshot entirety of focused screen
  s  | select               Screenshot selection only
  w  | window               Screenshot active window only"
}

if [ -z "${SCROT_DIR}" ]; then
  enddir="$HOME/Pictures/Screenshots"
else
  enddir="${SCROT_DIR}"
fi

if [ -z $1 ]; then
  usage
  exit 1
fi

_maim() {
  maim --quality 1 --hidecursor --quiet "$@"
}

_maim_lq() {
  maim --quality 6 --hidecursor --quiet "$@"
}

_copytoclipboard() {
  xclip -selection clipboard -t image/png "$@"
}

_makeshadow() {
  convert - \( +clone -background black -shadow 80x3+5+5 \) +swap \
    -background none -layers merge +repage "$@"
}

_playshuttersound() {
  ffplay -vn -autoexit -nodisp -loglevel quiet \
    $HOME/.data/sounds/camera-shutter-click-03.mp3 &
}

datetime=$(date "+%Y-%m-%d-%H%M%S")
s_flag=false
c_flag=false
delay=0

while getopts "cd:sh" opt; do
  case "${opt}" in
    c) c_flag=true ;;
    d) delay=$OPTARG ;;
    s) s_flag=true ;;
    h)
      usage
      exit 0
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

sc_flag=false
if ($c_flag && $s_flag); then
  sc_flag=true
fi

secondary_args=""

case $1 in
  "f" | "fullscreen")
    secondary_args="--window root --delay ${delay}"
    ;;
  "s" | "select")
    secondary_args="--select --delay ${delay}"
    ;;
  "w" | "window")
    secondary_args="--window $(xdotool getactivewindow) --delay ${delay}"
    ;;
  "help")
    usage
    exit 0
    ;;
  *)
    usage
    exit 1
esac

if ($sc_flag); then
  _maim_lq ${secondary_args} | _makeshadow "$cachefile"
  _playshuttersound
  _copytoclipboard -i "$cachefile"
  exit 0
elif ($c_flag); then
  _maim_lq ${secondary_args} | _copytoclipboard
  _playshuttersound
  exit 0
elif ($s_flag); then
  _maim ${secondary_args} | _makeshadow "$enddir/$datetime.png"
else
  _maim ${secondary_args} "$enddir/$datetime.png"
fi

_playshuttersound

sleep 0.5 # pause is introduced to allow the system to write the file

resolution=($(getRes))
monitor_width=${resolution[0]}
monitor_height=${resolution[1]}
preview_width=$((monitor_width  / 5))
preview_height=$((monitor_height  / 5))
offset_x=$((monitor_width - preview_width))
/usr/bin/convert $enddir/$datetime.png \
  -resize "${preview_width}x${preview_height}" $cachefile

# Display scrot for preview
~/.bin/n30f -bi $cachefile \
  -c "$HOME/.bin/rofi-screenshot-action $enddir $datetime.png" &
scrotpid=$!

~/.config/lemonbar/scrot-notification.sh

sleep 5
kill $scrotpid
exit 0
