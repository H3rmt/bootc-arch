#!/usr/bin/env bash

set -xeuo pipefail

# install basic packages and tools
pacman --noconfirm -Sy dracut qrencode linux linux-firmware linux-headers glibc less zsh tree tmux \
    ostree btrfs-progs e2fsprogs openssh exfat-utils dosfstools skopeo lsof \
    ttf-jetbrains-mono-nerd dbus-glib glib2 shadow man dbus rocm-smi-lib \
    intel-ucode micro git sudo systemd noto-fonts cantarell-fonts ncdu htop btop zoxide \
    upower powertop nvme-cli smartmontools bluez plymouth fzf networkmanager \
    ripgrep make brightnessctl flatpak pkgstats distrobox podman podman-compose gparted exfatprogs \
    pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse \
    yazi poppler poppler-data fd jq zstd ffmpeg chafa resvg \
    zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting

# install bootc
pacman --noconfirm -Sy rust go-md2man
git clone "https://github.com/bootc-dev/bootc.git" /tmp/bootc
cd /tmp/bootc && make bin install-all

# enable flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo