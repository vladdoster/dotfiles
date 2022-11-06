# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set default shell
SHELL=/bin/bash -o pipefail

IMGNAME = kube-cross

# Represents the targeted Kubernetes version at the time the images
# are to be created e.g., 'v1.100.0'
#
# Note: There is no need to increment the patch version of this variable.
#       The reason for the inclusion of the patch version here is to satisfy
#       a SemVer regex on the IMAGE_VERSION.
#
# Example:
# - v1.100.0-go1.17-bullseye.0 satisfies SemVer regex, while:
# - v1.100-go1.17-bullseye.0 does not
OS_CODENAME ?= bullseye
REVISION ?= 0
TYPE ?= default
# Build args
REGISTRY=docker.io
IMGNAME=vdoster/dotfiles
IMAGE = $(REGISTRY)/$(IMGNAME)
TAG ?= $(shell git describe --tags --always --dirty)
export DOCKER_CLI_EXPERIMENTAL=enabled

PLATFORMS ?= linux/amd64 linux/arm32v5 linux/arm32v7 linux/arm64v8 linux/i386 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x
ARCHS = $(patsubst linux/%,%,$(PLATFORMS))

check-env:
ifndef REGISTRY
	$(error REGISTRY is undefined, please set to registry you want to push)
endif

# build with buildx
# https://github.com/docker/buildx/issues/59
.PHONY: container
container: check-env init-docker-buildx
	echo "Building $(IMGNAME) for the following platforms: $(PLATFORMS)"
	@for platform in $(PLATFORMS); do \
		echo "Starting build for $${platform} platform"; \
		docker buildx build \
			--file ./Dockerfile \
			--load \
			--platform $${platform} \
			--progress plain \
			--tag $(IMAGE)-$${platform##*/}:$(TAG) \
			--tag $(IMAGE)-$${platform##*/}:latest \
			.; \
	done

.PHONY: push
push: container
	echo "Pushing $(IMGNAME) tags"
	@for platform in $(PLATFORMS); do \
		echo "Pushing tags for $${platform} platform"; \
		docker push $(IMAGE)-$${platform##*/}:$(TAG); \
		docker push $(IMAGE)-$${platform##*/}:latest; \
	done

.PHONY: manifest
manifest: push
	docker manifest create --amend $(IMAGE):$(TAG) $(shell echo $(ARCHS) | sed -e "s~[^ ]*~$(IMAGE)\-&:$(TAG)~g")
	@for platform in $(ARCHS); do docker manifest annotate --arch "$${platform}" ${IMAGE}:${TAG} ${IMAGE}-$${platform}:${TAG}; done
	docker manifest push --purge $(IMAGE):$(TAG)

# enable buildx
.PHONY: init-docker-buildx
init-docker-buildx:
	./init-buildx.sh
