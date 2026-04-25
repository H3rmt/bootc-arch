#!/usr/bin/env bash

set -xeuo pipefail

# configure pacman keys
pacman-key --init
pacman --noconfirm -Syu

mkdir -p /usr/lib/sysimage/lib/pacman/ /usr/lib/sysimage/cache/pacman/pkg/
cp -r /var/lib/pacman/* /usr/lib/sysimage/lib/pacman/

install -Dm644 /prepare/files/pacman/pacman.conf           /etc/pacman.conf
install -Dm644 /prepare/files/pacman/mirrorlist            /etc/pacman.d/mirrorlist
install -Dm755 /prepare/files/pacman/install-cachy.sh      /tmp/install-cachy.sh

# switch to cachy mirrors
/tmp/install-cachy.sh

# install basic packages and tools
pacman --noconfirm -Sy dracut linux linux-firmware less zsh tree tmux \
    ostree btrfs-progs e2fsprogs openssh exfat-utils dosfstools skopeo \
    ttf-jetbrains-mono-nerd dbus-glib glib2 shadow man dbus base-devel \
    intel-ucode micro git sudo systemd noto-fonts ncdu htop btop yazi zoxide \
    upower powertop nvme-cli smartmontools bluez plymouth fzf networkmanager \
    ripgrep make brightnessctl flatpak pkgstats distrobox podman gparted

# install bootc
pacman --noconfirm -Sy rust go-md2man
git clone "https://github.com/bootc-dev/bootc.git" /tmp/bootc
cd /tmp/bootc && make bin install-all

# enable flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo