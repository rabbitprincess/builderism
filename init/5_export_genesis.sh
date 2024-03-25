#!/bin/bash
set -eu

echo "[5/5] : export genesis files"

env_file="/config/address.ini"

cd ~/optimism/op-node
go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deploy-config/$NETWORK_TYPE.json \
  --deployment-dir ../packages/contracts-bedrock/deployments/$NETWORK_TYPE/ \
  --outfile.l2 /config/genesis.json \
  --outfile.rollup /config/rollup.json \
  --l1-rpc $L1_RPC_URL

cd ~/optimism/packages/contracts-bedrock
addresses=$(./scripts/print-addresses.sh $NETWORK_TYPE --sdk)
echo "$addresses" >> "$env_file" # 파싱 필요

echo "[all done!]"