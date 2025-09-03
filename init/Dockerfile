FROM nixos/nix:latest

ENV NIX_CONFIG="experimental-features = nix-command flakes"
ENV PATH="/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"

WORKDIR /app

# init system dependencies
RUN nix profile add \
    nixpkgs#go \
    nixpkgs#just \
    nixpkgs#gnumake \
    nixpkgs#procps \
    nixpkgs#bc \
    nixpkgs#xz \
    nixpkgs#foundry \
    nixpkgs#openssl

# install op-deployer
ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-op-deployer/v0.4.2}
RUN mkdir -p ~/optimism && cd ~/optimism && \
    git clone $OP_REPO --depth 1 --branch $OP_VERSION --single-branch . && \
    git switch -c $OP_VERSION && cd op-deployer && just build

COPY *.sh /script/
RUN chmod +x /script/*.sh

ENTRYPOINT ["bash", "-lc",  \
    ". /script/1_init.sh && \
    . /script/2_faucet.sh && \
    . /script/3_deploy.sh"]