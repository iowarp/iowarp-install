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
    # depends_on('gh')
