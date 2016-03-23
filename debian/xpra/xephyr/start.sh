#!/bin/bash
export IP_ADDR=$1
export PORT=$2
export PASSWD=$3
export SCREEN_RES=$4

services_start() {
    service ssh start
    service dbus start
}

# xpra_config() {
#     sed -i "s/\<CONTAINER_IP\>/${IP_ADDR}/g" /etc/xpra/xpra.conf
#     echo "${PASSWD}" > /tmp/xpra_passwd.txt
# }

# xpra_start() {
#     gosu viptela \
#          xpra start :200 \
#          --bind-tcp=0.0.0.0:${PORT} \
#          --html=on \
#          --pulseaudio=no \
#          --sharing=yes \
#          --speaker=disabled \
#          --microphone=disabled \
#          --csc-modules=all \
#          --opengl=yes \
#          --auth=file \
#          --password-file=/tmp/xpra_passwd.txt \
#          --xsettings=no \
#          --system-tray=no \
#          --idle-timeout=0 \
#          --server-idle-timeout=0 \
#          --dpi=96
# }

xpra_passwd() {
    echo "${PASSWD}" > /tmp/xpra_passwd.txt
}

#
xpra_start() {
    gosu viptela \
         xpra start :200 \
         --bind-tcp=0.0.0.0:${PORT} \
         --html=on \
         --csc-modules=all \
         --opengl=yes \
         --auth=file \
         --password-file=/tmp/xpra_passwd.txt \
         --idle-timeout=0 \
         --server-idle-timeout=0 \
         --pulseaudio=no \
         --speaker=disabled \
         --dpi=96 \
         --mdns=no \
         --input-method=xim \
         --start-child="Xephyr :202 -ac -query ${IP_ADDR} -screen ${SCREEN_RES}"
    # -keybd ephyr,,,xkbmodel=evdev
}

xpra_connect() {
    xpra_passwd
    services_start
    xpra_start
    tail -f /home/viptela/.xpra/\:200.log
}

! [ $# -eq 0 ] && xpra_connect || exec /bin/bash -l
