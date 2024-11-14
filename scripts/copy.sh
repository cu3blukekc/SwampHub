#!/bin/bash
cd /vagrant
DOCKER_BUILDKIT=1 docker build -f ./Dockerfile.build -t dist .
docker run --name dist dist:latest

if [ -d "dist_tmp" ]; then
  rm -r dist_tmp 
fi


docker cp dist:/var/www/dist dist_tmp
docker rm dist
