#!/bin/bash

# Build all IOWarp containers locally in sequence
# Usage: bash docker/build-all-local.sh

set -e  # Exit on error

# List of repositories to build
REPOS=(
  # "ppi-jarvis-cd"
  "cte-hermes-shm"
  "iowarp-runtime"
#   "content-transfer-engine"
  "content-assimilation-engine"
  "iowarp-install"
)

# Check if IOWARP is set
if [ -z "$IOWARP" ]; then
  echo "Error: IOWARP environment variable is not set"
  exit 1
fi

echo "Building all IOWarp containers..."
echo "IOWARP directory: $IOWARP"
echo ""

# Build each repository in sequence
for repo in "${REPOS[@]}"; do
  echo "========================================="
  echo "Building $repo..."
  echo "========================================="

  REPO_PATH="$IOWARP/$repo"

  if [ ! -d "$REPO_PATH" ]; then
    echo "Error: Repository not found at $REPO_PATH"
    exit 1
  fi

  if [ ! -f "$REPO_PATH/docker/local.sh" ]; then
    echo "Error: docker/local.sh not found in $REPO_PATH"
    exit 1
  fi

  cd "$REPO_PATH"/docker
  sudo bash local.sh

  echo ""
  echo "$repo build completed successfully"
  echo ""
done

echo "========================================="
echo "All containers built successfully!"
echo "========================================="

