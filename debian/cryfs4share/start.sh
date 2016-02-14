#!/bin/bash

set -o nounset

export passwd=$(echo "${1}" | sha256sum | cut -f 1 -d '-' | awk '{gsub(/^ +| +$/,"")} {print $0}')
echo ${passwd} > /etc/default/cryfs_passwd

_setup() {
    ! [ -d /.exports ] && mkdir -p /.exports
    ! [ -d /exports ] && mkdir -p /exports
    ! [ -d /run/sendsigs.omit.d/rpcbind ] && mkdir -p /run/sendsigs.omit.d/rpcbind
    useradd cryfs -M
    echo "samba123" | tee - | smbpasswd -s -a cryfs
}

cryfs_new() {
    yes y | cryfs /.exports /exports --extpass "cat /etc/default/cryfs_passwd" -- -o allow_other
}

cryfs_mount() {
    cryfs /.exports /exports --extpass "cat /etc/default/cryfs_passwd" -- -o allow_other
}


_nfs() {
    . /etc/default/nfs-kernel-server
    . /etc/default/nfs-common
    service rpcbind start
    service nfs-kernel-server start
}

_cifs() {
    service smbd start
}

_setup
! [ -r /.exports/cryfs.config ] && cryfs_new || cryfs_mount
_nfs
_cifs

exec inotifywait --timefmt "%d.%M.%Y %H:%M:%S" --format "[%T] - %w%f [%:e]" -rm /exports
