FROM quay.io/fedora/fedora-bootc:42 AS bootc-source

FROM docker.io/archlinux/archlinux:latest AS builder

COPY --from=bootc-source /usr/bin/bootc /usr/bin/bootc
COPY --from=bootc-source /usr/lib/dracut/modules.d/51bootc /usr/lib/dracut/modules.d/51bootc
COPY --from=bootc-source /usr/lib/bootc/initramfs-setup /usr/lib/bootc/initramfs-setup
COPY --from=bootc-source /usr/lib/systemd/system-generators/bootc-systemd-generator /lib/systemd/system-generators/bootc-systemd-generator
COPY --from=bootc-source /usr/lib/systemd/system/bootc* /usr/lib/systemd/system/

RUN --mount=type=bind,source=build_files,target=/prepare \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    /prepare/prepare.sh

RUN --mount=type=bind,source=build_files,target=/prepare \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    /prepare/install.sh

RUN --mount=type=bind,source=build_files,target=/prepare \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    /prepare/finalize.sh

LABEL containers.bootc 1

RUN bootc container lint
