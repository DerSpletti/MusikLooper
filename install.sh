#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y mpg123 autofs

echo "Configuring autofs..."
echo "/media/usb /etc/auto.usb --timeout=10" | sudo tee -a /etc/auto.master > /dev/null
echo "usb1 -fstype=vfat,rw,uid=pi,gid=pi :/dev/sda1" | sudo tee /etc/auto.usb > /dev/null
sudo systemctl restart autofs

echo "Setting up music player script..."
sudo cp play_music.py /usr/local/bin/play_music.py
sudo chmod +x /usr/local/bin/play_music.py

echo "Configuring to run script on startup..."
(crontab -l ; echo "@reboot python3 /usr/local/bin/play_music.py") | crontab -

echo "Installation complete. Please reboot the system."
