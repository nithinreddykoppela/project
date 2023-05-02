#!/bin/bash

set -e

apt update -y

apt install -y nginx
git clone https://github.com/cloudacademy/static-website-example
cd static-website-example
mv * /var/www/html/
systemctl start nginx
systemctl enable nginx
mkdir -p /non/exist/path
# efs_url="${efs_dns_name}"
apt -y install nfs-client nfs-common cifs-utils
mkdir /efs
echo "$efs_dns_name" >/efs/log.l
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_dns_name: /efs
echo $efs_dns_name:/ /efs nfs defaults,_netdev 0 0 >> /etc/fstab