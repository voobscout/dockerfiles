FROM voobscout/base-arch:latest
MAINTAINER Voob of Doom <voobscout[@]gmail.com>

COPY start.sh /

RUN export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    pacman -S offlineimap

RUN useradd -d /home/oim -m -u 1000 -g 100 -s /bin/bash offlineimap && \
    chmod +x /start.sh

VOLUME /home/oim/.offlineimap
VOLUME /home/oim/.config/offlineimap/config
VOLUME /home/oim/Documents/Maildir

WORKDIR /home/oim
USER offlineimap

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
