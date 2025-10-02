# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class PyPpiJarvisCd(PythonPackage):
    homepage = "grc.iit.edu/docs/jarvis/ppi-jarvis-cd/index"
    git      = "https://github.com/iowarp/ppi-jarvis-cd.git"

    import_modules = ['typing']

    version('main', branch='main', preferred=True)
    version('dev', branch='dev')

    depends_on('python@3:', type=('build', 'run'))
    depends_on('py-setuptools', type=('build', 'run'))
    depends_on('py-pip', type=('build', 'run'))
    depends_on('py-pandas', type=('build', 'run'))
    depends_on('py-pyyaml', type=('build', 'run'))
    depends_on('py-ppi-jarvis-util', type=('build', 'run'))
    depends_on('ppi-chi-nettest', type=('build', 'run'))
    depends_on('py-ppi-jarvis-util@priv', type=('build', 'run'), when='@priv')
    depends_on('py-ppi-scspkg', type=('build', 'run'))
    depends_on('iowarp-base')

