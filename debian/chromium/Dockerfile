FROM voobscout/base-deb
MAINTAINER Voob of Doom <voobscout@gmail.com>

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -t jessie-backports -qqfy chromium pepperflashplugin-nonfree && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \

    useradd -m -u 1000 -G sudo -s /bin/bash dev && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \

    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

USER dev
WORKDIR /home/dev

# RUN /bin/bash -l -c "\
#     curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
#     curl -sSL https://get.rvm.io | bash -s -- --version latest && \
#     source $HOME/.rvm/scripts/rvm && \
#     rvm requirements && \
#     rvm install ruby-2.3.0 && \
#     rvm use ruby-2.3.0@global --default && \
#     gem install --no-document sinatra cocaine commander bundler rhc ruby_expect"

# RUN mkdir -p /home/dev/bin && \
#     echo 'export PATH=$PATH:$HOME/bin' >> /home/dev/.bashrc

# COPY rhc_setup.rb /home/dev/bin/rhc_setup

# RUN sudo chmod 0755 /home/dev/bin/rhc_setup && \
#     sudo chown dev:dev /home/dev/bin/rhc_setup

ENTRYPOINT ["/usr/bin/dumb-init", "/bin/bash", "-l"]
