#!/bin/bash

echo "Removing music player script..."
sudo rm /usr/local/bin/play_music.py

echo "Removing autofs configuration..."
sudo sed -i '/\/media\/usb \/etc\/auto.usb --timeout=10/d' /etc/auto.master
sudo rm /etc/auto.usb
sudo systemctl restart autofs

echo "Removing crontab entry..."
crontab -l | grep -v '@reboot python3 /usr/local/bin/play_music.py' | crontab -

echo "Uninstallation complete."
