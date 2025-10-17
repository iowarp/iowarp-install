#!/bin/bash
# Maintain SLURM allocation and print node information

echo "SLURM Job ID: $SLURM_JOB_ID"
echo "Allocated nodes: $SLURM_JOB_NODELIST"
echo "Number of nodes: $SLURM_JOB_NUM_NODES"

# Expand the node list
scontrol show hostnames $SLURM_JOB_NODELIST

# Create a file with the job ID and node list for reference
echo "SLURM_JOB_ID=$SLURM_JOB_ID" > /mnt/common/hyoklee/k8s_cluster_info.txt
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST" >> /mnt/common/hyoklee/k8s_cluster_info.txt
echo "NODES=$(scontrol show hostnames $SLURM_JOB_NODELIST | tr '\n' ' ')" >> /mnt/common/hyoklee/k8s_cluster_info.txt

echo "Allocation ready. Press Ctrl+C or run 'scancel $SLURM_JOB_ID' to release."

# Keep the allocation alive
sleep infinity
