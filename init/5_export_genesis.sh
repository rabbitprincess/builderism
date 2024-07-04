#!/bin/bash
set -eu

echo "[5/5] : export genesis files"

cd ~/optimism/op-node
go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deploy-config/$DEPLOYMENT_CONTEXT.json \
  --l1-deployments ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT/.deploy \
  --outfile.l2 /config/genesis.json \
  --outfile.rollup /config/rollup.json \
  --l1-rpc $L1_RPC_URL \
  --l2-allocs ../packages/contracts-bedrock/deployments/state-dump-$DEPLOYMENT_CONTEXT.json

cp ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT/.deploy /config/.deploy

echo "[all process is done! check config files.]"
