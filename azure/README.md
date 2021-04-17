# Readme

Prerequisite: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

Execute scripts 1-3 manually.

Use `cleanup-azure.sh` script to remove the entire resource group from Azure.

Tried doing this stuff through the Docker Azure CLI Container, but two issues I need to work around:

1. Authentication to Azure for the Azure CLI 'az login` when running in the Docker container
2. How to push the local docker image from the Azure CLI Docker

## Azure CLI Docs

https://docs.microsoft.com/en-us/cli/azure/container