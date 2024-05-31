import os
import time
import random
import subprocess

MOUNT_POINT = "/media/usb/usb1"
MUSIC_EXTENSIONS = [".mp3", ".wav", ".ogg"]

def get_music_files(mount_point):
    music_files = []
    for root, dirs, files in os.walk(mount_point):
        for file in files:
            if any(file.endswith(ext) for ext in MUSIC_EXTENSIONS):
                music_files.append(os.path.join(root, file))
    return music_files

def play_random_music(music_files):
    if not music_files:
        return None
    random.shuffle(music_files)
    for file in music_files:
        subprocess.run(["mpg123", file])

def is_usb_mounted(mount_point):
    return os.path.ismount(mount_point)

try:
    while True:
        if is_usb_mounted(MOUNT_POINT):
            music_files = get_music_files(MOUNT_POINT)
            play_random_music(music_files)
        else:
            time.sleep(1)
except KeyboardInterrupt:
    print("Wiedergabe gestoppt.")
