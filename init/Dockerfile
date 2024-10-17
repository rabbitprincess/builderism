FROM debian

WORKDIR /app

# init system dependencies
RUN apt-get -y update && apt-get install -y sudo jq wget curl gnupg git make bc ca-certificates jsonnet && \
    sudo rm -rf /var/lib/apt/lists

# install go
RUN curl -sL https://golang.org/dl/go1.23.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# install nodejs and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN apt-get install -y nodejs && npm install -g pnpm

# install foundry
ENV FOUNDRY_VERSION=${FOUNDRY_VERSION:-nightly-ef62fdbab638a275fc19a2ff8fe8951c3bd1d9aa}
RUN curl -L https://foundry.paradigm.xyz | sudo -E bash -
RUN . ~/.bashrc && foundryup -v "$FOUNDRY_VERSION"
ENV PATH="~/.foundry/bin:${PATH}"

# clone optimism repository
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-v1.9.1}
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . && \
    git switch -c $OP_VERSION && \
    git submodule update --init --recursive --depth 1 && \
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