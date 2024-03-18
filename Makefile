mainnet:
	docker compose -f docker-compose.mainnet.yml up

testnet-sequencer:
	docker compose -f docker-compose.sepolia-sequencer.yml up

testnet-node:
	docker compose -f docker-compose.sepolia-node.yml up

# scan:


clean:
	rm -r ./geth-data/*
