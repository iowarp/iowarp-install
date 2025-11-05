FROM iowarp/iowarp-runtime:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp content-transfer-engine Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

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

# Add iowarp-cte to Spack configuration
RUN echo "  iowarp-cte:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: iowarp-cte@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml
