.PHONY: buildx init run scan

buildx:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/optimism_builder_init:0.0.1 --push ./init && \
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/optimism_builder_run:0.0.1 --push ./run

init:
	cp -n .env.example ./init/.env && \
	cd init && \
	docker compose -p builder_init up -d && \
	docker-compose down

run:
	cp -n .env.example ./run/.env && \
	cd run && \
	docker compose -p builder_run up

scan:
	git submodule update --init --recursive && \
	cd blockscout/docker-compose && \
	DOCKER_REPO=blockscout docker compose -f geth.yml up
