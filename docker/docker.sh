#!/bin/bash
docker build --no-cache -t iowarp/iowarp-base -f iowarp-base.Dockerfile .
# docker push iowarp/iowarp-base:latest

docker build --no-cache -t iowarp/iowarp-deps:latest -f iowarp-deps.Dockerfile . 
# docker push iowarp/iowarp-deps:latest

docker build --no-cache -t iowarp/iowarp:latest -f iowarp.Dockerfile . 
# docker push iowarp/iowarp:latest
