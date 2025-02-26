#!/bin/bash

TEMP_DIR="temp"
GRUB_DIR="grub"
wd="$PWD"

TEMP_DIR_GRUB="$TEMP_DIR/$GRUB_DIR"

git clone https://github.com/catppuccin/grub.git $TEMP_DIR_GRUB && cd $TEMP_DIR_GRUB
sudo cp -r src/* /usr/share/grub/themes/

cd $wd
