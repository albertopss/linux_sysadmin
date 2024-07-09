# Use an appropriate base image, such as Ubuntu or Debian
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install NFS kernel server and utilities
RUN apt-get update \
    && apt-get install -y nfs-kernel-server \
    && rm -rf /var/lib/apt/lists/*

# Create a directory to be shared via NFS
RUN mkdir -p /exports

# Copy NFS server configuration file
COPY exports /etc/exports

# Expose NFS ports (optional, depending on your setup)
EXPOSE 2049/tcp 2049/udp

# Start NFS server
CMD ["rpcbind", "-f", "-w", "&", "/usr/sbin/exportfs", "-r", "-v", "-o", "no_subtree_check,sync", "--no-udp", "/exports", "*(rw)"]
