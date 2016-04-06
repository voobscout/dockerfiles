FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

USER dev
WORKDIR /home/dev

RUN gpg --recv-keys A9D8C21429AC6C82 && \
    echo "1" | yaourt --noconfirm websockify && \
    echo "1" | yaourt --noconfirm xf86-video-qxl && \
    echo "1" | yaourt --noconfirm apache && \
    sudo pacman --noconfirm -Scc && \
    sudo find /var/cache/pacman/pkg -mindepth 1 -delete && \
    git clone https://anongit.freedesktop.org/git/spice/spice-html5.git && \
    sudo mv ./spice-html5 /srv/http/spice

CMD ["/bin/bash", "-l"]

# sudo Xspice :5 --password mypassword --port 5960 --auto --streaming-video all -query 172.17.0.1
# /srv/http
# sudo httpd -k start -DFOREGROUND
# docker run --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm -ti ssiegel/base-debian-systemd --unit=shell.service
