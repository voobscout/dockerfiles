FROM debian:jessie-backports
MAINTAINER Voob of Doom <voobscout@gmail.com>

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get -qq update && \
    apt-get -t jessie-backports -qqy dist-upgrade && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    apt-get install -qqyf --no-install-recommends \
    openssl ca-certificates curl wget inotify-tools sudo lsb-release kmod && \

    curl -sL -o /tmp/dumb-init_1.0.0_amd64.deb https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64.deb && \
    dpkg -i /tmp/dumb-init_1.0.0_amd64.deb && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \

    curl -sL -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 && \
    chmod 0755 /usr/local/bin/gosu && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log


CMD ["/usr/bin/dumb-init", "/bin/bash", "-l"]
