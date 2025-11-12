from spack.package import *

class CteHermesShm(CMakePackage):
    """DEPRECATED: This package has been merged into iowarp-core.
    Please use 'iowarp-core' or 'iowarp' instead.
    The cte-hermes-shm repository is now part of the unified core repository
    at https://github.com/iowarp/core as 'context-transport-primitives'."""
    
    homepage = "https://github.com/lukemartinlogan/cte-hermes-shm/wiki"
    git = "https://github.com/iowarp/cte-hermes-shm.git"
    
    # Branch versions
    version('main', branch='main', preferred=True)
    version('dev', branch='dev')
    
    # Main variants
    variant('debug', default=False, description='Build shared libraries')
    variant('mochi', default=False, description='Build with mochi-thallium support')
    variant('cereal', default=True, description='Build with cereal support')
    variant('boost', default=True, description='Build with boost support')
    variant('mpiio', default=True, description='Build with MPI support')
    variant('vfd', default=False, description='Build with HDF5 support')
    variant('zmq', default=True, description='Build ZeroMQ tests')
    variant('elf', default=False, description='Build elf toolkit')

    # Required deps
    depends_on('iowarp-base')
    depends_on('iowarp-base+vfd', when='+vfd')
    depends_on('iowarp-base+compress', when='+compress')
    depends_on('iowarp-base+encrypt', when='+encrypt')
    depends_on('iowarp-base+cuda', when='+cuda')
    depends_on('iowarp-base+rocm', when='+rocm')
    depends_on('iowarp-base+mochi', when='+mochi')
    depends_on('iowarp-base+ares', when='+ares')
    depends_on('iowarp-base+elf', when='+elf')
    depends_on('iowarp-base+mpi', when='+mpiio')

    # Machine variants
    variant('ares', default=False, description='Build in ares')

    # Additional variants
    variant('compress', default=False, description='Build with compression support')
    variant('encrypt', default=False, description='Build with encryption support')
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")

    # Direct dependencies (non-external packages)
    depends_on('py-ppi-jarvis-cd', type=('build')) 

    def cmake_args(self):
        args = []
        # args.append(self.define('BUILD_HSHM_TESTS', 'OFF'))
        if '+debug' in self.spec:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Debug'))
        if '+vfd' in self.spec:
            args.append(self.define('HSHM_ENABLE_VFD', 'ON'))
        if '+compress' in self.spec:
            args.append(self.define('HSHM_ENABLE_COMPRESS', 'ON'))
        if '+encrypt' in self.spec:
            args.append(self.define('HSHM_ENABLE_ENCRYPT', 'ON'))
        if '+mochi' in self.spec:
            args.append(self.define('HSHM_RPC_THALLIUM', 'ON'))
        if '+zmq' in self.spec:
            args.append(self.define('HSHM_ENABLE_ZMQ_TESTS', 'ON'))
        if '+elf' in self.spec:
            args.append(self.define('HSHM_ENABLE_ELF', 'ON'))
        if "+cuda" in self.spec:
            args.append(self.define("HSHM_ENABLE_CUDA", "ON"))
        if "+rocm" in self.spec:
            args.append(self.define("HSHM_ENABLE_ROCM", "ON"))
        args.append(self.define("HSHM_BUILD_TESTS", "OFF"))
        args.append(self.define("HSHM_BUILD_BENCHMARKS", "OFF"))
        return args

    def setup_run_environment(self, env):
        env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
        env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
