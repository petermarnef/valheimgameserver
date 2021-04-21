#!/bin/bash

source config.sh

echo "Creating Resource Group $RESOURCE_GROUP"
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

echo "Creating Container Registry $CONTAINER_REGISTRY"
az acr create \
    --resource-group $RESOURCE_GROUP \
    --name $CONTAINER_REGISTRY \
    --sku Standard \
    --admin-enabled


echo "Creating Storage Account $STORAGE_ACCOUNT"
az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT \
    --location $LOCATION \
    --sku Standard_LRS

echo "Create File Share $STORAGE_ACCOUNT_FILESHARE on Storage Account $STORAGE_ACCOUNT"
az storage share create \
  --name $STORAGE_ACCOUNT_FILESHARE \
  --account-name $STORAGE_ACCOUNT
