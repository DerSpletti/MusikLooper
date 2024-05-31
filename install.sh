#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y mpg123 autofs

echo "Configuring autofs..."

# Suchen Sie nach dem USB-Gerät
USB_DEVICE=$(lsblk -o NAME,TRAN | grep 'usb' | awk '{print $1}' | head -n 1)

# Prüfen, ob das Gerät existiert und ob es eine Partition gibt
if lsblk | grep -q "${USB_DEVICE}1"; then
  USB_DEVICE="${USB_DEVICE}1"
fi

# Bestätigung der Geräteerkennung
echo "Der Stick wurde als /dev/$USB_DEVICE erkannt. Ist das richtig? (y/n)"
read confirmation

if [[ $confirmation != "y" ]]; then
  echo "Installation abgebrochen."
  exit 1
fi

# Debugging-Ausgaben hinzufügen
echo "USB_DEVICE: /dev/$USB_DEVICE"
echo "Autofs master file: /etc/auto.master"
echo "Autofs map file: /etc/auto.usb"

echo "/media/usb /etc/auto.usb --timeout=10" | sudo tee -a /etc/auto.master > /dev/null
echo "usb1 -fstype=vfat,rw,uid=pi,gid=pi :/dev/$USB_DEVICE" | sudo tee /etc/auto.usb > /dev/null

# Autofs neu starten und Status überprüfen
sudo systemctl restart autofs
sudo systemctl status autofs

echo "Setting up music player script..."
sudo cp play_music.py /usr/local/bin/play_music.py
sudo chmod +x /usr/local/bin/play_music.py

echo "Configuring to run script on startup..."
(crontab -l ; echo "@reboot python3 /usr/local/bin/play_music.py") | crontab -

echo "Installation complete. Please reboot the system."
