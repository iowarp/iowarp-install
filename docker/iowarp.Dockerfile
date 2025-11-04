FROM iowarp/iowarp-deps:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Update iowarp-install repo
RUN cd iowarp-install && \
    git fetch origin && \
    git pull origin main

# Update grc-repo repo
RUN cd grc-repo && \
    git pull origin main

# Clone and install jarvis from git
RUN cd /root && \
    git clone https://github.com/iowarp/ppi-jarvis-cd.git && \
    cd ppi-jarvis-cd && \
    pip3 install --break-system-packages -r requirements.txt && \
    pip3 install --break-system-packages . && \
    cd /root && rm -rf ppi-jarvis-cd

# Clone and build cte-hermes-shm from source (with minimal features)
RUN cd /root && \
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
    make install && \
    ldconfig && \ 
    cd /root && rm -rf cte-hermes-shm

# Clone and build iowarp-runtime from source
RUN cd /root && \
    git clone --recurse-submodules https://github.com/iowarp/iowarp-runtime.git && \
    cd iowarp-runtime && \
    git checkout main && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd /root && rm -rf iowarp-runtime

# Clone and build iowarp-cte (content-transfer-engine) from source
RUN cd /root && \
    git clone --recurse-submodules https://github.com/iowarp/content-transfer-engine.git && \
    cd content-transfer-engine && \
    git checkout main && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_PREFIX_PATH=/usr/local/cmake \
        -DCTE_ENABLE_POSIX_ADAPTER=ON \
        -DCTE_ENABLE_MPIIO_ADAPTER=ON \
        -DCTE_OPENMPI=ON \
        -DCTE_ENABLE_STDIO_ADAPTER=ON \
        -DCTE_ENABLE_VFD=ON \
        -DCTE_ENABLE_PYTHON=ON \
        .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd /root && rm -rf content-transfer-engine

# Add iowarp packages to Spack configuration (system packages already configured in base image)
RUN echo "  py-ppi-jarvis-cd:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: py-ppi-jarvis-cd" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  cte-hermes-shm:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: cte-hermes-shm@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  iowarp-runtime:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: iowarp-runtime@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  iowarp-cte:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: iowarp-cte@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml

# Setup jarvis
RUN jarvis init
