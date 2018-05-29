FROM resin/raspberry-pi-alpine-golang
MAINTAINER Stefan Stammberger <some.fusion@gmail.com>


RUN apk update && apk upgrade

RUN apk add --no-cache \
    git \
    make \
&&  git clone https://github.com/lightningnetwork/lnd /go/src/github.com/lightningnetwork/lnd \
&&  cd /go/src/github.com/lightningnetwork/lnd \
&&  make \
&&  make install

RUN lnd --version

ENV HOME /lnd

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/lnd"]
EXPOSE 8080 9735 10009
WORKDIR /lnd

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
