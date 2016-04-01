#!/bin/bash

export IP_ADDR=$1
export PORT=$2
export PASSWD=$3
export SCREEN_RES=$4

start_services() {
    service ssh restart
    service dbus restart
}

start_xorg() {
    local logfile=/tmp/Xorg.log
    local configfile=/etc/xpra/xorg.conf
    local xorg_cmd="Xorg -reset -ac +extension GLX +extension RANDR +extension RENDER -logfile ${logfile} -config ${configfile} -query ${IP_ADDR}"
    $xorg_cmd 2> /dev/null & xorg_pid=$!
    export XORG_PID=$xorg_pid
    #
    # setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}'
}

create_xpra_passwd() {
    echo "${PASSWD}" > /tmp/xpra_passwd.txt
}

start_xpra_xephyr() {
    xpra start :200 \
         --no-daemon \
         --bind-tcp=0.0.0.0:${PORT} \
         --auth=file \
         --password-file=/tmp/xpra_passwd.txt \
         --html=on \
         --sharing=yes \
         --csc-modules=all \
         --opengl=yes \
         --encoding=webp \
         --idle-timeout=0 \
         --server-idle-timeout=0 \
         --pulseaudio=no \
         --speaker=disabled \
         --dpi=96 \
         --mdns=no \
         --start-child="Xephyr :202 -ac -query ${IP_ADDR} -screen ${SCREEN_RES}"
         # --xvfb="Xorg -reset -ac +iglx -dpi 96 +xinerama +extension GLX +extension RANDR +extension RENDER -logfile /tmp/xorg.log -config /etc/xpra/xorg.conf" \
}

start_xpra_xdummy() {
    xpra shadow \
         --no-daemon \
         --bind-tcp=0.0.0.0:${PORT} \
         --auth=file \
         --password-file=/tmp/xpra_passwd.txt \
         --html=on \
         --csc-modules=all \
         --opengl=yes \
         --encoding=webp \
         --idle-timeout=0 \
         --server-idle-timeout=0 \
         --pulseaudio=no \
         --speaker=disabled \
         --dpi=96 \
         --mdns=no \
         --xvfb="Xorg -reset -ac +iglx -dpi 96 +xinerama +extension GLX +extension RANDR +extension RENDER -logfile /tmp/xorg.log -config /etc/xpra/xorg.conf -query ${IP_ADDR}"
}

xpra_connect() {
    start_services
    start_xorg
    create_xpra_passwd
    start_xpra_xephyr
}

! [ $# -eq 0 ] && xpra_connect || exec /bin/bash -l
