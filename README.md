# Valheim Game Server in Docker on Azure (WIP)

## To do

- [ ] Automate backup every night
- [ ] Make the Azure setup part run in a Docker container so the only dependency on the host is Docker
- [ ] Update Readme(s) (+ creds to other projects linuxgsm dockerfile + steam install part)
- [ ] Cleanup the vhserver / docker part of the project
- [ ] Create a one button push setup (create vhserver docker container + azure setup)

Nice to have:

- [ ] Automate linuxgsm and valheimserver updates (and do a backup right before)
- [ ] Make this project game server generic (put the game that linuxgsm needs to install in config)

## How to test locally

Build container from scratch and connect with the Valheim client locally

1. Build docker container by running script `build-docker-image.sh` (do not forget to update the version number)
2. Run docker container by running script  `run-local-deamon.sh`
3. Connect to local IP from Valheim

## How to deploy to azure

See `README.md` in `azure` folder

## Documentation

### LinuxGSM

https://linuxgsm.com/lgsm/vhserver/
https://github.com/GameServerManagers/LinuxGSM/blob/master/README.md
https://github.com/GameServerManagers/LinuxGSM-Docker
https://github.com/GameServerManagers/LinuxGSM/blob/master/lgsm/config-default/config-lgsm/vhserver/_default.cfg

### Valheim server check
https://geekstrom.de/valheim/check/

### Other Docker builds

https://github.com/lloesche/valheim-server-docker/blob/main/Dockerfile
https://github.com/mbround18/valheim-docker

### File share in container instance

https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files

## Past issues

### Created files during Docker build were not saved

https://stackoverflow.com/questions/47574755/docker-created-files-disappear-between-layers

### Issues with Docker not building correctly?

Try running `docker system prune`, and building again afterwards
