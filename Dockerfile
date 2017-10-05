FROM debian:jessie-slim as builder
MAINTAINER Ville Törhönen <ville@torhonen.fi>

# Install build dependencies
# Separate layer so we can cache things
RUN set -x && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        libtool \
        autotools-dev \
        automake \
        pkg-config \
        libssl-dev \
        libevent-dev \
        bsdmainutils \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-program-options-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libzmq3-dev \
        git \
        wget && \
    rm -rf /var/lib/apt/lists/* 

RUN set -x && \
    cd /tmp && \
    git clone https://github.com/vertcoin/vertcoin.git && \
    mkdir -p /tmp/vertcoin/db4 && \
    wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' && \
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c && \
    tar xzvf db-4.8.30.NC.tar.gz && \
    cd db-4.8.30.NC/build_unix && \
    ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/tmp/vertcoin/db4 && \
    make install

RUN set -x && \
    cd /tmp/vertcoin && \
    git checkout tags/v0.11.1.0 && \
    ./autogen.sh && \
    ./configure \
        LDFLAGS="-L/tmp/vertcoin/db4/lib/" \
        CPPFLAGS="-I/tmp/vertcoin/db4/include/" \
        --without-gui \
        --without-miniupnpc && \
    make && \
    make install && \
    rm -rf /tmp/*

# Copy binaries and libs from builder to a separate image
FROM debian:jessie-slim
MAINTAINER Ville Törhönen <ville@torhonen.fi>

COPY --from=builder /usr/lib/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/libpgm-5.1.so.0 /usr/lib/libpgm-5.1.so.0
COPY --from=builder /usr/local/bin/vertcoind /usr/local/bin/
COPY --from=builder /usr/local/bin/vertcoin-cli /usr/local/bin/
COPY --from=builder /usr/local/bin/vertcoin-tx /usr/local/bin/
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
