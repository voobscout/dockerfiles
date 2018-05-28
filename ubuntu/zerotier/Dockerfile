FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_SSL_NO_VERIFY 1
ENV container docker

ADD https://github.com/Yelp/dumb-init/archive/v1.2.1.tar.gz /tmp

RUN apt update && apt -yq dist-upgrade && \
    apt -yq install curl build-essential && \
    curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
    gpg --export -a 'ZeroTier, Inc. (ZeroTier Support and Release Signing Key)' | apt-key add && \
    echo 'deb http://download.zerotier.com/debian/xenial xenial main' > /etc/apt/sources.list.d/zerotier.list

RUN cd /tmp && \
    tar xzf v1.2.1.tar.gz && \
    cd /tmp/dumb-init-1.2.1 && \
    make -j$(nproc) && \
    cp /tmp/dumb-init-1.2.1/dumb-init /usr/bin/dumb-init && \
    cd / && \
    rm -rf /tmp/dumb-init-1.2.1

RUN apt update && apt -yq install iptables zerotier-one psmisc
RUN apt -yq remove build-essential && apt -yq autoremove && apt -yq clean

ADD start.sh /
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
