FROM ubuntu AS builder

ENV OP_VERSION=v1.7.1
ENV FAUCET_PRIVATE_KEY=${FAUCET_PRIVATE_KEY}
ENV FAUCET_ADDRESS=${FAUCET_ADDRESS}
ENV L1_RPC_URL=${L1_RPC_URL}
ENV NETWORK_TYPE=${NETWORK_TYPE}

# 1. install dependencies
RUN echo "[1/5] Init Dependency" && ./1_init_dependency.sh

# 2. export addresses
RUN echo "[2/5] Init Environment Variables" && ./2_init_environment.sh

# 3. check balance and send from faucet key
# admin : 0.5 eth / proposer : 0.2 eth / batcher : 0.1 eth
RUN echo "[3/5] Send eth from faucet key" && \
    ./3_faucet.sh $GS_ADMIN_ADDRESS 0.5 && \
    ./3_faucet.sh $GS_PROPOSER_ADDRESS 0.2 && \
    ./3_faucet.sh $GS_BATCHER_ADDRESS 0.1

# 4. deploy L1 contracts
RUN echo "[4/5] Deploying L1 Contracts" && \
    ./4_deploy.sh

# 5. generate and export L2 config files
RUN echo "[5/5] Generate L2 Config files" && \
    ./5_export_config.sh

RUN echo "finish"

# copy config files - genesis.json / rollup.json / addresses for sdk

