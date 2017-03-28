FROM voobscout/base-arch:latest
MAINTAINER Voob of Doom <voobscout[@]gmail.com>

COPY start.sh /

RUN export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    pacman --noconfirm -S offlineimap

RUN usermod -u 1001 dev && \
    useradd -m -u 1000 -g 100 -s /bin/bash offlineimap && \
    chmod +x /start.sh

# VOLUME /home/offlineimap/.offlineimap
# VOLUME /home/offlineimap/.config/offlineimap/config
# VOLUME /home/offlineimap/Documents/Maildir

WORKDIR /home/offlineimap
USER offlineimap

ENTRYPOINT ["/start.sh"]
