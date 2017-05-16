#!/usr/bin/env bash
sysctl -w net.ipv4.ip_forward=1
modprobe tun

_ingress() {
    ip addr add 192.168.30.254/24 dev vpn_ingress
    iptables -t nat -N ingress
    iptables -t nat -A ingress -p tcp --dport 8443 -j DNAT --to-destination 192.168.30.10:443
    iptables -t nat -A ingress -p tcp --dport 8080 -j DNAT --to-destination 192.168.30.10:80
    iptables -t nat -A ingress -j RETURN
    iptables -t nat -I PREROUTING -j ingress

    iptables -t nat -A PREROUTING  -p tcp                -d $EXT.IP.ADD.RESS --dport 25 -j DNAT --to-destination 10.122.1.25:25
    iptables -t nat -A OUTPUT      -p tcp                -d $EXT.IP.ADD.RESS --dport 25 -j DNAT --to-destination 10.122.1.25:25
    iptables -t nat -A POSTROUTING -p tcp -s 10.122.1.25 -d 10.122.1.25      --dport 25 -j SNAT --to 10.122.1.1
}
# ip link set promisc on tap_vpn-br
# -j TEE --gateway 192.168.30.10
# ip tuntap add mode tap br0p0

_mkdirs() {
    pref='/usr/local/vpnserver'
    dirs="$pref/security_log $pref/packet_log $pref/server_log"
    for i in $dirs; do
        [[ ! -d $i ]] && mkdir -p $i
        chattr +i $i
    done
}

_server() {
    vpncmd="/usr/local/vpnserver/vpncmd 127.0.0.1 /server /cmd"
    vars="S_PASSWD S_HUB"

    for var in ${vars}; do
        [[ -z "$var" ]] && (echo "$var is required, but was not found!" && exit 1)
    done

    _mkdirs
    /usr/local/vpnserver/vpnserver start

    server_ready=0
    while [ $server_ready -lt 1 ]
    do
        sleep 3
        </dev/tcp/localhost/443 && server_ready=1
    done

    $vpncmd HubCreate $S_HUB /password
    $vpncmd ServerPasswordSet $S_PASSWD
    vpncmd="/usr/local/vpnserver/vpncmd 127.0.0.1 /server /password:$S_PASSWD /adminhub:$S_HUB /cmd"

    $vpncmd SecureNatEnable
    $vpncmd UserCreate $C_UNAME /group /realname /note
    $vpncmd UserPasswordSet $C_UNAME /password:$C_PASSWD
}

_client() {
    vpncmd="/usr/local/vpnclient/vpncmd 127.0.0.1 /client /cmd"
    vars="C_ACCOUNT C_NIC C_SERVER C_HUB C_UNAME C_PASSWD"

    for var in ${vars}; do
        [[ -z "$var" ]] && (echo "$var is required, but was not found!" && exit 1)
    done

    /usr/local/vpnclient/vpnclient start

    $vpncmd NicCreate $C_NIC
    $vpncmd AccountCreate $C_ACCOUNT \
            /server:$C_SERVER \
            /hub:$C_HUB \
            /username:$C_UNAME \
            /nicname:$C_NIC
    $vpncmd AccountPasswordSet $C_ACCOUNT /password:$C_PASSWD /type:standard
    [[ -n "$C_COMPRESS" ]] && $vpncmd AccountCompressEnable $C_ACCOUNT
    $vpncmd AccountConnect $C_ACCOUNT
}

_start_vpn() {
    [[ -n "$CLIENT_CONFIG" ]] && _client
    [[ -n "$SERVER_CONFIG" ]] && _server
}

_start_vpn

# shell illiteracy FTW!
tail -f /dev/null
