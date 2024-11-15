#!/bin/bash
#install/update docker engine ubuntu

#remove old installation
sudo apt-get remove docker docker-engine docker.io containerd runc docker-compose

#update repo
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Use the following command to set up the repository
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update

#apt-cache madison docker-ce | awk '{ print $3 }'

#Install docker
#VERSION_STRING=5:20.10.21~3-0~ubuntu-focal
#VERSION_STRING=5:24.0.0-1~3-0~ubuntu-focal
#sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#Set right for no-root
sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker
sudo chmod 666 /var/run/docker.sock

su -s ${USER}

#install docker-compose
#VERSION_STRING =v2.14.1
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Test 
sudo docker run hello-world