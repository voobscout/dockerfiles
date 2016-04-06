FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

##########################################################################
# CLEAN UP SECTION - THIS GOES AT THE END                                #
##########################################################################
RUN rm -r /usr/share/info/* && \
    rm -r /usr/share/man/* && \
    rm -r /usr/share/doc/*
    # bash -c "[ -d '/tmp' ] && rm -rf /tmp"

RUN bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    pacman-optimize && \
    rm -r /var/lib/pacman/sync/*

#########################################################################

USER dev
WORKDIR /home/dev
