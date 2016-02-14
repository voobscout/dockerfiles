FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /
ADD http://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    dpkg -i /yandex-disk_latest_amd64.deb && \
    apt-get install -qqyf expect && \
    rm -rf /yandex-disk_latest_amd64.deb && \
    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

VOLUME /root/Yandex.Disk
CMD ["/usr/bin/dumb-init", "/start.sh"]
