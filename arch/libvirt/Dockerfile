FROM voobscout/base-arch:systemd
MAINTAINER Voobscout <voobscout@archlinux.info>

ENV container docker
ENV TERM xterm

COPY mknod_kvm /etc/container-boot.d/mknod_kvm

RUN pacman --noconfirm -Syy --needed \
    ebtables \
    dnsmasq \
    bridge-utils \
    openbsd-netcat \
    libvirt \
    qemu-headless \
    qemu-arch-extra \
    qemu-block-gluster \
    qemu-block-iscsi \
    qemu-block-rbd \
    samba

RUN usermod -a -G libvirt,kvm dev && \
    systemctl enable libvirtd.service && \
    systemctl enable sshd.service

VOLUME ["/var/lib/libvirt"]
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
VOLUME ["/tmp"]

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/sbin/init"]
