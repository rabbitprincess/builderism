FROM node:latest

WORKDIR /app

COPY ./op-stack-bridge/* /app/
RUN yarn install

COPY ./op-stack-bridge /app
RUN yarn build
