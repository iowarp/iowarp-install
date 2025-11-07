Use docker agent. 

I want the docker/iowarp.Docekrfile container to be responsible for deploying iowarp-runtime and context transfer engine.
It should first start chimaera runtime with ```chimaera_start_runtime &`` to make a background process. 
This is a daemon process. 
Sleep for 1 second afterwards. Then launch the CTE.

Use ``FROM iowarp/context-transfer-engine:latest``.

Build an example combined iowarp-runtime and CTE configuration. Below is documentation on how the codes are deployed
and configured individually.

You should add a custom docker-compose.yml 
and wrp_config.yaml to the docker directory to show people how to make the compose container. 

I want the dockerfile to use touch to create a placeholder configuration file. Both WRP_RUNTIME_CONF
and WRP_CTE_CONF should point to this single file. Call it /etc/iowarp/wrp_conf.yaml.
It should be empty, which is fine. That is valid.

You should then create an example combined wrp_conf.yaml in the docker directory outside of the container
and then pass to the container as a volume so people know how to do this.


## Deploying Runtime

Below is an example code for deploying the runtime. This dockerfile assumes the user sets WRP_RUNTIME_CONF or CHI_SERVER_CONF.
Your example should use WRP_RUNTIME_CONF.
```Dockerfile
# Deployment Dockerfile for IOWarp Runtime
# Inherits from the build container and runs chimaera_start_runtime
FROM iowarp/iowarp-runtime-build:latest

# Create configuration directory
RUN mkdir -p /etc/wrp_runtime

# Copy default configuration
COPY config/chimaera_default.yaml /etc/wrp_runtime/wrp_runtime_config.yaml

# Set WRP_RUNTIME_CONF environment variable
ENV WRP_RUNTIME_CONF=/etc/wrp_runtime/wrp_runtime_config.yaml

# Expose default ZeroMQ port
EXPOSE 5555

# Run chimaera_start_runtime directly
CMD ["chimaera_start_runtime"]
```

## Deploying CTE

```Dockerfile
# Deployment Dockerfile for Content Transfer Engine (CTE)
# Inherits from the build container and runs launch_cte
FROM iowarp/context-transfer-engine-build:latest

# Create configuration directory
RUN mkdir -p /etc/wrp_cte

# Copy default configuration
COPY config/cte_default.yaml /etc/wrp_cte/wrp_cte.conf

# Set WRP_CTE_CONF environment variable
ENV WRP_CTE_CONF=/etc/wrp_cte/wrp_cte.conf

# Expose default ZeroMQ port
EXPOSE 5555

# Run launch_cte directly with local pool query
CMD ["launch_cte", "local"]
```

### Example CTE + Runtime configuration

```yaml
# Default Chimaera Configuration
# This file contains the default configuration for the Chimaera distributed task execution framework

# Worker thread configuration
workers:
  sched_threads: 8           # Unified scheduler worker threads
  process_reaper_threads: 1  # Process reaper threads

# Memory segment configuration  
memory:
  main_segment_size: 1073741824      # 1GB
  client_data_segment_size: 536870912 # 512MB
  runtime_data_segment_size: 536870912 # 512MB

# Network configuration
networking:
  port: 5555
  neighborhood_size: 32  # Maximum number of queries when splitting range queries
  
# Logging configuration
logging:
  level: "info"
  file: "/tmp/chimaera.log"

# Runtime configuration
runtime:
  stack_size: 65536  # 64KB per task
  queue_depth: 10000
  lane_map_policy: "round_robin"  # Options: map_by_pid_tid, round_robin (default), random
  heartbeat_interval: 1000  # milliseconds

# Content Transfer Engine (CTE) Configuration File
# RAM-only storage configuration for benchmark testing

# Target management settings
targets:
  neighborhood: 1  # Single-node configuration
  default_target_timeout_ms: 30000
  poll_period_ms: 5000  # Period to rescan targets for statistics (capacity, bandwidth, etc.)

# Storage block device configuration
# RAM-only configuration for benchmark testing
storage:
  # Primary RAM storage
  - path: "ram::cte_ram_tier1"
    bdev_type: "ram"
    capacity_limit: "16GB"
    score: 0.0           # Manual score override (0.0-1.0) - highest tier

# Data Placement Engine configuration
dpe:
  dpe_type: "max_bw"  # Options: "random", "round_robin", "max_bw"

# Note: This configuration uses only RAM-based storage for maximum performance
# benchmarking. All data is stored in memory with no persistent storage.
```