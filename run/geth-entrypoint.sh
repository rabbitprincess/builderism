#!/bin/bash
set -eu

RUN_MODE=${RUN_MODE:-"fullnode"}
ADDITIONAL_ARGS=""

if [ "$RUN_MODE" != "sequencer" ]; then
  if [ ! -z "${OP_GETH_SEQUENCER_HTTP:-}" ]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rollup.halt=major"
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rollup.sequencerhttp=$OP_GETH_SEQUENCER_HTTP"
  fi
fi

echo "ADDITIONAL ARGS: $ADDITIONAL_ARGS"

# Run geth with specified parameters
exec /app/geth \
  --datadir=/data \
  --db.engine=pebble \
  --networkid=${L2_CHAIN_ID} \
  --syncmode=full \
  --gcmode=archive \
  --nodiscover \
  --maxpeers=0 \
  --http \
  --http.vhosts="*" \
  --http.corsdomain="*" \
  --http.addr=0.0.0.0 \
  --http.port=8545 \
  --http.api=web3,debug,eth,txpool,net,engine \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=8546 \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=8551 \
  --authrpc.jwtsecret=/data/jwt.txt \
  --rollup.disabletxpoolgossip=true \
  $ADDITIONAL_ARGS