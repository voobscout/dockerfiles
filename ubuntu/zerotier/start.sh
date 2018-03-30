#!/usr/bin/env bash

_zt_start() {
    zerotier-one -d -U
    while [[ ! -f /var/lib/zerotier-one/identity.public ]];do sleep 3;done
    export ZT_DEVICE_ID=$(cat /var/lib/zerotier-one/identity.public| cut -d ':' -f 1)
}

_zt_join() {
    zerotier-cli join $ZT_NETWORK_ID
}

_zt_nat() {
    local zt_network=$(zerotier-cli listnetworks | grep -i $ZT_NETWORK_ID | cut -d' ' -f9)
    local eth0_ipaddr=$(ip a show eth0 | grep 'inet ' | xargs | cut -d' ' -f2 | cut -d'/' -f1)
    local anywhere="0.0.0.0/0"

    eval iptables -t nat -A POSTROUTING -s $zt_network -o eth0 -j SNAT --to-source $eth0_ipaddr
    eval iptables -A FORWARD -i zt0 -s $zt_network -d $anywhere -j ACCEPT
    eval iptables -A FORWARD -i eth0 -s $anywhere -d $zt_network -j ACCEPT

    iptables-save
}

_zt_net_auth() {
    [[ $NODE_DESCRIPTION ]] && true || export NODE_DESCRIPTION='containerized zt1'
    local node_name=$(hostname)
    local api_endpoint="https://my.zerotier.com/api/network/$ZT_NETWORK_ID/member/$ZT_DEVICE_ID/"
    local header_type='"Content-Type: application/json; charset=UTF-8"'
    local header_auth="\"Authorization: Bearer $ZT_API_KEY\""
    local form=$(cat <<EOL
{
  "networkId": "$ZT_NETWORK_ID",
  "nodeId": "$ZT_DEVICE_ID",
  "name": "$node_name",
  "description": "$NODE_DESCRIPTION",
  "config": {
    "nwid": "$ZT_NETWORK_ID",
    "authorized": true
  }
}
EOL
        )

    eval curl -fssL -H $header_type -H $header_auth -X POST -d \'$form\' $api_endpoint &> /dev/null
}

_zt() {
    _zt_start && _zt_join && _zt_net_auth
    while [[ ! -f /sys/devices/virtual/net/zt0/address ]];do sleep 2;done
    while [[ ! $(ip a show dev zt0) ]];do sleep 2;done
    while [[ ! $(zerotier-cli listnetworks | grep OK) ]];do sleep 3;done
}

[[ $ZT_NETWORK_ID && $ZT_API_KEY ]] && (_zt && _zt_nat) || echo '$ZT_NETWORK_ID and $ZT_API_KEY are required, but missing!'

while [[ $(ps aux | grep -i '[z]erotier') ]];do zerotier-cli listnetworks | grep OK && sleep 60;done
