FROM voobscout/base-deb
MAINTAINER Voob of Doom <voobscout@gmail.com>

ADD https://raw.githubusercontent.com/voobscout/configs/master/screenrc /etc/skel/.screenrc
ADD https://raw.githubusercontent.com/voobscout/configs/master/zshrc /etc/skel/.zshrc
ADD https://storage.googleapis.com/git-repo-downloads/repo /etc/skel/bin/repo

COPY start.sh /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get install -qqyf \
    git build-essential ruby python zsh screen vim && \
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /etc/skel/.oh-my-zsh && \
    chmod +x /etc/skel/bin/repo && \

    useradd -G sudo -m -s /bin/zsh -U dev && \
    echo "%dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-devs && \

    chmod +x /start.sh && \

    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log


USER dev
# VOLUME /var/www/html
WORKDIR /home/dev

ENTRYPOINT ["/bin/zsh", "-l"]
