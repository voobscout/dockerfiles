FROM voobscout/base-arch:systemd
MAINTAINER Voobscout <voobscout@archlinux.info>

ENV container docker
ENV TERM xterm

COPY prep /etc/container-boot.d/prep
COPY domrun.service /lib/systemd/system/domrun.service

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
    samba \
    vim && \
    gem install --no-user-install clamp nokogiri bytes_converter

RUN systemctl enable libvirtd.service && \
    systemctl enable sshd.service && \
    systemctl enable domrun.service

VOLUME ["/var/lib/libvirt/images"]
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
VOLUME ["/tmp"]

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/lib/systemd/systemd"]
