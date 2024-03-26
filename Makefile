init:
	cp -n .env.example ./init/.env && \
	cd init && \
	docker compose up -d && \
	docker-compose down

run:
	cp -n .env.example ./run/.env && \
	cd run && \
	docker compose up

scan:
	git submodule update --init --recursive && \
	cd blockscout/docker-compose && \
	DOCKER_REPO=blockscout docker compose -f geth.yml up
