MAKEFLAGS += --silent
SHELL=/bin/bash -o pipefail

REGISTRY=docker.io
IMGNAME=vdoster/dotfiles
IMAGE = $(REGISTRY)/$(IMGNAME)
TAG ?= $(shell git describe --tags --always --dirty)
export DOCKER_CLI_EXPERIMENTAL=enabled

# PLATFORMS ?= linux/amd64 linux/arm32v5 linux/arm32v7 linux/arm64v8 linux/i386 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x
PLATFORMS ?= linux/amd64 linux/arm64
ARCHS = $(patsubst linux/%,%,$(PLATFORMS))

check-env:
ifndef REGISTRY
	$(error REGISTRY is undefined, please set to registry you want to push)
endif

init-docker-buildx:
	./init-buildx.sh

container: check-env init-docker-buildx
	echo "Building $(IMGNAME) for the following platforms: $(PLATFORMS)"
	@for platform in $(PLATFORMS); do \
		echo "Starting build for $${platform} platform"; \
		docker buildx build \
			--file ../Dockerfile \
			--load \
			--platform $${platform} \
			--progress plain \
			--tag $(IMAGE)-$${platform##*/}:$(TAG) \
			--tag $(IMAGE)-$${platform##*/}:latest \
			..; \
	done

push: container
	echo "Pushing $(IMGNAME) tags"
	@for platform in $(PLATFORMS); do \
		echo "Pushing tags for $${platform} platform"; \
		docker push $(IMAGE)-$${platform##*/}:$(TAG); \
		docker push $(IMAGE)-$${platform##*/}:latest; \
	done

manifest: push
	docker manifest create --amend $(IMAGE):$(TAG) $(shell echo $(ARCHS) | sed -e "s~[^ ]*~$(IMAGE)\-&:$(TAG)~g")
	@for platform in $(ARCHS); do docker manifest annotate --arch "$${platform}" ${IMAGE}:${TAG} ${IMAGE}-$${platform}:${TAG}; done
	docker manifest push --purge $(IMAGE):$(TAG)

.PHONY: check-env container init-docker-buildx manifest push
.SILENT: check-env container init-docker-buildx manifest push
