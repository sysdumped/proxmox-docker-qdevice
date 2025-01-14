#!/bin/sh

docker build . --build-arg SSH_PORT=2222 -t proxmox-docker-qdevice
