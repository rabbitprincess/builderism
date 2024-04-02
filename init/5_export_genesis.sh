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
l2ooAddress=$(cat ./deployments/$NETWORK_TYPE/L2OutputOracleProxy.json | jq -r .address)
echo "L2OO_ADDRESS=$l2ooAddress" >> "$env_file"

addresses=$(./scripts/print-addresses.sh $NETWORK_TYPE --sdk)
parsed_addresses=""
while read -r line; do
    key=$(echo "$line" | cut -d':' -f1)
    value=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
    parsed_addresses="$parsed_addresses$key=$value"$'\n'
done <<< "$addresses"
echo "$parsed_addresses" >> "$env_file"

echo "[all done!]"