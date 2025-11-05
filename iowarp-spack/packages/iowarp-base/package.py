# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class IowarpBase(Package):
    """This is a backport of the standard library typing module to Python
    versions older than 3.6."""

    homepage = "grc.iit.edu/docs/jarvis/jarvis-util/index"
    git      = "https://github.com/iowarp/ppi-jarvis-util.git"

    version('main', branch='main', preferred=True)
    phases = []

    # Variants that affect package selections
    variant("vfd", default=True, description="Enable HDF5 VFD")
    variant("encrypt", default=True, description="Include encryption libraries")
    variant("compress", default=True, description="Include compression libraries")
    variant("ares", default=False, description="Enable full libfabric install")
    variant("mochi", default=False, description="Build with mochi-thallium support")
    variant("elf", default=True, description="Build elf toolkit")
    variant("adios2", default=True, description="Build with ADIOS2 support")
    variant("mpi", default=True, description="Build with MPI support")
    variant("cuda", default=False, description="Enable CUDA support")
    variant("rocm", default=False, description="Enable ROCm support")

    depends_on('cmake@3.25:')
    depends_on('catch2@3.0.1')
    depends_on('yaml-cpp')
    depends_on('doxygen')
    depends_on('cereal')
    depends_on('boost@1.7: +context +fiber +coroutine +regex +system +filesystem +serialization +pic +math')
    depends_on('libzmq')

    # Conditional core dependencies
    depends_on('libelf', when='+elf')
    depends_on('mpi', when='+mpi')
    depends_on('hdf5', when='+vfd')
    depends_on('adios2', when='+adios2')

    # Ares variant (libfabric)
    depends_on('libfabric fabrics=sockets,tcp,udp,verbs,mlx,rxm,rxd,shm', when='+ares')

    # Mochi variant
    depends_on('mochi-thallium+cereal', when='+mochi')
    depends_on('argobots@1.1+affinity', when='+mochi')

    # Compression libraries (conditional on +compress)
    depends_on('lzo', when='+compress')
    depends_on('bzip2', when='+compress')
    depends_on('zstd', when='+compress')
    depends_on('lz4', when='+compress')
    depends_on('zlib', when='+compress')
    depends_on('xz', when='+compress')
    depends_on('brotli', when='+compress')
    depends_on('snappy', when='+compress')
    depends_on('c-blosc2', when='+compress')

    # Encryption libraries (conditional on +encrypt)
    depends_on('openssl', when='+encrypt')

    # GPU support (conditional)
    depends_on('cuda', when='+cuda')
    depends_on('rocm-core', when='+rocm')

    depends_on('python')
    depends_on('py-pip')
    depends_on('py-setuptools')
    depends_on('py-pandas')
    depends_on('py-pyyaml')
    # depends_on('gh')

