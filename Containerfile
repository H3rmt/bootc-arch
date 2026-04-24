FROM docker.io/archlinux/archlinux:latest AS builder

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

LABEL containers.bootc=1
LABEL ostree.bootable=1
LABEL org.opencontainers.image.name="Bootc Arch"
LABEL org.opencontainers.image.version=1
LABEL org.opencontainers.image.url="https://github.com/H3rmt/bootc-arch"

RUN bootc container lint
