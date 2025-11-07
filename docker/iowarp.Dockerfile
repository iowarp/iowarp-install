FROM iowarp/context-transfer-engine:latest

# Set environment variables for configuration paths
ENV WRP_RUNTIME_CONF=/etc/iowarp/wrp_conf.yaml
ENV WRP_CTE_CONF=/etc/iowarp/wrp_conf.yaml

# Create configuration directory and empty placeholder file
RUN mkdir -p /etc/iowarp && \
    touch /etc/iowarp/wrp_conf.yaml

# Create startup script
RUN echo '#!/bin/bash\n\
# Start runtime in background\n\
chimaera_start_runtime &\n\
\n\
# Wait for runtime to initialize\n\
sleep 2\n\
\n\
# Launch CTE\n\
launch_cte local' > /usr/local/bin/start_iowarp.sh && \
    chmod +x /usr/local/bin/start_iowarp.sh

# Expose ZeroMQ port
EXPOSE 5555

# Run the startup script
CMD ["/usr/local/bin/start_iowarp.sh"]
