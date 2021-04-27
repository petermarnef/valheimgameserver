#!/bin/bash

source config.sh

az container exec --resource-group $RESOURCE_GROUP --name $DOCKER_CONTAINER --exec-command bash