#!/bin/bash
set -eu

# check environment variables
reqenv() {
    if [ -z "${!1:-}" ]; then
        echo "Error: environment variable '$1' is not set. check .env file!"
        exit 1
    fi
}
reqenv "L1_RPC_URL"
reqenv "L1_RPC_KIND"
reqenv "L1_CHAIN_ID"
reqenv "L2_CHAIN_ID"
reqenv "L2_CHAIN_NAME"
reqenv "FAUCET_PRIVATE_KEY"
reqenv "FAUCET_ADDRESS"

echo "[1/5] : init environment variables"

export IMPL_SALT=$(openssl rand -hex 32)
export DEPLOYMENT_CONTEXT=$L2_CHAIN_NAME
export TENDERLY_PROJECT=""
export TENDERLY_USERNAME=""
export ETHERSCAN_API_KEY=""
export PRIVATE_KEY=""

# generate l1 manager addresses
if [ -z "${GS_ADMIN_ADDRESS:-}" ]; then
    wallet=$(cast wallet new)
    export GS_ADMIN_ADDRESS=$(echo "$wallet" | awk '/Address/ { print $2 }')
    export GS_ADMIN_PRIVATE_KEY=$(echo "$wallet" | awk '/Private key/ { print $3 }')
fi
if [ -z "${GS_BATCHER_ADDRESS:-}" ]; then
    wallet=$(cast wallet new)
    export GS_BATCHER_ADDRESS=$(echo "$wallet" | awk '/Address/ { print $2 }')
    export GS_BATCHER_PRIVATE_KEY=$(echo "$wallet" | awk '/Private key/ { print $3 }')
fi
if [ -z "${GS_PROPOSER_ADDRESS:-}" ]; then
    wallet=$(cast wallet new)
    export GS_PROPOSER_ADDRESS=$(echo "$wallet" | awk '/Address/ { print $2 }')
    export GS_PROPOSER_PRIVATE_KEY=$(echo "$wallet" | awk '/Private key/ { print $3 }')
fi
if [ -z "${GS_SEQUENCER_ADDRESS:-}" ]; then
    wallet=$(cast wallet new)
    export GS_SEQUENCER_ADDRESS=$(echo "$wallet" | awk '/Address/ { print $2 }')
    export GS_SEQUENCER_PRIVATE_KEY=$(echo "$wallet" | awk '/Private key/ { print $3 }')
fi

# save to file ( address.ini )
sudo mkdir -p /config
env_file="/config/address.ini"
if [ -f "$env_file" ]; then
    sudo rm "$env_file"
fi
sudo tee "$env_file" > /dev/null <<EOF
# Admin account
GS_ADMIN_ADDRESS=$GS_ADMIN_ADDRESS
GS_ADMIN_PRIVATE_KEY=$GS_ADMIN_PRIVATE_KEY

# Batcher account
GS_BATCHER_ADDRESS=$GS_BATCHER_ADDRESS
GS_BATCHER_PRIVATE_KEY=$GS_BATCHER_PRIVATE_KEY

# Proposer account
GS_PROPOSER_ADDRESS=$GS_PROPOSER_ADDRESS
GS_PROPOSER_PRIVATE_KEY=$GS_PROPOSER_PRIVATE_KEY

# Sequencer account
GS_SEQUENCER_ADDRESS=$GS_SEQUENCER_ADDRESS
GS_SEQUENCER_PRIVATE_KEY=$GS_SEQUENCER_PRIVATE_KEY
EOF