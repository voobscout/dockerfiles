FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /


RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -qqfy curl && \
    curl http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - && \
    echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list && \
    apt-get update && \
    apt-get install -qqfy freeswitch-all && \
    rm -rf /usr/lib/freeswitch/mod/mod_g729.so && \

    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

COPY mod_g729.so /usr/lib/freeswitch/mod/

EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5066/tcp 7443/tcp
EXPOSE 8021/tcp
EXPOSE 64535-65535/udp

CMD ["/usr/bin/dumb-init", "/start.sh"]
