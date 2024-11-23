#!/bin/bash

lsblk
growpart /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var

yum install -y yum-utils 
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo 
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
systemctl start docker 
systemctl enable docker 
usermod -aG docker ec2-user  

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl 

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin 

git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh 

curl -sS https://webinstall.dev/k9s | bash 