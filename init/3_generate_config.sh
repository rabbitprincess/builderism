#!/bin/bash
set -eu

echo "[3/5] : generate config"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

base_address="0xff00000000000000000000000000000000000000"
BatchInboxAddress="${base_address%${base_address: -${#L2_CHAIN_ID}}}$L2_CHAIN_ID"

# basic config
config="{"
config+="ADMIN_ADDRESS: \"$ADMIN_ADDRESS\", "
config+="BATCHER_ADDRESS: \"$BATCHER_ADDRESS\", "
config+="SEQUENCER_ADDRESS: \"$SEQUENCER_ADDRESS\", "
config+="PROPOSER_ADDRESS: \"$PROPOSER_ADDRESS\", "
config+="TIMESTAMP: $timestamp, "
config+="l1StartingBlockTag: \"$blockhash\", "
config+="l1ChainID: $L1_CHAIN_ID, "
config+="l2ChainID: $L2_CHAIN_ID, "
config+="batchInboxAddress: \"$BatchInboxAddress\""

# Governance config
if [ -n "$GOVERNANCE_TOKEN_SYMBOL" ]; then
  config+=", "
  config+="enableGovernance: true, "
  config+="governanceTokenSymbol: \"$GOVERNANCE_TOKEN_SYMBOL\", "
  config+="governanceTokenName: \"$GOVERNANCE_TOKEN_SYMBOL\", "
  config+="governanceTokenOwner: \"$ADMIN_ADDRESS\""
fi

# Alt DA config
if [ -n "${ALT_DA_SERVER}" ]; then
  config+=", "
  config+="altDAServer: \"$ALT_DA_SERVER\", "
  config+="usePlasma: true, "
  config+="daCommitmentType: \"KeccakCommitment\", ",
  config+="daChallengeWindow: 16, ",
  config+="daResolveWindow: 16, ",
  config+="daBondSize: 1000000, ",
  config+="daResolverRefundPercentage: 0"
fi

config+="}"

# Generate the configuration using Jsonnet
cd ~/optimism/packages/contracts-bedrock && \
mkdir -p ./deployments/$DEPLOYMENT_CONTEXT && \
jsonnet /script/3_config.jsonnet --ext-code config="$config" > ./deployments/$DEPLOYMENT_CONTEXT/.deploy