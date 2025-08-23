#!/bin/bash

if ! grep -q "Arch Linux" /etc/os-release; then
  echo "This script is only for Arch Linux"
  exit 1
fi

INTEL_EXTRA_DEPS=(
  "intel-ucode"
  "vulkan-intel"
  "libva-intel-driver"
  "libva-utils"
)

AMD_EXTRA_DEPS=(
  "amd-ucode"
  "vulkan-radeon"
)

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

package_list=$(cat deps.txt)

if [ $(uname -m) == "x86_64" ]; then
  if grep -q "amd" /proc/cpuinfo; then
      echo "AMD CPU detected"
      package_list+=(${AMD_EXTRA_DEPS[@]})
    elif grep -q "intel" /proc/cpuinfo; then
      echo "Intel CPU detected"
      package_list+=(${INTEL_EXTRA_DEPS[@]})
    else 
      echo "Unknown CPU detected"
      echo "Please microcode and vulkan drivers if needed"
  fi
else 
  echo "Unknown architecture detected"
  echo "Some packages may not be installable"
fi


for package in ${package_list[@]}; do
  if ! yay -Q $package &> /dev/null; then
    echo "$package is not installed"
    install_list+=($package)
  else
    echo "$package is already installed"
  fi
done

if [ ${#install_list[@]} -eq 0 ]; then
  echo "All packages are already installed"
else
  echo "Installing packages: ${install_list[@]}"
  read -p "Do you want to continue? (y/n) " -n 1 -r
  yay -S ${install_list[@]}
fi

echo "Installing tmux plugin manager"
if [ -d ~/.tmux/plugins/tpm ]; then
  echo "tpm is already installed"
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
