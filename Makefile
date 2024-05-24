VERSION := 2024.3.0

.PHONY: all
all: docker-build

.PHONY: build
docker-build:
	docker --log-level=debug buildx build . \
		--file Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/amd64,linux/arm64,linux/arm/v7

.PHONY: release
docker-release:
	docker --log-level=debug buildx build . \
		--file Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/amd64,linux/arm64,linux/arm/v7 \
		--tag ghcr.io/radziejewicz/cloudflared:$(VERSION) \
		--tag ghcr.io/radziejewicz/cloudflared:latest \
		--tag radziejewicz/cloudflared:$(VERSION) \
		--tag radziejewicz/cloudflared:latest \
		--push