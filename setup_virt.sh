#!/bin/bash

yay -S qemu-base virt-manager bridge-utils dnsmasq

sudo -v

sudo usermod -aG libvirt $USER

