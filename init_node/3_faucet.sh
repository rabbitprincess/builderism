#!/bin/bash
set -eu

# .env
FAUCET_PRIVATE_KEY="$FAUCET_PRIVATE_KEY"
FAUCET_ADDRESS="$FAUCET_ADDRESS"

# parameter
receiver_address="$1"
amount_eth="$2"

# convert eth to wei
amount_to_send=$(echo "scale=0; $amount_eth * 1000000000000000000" | bc)

# if sender have less eth than amount to send, error
sender_balance=$(cast balance --address $FAUCET_ADDRESS --rpc-url $L1_RPC_URL)
if [ $sender_balance -gt $amount_to_send ]; then
  echo "$FAUCET_ADDRESS does not have enough balance"
  exit 1
fi

# if receiver have more eth than amount to send, return
receiver_balance=$(cast balance --address $receiver_address --rpc-url $L1_RPC_URL)
if [ $receiver_balance -lt $amount_to_send ]; then
  echo "$receiver_address already has enough balance"
else
  # send eth
  cast send --to $receiver_address --value $amount_to_send --from $FAUCET_ADDRESS --private-key $FAUCET_PRIVATE_KEY --rpc-url $L1_RPC_URL
fi
