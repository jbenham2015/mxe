FROM ubuntu:24.04
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# MXE system dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    gettext \
    git \
    gperf \
    intltool \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libgl-dev \
    libpcre2-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    nsis \
    openssl \
    p7zip-full \
    patch \
    perl \
    python3 \
    python3-mako \
    python3-packaging \
    python3-pkg-resources \
    python3-setuptools \
    python-is-python3 \
    ruby \
    sed \
    sqlite3 \
    unzip \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Clone your MXE fork
RUN git clone https://github.com/jbenham2015/mxe.git /opt/mxe

# Build all Denemo dependencies (slow - only reruns when Dockerfile changes)
RUN cd /opt/mxe && make denemo \
    -j$(nproc) \
    2>&1 | tail -100

ENV PATH="/opt/mxe/usr/bin:$PATH"
