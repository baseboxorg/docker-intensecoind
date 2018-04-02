FROM ubuntu:16.04

ENV SRC_DIR /app

RUN set -x \
  && buildDeps=' \
      cmake \
      g++ \
      git \
      libboost1.58-all-dev \
      libssl-dev \
      make \
      pkg-config ' \
  && apt-get -qq update \
  && apt-get -qq --no-install-recommends install apt-transport-https ca-certificates wget libminiupnpc-dev $buildDeps

RUN git clone https://github.com/valiant1x/intensecoin.git $SRC_DIR
WORKDIR $SRC_DIR
RUN git checkout master
# checkout is temporary until master is also xmr source
RUN make -j$(nproc) release-static

RUN cp build/release/bin/* /usr/local/bin/ \
  && rm -r $SRC_DIR \
  && apt-get -qq --auto-remove purge $buildDeps

# Contains the blockchain
VOLUME /app/.intensecoin

# Generate your wallet via accessing the container and run:
# cd /wallet
# intense-wallet-cli
VOLUME /app/wallet

ENV LOG_LEVEL 0
ENV P2P_BIND_IP 0.0.0.0
ENV P2P_BIND_PORT 48772
ENV RPC_BIND_IP 127.0.0.1
ENV RPC_BIND_PORT 48782

EXPOSE 48782
EXPOSE 48772

CMD intensecoind --log-level=$LOG_LEVEL --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC_BIND_PORT
