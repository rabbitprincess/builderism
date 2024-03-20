# init:


run-mainnet:
	docker compose -f docker-compose.mainnet.yml up

run-testnet-sequencer:
	docker compose -f docker-compose.sepolia-sequencer.yml up

run-testnet-node:
	docker compose -f docker-compose.sepolia-node.yml up

# scan:

clean: # caution!! it remove all data
	rm -r ./geth-data/* && rm -r ./config/sepolia && rm -r ./config/mainnet
