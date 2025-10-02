# Install

## IOWARP
```
spack install iowarp +mpiio +vfd +python
```

## IOWARP-VIZ
```
export IOWARP=${HOME}/iowarp
mkdir -p iowarp
cd $IOWARP
git clone https://github.com/iowarp/iowarp-viz.git

spack load iowarp
cd ${IOWARP}/iowarp-viz
pip install -e .
```

## ADIOS2

```
spack load iowarp

scspkg create adios2
cd $(scspkg pkg src adios2)
git clone https://github.com/ornladios/ADIOS2.git
cd ADIOS2
mkdir build
cd build
cmake ../ \
-DCMAKE_INSTALL_PREFIX=$(scspkg pkg root adios2) \
-DCMAKE_CXX_COMPILER=g++ \
-DCMAKE_C_COMPILER=gcc \
-DADIOS2_USE_SST=OFF \
-DBUILD_DOCS=ON \
-DBUILD_TESTING=ON \
-DADIOS2_BUILD_EXAMPLES=ON \
-DADIOS2_USE_MPI=ON \
-DADIOS2_USE_Derived_Variable=ON
make -j32 install
```

Add adios2 to spack:
```
nano ~/.spack/packages.yaml
```

```
packages:
  adios2:
    externals:
    - spec: adios2@2.9.0
      prefix: /home/llogan/.scspkg/packages/adios2
```

## COEUS
```
spack load iowarp
module load adios2

scspkg create coeus
cd $(scspkg pkg src coeus)
git clone https://github.com/lukemartinlogan/coeus-adapter.git --recurse-submodules
cd coeus-adapter
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$(scspkg pkg root coeus)
make -j32 install
```

## LAMMPS
```
spack install lammps^adios2@2.9.0^mpi
```

# Jarvis

```
spack load iowarp lammps
module load adios2 coeus
jarvis env build iowarp
cd ${IOWARP}/iowarp-install/demos/lammps
jarvis ppl load yaml lammps.yaml
jarvis ppl run
```

# SSH Config notes
```
Host ares
  HostName ares.cs.iit.edu
  User USER 
Host ares-comp
    HostName ares-comp-NODE
    User USER
    ProxyJump ares
```

```
ssh -L 9001:localhost:9001 ares-comp
```

You can now view the iowarp vizualizer [here](http://localhost:9001)