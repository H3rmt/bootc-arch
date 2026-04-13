#!/usr/bin/env bash
# Copyright (C) 2022-2024 CachyOS team
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

set -xeuo pipefail

export LC_MESSAGES=C
export LANG=C

msg() {
    local mesg=$1; shift
    printf "==> ${mesg}\n" "$@" >&2
}

info() {
    local mesg=$1; shift
    printf "==> ${mesg}\n" "$@" >&2
}

check_supported_isa_level() {
    /lib/ld-linux-x86-64.so.2 --help | grep "$1 (supported, searched)" > /dev/null
    echo $?
}

check_supported_znver45() {
    gcc -march=native -Q --help=target 2>&1 | grep 'march' | grep -E '(znver4|znver5)' > /dev/null
    echo $?
}

check_if_repo_was_added() {
    cat /etc/pacman.conf | grep "(cachyos\|cachyos-v3\|cachyos-core-v3\|cachyos-extra-v3\|cachyos-testing-v3\|cachyos-v4\|cachyos-core-v4\|cachyos-extra-v4\|cachyos-znver4\|cachyos-core-znver4\|cachyos-extra-znver4)" > /dev/null
    echo $?
}

check_if_repo_was_commented() {
    cat /etc/pacman.conf | grep "cachyos\|cachyos-v3\|cachyos-core-v3\|cachyos-extra-v3\|cachyos-testing-v3\|cachyos-v4\|cachyos-core-v4\|cachyos-extra-v4\|cachyos-znver4\|cachyos-core-znver4\|cachyos-extra-znver4" | grep -v "#\[" | grep "\[" > /dev/null
    echo $?
}

add_specific_repo() {
    local isa_level="$1"
    local gawk_script="$2"
    local repo_name="$3"
    local cmd_check="check_supported_isa_level ${isa_level}"

    local pacman_conf="/etc/pacman.conf"
    local pacman_conf_cachyos="./pacman.conf"
    local pacman_conf_path_backup="/etc/pacman.conf.bak"

    local is_isa_supported="$(eval ${cmd_check})"
    if [ $is_isa_supported -eq 0 ]; then
        info "${isa_level} is supported"

        cp $pacman_conf $pacman_conf_cachyos
        gawk -i inplace -f $gawk_script $pacman_conf_cachyos || true

        info "Backup old config"
        mv $pacman_conf $pacman_conf_path_backup

        info "CachyOS ${repo_name} Repo changed"
        mv $pacman_conf_cachyos $pacman_conf
    else
        info "${isa_level} is not supported"
    fi
}

run_install() {
    msg "Installing CachyOS repo.."

    pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key F3B607488DB35A47

    local mirror_url="https://mirror.cachyos.org/repo/x86_64/cachyos"

    pacman --noconfirm -U "${mirror_url}/cachyos-keyring-20240331-1-any.pkg.tar.zst" \
              "${mirror_url}/cachyos-mirrorlist-27-1-any.pkg.tar.zst"    \
              "${mirror_url}/cachyos-v3-mirrorlist-27-1-any.pkg.tar.zst" \
              "${mirror_url}/cachyos-v4-mirrorlist-27-1-any.pkg.tar.zst"  \
              "${mirror_url}/pacman-7.1.0.r9.g54d9411-2-x86_64.pkg.tar.zst"

    local is_repo_added="$(check_if_repo_was_added)"
    local is_repo_commented="$(check_if_repo_was_commented)"
    local is_isa_v4_supported="$(check_supported_isa_level x86-64-v4)"
    local is_znver_supported="$(check_supported_znver45)"
    if [ $is_repo_added -ne 0 ] || [ $is_repo_commented -ne 0 ]; then
        if [ $is_znver_supported -eq 0 ]; then
            add_specific_repo x86-64-v4 ./install-znver4-repo.awk cachyos-znver4
        elif [ $is_isa_v4_supported -eq 0 ]; then
            add_specific_repo x86-64-v4 ./install-v4-repo.awk cachyos-v4
        else
            add_specific_repo x86-64-v3 ./install-repo.awk cachyos-v3
        fi
    else
        info "Repo is already added!"
    fi

    msg "Done installing CachyOS repo."
}


run() {
    run_install
    pacman --noconfirm -Syu
}

run
