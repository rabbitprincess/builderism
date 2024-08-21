#!/bin/bash

echo "[3/5] : generate config"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# Generate the configuration using Jsonnet
cd ~/optimism/packages/contracts-bedrock && \
mkdir -p ./deployments/$DEPLOYMENT_CONTEXT && \
jsonnet generate_config.jsonnet \
  --ext-code config='{
    l2GenesisBlockNonce: "1",
    l2GenesisBlockGasUsed: "0",
  }' > .deploy

  # --ext-str block="$block" \
  # --ext-str timestamp="$timestamp" \
  # --ext-str blockhash="$blockhash" \
  # --ext-str L1_CHAIN_ID="$L1_CHAIN_ID" \
  # --ext-str L2_CHAIN_ID="$L2_CHAIN_ID" \
  # --ext-str SEQUENCER_ADDRESS="$SEQUENCER_ADDRESS" \
  # --ext-str BATCHER_ADDRESS="$BATCHER_ADDRESS" \
  # --ext-str PROPOSER_ADDRESS="$PROPOSER_ADDRESS" \
  # --ext-str ADMIN_ADDRESS="$ADMIN_ADDRESS" \
  # --ext-str DEPLOYMENT_CONTEXT="$DEPLOYMENT_CONTEXT" \
  # --ext-str GOVERNANCE_TOKEN_SYMBOL="${GOVERNANCE_TOKEN_SYMBOL:-''}" \
  # --ext-str ALT_DA_SERVER="${ALT_DA_SERVER:-''}" \