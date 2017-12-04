# -*- dockerfile -*-
FROM ubuntu:trusty

ADD https://github.com/cryfs/cryfs/releases/download/0.9.7/cryfs_0.9.7_ubuntu-14.04-x64.deb /tmp/cryfs_0.9.7_ubuntu-14.04-x64.deb

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get -qq update && \
    apt-get -qqy dist-upgrade && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
    apt-get install -qqyf --install-recommends \
    openssl \
    gnutls-bin \
    ca-certificates \
    locales \
    inotify-tools \
    lsb-release \
    kmod \
    git-core \
    zsh \
    screen \
    sudo \
    curl \
    wget \
    build-essential \
    unzip \
    vim \
    gnupg-agent \
    bcrypt \
    libgmp3-dev \
    libmysqlclient-dev \
    libmagick++5 \
    libmagickcore-dev \
    libmagickwand-dev \
    libxslt1-dev \
    pdftk \
    libreoffice \
    fonts-tlwg-typist \
    fonts-freefont-ttf \
    fonts-ubuntu-font-family-console \
    ttf-ubuntu-font-family \
    fonts-roboto \
    ssh \
    libcrypto++9 libcurl3 libfuse2 fuse gnupg2 && \
    dpkg -i /tmp/cryfs_0.9.7_ubuntu-14.04-x64.deb && \
    rm -rf /tmp/cryfs_0.9.7_ubuntu-14.04-x64.deb

RUN echo 'XAuthLocation /usr/bin/xauth' >> /etc/ssh/sshd_config && \
    echo 'AddressFamily inet' >> /etc/ssh/sshd_config && \
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config && \
    echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config

COPY windows_ttf.tar.gz /root/
RUN cd /usr/local/share/fonts && \
    tar xzf /root/windows_ttf.tar.gz && \
    rm -rf /root/windows_ttf.tar.gz && \
    fc-cache && \
    locale-gen en_US.UTF-8 && \
    useradd -d /opt/app -m -g users -G sudo,lp,uucp -u 1002 -s /bin/zsh app && \
    echo -n "%sudo ALL=(ALL:ALL) NOPASSWD: ALL, SETENV: ALL" > /etc/sudoers.d/10-admins

USER app
WORKDIR /opt/app

RUN /bin/bash -l -c "\
curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
curl -sSL https://get.rvm.io | bash -s -- --version latest && \
source /opt/app/.rvm/scripts/rvm && \
rvm requirements && \
mkdir /opt/app/gem_setup &&\
echo ': 1418507005:0;cryfs /opt/app/run /opt/app/mnt' > ~/.zsh_history &&\
echo ': 1418508006:0;cd ~/mnt/insurance_agent' >> ~/.zsh_history &&\
echo ': 1418509007:0;bundle exec ruby ./lib/insurance_agent.rb' >> ~/.zsh_history && \
mkdir -p /opt/app/.terminfo/e"

COPY Gemfile /opt/app/gem_setup/
COPY Gemfile.lock /opt/app/gem_setup/

RUN /bin/bash -l -c "\
source /opt/app/.rvm/scripts/rvm && \
source /etc/profile && \
echo 'gem: --no-ri --no-rdoc' >> /opt/app/.gemrc && \
rvm install ruby-2.4.0 &&\
rvm use ruby-2.4.0@global --default && \
gem install bundler && \
gem update --system &&\
cd /opt/app/gem_setup && \
bundle &&\
cd .. && \
rm -rf /opt/app/gem_setup"

RUN bash -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" && \
    git clone https://github.com/nojhan/liquidprompt.git ~/.liquidprompt && \
    echo '[ ! $TERM = "dumb" ] && [[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt' >> ~/.zshrc && \
    echo '[[ -z $STY ]] && export LP_PS1_POSTFIX="¬» " || export LP_PS1_POSTFIX="§» "' >> ~/.zshrc

USER root
RUN mkdir -p /var/run/sshd && /usr/sbin/sshd -D
