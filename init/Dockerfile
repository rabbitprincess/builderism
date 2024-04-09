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
ENV FOUNDRY_VERSION=${FOUNDRY_VERSION:-nightly-de33b6af53005037b463318d2628b5cfcaf39916}
RUN curl -L https://foundry.paradigm.xyz | sudo -E bash -
RUN . ~/.bashrc && foundryup -v "$FOUNDRY_VERSION"
ENV PATH="~/.foundry/bin:${PATH}"

# clone optimism repository
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-tutorials/chain}
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone --depth 1 $OP_REPO --branch $OP_VERSION --single-branch . && \
    git switch $OP_VERSION && \
    git submodule update --init --recursive --depth 1 && \
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