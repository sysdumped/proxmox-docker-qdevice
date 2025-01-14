#!/bin/sh

docker stop proxmox-docker-qdevice
docker rm proxmox-docker-qdevice

# to generate root password you could use below command
# openssl passwd -6 'root1234!!'
# 
# you could logon to ssh docker server using below command
# ssh root@localhost -p 2222

docker run -d \
    --name proxmox-docker-qdevice \
    -e ROOT_PASSWORD_HASH='$6$BsZbRNoqxTganb3H$lv5Rlb5JHtudOK6/tmFfwWX6nhs6qReWQ8nrz2S1BiuxlmfzS5T3lhg.H8.weZU47H3oGWzD5qWFoY.WqkXUy.' \
    -p 2222:2222/tcp \
    -p 5403:5403/tcp \
    pmox-docker-quorum
