#!/bin/bash
x11vnc_cmd="x11vnc -noipv6 -shared -forever -nopw -norc -noclipboard -speeds lan -ping 3 -nolookup -nobell -nosel -repeat -cursor -noxdamage"

Xvnc :1 -ac -geometry 1920x600 -rfbport 5900 & xvncpid=$!
echo $xvncpid
#wait $xvncpid
sleep 3

DISPLAY=:1 Xephyr :2 -screen 640x480 & xeph2=$!
echo $xeph2
# wait $xeph2
sleep 3

DISPLAY=:1 Xephyr :3 -screen 640x480 & xeph3=$!
echo $xeph3
# wait $xeph3
sleep 3

DISPLAY=:1 Xephyr :4 -screen 640x480 & xeph4=$!
echo $xeph4
# wait $xeph4
sleep 3

$x11vnc_cmd -desktop control -rfbport 5901 -display :2 & pid_virtual1=$!
echo $pid_virtual1
sleep 3

xdmx_cmd="Xdmx :20 -display :2 -display :3 -display :4 -input :2 -ac -ignorebadfontpaths -norender -noglxproxy +xinerama"

[[ ! $# -eq 0 ]] && eval "${xdmx_cmd} -query ${1}" || eval "${xdmx_cmd}"
