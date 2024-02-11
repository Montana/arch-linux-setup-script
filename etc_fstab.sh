#!/bin/bash

setup_mount_details() {
    UUID="your-uuid-here" 
    MOUNT_POINT="/mnt/my_mount_point" 
    TYPE="ext4" 
    OPTIONS="defaults" 
    DUMP="0" 
    PASS="2" 
}

create_mount_point() {
    echo "Creating mount point directory: $MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
}

backup_fstab() {
    echo "Backing up /etc/fstab to /etc/fstab.backup"
    cp /etc/fstab /etc/fstab.backup
}

add_fstab_entry() {
    echo "Adding new fstab entry for $MOUNT_POINT..."
    echo "UUID=$UUID $MOUNT_POINT $TYPE $OPTIONS $DUMP $PASS" | sudo tee -a /etc/fstab > /dev/null
}

main() {
    setup_mount_details
    create_mount_point
    backup_fstab
    add_fstab_entry
    echo "New /etc/fstab entry added successfully."
}

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

main
