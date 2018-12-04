FROM voobscout/base-arch:systemd
MAINTAINER Voob of Doom <vod+dockerhub@njk.li>

RUN runuser -l dev -c 'yaourt --noconfirm -Syyu && yaourt --noconfirm -S brother-mfc-j615w cups'
ADD cups_service_override.conf /etc/systemd/system/org.cups.cupsd.service.d/override.conf
# ADD cupsd.conf /etc/cups/cupsd.conf
RUN systemctl enable org.cups.cupsd.service
RUN usermod -a -G cups dev
