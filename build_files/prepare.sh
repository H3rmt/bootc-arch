#!/usr/bin/env bash
set -xeuo pipefail

# Basic configs
install -Dm644 /prepare/conf/locale.conf           /etc/locale.conf
install -Dm644 /prepare/conf/locale.gen            /etc/locale.gen
install -Dm644 /prepare/conf/zshrc                 /etc/skel/.zshrc
install -Dm644 /prepare/conf/plymouthd.conf        /etc/plymouth/plymouthd.conf
ln -s /usr/share/zoneinfo/Europe/Berlin            /etc/localtime
install -Dm644 /prepare/conf/prepare-root.conf     /usr/lib/ostree/prepare-root.conf
install -Dm644 /prepare/conf/dracut.conf           /etc/dracut.conf.d/bootc.conf
install -Dm644 /prepare/conf/nix.conf              /etc/nix/nix.conf

# copy after boot script and service
install -Dm755 /prepare/files/after-boot.sh       /opt/after-boot/after-boot.sh
install -Dm644 /prepare/files/flatpak-apps.conf   /opt/after-boot/flatpak-apps.conf
install -Dm644 /prepare/files/after-boot.service  /usr/lib/systemd/system/after-boot.service
systemctl enable after-boot.service 

# Other config files
install -Dm644 /prepare/conf/systemd/login-lid.conf               /etc/systemd/logind.conf.d/lid.conf
install -Dm644 /prepare/conf/systemd/sleep-power.conf             /etc/systemd/sleep.conf.d/power.conf
install -Dm644 /prepare/conf/systemd/user-hyprland-session.target /etc/systemd/user/hyprland-session.target