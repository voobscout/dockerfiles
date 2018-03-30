FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_SSL_NO_VERIFY 1
ENV container docker

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb /tmp

RUN apt update && apt -yq dist-upgrade && \
    apt -yq install curl && \
    dpkg -i /tmp/dumb-init_1.2.1_amd64.deb && \
    rm -rf /tmp/dumb-init_1.2.1_amd64.deb && \
    curl -s 'https://pgp.mit.edu/pks/lookup?op=get&search=0x1657198823E52A61' | gpg --import && \
    gpg --export -a 'ZeroTier, Inc. (ZeroTier Support and Release Signing Key)' | apt-key add && \
    echo 'deb http://download.zerotier.com/debian/xenial xenial main' > /etc/apt/sources.list.d/zerotier.list && \
    apt update && apt -yq install iptables zerotier-one psmisc

ADD start.sh /
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
