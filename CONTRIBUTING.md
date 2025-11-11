# Contributing to IOWarp

This repository provides unified installation methods and tools for the IOWarp ecosystem, including Docker configurations, Spack package definitions, and installation scripts.

The IOWarp platform components (CAE, CTE, Runtime, etc.) are developed in separate repositories. Contributions to this repository should focus on installation tooling, Docker configurations, Spack packages, and documentation.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/iowarp.git
   cd iowarp
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/iowarp/iowarp.git
   ```

## Development Setup

### Docker
```bash
cd docker
./build-all-local.sh
```

### Spack
```bash
spack repo add iowarp-spack
spack install iowarp
```

## Contribution Workflow

1. Create a branch: `git checkout -b feature/your-feature-name`
2. Make your changes and commit with clear messages
3. Keep your branch updated: `git fetch upstream && git rebase upstream/main`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a Pull Request on GitHub

## Pull Request Guidelines

- Provide a clear description of what your PR does and why
- Reference related issues using keywords like "Fixes #123"
- Include testing information
- Update documentation if your changes affect user-facing features
- Keep pull requests focused and reasonably sized

## Where to Contribute

**This repository (`iowarp`):**
- Installation and deployment tooling
- Docker configurations and Dockerfiles
- Spack package definitions
- Installation documentation
- Benchmark and demo setups

**Component repositories:**
- CTE core functionality → `content-transfer-engine`
- CAE core functionality → `content-assimilation-engine`
- Runtime features → `iowarp-runtime`
- Shared memory components → `cte-hermes-shm`
- Agent/CD tools → `ppi-jarvis-cd`

For questions, open an issue on GitHub or visit the [IOWarp project homepage](https://grc.iit.edu/research/projects/iowarp/).
