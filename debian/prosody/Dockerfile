FROM voobscout/base-deb:latest
MAINTAINER Voob of Doom <voobscout@gmail.com>

# Remove SUID programs
RUN for i in `find / -perm +6000 -type f 2>/dev/null`; do chmod a-s $i; done
COPY start.sh /

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 107D65A0A148C237FDF00AB47393D7E674D9DBB5 && \
    echo deb http://packages.prosody.im/debian jessie main >>/etc/apt/sources.list.d/prosody.list && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qqy && \
    apt-get install -qqfy prosody lua-sec lua-event lua-zlib lua-dbi-mysql lua-dbi-postgresql lua-dbi-sqlite3 && \
    chmod +x /start.sh && \
    apt-get autoremove -qqy && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

VOLUME /etc/prosody
VOLUME /var/lib/prosody

# 5000/tcp: mod_proxy65
# 5222/tcp: client to server
# 5223/tcp: deprecated, SSL client to server
# 5269/tcp: server to server
# 5280/tcp: BOSH
# 5281/tcp: Secure BOSH
# 5347/tcp: XMPP component
EXPOSE 5000 5222 5223 5269 5280 5281 5347
