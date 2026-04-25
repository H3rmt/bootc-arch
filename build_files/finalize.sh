#!/usr/bin/env bash

set -xeuo pipefail

# 1) Install dracut config used for bootc/ostree boot
install -Dm644 /prepare/files/dracut.conf /etc/dracut.conf.d/bootc.conf

# 2) Build initramfs for the installed kernel
kernel_dir="$(find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d \
  | grep -v '\.img$' \
  | sort \
  | tail -n 1)"

dracut --force "${kernel_dir}/initramfs.img"

# remove yay and pacman
pacman --noconfirm -Rs yay-bin rust go-md2man
pacman --noconfirm -Rdd --noconfirm pacman

rm -rf \
  /boot \
  /home \
  /root \
  /usr/local \
  /srv \
  /mnt \
  /var \
  /usr/lib/sysimage/log \
  /usr/lib/sysimage/cache/pacman/pkg

# remove to setup with systemd-firstboot
rm -rf /etc/machine-id /etc/hostname /etc/localtime /etc/shadow

mkdir -p /sysroot /boot /usr/lib/ostree /var

ln -sT sysroot/ostree /ostree
ln -sT var/roothome /root
ln -sT var/srv /srv
ln -sT var/mnt /mnt
ln -sT var/home /home
ln -sT ../var/usrlocal /usr/local

# 6) Ensure those target directories are created automatically at boot
cat > /usr/lib/tmpfiles.d/bootc-base-dirs.conf <<'EOF'
d /var/home      0755 root root -
d /var/srv       0755 root root -
d /var/mnt       0755 root root -
d /var/usrlocal  0755 root root -
d /var/roothome  0700 root root -
d /run/media     0755 root root -
EOF