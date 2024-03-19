#!/bin/bash
set -eu

L1_RPC_URL="$L1_RPC_URL"
env_file=".env"

cd ~/optimism/op-node
go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deploy-config/getting-started.json \
  --deployment-dir ../packages/contracts-bedrock/deployments/getting-started/ \
  --outfile.l2 ./genesis.json \
  --outfile.rollup ./rollup.json \
  --l1-rpc $L1_RPC_URL

cd ~/optimism/packages/contracts-bedrock
addresses=$(./scripts/print-addresses.sh getting-started --sdk)
echo "$addresses" >> "$env_file" # 파싱 필요
echo "Addresses added to $env_file"