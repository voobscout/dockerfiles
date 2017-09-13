FROM debian:jessie-backports
MAINTAINER voobscout <voobscout@archlinux.info>

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    echo "deb http://httpredir.debian.org/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list && \
    apt-get -qq update && \
    apt-get -t jessie-backports -qqy dist-upgrade && \
    apt-get install -qqyf curl && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get -qq update && \
    apt-get install -qqyf google-cloud-sdk && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ENTRYPOINT ["/usr/bin/gcloud"]

# docker run --rm -ti -v $HOME/.config/gcloud:/.config/gcloud -u $UID:$GID njkli/gcloud compute instance list
