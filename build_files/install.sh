#!/usr/bin/env bash
set -xeuo pipefail

# install basic packages and tools
pacman --noconfirm -Sy dracut linux linux-firmware linux-headers glibc glib2 ostree systemd dbus flatpak

# install packages
/prepare/files/install-packages.sh "/prepare/files/packages.conf" "pacman --noconfirm -Sy"

# install bootc
pacman --noconfirm -Sy rust go-md2man
git clone "https://github.com/bootc-dev/bootc.git" /tmp/bootc
cd /tmp/bootc && make bin install-all

# enable flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo