# voobscout/dockerfiles

- [Intro](#intro)
  - [Version](#version)
- [base](#base)
- [httpd](#httpd)
- [fail2ban](#fail2ban)
- [yadisk](#yadisk)
- [freeswitch](#freeswitch)
- [cryfs4share](#cryfs4share)
- [sync2davfs](#sync2davfs)
- [samba](#samba)

# Intro

Collection of personal dockerfiles

## Version

debian images are "FROM debian:jessie-backports"


# base

The most generic image runs "bash -l"

```bash
docker run -d -ti voobscout/base-deb:latest
```

# httpd

apt-get install apache2
> Bind your own certs /etc/apache2/ssl/key.pem /etc/apache2/ssl/cert.pem

```bash
docker run -d -ti -p 443:443/tcp -p 80:80/tcp -v /your/html/root:/var/www/html \
voobscout/base-deb:httpd
```

# fail2ban

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

# yadisk

Yandex Disk native linux client

```bash
docker run -d -ti -v /your/files:/root/Yandex.Disk:rw voobscout/base-deb:yadisk <uname> <passwd>
```

# freeswitch

[1.6 debs repo](http://files.freeswitch.org/repo/deb/freeswitch-1.6/) with g729 compiled from [Deepwalker ipp sources](http://goo.gl/IEbTx5)

```bash
docker run -d -ti --name freeswitch voobscout/base-deb:freeswitch freeswitch
```

# cryfs4share

Bind your own "/etc/samba/smb.conf" and/or "/etc/exports" into this container if additional shares are required
> Don't forget to add the defaults from provided files.

The unencrypted contents are accessible by:

NFS:
sudo mount <docker-machine-IP>:/exports /path/of/your/choosing

CIFS:
sudo mount //<docker-machine-IP>/exports /path/of/your/choosing -o username=cryfs -o password=samba123

```bash
docker run -d -ti --cap-add SYS_ADMIN -v /your/encrypted/folder:/.exports:rw \
voobscout/base-deb:cryfs4share <cryfs mount password>
```

# sync2davfs

Oneway sync from /mnt/sync_src to a webdav of your choice, using [lsyncd](https://github.com/axkibe/lsyncd) and [davfs2](https://savannah.nongnu.org/projects/davfs2) under the hood

```bash
docker run -d -ti --privileged -v /your/files:/mnt/sync_src:ro \
voobscout/base-deb:sync2davfs <http://davfs.server.com> <uname> <passwd>
```

# samba

[Stolen from here](https://github.com/dperson/samba) - I didn't like the lack of backports repo

```bash
docker run -d -ti --privileged voobscout/base-deb:samba \
    -u "adminuser;adminpasswd123" -u "user;userpass123" \
    -s "smb_share1;/path/to/share;yes;no;no;user;adminuser" \
    -s "smb_share2;/path/to/share2;yes;yes;no;all;adminuser"
```

# znc

This container expects a working copy of ~/.znc

```bash
docker run -d -ti -v ~/.znc:/home/znc/.znc:rw voobscout/base-deb:znc
```
