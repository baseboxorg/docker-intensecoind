FROM docker/compose:1.20.1

MAINTAINER BaseBoxOrg <baseboxorg@outlook.com>

RUN \
  apk --no-cache add --virtual .rundeps \
    ca-certificates \
    curl \
    docker \
    git \
    openssh-client \
    openssl \
    parallel \
    ruby \
    ruby-bundler \
    ruby-json \
    tar \
    gzip && \
  gem install danger --no-document
