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
    webp \
    libgstreamer* \
    xserver-xephyr \
    cups-pdf \
    winswitch \
    vim \
    xserver-xorg-input-void \
    python-gi-cairo && \

    apt-get -qqfy dist-upgrade && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \

    chmod +x /start.sh && \

    useradd -m xuser -G xpra -s /bin/bash && \
    echo "xuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

USER xuser
WORKDIR /home/xuser

RUN /bin/bash -l -c "\
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s -- --version latest && \
    source $HOME/.rvm/scripts/rvm && \
    rvm requirements && \
    rvm install ruby-2.3.0 && \
    rvm use ruby-2.3.0@global --default && \
    gem install --no-document cocaine commander sinatra bundler"

ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]

# api_key google AIzaSyBm_DSLZO_q0RQGOFtOO_1HGQyOfAoB1R0
# client_id: 529267890170-65b1ba4s66hiajojmts5jjt1tthi3il0.apps.googleusercontent.com
# client_secret -KNwOmX4vIBMpwfP0O8CF84w
