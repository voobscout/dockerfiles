#!/bin/bash
export IP_ADDR=$1
export PORT=$2
export PASSWD=$3

services_start() {
    service ssh start
    service dbus start
}

xpra_config() {
    sed -i "s/\<CONTAINER_IP\>/${IP_ADDR}/g" /etc/xpra/xpra.conf
    echo "${PASSWD}" > /tmp/xpra_passwd.txt
}

xpra_start() {
    gosu viptela \
         xpra start :200 \
         --bind-tcp=0.0.0.0:${PORT} \
         --html=on \
         --pulseaudio=no \
         --sharing=yes \
         --speaker=disabled \
         --microphone=disabled \
         --csc-modules=all \
         --opengl=yes \
         --auth=file \
         --password-file=/tmp/xpra_passwd.txt \
         --idle-timeout=0 \
         --server-idle-timeout=0 \
         --mdns=no \
         --xsettings=no \
         --system-tray=no \
         --dpi=96
}

xpra_connect() {
    xpra_config
    services_start
    xpra_start
    tail -f /home/viptela/.xpra/\:200.log
}

! [ $# -eq 0 ] && xpra_connect || exec /bin/bash -l
