#!/bin/bash
docker build --no-cache -t iowarp/iowarp-base -f iowarp-base.Dockerfile .
# docker push iowarp/iowarp-base:latest

docker build --no-cache -t iowarp/iowarp-deps:latest -f iowarp-deps.Dockerfile . 
# docker push iowarp/iowarp-deps:latest

# Build the minimal base image for deployment containers
docker build --no-cache -t iowarp/iowarp-base-minimal:latest -f iowarp-base-minimal.Dockerfile .
# docker push iowarp/iowarp-base-minimal:latest
