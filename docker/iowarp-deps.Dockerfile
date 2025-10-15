FROM iowarp/iowarp-deps-spack:ai
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Install iowarp.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack install -y iowarp@ai

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
