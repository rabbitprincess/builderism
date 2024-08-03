#!/bin/bash
set -eu

RUN_MODE=${RUN_MODE:-"replica"}
OP_BATCHER_L1_ETH_RPC=${L1_RPC_URL}
OP_BATCHER_MAX_CHANNEL_DURATION=${OP_BATCHER_MAX_CHANNEL_DURATION:-0}
OP_BATCHER_DATA_AVAILABILITY_TYPE=${OP_BATCHER_DATA_AVAILABILITY_TYPE:-"blobs"}

if [ "$RUN_MODE" != "sequencer" ]; then
  echo "batcher only running in sequencer mode, exiting..."
  exit 0
fi

OP_BATCHER_PRIVATE_KEY=$(grep "BATCHER_PRIVATE_KEY" /config/address.ini | cut -d'=' -f2)

exec /app/op-batcher \
  --l1-eth-rpc=${OP_BATCHER_L1_ETH_RPC} \
  --l2-eth-rpc=http://execution:8545 \
  --rollup-rpc=http://node:8547 \
  --sub-safety-margin=6 \
  --poll-interval=6s \
  --num-confirmations=10 \
  --safe-abort-nonce-too-low-count=3 \
  --resubmission-timeout=30s \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8548 \
  --rpc.enable-admin \
  --data-availability-type=${OP_BATCHER_DATA_AVAILABILITY_TYPE} \
  --wait-node-sync=true \
  --max-channel-duration=${OP_BATCHER_MAX_CHANNEL_DURATION} \
  --private-key=${OP_BATCHER_PRIVATE_KEY}