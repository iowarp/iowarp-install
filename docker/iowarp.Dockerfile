FROM iowarp/iowarp-cte:latest AS builder

# Runtime image based on minimal Ubuntu
FROM ubuntu:24.04
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp runtime-only Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies (not build tools)
RUN apt-get update && apt-get install -y \
    # Core runtime libraries
    libssl3 \
    libelf1 \
    libzmq5 \
    libboost-filesystem1.83.0 \
    libboost-system1.83.0 \
    libboost-thread1.83.0 \
    libyaml-cpp0.8 \
    # Serial HDF5 runtime
    libhdf5-103-1 \
    # Utilities
    sudo \
    && rm -rf /var/lib/apt/lists/*

#------------------------------------------------------------
# User Configuration
#------------------------------------------------------------

# Create non-root user with sudo privileges
RUN useradd -m -s /bin/bash -G sudo iowarp && \
    echo "iowarp ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    passwd -d iowarp

# Switch to non-root user
USER iowarp
ENV USER="iowarp"
ENV HOME="/home/iowarp"

#------------------------------------------------------------
# Copy binaries and libraries from builder
#------------------------------------------------------------

# Copy installed libraries and binaries from /usr/local
COPY --from=builder --chown=iowarp:iowarp /usr/local/lib /usr/local/lib
COPY --from=builder --chown=iowarp:iowarp /usr/local/bin /usr/local/bin
COPY --from=builder --chown=iowarp:iowarp /usr/local/include /usr/local/include

# Update library cache
USER root
RUN ldconfig
USER iowarp

# Default command
CMD ["/bin/bash"]
