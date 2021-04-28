# Run a Valheim game server in Azure

> Running a Valheim game server in Azure through an (almost) one-button-push deploy.

This repository contains scripts to:

1. Create a Docker container with a configured Valheim game server
2. Create the necessary infrastructure in Azure to run the container
3. Deploy the container to an Azure container instance

## Getting started

Steps to get the Valheim game server up-and-running in Azure:

### Pre-requisites

- Have Docker up and running on your local machine
  - [How-to install Docker](https://docs.docker.com/get-docker/)
- Install the Azure CLI and make sure your current terminal window is logged on before running the Azure setup scripts
  - [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - Login through `az login` - [more info here](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- Scripts are `.sh` files, so you are expected to be running a `bash` shell
- Have this repository cloned on your local machine

### Setting up the Valheim game server

1. **Configure the Valheim game server** - Set the `servername` and `serverpassword` parameters in the `vhserver.cfg` config file (the password needs to be at least 5 chars long, otherwise the server will not start)
2. **Configure the Container and Azure settings** - Set the parameters in the `config.sh` file, the most important parameter to change is the name of the `CONTAINER_REGISTRY`
3. **Run script** `bash ./docker/build-docker-image.sh` - this builds the docker container locally
4. **Run script** `bash ./azure/create-azure-infrastructure.sh` - this creates the necessary infrastructure in Azure
5. **Run script** `bash ./azure/push-and-run-docker-container.sh` - this deploys the container to an Azure container registry and boots it up in an Azure container instance

Run the scripts above in sequential order -and- from the root folder, wait until one script is done before running the next one.

### Playing the game

If all went well, you now have a Valheim game server up and running in Azure :party:

How to play:

1. Get the ip address of the container instance, you can do this by running script `bash ./azure/show-container-instance-ip.sh`
2. Edit the properties of Valheim in Steam and add the following in the `LAUNCH OPTIONS` field: `+connect <ip-address>:2456` (e.g. `+connect 51.138.124.34:2456`) - there is a way to have your game server show up in the Valheim server list, but apparently this is kinda buggy and I have not tried setting it up.
3. Start Valheim through Steam and provide the password you configured earlier in the `vhserver.cfg` file.

If the password is not accepted and you get a disconnect, something went wrong :-( You can start troubleshooting by seeing [if the server is online](#test-if-your-game-server-works) or [by connecting to the running container intance](#connecting-to-the-running-container-in-azure). If you want to see if the server is running, you can execute the following command `./vhserver details` on the server.

## LinuxGSM

The software that is used to manage the Valheim game server is called [LinuxGSM](https://linuxgsm.com/). It's a game server management system that supports [several different games](https://docs.linuxgsm.com/game-servers) and provides a lot of funtionality out of the box: server install, backup, monitor, update, etc. It's an open source project that is [available on Github](https://github.com/GameServerManagers/LinuxGSM) and it seems to work really well.

I also borrowed some code from [their own Docker implementation](https://github.com/GameServerManagers/LinuxGSM-Docker).

## Usefull stuff

### Connecting to the running container in Azure

You can connect to the docker container in Azure by running this script `bash ./azure/connect-with-container-in-azure.sh`.

### Test if your game server works

You can use this website to check if your Valheim game server works correctly: https://geekstrom.de/valheim/check/

### Running the Valheim game server locally

1. Go through steps 1-4 above
2. Run the docker container by running this script `bash ./docker/run-local-interactive.sh`
3. Make Steam connect on the IP of your local machine

### Cleaning up in Azure

You can throw away everything that was created in Azure by running this script `bash ./azure/cleanup_azure.sh` - this will remove the entire resource group AND your Valheim game world, so be careful when running this command (see the section below `Backup up the game world locally` to avoid losing any progress).

## Backup

The backup procedure is not yet automated, at this moment you need to launch the backup process manually. You can do this by following these steps:

1. [Connect to the running container in Azure](#connecting-to-the-running-container-in-azure)
2. Run this command in the container `./vhserver backup`

### Backup up the game world locally

The backup is done to the storage account file share that was automatically created. If you go to the storage account and to `File shares` you will find a file share there that contains the backup files (`.tar.gz` files). You can download these files locally, and they contain a complete backup of the server

### Restoring the backup

With the `.tar.gz` backup file you can restore the entire server.

If you want you can even:

- Remove the entire Azure resource group
- Recreate it again from scratch
- Stop the game server
- Restore the backup file, by extracting the `.tar.gz` backup and overwriting the existing files, this is the command to extract the backup file `tar -xvf <backupfilename>.tar.gz -C /home/linuxgsm`

## Updating the Valheim game server or LinuxGSM

No automation has been setup, but it's pretty simple. Just follow the [instructions from LinuxGSM](https://docs.linuxgsm.com/commands/update).

Beware! Backup your game server first. Valheim is still a little buggy, and I had my game world destroyed after an update :-(

## Optimisations

If you would like to contribute, these are the optimisations I have in mind:

- [ ] Create a start/stop script to easily stop the Azure services and save on cost
- [ ] Automate the backups every night
- [ ] Make the Azure setup part run in a Docker container so the only dependency on the host is Docker and installing the Azure CLI is not needed anymore
- [ ] Create a real one button push setup (create vhserver docker container + azure setup)

Nice to have:

- [ ] Add error handling
- [ ] Automate linuxgsm and valheimserver updates (and do a backup right before)
- [ ] Make this project game server generic (put the game that linuxgsm needs to install in config)

## Other Docker Valheim setups

- https://github.com/lloesche/valheim-server-docker/blob/main/Dockerfile
- https://github.com/mbround18/valheim-docker

## A few issues I encountered

### Created files during Docker build were not saved

https://stackoverflow.com/questions/47574755/docker-created-files-disappear-between-layers

### Issues with Docker not building correctly

Try running `docker system prune`, and building again afterwards.

### When trying to run the Azure CLI stuff in the Azure CLI Docker container

I tried doing the Azure stuff through the [Docker Azure CLI Container](https://hub.docker.com/_/microsoft-azure-cli
), but there are two issues I need to work around:

1. Authentication to Azure for the Azure CLI 'az login` when running in the Docker container
2. How to push the local docker image from the Azure CLI Docker
