#!/bin/bash

# disk resize commands
growpart /dev/nvme0n1 4
 
lvextend -L +10G /dev/RootVG/rootVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /
xfs_growfs /var/tmp
xfs_growfs /var 

# jenkins installation commands 
curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key 

dnf install fontconfig java-17-openjdk -y 

dnf install jenkins -y 

systemctl daemon-reload 

systemctl start jenkins

systemctl enable jenkins 
