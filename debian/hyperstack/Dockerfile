FROM ruby:latest
MAINTAINER Voob of Doom <dockerfiles [at] njk.li>

ENV TERM screen
WORKDIR /usr/src/app

RUN set -ex && cd && export DEBIAN_FRONTEND='noninteractive' && \
  export GIT_SSL_NO_VERIFY=1 && \
  export container=docker && \
  apt-get -qqy update && apt-get -qqy dist-upgrade && \
  echo "Europe/Berlin" > /etc/timezone && \
  dpkg-reconfigure tzdata && \
  echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
  echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
  apt-get install -qqyf \
  openssl \
  apt-transport-https \
  gnutls-bin \
  ca-certificates \
  curl \
  locales \
  libzmq5 \
  libzmq3-dev \
  wget \
  inotify-tools \
  sudo \
  lsb-release \
  kmod \
  git \
  libxml2 \
  libxslt1-dev \
  libxslt1.1 \
  bzip2 \
  ca-certificates \
  libffi-dev \
  procps \
  bzip2 \
  openssl \
  sqlite \
  zookeeper \
  netcat \
  imagemagick \
  pkg-config \
  default-libmysqlclient-dev \
  gcc && \
  curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  apt-get -qq update && apt-get install -qqyf yarn nodejs

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb /tmp
ADD https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 /usr/local/bin/gosu
ADD container-start /usr/local/bin/container-start

RUN gem install rails && \
  export PATH=/usr/local/bundle/bin:$PATH && \
  git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name" && \
  mkdir MyApp && \
  cd MyApp && \
  echo 'gem "source \"https://rubygems.org\""' >> Gemfile && \
  echo 'gem "activesupport"' >> Gemfile && \
  echo 'gem "mechanize"' >> Gemfile && \
  echo 'gem "typhoeus"' >> Gemfile && \
  echo 'gem "rio"' >> Gemfile && \
  echo 'gem "ansi"' >> Gemfile && \
  echo 'gem "yell"' >> Gemfile && \
  echo 'gem "fuzzy_match"' >> Gemfile && \
  echo 'gem "amatch"' >> Gemfile && \
  echo 'gem "concurrent-ruby-edge"' >> Gemfile && \
  echo 'gem "parallel"' >> Gemfile && \
  echo 'gem "digest-crc"' >> Gemfile && \
  echo 'gem "roadie"' >> Gemfile && \
  echo 'gem "mail"' >> Gemfile && \
  echo 'gem "pony"' >> Gemfile && \
  echo 'gem "zk"' >> Gemfile && \
  echo 'gem "msgpack"' >> Gemfile && \
  echo 'gem "statsd-ruby"' >> Gemfile && \
  echo 'gem "foreman"' >> Gemfile && \
  echo 'gem "sneakers"' >> Gemfile && \
  echo 'gem "rom"' >> Gemfile && \
  echo 'gem "rom-sql"' >> Gemfile && \
  echo 'gem "mysql2"' >> Gemfile && \
  echo 'gem "faraday"' >> Gemfile && \
  echo 'gem "multi_json"' >> Gemfile && \
  echo 'gem "roar"' >> Gemfile && \
  echo 'gem "phone"' >> Gemfile && \
  echo 'gem "rubyXL"' >> Gemfile && \
  echo 'gem "google_maps_service"' >> Gemfile && \
  echo 'gem "pushover"' >> Gemfile && \
  echo 'gem "retryable"' >> Gemfile && \
  echo 'gem "sanitize"' >> Gemfile && \
  echo 'gem "chronic"' >> Gemfile && \
  echo 'gem "ibanizator"' >> Gemfile && \
  echo 'gem "chronic_between"' >> Gemfile && \
  echo 'gem "clamp"' >> Gemfile && \
  echo 'gem "pry"' >> Gemfile && \
  bundle && \
  cd .. && \
  rm -rf MyApp && \
  dpkg -i /tmp/dumb-init_1.2.2_amd64.deb && \
  chmod 0755 /usr/local/bin/gosu && \
  chmod 0755 /usr/local/bin/container-start && \
  apt-get -qqfy autoremove && apt-get -qqy autoclean

VOLUME [ "/usr/src/app" ]
ENTRYPOINT [ "/usr/bin/dumb-init", "/usr/local/bin/container-start" ]

#  echo 'gem "sqlite3"' >> Gemfile && \
#  echo 'gem "rake"' >> Gemfile && \
#   rails new MyApp -m https://rawgit.com/hyperstack-org/hyperstack/edge/install/rails-webpacker.rb && \
