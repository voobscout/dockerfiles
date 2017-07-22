FROM base/archlinux:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN pacman --force --noconfirm --needed -Syyu \
    sed \
    grep \
    base-devel \
    git \
    jq \
    bind-tools \
    iproute2 \
    ncurses \
    ruby \
    python-pip \
    openssl \
    sudo && \
    pacman --force --noconfirm -Scc && \
    useradd -m -u 1000 -G wheel,video,audio -s /bin/bash dev

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \
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
    runuser -l dev -c "yaourt --noconfirm -S localepurge python-pip" && \
    sed -i "s/NEEDSCONFIGFIRST/#NEEDSCONFIGFIRST/" /etc/locale.nopurge && \
    sed -i "s/#DONTBOTHERNEWLOCALE/DONTBOTHERNEWLOCALE/" /etc/locale.nopurge && \
    sed -i "s/#Color/Color/" /etc/pacman.conf && \
    pip install dumb-init && \
    chmod +x /usr/bin/dumb-init

RUN find /var/cache/pacman/pkg -mindepth 1 -delete
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/bin/bash", "-l"]

ONBUILD USER root
ONBUILD RUN bash -c "export COUNTRY=$(curl http://country.io/names.json 2> /dev/null | jq -r .$(curl ipinfo.io/$(dig +short myip.opendns.com @resolver1.opendns.com)/country 2> /dev/null)); awk -v GG=\${COUNTRY} '{if(match(\$0,GG) != 0)AA=1;if(AA == 1){if( length(\$2) != 0  )print substr(\$0,2) ;else AA=0} }' <(curl https://www.archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4) > $HOME/mirrors_\${COUNTRY} && rankmirrors -n 0  $HOME/mirrors_\${COUNTRY} > /etc/pacman.d/mirrorlist"
ONBUILD RUN pacman --force --noconfirm -Syy && \
pacman --force --noconfirm -S pacman archlinux-keyring && \
pacman-db-upgrade && \
pacman --force --noconfirm -Suu && \
pacman --force --noconfirm -Scc && \
find /var/cache/pacman/pkg -mindepth 1 -delete
