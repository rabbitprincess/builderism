mainnet:
	docker compose -f docker-compose.mainnet.yml up

testnet:
	docker compose -f docker-compose.sepolia.yml up

# scan:


clean:
	rm -r ./geth-data/*
