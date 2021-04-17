#!/bin/bash

source config.sh

echo "Creating Azure Container Instance $CONTAINER"
if [[ $CONTAINER_REGISTRY_PASSWORD -eq "" ]]
then
    echo "ERROR: Container Registry password not found. Copy/paste the admin password of the container registry '$CONTAINER_REGISTRY' to the CONTAINER_REGISTRY_PASSWORD environment variable in the config.sh file before executing this file. You can find the password in the section 'Access keys'. (If the password contains an escapable char, regenerate the pwd.)"
else
    az container create \
        -g $RESOURCE_GROUP \
        --name $DOCKER_CONTAINER \
        --image $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG \
        --ports 2456 2457 \
        --dns-name-label $DOCKER_CONTAINER \
        --image $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG \
        --registry-username $CONTAINER_REGISTRY \
        --registry-password $CONTAINER_REGISTRY_PASSWORD \
        --cpu 4 \
        --memory 2 \
        --protocol UDP
fi
