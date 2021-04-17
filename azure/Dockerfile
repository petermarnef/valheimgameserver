# Dockerfile is WIP, can not be used due to azure login issues

FROM mcr.microsoft.com/azure-cli

ENV RESOURCE_GROUP=valheimgameserver
ENV RESOURCE_GROUP_LOCATION=westeurope

COPY create-azure-stuff.sh .
RUN chmod +x create-azure-stuff.sh

ENTRYPOINT [ "./create-azure-stuff.sh" ]