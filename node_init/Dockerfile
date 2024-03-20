FROM ubuntu

# copy sh file to docker container
COPY *.sh ./

ENV OP_VERSION=v1.7.1
ENV FAUCET_PRIVATE_KEY=${FAUCET_PRIVATE_KEY}
ENV FAUCET_ADDRESS=${FAUCET_ADDRESS}
ENV L1_RPC_URL=${L1_RPC_URL}
ENV NETWORK_TYPE=${NETWORK_TYPE}

RUN echo "L1_RPC_URL: $L1_RPC_URL"

ENTRYPOINT ["sh", "-c", "\
    ./1_init_dependency.sh && \
    ./2_init_environment.sh && \
    ./3_faucet.sh $GS_ADMIN_ADDRESS 0.5 && \
    ./3_faucet.sh $GS_PROPOSER_ADDRESS 0.2 && \
    ./3_faucet.sh $GS_BATCHER_ADDRESS 0.1 && \
    ./4_deploy_contract.sh && \
    ./5_generate_config.sh && \
    ./6_export_genesis.sh \
"]