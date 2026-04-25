#!/usr/bin/env bash

set -xeuo pipefail

# Basic configs
install -Dm644 /prepare/files/locale.conf           /etc/locale.conf
install -Dm644 /prepare/files/locale.gen            /etc/locale.gen
install -Dm644 /prepare/files/.zshrc                /etc/skel/.zshrc
install -Dm644 /prepare/files/plymouthd.conf        /etc/plymouth/plymouthd.conf
ln -s /usr/share/zoneinfo/Europe/Berlin             /etc/localtime
install -Dm644 /prepare/files/prepare-root.conf     /usr/lib/ostree/prepare-root.conf

# copy after boot script and service
install -Dm755 /prepare/files/after-boot.sh      /opt/after-boot/after-boot.sh
install -Dm644 /prepare/files/flatpak-apps.txt   /opt/after-boot/flatpak-apps.txt
install -Dm644 /prepare/files/after-boot.service /usr/lib/systemd/system/after-boot.service
systemctl enable after-boot.service

# Enable homed
systemctl enable systemd-homed.service

# generate locales
locale-gen

# Enable firstboot to run after installation
systemctl enable systemd-firstboot.service