FROM ubuntu

ENV OP_VERSION=v1.7.1

# 1. install dependencies
RUN echo "1. Init Dependency" && ./1_init_dependency.sh

# 2. export addresses
RUN echo "Init Environment Variables" && ./2_init_environment.sh

# 3. check balance and send from specific private key
# admin : 0.5 eth / proposer : 0.2 eth / batcher : 0.1 eth
RUN echo "Check Balance and Faucet" && \
    ./3_faucet.sh $GS_PRIVATE_KEY $GS_ADMIN_ADDRESS 0.5 && \
    ./3_faucet.sh $GS_PRIVATE_KEY $GS_PROPOSER_ADDRESS 0.2 && \
    ./3_faucet.sh $GS_PRIVATE_KEY $GS_BATCHER_ADDRESS 0.1

# 4. deploy L1 contracts
RUN echo "Deploying L1 Contracts" && echo "Admin:$GS_ADMIN_ADDRESS | Batcher:$GS_BATCHER_ADDRESS | Proposer:$GS_PROPOSER_ADDRESS | Sequencer:$GS_SEQUENCER_ADDRESS" && \
    cd ~/optimism/packages/contracts-bedrock && \
    forge script scripts/Deploy.s.sol:Deploy --private-key $GS_ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL --slow

# 5. generate and export L2 config files - genesis.json / rollup.json / addresses for sdk
RUN go run cmd/main.go genesis l2 \
  --deploy-config ../packages/contracts-bedrock/deploy-config/getting-started.json \
  --deployment-dir ../packages/contracts-bedrock/deployments/getting-started/ \
  --outfile.l2 genesis.json \
  --outfile.rollup rollup.json \
  --l1-rpc $L1_RPC_URL
