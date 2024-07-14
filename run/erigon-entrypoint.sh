#!/bin/sh
set -eu

RUN_MODE=${RUN_MODE:-"fullnode"}
ADDITIONAL_ARGS=""

if [ "$RUN_MODE" != "sequencer" ]; then
  if [ ! -z "${OP_EXECUTION_SEQUENCER_HTTP:-}" ]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rollup.halt=major"
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rollup.sequencerhttp=$OP_EXECUTION_SEQUENCER_HTTP"
  fi
  if [ ! -z "${L2_SUPERCHAIN_NETWORK:-}" ]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --chain=$L2_SUPERCHAIN_NETWORK"
  fi
fi

exec erigon \
  --datadir=/data \
  --private.api.addr=localhost:9090 \
  --nodiscover \
  --maxpeers=0 \
  --http.addr=0.0.0.0 \
  --http.port=8545 \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=8551 \
  --authrpc.vhosts="*" \
  --authrpc.jwtsecret=/data/jwt.txt \
  --txpool.gossip.disable=true \
  --db.size.limit=8TB \
  $ADDITIONAL_ARGS