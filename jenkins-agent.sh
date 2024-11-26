#!/bin/bash

# disk resize commands 
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

# java installation for jenkins
dnf install fontconfig java-17-openjdk -y 

# terraform installation
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform 

# nodejs installation 
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y 

# docker installation
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
systemctl start docker 
systemctl enable docker
usermod -aG docker ec2-user 

# helm installation 
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh 