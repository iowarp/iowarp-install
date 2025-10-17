#!/bin/bash
#SBATCH -N 4
#SBATCH --exclusive
#SBATCH -J k8s-cluster
#SBATCH -t 8:00:00
#SBATCH -o /mnt/common/hyoklee/k8s_allocation_%j.out
#SBATCH -e /mnt/common/hyoklee/k8s_allocation_%j.err

echo "================================================"
echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Allocated nodes: $SLURM_JOB_NODELIST"
echo "Number of nodes: $SLURM_JOB_NUM_NODES"
echo "================================================"

# Expand the node list
echo "Individual nodes:"
scontrol show hostnames $SLURM_JOB_NODELIST

# Create a file with the job ID and node list for reference
echo "SLURM_JOB_ID=$SLURM_JOB_ID" > /mnt/common/hyoklee/k8s_cluster_active.txt
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST" >> /mnt/common/hyoklee/k8s_cluster_active.txt
NODES=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ' ')
echo "NODES=$NODES" >> /mnt/common/hyoklee/k8s_cluster_active.txt

# Get the master node (first node)
MASTER_NODE=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
echo "MASTER_NODE=$MASTER_NODE" >> /mnt/common/hyoklee/k8s_cluster_active.txt

# Get worker nodes (remaining nodes)
WORKER_NODES=$(scontrol show hostnames $SLURM_JOB_NODELIST | tail -n +2 | tr '\n' ' ')
echo "WORKER_NODES=$WORKER_NODES" >> /mnt/common/hyoklee/k8s_cluster_active.txt

echo ""
echo "Allocation is ready!"
echo "Master node: $MASTER_NODE"
echo "Worker nodes: $WORKER_NODES"
echo ""
echo "You can now set up Kubernetes on these nodes."
echo "To release this allocation, run: scancel $SLURM_JOB_ID"
echo ""

# Create a marker file to indicate allocation is ready
touch /mnt/common/hyoklee/k8s_allocation_ready

# Keep the allocation alive - wait for a signal file to be created to terminate
echo "Waiting for termination signal..."
while [ ! -f /mnt/common/hyoklee/k8s_terminate_allocation ]; do
    sleep 10
done

echo "Termination signal received. Cleaning up..."
rm -f /mnt/common/hyoklee/k8s_allocation_ready
rm -f /mnt/common/hyoklee/k8s_terminate_allocation
rm -f /mnt/common/hyoklee/k8s_cluster_active.txt
