#!/usr/bin/env bash
sysctl -w net.ipv4.ip_forward=1
modprobe tun

_ingress() {
    ip addr add 192.168.30.254/24 dev vpn_ingress
    iptables -t nat -N ingress
    iptables -t nat -A ingress -p tcp -m tcp --dport 8443 -j DNAT --to-destination 192.168.30.10:443
    iptables -t nat -A ingress -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.30.10:80
    iptables -t nat -A ingress -j RETURN
    iptables -t nat -A PREROUTING -j ingress
}
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
    curl $SERVER_CONFIG -o /usr/local/vpnserver/vpn_server.config
    _mkdirs
    /usr/local/vpnserver/vpnserver start
}

_client() {
    curl $CLIENT_CONFIG -o /usr/local/vpnclient/public_ip.vpn
    /usr/local/vpnclient/vpnclient start
    cd /usr/local/vpnclient
    /usr/local/vpnclient/vpncmd 127.0.0.1 /client /cmd AccountImport public_ip.vpn
    /usr/local/vpnclient/vpncmd 127.0.0.1 /client /cmd AccountConnect public_ip
}

_start_vpn() {
    [[ -n "$CLIENT_CONFIG" ]] && _client
    [[ -n "$SERVER_CONFIG" ]] && _server
}

_start_vpn

# shell illiteracy FTW!
tail -f /dev/null
