docker build --no-cache -t iowarp-base docker -f docker/iowarp-base.Dockerfile
docker tag iowarp-base iowarp/iowarp-base:latest
# docker push iowarp/iowarp-base:latest
docker build --no-cache -t iowarp-deps docker -f docker/iowarp-deps.Dockerfile
docker tag iowarp-deps iowarp/iowarp-deps:latest
# docker push iowarp/iowarp-deps:latest
docker build --no-cache -t iowarp-ext-dev docker -f docker/iowarp-ext-dev.Dockerfile
docker tag iowarp-ext-dev iowarp/iowarp-ext-dev:latest
# docker push iowarp/iowarp-ext-dev:latest
docker build --no-cache -t iowarp-user docker -f docker/iowarp-user.Dockerfile
docker tag iowarp-user iowarp/iowarp-user:latest
# docker push iowarp/iowarp-user:latest
