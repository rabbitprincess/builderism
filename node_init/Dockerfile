FROM ubuntu

# copy sh file to docker container
COPY *.sh ./

ENV OP_VERSION=v1.7.1
ENV FAUCET_PRIVATE_KEY=${FAUCET_PRIVATE_KEY}
ENV FAUCET_ADDRESS=${FAUCET_ADDRESS}
ENV L1_RPC_URL=${L1_RPC_URL}
ENV NETWORK_TYPE=${NETWORK_TYPE}

ENTRYPOINT ["sh", "-c", "\
    /script/1_init_dependency.sh && \
    /script/2_init_environment.sh && \
    /script/3_faucet.sh $GS_ADMIN_ADDRESS 0.5 && \
    /script/3_faucet.sh $GS_PROPOSER_ADDRESS 0.2 && \
    /script/3_faucet.sh $GS_BATCHER_ADDRESS 0.1 && \
    /script/4_deploy_contract.sh && \
    /script/5_generate_config.sh && \
    /script/6_export_genesis.sh \
"]