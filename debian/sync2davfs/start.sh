#!/bin/bash
set -e
mkdir -p ~/.davfs
mkdir -p /mnt/sync_target
rm -rf /var/run/mount.davfs

echo "${1} ${2} ${3}" >> ~/.davfs/secrets
chmod 0600 ~/.davfs/secrets
echo "use_locks 0" >> ~/.davfs/davfs.conf
echo "secrets ~/.davfs/secrets" >> ~/.davfs/davfs.conf

# FIXME: http://www.linuxquestions.org/questions/linux-software-2/force-accept-certificates-when-using-mount-davfs-632056
yes y | mount -t davfs ${1} /mnt/sync_target -o conf=~/.davfs/davfs.conf

lsyncd -log all -nodaemon -rsync /mnt/sync_src /mnt/sync_target
