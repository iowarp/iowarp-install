FROM iowarp/iowarp-base:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Update iowarp-install repo
RUN cd iowarp-install && \
    git fetch origin && \
    git pull origin main

# Change iowarp to 
RUN cd iowarp-install

# Update grc-repo repo
RUN cd grc-repo && \
    git pull origin main

# Install iowarp.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack install -y iowarp-base
