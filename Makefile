.PHONY: init run scan bridge buildx buildx-init buildx-run buildx-bridge

cp_env :=
ifeq ($(OS),Windows_NT)
	cp_env := (if not exist .env copy ..\.env.example .env)
else
	cp_env := cp -n ../.env.example .env
endif

init:
	cd init && $(cp_env) && \
	docker compose -p builderism_init up && \
	docker-compose down

run:
	cd run && $(cp_env) && \
	docker compose -p builderism_run up

scan:
	cd scan && $(cp_env) && \
	docker compose -p builderism_scan up

bridge:
	git submodule update --init --recursive && \
	cd bridge && $(cp_env) && \
	docker compose -p builderism_bridge up

# buildx command
buildx: buildx-init buildx-run buildx-bridge

buildx-init:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_init:1.7.3 \
	-t dreamcacao/builderism_init:latest \
	--push ./init

buildx-run:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_run:1.7.6 \
	-t dreamcacao/builderism_run:latest \
	--push ./run

buildx-bridge:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t dreamcacao/builderism_bridge:0.0.0 \
	-t dreamcacao/builderism_bridge:latest \
	--push ./bridge

