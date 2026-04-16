#!/usr/bin/env bash

set -xeuo pipefail


# configure pacman
pacman-key --init
pacman --noconfirm -Syu

mkdir -p /usr/lib/sysimage/lib/pacman/ /usr/lib/sysimage/cache/pacman/pkg/
cp -r /var/lib/pacman/* /usr/lib/sysimage/lib/pacman/

install -Dm644 /prepare/files/pacman/pacman.conf           /etc/pacman.conf
install -Dm644 /prepare/files/pacman/mirrorlist            /etc/pacman.d/mirrorlist
install -Dm755 /prepare/files/pacman/install-cachy.sh      /tmp/install-cachy.sh

/tmp/install-cachy.sh

# cd /tmp && curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
# tar xvf cachyos-repo.tar.xz && cd /tmp/cachyos-repo && yes '' | ./cachyos-repo.sh

pacman --noconfirm -Sy dracut linux linux-firmware less zsh \
    ostree btrfs-progs e2fsprogs openssh \
    xfsprogs dosfstools skopeo ttf-jetbrains-mono-nerd  \
    dbus-glib glib2 ostree shadow man dbus base-devel \
    intel-ucode micro git sudo systemd noto-fonts


pacman --noconfirm -Sy ncdu \
    htop btop networkmanager upower powertop \
    nvme-cli smartmontools bluez plymouth \
    rustup go python alacritty fzf just make docker docker-compose docker-buildx \
    firefox brightnessctl pavucontrol mpv chromium podman \
    gnome-control-center gnome-keyring hyprpolkitagent \
    flatpak pkgstats distrobox

# install paru
groupadd -g 771 builder || true
useradd -m builder -u 771 -g 771 || true
cat >/etc/sudoers.d/builder <<'EOF'
builder ALL=(ALL) NOPASSWD: ALL
Defaults:builder !requiretty
EOF
chmod 440 /etc/sudoers.d/builder

# Default user for installed systems
useradd -m -G wheel,docker user || true
echo 'user:test' | chpasswd

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
    google-chrome \
    paru-bin
'
rm -f /etc/sudoers.d/builder
userdel -r builder || true
groupdel builder || true

rm -rf /usr/lib/sysimage/cache/pacman/pkg
mkdir /usr/lib/sysimage/cache/pacman/pkg

# enable flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub \
  org.onlyoffice.desktopeditors \
  org.libreoffice.LibreOffice \
  org.gnome.baobab \
  md.obsidian.Obsidian 

echo "Install completed"
