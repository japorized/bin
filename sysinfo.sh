#!/usr/bin/env bash
# sysinfo script

bold="\x1B[1m"
red="\e[31m"
grn="\e[32m"
ylw="\e[33m"
cyn="\e[36m"
blu="\e[34m"
prp="\e[35m"
dprp="\e[35;1m"
frst="\x1B[22m"
rst="\e[0m"

editor() {
  echo $EDITOR | sed 's/\/usr\/bin\///g'
}

total_packages() {
  pacman -Q | wc -l
}

tp() {
  total_packages
}

echo -e
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e
echo -e "   ${bold}${cyn}WM ${rst}${frst}      bspwm                 ${bold}${cyn}OS ${rst}${frst}     Arch Linux"
echo -e "   ${bold}${cyn}machine ${rst}${frst} Lenovo Thinkpad E580  ${bold}${cyn}shell ${rst}${frst}  zsh"
echo -e "   ${bold}${cyn}editor ${rst}${frst}  $(editor)                  ${bold}${cyn}term${rst}${frst}    kitty, termite"
echo -e "   ${bold}${cyn}music ${rst}${frst}   mpd, lollypop"
echo -e "   ${bold}${cyn}sys font${rst}${frst}"
echo -e "   ${prp}serif${rst}     Times Newer Roman    ${prp}sans${rst}    Helvetica Neue"
echo -e "   ${prp}monospace${rst} Hack Nerd Font       ${prp}ja${rst}      装甲明朝"
echo -e
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
echo -e
echo -e "           \"Exactly, Watson. Pathetic and futile."
echo -e "          But is not all life pathetic and futile?"
echo -e "         Is not his story a microcosm of the whole?"
echo -e "                     We reach. We grasp."
echo -e "          And what is left in our hands at the end?"
echo -e "                         A shadow."
echo -e "              Or worse than a shadow — misery.\""
echo -e "                    ${grn}― Arthur Conan Doyle${rst}"
echo -e "          ${grn}Sherlock Holmes: The Ultimate Collection${rst}"
echo -e
echo -e "   ${red}█████   ${grn}█████   ${ylw}█████   ${cyn}█████   ${blu}█████   ${prp}█████   ${dprp}█████${rst}"
