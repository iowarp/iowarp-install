FROM iowarp/iowarp-deps:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp Docker image with CI"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Clone GRC tutorial
RUN git clone https://github.com/grc-iit/grc-tutorial.git

# Install iowarp package from GitHub main repository.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack uninstall -y --all --dependents iowarp-base && \
    spack install -y iowarp@main +vfd +mpiio +compress +encrypt
