FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    echo "davfs2 davfs2/suid_file boolean false" | debconf-set-selections && \
    echo "davfs2 davfs2/non_root_users_confimed note" | debconf-set-selections && \
    echo "davfs2 davfs2/new_group boolean true" | debconf-set-selections && \
    echo "davfs2 davfs2/new_user boolean true" | debconf-set-selections && \
    apt-get install -qqfy davfs2 lsyncd && \
    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

VOLUME ["/mnt/sync_src"]
CMD ["/usr/bin/dumb-init", "/start.sh"]
