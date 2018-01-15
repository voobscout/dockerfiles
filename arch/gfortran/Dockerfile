FROM voobscout/base-arch
MAINTAINER Voobscout <voobscout@archlinux.info>

ENV container docker
ENV TERM screen

COPY schneiden /usr/local/bin
RUN runuser -l dev -c 'yaourt --noconfirm -S libgfortran6'
