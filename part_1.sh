#!/bin/bash

# Define variables
SD_CARD="/dev/sdx" # Replace /dev/sdx with your SD card device. Be very careful with this!
ARCHLINUX_ARM_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"

# WARNING: The following steps will erase the storage device you specify.
# Ensure you have selected the correct device and have backups if necessary.

# Step 1: Partition and format the SD card
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

# Replace sdX in the following commands with the actual device name of your SD card.
mkfs.vfat "${SD_CARD}1"
mkfs.ext4 "${SD_CARD}2"

# Step 2: Mount the partitions
mkdir -p /mnt/archarm/boot
mount "${SD_CARD}2" /mnt/archarm
mount "${SD_CARD}1" /mnt/archarm/boot

# Step 3: Download and extract the Arch Linux ARM root filesystem
echo "Downloading and extracting Arch Linux ARM..."
wget $ARCHLINUX_ARM_URL -O /tmp/archlinuxarm.tar.gz
tar -xzf /tmp/archlinuxarm.tar.gz -C /mnt/archarm

# Step 4: Initial setup (this part varies greatly by device, check the Arch Linux ARM documentation)
# Example for a generic setup
sync
echo "Initial setup is device-specific. Please refer to the Arch Linux ARM documentation for your device."

# Final message
echo "Arch Linux ARM initial setup complete. Please refer to the device-specific instructions for bootloader setup and further configuration."
