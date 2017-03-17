FROM debian:jessie-backports
MAINTAINER Voob of Doom <voobscout@gmail.com>

ENV HOME /
COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    echo "deb http://httpredir.debian.org/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list && \
    apt-get -qq update && \
    apt-get -t jessie-backports -qqy dist-upgrade && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \

    apt-get install -qqyf --no-install-recommends \
    openssl \
    gnutls-bin \
    ca-certificates \
    curl \
    locales \
    wget \
    inotify-tools \
    sudo \
    lsb-release \
    kmod \
    augeas-tools \
    ruby \
    git-core

RUN curl -sL -o /tmp/dumb-init-amd64.deb https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb && \
    dpkg -i /tmp/dumb-init-amd64.deb && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \

    curl -sL -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 && \
    chmod 0755 /usr/local/bin/gosu && \

    chmod +x /start.sh && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ONBUILD RUN export DEBIAN_FRONTEND='noninteractive' && \
            export GIT_SSL_NO_VERIFY=1 && \
            export container=docker && \
            apt-get -qq update && \
            apt-get -t jessie-backports -qqy dist-upgrade

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
