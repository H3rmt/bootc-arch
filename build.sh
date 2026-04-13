#!/usr/bin/env bash

set -xeuo pipefail

podman build --network=host -f Containerfile -t arch-custom-bootc .

# podman run --rm --mount=type=image,src=arch-custom-bootc,dest=/chunkah -e CHUNKAH_CONFIG_STR quay.io/coreos/chunkah build --label ostree.bootable=1 --compressed --max-layers 256 -t arch-custom-bootc-chunked | podman load
podman run --rm --mount=type=image,src=arch-custom-bootc,dest=/chunkah -e CHUNKAH_CONFIG_STR quay.io/coreos/chunkah build --label ostree.bootable=1 --compressed --max-layers 256 | podman load | \
        sort -n | \
        head -n1 | \
        cut -d, -f2 | \
        cut -d: -f3 | \
        xargs -I{} podman tag {} arch-custom-bootc-chunked


sudo podman run --rm --privileged --pid=host -it -v /var/lib/containers:/var/lib/containers -v /etc/containers:/etc/containers -v /dev:/dev -v "$(pwd):/data" arch-custom-bootc-chunked \
    bootc install to-disk --composefs-backend --via-loopback /data/bootable.img --wipe --bootloader systemd