#!/bin/bash
docker build --no-cache -t iowarp-base -f iowarp-base.Dockerfile .
docker tag iowarp-base iowarp/iowarp-base:latest
# docker push iowarp/iowarp-base:latest
docker build --no-cache -t iowarp-deps -f iowarp-deps.Dockerfile .
docker tag iowarp-deps iowarp/iowarp-deps:latest
# docker push iowarp/iowarp-deps:latest
docker build --no-cache -t iowarp -f iowarp.Dockerfile .
docker tag iowarp iowarp/iowarp:latest
# docker push iowarp/iowarp:latest
