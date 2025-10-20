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

    depends_on('cmake@3.25:')
    depends_on('catch2@3.0.1')
    depends_on('yaml-cpp')
    depends_on('doxygen')
    depends_on('libelf')
    depends_on('cereal')
    depends_on('boost')
    depends_on('mpi')
    depends_on('hdf5')
    depends_on('libzmq')
    depends_on('adios2')
    depends_on('python')
    depends_on('py-pip')
    depends_on('lzo')
    depends_on('bzip2')
    depends_on('zstd')
    depends_on('lz4')
    depends_on('zlib')
    depends_on('xz')
    depends_on('brotli')
    depends_on('snappy')
    depends_on('c-blosc2')
    depends_on('openssl')
    # depends_on('cuda')
    # depends_on('rocm-core')
    depends_on('py-setuptools')
    depends_on('py-pandas')
    depends_on('py-pyyaml')
    # depends_on('gh')

