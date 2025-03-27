# Install IOWarp

## conda

1. Install Miniconda.
2. `$ source ~/miniconda3/bin/activate`
3. `$ conda install hyoklee::iowarp`

## docker

1. `$ docker pull iowarp/iowarp-user`
2. `$ docker run -it iowarp/iowarp-user`

## snap

1. Install `snapd`.
2. Run `sudo snap install iowarp`.

## spack

1. Install `spack`.
2. `$ spack repo add iowarp-spack`
3. `$ spack install iowarp`

## vcpkg

1. Install `git`.
2. `$ git clone https://github.com/iowarp/iowarp-install`
3. Run `$ ./install.sh`.

# Continuous Integration

| Test    | Status |
| --------| ------ |
| Windows 2022 | [![win](https://github.com/iowarp/iowarp-install/actions/workflows/win.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/win.yml) |
| Ubuntu 24.04 |[![lin](https://github.com/iowarp/iowarp-install/actions/workflows/lin.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/lin.yml) [![conda](https://github.com/iowarp/iowarp-install/actions/workflows/lin-cnd.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/lin-cnd.yml) [![spack](https://github.com/iowarp/iowarp-install/actions/workflows/spack.yml/badge.svg)](https://github.com/iowarp/iowarp-install/actions/workflows/spack.yml) |
