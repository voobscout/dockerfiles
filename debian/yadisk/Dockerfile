FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

ENV HOME /root
ADD http://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    dpkg -i /yandex-disk_latest_amd64.deb && \
    apt-get install -qqyf expect procps && \
    rm -rf /yandex-disk_latest_amd64.deb && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
