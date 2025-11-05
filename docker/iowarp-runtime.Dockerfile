FROM iowarp/cte-hermes-shm:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp runtime Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Clone and build iowarp-runtime from source
RUN cd ${HOME} && \
    git clone --recurse-submodules https://github.com/iowarp/iowarp-runtime.git && \
    cd iowarp-runtime && \
    git checkout main && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j$(nproc) && \
    sudo make install && \
    sudo ldconfig && \
    cd ${HOME} && rm -rf iowarp-runtime

# Add iowarp-runtime to Spack configuration
RUN echo "  iowarp-runtime:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: iowarp-runtime@main" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml
