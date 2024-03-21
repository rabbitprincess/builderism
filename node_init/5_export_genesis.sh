#!/bin/bash
set -eu

env_file="/config/address.ini"

cd ~/optimism/op-node
go run cmd/main.go genesis l2 \
  --deploy-config /config/deploy-config.json \
  --deployment-dir /config \
  --outfile.l2 /config/genesis.json \
  --outfile.rollup /config/rollup.json \
  --l1-rpc $L1_RPC_URL

cd ~/optimism/packages/contracts-bedrock
addresses=$(./scripts/print-addresses.sh getting-started --sdk)
echo "$addresses" >> "$env_file" # 파싱 필요