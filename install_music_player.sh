#!/bin/bash

# Installation von notwendigen Paketen
sudo apt-get update
sudo apt-get install -y mpd mpc

# Erstellen eines Mountpunktes für den USB-Stick
sudo mkdir /media/usb

# Einbinden des USB-Sticks
# Die UUID des USB-Sticks herausfinden und ersetzen (durch `blkid` ermittelbar)
echo "UUID=deine-uuid /media/usb vfat defaults,auto,users,rw,nofail 0 0" | sudo tee -a /etc/fstab

# Nach dem Neustart wird das folgende Skript automatisch ausgeführt:
# Musikwiedergabe-Skript
cat <<EOF | sudo tee /usr/local/bin/play_music.sh
#!/bin/bash

# Zufällige Wiedergabe von Musikdateien vom USB-Stick
mpc update
mpc clear
mpc load USB
mpc random on
mpc play
EOF

# Ausführbar machen des Skripts
sudo chmod +x /usr/local/bin/play_music.sh

# Einrichten eines Crontab-Eintrags, um das Musikwiedergabe-Skript beim Booten zu starten
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/play_music.sh") | crontab -

# System neu starten, um den USB-Stick automatisch einzubinden
sudo reboot
