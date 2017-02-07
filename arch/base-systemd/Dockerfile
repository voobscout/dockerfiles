FROM base/archlinux:latest
MAINTAINER Voobscout <voobscout@archlinux.info>
ENV container docker

# Add multilib repo
RUN sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i 's/#\[multilib\]/\[multilib\]/g' /etc/pacman.conf

COPY dockerize-systemd /usr/local/bin/dockerize-systemd
COPY container-boot.service /usr/lib/systemd/system/container-boot.service
COPY shell.service /usr/lib/systemd/system/shell.service
COPY journald.conf /etc/systemd/journald.conf

RUN pacman --noconfirm -Syy && \
    pacman --noconfirm -S \
    pacman \
    archlinux-keyring \
    pacman-mirrorlist && \
	  pacman-db-upgrade && \
	  pacman --noconfirm -Suu && \
	  pacman --noconfirm -S --asdeps $(pacman -Qq) && \
    pacman --noconfirm -S --needed \
    base-devel \
    ruby \
    git \
    jq \
    bind-tools \
    ncurses \
    openssh \
    sudo && \
    chmod +x /usr/local/bin/dockerize-systemd && \
    mkdir -p /etc/container-boot.d && \
    pacman --noconfirm -Scc && \
    find /var/cache/pacman/pkg -mindepth 1 -delete && \
    useradd -m -u 1000 -G wheel,video,audio -s /bin/bash dev && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins

RUN /usr/local/bin/dockerize-systemd && \
    systemctl enable sshd

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

USER root
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/sbin/init"]

ONBUILD USER root
ONBUILD RUN bash -c "export COUNTRY=$(curl http://country.io/names.json 2> /dev/null | jq -r .$(curl ipinfo.io/$(dig +short myip.opendns.com @resolver1.opendns.com)/country 2> /dev/null)); awk -v GG=\${COUNTRY} '{if(match(\$0,GG) != 0)AA=1;if(AA == 1){if( length(\$2) != 0  )print substr(\$0,2) ;else AA=0} }' /etc/pacman.d/mirrorlist.pacnew > $HOME/mirrors_\${COUNTRY} && rankmirrors -n 0  $HOME/mirrors_\${COUNTRY} > /etc/pacman.d/mirrorlist"
ONBUILD RUN pacman --noconfirm -Syy && \
pacman --noconfirm -S pacman archlinux-keyring && \
pacman-db-upgrade && \
pacman --noconfirm -Suu && \
pacman --noconfirm -Scc && \
find /var/cache/pacman/pkg -mindepth 1 -delete

# docker run --name base-arch --hostname base-arch  -t -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro base-arch-systemd
# --cap-add SYS_ADMIN




# docker run --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm -ti voobscout/base-arch:systemd --unit=shell.service
#
