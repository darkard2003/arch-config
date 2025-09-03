#!/bin/bash


CONFIGS=( 
  "ghostty" 
  "kanata"
  "kitty"
  "nvim"
  "sway"
  "swaylock"
  "swaync"
  "tmux"
  "waybar"
  "wob"
  "wofi"
  "code-flags.conf"
  "qutebrowser"
  "niri"
  "kanshi"
) 

safe_clean(){
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "creating backup of $1 to $1.bak"
    mv "$1" "$1.bak"
  elif [ -L "$1" ]; then
    rm "$1"
  fi
}

if [ "$1" == "-only" ]; then
  only_configs=( "$@" )
  # remove the -only argument
  only_configs=( "${only_configs[@]:1}" )
  for i in ${only_configs[@]}; do
    if [ -e "$PWD/$i" ]; then
      echo "Linking $i"
      safe_clean "$HOME/.config/$i"
      ln -s "$PWD/$i" "$HOME/.config/$i"
    else
      echo "Config $i does not exist in arch-config"
    fi
    exit 0
  done
fi

for i in ${CONFIGS[@]}; do
  echo "Linking $i"
  config_dir="$HOME/.config/$i"
  safe_clean $config_dir
  ln -s "$PWD/$i" $config_dir
done

