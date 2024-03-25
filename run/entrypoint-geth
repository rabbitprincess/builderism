#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
ADDITIONAL_ARGS=""

if [ "$SEQUENCER_MODE" != "true" ]; then
    if [ "${SEQUENCER_HTTP+x}" = x ]; then
        ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rollup.halt=major --rollup.sequencer-http=$SEQUENCER_HTTP"
    fi
    if [ "${BOOTNODES+x}" = x ]; then
        ADDITIONAL_ARGS="$ADDITIONAL_ARGS --bootnodes=$BOOTNODES"
    fi
fi

echo "ADDITIONAL ARGS: $ADDITIONAL_ARGS"

# Run geth with specified parameters
exec /app/geth \
    --datadir=/data \
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