init:
	cd node_init && \
	docker compose up -d && \
	docker rmi node_init

run-mainnet:
	cd ./node_run && \
	docker compose -f docker-compose.mainnet.yml up

run-testnet-sequencer:
	cd ./node_run && \
	docker compose -f docker-compose.sepolia-sequencer.yml up

run-testnet-node:
	cd ./node_run && \
	docker compose -f docker-compose.sepolia-node.yml up

# scan:

clean: # caution!! it remove all existing data
	rm -r ./geth-data/* && \
	rm -r ./config/sepolia && \
	Erm -r ./config/mainnet
