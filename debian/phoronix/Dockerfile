FROM voobscout/base-deb
MAINTAINER Voobscout <voobscout@gmail.com>

# COPY start.sh /
ADD http://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_6.2.1_all.deb /

RUN export DEBIAN_FRONTEND='noninteractive' && \
    export GIT_SSL_NO_VERIFY=1 && \
    export container=docker && \
    apt-get update && \
    apt-get install -t jessie-backports -qqyf \
    build-essential \
    autoconf \
    yasm \
    libpcre3-dev \
    bc \
    autoconf \
    libpopt-dev \
    libaio-dev \
    libssl-dev \
    libnuma-dev \
    tcl \
    gfortran \
    libfftw3-dev \
    fftw-dev \
    libblas-dev \
    liblapack-dev \
    cmake \
    cmake-data \
    libboost-all-dev \
    libasio-dev \
    libboost-iostreams-dev \
    libbz2-dev \
    zlib1g-dev \
    libjpeg-dev \
    libtiff-dev \
    libpng12-dev \
    freeglut3-dev \
    libopenmpi-dev \
    openmpi-bin \
    libmpich-dev \
    openjdk-7-jre \
    portaudio19-dev \
    php5-cli \
    php5-gd \
    php5-json && \

    dpkg -i /phoronix-test-suite_6.2.1_all.deb && \
    rm -rf /phoronix-test-suite_6.2.1_all.deb && \
    # phoronix-test-suite install-dependencies pts/universe-cli && \
    # chmod +x /start.sh && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    /tmp/* \
    /var/log/apt/* \
    /var/log/alternatives.log \
    /var/log/bootstrap.log \
    /var/log/dpkg.log

ENTRYPOINT ["/usr/bin/dumb-init", "bash", "-l"]
