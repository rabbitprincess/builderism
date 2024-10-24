FROM golang:1.23 AS op

WORKDIR /app

ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-v1.9.4}

RUN git clone $OP_REPO --depth 1 --branch op-node/$OP_VERSION --single-branch . && \
    git switch -c branch-$OP_VERSION && \
    make -C op-node VERSION=$OP_VERSION op-node && \
    make -C op-batcher VERSION=$OP_VERSION op-batcher && \
    make -C op-proposer VERSION=$OP_VERSION op-proposer

FROM golang:1.22 AS geth

WORKDIR /app

ENV GETH_REPO=https://github.com/ethereum-optimism/op-geth.git
ENV GETH_VERSION=${GETH_VERSION:-v1.101411.0}

RUN git clone $GETH_REPO --depth 1 --branch $GETH_VERSION --single-branch . && \
    git switch -c branch-$GETH_VERSION && \
    make geth

FROM debian

COPY *-entrypoint.sh /script/
RUN chmod +x /script/*.sh

WORKDIR /app

RUN apt-get update && \
    apt-get install -y sudo jq curl wget lz4 && \
    rm -rf /var/lib/apt/lists

COPY --from=op /app/op-node/bin/op-node ./
COPY --from=op /app/op-batcher/bin/op-batcher ./
COPY --from=op /app/op-proposer/bin/op-proposer ./
COPY --from=geth /app/build/bin/geth ./