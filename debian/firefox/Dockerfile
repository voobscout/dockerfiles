FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \

    dpkg --add-architecture i386 && \
    curl http://repos.fds-team.de/Release.key | apt-key add - && \
    echo "deb http://repos.fds-team.de/stable/debian/ jessie main" > /etc/apt/sources.list.d/pipelight.list && \
    echo "deb http://httpredir.debian.org/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list && \

    apt-get update -qq && \
    apt-get install -qqfy wine-staging pipelight-multi iceweasel && \
    pipelight-plugin --update && \

    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log



# VOLUME /root/Yandex.Disk
# ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
