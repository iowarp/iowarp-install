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

USER iowarp

# Run chimaera runtime in foreground
CMD ["chimaera_start_runtime"]
