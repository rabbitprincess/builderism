#!/bin/bash
set -eu

echo "[4/5] : deploy contract"

cd ~/optimism/packages/contracts-bedrock && \
forge script scripts/Deploy.s.sol:Deploy \
    --private-key $ADMIN_PRIVATE_KEY \
    --broadcast \
    --rpc-url $L1_RPC_URL \
    --priority-gas-price $PRIORITY_GAS_PRICE \
    --slow