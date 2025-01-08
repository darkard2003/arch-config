#!/bin/bash

CONFIGS=( 
  "ghostty" 
  "kanata"
  "kitty"
  "nvim"
  "sway"
  "swaylock"
  "swaync"
  "waybar"
  "wofi"
) 

safe_clean(){
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "creating backup of $1 to $1.bak"
    mv "$1" "$1.bak"
  elif [ -L "$1" ]; then
    rm "$1"
  fi
}

for i in ${CONFIGS[@]}; do
  echo "Linking $i"
  config_dir="$HOME/.config/$i"
  safe_clean $config_dir
  ln -s "$PWD/$i" $config_dir
done
