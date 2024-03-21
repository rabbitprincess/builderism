init:
	cd init && \
	docker compose up -d && \
	docker-compose down

run:
	cd run && \
	docker compose up

# bridge:

# blockscout:

clean: # caution!! it remove all existing data
	rm -r ./geth_data/* && \
	rm -r ./config/*