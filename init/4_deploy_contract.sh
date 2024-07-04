#!/bin/bash
set -eu

echo "[4/5] : deploy contract"

export DEPLOY_CONFIG_PATH="~/optimism/packages/contracts-bedrock/deploy-config/87655678.json"
export CONTRACT_ADDRESSES_PATH="~/optimism/packages/contracts-bedrock/deployments/$L1_CHAIN_ID-deploy.json"
export STATE_DUMP_PATH="~/optimism/packages/contracts-bedrock/deployments/"

cd ~/optimism/packages/contracts-bedrock && \
forge script scripts/Deploy.s.sol:Deploy \
  --private-key $ADMIN_PRIVATE_KEY \
  --broadcast \
  --rpc-url $L1_RPC_URL \
  --priority-gas-price $PRIORITY_GAS_PRICE \
  --slow && \
forge script scripts/L2Genesis.s.sol:L2Genesis \
  --sig 'runWithAllUpgrades()' \
  --rpc-url $L1_RPC_URL

# mv state-dump-$DEPLOYMENT_CONTEXT.json deployments/
# mv state-dump-$DEPLOYMENT_CONTEXT-delta.json deployments/
# mv state-dump-$DEPLOYMENT_CONTEXT-ecotone.json deployments/