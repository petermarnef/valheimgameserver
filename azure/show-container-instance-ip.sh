#!/bin/bash

source config.sh

az container show --name $DOCKER_CONTAINER --resource-group $RESOURCE_GROUP | grep ip\":