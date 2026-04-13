#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[after-boot] $*"
}

# Wait a bit for networking to be usable
for _ in $(seq 1 60); do
  if getent hosts dl.flathub.org >/dev/null 2>&1; then
    break
  fi
  sleep 2
  printf "."
done
echo ""

# Ensure Flathub exists
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

# System-wide apps to keep installed
apps=(
  org.torproject.torbrowser-launcher 
  org.shotcut.Shotcut 
  # org.onlyoffice.desktopeditors 
  # org.libreoffice.LibreOffice 
  org.inkscape.Inkscape 
  org.gnome.clocks 
  # org.gnome.baobab 
  org.gnome.Snapshot 
  org.gnome.PowerStats 
  org.gnome.Evince 
  org.gnome.Calculator 
  org.gnome.Boxes 
  org.gimp.GIMP 
  net.nokyan.Resources 
  # md.obsidian.Obsidian 
  io.missioncenter.MissionCenter 
  io.gitlab.adhami3310.Converter 
  io.github.flattool.Warehouse 
  com.usebottles.bottles 
  com.spotify.Client 
  com.obsproject.Studio 
  com.getpostman.Postman
  com.github.xournalpp.xournalpp 
  com.github.tchx84.Flatseal 
  cc.arduino.IDE2
)

for app in "${apps[@]}"; do
  if flatpak info "$app" >/dev/null 2>&1; then
    log "$app already installed"
  else
    log "installing $app"
    flatpak install -y flathub "$app"
  fi
done

# Optional: keep them updated too
flatpak update -y || true

# update rust
rustup self update

# install rust toolchain
rustup toolchain install stable

log "done"