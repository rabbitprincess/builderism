FROM ubuntu:24.04

WORKDIR /app

# init system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common ca-certificates curl tar \
    && apt-get update

RUN apt-get -y update && apt-get install -y just sudo jq wget curl git make procps coreutils bc xz-utils && \
    sudo rm -rf /var/lib/apt/lists/*

# install go
RUN curl -sL https://golang.org/dl/go1.24.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="$PATH:/usr/local/go/bin"

# install foundry
ENV FOUNDRY_DIR=/root/.foundry
ENV PATH="${FOUNDRY_DIR}/bin:${PATH}"
RUN curl -fsSL https://foundry.paradigm.xyz | bash
RUN . "$HOME/.profile" && foundryup

# install op-deployer
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-op-deployer/v0.4.2}
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . && \
    git switch -c $OP_VERSION && cd op-deployer && just build
    
COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["/bin/bash", "-c", \
    "chmod +x /script/*.sh && \
    source /script/1_init.sh && \
    /script/2_faucet.sh && \
    /script/3_deploy.sh"]