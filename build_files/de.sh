#!/usr/bin/env bash

set -xeuo pipefail

# basic gui programs
pacman --noconfirm -Sy \
    alacritty firefox chromium pavucontrol mpv \
    podman-desktop rofi yad gnome-tweaks nautilus \
    gnome-keyring wl-clipboard playerctl pipewire wireplumber \
    slurp grim swappy fuzzel ydotool sddm archlinux-themes-sddm \
    candy-icons-git plymouth-theme-hud-3-git \
    tuxedo-control-center-bin tuxedo-drivers-dkms \
    gnome-software gnome-autoar gnome-bluetooth gnome-disk-utility \
    gnome-disk-utility gnome-keyring gnome-power-manager xdg-desktop-portal-gnome \

pacman --noconfirm -Sy \
    hyprland \
    hyprpicker hypridle hyprlock xdg-desktop-portal-hyprland hyprpaper \
    hyprsysteminfo hyprpolkitagent hyprland-qt-support hyprshutdown hyprcursor \
    dunst waybar udiskie

systemctl enable sddm.service