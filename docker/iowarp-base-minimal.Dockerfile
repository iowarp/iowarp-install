# Minimal runtime base image for IOWarp deployment
# Contains only runtime dependencies without development tools
FROM ubuntu:24.04
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp minimal runtime base image"

# Disable prompt during packages installation
ARG DEBIAN_FRONTEND=noninteractive

# Update package lists
RUN apt-get update && apt-get upgrade -y

# Install essential runtime dependencies only (no build tools)
RUN apt-get update && apt-get install -y \
    # Core utilities
    sudo \
    bash \
    # Runtime libraries for C++ and Boost
    libstdc++6 \
    libboost-filesystem1.83.0 \
    libboost-system1.83.0 \
    libboost-thread1.83.0 \
    libboost-program-options1.83.0 \
    libboost-context1.83.0 \
    libboost-fiber1.83.0 \
    # YAML-CPP runtime library
    libyaml-cpp0.8 \
    # ZeroMQ runtime library
    libzmq5 \
    # OpenSSL runtime library
    libssl3 \
    # ELF library runtime
    libelf1 \
    # MPI runtime (no dev packages)
    openmpi-bin \
    libopenmpi3 \
    # HDF5 runtime library (serial version)
    libhdf5-103-1 \
    # Python runtime
    python3 \
    python3-pip \
    # LZ4 runtime library
    liblz4-1 \
    # Zlib runtime library
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with sudo privileges
RUN useradd -m -s /bin/bash -G sudo iowarp && \
    echo "iowarp ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    passwd -d iowarp

# Set environment variables for MPI
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Switch to non-root user
USER iowarp
ENV USER="iowarp"
ENV HOME="/home/iowarp"
WORKDIR /home/iowarp

# Default command
CMD ["/bin/bash"]
