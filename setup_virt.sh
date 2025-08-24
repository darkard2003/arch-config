#!/bin/bash

echo "Installing virt-manager"
yay -S qemu-base virt-manager bridge-utils dnsmasq

echo "Setting up virt-manager"
if ! groups $USER | grep -q libvirt; then
  echo "Adding user to libvirt group"
  sudo usermod -a -G libvirt USER
else
  echo "User is already in libvirt group"
fi

