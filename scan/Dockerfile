FROM node:22-bullseye

RUN apt update && apt-get install -y sudo jq git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm

RUN curl -fsSL https://bun.sh/install | bash && \
    echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc && \
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc

ENV BUN_INSTALL=/root/.bun
ENV PATH=$BUN_INSTALL/bin:$PATH

WORKDIR /app

RUN git clone https://github.com/walnuthq/op-scan --branch main --single-branch && \
    cd op-scan && pnpm install