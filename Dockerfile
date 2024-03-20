FROM golang:1.21 as op

WORKDIR /app

ENV REPO=https://github.com/ethereum-optimism/optimism.git
ENV VERSION=v1.7.1
ENV NETWORK_TYPE=${NETWORK_TYPE}

RUN git clone $REPO --branch op-node/$VERSION --single-branch . && \
    git switch -c branch-$VERSION

RUN make -C op-node VERSION=$VERSION op-node
RUN make -C op-batcher VERSION=$VERSION op-batcher
RUN make -C op-proposer VERSION=$VERSION op-proposer

FROM golang:1.21 as geth

WORKDIR /app

ENV REPO=https://github.com/ethereum-optimism/op-geth.git
ENV VERSION=v1.101308.2

RUN git clone $REPO --branch $VERSION --single-branch . && \
    git switch -c branch-$VERSION

RUN go run build/ci.go install -static ./cmd/geth

FROM golang:1.21

RUN apt-get update && \
    apt-get install -y sudo jq curl && \
    rm -rf /var/lib/apt/lists

WORKDIR /app

COPY --from=op /app/op-node/bin/op-node ./
COPY --from=op /app/op-batcher/bin/op-batcher ./
COPY --from=op /app/op-proposer/bin/op-proposer ./
COPY --from=geth /app/build/bin/geth ./
COPY ./config/&{NETWORK_TYPE} ./config