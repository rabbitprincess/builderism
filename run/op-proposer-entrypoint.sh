#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
L1_RPC_URL=${L1_RPC_URL}

# if SEQUENCER_MODE is not true, do not run proposer
if [ "$SEQUENCER_MODE" != "true" ]; then
  echo "proposer only running in sequencer mode, exiting..."
  exit 0
fi

L2OO_ADDRESS=$(grep "L2OO_ADDRESS" /config/address.ini | cut -d'=' -f2)
PROPOSER_PRIVATE_KEY=$(grep "PROPOSER_PRIVATE_KEY" /config/address.ini | cut -d'=' -f2)

exec /app/op-proposer \
    --l1-eth-rpc=${L1_RPC_URL} \
    --rollup-rpc=http://node:8547 \
    --poll-interval=12s \
    --rpc.port=8560 \
    --l2oo-address=${L2OO_ADDRESS} \
    --private-key=${PROPOSER_PRIVATE_KEY}