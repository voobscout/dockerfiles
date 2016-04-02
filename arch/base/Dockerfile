FROM base/archlinux:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN pacman --noconfirm -Syy && \
    pacman --noconfirm -S pacman archlinux-keyring && \
	  pacman-db-upgrade && \
	  pacman --noconfirm -Suu && \
	  pacman --noconfirm -S --asdeps $(pacman -Qq) && \
    pacman --noconfirm -S --needed \
    base-devel \
    git \
    sudo && \
    pacman --noconfirm -Scc && \
    find /var/cache/pacman/pkg -mindepth 1 -delete && \
    useradd -m -u 1000 -G wheel,video,audio -s /bin/bash dev && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins

USER dev
WORKDIR /home/dev

RUN mkdir -p yaourt-src && \
    cd yaourt-src && \
    git clone https://aur.archlinux.org/package-query.git && \
    git clone https://aur.archlinux.org/yaourt.git && \
    cd package-query && \
    makepkg --noconfirm -si && \
    cd ../yaourt && \
    makepkg --noconfirm -si && \
    cd /home/dev && \
    rm -rf ./yaourt-src

CMD ["/bin/bash", "-l"]

ONBUILD RUN pacman --noconfirm -Syy && \
    pacman --noconfirm -S pacman archlinux-keyring && \
	  pacman-db-upgrade && \
	  pacman --noconfirm -Suu && \
    pacman --noconfirm -Scc && \
    find /var/cache/pacman/pkg -mindepth 1 -delete
