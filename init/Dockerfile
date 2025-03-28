FROM debian

WORKDIR /app


# init system dependencies
RUN apt-get -y update && apt-get install -y sudo jq wget curl gnupg git make bc ca-certificates build-essential && \
    sudo rm -rf /var/lib/apt/lists

ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=${GITHUB_TOKEN:-""}
ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:/root/.local/share/mise/bin:$PATH"
ENV MISE_DATA_DIR="/root/.local/share/mise"
ENV MISE_DIR="/root/.mise"
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-v1.12.2}

# clone optimism repository
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . && \
    git switch -c $OP_VERSION

# install op-deployer
RUN cd ~/optimism && curl https://mise.run | sh && \
    mise trust mise.toml && mise use -g foundry@1.0.0 && mise install && \
    git submodule update --init --recursive --depth 1

RUN cd ~/optimism/op-deployer && just build

COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["/bin/bash", "-c", \
    "chmod +x /script/*.sh && \
    source /script/1_init.sh && \
    /script/2_faucet.sh && \
    /script/3_deploy.sh"]