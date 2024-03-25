#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
L1_RPC_URL=${L1_RPC_URL}
PROPOSER_PRIVATE_KEY=${PROPOSER_PRIVATE_KEY}

# if SEQUENCER_MODE is not true, do not run proposer
if [ "$SEQUENCER_MODE" != "true" ]; then
  echo "proposer only running in sequencer mode, exiting..."
  exit 0
fi

exec /app/op-proposer \
    --l1-eth-rpc=${L1_RPC_URL} \
    --rollup-rpc=http://node:8547 \
    --poll-interval=12s \
    --rpc.port=8560 \
    --l2oo-address=${L2OO_ADDRESS} \
    --private-key=${PROPOSER_PRIVATE_KEY}