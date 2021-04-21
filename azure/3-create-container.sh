#!/bin/bash

source config.sh

CONTAINER_REGISTRY_KEY=$(
    az acr credential show \
    -n $CONTAINER_REGISTRY \
    --query "passwords[0].value" \
    --output tsv \
)

STORAGE_ACCOUNT_KEY=$(
    az storage account keys list \
    --resource-group $RESOURCE_GROUP \
    --account-name $STORAGE_ACCOUNT \
    --query "[0].value" \
    --output tsv \
)

az container create \
    -g $RESOURCE_GROUP \
    --name $DOCKER_CONTAINER \
    --image $DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG \
    --ports 2456 2457 \
    --dns-name-label $DOCKER_CONTAINER \
    --image $CONTAINER_REGISTRY.azurecr.io/$DOCKER_CONTAINER:$DOCKER_CONTAINER_TAG \
    --registry-username $CONTAINER_REGISTRY \
    --registry-password $CONTAINER_REGISTRY_KEY \
    --cpu 4 \
    --memory 2 \
    --protocol UDP \
    --azure-file-volume-account-name $STORAGE_ACCOUNT \
    --azure-file-volume-account-key $STORAGE_ACCOUNT_KEY \
    --azure-file-volume-share-name $STORAGE_ACCOUNT_FILESHARE \
    --azure-file-volume-mount-path $DOCKER_CONTAINER_FILESHARE_PATH
