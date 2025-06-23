FROM iowarp/iowarp-base:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Install iowarp.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack install -y iowarp@main+vfd+mpiio+compress+encrypt+nocompile

# Uninstall iowarp-base
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack uninstall -y --all --dependents iowarp-base

