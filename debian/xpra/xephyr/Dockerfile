FROM voobscout/base-deb
MAINTAINER Voob of Doom <voobscout@gmail.com>

COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \

    curl http://winswitch.org/gpg.asc | apt-key add - && \
    echo "deb http://winswitch.org/ jessie main" > /etc/apt/sources.list.d/winswitch.list && \
    apt-get -qq update && \

    apt-get install -t jessie-backports -qqyf \
    cython \
    python-pyopencl \
    cups-client \
    python-cups \
    websockify \
    libx264-142 \
    x264 \
    libvpx1 \
    vpx-tools \
    xserver-xephyr \
    winswitch \
    vim \
    xserver-xorg-input-void \
    python-gi-cairo && \

    apt-get -qqfy dist-upgrade && \

    useradd viptela -m -s /bin/bash && \
    echo "viptela ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \

    chmod +x /start.sh && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
