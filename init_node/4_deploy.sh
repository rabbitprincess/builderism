#!/bin/bash
set -eu

L1_RPC_URL="$L1_RPC_URL"

cd ~/optimism/packages/contracts-bedrock

forge script scripts/Deploy.s.sol:Deploy \
    --private-key "$GS_ADMIN_PRIVATE_KEY" \
    --broadcast \
    --rpc-url "$L1_RPC_URL" \
    --slow