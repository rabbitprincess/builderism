#!/bin/bash
set -eu

echo "[4/5] : deploy contract"

cd ~/optimism/packages/contracts-bedrock && \
DEPLOY_CONFIG_PATH="./deploy-config/$DEPLOYMENT_CONTEXT.json" \
forge script scripts/Deploy.s.sol:Deploy \
  --private-key $ADMIN_PRIVATE_KEY \
  --broadcast \
  --rpc-url $L1_RPC_URL \
  --priority-gas-price $PRIORITY_GAS_PRICE \
  --slow

CONTRACT_ADDRESSES_PATH="./deployments/$DEPLOYMENT_CONTEXT/deploy.json" \
DEPLOY_CONFIG_PATH="./deploy-config/$DEPLOYMENT_CONTEXT.json" \
forge script scripts/L2Genesis.s.sol:L2Genesis \
  --sig 'runWithAllUpgrades()' \
  --rpc-url $L1_RPC_URL

mv ./state-dump-$DEPLOYMENT_CONTEXT.json ./deployments
mv ./state-dump-$DEPLOYMENT_CONTEXT-delta.json ./deployments
mv ./state-dump-$DEPLOYMENT_CONTEXT-ecotone.json ./deployments