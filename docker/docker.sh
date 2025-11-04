#!/bin/bash
docker build --no-cache -t iowarp-base -f iowarp-base.Dockerfile .
docker tag iowarp-base iowarp/iowarp-base:latest
# docker push iowarp/iowarp-base:latest

docker build --no-cache -t iowarp-deps -f iowarp-deps.Dockerfile .
docker tag iowarp-deps iowarp/iowarp-deps:latest
# docker push iowarp/iowarp-deps:latest

docker build --no-cache -t ppi-jarvis-cd -f ppi-jarvis-cd.Dockerfile .
docker tag ppi-jarvis-cd iowarp/ppi-jarvis-cd:latest
# docker push iowarp/ppi-jarvis-cd:latest

docker build --no-cache -t cte-hermes-shm -f cte-hermes-shm.Dockerfile .
docker tag cte-hermes-shm iowarp/cte-hermes-shm:latest
# docker push iowarp/cte-hermes-shm:latest

docker build --no-cache -t iowarp-runtime -f iowarp-runtime.Dockerfile .
docker tag iowarp-runtime iowarp/iowarp-runtime:latest
# docker push iowarp/iowarp-runtime:latest

docker build --no-cache -t iowarp-cte -f iowarp-cte.Dockerfile .
docker tag iowarp-cte iowarp/iowarp-cte:latest
# docker push iowarp/iowarp-cte:latest

docker build --no-cache -t iowarp -f iowarp.Dockerfile .
docker tag iowarp iowarp/iowarp:latest
# docker push iowarp/iowarp:latest
