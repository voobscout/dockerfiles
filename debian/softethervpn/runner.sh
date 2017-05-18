#!/usr/bin/env bash
_ingress() {
    iptables -t nat -A POSTROUTING -p tcp -s 10.122.1.25 -d 10.122.1.25 --dport 25 -j SNAT --to 10.122.1.1
    # -j TEE --gateway 192.168.30.10
}

_wait4vpn() {
    port=$1
    server_ready=0
    while [ $server_ready -lt 1 ]
    do
        sleep 3
        </dev/tcp/localhost/$port && server_ready=1
    done
}

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
    vars="S_PASSWD S_HUB S_NAT_HOST S_DNAT S_USERS"

    for var in ${vars}; do
        [[ -z "$var" ]] && (echo "$var is required, but was not found!" && exit 1)
    done

    _mkdirs
    /usr/local/vpnserver/vpnserver start
    _wait4vpn '443'

    $vpncmd HubCreate $S_HUB /password
    $vpncmd ServerPasswordSet $S_PASSWD
    vpncmd="/usr/local/vpnserver/vpncmd 127.0.0.1 /server /password:$S_PASSWD /adminhub:$S_HUB /cmd"

    [[ -n "$S_CIPHER" ]] && cipher=$S_CIPHER || cipher='DHE-RSA-AES256-SHA'
    $vpncmd ServerCipherSet $cipher

    snh_ip=$(echo $S_NAT_HOST | awk -F':' '{print $1}')
    snh_mask=$(echo $S_NAT_HOST | awk -F':' '{print $2}')
    $vpncmd SecureNatHostSet /mac:none /ip:$snh_ip /mask:$snh_mask
    $vpncmd SecureNatEnable

    for i in $S_USERS; do
        uname=$(echo $i | awk -F':' '{print $1}')
        passwd=$(echo $i | awk -F':' '{print $2}')
        $vpncmd UserCreate $uname /group /realname /note
        $vpncmd UserPasswordSet $uname /password:$passwd
    done

    iptables -t nat -N ingress
    for i in $S_DNAT; do
        proto=$(echo $i | awk -F'/' '{print $2}')
        port=$(echo $i | awk -F'/' '{print $1}' | awk -F':' '{print $2}')
        iptables -t nat -A ingress -p $proto -m $proto --dport $port -j DNAT --to-destination $i
    done
    iptables -t nat -A ingress -j RETURN
    iptables -t nat -I PREROUTING -j ingress

}

_client() {
    vpncmd="/usr/local/vpnclient/vpncmd 127.0.0.1:9930 /client /cmd"
    vars="C_ACCOUNT C_NIC C_SERVER C_HUB C_UNAME C_PASSWD"

    for var in ${vars}; do
        [[ -z "$var" ]] && (echo "$var is required, but was not found!" && exit 1)
    done

    /usr/local/vpnclient/vpnclient start
    _wait4vpn '9930'

    $vpncmd NicCreate $C_NIC
    $vpncmd AccountCreate $C_ACCOUNT \
            /server:$C_SERVER \
            /hub:$C_HUB \
            /username:$C_UNAME \
            /nicname:$C_NIC
    $vpncmd AccountPasswordSet $C_ACCOUNT /password:$C_PASSWD /type:standard
    [[ -n "$C_COMPRESS" ]] && $vpncmd AccountCompressEnable $C_ACCOUNT
    $vpncmd AccountConnect $C_ACCOUNT

    connected=1
    while [ $connected -gt 0 ]
    do
        sleep 3
        echo 'Checking connection status...'
        $vpncmd AccountStatusGet $C_ACCOUNT | grep -q 'Session Established'
        connected=$?
    done
    echo 'Connection established...'

    [[ -n "$C_NIC_DHCP" ]] && dhclient vpn_$C_NIC || ip addr add $C_NIC_IP dev vpn_$C_NIC

    if [ -z "$SERVER_CONFIG" ]; then
        gw=$(ip r | grep -i vpn_ingress | awk -F'/' '{print $1}' | awk -F'.' '{print $1 "." $2 "." $3 ".1"}')
        echo "nameserver $gw" > /etc/resolv.conf

        vpn_server_ip=$(echo $C_SERVER | awk -F':' '{print $1}' | xargs dig +short $1 @8.8.8.8)
        old_default_route=$(ip r | grep default | awk 'NR==1 {print $3}')
        container_ip=$(ip a | grep eth0 | awk 'NR==2 {print $2}' | awk -F'/' '{print $1}')
        ip route add $vpn_server_ip via $old_default_route src $container_ip
        ip route del default
        ip route add default via $gw
    fi
}

_start_vpn() {
    sysctl -w net.ipv4.ip_forward=1 &> /dev/null
    modprobe tun &> /dev/null
    [[ -n "$SERVER_CONFIG" ]] && _server
    [[ -n "$CLIENT_CONFIG" ]] && _client
    tail -f /dev/null
}

[[ $# -gt 0 ]] && exec "$@" || _start_vpn
