.PHONY: init run scan bridge buildx buildx-init buildx-run buildx-bridge

ENV_FILE=common.env
DOCKER_COMPOSE=docker compose --env-file $(ENV_FILE)

init:
	$(DOCKER_COMPOSE) -f init/docker-compose.yml -p builderism_init up

run:
	$(DOCKER_COMPOSE) -f run/docker-compose.yml -p builderism_run up

run-erigon:
	$(DOCKER_COMPOSE) -f run/docker-compose.erigon.yml -p builderism_run up

scan:
	$(DOCKER_COMPOSE) -f scan/docker-compose.yml -p builderism_scan up

bridge:
	$(DOCKER_COMPOSE) -f bridge/docker-compose.yml -p builderism_bridge up

# buildx command
buildx: buildx-init buildx-run buildx-bridge

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_init:2.0.0 \
	-t dreamcacao/builderism_init:latest \
	 ./init

buildx-run:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_run:2.0.0 \
	-t dreamcacao/builderism_run:latest \
	--push ./run

buildx-bridge:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_bridge:0.0.0 \
	-t dreamcacao/builderism_bridge:latest \
	--push ./bridge

