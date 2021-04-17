#!/bin/bash

source config.sh

echo "Login to Container Registry $CONTAINER_REGISTRY"
az acr login --name $CONTAINER_REGISTRY

echo "Tagging image with fully qualified domain name of the registry $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG"
docker tag $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG

echo "Pushing image to the container registry $CONTAINER_REGISTRY.azurecr.io"
docker push $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG

echo "Removing image from local repository $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG"
docker rmi $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG
