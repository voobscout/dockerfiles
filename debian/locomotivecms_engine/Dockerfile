FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

# RUN bundle config --global frozen 1

# RUN mkdir -p /usr/src/app
# WORKDIR /usr/src/app

# ONBUILD COPY Gemfile /usr/src/app/
# ONBUILD COPY Gemfile.lock /usr/src/app/
# ONBUILD RUN bundle install

# ONBUILD COPY . /usr/src/app

COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \

    apt-get update -qq && \
    apt-get install -t jessie-backports -qqfy less libssl-dev && \

    useradd -m locomotivecms -G sudo -s /bin/bash -d /opt/locomotivecms && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-admins && \

    chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

USER locomotivecms
WORKDIR /opt/locomotivecms

RUN /bin/bash -l -c "\
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s -- --version latest && \
    source $HOME/.rvm/scripts/rvm && \
    rvm requirements && \
    rvm install ruby-2.3.1 && \
    rvm use ruby-2.3.1@global --default && \
    gem install --no-document \
    locomotivecms \
    puma && \
    rails new engine --skip-bundle --skip-active-record && \
    cd engine && \
    echo \"gem 'locomotivecms'\" >> ./Gemfile  && \
    echo \"gem 'therubyracer'\" >> ./Gemfile  && \
    bundle install && \
    echo \"n\" | bundle exec rails generate locomotive:install"

COPY config/container_init.rb /opt/locomotivecms/engine/config
# Expose listen port
EXPOSE 3000

# Expose our data volumes
VOLUME ["/opt/locomotivecms/engine/public/sites"]
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
