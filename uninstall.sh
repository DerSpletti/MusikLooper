#!/bin/bash

echo "Removing music player script..."
sudo rm /usr/local/bin/play_music.py

echo "Removing udev rules..."
sudo rm /etc/udev/rules.d/99-usb-autmount.rules

echo "Removing crontab entry..."
crontab -l | grep -v '@reboot python3 /usr/local/bin/play_music.py' | crontab -

echo "Uninstallation complete. Please reboot the system."
