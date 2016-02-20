FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /
ADD https://www.cryfs.org/install.sh /opt/bin/cryfs_install.sh

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -qqfy \
    nfs-kernel-server samba expect && \
    useradd smbuser -M && \
    chmod +x /opt/bin/cryfs_install.sh && \
    chmod +x /start.sh
RUN /opt/bin/cryfs_install.sh
RUN apt-get -qqfy dist-upgrade && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /opt/bin/cryfs_install.sh && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

COPY smb.conf /etc/samba/smb.conf
COPY exports /etc/exports

EXPOSE 111/udp 2049/tcp 139 445
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
