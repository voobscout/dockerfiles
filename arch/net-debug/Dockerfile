FROM voobscout/base-arch:xorg-dummy
MAINTAINER Voobscout <voobscout@archlinux.info>

USER root
WORKDIR /root
# add BlackArch repos:
RUN curl https://blackarch.org/strap.sh > /tmp/ba_repo && \
    chmod 0755 /tmp/ba_repo && \
    sed -i 's/get_mirror$/# get_mirrors/g' /tmp/ba_repo && \
    /tmp/ba_repo && \
    sudo find /var/cache/pacman/pkg -mindepth 1 -delete

RUN runuser -l dev -c 'yaourt --noconfirm --needed -Syyu \
                         xfce4 \
                         xfce4-goodies \
                         terminator \
                         wireshark-gtk \
                         wireshark-cli \
                         putty \
                         umit \
                         tigervnc \
                         iproute2'

# docker run --name xfce -ti --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /tmp --tmpfs /run --security-opt=seccomp:unconfined
