#!/bin/bash
set -eu

SEQUENCER_MODE=${SEQUENCER_MODE:-"false"}
OP_PROPOSER_L1_ETH_RPC=${L1_RPC_URL}

# if SEQUENCER_MODE is not true, do not run proposer
if [ "$SEQUENCER_MODE" != "true" ]; then
  echo "proposer only running in sequencer mode, exiting..."
  exit 0
fi

OP_PROPOSER_L2OO_ADDRESS=$(jq -r '.L2OutputOracleProxy' /config/.deploy)

PROPOSER_PRIVATE_KEY=$(grep "PROPOSER_PRIVATE_KEY" /config/address.ini | cut -d'=' -f2)

exec /app/op-proposer \
    --l1-eth-rpc=${OP_PROPOSER_L1_ETH_RPC} \
    --rollup-rpc=http://node:8547 \
    --poll-interval=12s \
    --rpc.port=8560 \
    --l2oo-address=${OP_PROPOSER_L2OO_ADDRESS} \
    --wait-node-sync=true \
    --private-key=${PROPOSER_PRIVATE_KEY}