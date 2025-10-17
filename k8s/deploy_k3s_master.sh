#!/bin/bash
# Deploy k3s master on compute node

# Clean up any existing k3s processes
pkill -9 k3s 2>/dev/null || true
sleep 2

# Set up directories and runtime environment
export K3S_DATA_DIR=$HOME/.k3s/data
export K3S_CONFIG_DIR=$HOME/.k3s/config
export XDG_RUNTIME_DIR=$HOME/.k3s/runtime
mkdir -p $K3S_DATA_DIR $K3S_CONFIG_DIR $HOME/.kube $XDG_RUNTIME_DIR

# Remove old data to start fresh
rm -rf $K3S_DATA_DIR/* $K3S_CONFIG_DIR/*

# Get the node's primary IP
NODE_IP=$(hostname -I | awk '{print $1}')
echo "Node: $(hostname)"
echo "Node IP: $NODE_IP"

# Start k3s server in rootless mode with cgroups disabled
echo "Starting k3s server..."
nohup $HOME/.local/bin/k3s server \
  --data-dir=$K3S_DATA_DIR \
  --write-kubeconfig=$HOME/.kube/config \
  --write-kubeconfig-mode=644 \
  --disable=traefik \
  --disable=servicelb \
  --rootless \
  --node-ip=$NODE_IP \
  --snapshotter=native \
  --kube-controller-manager-arg=controllers=*,-nodeipam,-nodelifecycle,-persistentvolume-binder,-attachdetach,-persistentvolume-expander,-cloud-node-lifecycle,-ttl \
  --kubelet-arg=fail-swap-on=false \
  --kubelet-arg=cgroup-driver=none \
  > $HOME/.k3s/server.log 2>&1 &

K3S_PID=$!
echo "$K3S_PID" > $HOME/.k3s/server.pid
echo "K3s server started with PID $K3S_PID"

# Wait for server to be ready
echo "Waiting for k3s server to be ready..."
READY=0
for i in {1..90}; do
  if $HOME/.local/bin/k3s kubectl get nodes >/dev/null 2>&1; then
    echo "K3s server is ready!"
    $HOME/.local/bin/k3s kubectl get nodes
    READY=1
    break
  fi
  if ! kill -0 $K3S_PID 2>/dev/null; then
    echo "ERROR: K3s server process died!"
    echo "Last 30 lines of log:"
    tail -30 $HOME/.k3s/server.log
    exit 1
  fi
  echo "Waiting... ($i/90)"
  sleep 3
done

if [ $READY -eq 0 ]; then
  echo "ERROR: K3s server did not become ready in time"
  echo "Last 30 lines of log:"
  tail -30 $HOME/.k3s/server.log
  exit 1
fi

# Wait a bit more for token to be generated
sleep 5

# Get and display the node token
if [ -f "$K3S_DATA_DIR/server/node-token" ]; then
  TOKEN=$(cat $K3S_DATA_DIR/server/node-token)
  echo "====================================="
  echo "Master node setup complete!"
  echo "Node IP: $NODE_IP"
  echo "Node Token: $TOKEN"
  echo "====================================="

  # Save token to shared location
  echo "$TOKEN" > /mnt/common/hyoklee/k3s_node_token.txt
  echo "$NODE_IP" > /mnt/common/hyoklee/k3s_master_ip.txt
  echo "Token and IP saved to /mnt/common/hyoklee/"
else
  echo "ERROR: Node token not found!"
  echo "Searching for token files:"
  find $K3S_DATA_DIR -name "*token*" -type f 2>/dev/null
  exit 1
fi

# Keep the server running
echo "K3s master is running. Keeping process alive..."
wait $K3S_PID
