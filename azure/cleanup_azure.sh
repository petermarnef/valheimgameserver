#!/bin/bash

source config.sh

echo "Removing resource group $RESOURCE_GROUP"
az group delete -n $RESOURCE_GROUP
