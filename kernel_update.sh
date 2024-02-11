#!/bin/bash

set -e 

WORKDIR="$HOME/kernel_build"
KERNEL_VERSION="latest" 
ARCH="arm64"

install_dependencies() {
    sudo pacman -Syu --needed base-devel git bc wget
}

prepare_workdir() {
    mkdir -p "$WORKDIR" && cd "$WORKDIR"
}

download_kernel_source() {
    if [[ "$KERNEL_VERSION" == "latest" ]]; then
        echo "Determining the latest stable kernel version..."
        KERNEL_VERSION=$(wget -qO- https://www.kernel.org/ | grep -Po 'latest_link" href="/version/\K[^"]*' | head -1)
    fi

    echo "Downloading kernel version $KERNEL_VERSION..."
    wget "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.xz"
}

extract_kernel_source() {
    tar xf "linux-$KERNEL_VERSION.tar.xz"
    cd "linux-$KERNEL_VERSION"
}

configure_kernel() {
    zcat /proc/config.gz > .config

    make ARCH=$ARCH menuconfig
}

compile_and_install_kernel() {
    make ARCH=$ARCH -j"$(nproc)"

    sudo make ARCH=$ARCH modules_install

    sudo cp -v arch/$ARCH/boot/Image /boot/vmlinuz-linux-custom
    sudo mkinitcpio -k "$KERNEL_VERSION" -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-custom.img
}

update_bootloader() {
    sudo cp -v .config /boot/config-"$KERNEL_VERSION"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

cleanup() {
    cd $HOME
    rm -rf "$WORKDIR"
}
