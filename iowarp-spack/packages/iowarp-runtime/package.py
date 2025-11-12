from spack.package import *

class IowarpRuntime(CMakePackage):
    """DEPRECATED: This package has been merged into iowarp-core.
    Please use 'iowarp-core' or 'iowarp' instead.
    The runtime (Chimaera) is now part of the unified core repository
    at https://github.com/iowarp/core."""
    
    homepage = "http://www.cs.iit.edu/~scs/assets/projects/Hermes/Hermes.html"
    git = "https://github.com/iowarp/iowarp-runtime.git"

    version('main',
            branch='main', submodules=True, preferred=True)
    version('dev',
            branch='dev', submodules=True)

    # Common variants
    variant('debug', default=False, description='Build shared libraries')
    variant('ares', default=False, description='Enable full libfabric install')
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")

    depends_on('iowarp-base')
    depends_on('iowarp-base+cuda', when='+cuda')
    depends_on('iowarp-base+rocm', when='+rocm')

    depends_on('cte-hermes-shm')
    depends_on('cte-hermes-shm@main', when='@main')
    depends_on('cte-hermes-shm@dev', when='@dev')
    depends_on('cte-hermes-shm@priv', when='@priv')
    depends_on('cte-hermes-shm+compress')
    depends_on('cte-hermes-shm+encrypt')
    depends_on('cte-hermes-shm+elf')
    depends_on('cte-hermes-shm+debug', when='+debug')
    depends_on('cte-hermes-shm+cereal')
    depends_on('cte-hermes-shm+boost')
    depends_on('cte-hermes-shm+ares', when='+ares')
    depends_on('cte-hermes-shm+zmq')
    depends_on('cte-hermes-shm+cuda', when="+cuda")
    depends_on('cte-hermes-shm+rocm', when="+rocm")
    depends_on('py-ppi-jarvis-cd', type=('build'))

    def cmake_args(self):
        args = []
        if '+debug' in self.spec:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Debug'))
        else:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Release'))
        if "+cuda" in self.spec:
            args.append(self.define("CHIMAERA_ENABLE_CUDA", "ON"))
        if "+rocm" in self.spec:
            args.append(self.define("CHIMAERA_ENABLE_CUDA", "ON"))
        return args

    def setup_run_environment(self, env):
        # This is for the interceptors
        env.prepend_path('LD_LIBRARY_PATH', self.prefix.lib)
        env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
        env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
