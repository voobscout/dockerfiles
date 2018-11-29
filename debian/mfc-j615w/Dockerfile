FROM voobscout/base-deb:latest
MAINTAINER Voob of Doom <vod+dockerfiles@njk.li>

ADD https://download.brother.com/welcome/dlf006602/mfcj615wlpr-1.1.3-1.i386.deb /tmp
ADD https://download.brother.com/welcome/dlf006604/mfcj615wcupswrapper-1.1.3-1.i386.deb /tmp

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    dpkg --add-architecture i386 && \
    apt -y update && apt -fy dist-upgrade && \
    apt-get -fy --install-recommends install cups lib32stdc++6 && \
    dpkg -i /tmp/*.deb && \
    rm -rf /tmp/*.deb

RUN apt-get -y autoremove && apt-get -yq clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ADD start.sh /
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
