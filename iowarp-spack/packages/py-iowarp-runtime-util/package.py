# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class PyIowarpRuntimeUtil(PythonPackage):
    homepage = "grc.iit.edu/docs/jarvis/ppi-jarvis-cd/index"
    git      = "https://github.com/iowarp/iowarp-runtime-util.git"

    import_modules = ['typing']

    version('main', branch='main', preferred=True)
    version('dev', branch='dev')

    depends_on('python@3:', type=('build', 'run'))
    depends_on('py-setuptools', type=('build', 'run'))
    depends_on('py-pip', type=('build', 'run'))
    depends_on('py-pyyaml', type=('build', 'run'))
    depends_on('py-ppi-jarvis-util', type=('build'))
    depends_on('py-ppi-jarvis-util@priv', type=('build'), when='@priv')
    depends_on('iowarp-base')

