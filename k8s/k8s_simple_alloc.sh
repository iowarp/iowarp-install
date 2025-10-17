#!/bin/bash
#SBATCH -N 4
#SBATCH --exclusive
#SBATCH -J k8s-cluster
#SBATCH -t 8:00:00

echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST"
echo "Nodes allocated:"
scontrol show hostnames $SLURM_JOB_NODELIST

# Keep allocation alive
sleep 28800  # 8 hours
