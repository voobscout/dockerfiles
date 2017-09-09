FROM debian:wheezy-backports

ENV DEBIAN_FRONTEND noninteractive
ENV GIT_SSL_NO_VERIFY 1
ENV container docker

RUN apt-get -fy update &&\
    apt-get -fy -t wheezy-backports upgrade &&\
    apt-get -fy -t wheezy-backports install \
                python-pip \
                xserver-xephyr \
                xdmx \
                xdmx-tools \
                tightvncserver \
                x11vnc \
                procps \
                xterm

COPY xdmx.sh /usr/local/bin/xdmx.sh
RUN pip install dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/xdmx.sh"]
