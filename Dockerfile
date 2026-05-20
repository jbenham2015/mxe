FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
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
    guile-3.0 \
    guile-3.0-dev \
    intltool \
    itstool \
    libgdk-pixbuf-2.0-dev \
    libltdl-dev \
    libgl-dev \
    libgtk-3-bin \
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
    rsync \
    ruby \
    sed \
    sqlite3 \
    unzip \
    wget \
    wine \
    xz-utils \
    zip \
    cmake \
    meson \
    ninja-build \
    pkg-config \
    yasm \
    nasm \
    texinfo \
    scons \
    g++-multilib \
    libc6-dev-i386 \
    libclang-dev \
    && rm -rf /var/lib/apt/lists/*

# Cache bust - increment when deps change
ARG CACHE_BUST=3
# Clone your MXE fork
RUN git clone https://github.com/jbenham2015/mxe.git /opt/mxe
# Build all Denemo dependencies (slow - only reruns when Dockerfile changes) 
RUN mkdir -p /opt/mxe/pkg && \
    wget -q https://ftp.gnu.org/gnu/guile/guile-3.0.10.tar.xz \
         -O /opt/mxe/pkg/guile-3.0.10.tar.xz
# cache-bust 2026-05-19 - force Guile rebuild with --disable-jit
RUN cd /opt/mxe && make guile gtk3 gtksourceview aubio portaudio librsvg libgcrypt portmidi libsndfile evince fluidsynth \
    MXE_TARGETS=x86_64-w64-mingw32.shared \
    PKG_CDN= \
    PKG_MIRROR= \
    -j$(nproc)

ENV PATH="/opt/mxe/usr/bin:$PATH"

# cache-bust Mon May 18 09:28:50 PM UTC 2026
