FROM iowarp/iowarp-base:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Update iowarp-install repo
RUN cd ${HOME}/iowarp-install && \
    git fetch origin && \
    git pull origin main

# Update grc-repo repo
RUN cd ${HOME}/grc-repo && \
    git pull origin main

# Install core build tools (needs root)
USER root
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    doxygen \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install core dependencies
RUN apt-get update && apt-get install -y \
    libyaml-cpp-dev \
    libboost-all-dev \
    libzmq3-dev \
    libelf-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install MPI (openmpi)
RUN apt-get update && apt-get install -y \
    openmpi-bin \
    libopenmpi-dev \
    libhdf5-openmpi-dev \
    mpi-default-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pkg-config
RUN apt-get update && apt-get install -y \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install catch2 from source (using newer version that fixes C++20 issues)
RUN cd /tmp && \
    git clone --depth 1 --branch v3.5.2 https://github.com/catchorg/Catch2.git && \
    cd Catch2 && \
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF && \
    cmake --build build -j$(nproc) && \
    cmake --install build && \
    cd / && rm -rf /tmp/Catch2

# Install cereal (header-only library) from source
RUN cd /tmp && \
    git clone --depth 1 --branch v1.3.2 https://github.com/USCiLab/cereal.git && \
    cd cereal && \
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DJUST_INSTALL_CEREAL=ON && \
    cmake --install build && \
    cd / && rm -rf /tmp/cereal

# Note: Skipping c-blosc2 - libblosc-dev from apt should be sufficient
# If needed later, can build from source with: -DBUILD_EXAMPLES=OFF -DBUILD_FUZZERS=OFF
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Switch back to iowarp user
USER iowarp
WORKDIR /home/iowarp

# Configure Spack to use system packages
RUN mkdir -p ~/.spack && \
    echo "packages:" > ~/.spack/packages.yaml && \
    echo "  cmake:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: cmake" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  boost:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: boost" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  openmpi:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: openmpi" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  hdf5:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: hdf5" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml && \
    echo "  python:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: python" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml
