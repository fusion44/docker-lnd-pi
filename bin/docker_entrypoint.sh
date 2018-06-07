#!/bin/bash

set -uxo pipefail

LND_DIR=/lnd
LND_CONF=${LND_DIR}/lnd.conf

if [ ! -e "${LND_CONF}" ]; then
  cat >${LND_CONF} <<EOF


[Application Options]
debuglevel=${LND_DEBUG_LEVEL:=trace}
debughtlc=${LND_DEBUG_HTLC:=true}
maxlogfiles=${LND_MAX_LOG_FILES:=3}
maxlogfilesize=${LND_MAX_LOG_FILESIZE:=10}
maxpendingchannels=${LND_MAX_PENDING_CHANNELS:=10}
alias=${LND_ALIAS:=pi-lnd}
color=${LND_COLOR:=#FFFF00}

restlisten=0.0.0.0:8080
listen=0.0.0.0:9735
rpclisten=0.0.0.0:10009


[Bitcoin]
bitcoin.active=1
bitcoin.mainnet=1
bitcoin.node=bitcoind

[Bitcoind]
bitcoind.rpcuser=${BITCOIND_RPCUSER:=username}
bitcoind.rpcpass=${BITCOIND_RPCPASSWORD:=password}
bitcoind.rpchost=${BITCOIND_RPCHOST:=172.17.0.2:8332}
bitcoind.zmqpath=${BITCOIND_ZMQ_PATH:=tcp://172.17.0.2:18332}

[autopilot]
autopilot.active=1
autopilot.maxchannels=10
autopilot.allocation=0.6


EOF
fi


if [ $# -eq 0 ]; then
  exec lnd --logdir=${LND_DIR}/logs --datadir=${LND_DIR} --configfile=${LND_CONF}
else
  exec "$@"
fi
