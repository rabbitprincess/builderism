#!/bin/bash
set -eu

env_file=".env"

cd ~/optimism/op-node
# todo : set --deploy-config path / --deployment-dir path - mainnet or sepolia
go run cmd/main.go genesis l2 \
  --deploy-config ../$NETWORK_TYPE/deploy-config.json \ 
  --deployment-dir ../$NETWORK_TYPE \
  --outfile.l2 ./genesis.json \
  --outfile.rollup ./rollup.json \
  --l1-rpc $L1_RPC_URL

cd ~/optimism/packages/contracts-bedrock
addresses=$(./scripts/print-addresses.sh getting-started --sdk)
echo "$addresses" >> "$env_file" # 파싱 필요
echo "Addresses added to $env_file"