FROM voobscout/base-arch:systemd
MAINTAINER Voobscout <voobscout@archlinux.info>

ENV container docker
ENV TERM xterm

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
    dmidecode \
    net-tools \
    vim && \
    gem install --no-user-install clamp nokogiri bytes_converter ruby-ip

COPY domrun.service /lib/systemd/system/domrun.service
COPY libvirtd_override.conf /etc/systemd/system/libvirtd.service.d/override.conf
COPY runner /usr/local/bin/runner

RUN systemctl enable libvirtd.service && \
    systemctl enable sshd.service && \
    systemctl enable domrun.service && \
    rm -rf /usr/lib/tmpfiles.d/ceph.conf && \
    rm -rf /usr/lib/tmpfiles.d/systemd-nologin.conf && \
    echo '#!/bin/bash' > /usr/local/bin/vm-ttyS0 && \
    echo 'exec telnet localhost 4555' >> /usr/local/bin/vm-ttyS0 && \
    chmod 0755 /usr/local/bin/vm-ttyS0 && \
    chsh -s /usr/local/bin/vm-ttyS0 dev && \
    sed -i 's/#StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config

VOLUME ["/var/lib/libvirt/images"]
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
VOLUME ["/tmp"]

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/usr/local/bin/runner"]
