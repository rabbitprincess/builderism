#!/bin/bash
set -eu

L1_RPC_URL="$L1_RPC_URL"

cd ~/optimism
cp .envrc.example .envrc
output=$(./packages/contracts-bedrock/scripts/getting-started/wallets.sh) \ 
&& sed -i \
    -e 's/^export GS_ADMIN_ADDRESS=.*/export GS_ADMIN_ADDRESS='"$(echo "$output" | grep "GS_ADMIN_ADDRESS" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_ADMIN_PRIVATE_KEY=.*/export GS_ADMIN_PRIVATE_KEY='"$(echo "$output" | grep "GS_ADMIN_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_BATCHER_ADDRESS=.*/export GS_BATCHER_ADDRESS='"$(echo "$output" | grep "GS_BATCHER_ADDRESS" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_BATCHER_PRIVATE_KEY=.*/export GS_BATCHER_PRIVATE_KEY='"$(echo "$output" | grep "GS_BATCHER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_PROPOSER_ADDRESS=.*/export GS_PROPOSER_ADDRESS='"$(echo "$output" | grep "GS_PROPOSER_ADDRESS" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_PROPOSER_PRIVATE_KEY=.*/export GS_PROPOSER_PRIVATE_KEY='"$(echo "$output" | grep "GS_PROPOSER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_SEQUENCER_ADDRESS=.*/export GS_SEQUENCER_ADDRESS='"$(echo "$output" | grep "GS_SEQUENCER_ADDRESS" | cut -d'=' -f2-)"'/' \
    -e 's/^export GS_SEQUENCER_PRIVATE_KEY=.*/export GS_SEQUENCER_PRIVATE_KEY='"$(echo "$output" | grep "GS_SEQUENCER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
    -e 's/^export L1_RPC_URL=.*/export L1_RPC_URL='"$L1_RPC_URL"'/' \
    -e 's/^export L1_RPC_KIND=.*/export L1_RPC_KIND=any/' \
.envrc \
&& direnv allow && \
eval "$(direnv hook bash)"