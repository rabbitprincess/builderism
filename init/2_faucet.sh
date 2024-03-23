#!/bin/bash
set -eu

# .env
FAUCET_PRIVATE_KEY="$FAUCET_PRIVATE_KEY"
FAUCET_ADDRESS="$FAUCET_ADDRESS"

echo "[2/5] : faucet eth to environment accounts"

send_eth() {
    receiver_address="$1"
    amount_to_eth="$2"
    amount_to_send=$(cast to-wei $amount_to_eth)

    # if receiver has more eth than amount to send, no need to send
    receiver_balance=$(cast balance --rpc-url "$L1_RPC_URL" "$receiver_address")
    if [ "$receiver_balance" -ge "$amount_to_send" ]; then
        echo "$receiver_address already has enough balance"
    else
        # if sender has less eth than amount to send, error
        sender_balance=$(cast balance --rpc-url "$L1_RPC_URL" "$FAUCET_ADDRESS")
        if [ "$sender_balance" -lt "$amount_to_send" ]; then
            echo "$FAUCET_ADDRESS does not have enough balance"
            exit 1
        fi

        # send eth
        cast send "$receiver_address" --value "$amount_to_send" --from "$FAUCET_ADDRESS" --private-key "$FAUCET_PRIVATE_KEY" --rpc-url "$L1_RPC_URL"
        echo "Sent $amount_to_eth eth to $receiver_address"
    fi
}

send_eth "$GS_ADMIN_ADDRESS" 0.5
send_eth "$GS_BATCHER_ADDRESS" 0.2
send_eth "$GS_PROPOSER_ADDRESS" 0.1