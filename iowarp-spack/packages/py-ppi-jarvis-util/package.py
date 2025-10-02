# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class PyPpiJarvisUtil(PythonPackage):
    """This is a backport of the standard library typing module to Python
    versions older than 3.6."""

    homepage = "grc.iit.edu/docs/jarvis/jarvis-util/index"
    git      = "https://github.com/iowarp/ppi-jarvis-util.git"

    version('main', branch='main', preferred=True)
    version('dev', branch='dev')

    depends_on('python@3:', type=('build', 'run'))
    depends_on('py-setuptools', type=('build', 'run'))
    depends_on('py-pip', type=('build', 'run'))
    depends_on('py-pyyaml', type=('build', 'run'))
    depends_on('py-tabulate', type=('build', 'run'))
    depends_on('iowarp-base')
