FROM base/archlinux:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN pacman --noconfirm -Syy sed grep

# Add multilib repo
RUN sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/ s/#//' /etc/pacman.conf && \
    sed -i 's/#\[multilib\]/\[multilib\]/g' /etc/pacman.conf

RUN pacman --force --noconfirm -Syy && \
    pacman --force --noconfirm -S \
    pacman \
    archlinux-keyring \
    pacman-mirrorlist && \
	  pacman-db-upgrade && \
	  pacman --force --noconfirm -Suu && \
	  pacman --force --noconfirm -S --asdeps $(pacman -Qq) && \
    pacman --force --noconfirm -S --needed \
    base-devel \
    git \
    jq \
    bind-tools \
    ncurses \
    ruby \
    sudo && \
    pacman --force --noconfirm -Scc && \
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

ONBUILD USER root
ONBUILD RUN bash -c "curl -o /etc/pacman.d/mirrorlist.pacnew https://www.archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4 && export COUNTRY=$(curl http://country.io/names.json 2> /dev/null | jq -r .$(curl ipinfo.io/$(dig +short myip.opendns.com @resolver1.opendns.com)/country 2> /dev/null)); awk -v GG=\${COUNTRY} '{if(match(\$0,GG) != 0)AA=1;if(AA == 1){if( length(\$2) != 0  )print substr(\$0,2) ;else AA=0} }' /etc/pacman.d/mirrorlist.pacnew > $HOME/mirrors_\${COUNTRY} && rankmirrors -n 0  $HOME/mirrors_\${COUNTRY} > /etc/pacman.d/mirrorlist"
ONBUILD RUN pacman --force --noconfirm -Syy && \
pacman --force --noconfirm -S pacman archlinux-keyring && \
pacman-db-upgrade && \
pacman --force --noconfirm -Suu && \
pacman --force --noconfirm -Scc && \
find /var/cache/pacman/pkg -mindepth 1 -delete
