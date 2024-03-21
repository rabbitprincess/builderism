FROM ubuntu

WORKDIR /app

COPY ${CONFIG_DIR} ./config

RUN if [ ! -f ./config/genesis.json ] || \
    [ ! -f ./config/rollup.json ] || \
    [ ! -f ./config/.env.address ]; then \
    echo "Error: genesis file is not set. initialize the node first!" \
    exit -1; \
fi

FROM golang:1.22 as op

WORKDIR /app

ENV OP_REPO=https://github.com/ethereum-optimism/optimism.git
ENV OP_VERSION=${OP_VERSION:-1.7.1}

RUN git clone $OP_REPO --branch op-node/$OP_VERSION --single-branch . && \
    git switch -c branch-$OP_VERSION

RUN make -C op-node VERSION=$OP_VERSION op-node
RUN make -C op-batcher VERSION=$OP_VERSION op-batcher
RUN make -C op-proposer VERSION=$OP_VERSION op-proposer

FROM golang:1.22 as geth

WORKDIR /app

ENV GETH_REPO=https://github.com/ethereum-optimism/op-geth.git
ENV GETH_VERSION=${GETH_VERSION:-v1.101308.2}

RUN git clone $GETH_REPO --branch $GETH_VERSION --single-branch . && \
    git switch -c branch-$GETH_VERSION

RUN go run build/ci.go install -static ./cmd/geth

FROM golang:1.22

RUN apt-get update && \
    apt-get install -y sudo jq curl && \
    rm -rf /var/lib/apt/lists

WORKDIR /app

COPY --from=op /app/op-node/bin/op-node ./
COPY --from=op /app/op-batcher/bin/op-batcher ./
COPY --from=op /app/op-proposer/bin/op-proposer ./
COPY --from=geth /app/build/bin/geth ./