user_data = <<-EOF
#!/bin/bash

# Disk expansion
dnf install cloud-utils-growpart -y

growpart /dev/nvme0n1 4

lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol

xfs_growfs /
xfs_growfs /var


# Update packages
dnf update -y


# Install Docker
dnf install docker -y

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user


# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl

chmod +x kubectl
mv kubectl /usr/local/bin/kubectl


# Install eksctl
ARCH=amd64
PLATFORM=Linux_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp

rm -f eksctl_${PLATFORM}.tar.gz

mv /tmp/eksctl /usr/local/bin/eksctl


# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh

EOF