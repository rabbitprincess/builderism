FROM node:22-bullseye-slim

RUN apt update && apt install -y git \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# add pnpm
RUN npm install -g pnpm

# clone main branch of op-scan
RUN git clone git@github.com/walnuthq/op-scan --branch main --single-branch && \
    cd op-scan && pnpm install && pnpm build
