#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
OP_BATCHER_L1_ETH_RPC=${L1_RPC_URL}
OP_BATCHER_MAX_CHANNEL_DURATION=${MAX_CHANNEL_DURATION:-0}

# if SEQUENCER_MODE is not true, do not run batcher
if [ "$SEQUENCER_MODE" != "true" ]; then
  echo "batcher only running in sequencer mode, exiting..."
  exit 0
fi

OP_BATCHER_PRIVATE_KEY=$(grep "BATCHER_PRIVATE_KEY" /config/address.ini | cut -d'=' -f2)

exec /app/op-batcher \
    --l1-eth-rpc=${OP_BATCHER_L1_ETH_RPC} \
    --l2-eth-rpc=http://geth:8545 \
    --rollup-rpc=http://node:8547 \
    --sub-safety-margin=6 \
    --poll-interval=1s \
    --num-confirmations=1 \
    --safe-abort-nonce-too-low-count=3 \
    --resubmission-timeout=30s \
    --rpc.addr=0.0.0.0 \
    --rpc.port=8548 \
    --rpc.enable-admin \
    --data-availability-type=blobs \
    --wait-node-sync=true \
    --max-channel-duration=${OP_BATCHER_MAX_CHANNEL_DURATION} \
    --private-key=${OP_BATCHER_PRIVATE_KEY}