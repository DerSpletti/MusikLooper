#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y mpg123 udisks2

echo "Configuring udev rules for automatic mounting..."

# Erstellen der udev-Regel
UDEV_RULE='KERNEL=="sd*", ACTION=="add", SUBSYSTEM=="block", ENV{ID_BUS}=="usb", RUN+="/usr/bin/udisksctl mount -b /dev/%k"'
echo $UDEV_RULE | sudo tee /etc/udev/rules.d/99-usb-autmount.rules

# Anwenden der udev-Regeln
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Creating mount point and setting permissions..."
sudo mkdir -p /media/usb
sudo chmod 777 /media/usb

echo "Setting up music player script..."
sudo cp play_music.py /usr/local/bin/play_music.py
sudo chmod +x /usr/local/bin/play_music.py

echo "Configuring to run script on startup..."
(crontab -l ; echo "@reboot python3 /usr/local/bin/play_music.py") | crontab -

echo "Installation complete. Please reboot the system."
