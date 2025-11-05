FROM iowarp/iowarp-deps:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp ppi-jarvis-cd Docker image"

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

# Add ppi-jarvis-cd to Spack configuration
RUN echo "  py-ppi-jarvis-cd:" >> ~/.spack/packages.yaml && \
    echo "    externals:" >> ~/.spack/packages.yaml && \
    echo "    - spec: py-ppi-jarvis-cd" >> ~/.spack/packages.yaml && \
    echo "      prefix: /usr/local" >> ~/.spack/packages.yaml && \
    echo "    buildable: false" >> ~/.spack/packages.yaml

# Setup jarvis
RUN jarvis init
