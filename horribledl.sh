#!/usr/bin/env bash
# Dependency: xmlstarlet, curl, fzf, aria2c

baseurl="http://www.horriblesubs.info/rss.php"
res="720" # default resolution
btdler=/usr/bin/aria2c
filter=""

if [ -n "$XDG_DATA_HOME" ]; then
  storage=$XDG_DATA_HOME/horribledl
else
  storage=/home/japorized/.data/horribledl
fi
if [ ! -d $storage ]; then
  echo "${storage} does not exist. Creating directory."
  mkdir $storage
fi

usage() {
  echo "  horribledl.sh [OPTIONS]

  OPTIONS:
  -r    Resolution [options: all, sd, 720, 1080] (default: ${res})
  -R    Refresh rss data before download (works alongside -r)
  -U    Refresh rss data only (works alongside -r)
  -s    Filter for show name
  -f    Force mode (no questions asked)"
}

updateRSS() {
  echo "Downloading rss-${res}.xml"
  url="${baseurl}?res=${res}"
  curl "$url" > $storage/rss-${res}.xml
}

f_flag=false

while getopts "r:RUs:f" opt; do
  case "${opt}" in
    r) res="$OPTARG" ;;
    R) updateRSS ;;
    U)
      updateRSS
      exit 0
      ;;
    s) filter="$OPTARG" ;;
    f) f_flag=true ;;
    \?)
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# set down working files
rssfile=$storage/rss-${res}.xml
tmpshowlist=$storage/tmp-showlist.txt

# check if rssfile exists
# download rss file if dne
if [ ! -f $rssfile ]; then
  echo "${rssfile} does not exist. Creating file."
  updateRSS
fi

# load parsed rss into memory
IFS=$'\n'
shows=($(/usr/bin/xmlstarlet sel -t -m "/rss/channel/item" -v title -n $rssfile))
links=($(/usr/bin/xmlstarlet sel -t -m "/rss/channel/item" -v link -n $rssfile))
unset IFS

rm $tmpshowlist  # rm existing tmpfile of shows

# list files into tmpfile with respective index
for showidx in "${!shows[@]}"
do
  if [ -n "$filter" ]; then
    grepres=$(echo ${shows[$showidx]} | grep "$filter")
    if [ -n "$grepres" ]; then
      echo $showidx "${shows[$showidx]}" >> $tmpshowlist
    fi
  else
    echo $showidx "${shows[$showidx]}" >> $tmpshowlist
  fi
done

# query user
only_one_choice() {
  lines=$(wc -l $tmpshowlist | cut -d' ' -f1)
  test $lines = 1
}
if (only_one_choice); then
  sel=$(cat $tmpshowlist)
else
  sel=$(cat $tmpshowlist | fzf)
fi
val=$?

if [ $val = 130 ]; then
  echo "Cancelled"
  exit 1
fi

selno=$(echo $sel | cut -d' ' -f1)  # get selected number

if (! $f_flag); then
  echo "Download ${shows[$selno]}?"
  read confirm
  confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
  case "${confirm}" in
    n|"no")
      echo "Cancelled"
      exit 0
      ;;
  esac
fi

magnet="${links[$selno]}"   # get magnet of selected show
${btdler} "$magnet"   # download
