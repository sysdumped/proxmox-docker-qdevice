#!/bin/sh

docker stop proxmox-docker-qdevice
docker rm proxmox-docker-qdevice

# to generate root password you could use below command
# openssl passwd -6 'rootpw'
# 
# you could logon to ssh docker server using below command
# ssh root@localhost -p 2222

docker run -d \
    --name proxmox-docker-qdevice \
    -e ROOT_PASSWORD_HASH='$6$YjADoxGRYOwdaK8w$PlVZ2daOEzE4p7PyUDpx0JuoxERmi3cjSclDmtzvVGlSIXiV9izzYJDrmBttNsdlqVfVXwY3/zM2s3Y9O/JzZ.' \
    -p 2222:2222/tcp \
    -p 5403:5403/tcp \
    proxmox-docker-qdevice
