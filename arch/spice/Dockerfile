FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN pacman --noconfirm -S --needed \
    base-devel \
    git \
    sudo && \

    pacman --noconfirm -Scc && \
    find /var/cache/pacman/pkg -mindepth 1 -delete

USER dev
WORKDIR /home/dev

CMD ["/bin/bash", "-l"]
# sudo Xspice :5 --password gavno123 --port 5960 --auto -query 172.17.0.1
