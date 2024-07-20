#!/bin/bash

# Update und Installation der benötigten Pakete
sudo apt update
sudo apt install -y usbmount mpv

# Konfigurationsdatei für usbmount anpassen
sudo sed -i 's/^FILESYSTEMS.*/FILESYSTEMS="vfat ext2 ext3 ext4 hfsplus ntfs exfat"/' /etc/usbmount/usbmount.conf
sudo sed -i 's/^MOUNTOPTIONS.*/MOUNTOPTIONS="sync,noexec,nodev,noatime,nodiratime"/' /etc/usbmount/usbmount.conf
sudo sed -i 's/^FS_MOUNTOPTIONS.*/FS_MOUNTOPTIONS="-fstype=vfat,uid=pi,gid=pi -fstype=ext2,uid=pi,gid=pi -fstype=ext3,uid=pi,gid=pi -fstype=ext4,uid=pi,gid=pi"/' /etc/usbmount/usbmount.conf

# Skript zum Abspielen der Musik erstellen
sudo bash -c 'cat <<EOF > /usr/local/bin/play_music.sh
#!/bin/bash

# Verzeichnis des USB-Mounts
MOUNT_DIR="/media/usb0"

# Prüfen, ob das Verzeichnis existiert
if [ -d "$MOUNT_DIR" ]; then
    # Suche nach Musikdateien und spiele sie zufällig ab
    find "$MOUNT_DIR" -type f \\( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" \\) -print0 | xargs -0 mpv --shuffle
fi
EOF'

# Skript ausführbar machen
sudo chmod +x /usr/local/bin/play_music.sh

# Udev-Regel erstellen
sudo bash -c 'cat <<EOF > /etc/udev/rules.d/99-play-music.rules
ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd[b-z][1-9]", RUN+="/usr/local/bin/play_music.sh"
EOF'

# Udev-Dienst neu starten
sudo udevadm control --reload-rules
sudo systemctl restart udev

echo "Installation abgeschlossen."
