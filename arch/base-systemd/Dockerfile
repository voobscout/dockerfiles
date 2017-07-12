FROM base/archlinux:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

ENV container docker
ENV TERM screen

ONBUILD RUN bash -c "export COUNTRY=$(curl http://country.io/names.json 2> /dev/null | jq -r .$(curl ipinfo.io/$(dig +short myip.opendns.com @resolver1.opendns.com)/country 2> /dev/null)); awk -v GG=\${COUNTRY} '{if(match(\$0,GG) != 0)AA=1;if(AA == 1){if( length(\$2) != 0  )print substr(\$0,2) ;else AA=0} }' <(curl https://www.archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4) > $HOME/mirrors_\${COUNTRY} && rankmirrors -n 0  $HOME/mirrors_\${COUNTRY} > /etc/pacman.d/mirrorlist"

RUN pacman --noconfirm -Syy sed grep jq bind-tools
RUN bash -c "export COUNTRY=$(curl http://country.io/names.json 2> /dev/null | jq -r .$(curl ipinfo.io/$(dig +short myip.opendns.com @resolver1.opendns.com)/country 2> /dev/null)); awk -v GG=\${COUNTRY} '{if(match(\$0,GG) != 0)AA=1;if(AA == 1){if( length(\$2) != 0  )print substr(\$0,2) ;else AA=0} }' <(curl https://www.archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4) > $HOME/mirrors_\${COUNTRY} && rankmirrors -n 0  $HOME/mirrors_\${COUNTRY} > /etc/pacman.d/mirrorlist"

# Add multilib repo
RUN sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i 's/#\[multilib\]/\[multilib\]/g' /etc/pacman.conf

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
    ncurses \
    openssh \
    systemd \
    run-parts \
    sudo && \
    mkdir -p /etc/container-boot.d && \
    pacman --noconfirm -Scc && \
    useradd -m -u 1000 -G wheel,video,audio -s /bin/bash dev && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \
    runuser -l dev -c 'cd $HOME && \
                         mkdir -p yaourt-src && \
                         cd yaourt-src && \
                         git clone https://aur.archlinux.org/package-query.git && \
                         git clone https://aur.archlinux.org/yaourt.git && \
                         cd package-query && \
                         makepkg --noconfirm -si && \
                         cd ../yaourt && \
                         makepkg --noconfirm -si && \
                         cd $HOME && \
                         rm -rf $HOME/yaourt-src && \
                         mkdir -p $HOME/tmp/yaourt && \
                         echo "TMPDIR=$HOME/tmp/yaourt" > ~/.yaourtrc && \
                         echo "UP_NOCONFIRM=1" >> ~/.yaourtrc && \
                         echo "BUILD_NOCONFIRM=1" >> ~/.yaourtrc && \
                         echo "PU_NOCONFIRM=1" >> ~/.yaourtrc && \
                         echo "EDITFILES=0" >> ~/.yaourtrc' && \
    runuser -l dev -c 'yaourt --noconfirm -S localepurge' && \
    sed -i "s/NEEDSCONFIGFIRST/#NEEDSCONFIGFIRST/" /etc/locale.nopurge && \
    sed -i "s/#DONTBOTHERNEWLOCALE/DONTBOTHERNEWLOCALE/" /etc/locale.nopurge

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;

RUN systemctl enable container-boot.service

RUN sed -i "s/#Color/Color/" /etc/pacman.conf && \
    # localepurge && \
    find /var/cache/pacman/pkg -mindepth 1 -delete && \
    find /usr/share/info -mindepth 1 -delete && \
    find /usr/share/man -mindepth 1 -delete && \
    find /usr/share/doc -mindepth 1 -delete && \
    find /usr/share/zoneinfo -mindepth 1 -delete && \
    find /usr/share/i18n -mindepth 1 -delete && \
    find /. -name "*~" -type f -delete && \
    find /usr/share/terminfo/. ! -name "*xterm*" ! -name "*screen*" ! -name "*screen*" -type f -delete && \
    find /tmp -mindepth 1 -delete

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
VOLUME ["/tmp"]

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/lib/systemd/systemd"]

# a little clean-up
ONBUILD RUN find /var/cache/pacman/pkg -mindepth 1 -delete && \
    find /usr/share/info -mindepth 1 -delete && \
    find /usr/share/man -mindepth 1 -delete && \
    find /usr/share/doc -mindepth 1 -delete && \
    find /usr/share/zoneinfo -mindepth 1 -delete && \
    find /usr/share/i18n -mindepth 1 -delete && \
    find /. -name "*~" -type f -delete && \
    find /tmp -mindepth 1 -delete
