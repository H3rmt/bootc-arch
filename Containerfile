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

LABEL containers.bootc 1

RUN bootc container lint
