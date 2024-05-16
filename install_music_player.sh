#!/bin/bash

# Installation von notwendigen Paketen
sudo apt-get update
sudo apt-get install -y mpd mpc

# Erstellen eines Mountpunktes für den USB-Stick
sudo mkdir /media/usb

# Einbinden des USB-Sticks
# Hinweis: Ersetzen Sie 'deine-uuid' durch die tatsächliche UUID des USB-Sticks.
# Die UUID kann mit dem Befehl `sudo blkid` ermittelt werden.
echo "UUID=deine-uuid /media/usb auto defaults,auto,users,rw,nofail,x-systemd.automount 0 0" | sudo tee -a /etc/fstab

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

# Jetzt können Sie das System neu starten, um die Änderungen wirksam zu machen
echo "Installation abgeschlossen. Bitte starten Sie das System neu, um die Musikwiedergabe zu starten."
