#!/usr/bin/env bash
set -euo pipefail

# nove to shell script directory
cd /opt/after-boot

log() {
  echo "[after-boot] $*"
}

# Store hash of the script content to check if it has changed since last run
current_hash=$(sha256sum after-boot.sh flatpak-apps.txt)
hash_file="/var/lib/after-boot/last_hash"
if [[ -f "$hash_file" ]]; then
  last_hash=$(cat "$hash_file")
  if [[ "$current_hash" == "$last_hash" ]]; then
    log "Script has not changed since last run, skipping execution"
    exit 0
  fi
fi
echo "$current_hash" > "$hash_file"

# Wait a bit for networking to be usable
for _ in $(seq 1 60); do
  if getent hosts dl.flathub.org >/dev/null 2>&1; then
    break
  fi
  sleep 2
  printf "."
done
echo ""


flatpak_file="flatpak-apps.txt"
# apps must be read from /opt/after-boot/flatpak-apps.txt, one app per line
if [[ -f "$flatpak_file" ]]; then
  log "Installing flatpak apps from $flatpak_file"
  while IFS= read -r app; do
    if [[ -n "$app" ]]; then
      log "Installing $app"
      flatpak install -y --noninteractive "$app" || log "Failed to install $app, continuing with next app"
    fi
  done < "$flatpak_file"
else
  log "No $flatpak_file found, skipping flatpak app installation"
fi

# update flatpak apps
flatpak update -y || true

log "done"