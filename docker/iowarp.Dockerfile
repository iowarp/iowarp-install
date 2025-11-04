FROM iowarp/iowarp-cte:latest
LABEL maintainer="llogan@hawk.iit.edu"
LABEL version="0.0"
LABEL description="IOWarp complete Docker image"

# Disable prompt during packages installation.
ARG DEBIAN_FRONTEND=noninteractive
