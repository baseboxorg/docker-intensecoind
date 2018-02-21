FROM ubuntu:16.04

ENV S6_FIX_ATTRS_HIDDEN=1
ENV TMP_DIR /tmp/intensecoin
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

RUN apt-get -qq update \
  && apt-get -qq --no-install-recommends install wget ca-certificates libboost1.58-all-dev xz-utils

RUN mkdir -p $TMP_DIR \
  && cd $TMP_DIR \
  && wget "https://github.com/valiant1x/intensecoin/releases/download/1.4.4/Intensecoin-daemon-linux-x86_64.tar.xz" \
  && tar xf Intensecoin-daemon-linux-x86_64.tar.xz \
  && rm -f Intensecoin-daemon-linux-x86_64.tar.xz \
  && chmod +x * \
  && mv * /usr/local/bin/ \
  && rm -rf $TMP_DIR

# Contains the blockchain
VOLUME /root/.intensecoin

# Generate your wallet via accessing the container and run:
# cd /wallet
# intense-wallet-cli
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
