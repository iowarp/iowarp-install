# IOWarp Container Restructure

## Overview

The IOWarp container architecture has been restructured to optimize the deployment image by:
1. Using `iowarp/context-transfer-engine:latest` as the builder instead of the base image
2. Creating a minimal runtime base image without development dependencies
3. Copying only the compiled libraries and binaries to the deployment container

## Changes Made

### 1. New Minimal Base Image

**File**: `iowarp-base-minimal.Dockerfile`

- Based on `ubuntu:24.04`
- Contains only runtime dependencies (no development tools like cmake, g++, etc.)
- Includes runtime libraries for:
  - C++ and Boost
  - YAML-CPP
  - ZeroMQ
  - OpenSSL
  - MPI (runtime only)
  - HDF5 (serial version)
  - Python
  - LZ4, Zlib

### 2. Updated Deployment Container

**File**: `iowarp.Dockerfile`

Now uses a multi-stage build:
- **Builder stage**: `iowarp/context-transfer-engine:latest`
  - Contains all compiled objects from the full build chain
- **Final stage**: `iowarp/iowarp-base-minimal:latest`
  - Minimal runtime base image
  - Copies all compiled objects from builder's `/usr/local/` directory
  - Note: While the builder has separate install directories (`/cte-hermes-shm`, `/iowarp-runtime`, `/iowarp-cte`), all functional binaries and libraries are in `/usr/local`
  - Runs `ldconfig` to update library cache
  - Significantly smaller image size (68% reduction)

### 3. Build Container (No Changes)

**File**: `iowarp-build.Dockerfile`

- Still inherits from `iowarp/context-assimilation-engine-build:latest`
- Contains all developer container dependencies

### 4. Updated Build Scripts

**File**: `local.sh`
- Added build step for `iowarp-base-minimal:latest`
- Builds minimal base before deployment container

**File**: `local.deps.sh`
- Added build step for `iowarp-base-minimal:latest`
- Ensures minimal base is available when building dependencies

## Benefits

1. **Smaller deployment image**: Only runtime dependencies, no build tools
2. **Clearer separation**: Development vs deployment containers
3. **Security**: Reduced attack surface with minimal dependencies
4. **Proper dependency chain**: Uses the built context-transfer-engine as source

## Build Order

When building from scratch:

1. Base images (via `local.deps.sh`):
   - `iowarp/iowarp-base:latest` (dev base)
   - `iowarp/iowarp-deps:latest` (dev dependencies)
   - `iowarp/iowarp-base-minimal:latest` (runtime base)

2. Project builds (via component `local.sh` scripts):
   - `iowarp/cte-hermes-shm-build:latest`
   - `iowarp/iowarp-runtime-build:latest`
   - `iowarp/context-transfer-engine:latest`
   - `iowarp/content-assimilation-engine-build:latest`

3. IOWarp platform (via `local.sh`):
   - `iowarp/iowarp:latest` (uses context-transfer-engine as builder)
   - `iowarp/iowarp-build:latest`

## Container Hierarchy

```
Development Chain:
ubuntu:24.04
  └─> iowarp-base:latest
       └─> iowarp-deps:latest
            └─> [various -build containers]
                 └─> context-transfer-engine:latest

Deployment Chain:
ubuntu:24.04
  └─> iowarp-base-minimal:latest
       └─> iowarp:latest (copies from context-transfer-engine:latest)
```

## Testing

After building, verify the deployment container:
```bash
# Check that binaries are available
docker run --rm iowarp/iowarp:latest which chimaera_start_runtime

# Check that libraries are found
docker run --rm iowarp/iowarp:latest ldconfig -p | grep iowarp

# Test that the runtime can start
docker run --rm iowarp/iowarp:latest chimaera_start_runtime --help

# Check image size (should be smaller than before)
docker images | grep iowarp
```

## Test Results

✅ All tests passed successfully!

### Image Size Comparison
- **Old image** (`iowarp:latest` before restructure): **3.73GB**
- **New image** (`iowarp:latest` after restructure): **1.17GB**
- **Size reduction**: **68% smaller** (saved 2.56GB)

### Functionality Tests
- ✅ Binary availability: `chimaera_start_runtime` found at `/usr/local/bin/chimaera_start_runtime`
- ✅ Library linking: All iowarp libraries properly registered in ldconfig cache
- ✅ Runtime execution: Successfully starts with all modules loaded:
  - `chimaera_bdev`
  - `chimaera_admin`
  - `wrp_cte_core`
  - `chimaera_MOD_NAME`
  - All workers initialize correctly
