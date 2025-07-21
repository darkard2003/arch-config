#!/bin/bash

CONFIG_DIR="$HOME/arch-config"
WALLPAPER_DIR="$CONFIG_DIR/wallpapers"
TEMP_DIR="$CONFIG_DIR/temp"
THEME_DIR="$HOME/.cache/wal"

set -e

image=$(ls "$WALLPAPER_DIR" | sed 's/\..*$//' | wofi -d)

# Check if the image is selected 

if [ -z "$image" ]; then
  echo "No image selected"
  exit 1
fi

echo "Changing sway wallpaper to $image"
echo "output * bg $WALLPAPER_DIR/$image.jpg fill" > $CONFIG_DIR/sway/wallpaper.conf

echo "Generating pywal colorscheme"
wal -i $WALLPAPER_DIR/$image.jpg

echo "Copying theme"
cp $THEME_DIR/colors-sway $CONFIG_DIR/sway
cp $THEME_DIR/colors-waybar.css $CONFIG_DIR/waybar
cp $THEME_DIR/colors.css $CONFIG_DIR/swaync

echo "Reloading swaync"
swaync-client -R && swaync-client -rs

