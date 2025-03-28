#!/bin/bash
set -eu

RUN_MODE=${RUN_MODE:-"replica"}
OP_PROPOSER_L1_ETH_RPC=${L1_RPC_URL}

if [ "$RUN_MODE" != "sequencer" ]; then
  echo "proposer only running in sequencer mode, exiting..."
  exit 0
fi

OP_PROPOSER_GAME_FACTORY_ADDRESS=$(jq -r '.. | .disputeGameFactoryProxyAddress? // empty' /config/state.json)
PROPOSER_PRIVATE_KEY=$(grep "PROPOSER_PRIVATE_KEY" /config/address.ini | cut -d'=' -f2)

exec /app/op-proposer \
  --l1-eth-rpc=${OP_PROPOSER_L1_ETH_RPC} \
  --rollup-rpc=http://node:8547 \
  --poll-interval=12s \
  --rpc.port=8560 \
  --game-factory-address=${OP_PROPOSER_GAME_FACTORY_ADDRESS} \
  --proposal-interval=20s \
  --wait-node-sync=true \
  --private-key=${PROPOSER_PRIVATE_KEY}