#!/bin/bash

EXP_CONFIG_DIRS=(
  "sway"
  "swaync"
  "waybar"
)

USR_CONFIG_DIR="$HOME/.config"
EXP_DIR="$HOME/arch-config/exp"


for dir in "${EXP_CONFIG_DIRS[@]}"; do
  echo "Linking $dir..."
  if [ -d "$USR_CONFIG_DIR/$dir" ]; then
    if [ -L "$USR_CONFIG_DIR/$dir" ]; then
      echo "Symbolic link found, removing..."
      rm -rf "$USR_CONFIG_DIR/$dir"
    else
      echo "Backuping existing config..."
      cp -r "$USR_CONFIG_DIR/$dir" "$USR_CONFIG_DIR/$dir.bak"
      rm -rf "$USR_CONFIG_DIR/$dir"
    fi
  fi
  ln -s "$EXP_DIR/$dir" "$USR_CONFIG_DIR/$dir"
done
