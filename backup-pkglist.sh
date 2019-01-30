#!/usr/bin/env bash

pacman -Qneq > $HOME/dotfiles/install/pacman-native-explicit.txt
pacman -Qmeq > $HOME/dotfiles/install/pacman-foreign-explicit.txt
