docker build --no-cache -t iowarp-base docker -f docker/iowarp-base.Dockerfile
docker tag iowarp-base iowarp/iowarp-base:latest
# docker push iowarp/iowarp-base:latest
docker build --no-cache -t iowarp-deps docker -f docker/iowarp-deps.Dockerfile
docker tag iowarp-deps iowarp/iowarp-deps:latest
# docker push iowarp/iowarp-deps:latest
docker build --no-cache -t iowarp docker -f docker/iowarp.Dockerfile
docker tag iowarp iowarp/iowarp:latest
# docker push iowarp/iowarp:latest
