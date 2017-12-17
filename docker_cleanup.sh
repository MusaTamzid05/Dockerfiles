#!/bin/bash

# original source => https://gist.githubusercontent.com/mlebkowski/471d2731176fb11e81aa/raw/4a6a18a19ac5a9f1b8c6533a07f93e01da8ddba0/cleanup-docker.sh

# remove exited containers:
docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v

# remove unused images:
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi

# remove unused volumes:
find '/var/lib/docker/volumes/' -mindepth 1 -maxdepth 1 -type d | grep -vFf <(
  docker ps -aq | xargs docker inspect | jq -r '.[] | .Mounts | .[] | .Name | select(.)'
) | xargs -r rm -fr
