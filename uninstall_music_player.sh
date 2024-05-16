#!/bin/bash

# Stoppen des Music Player Daemon
sudo systemctl stop mpd.service

# Deinstallation der Pakete
sudo apt-get remove --purge -y mpd mpc

# Entfernen des Mountpunkts für den USB-Stick
sudo sed -i '/\/media\/usb/d' /etc/fstab
sudo umount /media/usb
sudo rmdir /media/usb

# Entfernen des Musikwiedergabe-Skripts
sudo rm -f /usr/local/bin/play_music.sh

# Entfernen des Crontab-Eintrags
(crontab -l | grep -v '/usr/local/bin/play_music.sh') | crontab -

# Wiederherstellen der Original-MPD-Konfiguration
sudo sed -i '/music_directory/c\music_directory "/var/lib/mpd/music"' /etc/mpd.conf

# Optionale Bereinigung: Entfernen nicht mehr benötigter Pakete
sudo apt-get autoremove -y

# Neustarten des Systems, um alle Änderungen wirksam zu machen (optional)
echo "Deinstallation abgeschlossen. Es wird empfohlen, das System neu zu starten."
