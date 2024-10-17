#!/bin/bash
set -eu

# Check environment variables
reqenv() {
    if [ -z "${!1:-}" ]; then
        echo "Error: environment variable '$1' is not set. check .env file!"
        exit 1
    fi
}
reqenv "CONFIG_DIR"
reqenv "L1_RPC_URL"
reqenv "L1_RPC_KIND"
reqenv "L1_BEACON_URL"
reqenv "L1_CHAIN_ID"
reqenv "L2_CHAIN_ID"

if [ -f /config/deploy.json ]; then
    OPTIMISM_PORTAL_PROXY=$(jq -r '.OptimismPortalProxy' /config/deploy.json)
    ADDRESS_MANAGER=$(jq -r '.AddressManager' /config/deploy.json)
    L1_CROSS_DOMAIN_MESSANGER_PROXY=$(jq -r '.L1CrossDomainMessengerProxy' /config/deploy.json)
    L1_STANDARD_BRIDGE_PROXY=$(jq -r '.L1StandardBridgeProxy' /config/deploy.json)
    L2_OUTPUT_ORACLE_PROXY=$(jq -r '.L2OutputOracleProxy' /config/deploy.json)
fi

rm -f /data/.env.local

sudo tee "/data/.env.local" > /dev/null <<EOF
NEXT_PUBLIC_L1_CHAIN_ID="$L1_CHAIN_ID"
NEXT_PUBLIC_L1_RPC_URL="$L1_RPC_URL"
NEXT_PUBLIC_L1_NAME="$L1_CHAIN_NAME"
NEXT_PUBLIC_L2_CHAIN_ID="$L2_CHAIN_ID"
NEXT_PUBLIC_L2_RPC_URL="$L2_RPC_URL"
NEXT_PUBLIC_L2_NAME="$L2_CHAIN_NAME"
NEXT_PUBLIC_OPTIMISM_PORTAL_ADDRESS="$OPTIMISM_PORTAL_PROXY"
NEXT_PUBLIC_L1_CROSS_DOMAIN_MESSENGER_ADDRESS="$L1_CROSS_DOMAIN_MESSANGER_PROXY"

# constants
NEXT_PUBLIC_L1_BLOCK_TIME="12"
NEXT_PUBLIC_L2_BLOCK_TIME="2"
NEXT_PUBLIC_BLOCKS_PER_PAGE="25"
NEXT_PUBLIC_TXS_PER_PAGE="50"
NEXT_PUBLIC_TXS_ENQUEUED_PER_PAGE="50"
NEXT_PUBLIC_EVENTS_PER_PAGE="25"

DATABASE_URL="file:/data/dev.db"
L1_RPC_WS="$L1_WS_URL"
L2_RPC_WS="$L2_WS_URL"
EOF