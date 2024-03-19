#!/bin/bash
set -eu

cd ~/optimism/packages/contracts-bedrock

forge script scripts/Deploy.s.sol:Deploy \
    --private-key "$GS_ADMIN_PRIVATE_KEY" \
    --broadcast \
    --rpc-url "$L1_RPC_URL" \
    --slow