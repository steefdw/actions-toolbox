DOCKER_COMMAND = docker run -it --rm -v ./mise:/mise -v ./mise.toml:/mise.toml actions-tookbox

## Build the docker container
.PHONY: build
build:
	docker build -t actions-tookbox -f ./build/Dockerfile .
	@[ ! -f ./mise.toml ] && cp mise.toml.example mise.toml && echo 'created default mise.toml config file' || true
	${DOCKER_COMMAND} sh -c 'mise install'

## Run
run:
	${DOCKER_COMMAND} bash

## Generate a bootstrapped mise
bootstrap:
	${DOCKER_COMMAND} mise generate bootstrap -l -w && mv ./bin/mise ./mise/mise-bootstrapped
