echo "Give sudo permission to continue"
sudo -v

TEMP_DIR="./temp"

if [ ! -d $TEMP_DIR ]; then
  mkdir $TEMP_DIR
fi

sudo groupadd uinput

sudo usermod -aG uinput $USER
sudo usermod -aG input $USER

touch $TEMP_DIR/99-input.rules

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > $TEMP_DIR/99-input.rules
sudo cp $TEMP_DIR/99-input.rules /etc/udev/rules.d/99-input.rules

sudo udevadm control --reload-rules && sudo udevadm trigger

sudo modprobe uinput

CONFIG_DIR="$HOME/.config/systemd/user"

[ ! -d $CONFIG_DIR ] || mkdir -p $CONFIG_DIR

cp "./services/kanata.service" "$HOME/.config/systemd/user/kanata.service"
systemctl --user enable kanata.service

echo "Reboot your system to take effect"
