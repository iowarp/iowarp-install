# Multi-stage build: Use context-transfer-engine as builder
FROM iowarp/context-transfer-engine:latest AS builder

# Final deployment stage: Use minimal base image
FROM iowarp/iowarp-base-minimal:latest

# Set environment variables for configuration paths
ENV WRP_RUNTIME_CONF=/etc/iowarp/wrp_conf.yaml

USER root

# Copy compiled iowarp libraries and binaries from builder stage
# All compiled objects from cte-hermes-shm, iowarp-runtime, and iowarp-cte
# are installed in /usr/local in the builder container
COPY --from=builder /usr/local/ /usr/local/

# Update library cache so system can find the newly installed libraries
RUN ldconfig

# Create configuration directory and copy default configuration
RUN mkdir -p /etc/iowarp
COPY user/wrp_conf.yaml /etc/iowarp/wrp_conf.yaml
RUN chown iowarp:iowarp /etc/iowarp/wrp_conf.yaml

# Expose ZeroMQ port
EXPOSE 5555

# Health check to verify runtime is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD pgrep -f chimaera_start_runtime || exit 1

USER iowarp

# Run chimaera runtime in foreground
CMD ["chimaera_start_runtime"]
