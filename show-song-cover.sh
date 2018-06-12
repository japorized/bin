#!/bin/bash

# Script intended to be executed from ncmpcpp (execute_on_song_change
# preference) running from urxvt to set album cover as background image

# Copyright (c) 2013  Vyacheslav Levit
# Licensed under The MIT License: http://opensource.org/licenses/MIT

MUSIC_DIR=$HOME/Music
COVER=$HOME/.cache/cover.jpg

# . "${HOME}/.cache/wal/colors.sh"

function reset_background
{
    # is there any better way?
    printf "\e]20;;100x100+1000+1000\a"
}

{
    album="$(mpc --format %album% current)"
    file="$(mpc --format %file% current)"
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"

    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER"
    if [[ -n "$src" ]] ; then
        convert "$src" -resize 300x "$COVER"
        if [[ -f "$COVER" ]] ; then
            # printf "\e]11;0:${background}\a"
            # printf "\e]708;0:${background}\a"
            printf "\e]20;${COVER};30x30+1+50:op=keep-aspect\a"
        else
            reset_background
        fi
    else
        reset_background
    fi
} &
