FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

COPY start.sh /
COPY set_mongodb_password.sh /set_mongodb_password.sh

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \

    curl https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" > /etc/apt/sources.list.d/mongodb-org.list && \

    apt-get update -qq && \
    apt-get install -qqfy pwgen mongodb-org && \

    chmod +x /start.sh && \
    chmod +x /set_mongodb_password.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

VOLUME /data/db

# ENV AUTH yes
# ENV STORAGE_ENGINE wiredTiger
# ENV JOURNALING yes
# ENV OPLOG_SIZE 8192
# ENV MONGODB_USER admin
# ENV MONGODB_DATABASE admin
# ENV MONGODB_PASS kaka123

# Expose listen port
EXPOSE 27017 28017

# Expose our data volumes
VOLUME ["/data/db"]
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
