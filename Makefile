init:
	cd node_init && \
	docker compose up -d && \
	docker-compose down --rmi all

run:
	cd node_run && \
	docker compose up

# bridge:

# blockscout:

clean: # caution!! it remove all existing data
	rm -r ./geth-data/* && \
	rm -r ./config/sepolia/* && \
	Erm -r ./config/mainnet/*
