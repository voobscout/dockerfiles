FROM voobscout/base-arch:xorg-dummy
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN sed -i 's/#start-default-seat=true/start-default-seat=false/g' /etc/lightdm/lightdm.conf && \
    runuser -l dev -c 'yaourt --aur --noconfirm --needed -Syyu && \
                       yaourt --aur --noconfirm --needed -S \
                         zsh \
                         screen \
                         tilix-bin \
                         awesome \
                         vicious \
                         dex \
                         xorg-xrandr \
                         xorg-xinit \
                         xorg-xrdb \
                         xorg-server-xdmx \
                         xorg-server-xephyr \
                         tigervnc \
                         x11vnc \
                         gtkglext \
                         unzip \
                         p7zip \
                         firefox \
                         iproute2' && \
    systemctl mask getty.service
