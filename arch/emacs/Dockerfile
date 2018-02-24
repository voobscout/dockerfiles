FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    usermod -u 1001 dev && \
    useradd -m -u 1000 -g users -G wheel,video,audio -s /bin/zsh emacs && \
    runuser -l dev -c 'mkdir /home/dev/tmp' && \
    runuser -l dev -c 'yaourt --noconfirm -S \
                       emacs \
                       biber \
                       pandoc-bin \
                       pandoc-citeproc-bin \
                       pandoc-crossref-bin \
                       texlive-core \
                       jdk8-openjdk \
                       jre8-openjdk \
                       plantuml \
                       plantuml-ascii-math \
                       ditaa \
                       graphviz'

# VOLUME ["/tmp"]

# WORKDIR /home/firefox
# USER emacs

CMD ["/bin/bash", "-l"]

#-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix

# --volume /etc/timezone:/etc/timezone:ro \
# --env SOCKS_SERVER="socks://172.17.0.1:5080" \
# --env SOCKS_VERSION=5 \
# --volume /run/user/"${UID}"/pulse/native:/tmp/pulse-unix "${dri_devices[@]}" \
# --env PULSE_SERVER="unix:/tmp/pulse-unix" \

# declare -a dri_devices
# for d in `find /dev/dri -type c` ; do
# 	dri_devices+=(--device "${d}")
# done
