FROM iowarp/iowarp-user:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp Docker image with CI"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive

# Build resource graph
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp && \
    jarvis rg build

# Create pipeline.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp && \
    jarvis env build hermes && \
    jarvis ppl index load jarvis_hermes.hermes.test_hermes && \
    jarvis pkg conf chimaera_run data_shm=500m rdata_shm=500m task_shm=500m qdepth=50 worker_cpus=[0,1,1] && lane_depth=50 && comux_depth=50 && \
    jarvis ppl print && \
    cat $(jarvis path +shared)/chimaera_run/hostfile  && \
    cat $(jarvis path +shared)/chimaera_run/chimaera_server.yaml

# Create pipeline.
# RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
#     spack load iowarp && \
#     jarvis env build hermes && \
#     jarvis ppl create start_runtime && \
#     jarvis ppl append chimaera_run data_shm=500m rdata_shm=500m task_shm=500m qdepth=50 worker_cpus=[0,1,1] && lane_depth=50 && comux_depth=50 \
#     jarvis ppl prepend asan && \
#     jarvis ppl print && \
#     cat $(jarvis path +shared)/chimaera_run/hostfile  && \
#     cat $(jarvis path +shared)/chimaera_run/chimaera_server.yaml


# Run pipeline.
RUN . "${SPACK_DIR}/share/spack/setup-env.sh" && \
    spack load iowarp
#    && \
#    jarvis ppl run