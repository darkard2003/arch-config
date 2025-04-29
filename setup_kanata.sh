echo "Give sudo permission to continue"
sudo -v

sudo groupadd uinput

sudo usermod -aG uinput $USER
sudo usermod -aG input $USER

touch /etc/udev/rules.d/99-input.rules

sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > /etc/udev/rules.d/99-input.rules
sudo udevadm control --reload-rules && sudo udevadm trigger

sudo modprobe uinput

cp -sf "./services/kanata.service" "$HOME/.config/systemd/user/kanata.service"
sudo systemctl --user enable kanata.service

echo "Reboot your system to take effect"
