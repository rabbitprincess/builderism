#!/bin/bash

echo "[3/5] : generate config"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# Generate the configuration using Jsonnet
cd ~/optimism/packages/contracts-bedrock && \
mkdir -p ./deployments/$DEPLOYMENT_CONTEXT && \
jsonnet /script/3_config.jsonnet --ext-code config='{
  ADMIN_ADDRESS: "$ADMIN_ADDRESS",
  BATCHER_ADDRESS: "$BATCHER_ADDRESS",
  SEQUENCER_ADDRESS: "$SEQUENCER_ADDRESS",
  TIMESTAMP: "$timestamp",
  l1ChainID: "$L1_CHAIN_ID",
  l2ChainID: "$L2_CHAIN_ID",
  l2BlockTime: "$timestamp",
  l1StartingBlockTag: "$blockhash",
}' > /config/.deploy