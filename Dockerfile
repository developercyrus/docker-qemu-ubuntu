# Use Ubuntu as the base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    wget \
    cloud-image-utils \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /qemu

COPY cloud-config.yml /qemu

# Download Ubuntu 24.04 cloud image
RUN wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img


# Create a startup script
RUN echo '#!/bin/bash\n\
if [ ! -f /data/ubuntu.qcow2 ]; then\n\
    echo "Creating new QEMU image..."\n\
    qemu-img create -f qcow2 -b /qemu/ubuntu-24.04-server-cloudimg-amd64.img -F qcow2 /data/ubuntu.qcow2 20G\n\
    echo "Creating cloud-config ISO..."\n\
    cloud-localds /data/cloud-config.iso /qemu/cloud-config.yml\n\
fi\n\
echo "Starting QEMU..."\n\
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -nographic \
    -drive file=/data/ubuntu.qcow2,format=qcow2 \
    -drive file=/data/cloud-config.iso,format=raw \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device e1000,netdev=net0\n' > start.sh && chmod +x start.sh

# Ensure the script can write to /data
RUN mkdir /data && chmod 777 /data

# Set the entrypoint to the startup script
ENTRYPOINT ["/qemu/start.sh"]
