FROM voobscout/base-deb:latest
MAINTAINER Voobscout <voobscout@gmail.com>

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt -y update && apt -fy dist-upgrade && \
    apt -fy install bzip2 procps jq lighttpd openssh-server openssh-client && \
    groupadd -r nixbld && \
    for n in $(seq 1 10); do useradd -c "Nix build user $n" \
    -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
    nixbld$n; done && \
    useradd -m -u 1000 -G sudo -s /bin/bash hydra && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-hydra

RUN runuser -l hydra -c 'bash <(curl https://nixos.org/nix/install)' && \
    runuser -l hydra -c 'nix-channel --update && nix-env -i hydra'

RUN apt-get -y autoremove && apt-get -yq clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ADD start.sh /
ENTRYPOINT ["/usr/bin/dumb-init", "/start.sh"]
