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
  -u                        Screenshot with cursor

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
  maim --quality 1 --quiet "$@"
}

_maim_lq() {
  maim --quality 6 --quiet "$@"
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
s_flag=false  # shadow
c_flag=false  # copy
u_flag=false  # show cursor (not that this is opposite to maim)
delay=0

while getopts "cd:shu" opt; do
  case "${opt}" in
    c) c_flag=true ;;
    d) delay=$OPTARG ;;
    s) s_flag=true ;;
    u) u_flag=true ;;
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

getHideCursorStatus() {
  if ( ! $u_flag ); then
    echo "--hidecursor"
  fi
}

if ($sc_flag); then
  _maim_lq $(getHideCursorStatus) ${secondary_args} | _makeshadow "$cachefile"
  retval=$?
  if [ $retval = 0 ]; then
    _playshuttersound
    _copytoclipboard -i "$cachefile"
    exit 0
  else
    exit 1
  fi
elif ($c_flag); then
  _maim_lq $(getHideCursorStatus) ${secondary_args} | _copytoclipboard
  retval=$?
  if [ $retval = 0 ]; then
    _playshuttersound
    exit 0
  else
    exit 1
  fi
elif ($s_flag); then
  _maim $(getHideCursorStatus) ${secondary_args} | _makeshadow "$enddir/$datetime.png"
  retval=$?
else
  _maim $(getHideCursorStatus) ${secondary_args} "$enddir/$datetime.png"
  retval=$?
fi

if [ $retval = 0 ]; then
  _playshuttersound
else
  exit 1
fi

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
