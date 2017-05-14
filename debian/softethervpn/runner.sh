#!/usr/bin/env bash
service ssh start
modprobe tun

# ip tuntap add mode tap br0p0

_mkdirs() {
    pref='/var/log/vpnserver'
    dirs="$pref/security_log $pref/packet_log $pref/server_log"
    for i in $dirs; do
        [[ ! -d $i ]] && mkdir -p $i
        ln -s $i /usr/local/vpnserver/
    done
}

_mkdirs

/usr/local/vpnclient/vpnclient start

exec /usr/local/vpnserver/vpnserver execsvc

exit $?
