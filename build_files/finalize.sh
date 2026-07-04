#!/usr/bin/env bash
set -xeuo pipefail

# Generate locales
locale-gen

# Build initramfs with dracut, using the latest kernel available in /usr/lib/modules
ls -la /usr/lib/modules
kernel_dir="$(find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d | grep -v '\.img$' | sort | tail -n 1)"
depmod "${kernel_dir##*/}"
dracut --force "${kernel_dir}/initramfs.img"

# remove builder user
rm -f /etc/sudoers.d/builder
userdel -r builder || true
groupdel builder || true

# remove yay and pacman
pacman --noconfirm -Rs yay-bin rust go-md2man
pacman --noconfirm -Rdd --noconfirm pacman

systemctl daemon-reload

# Enable filesystem trim
systemctl enable fstrim.timer

# Enable filesystem backups
systemctl enable timeshift-hourly.timer

# Enable homed
systemctl enable systemd-homed.service

# Enable firstboot to run after installation
systemctl enable systemd-firstboot.service

# Enable NetworkManager
systemctl enable NetworkManager.service

# remove to setup with systemd-firstboot
rm -rf /etc/machine-id /etc/hostname /etc/localtime /etc/shadow

# remove dirs
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

mkdir -p /sysroot /boot /usr/lib/ostree /var

# link target directories to sysroot for ostree-prepare-root
ln -sT sysroot/ostree /ostree
ln -sT var/roothome /root
ln -sT var/srv /srv
ln -sT var/mnt /mnt
ln -sT var/home /home
ln -sT ../var/usrlocal /usr/local

# Ensure those target directories are created automatically at boot
cat > /usr/lib/tmpfiles.d/bootc-base-dirs.conf <<'EOF'
d /var/home      0755 root root -
d /var/srv       0755 root root -
d /var/mnt       0755 root root -
d /var/usrlocal  0755 root root -
d /var/roothome  0700 root root -
d /run/media     0755 root root -
EOF
