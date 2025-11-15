#!/bin/bash
#
# IOWarp Standalone Installer
#
# Download and run with:
#   curl -fsSL https://raw.githubusercontent.com/iowarp/iowarp-install/main/install.sh | bash
# Or with custom install prefix:
#   curl -fsSL https://raw.githubusercontent.com/iowarp/iowarp-install/main/install.sh | INSTALL_PREFIX=$HOME/iowarp bash
#

set -e  # Exit on error

# Default install prefix
: ${INSTALL_PREFIX:=/usr/local}

# Create temporary working directory
trap "rm -rf $WORK_DIR" EXIT

cd "$WORK_DIR"

echo "=== IOWarp Installation Script ==="
echo "Install prefix: $INSTALL_PREFIX"
echo "Working directory: $WORK_DIR"

# Clone iowarp-core repository with submodules
if [ ! -d "core" ]; then
    echo "Cloning iowarp-core with submodules..."
    git clone --recurse-submodules --branch 52-attempt-uv-installer https://github.com/iowarp/core.git
else
    echo "iowarp-core already exists, skipping clone..."
fi

# Run iowarp-core install.sh with INSTALL_PREFIX
echo "Running iowarp-core install.sh with INSTALL_PREFIX=$INSTALL_PREFIX..."
cd core
if [ -f "install.sh" ]; then
    chmod +x install.sh
    INSTALL_PREFIX="$INSTALL_PREFIX" ./install.sh
else
    echo "Error: install.sh not found in iowarp-core"
    exit 1
fi
cd ..

# Install iowarp-agent-toolkit
echo "Installing iowarp-agent-toolkit..."
pip install iowarp-agent-toolkit

echo ""
echo "=== IOWarp installation complete ==="
echo "Installed to: $INSTALL_PREFIX"
