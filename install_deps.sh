#!/bin/bash

# Check if yay is installed and install it if not
if ! command -v yay &> /dev/null
then
  read -p "yay is not installed, do you want to install it? (y/n) " -n 1 -r
    echo "yay could not be found, installing yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "yay is already installed"
fi

install_list=()

for package in $(cat deps.txt); do
  if ! yay -Q $package &> /dev/null; then
    echo "$package is not installed"
    install_list+=($package)
  else
    echo "$package is already installed"
  fi
done

if [ ${#install_list[@]} -eq 0 ]; then
  echo "All packages are already installed"
  exit 0
fi

echo "Installing packages: ${install_list[@]}"
read -p "Do you want to continue? (y/n) " -n 1 -r

yay -S ${install_list[@]}
