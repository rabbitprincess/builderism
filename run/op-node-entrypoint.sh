#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
L1_RPC_URL=${L1_RPC_URL}
L1_BEACON_URL=${L1_BEACON_URL}
SEQUENCER_PRIVATE_KEY=${SEQUENCER_PRIVATE_KEY}
ADDITIONAL_ARGS=""

if [ "$SEQUENCER_MODE" = "true" ]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS \
        --sequencer.enabled \
        --sequencer.l1-confs=5 \
        --verifier.l1-confs=4 \
        --p2p.sequencer.key=${SEQUENCER_PRIVATE_KEY}"
fi

exec /app/op-node \
    --l1=${L1_RPC_URL} \
    --l1.beacon=${L1_BEACON_URL} \
    --l1.rpckind=any \
    --l2=http://geth:8551 \
    --l2.jwt-secret=/data/jwt.txt \
    --rollup.config=/config/rollup.json \
    --rpc.addr=0.0.0.0 \
    --rpc.port=8547 \
    --rpc.enable-admin \
    $ADDITIONAL_ARGS
