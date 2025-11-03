# IOWarp Install

[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![IoWarp](https://img.shields.io/badge/IoWarp-GitHub-blue.svg)](http://github.com/iowarp)
[![GRC](https://img.shields.io/badge/GRC-Website-blue.svg)](https://grc.iit.edu/)
[![Python](https://img.shields.io/badge/Python-3.7+-yellow.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Compatible-blue.svg)](https://www.docker.com/)

Make IOWarp Installation Easy

## Purpose

IOWarp Install provides unified installation methods and tools for the IOWarp ecosystem across multiple platforms and package managers. It simplifies the deployment of IOWarp's high-performance I/O runtime and related components through various installation channels including Conda, Docker, Snap, Spack, and vcpkg.

## Dependencies

### System Requirements
- Git (for vcpkg installation)
- Python >= 3.7 (for Python-based components)
- Docker (for containerized deployment)
- Snapd (for snap installation)
- Spack (for spack installation)

### Python Dependencies
- GitPython >= 3.1.0
- PyGithub >= 2.1.1
- ppi-jarvis-util (from IOWarp)

## Installation

### spack

1. Install Spack package manager
2. Add IOWarp repository:
```bash
spack repo add iowarp-spack
```
3. Install IOWarp:
```bash
spack install iowarp
```

### docker

1. Pull the IOWarp Docker image:
```bash
docker pull iowarp/iowarp-user
```
2. Run the container:
```bash
docker run -it iowarp/iowarp-user
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
- `ports/` - vcpkg port files
- `snap/` - Snap package configuration
- `install.sh` - Main installation script
- `wrpgit` - Git wrapper utility

## License

IOWarp Install is licensed under the BSD 3-Clause License. You can find the full license text in the source files.

## Support

For issues, questions, or installation support:
- Open an issue on the [GitHub repository](https://github.com/iowarp/iowarp-install)
- Visit the [IOWarp project homepage](https://grc.iit.edu/research/projects/iowarp/)
- Contact the Gnosis Research Center at Illinois Institute of Technology
