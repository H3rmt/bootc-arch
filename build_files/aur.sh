#!/usr/bin/env bash

set -xeuo pipefail

# install paru
groupadd -g 771 builder || true
useradd -m builder -u 771 -g 771 || true
cat >/etc/sudoers.d/builder <<'EOF'
builder ALL=(ALL) NOPASSWD: ALL
Defaults:builder !requiretty
EOF
chmod 440 /etc/sudoers.d/builder

# cant run makepkg as root, so we have to do it as builder
# cant finish the install as builder because install needs root
su builder -c '
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  cd /tmp/yay-bin
  makepkg -s --noconfirm
'
pacman -U --noconfirm /tmp/yay-bin/*.pkg.tar.zst
which yay
su builder -c '
  yay --noconfirm --needed -S \
    visual-studio-code-bin \
    jetbrains-toolbox \
    google-chrome
'
rm -f /etc/sudoers.d/builder
userdel -r builder || true
groupdel builder || true