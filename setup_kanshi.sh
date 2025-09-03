#!/bin/bash

mkdir -p $HOME/.config/systemd/user

cp ./unitfiles/kanshi.service $HOME/.config/systemd/user/kanshi.service

systemctl --user enable kanshi.service
