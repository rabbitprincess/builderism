FROM node:22-bullseye

RUN apt update && apt install -y git jq \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# add pnpm
RUN npm install -g pnpm

WORKDIR /app

RUN git clone https://github.com/walnuthq/op-scan --branch main --single-branch && \
    cd op-scan && pnpm install