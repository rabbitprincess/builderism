#!/bin/bash

echo "[3/5] : generate config"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# make necessary args
extCode="{"
extCode+="ADMIN_ADDRESS: \"$ADMIN_ADDRESS\", "
extCode+="BATCHER_ADDRESS: \"$BATCHER_ADDRESS\", "
extCode+="SEQUENCER_ADDRESS: \"$SEQUENCER_ADDRESS\", "
extCode+="PROPOSER_ADDRESS: \"$PROPOSER_ADDRESS\", "
extCode+="TIMESTAMP: \"$timestamp\", "
extCode+="l1StartingBlockTag: \"$blockhash\", "
extCode+="l1ChainID: $L1_CHAIN_ID, "
extCode+="l2ChainID: $L2_CHAIN_ID"

# Governance
if [ -n "$GOVERNANCE_TOKEN_SYMBOL" ]; then
  extCode+=", "
  extCode+="enableGovernance: true, "
  extCode+="governanceTokenSymbol: \"$GOVERNANCE_TOKEN_SYMBOL\", "
  extCode+="governanceTokenName: \"$GOVERNANCE_TOKEN_SYMBOL\", "
  extCode+="governanceTokenOwner: \"$ADMIN_ADDRESS\""
fi

# Alt DA
if [ -n "${ALT_DA_SERVER}" ]; then
  extCode+=", "
  extCode+="altDAServer: \"$ALT_DA_SERVER\", "
  extCode+="usePlasma: true, "
  extCode+="daCommitmentType: \"KeccakCommitment\", ",
  extCode+="daChallengeWindow: 16, ",
  extCode+="daResolveWindow: 16, ",
  extCode+="daBondSize: 1000000, ",
  extCode+="daResolverRefundPercentage: 0"
fi

# Fault proof - TODO

extCode+="}"

# Generate the configuration using Jsonnet
cd ~/optimism/packages/contracts-bedrock && \
mkdir -p ./deployments/$DEPLOYMENT_CONTEXT && \
jsonnet /script/3_config.jsonnet --ext-code config="$extCode" > /config/.deploy