FROM ubuntu

WORKDIR /app

ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-v1.7.1}

# init system dependencies
RUN apt-get update && apt-get install -y sudo jq wget curl gnupg git make ca-certificates && \
rm -rf /var/lib/apt/lists

# install go
RUN curl -sL https://golang.org/dl/go1.22.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# install node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN apt-get install -y nodejs

# install pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | sudo -E bash -
RUN . ~/.bashrc

# install foundryup
RUN curl -L https://foundry.paradigm.xyz | sudo -E bash -
RUN . ~/.bashrc && foundryup

# clone optimism repository
RUN cd ~/optimism && \
    git clone $OP_REPO --branch op-node/$OP_VERSION --single-branch . && \
    git switch -c branch-$OP_VERSION

COPY *.sh /script/

ENTRYPOINT ["sh", "-c", "\
    /script/1_init_environment.sh && \
    /script/2_faucet.sh $GS_ADMIN_ADDRESS 0.5 && \
    /script/2_faucet.sh $GS_PROPOSER_ADDRESS 0.2 && \
    /script/2_faucet.sh $GS_BATCHER_ADDRESS 0.1 && \
    /script/3_deploy_contract.sh && \
    /script/4_generate_config.sh && \
    /script/5_export_genesis.sh \
"]