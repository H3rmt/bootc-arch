#!/usr/bin/env bash
set -xeuo pipefail

# basic gui programs
/prepare/files/install-packages.sh "/prepare/files/programs.conf" pacman --noconfirm -S

# Aur Packages
su builder -c '/prepare/files/install-packages.sh "/prepare/files/aur-packages.conf" yay --noconfirm --needed -S'

# Hyprland
/prepare/files/install-packages.sh "/prepare/files/hyprland-files.conf" pacman --noconfirm -S

systemctl enable sddm.service
