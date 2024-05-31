# MusikLooper

Dieses Projekt spielt automatisch Musik von einem USB-Stick ab, wenn dieser an den Raspberry Pi 3B angeschlossen wird.

## Installation

1. Klonen Sie das Repository:
    ```bash
    git clone https://github.com/DerSpletti/MusikLooper.git
    cd MusikLooper
    ```

2. Führen Sie das Installationsskript aus:
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```

3. Starten Sie das System neu:
    ```bash
    sudo reboot
    ```

## Deinstallation

1. Führen Sie das Deinstallationsskript aus:
    ```bash
    chmod +x uninstall.sh
    sudo ./uninstall.sh
    ```

## Hinweise

- Stellen Sie sicher, dass die Musikdateien im unterstützten Format (.mp3, .wav, .ogg) vorliegen.
- Passen Sie die Mount-Punkte und Datei-Erweiterungen nach Bedarf an.
