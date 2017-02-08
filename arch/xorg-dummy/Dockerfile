FROM voobscout/base-arch:systemd
MAINTAINER Voobscout <voobscout@archlinux.info>

COPY xorg.conf /etc/X11/xorg.conf.d/dummy.conf

USER dev
WORKDIR /home/dev

RUN yaourt -Syy --noconfirm --needed \
           inetutils \
           libxv \
           libxdamage \
           pulseaudio \
           mesa-libgl \
           xf86-input-evdev \
           xorg-xauth \
           xorg-server \
           xf86-input-evdev \
           xf86-video-dummy \
           lightdm \
           lightdm-gtk-greeter \
           xterm \
           accountsservice \
           xf86-video-dummy \
           vim \
           net-tools && \

    sudo systemctl enable lightdm && \
    sudo systemctl set-default graphical.target && \
    sudo pacman --noconfirm -Scc && \
    sudo sed -i '/\[XDMCPServer\]/a enabled=true' /etc/lightdm/lightdm.conf && \
    sudo find /var/cache/pacman/pkg -mindepth 1 -delete

USER root

# docker run --name xfce -ti --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /tmp --tmpfs /run --security-opt=seccomp:unconfined
