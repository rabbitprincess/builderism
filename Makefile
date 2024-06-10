.PHONY: init run scan bridge buildx buildx-init buildx-run buildx-bridge

ifeq ($(OS),Windows_NT)
    cp_env = @powershell -Command "Copy-Item -Path '..\\.env.example' -Destination '.env' -ErrorAction Ignore"
else
    cp_env = cp -n ../.env.example .env
endif

init:
	cd init && @$(cp_env) && \
	docker compose -p builder_init up -d && \
	docker-compose down

run:
	cd run && @$(cp_env) && \
	docker compose -p builder_run up

scan:
	cd scan && @$(cp_env) && \
	docker compose -p builder_scan up

bridge:
	git submodule update --init --recursive && \
	cd bridge && @$(cp_env) && \
	docker compose -p builder_bridge up

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

