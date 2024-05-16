#!/bin/bash

# Stoppen des Music Player Daemon
sudo systemctl stop mpd.service

# Deinstallation der installierten Pakete
sudo apt-get remove --purge -y mpd mpc

# Entfernen des Eintrags aus der /etc/fstab
sudo sed -i '/\/media\/usb/d' /etc/fstab

# Unmounten und Entfernen des Mountpunktes für den USB-Stick
sudo umount /media/usb
sudo rmdir /media/usb

# Entfernen des Musikwiedergabe-Skripts
sudo rm -f /usr/local/bin/play_music.sh

# Entfernen des Crontab-Eintrags
(crontab -l | grep -v '/usr/local/bin/play_music.sh') | crontab -

# Wiederherstellen der ursprünglichen MPD-Konfiguration, falls notwendig
# Dies hängt von Ihrer ursprünglichen MPD-Konfiguration ab.
# Zum Beispiel: sudo sed -i '/music_directory/c\music_directory "/var/lib/mpd/music"' /etc/mpd.conf

# Entfernen nicht mehr benötigter Abhängigkeiten
sudo apt-get autoremove -y

# Optionaler Neustart oder Meldung, dass der Vorgang abgeschlossen ist
echo "Deinstallation abgeschlossen. Es wird empfohlen, das System neu zu starten."
