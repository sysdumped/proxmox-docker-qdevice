#!/bin/bash

# Example hash generation: openssl passwd -6 'rootpw'

if [ -n "$ROOT_PASSWORD_HASH" ]; then
    echo "Setting root password..."
    echo "root:${ROOT_PASSWORD_HASH}" | chpasswd -e
    echo "Root password has been set successfully."
else
    echo "No root password hash provided. Skipping password setup."
fi
