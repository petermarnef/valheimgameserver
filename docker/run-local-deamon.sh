#!/bin/bash

source config.sh

docker run -d -p 2456-2458:2456-2458/tcp -p 2456-2458:2456-2458/udp --rm $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG