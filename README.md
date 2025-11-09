# IOWarp Install

[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![IoWarp](https://img.shields.io/badge/IoWarp-GitHub-blue.svg)](http://github.com/iowarp)
[![GRC](https://img.shields.io/badge/GRC-Website-blue.svg)](https://grc.iit.edu/)
[![Python](https://img.shields.io/badge/Python-3.7+-yellow.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Compatible-blue.svg)](https://www.docker.com/)

Make IOWarp Installation Easy

## Purpose

IOWarp Install provides unified installation methods and tools for the IOWarp ecosystem across multiple platforms and package managers. It simplifies the deployment of IOWarp's high-performance I/O runtime and related components through various installation channels including Conda, Docker, Snap, Spack, and vcpkg.

## Installation

### Docker (Recommended)

Docker provides the easiest way to get started with IOWarp. The `iowarp/iowarp:latest` image includes the complete runtime with buffering services.

#### Quick Start

Create a `docker-compose.yml` file:

```yaml
# IOWarp Runtime Docker Compose Configuration
#
# This compose file runs the IOWarp runtime service for user applications.
# The iowarp service provides the CTE runtime that applications can connect to.
#
# Usage:
#   docker-compose up                       # Run runtime service
#   docker-compose down                     # Stop service

services:
  # IOWarp Runtime Service
  # Provides the CTE runtime daemon that applications connect to
  iowarp-runtime:
    image: iowarp/iowarp:latest
    container_name: iowarp-runtime

    # Mount shared CTE configuration
    volumes:
      - ./wrp_conf.yaml:/etc/iowarp/wrp_conf.yaml:ro

    # Expose ZeroMQ port for client connections
    ports:
      - "5555:5555"

    # Resource limits
    # Large shared memory for CTE operations
    shm_size: 8g
    mem_limit: 8g

    # Make IPC namespace shareable so application containers can join
    ipc: shareable

    # Keep container running as a daemon
    stdin_open: true
    tty: true

    # Restart policy - no restart for manual runs
    restart: "no"
```

Run the container:
```bash
docker-compose up -d
```

Shared memory and shareable ipcs are required.

#### Configuration (optional)

The default configuration provides up to 16GB buffer cache.
For more complexity, create a `wrp_conf.yaml` configuration file.
This is an example with some paramters, but not all:

```yaml
# IOWarp Runtime Configuration File
compose:
  # Compose parameters (do not change these)
  - mod_name: wrp_cte_core
    pool_name: wrp_cte
    pool_query: local
    pool_id: 512.0

    # Storage block device configuration
    # This is the most important section - defines where data is buffered
    storage:
      # RAM-based storage tier (fastest)
      - path: "ram::cte_ram_tier1"
        bdev_type: "ram"
        capacity_limit: "16GB"
        score: 0.0           # Manual score override (range 0 to 1), put all data here

      # Example: Add NVMe tier (uncomment to use)
      # - path: "/dev/nvme0n1"
      #   bdev_type: "file"
      #   capacity_limit: "500GB"
      #   score: 0.5

      # Example: Add SSD tier (uncomment to use)
      # - path: "/dev/sda1"
      #   bdev_type: "file"
      #   capacity_limit: "1TB"
      #   score: 1.0
```

**Storage Configuration:**
- `path` - Device path or RAM identifier (format: `ram::<name>` for RAM, `/dev/<device>` for block devices)
- `bdev_type` - Backend type: `"ram"` (memory), `"nvme"` (NVMe SSD), `"aio"` (async I/O for other block devices)
- `capacity_limit` - Maximum storage capacity (supports `KB`, `MB`, `GB`, `TB` suffixes)
- `score` - Tier priority (0.0 = lowest priority, 1.0 = highest). 0.0 means "anyone can put data here", 
while 1.0 means only put high priority data here.

Multiple storage tiers can be configured to create a hierarchical storage system. Data is automatically placed across tiers based on the data placement engine (DPE) strategy.

#### Example: Running Benchmarks

The `demos/benchmark/` directory contains a complete Docker Compose setup for running CTE benchmarks:

```bash
cd demos/benchmark

# Run default benchmark (Put test)
docker-compose up

# Run specific test with custom parameters
TEST_CASE=Get IO_SIZE=4m IO_COUNT=1000 docker-compose up
```

Available benchmark parameters:
- `TEST_CASE` - Benchmark test: `Put`, `Get`, `PutGet` (default: `Put`)
- `NUM_PROCS` - Number of parallel processes (default: `1`)
- `DEPTH` - Queue depth for concurrent operations (default: `4`)
- `IO_SIZE` - Size of each I/O operation with suffix `b`, `k`, `m`, `g` (default: `1m`)
- `IO_COUNT` - Number of operations to perform (default: `100`)

The benchmark compose file demonstrates:
- Separate runtime and benchmark services
- Shared memory configuration (`shm_size: 8g`)
- IPC namespace sharing for shared memory access
- Custom CTE configuration via volume mounts
- Health checks to ensure runtime readiness

### Spack

1. Install Spack package manager
2. Add IOWarp repository:
```bash
spack repo add iowarp-spack
```
3. Install IOWarp:
```bash
spack install iowarp
```

## Continuous Integration

| Test    | Status |
| --------| ------ |
| Windows 2022 | [![win](https://github.com/iowarp/iowarp-install/actions/workflows/win.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/win.yml) |
| Ubuntu 24.04 |[![lin](https://github.com/iowarp/iowarp-install/actions/workflows/lin.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/lin.yml) [![conda](https://github.com/iowarp/iowarp-install/actions/workflows/lin-cnd.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/lin-cnd.yml) [![spack](https://github.com/iowarp/iowarp-install/actions/workflows/spack.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/spack.yml) |

## Project Structure

- `docker/` - Docker images and configurations
- `demos/` - Example applications and demos
- `iowarp-spack/` - Spack package definitions

## License

IOWarp Install is licensed under the BSD 3-Clause License. You can find the full license text in the source files.

## Support

For issues, questions, or installation support:
- Open an issue on the [GitHub repository](https://github.com/iowarp/iowarp-install)
- Visit the [IOWarp project homepage](https://grc.iit.edu/research/projects/iowarp/)
- Contact the Gnosis Research Center at Illinois Institute of Technology
