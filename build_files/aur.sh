#!/usr/bin/env bash
set -xeuo pipefail

# create builder user to build yay and other aur packages (can use sudo)
groupadd -g 10005 builder || true
useradd -m builder -u 10005 -g 10005 || true
cat >/etc/sudoers.d/builder <<'EOF'
builder ALL=(ALL) NOPASSWD: ALL
Defaults:builder !requiretty
EOF
chmod 440 /etc/sudoers.d/builder

# can't run makepkg as root, so we have to do it as builder
# can't finish the install as builder because install needs root
su builder -c '
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  cd /tmp/yay-bin
  makepkg -s --noconfirm
'
pacman -U --noconfirm /tmp/yay-bin/*.pkg.tar.zst
which yay