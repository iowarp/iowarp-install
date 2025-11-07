# Install Ubuntu.
FROM ubuntu:24.04
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IoWarp spack docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

# Install basic packages.
RUN apt install -y \
    openssl libssl-dev openssh-server \
    sudo git \
    gcc g++ gfortran make binutils gpg \
    tar zip xz-utils bzip2 \
    perl m4 libncurses5-dev libxml2-dev diffutils \
    pkg-config cmake \
    python3 python3-pip python3-venv doxygen \
    lcov zlib1g-dev hdf5-tools \
    build-essential ca-certificates \
    coreutils curl \
    lsb-release unzip liblz4-dev \
    bash jq gdbserver gdb gh nano vim dos2unix \
    clangd clang-format clang-tidy npm \
    redis-server redis-tools

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
# Spack Configuration
#------------------------------------------------------------

# Setup basic environment.
ENV SPACK_DIR="${HOME}/spack"
ENV SPACK_VERSION="v0.23.0"

# Install Spack.
RUN git clone -b ${SPACK_VERSION} https://github.com/spack/spack ${SPACK_DIR} && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack external find

# Add GRC Spack repo.
RUN git clone https://github.com/grc-iit/grc-repo.git ${HOME}/grc-repo && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack repo add ${HOME}/grc-repo

# Add IOWarp Spack repo.
RUN git clone https://github.com/iowarp/iowarp-install.git ${HOME}/iowarp-install && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack repo add ${HOME}/iowarp-install/iowarp-spack

# Update .bashrc.
RUN echo "source ${SPACK_DIR}/share/spack/setup-env.sh" >> ${HOME}/.bashrc

#------------------------------------------------------------
# SSH Configuration
#------------------------------------------------------------

# Configure SSH for iowarp user
RUN mkdir -p ~/.ssh && \
    echo "Host *" >> ~/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> ~/.ssh/config && \
    chmod 600 ~/.ssh/config

# Enable passwordless SSH (requires root)
USER root
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

#------------------------------------------------------------
# Claude Code Installation
#------------------------------------------------------------

# Install Claude Code globally using npm
RUN npm install -g @anthropic-ai/claude-code

#------------------------------------------------------------
# uvx Package Manager Installation
#------------------------------------------------------------

# Install uvx (standalone tool runner for Python)
RUN pip3 install --break-system-packages uv

# Switch back to iowarp user
USER iowarp

# Start SSH on container startup (using sudo since iowarp user has NOPASSWD)
CMD sudo service ssh start && /bin/bash
