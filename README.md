# Proxmox Docker QDevice
This repository provides a solution to enhance the reliability of a 2-node Proxmox cluster by introducing a QDevice running within a Docker container. By implementing this setup, you can achieve quorum in scenarios where one node becomes unavailable, thereby maintaining the high availability of your services.

## Understanding the Quorum Problem in 2-Node Proxmox Clusters

In Proxmox clusters, quorum is the minimum number of votes required for the cluster to make decisions and maintain consistency. In a 2-node cluster, each node typically has one vote, resulting in a total of two votes. For the cluster to achieve quorum, more than half of the votes are needed, which equates to two votes in this scenario. This configuration presents a challenge: if one node fails or becomes unreachable, the remaining node lacks the necessary quorum to continue operations, leading to potential downtime.

## Solution: Introducing a QDevice via Docker

To address the quorum issue in a 2-node cluster, a third-party arbitrator known as a QDevice can be introduced. The QDevice provides an additional vote, transforming the cluster into a 3-vote system. With this setup, the cluster can maintain quorum even if one node fails, as the remaining node, together with the QDevice, holds two out of three votes.

This repository offers a method to deploy the QDevice within a Docker container, allowing for flexibility and ease of deployment. Notably, this implementation uses a custom SSH port (e.g., 2222) to avoid conflicts with the Docker host's default SSH port (22).

## Prerequisites

Before proceeding, ensure you have the following:

- A 2-node Proxmox cluster.
- A separate physical or virtual machine to host the Docker container (this should not be one of the Proxmox nodes, could be a tiny raspberry pie node).
- Docker or Docker Compose installed on the host machine.

## Installation and Configuration

1. Clone the Repository:
``` bash
git clone https://github.com/ozhankaraman/proxmox-docker-qdevice.git
cd proxmox-docker-qdevice
```

2. Build the docker container, container uses port 2222 as default ssh port, if you need any other port update the docker-builder.sh file before running
``` bash
./docker-builder.sh
```

3. Deploy the container via docker compose or simply running proxmox-docker-qdevice-test.sh script. If you need to change the default root ssh user password in container follow the procedure in related files.
``` bash
docker compose up -d
```

4. Install corosync-qdevice on Proxmox Nodes, on each Proxmox node, execute below command:
``` bash
apt update
apt install corosync-qdevice -y
```

5. Connect to all proxmox nodes and generate .ssh/config file as below, which will tell proxmox server to use non standard ssh port when accessing the qdevice daemon on docker container. You need to replace <Docker host IP> with the exact ip address of the Docker Host which runs proxmox-docker-qdevice container, for example like `192.168.0.5`
``` bash
Host <Docker host IP>
    Hostname <Docker host IP>
    Port 2222
    User root
```

6. After you build a Proxmox Cluster with minumum 2 nodes to add new third quorum, you need to execute below command on any of the one proxmox node, then qdevice and minumum 3 quorum votes are generated.
``` bash
pvecm qdevice setup <Docker host IP> -f
```

7. Check status of quorum from a proxmox server:
``` bash
pvecm status
```

## Security Considerations
- The Docker container runs an SSH server that permits root logins. Ensure that the NEW_ROOT_PASSWORD is strong and not hardcoded in the docker-compose.yml file to prevent security risks.
- After the initial setup, consider restricting SSH access to the QDevice container by configuring firewall rules 

## Resources.
- Forked from this project, please give a star to them: https://github.com/bcleonard/proxmox-qdevice/tree/master
- https://pve.proxmox.com/wiki/Cluster_Manager
- https://www.apalrd.net/posts/2022/cluster_qdevice/

