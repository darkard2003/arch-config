#!/bin/bash

mkdir -p $HOME/.config/systemd/user

cp "./unitfiles/sway-session.target" $HOME/.config/systemd/user/
