#!/usr/bin/env bash

set -xeuo pipefail

# basic gui programs
pacman --noconfirm -Sy \
    alacritty firefox chromium pavucontrol mpv \
    podman-desktop rofi yad gnome-tweaks nautilus \
    gnome-keyring wl-clipboard playerctl pipewire wireplumber \
    slurp grim swappy fuzzel ydotool sddm evince gvfs-mtp \
    gnome-software gnome-autoar gnome-bluetooth-3.0 gnome-disk-utility \
    gnome-disk-utility gnome-keyring gnome-power-manager xdg-desktop-portal-gnome \

su builder -c '
  yay --noconfirm --needed -S \
    visual-studio-code-bin \
    jetbrains-toolbox \
    google-chrome \
    tuxedo-control-center-bin tuxedo-drivers-dkms \
    candy-icons-git plymouth-theme-loader-alt-git \
    archlinux-themes-sddm \
'

pacman --noconfirm -Sy \
    hyprland \
    hyprpicker hypridle hyprlock xdg-desktop-portal-hyprland hyprpaper \
    hyprpolkitagent hyprland-qt-support hyprcursor \
    dunst waybar udiskie

systemctl enable sddm.service
