FROM debian:stretch

MAINTAINER voobscout

# add contrib, non-free and backports repositories, pin stable repositories
ADD sources.list /etc/apt/sources.list
ADD preferences /etc/apt/preferences

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
    apt-get -y update && apt-get -y upgrade && apt-get clean && \
	  apt-get -y install apt-utils lsb-release curl git cron at logrotate rsyslog \
		                   unattended-upgrades ssmtp lsof procps \
		                   initscripts libsystemd0 libudev1 systemd sysvinit-utils udev util-linux \
                       locales bzip2 jq lighttpd openssh-server openssh-client sudo \
                       build-essential \
                       wget \
                       libsodium-dev \
	                     pkg-config \
	                     autotools-dev \
	                     dh-autoreconf \
	                     libssl-dev \
	                     libbz2-dev \
	                     libsqlite3-dev \
	                     libcurl4-openssl-dev \
	                     liblzma-dev \
	                     libgc-dev \
	                     libdbi-perl \
	                     libdbd-sqlite3-perl \
	                     libwww-curl-perl \
	                     libxml2 \
	                     libxslt-dev \
	                     libseccomp-dev && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
	apt-get clean && \
	sed -i '/imklog/{s/^/#/}' /etc/rsyslog.conf

# set random root password
RUN P="$(dd if=/dev/random bs=1 count=8 2>/dev/null | base64)" ; echo $P && echo "root:$P" | chpasswd
# set to foobar
#RUN P="foobar" ; echo $P && echo "root:$P" | chpasswd

# unattended upgrades & co
# ADD apt_unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
# ADD apt_periodic /etc/apt/apt.conf.d/02periodic

RUN cd /lib/systemd/system/sysinit.target.wants/ && \
		ls | grep -v systemd-tmpfiles-setup.service | xargs rm -f && \
		rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
		systemctl mask -- \
			tmp.mount \
			etc-hostname.mount \
			etc-hosts.mount \
			etc-resolv.conf.mount \
			-.mount \
			swap.target \
			getty.target \
			getty-static.service \
			dev-mqueue.mount \
			cgproxy.service \
			systemd-tmpfiles-setup-dev.service \
			systemd-remount-fs.service \
			systemd-ask-password-wall.path \
			systemd-logind.service && \
		systemctl set-default multi-user.target || true

RUN sed -ri /etc/systemd/journald.conf \
			-e 's!^#?Storage=.*!Storage=volatile!'

ADD container-boot.service /etc/systemd/system/container-boot.service
RUN mkdir -p /etc/container-boot.d && \
		systemctl enable container-boot.service

# run stuff
ADD configurator.sh configurator_dumpenv.sh /root/
ADD configurator.service configurator_dumpenv.service /etc/systemd/system/
RUN chmod 700 /root/configurator.sh /root/configurator_dumpenv.sh && \
		systemctl enable configurator.service configurator_dumpenv.service

# setup nix
ADD nix-install-deb-multi-user /root
RUN chmod +x /root/nix-install-deb-multi-user && /root/nix-install-deb-multi-user

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]
CMD ["/lib/systemd/systemd"]
