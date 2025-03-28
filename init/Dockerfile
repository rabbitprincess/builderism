FROM debian

WORKDIR /app

# init system dependencies
RUN apt-get -y update && apt-get install -y sudo jq wget curl gnupg git make bc ca-certificates jsonnet build-essential && \
    sudo rm -rf /var/lib/apt/lists

# clone optimism repository
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-v1.12.2}
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . && \
    git switch -c $OP_VERSION 

# install dependencies
ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:/root/.local/share/mise/bin:$PATH"
ENV MISE_DATA_DIR="/root/.local/share/mise"
ENV MISE_DIR="/root/.mise"

RUN curl https://mise.run | sh && \
    cd ~/optimism && mise trust mise.toml && mise use -g foundry@1.0.0 && mise install

# install op-node
RUN cd ~/optimism && git submodule update --init --recursive --depth 1 && \
    go mod download && go mod tidy && \
    make -C op-node VERSION=$OP_VERSION op-node

COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["/bin/bash", "-c", \
    "chmod +x /script/*.sh && \
    source /script/1_init_environment.sh && \
    /script/2_faucet.sh && \
    /script/3_generate_config.sh && \
    /script/4_deploy_contract.sh && \
    /script/5_export_genesis.sh"]