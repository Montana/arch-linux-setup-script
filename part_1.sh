#!/bin/bash

SD_CARD="/dev/sdx"
ARCHLINUX_ARM_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"

echo "Partitioning and formatting the SD card..."
fdisk $SD_CARD <<EOF
o
n
p
1

+200M
t
c
n
p
2


w
EOF

mkfs.vfat "${SD_CARD}1"
mkfs.ext4 "${SD_CARD}2"

mkdir -p /mnt/archarm/boot
mount "${SD_CARD}2" /mnt/archarm
mount "${SD_CARD}1" /mnt/archarm/boot

echo "Downloading and extracting Arch Linux ARM..."
wget $ARCHLINUX_ARM_URL -O /tmp/archlinuxarm.tar.gz
tar -xzf /tmp/archlinuxarm.tar.gz -C /mnt/archarm

sync
echo "Initial setup is device-specific. Please refer to the Arch Linux ARM documentation for your device."

echo "Arch Linux ARM initial setup complete. Please refer to the device-specific instructions for bootloader setup and further configuration."
