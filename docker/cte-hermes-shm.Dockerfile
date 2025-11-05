FROM iowarp/ppi-jarvis-cd:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp cte-hermes-shm Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Clone and build cte-hermes-shm from source (with minimal features)
RUN cd ${HOME} && \
    git clone --recurse-submodules https://github.com/iowarp/cte-hermes-shm.git && \
    cd cte-hermes-shm && \
    git checkout main && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DHSHM_ENABLE_ELF=ON \
        -DHSHM_BUILD_TESTS=OFF \
        -DHSHM_BUILD_BENCHMARKS=ON \
        -DHSHM_BUILD_TESTS=ON \
        -DHSHM_ENABLE_MPI=ON \
    .. && \
    make -j$(nproc) && \
    sudo make install && \
    sudo ldconfig && \
    cd ${HOME} && rm -rf cte-hermes-shm

# Add cte-hermes-shm to Spack configuration
RUN echo "  cte-hermes-shm:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: cte-hermes-shm@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml
