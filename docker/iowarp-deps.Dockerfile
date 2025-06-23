FROM iowarp/iowarp-deps-spack:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp dependencies Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Install iowarp.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack install -y iowarp@main+vfd+mpiio+compress+encrypt+nocompile

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
    echo "module use $(scspkg module dir)" >> /root/.bashrc && \
    scspkg init tcl

# Setup jarvis.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp && \
    jarvis bootstrap from local && \
    jarvis rg build
