FROM iowarp/iowarp-deps-spack:ai
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Install iowarp.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack install -y iowarp@ai

# Copy all relevant spack packages to /usr directory
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \\
    which spack && \
    spack load iowarp && \\
    cp -r $(spack location -i python)/bin/* /usr/bin || true 

# Copy all relevant spack packages to /usr directory
# RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \\
#     spack load iowarp && \\
#     cp -r $(spack location -i python)/bin/* /usr/bin || true && \\
#     cp -r $(spack location -i py-pip)/bin/* /usr/bin || true && \\
#     cp -r $(spack location -i python-venv)/bin/* /usr/bin || true && \\
#     PYTHON_PATH=$(readlink -f /usr/bin/python3) && \\
#     PYTHON_PREFIX=$(dirname $(dirname $PYTHON_PATH)) && \\
#     SITE_PACKAGES="$PYTHON_PREFIX/lib/python3.11/site-packages" && \\
#     cp -r $(spack location -i mpi)/bin/* /usr/bin || true && \\
#     cp -r $(spack location -i iowarp-runtime)/bin/* /usr/bin || true && \\
#     cp -r $(spack location -i iowarp-cte)/bin/* /usr/bin || true && \\
#     cp -r $(spack location -i cte-hermes-shm)/bin/* /usr/bin || true && \\
#     for pkg in $(spack find --format '{name}' | grep '^py-'); do \\
#         cp -r $(spack location -i $pkg)/lib/python3.11/site-packages/* $SITE_PACKAGES/ 2>/dev/null || true; \\
#         cp -r $(spack location -i $pkg)/bin/* /usr/bin 2>/dev/null || true; \\
#     done && \\
#     sed -i '1s|.*|#!/usr/bin/python3|' /usr/bin/jarvis && \\
#     echo "Spack packages copied to /usr directory"

# Setup modules.
RUN echo $'\n\
    if ! shopt -q login_shell; then\n\
    if [ -d /etc/profile.d ]; then\n\
    for i in /etc/profile.d/*.sh; do\n\
    if [ -r $i ]; then\n\
    . $i\n\
    fi\n\
    done\n\
    fi\n\
    fi\n\
    ' >> /root/.bashrc

# Setup scspkg
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp && \
    echo "module use $(scspkg module dir)" >> /root/.bashrc

# Setup jarvis.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp && \
    jarvis init
