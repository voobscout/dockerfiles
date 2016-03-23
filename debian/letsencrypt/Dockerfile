FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /
ADD https://github.com/kaklakariada/portmapper/releases/download/v2.0.0-alpha3/portmapper-2.0.0-alpha3.jar /usr/local/bin

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -qqyf apache2 openjdk-7-jdk && \
    locale-gen en_US.UTF-8 && \

    mkdir -p /etc/apache2/ssl/ && \
    mkdir -p /var/lock/apache2 && \
    mkdir -p /var/run/apache2 && \

    ln -sf /dev/stdout /var/log/apache2/access-ssl.log && \
    ln -sf /dev/stderr /var/log/apache2/error-ssl.log && \
    a2enmod ssl rewrite && \
    sed -i '1s/^/ServerName localhost\n /' /etc/apache2/apache2.conf && \

    useradd -d /opt/letsencrypt -m -g users -G sudo -s /bin/bash letsencrypt && \
    echo -n '%sudo ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/10-admins && \

    curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | sudo bash -s -- --version latest && \

    echo '#!/bin/bash' > /usr/local/bin/upnp-pm && \
    echo 'exec java -jar /usr/local/bin/portmapper-2.0.0-alpha3.jar $@' >> /usr/local/bin/upnp-pm && \

    usermod -a -G rvm letsencrypt && \

    chmod +x /usr/local/bin/upnp-pm && \
    chmod +r /usr/local/bin/portmapper-2.0.0-alpha3.jar && \
    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

USER letsencrypt
WORKDIR /opt/letsencrypt
RUN bash -l -c "source /etc/profile.d/rvm.sh &&\
                rvm requirements && \
                rvm install ruby-2.3.0 && \
                rvm use ruby-2.3.0@global --default && \
                gem install bundler && \
                git clone https://github.com/letsencrypt/letsencrypt"

EXPOSE 80/tcp 443/tcp
VOLUME /var/www/html
VOLUME /opt/letsencrypt/certificates
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
# java -jar /usr/local/bin/portmapper-2.0.0-alpha3.jar -add -externalPort 80 -internalPort 80 -ip 10.1.1.168 -protocol tcp -description testing > /dev/null 2> /dev/null
