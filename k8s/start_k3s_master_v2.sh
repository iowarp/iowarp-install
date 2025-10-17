#!/bin/bash
# Start k3s server in rootless mode on master node

# Kill any existing k3s processes
pkill -9 k3s 2>/dev/null || true
sleep 2

export K3S_DATA_DIR=$HOME/.k3s/data
export K3S_CONFIG_DIR=$HOME/.k3s/config
mkdir -p $K3S_DATA_DIR $K3S_CONFIG_DIR $HOME/.kube

# Get the node's IP address
NODE_IP=$(hostname -I | awk '{print $1}')

echo "Starting k3s server..."
echo "Node IP: $NODE_IP"

# Start k3s server without root - bind to all interfaces
nohup $HOME/.local/bin/k3s server \
  --data-dir=$K3S_DATA_DIR \
  --write-kubeconfig=$HOME/.kube/config \
  --write-kubeconfig-mode=644 \
  --disable=traefik \
  --disable=servicelb \
  --rootless \
  > $HOME/.k3s/server.log 2>&1 &

K3S_PID=$!
echo "$K3S_PID" > $HOME/.k3s/server.pid
echo "K3s server started with PID $K3S_PID"

# Wait for server to be ready
echo "Waiting for k3s server to be ready..."
for i in {1..60}; do
  if $HOME/.local/bin/k3s kubectl get nodes >/dev/null 2>&1; then
    echo "K3s server is ready!"
    $HOME/.local/bin/k3s kubectl get nodes
    break
  fi
  if ! kill -0 $K3S_PID 2>/dev/null; then
    echo "ERROR: K3s server process died!"
    tail -20 $HOME/.k3s/server.log
    exit 1
  fi
  sleep 2
done

# Save the node token for workers
sleep 3
if [ -f "$K3S_DATA_DIR/server/node-token" ]; then
  cp $K3S_DATA_DIR/server/node-token $HOME/.k3s/node-token
  echo "Node token saved to $HOME/.k3s/node-token"
  echo "TOKEN: $(cat $HOME/.k3s/node-token)"
else
  echo "Warning: Node token not found at $K3S_DATA_DIR/server/node-token"
  find $K3S_DATA_DIR -name "*token*" -type f 2>/dev/null
fi

echo "Master node setup complete!"
