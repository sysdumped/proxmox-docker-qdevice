Host pi4-qdevice
    Hostname 192.168.10.213
    Port 2222
    User root

# Install corosync-qdevice on all proxmox servers
apt install corosync-qdevice -y

# We can add the QDevice to the cluster. From any node in the cluster, run the pvecm command to add your node. It needs the IP address of the node here. -f forces it to overwrite any existing configuration.
pvecm qdevice setup 192.168.10.213 -f
