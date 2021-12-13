DOCKER_REGISTRY=ghcr.io
DEV_TAG=0.0.0-dev
IMAGE_NAME=hollodotme/readis

build:
	docker pull mlocati/php-extension-installer
	docker build --pull -f ./.docker/Dockerfile -t "$(IMAGE_NAME)" --target=readis ./.docker
.PHONY: build

push: build
	docker tag "$(IMAGE_NAME)" "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(DEV_TAG)"
	docker push "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(DEV_TAG)"
.PHONY: push

