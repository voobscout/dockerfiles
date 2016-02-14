FROM voobscout/base-deb
MAINTAINER Voob of Doom <voobscout@gmail.com>

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -qqyf --no-install-recommends \
    apache2 && \

    mkdir -p /etc/apache2/ssl/ && \
    mkdir -p /var/lock/apache2 && \
    mkdir -p /var/run/apache2 && \
    openssl req -x509 -nodes -sha256 -days 3650 -subj "/C=BE/ST=Brussels/CN=localhost" -newkey rsa:2048 -keyout "/etc/apache2/ssl/key.pem" -out "/etc/apache2/ssl/cert.pem" && \
    ln -sf /dev/stdout /var/log/apache2/access-ssl.log && \
    ln -sf /dev/stderr /var/log/apache2/error-ssl.log && \
    a2enmod ssl rewrite && \
    sed -i '1s/^/ServerName localhost\n /' /etc/apache2/apache2.conf && \

    chmod +x /start.sh && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

VOLUME /var/www/html
WORKDIR /var/www/html

EXPOSE 80/tcp 443/tcp

CMD ["/usr/bin/dumb-init", "/start.sh"]
