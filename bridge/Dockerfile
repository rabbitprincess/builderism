FROM node:latest

WORKDIR /app

RUN apt-get update && apt-get install -y jq sudo

COPY ./op-stack-bridge/package.json ./
COPY ./op-stack-bridge/yarn.lock ./
RUN yarn install

COPY ./op-stack-bridge/ .
RUN yarn build