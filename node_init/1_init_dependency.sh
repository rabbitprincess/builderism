#!/bin/bash
set -eu

OP_VERSION="$OP_VERSION"

# Install system dependencies
apt-get update && apt-get install -y sudo jq wget curl gnupg git make direnv ca-certificates && \
    rm -rf /var/lib/apt/lists

# Install Go
curl -sL https://golang.org/dl/go1.22.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs

# Install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Install Foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# Clone Optimism repository
cd ~/ && \
git clone https://github.com/ethereum-optimism/optimism.git && \
cd ~/optimism && \
git switch op-node/$OP_VERSION

# is it necessary?
# pnpm install && \
# make op-node op-batcher op-proposer && \
# pnpm build