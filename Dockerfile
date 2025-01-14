# Use the base image
FROM debian:bookworm-slim

# Define build argument for SSH port (non-sensitive)
ARG SSH_PORT=2222

# Install required packages
RUN apt update \
    && apt -y upgrade \
    && apt install --no-install-recommends -y supervisor openssh-server corosync-qnetd \
    && apt -y autoremove \
    && apt clean all

# Enable root login and set SSH port dynamically
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i "s/^#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config

# Create necessary directories
RUN mkdir -p /run/sshd

# Copy the root password setup script
COPY set_root_password.sh /usr/local/bin/set_root_password.sh
RUN chmod +x /usr/local/bin/set_root_password.sh

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisord.conf

# Expose the custom SSH port and Corosync qnetd port
EXPOSE ${SSH_PORT}
EXPOSE 5403

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

