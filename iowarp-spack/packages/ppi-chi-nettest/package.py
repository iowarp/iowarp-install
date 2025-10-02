from spack.package import *

class PpiChiNettest(CMakePackage):
    homepage = "https://github.com/iowarp/ppi-chi-nettest.git"
    git = "https://github.com/iowarp/ppi-chi-nettest.git"
    version('main', branch='main', submodules=True, preferred=True)
    version('dev', branch='dev')
    
    # Required deps
    # depends_on('cte-hermes-shm@2: +mochi -nocompile', type=('build'))
    depends_on('catch2@3.0.1')
    depends_on('yaml-cpp')
    depends_on('doxygen')
    depends_on('mochi-thallium+cereal')
    depends_on('argobots@1.1+affinity')
    depends_on('cereal')
    depends_on('iowarp-base')
    depends_on('mpi')

    def cmake_args(self):
        args = []
        return args
