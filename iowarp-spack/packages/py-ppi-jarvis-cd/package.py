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

    depends_on('iowarp-base')

