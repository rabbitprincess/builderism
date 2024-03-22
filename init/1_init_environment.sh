#!/bin/bash
set -eu

# Check environment variables
reqenv() {
    if [ -z "${!1:-}" ]; then
        echo "Error: environment variable '$1' is not set. check .env file!"
        exit 1
    fi
}
reqenv "L1_NETWORK_TYPE"
reqenv "L1_RPC_URL"
reqenv "L1_RPC_KIND"
reqenv "L1_CHAIN_ID"
reqenv "L2_CHAIN_ID"
reqenv "FAUCET_PRIVATE_KEY"
reqenv "FAUCET_ADDRESS"

output=$(./packages/contracts-bedrock/scripts/getting-started/wallets.sh) \
export GS_ADMIN_ADDRESS=$(echo "$output" | grep "GS_ADMIN_ADDRESS" | cut -d'=' -f2-) \
export GS_ADMIN_PRIVATE_KEY=$(echo "$output" | grep "GS_ADMIN_PRIVATE_KEY" | cut -d'=' -f2-) \
export GS_BATCHER_ADDRESS=$(echo "$output" | grep "GS_BATCHER_ADDRESS" | cut -d'=' -f2-) \
export GS_BATCHER_PRIVATE_KEY=$(echo "$output" | grep "GS_BATCHER_PRIVATE_KEY" | cut -d'=' -f2-) \
export GS_PROPOSER_ADDRESS=$(echo "$output" | grep "GS_PROPOSER_ADDRESS" | cut -d'=' -f2-) \
export GS_PROPOSER_PRIVATE_KEY=$(echo "$output" | grep "GS_PROPOSER_PRIVATE_KEY" | cut -d'=' -f2-) \
export GS_SEQUENCER_ADDRESS=$(echo "$output" | grep "GS_SEQUENCER_ADDRESS" | cut -d'=' -f2-) \
export GS_SEQUENCER_PRIVATE_KEY=$(echo "$output" | grep "GS_SEQUENCER_PRIVATE_KEY" | cut -d'=' -f2-) \
export DEPLOYMENT_CONTEXT=$L1_NETWORK_TYPE
