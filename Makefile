init:
	cd init && \
	docker compose up -d && \
	docker-compose down

run:
	cd run && \
	docker compose up

# bridge:

scan:
	git submodule update --init --recursive && \
	cd blockscout/docker-compose && \
	DOCKER_REPO=blockscout docker compose -f geth.yml up
