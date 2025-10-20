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
RUN cp $(spack location -i mpi)/bin/* /usr/bin && \\
    cp $(spack location -i python)/bin/* /usr/bin && \\
    cp $(spack location -i python)/lib/* /usr/lib && \\
    cp $(spack location -i py-pip)/bin/* /usr/bin && \\
    cp $(spack location -i py-pip)/lib/* /usr/lib && \\
    cp $(spack location -i iowarp-runtime)/bin/* /usr/bin && \\ 
    cp $(spack location -i iowarp-runtime)/lib/* /usr/lib && \\
    cp $(spack location -i iowarp-cte)/bin/* /usr/bin && \\
    cp $(spack location -i iowarp-cte)/lib/* /usr/lib && \\
    cp $(spack location -i cte-hermes-shm)/bin/* /usr/bin && \\ 
    cp $(spack location -i cte-hermes-shm)/lib/* /usr/lib && \\
    cp $(spack location -i py-ppi-jarvis-cd)/bin/* /usr/bin && \\
    cp $(spack location -i py-ppi-jarvis-cd)/lib/* /usr/lib

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
