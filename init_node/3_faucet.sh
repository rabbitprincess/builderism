#!/bin/bash
set -eu

# .env
FAUCET_PRIVATE_KEY="$FAUCET_PRIVATE_KEY"
FAUCET_ADDRESS="$FAUCET_ADDRESS"
L1_RPC_URL="$L1_RPC_URL"

# parameter
receiver_address="$1"
amount_eth="$2"

# convert eth to wei
amount_to_send=$(echo "scale=0; $amount_eth * 1000000000000000000" | bc)

# if sender have less eth than amount to send, error
sender_balance=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'"$FAUCET_ADDRESS"'", "latest"],"id":1}' -H "Content-Type: application/json" | jq -r .result)
if [ $sender_balance -gt $amount_to_send ]; then
  echo "$FAUCET_ADDRESS does not have enough balance"
  exit 1
fi

# if receiver have more eth than amount to send, return
receiver_balance=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'"$sender_address"'", "latest"],"id":1}' -H "Content-Type: application/json" | jq -r .result)
if [ $receiver_balance -lt $amount_to_send ]; then
  echo "$receiver_address already has enough balance"
else 
  # send eth
  nonce=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["'"$sender_address"'", "latest"],"id":1}' -H "Content-Type: application/json" | jq -r .result)
  gas_price=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":2}' -H "Content-Type: application/json" | jq -r .result)
  tip="5000000000" 
  max_priority_fee_per_gas="5000000000"
  max_fee_per_gas=$((gas_price + tip))

  raw_tx='{"nonce":"0x'$nonce'","maxPriorityFeePerGas":"0x'$max_priority_fee_per_gas'","maxFeePerGas":"0x'$max_fee_per_gas'","gas":"0x5208","to":"'"$receiver_address"'","value":"'$amount_to_send'000000000000000000"}'
  signed_tx=$(echo "$raw_tx" | jq -r '.nonce="0x'+$nonce+'"' | jq -R . | jq -r '. | @base64' | xargs echo -n | base64 --decode | ethsign -p $sender_private_key)
  tx_hash=$(echo '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["'"$signed_tx"'"],"id":1}' | curl -s -X POST -H "Content-Type: application/json" -d @- $L1_RPC_URL | jq -r .result)
  echo "send $amount_to_send to $receiver_address | Transaction Hash: $tx_hash"
fi
