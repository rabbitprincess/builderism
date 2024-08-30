#!/bin/bash
set -eu

echo "[5/5] : export genesis files"

cd ~/optimism/op-node
./bin/op-node genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT/.deploy \
  --l1-deployments ../packages/contracts-bedrock/deployments/$L1_CHAIN_ID-deploy.json \
  --outfile.l2 /config/genesis.json \
  --outfile.rollup /config/rollup.json \
  --l1-rpc $L1_RPC_URL \
  --l2-allocs ../packages/contracts-bedrock/state-dump-$DEPLOYMENT_CONTEXT-granite.json

cp ../packages/contracts-bedrock/deployments/$L1_CHAIN_ID-deploy.json /config/deploy.json

echo "[all process is done! check config files.]"
