#!/bin/bash

source config.sh

docker build . -t $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG