# bootc-arch

Minimal Arch Linux [bootc](https://github.com/bootc-dev/bootc) image.

- Arch Linux base
- CachyOS repos enabled
- Tuxedo Controll Center installed
- Hyprland + Ecosystem installed
- Browser + Developpertools installed
- Flatpak preconfigured

The container image is published to GHCR by the weekly GitHub Action.

## Install From Live USB

Boot the target PC from a live USB that has `podman` available. (use `cow_spacesize=14G` kernel param or `sudo mount -o remount,size=14G /run` to increase availible size in live environment)

To install directly to a disk from live USB, let `bootc` create the layout:

1. Identify the target disk with `lsblk`.
2. Pull the image:

```bash
sudo podman pull ghcr.io/h3rmt/bootc-arch:weekly
```

3. Install it to the disk, replacing `/dev/nvme0n1` with your target device:

```bash
# sudo is required for this command
sudo podman run --network=host --privileged --pid=host --ipc=host -e RUST_LOG=debug \
  -v /dev:/dev -v /var/lib/containers:/var/lib/containers -v /etc/containers:/etc/containers \
  ghcr.io/h3rmt/bootc-arch:weekly \
  bootc install to-disk /dev/nvme0n1 --filesystem btrfs --bootloader systemd --composefs-backend
```

If you want to build a raw disk image instead of installing to a physical disk, use `bootc install to-disk --via-loopback`.

4. Setup
```
Setup is being handled by systemd-firstboot
```

5. Setup user
```
homectl create user --shell=/usr/bin/zsh --member-of=wheel,i2c,uucp
homectl activate user
```
