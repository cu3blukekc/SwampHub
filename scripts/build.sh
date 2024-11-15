#!/bin/bash



cd /vagrant
#openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./cert/server.key -out ./cert/server.crt
#openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./cert/vagrant-dochub.key -out ./cert/vagrant-dochub.crt

#SSL
#sudo openssl genrsa -out vagrant-dochub.key 4096
#sudo openssl req -new -key vagrant-dochub.key -out vagrant-dochub.csr
#sudo openssl x509 -req -days 365 -in vagrant-dochub.csr -signkey vagrant-dochub.key -out vagrant-dochub.crt
#correct error with resolving in docker build process
sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf 
docker-compose build 