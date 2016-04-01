#!/bin/bash

declare -a dri_devices
for d in `find /dev/dri -type c` ; do
	  dri_devices+=(--device "${d}")
done

# TODO: pulse-audio isn't working
# --cpu-shares [0..1024] (1024 = 100%)
# --blkio-weight [10..1000] (1000 = 100%)
# --memory-swap 256M
exec docker run \
     --rm \
     --cpu-shares 256 \
     --memory 768M \
     --memory-swappiness 0 \
     --blkio-weight 300 \
     --env DISPLAY="${DISPLAY}" \
     --volume /tmp/.X11-unix:/tmp/.X11-unix \
     --env PULSE_SERVER="unix:/tmp/pulse-unix" \
     --volume /run/user/"${UID}"/pulse:/tmp/pulse-unix:rw \
     --volume /dev/snd:/dev/snd:rw \
     "${dri_devices[@]}" -ti \
     iw1
#"$@"


     # --volume /etc/localtime:/etc/localtime:ro \
     # --volume /etc/timezone:/etc/timezone:ro \
     # --volumes-from storage \
     # --env SOCKS_SERVER="socks://172.17.0.1:5080" \
     # --env SOCKS_VERSION=5 \
