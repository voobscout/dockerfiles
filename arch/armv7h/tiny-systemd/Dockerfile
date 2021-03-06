FROM scratch
ADD http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz /

COPY container-boot.service /usr/lib/systemd/system/container-boot.service
COPY shell.service /usr/lib/systemd/system/shell.service
COPY journald.conf /etc/systemd/journald.conf

MAINTAINER Voobscout

ENV TERM screen
ENV container docker

WORKDIR /tmp

RUN pacman -Rcs --noconfirm \
      cryptsetup \
      device-mapper \
      dhcpcd \
      iproute2 \
      jfsutils \
      procps-ng \
      lvm2 \
      man-db \
      man-pages \
      mdadm \
      nano \
      netctl \
      openresolv \
      pciutils \
      reiserfsprogs \
      s-nail \
      usbutils \
      openssh \
      vi \
      texinfo \
      xfsprogs \
      linux-armv7 \
      linux-firmware && \

    pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
    run-parts

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;

RUN systemctl enable container-boot.service && \
    mkdir -p /etc/container-boot.d

RUN sed -i "s/#Color/Color/" /etc/pacman.conf && \

    # a little clean-up
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
ENTRYPOINT ["/sbin/init"]
# ENTRYPOINT ["/usr/sbin/dumb-init", "--"]

    # runuser -l alarm -c 'cd $HOME && \
    #                      mkdir -p yaourt-src && \
    #                      cd yaourt-src && \
    #                      git clone https://aur.archlinux.org/package-query.git && \
    #                      git clone https://aur.archlinux.org/yaourt.git && \
    #                      cd package-query && \
    #                      makepkg --noconfirm -si && \
    #                      cd ../yaourt && \
    #                      makepkg --noconfirm -si && \
    #                      cd $HOME && \
    #                      rm -rf $HOME/yaourt-src && \
    #                      mkdir -p $HOME/tmp/yaourt && \
    #                      echo "TMPDIR=$HOME/tmp/yaourt" > ~/.yaourtrc && \
    #                      echo "UP_NOCONFIRM=1" >> ~/.yaourtrc && \
    #                      echo "BUILD_NOCONFIRM=1" >> ~/.yaourtrc && \
    #                      echo "PU_NOCONFIRM=1" >> ~/.yaourtrc && \
    #                      echo "EDITFILES=0" >> ~/.yaourtrc' && \
    # runuser -l alarm -c 'yaourt --noconfirm -S localepurge' && \
    # sed -i "s/NEEDSCONFIGFIRST/#NEEDSCONFIGFIRST/" /etc/locale.nopurge && \
    # sed -i "s/#DONTBOTHERNEWLOCALE/DONTBOTHERNEWLOCALE/" /etc/locale.nopurge && \

#echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \
