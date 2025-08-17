#!/bin/bash

# server update 
sudo apt-get update

# install jenkins on ubuntu 16.04 LTS
sudo apt-get install -y openjdk-17-jre curl gpg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /etc/apt/keyrings/jenkins.gpg
echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y jenkins

# # install jenkins on ubuntu 16.04 LTS
# sudo apt install fontconfig openjdk-17-jre -y

# sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt upgrade -y
# sudo apt-get install jenkins -y

# Change Jenkins port from 8080 to 9090
# sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8081/' /etc/default/jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins
# sudo systemctl status jenkins

# install maven 
sudo apt install maven -y

# install docker 
sudo apt update
sudo apt  install docker.io -y
# sudo apt-get install ca-certificates curl gnupg
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg
# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#   sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install git
sudo apt-get install git -y

# install nodejs and npm
sudo apt-get install nodejs -y
sudo apt-get install npm -y

# amazon cli install
sudo apt-get install unzip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

 # Install dependencies
sudo apt-get install -y curl unzip apt-transport-https ca-certificates gnupg

# Install kubectl (v1.30.0 for x86_64)
curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install eksctl (latest)
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

# Verify versions
kubectl version --client
eksctl version

# install kubectl 
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.11/2025-04-17/bin/darwin/amd64/kubectl
# chmod +x ./kubectl
# mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
# echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile


# # eks installation 
# # for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
# ARCH=amd64
# PLATFORM=$(uname -s)_$ARCH

# curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# # (Optional) Verify checksum
# curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

# tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

# sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

# add ubuntu and jenkins user in docker group
sudo usermod -aG docker ubuntu
sudo newgrp docker
sudo usermod -aG docker jenkins
sudo newgrp docker
sudo systemctl restart jenkins
sudo systemctl restart docker
sudo systemctl start docker
sudo systemctl enable docker

# install zap 
wget https://github.com/zaproxy/zaproxy/releases/download/v2.16.1/ZAP_2.16.1_Linux.tar.gz
sudo tar xvf ZAP_2.16.1_Linux.tar.gz
cd ZAP_2.16.1
sudo ./zap.sh
