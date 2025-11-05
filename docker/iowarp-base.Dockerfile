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
    clangd clang-format clang-tidy

#------------------------------------------------------------
# Spack Configuration
#------------------------------------------------------------

# Setup basic environment.
ENV USER="root"
ENV HOME="/root"
ENV SPACK_DIR="${HOME}/spack"
ENV SPACK_VERSION="v0.23.0"

# Install Spack.
RUN git clone -b ${SPACK_VERSION} https://github.com/spack/spack ${SPACK_DIR} && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack external find

# Add GRC Spack repo.
RUN git clone https://github.com/grc-iit/grc-repo.git && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack repo add grc-repo

# Add IOWarp Spack repo.
RUN git clone https://github.com/iowarp/iowarp-install.git && \
    . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack repo add iowarp-install/iowarp-spack

# Update .bashrc.
RUN echo "source ${SPACK_DIR}/share/spack/setup-env.sh" >> ${HOME}/.bashrc

#------------------------------------------------------------
# SSH Configuration
#------------------------------------------------------------

# Disable host key checking.
RUN echo "Host *" >> ~/.ssh/config
RUN echo "    StrictHostKeyChecking no" >> ~/.ssh/config
RUN chmod 600 ~/.ssh/config

# Enable passwordless SSH.
# Replaces #PermitEmptyPasswords no with PermitEmptyPasswords yes
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

# Create this directory, as sshd doesn't do so automatically.
RUN mkdir /run/sshd
