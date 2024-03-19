FROM ubuntu as init

ENV OP_VERSION=v1.7.1
ENV GETH_VERSION=v1.101308.2

# install dependencies
RUN apt-get update && \
    apt-get install -y sudo jq wget curl gnupg git make direnv ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    curl -sL https://golang.org/dl/go1.22.1.linux-amd64.tar.gz | tar -C /usr/local -xzf - && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    curl -fsSL https://get.pnpm.io/install.sh | sh - && \
    curl -L https://foundry.paradigm.xyz | bash && foundryup

# init repo
RUN cd ~/ && \
    git clone https://github.com/ethereum-optimism/optimism.git && \
    cd ~/optimism && \
    git switch op-node/$OP_VERSION && \
    pnpm install && \
    make op-node op-batcher op-proposer && \
    pnpm build && \
    ./packages/contracts-bedrock/scripts/getting-started/wallets.sh

# export addresses
# TODO : .env 파일을 복사해서, 주소가 있으면 해당 주소 사용
# COPY .env /app/.env
# direnv를 사용하여 .env 파일을 환경 변수로 등록하는 스크립트 실행
# RUN echo 'eval "$(direnv hook bash)"' >> /root/.bashrc \
#    && echo 'source /app/.env' >> /root/.bashrc

RUN echo "Init Environment Variables" && \
    cp .envrc.example .envrc \
    && output=$(./packages/contracts-bedrock/scripts/getting-started/wallets.sh) \
    && sed -i \
        -e 's/^export GS_ADMIN_ADDRESS=.*/export GS_ADMIN_ADDRESS='"$(echo "$output" | grep "GS_ADMIN_ADDRESS" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_ADMIN_PRIVATE_KEY=.*/export GS_ADMIN_PRIVATE_KEY='"$(echo "$output" | grep "GS_ADMIN_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_BATCHER_ADDRESS=.*/export GS_BATCHER_ADDRESS='"$(echo "$output" | grep "GS_BATCHER_ADDRESS" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_BATCHER_PRIVATE_KEY=.*/export GS_BATCHER_PRIVATE_KEY='"$(echo "$output" | grep "GS_BATCHER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_PROPOSER_ADDRESS=.*/export GS_PROPOSER_ADDRESS='"$(echo "$output" | grep "GS_PROPOSER_ADDRESS" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_PROPOSER_PRIVATE_KEY=.*/export GS_PROPOSER_PRIVATE_KEY='"$(echo "$output" | grep "GS_PROPOSER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_SEQUENCER_ADDRESS=.*/export GS_SEQUENCER_ADDRESS='"$(echo "$output" | grep "GS_SEQUENCER_ADDRESS" | cut -d'=' -f2-)"'/' \
        -e 's/^export GS_SEQUENCER_PRIVATE_KEY=.*/export GS_SEQUENCER_PRIVATE_KEY='"$(echo "$output" | grep "GS_SEQUENCER_PRIVATE_KEY" | cut -d'=' -f2-)"'/' \
        -e '/^export L1_RPC_URL=/s@^export L1_RPC_URL=.*@export L1_RPC_URL=http://localhost:3000@' \
        -e '/^export L1_RPC_KIND=/s@^export L1_RPC_KIND=.*@export L1_RPC_KIND=any@' \
    .envrc \
    && direnv allow && \
    eval "$(direnv hook bash)"

# check balance and send from $private key
# admin : 0.5 eth / proposer : 0.2 eth / batcher : 0.1 eth
RUN echo "Check Balance and Faucet" && \
    echo "Admin:$GS_ADMIN_ADDRESS | Batcher:$GS_BATCHER_ADDRESS | Proposer:$GS_PROPOSER_ADDRESS | Sequencer:$GS_SEQUENCER_ADDRESS" && \
    ./faucet.sh $GS_PRIVATE_KEY $GS_ADMIN_ADDRESS 0.5 && \
    ./faucet.sh $GS_PRIVATE_KEY $GS_PROPOSER_ADDRESS 0.2 && \
    ./faucet.sh $GS_PRIVATE_KEY $GS_BATCHER_ADDRESS 0.1
    

# deploy L1 contracts
RUN echo "Deploying L1 Contracts" && echo "Admin:$GS_ADMIN_ADDRESS | Batcher:$GS_BATCHER_ADDRESS | Proposer:$GS_PROPOSER_ADDRESS | Sequencer:$GS_SEQUENCER_ADDRESS" && \
    cd ~/optimism/packages/contracts-bedrock && \
    forge script scripts/Deploy.s.sol:Deploy --private-key $GS_ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL --slow

# generate and export L2 config files - genesis.json / rollup.json / addresses for sdk
RUN go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deploy-config/getting-started.json \
  --deployment-dir ../packages/contracts-bedrock/deployments/getting-started/ \
  --outfile.l2 genesis.json \
  --outfile.rollup rollup.json \
  --l1-rpc $L1_RPC_URL
