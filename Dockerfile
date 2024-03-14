FROM golang:1.21 as op

WORKDIR /app

ENV REPO=https://github.com/ethereum-optimism/optimism.git
ENV VERSION=v1.7.1

RUN git clone $REPO --branch op-node/$VERSION --single-branch . && \
    git switch -c branch-$VERSION

RUN make -C op-node VERSION=$VERSION op-node
RUN make -C op-batcher VERSION=$VERSION op-batcher
RUN make -C op-proposer VERSION=$VERSION op-proposer

FROM golang:1.21 as geth

WORKDIR /app

ENV REPO=https://github.com/ethereum-optimism/op-geth.git
ENV VERSION=v1.101308.2

# avoid depth=1, so the geth build can read tags
RUN git clone $REPO --branch $VERSION --single-branch . && \
    git switch -c branch-$VERSION

RUN go run build/ci.go install -static ./cmd/geth

FROM golang:1.21

RUN apt-get update && \
    apt-get install -y jq curl supervisor && \
    rm -rf /var/lib/apt/lists
RUN mkdir -p /var/log/supervisor

WORKDIR /app

COPY --from=op /app/op-node/bin/op-node ./
COPY --from=op /app/op-batcher/bin/op-batcher ./
COPY --from=op /app/op-proposer/bin/op-proposer ./
COPY --from=geth /app/build/bin/geth ./
COPY supervisord.conf ./
COPY ./config ./config


CMD ["/usr/bin/supervisord"]