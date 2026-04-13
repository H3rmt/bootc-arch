# bootc-arch

Minimal Arch Linux [bootc](https://github.com/bootc-dev/bootc) image.

- Arch Linux base
- CachyOS repos enabled
- Flatpak preconfigured

The container image is published to GHCR by the weekly GitHub Action.

## Install From Live USB

Boot the target PC from a live USB that has `podman` available, then install the image directly to the disk you want to use.

1. Setup partitions using fdisk.
2. Format partitions (mkfs.btrfs / mkfs.ext4)
34 Identify the target disk with `lsblk`.
3. Pull the image:

```bash
podman pull ghcr.io/h3rmt/bootc-arch:weekly
```

4. Install it to the disk, replacing `/dev/nvme0n1` with your target device:

```bash
mount /dev/nvme0n1 /mnt
podman run --rm --privileged --pid=host --ipc=host --security-opt label=type:disable -v /dev:/dev -v /var/lib/containers:/var/lib/containers \
  ghcr.io/h3rmt/bootc-arch:weekly bootc install to-filesystem /mnt --bootloader systemd --composefs-backend --run-fetch-check
```

5. Reboot into the installed system.

If you want to build a [raw disk image](https://bootc.dev/bootc/bootc-install.html) instead of installing to a physical disk, use `bootc install to-disk --via-loopback`.
