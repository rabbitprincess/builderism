FROM debian

WORKDIR /app

# init system dependencies
RUN apt-get -y update && apt-get install -y sudo jq wget curl gnupg git make bc ca-certificates && \
    sudo rm -rf /var/lib/apt/lists

# install go
RUN curl -sL https://golang.org/dl/go1.22.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# install node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN apt-get install -y nodejs

# install pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | npm install -g pnpm

# install foundryup
RUN curl -L https://foundry.paradigm.xyz | sudo -E bash -
RUN . ~/.bashrc && foundryup
ENV PATH="~/.foundry/bin:${PATH}"

ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-tutorials/chain}

# clone optimism repository
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --branch $OP_VERSION --single-branch . && \
    git switch -c branch-$OP_VERSION && \
    git submodule update --init --recursive && \
    go mod download && go mod tidy

COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["/bin/bash", "-c", "\
    source /script/1_init_environment.sh && \
    /script/2_faucet.sh && \
    /script/3_generate_config.sh && \
    /script/4_deploy_contract.sh && \
    /script/5_export_genesis.sh \
"]