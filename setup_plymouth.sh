#!/bin/bash

TMP_DIR="temp"
PLYMOUTH_THEME="plymouth-catppuccin"

TMP_PATH_PLYMOUTH="./$TMP_DIR/$PLYMOUTH_THEME"

sudo -v

git clone https://github.com/catppuccin/plymouth.git  $TMP_PATH_PLYMOUTH

sudo cp -r "$TMP_PATH_PLYMOUTH/themes/*" "/usr/share/plymouth/themes/"

sudo plymouth-set-default-theme -R catppuccin-mocha

