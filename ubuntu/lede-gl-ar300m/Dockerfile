FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    apt-get -y update && apt-get dist-upgrade -y && \
    apt-get install -fy \
    build-essential \
    subversion \
    libncurses5-dev \
    zlib1g-dev \
    gawk \
    gcc-multilib \
    flex \
    git-core \
    gettext \
    libssl-dev \
    unzip \
    wget \
    python \
    g++ \
    rsync \
    man-db \
    file \
    zip \
    time quilt  xsltproc libxml-parser-perl mercurial bzr ecj cvs

RUN useradd -m -g users -G sudo,lp,uucp,dialout openwrt
