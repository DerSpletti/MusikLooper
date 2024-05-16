#!/bin/bash

# Installation von notwendigen Paketen
sudo apt-get update
sudo apt-get install -y mpd mpc

# Erstellen eines Mountpunktes für den USB-Stick
sudo mkdir -p /media/usb

# Automatisches Finden der UUID des USB-Sticks
# Hinweis: Dies setzt voraus, dass nur ein USB-Speichergerät angeschlossen ist.
# Prüfen, ob eine Partition vorhanden ist oder nicht
DEVICE="/dev/sda"  # Gerätebasispfad
PARTITION=$(lsblk -no NAME $DEVICE | grep -o '^sda[0-9]')
if [ -z "$PARTITION" ]; then
    UUID=$(lsblk -no UUID $DEVICE)
else
    UUID=$(lsblk -no UUID /dev/$PARTITION)
fi

if [ -z "$UUID" ]; then
  echo "Kein USB-Stick gefunden. Bitte stellen Sie sicher, dass der Stick eingesteckt ist und versuchen Sie es erneut."
  exit 1
fi

# Einbinden des USB-Sticks in die fstab
echo "UUID=$UUID /media/usb auto defaults,auto,users,rw,nofail,x-systemd.automount 0 0" | sudo tee -a /etc/fstab

# Konfiguration von MPD
sudo sed -i '/music_directory/c\music_directory "/media/usb"' /etc/mpd.conf

# Musikwiedergabe-Skript
cat <<EOF | sudo tee /usr/local/bin/play_music.sh
#!/bin/bash

# Warten, bis der USB-Stick verfügbar ist
while ! mountpoint -q /media/usb; do
  sleep 1
done

# Aktualisieren der MPD-Datenbank und Abspielen der Musik
mpc update
mpc clear
mpc add /
mpc random on
mpc play
EOF

# Ausführbar machen des Skripts
sudo chmod +x /usr/local/bin/play_music.sh

# Einrichten eines Crontab-Eintrags, um das Musikwiedergabe-Skript beim Booten zu starten
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/play_music.sh") | crontab -

# Ausgabe der Erfolgsmeldung
echo "Installation abgeschlossen. Bitte starten Sie das System neu, um die Musikwiedergabe zu starten."
