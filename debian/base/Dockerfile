FROM debian:jessie-backports
MAINTAINER Voob of Doom <vod+dockerfiles@njk.li>

# ENV HOME /
COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    echo "deb http://httpredir.debian.org/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list && \
    apt-get -qq update; apt-get -qq update  && \
    apt-get --force-yes -t jessie-backports -qqy dist-upgrade && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \

    apt-get install --force-yes -qqyf --no-install-recommends \
    openssl \
    apt-transport-https \
    gnutls-bin \
    ca-certificates \
    curl \
    locales \
    wget \
    inotify-tools \
    sudo \
    lsb-release \
    kmod \
    git-core

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb /tmp
ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/local/bin/gosu

RUN dpkg -i /tmp/dumb-init_1.2.2_amd64.deb && \
    chmod 0755 /usr/local/bin/gosu && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \

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
            apt-get --force-yes -t jessie-backports -qqy dist-upgrade

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
