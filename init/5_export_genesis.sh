#!/bin/bash
set -eu

echo "[5/5] : export genesis files"

cd ~/optimism/op-node
go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT.json \
  --l1-deployments ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT/deploy.json \
  --outfile.l2 /config/genesis.json \
  --outfile.rollup /config/rollup.json \
  --l1-rpc $L1_RPC_URL \
  --l2-allocs ../packages/contracts-bedrock/state-dump-$DEPLOYMENT_CONTEXT.json

cp ../packages/contracts-bedrock/deployments/$DEPLOYMENT_CONTEXT/deploy.json /config/deploy.json

echo "[all process is done! check config files.]"
