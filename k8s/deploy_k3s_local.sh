#!/bin/bash
# Deploy k3s single-node cluster on local machine

set -e

# Clean up any existing k3s processes
pkill -9 k3s 2>/dev/null || true
sleep 2

# Set up directories and runtime environment
export K3S_DATA_DIR=$HOME/.k3s/data
export XDG_RUNTIME_DIR=$HOME/.k3s/runtime
mkdir -p $K3S_DATA_DIR $HOME/.kube $XDG_RUNTIME_DIR

# Remove old data
rm -rf $K3S_DATA_DIR/*

echo "Starting k3s single-node cluster..."
echo "Data dir: $K3S_DATA_DIR"

# Start k3s server in rootless mode
nohup $HOME/.local/bin/k3s server \
  --data-dir=$K3S_DATA_DIR \
  --write-kubeconfig=$HOME/.kube/config \
  --write-kubeconfig-mode=644 \
  --disable=traefik \
  --disable=servicelb \
  --rootless \
  --snapshotter=native \
  > $HOME/.k3s/server.log 2>&1 &

K3S_PID=$!
echo "$K3S_PID" > $HOME/.k3s/server.pid
echo "K3s server started with PID $K3S_PID"

# Wait for server to be ready
echo "Waiting for k3s server to be ready..."
for i in {1..60}; do
  if $HOME/.local/bin/k3s kubectl get nodes >/dev/null 2>&1; then
    echo "K3s server is ready!"
    echo ""
    echo "=========================================="
    echo "Kubernetes cluster is running!"
    echo "=========================================="
    $HOME/.local/bin/k3s kubectl get nodes
    echo ""
    echo "Kubeconfig: $HOME/.kube/config"
    echo "To use: export KUBECONFIG=$HOME/.kube/config"
    echo "Or use: kubectl get nodes"
    echo ""
    exit 0
  fi
  if ! kill -0 $K3S_PID 2>/dev/null; then
    echo "ERROR: K3s server process died!"
    echo "Last 30 lines of log:"
    tail -30 $HOME/.k3s/server.log
    exit 1
  fi
  sleep 2
done

echo "ERROR: K3s server did not become ready in time"
tail -30 $HOME/.k3s/server.log
exit 1
