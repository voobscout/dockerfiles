#!/usr/bin/env bash
_ingress() {
    iptables -t nat -N ingress
    iptables -t nat -A ingress -p tcp --dport 443 -j DNAT --to-destination 192.168.30.10:443
    iptables -t nat -A ingress -p tcp --dport 80  -j DNAT --to-destination 192.168.30.10:80
    iptables -t nat -A ingress -j RETURN
    iptables -t nat -I PREROUTING -j ingress

    iptables -t nat -I PREROUTING -p tcp --dport 443 -j DNAT --to-destination 192.168.30.254:443
    # iptables -t nat -I OUTPUT -p tcp --dport 80 -j DNAT --to-destination 192.168.30.254:80

    iptables -t nat -A PREROUTING  -p tcp                -d $EXT.IP.ADD.RESS --dport 25 -j DNAT --to-destination 10.122.1.25:25
    iptables -t nat -A OUTPUT      -p tcp                -d $EXT.IP.ADD.RESS --dport 25 -j DNAT --to-destination 10.122.1.25:25

    iptables -t nat -A POSTROUTING -p tcp -s 10.122.1.25 -d 10.122.1.25      --dport 25 -j SNAT --to 10.122.1.1
}

# ip link set promisc on tap_vpn-br
# -j TEE --gateway 192.168.30.10
# ip tuntap add mode tap br0p0

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

    $vpncmd SecureNatEnable
    snh_ip=$(echo $S_NAT_HOST | awk -F':' '{print $1}')
    snh_mask=$(echo $S_NAT_HOST | awk -F':' '{print $2}')
    $vpncmd SecureNatHostSet /mac:none /ip:$snh_ip /mask:$snh_mask

    for i in $S_USERS; do
        uname=$(echo $i | awk -F':' '{print $1}')
        passwd=$(echo $i | awk -F':' '{print $2}')
        $vpncmd UserCreate $uname /group /realname /note
        $vpncmd UserPasswordSet $uname /password:$passwd
    done

    for i in $S_DNAT; do
        proto=$(echo $i | awk -F'/' '{print $2}')
        port=$(echo $i | awk -F'/' '{print $1}' | awk -F':' '{print $2}')
        iptables -t nat -I hyperstart-PREROUTING -p $proto -m $proto --dport $port -j DNAT --to-destination $i
    done

}

_client() {
    vpncmd="/usr/local/vpnclient/vpncmd 127.0.0.1 /client /cmd"
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

    [[ -n "$C_NIC_DHCP" ]] && dhclient vpn_$C_NIC || ip addr add $C_NIC_IP dev vpn_$C_NIC

    ns=$(ip r | grep -i vpn_ingress | awk -F'/' '{print $1}' | awk -F'.' '{print $1 "." $2 "." $3 ".1"}')
    echo "nameserver $ns" > /etc/resolv.conf

    vpn_server_ip=$(echo $C_SERVER | awk -F':' '{print $1}' | xargs dig +short $1 @8.8.8.8)
    old_default_route=$(ip r | grep default | awk 'NR==1 {print $3}')
    container_ip=$(ip a | grep eth0 | awk 'NR==2 {print $2}' | awk -F'/' '{print $1}')
    ip route add $vpn_server_ip via $old_default_route src $container_ip
    ip route del default
    ip route add default via $ns

    # ip link set dev vpn_$C_NIC mtu 1450
}

_start_vpn() {
    [[ -n "$CLIENT_CONFIG" ]] && _client
    [[ -n "$SERVER_CONFIG" ]] && _server
}

sysctl -w net.ipv4.ip_forward=1 &> /dev/null
modprobe tun &> /dev/null

_start_vpn

# shell illiteracy FTW!
tail -f /dev/null
