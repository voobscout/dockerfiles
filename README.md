# voobscout/dockerfiles

- [Intro](#intro)
  - [Version](#version)
- [base](#base)
  - [Debian](#debian)
    - [httpd](#httpd)
    - [fail2ban](#fail2ban)
    - [yadisk](#yadisk)
    - [freeswitch](#freeswitch)
    - [cryfs4share](#cryfs4share)
    - [sync2davfs](#sync2davfs)
    - [samba](#samba)
    - [mongodb](#mongodb)
  - [Arch](#arch)
    - [systemd](#arch-systemd)
    - [offlineimap](#offlineimap)
    - [xorg-dummy](#xorg-dummy)
    - [firefox](#firefox)
# Intro

Collection of personal dockerfiles

## Version

debian images are "FROM debian:jessie-backports"
arch images are "FROM base/archlinux:latest"

# base

The most generic image runs "bash -l"

```bash
docker run -d -ti voobscout/base-deb:latest
```

## debian

### httpd

apt-get install apache2
> Bind your own certs /etc/apache2/ssl/key.pem /etc/apache2/ssl/cert.pem

```bash
docker run -d -ti -p 443:443/tcp -p 80:80/tcp -v /your/html/root:/var/www/html \
voobscout/base-deb:httpd
```

### fail2ban

jail.local example:

```
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime  = 3600
findtime  = 3600
maxretry = 3

[ssh]
enabled = true
port    = ssh
filter  = sshd
logpath  = /var/log/host/secure
maxretry = 1
```

```bash
docker run -d -ti --privileged --net host -v /var/log:/var/log/host \
-v /your/jail.local:/etc/fail2ban/jail.local voobscout/base-deb:fail2ban
```

### yadisk

Yandex Disk native linux client

```bash
docker run -d -ti -v /your/files:/root/Yandex.Disk:rw voobscout/base-deb:yadisk <uname> <passwd>
```

### freeswitch

[1.6 debs repo](http://files.freeswitch.org/repo/deb/freeswitch-1.6/) with g729 compiled from [Deepwalker ipp sources](http://goo.gl/IEbTx5)

```bash
docker run -d -ti --name freeswitch voobscout/base-deb:freeswitch freeswitch
```

### cryfs4share

Bind your own "/etc/samba/smb.conf" and/or "/etc/exports" into this container if additional shares are required
> Don't forget to add the defaults from provided files.

The unencrypted contents are accessible by:

NFS:
sudo mount <docker-machine-IP>:/exports /path/of/your/choosing

CIFS:
sudo mount //<docker-machine-IP>/exports /path/of/your/choosing -o username=cryfs -o password=samba123

```bash
docker run -d -ti --cap-add SYS_ADMIN --device /dev/fuse -v /your/encrypted/folder:/.exports:rw \
voobscout/base-deb:cryfs4share ${cryfs_mount_password}
```

### sync2davfs

Oneway sync from /mnt/sync_src to a webdav of your choice, using [lsyncd](https://github.com/axkibe/lsyncd) and [davfs2](https://savannah.nongnu.org/projects/davfs2) under the hood

```bash
docker run -d -ti --privileged -v /your/files:/mnt/sync_src:ro \
voobscout/base-deb:sync2davfs <http://davfs.server.com> <uname> <passwd>
```

### samba

[Stolen from here](https://github.com/dperson/samba) - I didn't like the lack of backports repo

```bash
docker run -d -ti --privileged voobscout/base-deb:samba \
    -u "adminuser;adminpasswd123" -u "user;userpass123" \
    -s "smb_share1;/path/to/share;yes;no;no;user;adminuser" \
    -s "smb_share2;/path/to/share2;yes;yes;no;all;adminuser"
```

### mongodb

[Stolen from here](https://github.com/tutumcloud/mongodb/tree/master/3.2) - I wanted a debian base, not ubuntu

This expects some ENV and a data dir volume

```bash
docker run -d -ti \
    -e AUTH=yes \
    -e STORAGE_ENGINE=wiredTiger \
    -e JOURNALING=yes \
    -e OPLOG_SIZE=8192 \
    -e MONGODB_USER=admin \
    -e MONGODB_DATABASE=admin \
    -e MONGODB_PASS=kaka123 \
    -v /opt/mongodb_data:/data/db \
    voobscout/base-deb:mongodb
```

### znc

This container expects a working copy of ~/.znc

```bash
docker run -d -ti -v ~/.znc:/home/znc/.znc:rw voobscout/base-deb:znc
```

### prosody

```bash
docker run -d -ti \
-v /path/to/prosody/etc:/etc/prosody:rw \
-v /path/to/prosody/var:/var/lib/prosody:rw \
voobscout/base-deb:prosody
```

### arch-systemd

This works without additional security capabilities, ie. no need for '--cap-add SYS_ADMIN', but there seems to be a [difference of opinion on the issue](https://github.com/docker/docker/pull/21287) and the ```--security-opt=seccomp:unconfined``` is nessesary!

```bash
docker run -d -ti \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
--tmpfs /tmp \
--tmpfs /run:rw \
--security-opt=seccomp:unconfined voobscout/base-arch:systemd
```

### xorg-dummy

```bash
docker run --name xfce -ti --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /tmp --tmpfs /run --security-opt=seccomp:unconfined
```

### offlineimap

```bash
docker run -d -ti \
-v $HOME/.offlineimap:/home/offlineimap/.offlineimap:rw \
-v $HOME/.config/offlineimap/config:/home/offlineimap/.config/offlineimap/config:rw \
-v $HOME/Documents/Maildir:/home/offlineimap/Documents/Maildir:rw \
voobscout/base-arch:offlineimap #{config account name to sync}
```

### firefox

```bash
docker run --rm -ti \
--env DISPLAY="${DISPLAY}" \
--memory 1024M \
--cpus 0.5 \
--memory-swap 0B \
--memory-swappiness 0 \
--env PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
--env TZ=Europe/Amsterdam \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /etc/localtime:/etc/localtime:ro \
-v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse \
-v ${HOME}/.Xauthority:/home/firefox/.Xauthority \
-v ${HOME}/.mozilla:/home/firefox/.mozilla \
-v /dev/dri:/dev/dri \
voobscout/base-arch:firefox
```
