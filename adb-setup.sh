#!/bin/sh
sudo mkdir -p /run/udev/rules.d;
sudo cp /etc/udev/rules.d/*.rules $chasn/51-android.rules /run/udev/rules.d;
sudo udevadm control --reload
