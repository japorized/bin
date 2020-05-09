#!/usr/bin/env bash
# Dependencies: pacman, pacman-contrib, fzf

add_args=""
help_opt=""
show="info"

usage() {
  echo "  Usage: sys-packinfo.sh [OPTIONS]

  OPTIONS:
  -h  Show this message
  -s  Change previewed item [default: info]
      Options:
      l,list    List all files owned by previewed package
      i,info    Show package info
      d,deps    Show dependencies of package
      r,revdeps Show reverse dependencies of package
  -O  Append more pacman query flags to \`pacman -Qeq\`
      See also \`man pacman\`"
}

while getopts "hO:s:" opt; do
  case "${opt}" in
    h)
      usage
      exit 0
      ;;
    O) add_args=${OPTARG} ;;
    s) show=${OPTARG} ;;
    \?)
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

case $show in
  l|"list") show_cmd="pacman -Ql {}" ;;
  i|"info") show_cmd="pacman -Qi {}" ;;
  d|"deps") show_cmd="pactree {}" ;;
  r|"revdeps") show_cmd="pactree -r {}" ;;
  *) show_cmd="pacman -Qi {}" ;;
esac

result=$(pacman -Qq${add_args} | fzf --reverse --preview="${show_cmd}")
retval=$?
if [ $retval -eq 0 ]; then
  show_cmd=$(echo ${show_cmd} | sed "s/{}/$result/g")
  ${show_cmd} | less
fi
