# bootc-arch

Minimal Arch Linux [bootc](https://github.com/bootc-dev/bootc) image.

- Arch Linux base
- CachyOS repos enabled
- Flatpak preconfigured

The container image is published to GHCR by the weekly GitHub Action.

## Install From Live USB

Boot the target PC from a live USB that has `podman` available.

If you want a config-driven layout, build a disk image with [`example/config.toml`](example/config.toml) instead of partitioning by hand. That config uses `customizations.disk.partitions` with a btrfs volume and defines the user setup directly.

Docs:

- https://osbuild.org/docs/user-guide/blueprint-reference/
- https://osbuild.org/docs/user-guide/partitioning/
- https://github.com/osbuild/bootc-image-builder/?tab=readme-ov-file#-build-config

To install directly to a disk from live USB, let `bootc` create the layout:

1. Identify the target disk with `lsblk`.
2. Pull the image:

```bash
podman pull ghcr.io/h3rmt/bootc-arch:weekly
```

3. Install it to the disk, replacing `/dev/nvme0n1` with your target device:

```bash
podman run --rm --privileged --pid=host --ipc=host --security-opt label=type:unconfined_t \
  -v /dev:/dev \
  -v /var/lib/containers:/var/lib/containers \
  ghcr.io/h3rmt/bootc-arch:weekly \
  bootc install to-disk /dev/nvme0n1 --filesystem btrfs --run-fetch-check --bootloader systemd --composefs-backend --block-setup tpm2-luks
```

If you want to build a [raw disk image](https://bootc.dev/bootc/bootc-install.html) instead of installing to a physical disk, use `bootc install to-disk --via-loopback`.
