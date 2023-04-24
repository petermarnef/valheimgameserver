#!/bin/bash

source config.sh

docker run --name localvalheim -d -i -t $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG /bin/sh

docker exec -it localvalheim /bin/bash

#docker run -it -p 2456-2458:2456-2458/tcp -p 2456-2458:2456-2458/udp --rm $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG