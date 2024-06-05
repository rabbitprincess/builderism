.PHONY: init run scan bridge buildx buildx-init buildx-run buildx-bridge

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

bridge:
	git submodule update --init --recursive && \
	cp -n .env.example ./bridge/.env && \
	cd op-stack-bridge && \
	yarn && yarn start

# buildx command
buildx: buildx-init && buildx-run && buildx-bridge

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/optimism_builder_init:1.7.3 \
	-t dreamcacao/optimism_builder_init:latest \
	--push ./init

buildx-run:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/optimism_builder_run:1.7.6 \
	-t dreamcacao/optimism_builder_run:latest \
	--push ./run

buildx-bridge:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/optimism_builder_bridge:0.0.0 \
	-t dreamcacao/optimism_builder_bridge:latest \
	--push ./bridge

