#!/usr/bin/env bash

set -xeuo pipefail

# Basic configs
install -Dm644 /prepare/files/useradd               /etc/default/useradd
install -Dm644 /prepare/files/locale.conf           /etc/locale.conf
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# copy after boot script and service
install -Dm755 /prepare/files/after-boot.sh /usr/local/lib/after-boot.sh
install -Dm644 /prepare/files/after-boot.service /usr/lib/systemd/system/after-boot.service
systemctl enable after-boot.service