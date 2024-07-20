#!/bin/bash

# Udev-Regel entfernen
sudo rm /etc/udev/rules.d/99-play-music.rules

# Skript zum Abspielen der Musik entfernen
sudo rm /usr/local/bin/play_music.sh

# Pakete deinstallieren
sudo apt remove -y usbmount mpv

# Udev-Dienst neu starten
sudo udevadm control --reload-rules
sudo systemctl restart udev

echo "Deinstallation abgeschlossen."
