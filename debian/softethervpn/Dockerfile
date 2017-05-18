# SoftEther VPN server

FROM voobscout/base-deb:latest
MAINTAINER voobscout

ENV VERSION v4.22-9634-beta-2016.11.27
WORKDIR /usr/local/vpnserver


RUN apt-get update && \
        apt-get -y -q install \
        iptables \
        gcc \
        make \
        wget \
        dnsutils \
        isc-dhcp-client && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget -c http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnserver.tar.gz && \
        wget -c http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Client/64bit_-_Intel_x64_or_AMD64/softether-vpnclient-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-client.tar.gz && \
        tar xzf /tmp/softether-vpnserver.tar.gz -C /usr/local/ && \
        tar xzf /tmp/softether-client.tar.gz -C /usr/local/ && \
        rm /tmp/softether-vpnserver.tar.gz && \
        rm /tmp/softether-client.tar.gz && \
        cd /usr/local/vpnclient && \
        make i_read_and_agree_the_license_agreement && \
        cd /usr/local/vpnserver && \
        make i_read_and_agree_the_license_agreement && \
        apt-get purge -y -q --auto-remove gcc make wget

ADD runner.sh /usr/local/vpnserver/runner.sh
RUN chmod 755 /usr/local/vpnserver/runner.sh

EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp

ENTRYPOINT ["/usr/local/vpnserver/runner.sh"]
