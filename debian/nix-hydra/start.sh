#!/bin/bash
set -e

_chk_env() {
    # [[ $HYDRA_DBI && $HYDRA_DATA ]]
    # HYDRA_DBI="dbi:Pg:dbname=hydra;host=dbserver.example.org;user=hydra;"
    HYDRA_DATA=/var/lib/hydra
}

_ssh_keygen() {
    k_pre="/etc/ssh/ssh_host_"
    k_suf="_key"
    k_types="rsa dsa ecdsa ed25519"
    kg="/usr/bin/ssh-keygen"

    for i in $k_types;do echo y | "${kg}" -q -f "${k_pre}${i}${k_suf}" -N '' -t "${i}";done
}

_ssh_keygen
/usr/sbin/sshd -D &> /dev/stdout &
# We should totally fail when that dies:
exec /home/hydra/.nix-profile/bin/nix-daemon
