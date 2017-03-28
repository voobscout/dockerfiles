FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

RUN export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    pacman --noconfirm -S firefox

RUN usermod -u 1001 dev && \
    useradd -m -u 1000 -g 100 -G wheel,video,audio -s /bin/bash firefox

VOLUME ["/tmp"]

WORKDIR /home/firefox
USER firefox
CMD ["/bin/bash", "-l"]

# --volume /etc/timezone:/etc/timezone:ro \
# --env SOCKS_SERVER="socks://172.17.0.1:5080" \
# --env SOCKS_VERSION=5 \
# --volume /run/user/"${UID}"/pulse/native:/tmp/pulse-unix "${dri_devices[@]}" \
# --env PULSE_SERVER="unix:/tmp/pulse-unix" \

# declare -a dri_devices
# for d in `find /dev/dri -type c` ; do
# 	dri_devices+=(--device "${d}")
# done
