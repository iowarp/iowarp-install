FROM iowarp/context-transfer-engine:latest

# Set environment variables for configuration paths
ENV WRP_RUNTIME_CONF=/etc/iowarp/wrp_conf.yaml

USER root

# Create configuration directory and empty placeholder file
RUN mkdir -p /etc/iowarp && \
    touch /etc/iowarp/wrp_conf.yaml && \
    chown iowarp:iowarp /etc/iowarp/wrp_conf.yaml

# Expose ZeroMQ port
EXPOSE 5555

# Health check to verify runtime is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD pgrep -f chimaera_start_runtime || exit 1

USER iowarp

# Run chimaera runtime in foreground
CMD ["chimaera_start_runtime"]
