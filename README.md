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

1. Pull the IOWarp Docker image:
```bash
docker pull iowarp/iowarp:latest
```

2. Run the container:
```bash
docker run -d -p 5555:5555 --name iowarp iowarp/iowarp:latest
```

#### Using Docker Compose

For more advanced configurations, use Docker Compose with custom CTE (Context Transfer Engine) settings:

```bash
cd docker/user
docker-compose up -d
```

This mounts a custom `wrp_conf.yaml` configuration file that controls the IOWarp runtime and CTE behavior.

#### Configuration

The CTE configuration is controlled by a YAML file (e.g., `wrp_conf.yaml`). The most important parameter is the **storage configuration**, which defines where and how data is buffered:

```yaml
# Storage block device configuration
storage:
  # RAM-based storage tier
  - path: "ram::cte_ram_tier1"
    bdev_type: "ram"
    capacity_limit: "16GB"
    score: 0.0  # Tier priority (0.0 = highest)

  # Example: Add NVMe tier
  # - path: "/dev/nvme0n1"
  #   bdev_type: "nvme"
  #   capacity_limit: "500GB"
  #   score: 0.5
```

Other parameters primarily affect performance:
- `targets.neighborhood` - Number of nodes in the cluster
- `targets.poll_period_ms` - How often to rescan targets for statistics
- `dpe.dpe_type` - Data placement strategy: `"random"`, `"round_robin"`, or `"max_bw"` (maximum bandwidth)

See `demos/benchmark/docker-compose.yml` for a complete benchmark example with detailed configuration documentation.

#### Example: Running Benchmarks

The `demos/benchmark/` directory contains a complete Docker Compose setup for running CTE benchmarks:

```bash
cd demos/benchmark

# Run default benchmark (Put test)
docker-compose up

# Run specific test with custom parameters
TEST_CASE=Get IO_SIZE=4m IO_COUNT=1000 docker-compose up

# Start only the runtime service
docker-compose up -d iowarp-runtime
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
