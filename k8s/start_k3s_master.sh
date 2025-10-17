#!/bin/bash
# Start k3s server in rootless mode on master node

export K3S_DATA_DIR=$HOME/.k3s/data
export K3S_CONFIG_DIR=$HOME/.k3s/config
mkdir -p $K3S_DATA_DIR $K3S_CONFIG_DIR

# Get the node's IP address
NODE_IP=$(hostname -I | awk '{print $1}')

echo "Starting k3s server on $NODE_IP..."

# Start k3s server without root
nohup $HOME/.local/bin/k3s server \
  --data-dir=$K3S_DATA_DIR \
  --node-ip=$NODE_IP \
  --bind-address=$NODE_IP \
  --advertise-address=$NODE_IP \
  --write-kubeconfig=$HOME/.kube/config \
  --write-kubeconfig-mode=644 \
  --disable=traefik \
  --disable=servicelb \
  --rootless \
  > $HOME/.k3s/server.log 2>&1 &

echo "K3S_PID=$!" > $HOME/.k3s/server.pid
echo "K3s server started with PID $(cat $HOME/.k3s/server.pid)"
echo "Node IP: $NODE_IP"

# Wait for server to be ready
echo "Waiting for k3s server to be ready..."
for i in {1..60}; do
  if $HOME/.local/bin/k3s kubectl get nodes >/dev/null 2>&1; then
    echo "K3s server is ready!"
    $HOME/.local/bin/k3s kubectl get nodes
    break
  fi
  echo "Waiting... ($i/60)"
  sleep 2
done

# Save the node token for workers
mkdir -p $HOME/.k3s/
if [ -f "$K3S_DATA_DIR/server/node-token" ]; then
  cp $K3S_DATA_DIR/server/node-token $HOME/.k3s/node-token
  echo "Node token saved to $HOME/.k3s/node-token"
else
  echo "Warning: Node token not found yet"
fi

echo "Master node setup complete!"
echo "Node IP: $NODE_IP"
