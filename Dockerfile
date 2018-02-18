FROM ubuntu:16.04

ENV S6_FIX_ATTRS_HIDDEN=1
ENV SRC_DIR /usr/local/src/intensecoin
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

RUN set -x \
  && buildDeps=' \
      ca-certificates \
      cmake \
      g++ \
      git \
      libboost1.58-all-dev \
      libssl-dev \
      make \
      pkg-config \
  ' \
  && apt-get -qq update \
  && apt-get -qq --no-install-recommends install $buildDeps

RUN git clone -b xmr --single-branch https://github.com/valiant1x/intensecoin.git $SRC_DIR --depth 1
WORKDIR $SRC_DIR
RUN make -j$(nproc)

RUN cp build/release/src/connectivity_tool build/release/src/intensecoind build/release/src/miner build/release/src/simplewallet build/release/src/walletd /usr/local/bin/ \
  && rm -r $SRC_DIR \
  && apt-get -qq --auto-remove purge $buildDeps

# Contains the blockchain
VOLUME /root/.intensecoin

# Generate your wallet via accessing the container and run:
# cd /wallet
# simplewallet
VOLUME /wallet

EXPOSE 48782
EXPOSE 48772

WORKDIR /root

# S6 Overlay
COPY rootfs /
ADD env/.bashrc /root/
RUN apt-get -y install curl && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.1/s6-overlay-amd64.tar.gz \
    | tar xzf - -C /

ENTRYPOINT [ "/init" ]
