#!/bin/bash

source config.sh

echo "Creating Resource Group $RESOURCE_GROUP"
az group create \
    --name $RESOURCE_GROUP \
    --location $RESOURCE_GROUP_LOCATION

echo "Creating Container Registry $CONTAINER_REGISTRY"
az acr create \
    --resource-group $RESOURCE_GROUP \
    --name $CONTAINER_REGISTRY \
    --sku Standard \
    --admin-enabled
