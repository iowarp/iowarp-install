#!/bin/bash
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST"
echo "Allocated nodes:"
scontrol show hostnames $SLURM_JOB_NODELIST
sleep infinity
