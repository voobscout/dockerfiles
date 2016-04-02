FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

USER dev
WORKDIR /home/dev

RUN gpg --recv-keys A9D8C21429AC6C82 && \
    echo "1" | yaourt --noconfirm websockify && \
    echo "1" | yaourt --noconfirm xf86-video-qxl && \
    sudo pacman --noconfirm -Scc && \
    sudo find /var/cache/pacman/pkg -mindepth 1 -delete

CMD ["/bin/bash", "-l"]
# sudo Xspice :5 --password gavno123 --port 5960 --auto -query 172.17.0.1
