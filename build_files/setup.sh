#!/usr/bin/env bash

set -xeuo pipefail

# configure pacman keys
pacman-key --init
pacman --noconfirm -Syuu sudo-rs uutils-coreutils archlinux-keyring git base-devel

mkdir -p /usr/lib/sysimage/lib/pacman/ /usr/lib/sysimage/cache/pacman/pkg/
cp -r /var/lib/pacman/* /usr/lib/sysimage/lib/pacman/

install -Dm644 /prepare/files/pacman/pacman.conf           /etc/pacman.conf
install -Dm644 /prepare/files/pacman/mirrorlist            /etc/pacman.d/mirrorlist
install -Dm755 /prepare/files/pacman/install-cachy.sh      /tmp/install-cachy.sh

# switch to cachy mirrors
/tmp/install-cachy.sh