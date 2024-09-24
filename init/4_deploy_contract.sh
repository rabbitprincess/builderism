#!/bin/bash
set -eu

echo "[4/5] : deploy contract"

cd ~/optimism/packages/contracts-bedrock && \
DEPLOY_CONFIG_PATH="./deployments/$DEPLOYMENT_CONTEXT/.deploy" \
forge script scripts/deploy/Deploy.s.sol:Deploy \
  --private-key $ADMIN_PRIVATE_KEY \
  --broadcast \
  --rpc-url $L1_RPC_URL \
  --priority-gas-price $PRIORITY_GAS_PRICE

echo "[deploy contract done, start to deploy L2Genesis]"

CONTRACT_ADDRESSES_PATH="./deployments/$L1_CHAIN_ID-deploy.json" \
DEPLOY_CONFIG_PATH="./deployments/$DEPLOYMENT_CONTEXT/.deploy" \
FORK="granite" \
forge script scripts/L2Genesis.s.sol:L2Genesis \
  --sig 'runWithStateDump()' \
  --rpc-url $L1_RPC_URL
